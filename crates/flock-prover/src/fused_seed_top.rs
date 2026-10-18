//! Witness-overlapped seed+top NTT pass for the ranked BLAKE3 commit.
//!
//! The commit's rate-1/2 seed+top fused pass (NTT layers 1..9) is 2048 tasks;
//! task `r` reads message positions `r + k·S + i·B` (`k < 64`, `i < 4`, `S =
//! 2^11`, `B = 2^17`), i.e. the 256 witness blocks `⌊r/2⌋ + 1024·t`. Witness
//! generation normally runs those blocks in index order, so no task is ready
//! before the whole witness exists. Here the 16-block witness groups are
//! handed out family-major instead — family `f` is the 256 groups
//! `g ≡ f (mod 64)` — so family `f` completes after 1/64 of the witness and
//! its 32 tasks (`r ∈ [32f, 32f + 32)`) run while the rest of the witness is
//! still being built. Both kinds of work share one `rayon::broadcast`; on a
//! machine whose pool covers whole SMT pairs, one sibling of each core prefers
//! the seed tasks (CLMUL-bound) and the other the witness groups
//! (dispatch-bound), the same producer/consumer pairing the deep pass uses.
//!
//! Every byte written is the same as on the sequential schedule: witness
//! groups write their own disjoint regions in any order, and each seed task
//! writes its own disjoint codeword rows from inputs that are complete and
//! published (per-group `sfence` + release counter, acquire before the task).
//! `FLOCK_NO_FUSED_SEED_TOP=1` restores the sequential schedule.

use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};

use flock_core::field::F128;
use flock_core::ntt::additive_ntt_f128::{self as antt, AdditiveNttF128, SeedTopScheduler};

/// Default ON; `FLOCK_NO_FUSED_SEED_TOP=1` restores the sequential schedule.
pub(crate) fn fused_seed_top_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_FUSED_SEED_TOP").is_none());
    *ON
}

/// Witness groups at the ranked shape: 2^18 blocks in groups of 16.
pub(crate) const RANKED_GROUPS: usize = 1 << 14;
const FAMILIES: usize = 64;
const GROUPS_PER_FAMILY: usize = RANKED_GROUPS / FAMILIES;
const RANKED_TASKS: usize = 2048;
const TASKS_PER_FAMILY: usize = RANKED_TASKS / FAMILIES;

/// What the witness generator needs to run the commit's seed+top pass
/// alongside itself: the NTT, the codeword buffer and its lane count.
pub(crate) struct FusedSeedTopInputs<'a> {
    pub ntt: &'a AdditiveNttF128,
    codeword_ptr: usize,
    codeword_len: usize,
    pub num_ntts: usize,
    seeded: AtomicBool,
}

impl<'a> FusedSeedTopInputs<'a> {
    pub fn new(ntt: &'a AdditiveNttF128, codeword: &mut [F128], num_ntts: usize) -> Self {
        Self {
            ntt,
            codeword_ptr: codeword.as_mut_ptr() as usize,
            codeword_len: codeword.len(),
            num_ntts,
            seeded: AtomicBool::new(false),
        }
    }

    /// True once the seed+top pass ran to completion on the codeword.
    pub fn seeded(&self) -> bool {
        self.seeded.load(Ordering::Acquire)
    }
}

/// Run the `n_groups` witness groups (`group_fn(g)`, any order, each exactly
/// once) together with the seed+top tasks. Returns `false` without running
/// anything when the NTT declines the fused pass or the shape is not the
/// ranked one; the caller then runs its ordinary schedule.
///
/// `group_fn` must publish group `g`'s z rows (NT stores drained by an
/// `sfence`) before it returns.
pub(crate) fn run_fused(
    fs: &FusedSeedTopInputs<'_>,
    z_ptr: *const F128,
    z_len: usize,
    n_groups: usize,
    group_fn: &(dyn Fn(usize) + Sync),
) -> bool {
    if n_groups != RANKED_GROUPS || rayon::current_thread_index().is_some() {
        return false;
    }
    let sched = Sched { group_fn };
    // SAFETY: the buffer was handed to `FusedSeedTopInputs::new` as `&mut
    // [F128]` by the caller, who keeps it alive and untouched for the whole
    // witness phase; only the seed tasks write it here.
    let codeword =
        unsafe { std::slice::from_raw_parts_mut(fs.codeword_ptr as *mut F128, fs.codeword_len) };
    // SAFETY: `z_ptr..z_len` is the live witness buffer; the scheduler runs a
    // task only after an acquire on its family's completion count, which
    // follows every writer's `sfence` + release.
    let ok = unsafe {
        fs.ntt
            .seed_top_fused_with_scheduler(z_ptr, z_len, codeword, fs.num_ntts, &sched)
    };
    if ok {
        fs.seeded.store(true, Ordering::Release);
    }
    ok
}

struct Sched<'a> {
    group_fn: &'a (dyn Fn(usize) + Sync),
}

#[repr(align(64))]
struct Counter(AtomicUsize);

impl SeedTopScheduler for Sched<'_> {
    fn run(&self, n_tasks: usize, row_len: usize, task: &(dyn Fn(&mut Vec<F128>, usize) + Sync)) {
        use rayon::prelude::*;
        if n_tasks != RANKED_TASKS {
            // Unexpected geometry: no overlap, still every group then every
            // task exactly once.
            (0..RANKED_GROUPS).into_par_iter().for_each(|g| (self.group_fn)(g));
            (0..n_tasks)
                .into_par_iter()
                .for_each_init(|| antt::seed_top_staging_block(row_len), |buf, r| task(buf, r));
            return;
        }
        let done: Vec<Counter> = (0..FAMILIES).map(|_| Counter(AtomicUsize::new(0))).collect();
        let next_slot = AtomicUsize::new(0);
        let next_task = AtomicUsize::new(0);
        let nthreads = rayon::current_num_threads();
        let pairs = antt::smt_sibling_pairs().filter(|p| p.len() * 2 == nthreads);
        let n_pairs = nthreads / 2;
        let group_fn = self.group_fn;
        let (done, next_slot, next_task) = (&done, &next_slot, &next_task);
        rayon::broadcast(|ctx| {
            let idx = ctx.index();
            let (seed_first, pin) = match pairs {
                Some(p) if idx < n_pairs => (false, Some(p[idx].0)),
                Some(p) => (true, Some(p[idx - n_pairs].1)),
                None => (idx % 2 == 1, None),
            };
            #[cfg(target_os = "linux")]
            let saved = pin.map(|cpu| {
                let m = antt::cpu_mask();
                antt::pin_cpu(cpu);
                m
            });
            #[cfg(not(target_os = "linux"))]
            let _ = pin;
            let mut staging: Option<Vec<F128>> = None;
            let try_witgen = || -> bool {
                let s = next_slot.fetch_add(1, Ordering::Relaxed);
                if s >= RANKED_GROUPS {
                    return false;
                }
                let f = s / GROUPS_PER_FAMILY;
                let j = s % GROUPS_PER_FAMILY;
                group_fn(f + FAMILIES * j);
                done[f].0.fetch_add(1, Ordering::Release);
                true
            };
            let try_seed = |staging: &mut Option<Vec<F128>>| -> bool {
                loop {
                    let r = next_task.load(Ordering::Acquire);
                    if r >= RANKED_TASKS {
                        return false;
                    }
                    if done[r / TASKS_PER_FAMILY].0.load(Ordering::Acquire) < GROUPS_PER_FAMILY {
                        return false;
                    }
                    if next_task
                        .compare_exchange_weak(r, r + 1, Ordering::AcqRel, Ordering::Acquire)
                        .is_ok()
                    {
                        let buf = staging.get_or_insert_with(|| antt::seed_top_staging_block(row_len));
                        task(buf, r);
                        return true;
                    }
                }
            };
            loop {
                let progressed = if seed_first {
                    try_seed(&mut staging) || try_witgen()
                } else {
                    try_witgen() || try_seed(&mut staging)
                };
                if progressed {
                    continue;
                }
                if next_slot.load(Ordering::Relaxed) >= RANKED_GROUPS
                    && next_task.load(Ordering::Acquire) >= RANKED_TASKS
                {
                    break;
                }
                std::hint::spin_loop();
            }
            #[cfg(target_os = "linux")]
            if let Some(m) = saved {
                antt::set_cpu_mask(&m);
            }
        });
        for c in done {
            assert_eq!(c.0.load(Ordering::Acquire), GROUPS_PER_FAMILY, "fused seed+top: witness family incomplete");
        }
        assert_eq!(next_task.load(Ordering::Acquire), RANKED_TASKS);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Every group and every task runs exactly once, and a task never runs
    /// before all 256 groups of its family have finished.
    #[test]
    fn scheduler_orders_tasks_after_their_family() {
        let group_done: Vec<AtomicUsize> = (0..RANKED_GROUPS).map(|_| AtomicUsize::new(0)).collect();
        let task_done: Vec<AtomicUsize> = (0..RANKED_TASKS).map(|_| AtomicUsize::new(0)).collect();
        let violations = AtomicUsize::new(0);
        let group_fn = |g: usize| {
            assert!(g < RANKED_GROUPS);
            group_done[g].fetch_add(1, Ordering::Release);
        };
        let task = |_buf: &mut Vec<F128>, r: usize| {
            let f = r / TASKS_PER_FAMILY;
            for j in 0..GROUPS_PER_FAMILY {
                if group_done[f + FAMILIES * j].load(Ordering::Acquire) != 1 {
                    violations.fetch_add(1, Ordering::Relaxed);
                }
            }
            task_done[r].fetch_add(1, Ordering::Relaxed);
        };
        let sched = Sched { group_fn: &group_fn };
        sched.run(RANKED_TASKS, 64, &task);
        assert!(group_done.iter().all(|c| c.load(Ordering::Relaxed) == 1));
        assert!(task_done.iter().all(|c| c.load(Ordering::Relaxed) == 1));
        assert_eq!(violations.load(Ordering::Relaxed), 0);
    }
}
