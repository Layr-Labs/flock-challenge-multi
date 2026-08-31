//! CPU DVFS/idle keep-alive for the ranked worker's ready→seed gap.
//!
//! # The gap
//!
//! The ranked worker runs an *untimed* warm-up proof, publishes its "ready"
//! file, then waits for the harness to write the timed 64-bit seed to stdin.
//! Across that wait every prover thread is parked in the kernel: the worker
//! main thread blocks reading the seed-pipe forwarding pipe, the seed-pipe
//! thread blocks in the real-stdin `read()` (`seed_pipe::read_line_fd`), and
//! every Rayon pool sits idle. With nothing runnable, `cpuidle` drops the
//! package into a deep C-state and the HWP/`intel_pstate` frequency request
//! decays toward the minimum. The timed window is measured from "seed written"
//! to "proof published", so when the seed lands the first slice of that window
//! pays C-state exit latency on every core the prove immediately fans out to,
//! plus the frequency ramp back to the all-core turbo point the prove actually
//! runs at. Both are scored.
//!
//! On the ranked c7i.4xlarge that gap is entirely avoidable: the harness reads
//! 8 bytes from `/dev/urandom` and writes the seed immediately after
//! readiness, so the idle window is short, predictable, and sits directly in
//! front of a ~0.167 s scored interval.
//!
//! # What this does
//!
//! From the tail of the warm-up ([`keepalive_start`]) until the seed's first
//! byte is read ([`keepalive_stop`]), spawn one light spin thread per logical
//! CPU. Each thread retires a tight loop of **scalar integer** arithmetic on a
//! private register — no SIMD, no CLMUL, no memory traffic. That is enough to
//! keep every core in C0 with its clock request up, while drawing far less
//! power than a real prover kernel would. Scalar is deliberate on x86: a spin
//! built from 512-bit work would hold the AVX-512 frequency license and can
//! pull the all-core ceiling *down* before the timed window, which is the
//! opposite of the intent.
//!
//! # Why it cannot change the proof
//!
//! The spin touches only a per-thread `u64` fed through `std::hint::black_box`.
//! It reads and writes **zero** proof / Fiat-Shamir / witness / commitment
//! state and shares nothing with the prover but the CPU it warms. Proof bytes
//! are identical with the keep-alive on or off, by construction, and that is
//! checked by fingerprint rather than assumed.
//!
//! # Handoff
//!
//! The seed-pipe thread calls [`keepalive_signal`] the instant its stdin
//! `read()` returns — before it parses the seed, forwards it, or starts the
//! speculative prove — and [`keepalive_join`] just before the speculative
//! prove begins. The timed `prove_fast` call also calls [`keepalive_stop`]
//! (idempotently) as a fallback when the seed pipe is disabled. So the timed
//! path never shares a core with a keep-alive thread, and the keep-alive never
//! steals a cycle from real proving.
//!
//! The wait is **not** a pthread join. Every spin thread is spawned detached
//! and reaps itself; completion is tracked by a plain atomic live-count that
//! each thread decrements as its last action. Waiting therefore costs a single
//! load-and-return in the common case (the threads exited while the seed was
//! being parsed), instead of 16 sequential `pthread_join` reaps — tens of
//! microseconds of pure serial time — inside the front of the timed window.
//!
//! # Safety net
//!
//! A hard `MAX_KEEPALIVE` deadline caps how long the spin can run even if the
//! stop is never reached (a caller error, or a pathologically long harness
//! gap). Past the deadline the threads exit on their own, so the spin can
//! never become an unbounded furnace and the worst case degrades back to the
//! baseline deep-idle behavior.
//!
//! Disable the whole mechanism with `FLOCK_NO_CPU_KEEPALIVE=1`. The effect is
//! specific to the ranked x86_64 Linux runner, so on every other target both
//! entry points are no-ops.

/// Start the CPU keep-alive: spawn one light spin thread per logical CPU. Call
/// once, at the tail of the untimed warm-up proof (before the worker publishes
/// "ready" and blocks for the seed).
///
/// No-op off x86_64 Linux, under `FLOCK_NO_CPU_KEEPALIVE=1`, or if already
/// running. The caller is responsible for restricting this to the ranked
/// worker (see the `is_ranked_worker` gate at the call site) so it never fires
/// for tests, benches or examples.
pub fn keepalive_start() {
    #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
    imp::start();
}

/// Stop the keep-alive: signal the spin threads and wait for quiet. Idempotent
/// and safe to call from any thread. Used by the timed `prove_fast` call as a
/// fallback when the seed pipe is disabled.
pub fn keepalive_stop() {
    #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
    imp::stop();
}

/// Signal-only half of [`keepalive_stop`]: clear the run flag so every spin
/// thread starts exiting (they notice within one ~64-op spin slice), but do
/// not wait for them. The seed-pipe thread uses this so the wait happens after
/// the seed is parsed and forwarded rather than before it. Pair with
/// [`keepalive_join`]; calling [`keepalive_stop`] later is also safe.
pub fn keepalive_signal() {
    #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
    imp::signal();
}

/// Join-only half of [`keepalive_stop`]: wait until every spin thread has
/// finished (spawned-detached threads are awaited through the live-count, not
/// joined). Idempotent; a no-op when nothing was started.
pub fn keepalive_join() {
    #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
    imp::join_all();
}

#[cfg(all(target_arch = "x86_64", target_os = "linux"))]
mod imp {
    use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
    use std::time::{Duration, Instant};

    /// Upper bound on how long the keep-alive spins before self-terminating,
    /// independent of [`stop`]. The real ready→seed gap is short (the harness
    /// reads 8 bytes of randomness and writes the seed); this only bounds the
    /// worst case so a missed stop or an abnormally long gap cannot spin the
    /// package indefinitely.
    const MAX_KEEPALIVE: Duration = Duration::from_secs(2);

    /// How long [`join_all`] may wait for the spin threads to notice the stop
    /// signal before giving up and letting the prove proceed anyway. The
    /// threads exit within one ~64-op slice of the signal; the cap only
    /// matters if a thread is descheduled at the worst moment, and even then
    /// the residual overlap risk is identical to a design that never waits.
    const QUIET_TIMEOUT: Duration = Duration::from_micros(250);

    /// Spin slices between deadline checks. `Instant::now()` is a vDSO call;
    /// checking it every slice would dominate the loop and pull the core into
    /// the kernel's clocksource path instead of retiring plain ALU work.
    const SLICES_PER_DEADLINE_CHECK: u32 = 256;

    /// `true` while the spin threads should keep running. Cleared by
    /// [`signal`]; each thread also self-exits past `MAX_KEEPALIVE`.
    static RUNNING: AtomicBool = AtomicBool::new(false);

    /// Spin threads spawned but not yet finished. [`start`] increments before
    /// each spawn (and re-decrements if the spawn fails); each thread
    /// decrements itself as its very last action. This replaces handle-based
    /// joining on the timed path: awaiting quiet costs one load in the common
    /// case instead of 16 sequential `pthread_join` reaps.
    static LIVE: AtomicUsize = AtomicUsize::new(0);

    /// The per-core spin body: proof-irrelevant scalar-integer churn that keeps
    /// the core retiring instructions (so it stays in C0 with its clock request
    /// high) without SIMD/CLMUL power draw or any shared/memory state.
    fn spin_until_stopped(deadline: Instant) {
        // A private splitmix-style dependent chain. Each step depends on the
        // last, so the core cannot fold the loop away or idle its pipeline;
        // `black_box` keeps the optimizer from eliminating the whole thing.
        let mut x: u64 = 0x9E37_79B9_7F4A_7C15;
        let mut slices: u32 = 0;
        while RUNNING.load(Ordering::Relaxed) {
            // A batch of cheap scalar ops between flag checks: frequent enough
            // that stop latency is sub-microsecond, coarse enough that the
            // check itself costs nothing measurable.
            for _ in 0..64 {
                x = x
                    .wrapping_mul(0x2545_F491_4F6C_DD1D)
                    .wrapping_add(0x9E37_79B9_7F4A_7C15);
                x ^= x >> 29;
            }
            std::hint::black_box(x);
            slices = slices.wrapping_add(1);
            if slices.is_multiple_of(SLICES_PER_DEADLINE_CHECK) && Instant::now() >= deadline {
                break;
            }
        }
        std::hint::black_box(x);
        // Detached: this thread reaps itself. Dropping the live count as the
        // last action lets an awaiter observe quiet only after the spin state
        // is fully abandoned.
        LIVE.fetch_sub(1, Ordering::SeqCst);
    }

    /// One spin thread per logical CPU the process may run on. The ranked
    /// worker's cleared environment carries `RAYON_NUM_THREADS`, but the
    /// resource being kept out of a deep C-state is the CPU, not the pool, so
    /// size to the affinity mask and fall back to the pool width.
    fn keepalive_threads() -> usize {
        std::thread::available_parallelism()
            .map(std::num::NonZeroUsize::get)
            .unwrap_or_else(|_| rayon::current_num_threads())
            .max(1)
    }

    pub(super) fn start() {
        if std::env::var_os("FLOCK_NO_CPU_KEEPALIVE").is_some() {
            return;
        }
        // Claim the run: if it was already true, another start is live.
        if RUNNING.swap(true, Ordering::SeqCst) {
            return;
        }
        let deadline = Instant::now() + MAX_KEEPALIVE;
        for i in 0..keepalive_threads() {
            LIVE.fetch_add(1, Ordering::SeqCst);
            match std::thread::Builder::new()
                .name(format!("flock-keepalive-{i}"))
                .stack_size(64 * 1024)
                .spawn(move || spin_until_stopped(deadline))
            {
                // Detached on purpose: dropping the join handle frees the
                // timed path from ever paying a pthread_join. Lifetime is
                // governed by RUNNING / MAX_KEEPALIVE, and quiet by LIVE.
                Ok(_) => {}
                Err(_) => {
                    LIVE.fetch_sub(1, Ordering::SeqCst);
                    break;
                }
            }
        }
    }

    pub(super) fn stop() {
        // Signal first so the threads start winding down before we wait.
        signal();
        join_all();
    }

    /// Clear the run flag without waiting. Threads notice within one spin
    /// slice and exit on their own.
    pub(super) fn signal() {
        RUNNING.swap(false, Ordering::SeqCst);
    }

    /// Wait until every spin thread has finished. All spin threads are spawned
    /// detached, so this is an atomic live-count check, not a join: on the
    /// seed-pipe path the threads have always exited while the seed was being
    /// parsed, making this a single load-and-return. Bounded by
    /// [`QUIET_TIMEOUT`] so a pathologically descheduled thread can never
    /// stall the prove.
    pub(super) fn join_all() {
        if LIVE.load(Ordering::SeqCst) == 0 {
            return;
        }
        let give_up_at = Instant::now() + QUIET_TIMEOUT;
        while LIVE.load(Ordering::SeqCst) != 0 {
            if Instant::now() >= give_up_at {
                return;
            }
            std::hint::spin_loop();
        }
    }

    #[cfg(test)]
    mod tests {
        use super::*;
        use std::sync::Mutex;

        // The module under test is a pair of process-global atomics, so the
        // tests must not interleave even when `cargo test` runs its default
        // parallel harness.
        static TEST_LOCK: Mutex<()> = Mutex::new(());

        /// start → stop leaves nothing running and no live spin threads.
        #[test]
        fn start_then_stop_is_clean() {
            let _guard = TEST_LOCK.lock().unwrap_or_else(|e| e.into_inner());
            start();
            stop();
            assert!(!RUNNING.load(Ordering::SeqCst));
            assert_eq!(LIVE.load(Ordering::SeqCst), 0);
        }

        /// stop with nothing running is inert, and a redundant second stop is
        /// likewise inert (idempotent).
        #[test]
        fn stop_without_start_is_noop() {
            let _guard = TEST_LOCK.lock().unwrap_or_else(|e| e.into_inner());
            stop();
            stop();
            assert!(!RUNNING.load(Ordering::SeqCst));
            assert_eq!(LIVE.load(Ordering::SeqCst), 0);
        }

        /// The kill switch prevents any thread from being spawned.
        #[test]
        fn kill_switch_spawns_nothing() {
            let _guard = TEST_LOCK.lock().unwrap_or_else(|e| e.into_inner());
            // SAFETY: serialized by TEST_LOCK, so no other keep-alive test
            // touches the env concurrently. Restored before return.
            unsafe { std::env::set_var("FLOCK_NO_CPU_KEEPALIVE", "1") };
            start();
            let empty = LIVE.load(Ordering::SeqCst) == 0;
            let stopped = !RUNNING.load(Ordering::SeqCst);
            unsafe { std::env::remove_var("FLOCK_NO_CPU_KEEPALIVE") };
            stop();
            assert!(empty, "kill switch must spawn no keep-alive threads");
            assert!(stopped, "kill switch must leave the run flag clear");
        }

        /// A start/stop cycle followed by a second start works: detached
        /// generations are independent, and quiet is observed after each stop.
        #[test]
        fn restart_after_stop_is_clean() {
            let _guard = TEST_LOCK.lock().unwrap_or_else(|e| e.into_inner());
            start();
            stop();
            start();
            stop();
            assert!(!RUNNING.load(Ordering::SeqCst));
            assert_eq!(LIVE.load(Ordering::SeqCst), 0);
        }

        /// Signal/join split behaves like a stop.
        #[test]
        fn signal_then_join_is_clean() {
            let _guard = TEST_LOCK.lock().unwrap_or_else(|e| e.into_inner());
            start();
            signal();
            join_all();
            assert!(!RUNNING.load(Ordering::SeqCst));
            assert_eq!(LIVE.load(Ordering::SeqCst), 0);
        }
    }
}
