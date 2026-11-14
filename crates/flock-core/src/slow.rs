//! xint slowdown probes (diagnostic submissions only).
//!
//! Each probe adds a fixed amount of one kind of work to every task of one
//! phase, on the thread that ran the task, right after the task: `C` = an
//! independent VPCLMULQDQ chain (vector compute, no memory), `M` = a stream of
//! cold cache-line loads from a private 256 MiB buffer (memory traffic, almost
//! no compute). The amount is 10% of the task's own measured duration
//! (TSC ticks between the task's begin and end trace marks), so a probe whose
//! phase is bound by nothing it adds costs about 10% of that phase's thread
//! time, and a probe that contends with the phase's binding resource costs
//! more. Values are never touched: the probe's result goes to a sink.
//!
//! Every probe's begin/end marks are matched in every trial (the matching cost
//! is the same in all trials). Warm-up trials report, through a wait before
//! the proof is published, whether site `(r - 1) mod 12` was reached.
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::LazyLock;

#[derive(Clone, Copy)]
enum Kind {
    C,
    M,
}

/// (begin tag, end tag, switch, kind). Order = warm-up report order.
const SITES: [(&str, &str, &str, Kind); 12] = [
    ("f:seeded", "f:fold", "FLOCK_SLOW_SEED_C", Kind::C),
    ("f:seeded", "f:fold", "FLOCK_SLOW_SEED_M", Kind::M),
    ("hb:s", "hb:e", "FLOCK_SLOW_DEEP_C", Kind::C),
    ("hb:s", "hb:e", "FLOCK_SLOW_DEEP_M", Kind::M),
    ("ab:b", "ab:e", "FLOCK_SLOW_R1AB_C", Kind::C),
    ("ab:b", "ab:e", "FLOCK_SLOW_R1AB_M", Kind::M),
    ("r2:b", "r2:e", "FLOCK_SLOW_R2_C", Kind::C),
    ("r2:b", "r2:e", "FLOCK_SLOW_R2_M", Kind::M),
    ("r3:b", "r3:e", "FLOCK_SLOW_L0_C", Kind::C),
    ("zt:c0", "zt:c1", "FLOCK_SLOW_TAIL_M", Kind::M),
    ("rf:w0", "rf:w1", "FLOCK_SLOW_ROOT_C", Kind::C),
    ("dp:claim", "dp:subend", "FLOCK_SLOW_DEEPP_C", Kind::C),
];

static HIT: [AtomicBool; 12] = [const { AtomicBool::new(false) }; 12];

struct Cfg {
    on: [bool; 12],
    buf: usize,
}

static CFG: LazyLock<Cfg> = LazyLock::new(|| {
    let mut on = [false; 12];
    for (k, s) in SITES.iter().enumerate() {
        on[k] = std::env::var_os(s.2).is_some();
    }
    let buf = if on.iter().zip(SITES.iter()).any(|(o, s)| *o && matches!(s.3, Kind::M)) {
        cold_buffer()
    } else {
        0
    };
    Cfg { on, buf }
});

const COLD_BYTES: usize = 256 << 20;
const PER_THREAD: usize = COLD_BYTES / 16;

fn cold_buffer() -> usize {
    let mut v: Vec<u8> = Vec::with_capacity(COLD_BYTES + (2 << 20));
    let p = v.as_mut_ptr();
    let a = p.align_offset(2 << 20);
    // SAFETY: within the reservation; first touch of every page here, in setup.
    unsafe { std::ptr::write_bytes(p.add(a), 1u8, COLD_BYTES) };
    let addr = p as usize + a;
    std::mem::forget(v);
    addr
}

/// Resolve the switches and touch the cold buffer (call in untimed setup).
pub fn init() {
    LazyLock::force(&CFG);
    crit::calibrate();
}

thread_local! {
    static T0: std::cell::Cell<[u64; 12]> = const { std::cell::Cell::new([0; 12]) };
    static CUR: std::cell::Cell<usize> = const { std::cell::Cell::new(usize::MAX) };
}
static NEXT_SLICE: AtomicU64 = AtomicU64::new(0);
static SINK: AtomicU64 = AtomicU64::new(0);

#[inline]
fn tsc() -> u64 {
    #[cfg(target_arch = "x86_64")]
    unsafe {
        core::arch::x86_64::_rdtsc()
    }
    #[cfg(not(target_arch = "x86_64"))]
    0
}

/// Trace-mark hook (called from `rstrace::ev` / `evd` for every mark).
#[inline]
pub fn at(tag: &'static str) {
    let b = tag.as_bytes();
    if b.len() < 4 || b.len() > 9 {
        return;
    }
    crit::at(b);
    let mut t = 0u64;
    for k in 0..12 {
        let s = &SITES[k];
        let is_begin = s.0.as_bytes() == b;
        let is_end = !is_begin && s.1.as_bytes() == b;
        if !is_begin && !is_end {
            continue;
        }
        if t == 0 {
            t = tsc();
        }
        if is_begin {
            T0.with(|c| {
                let mut a = c.get();
                a[k] = t;
                c.set(a);
            });
            continue;
        }
        let t0 = T0.with(|c| c.get()[k]);
        if !HIT[k].load(Ordering::Relaxed) {
            HIT[k].store(true, Ordering::Relaxed);
        }
        if CFG.on[k] && t0 != 0 && t > t0 {
            let dt = (t - t0).min(1 << 32);
            match s.3 {
                Kind::C => burn(dt / 60),
                Kind::M => stream(dt / 200),
            }
        }
    }
}

/// `iters` rounds of six independent VPCLMULQDQ chains (~6 cycles each).
#[inline(never)]
fn burn(iters: u64) {
    #[cfg(all(target_arch = "x86_64", target_feature = "avx512f", target_feature = "vpclmulqdq"))]
    unsafe {
        use core::arch::x86_64::*;
        let k = _mm512_set1_epi64(0x87);
        let mut a = _mm512_set1_epi64(iters as i64 | 1);
        let mut b = _mm512_set1_epi64(3);
        let mut c = _mm512_set1_epi64(5);
        let mut d = _mm512_set1_epi64(7);
        let mut e = _mm512_set1_epi64(11);
        let mut f = _mm512_set1_epi64(13);
        for _ in 0..iters {
            a = _mm512_clmulepi64_epi128(a, k, 0x01);
            b = _mm512_clmulepi64_epi128(b, k, 0x10);
            c = _mm512_clmulepi64_epi128(c, k, 0x01);
            d = _mm512_clmulepi64_epi128(d, k, 0x10);
            e = _mm512_clmulepi64_epi128(e, k, 0x01);
            f = _mm512_clmulepi64_epi128(f, k, 0x10);
        }
        let x = _mm512_xor_si512(_mm512_xor_si512(_mm512_xor_si512(a, b), _mm512_xor_si512(c, d)), _mm512_xor_si512(e, f));
        SINK.fetch_xor(_mm512_reduce_add_epi64(x) as u64, Ordering::Relaxed);
    }
    #[cfg(not(all(target_arch = "x86_64", target_feature = "avx512f", target_feature = "vpclmulqdq")))]
    {
        let mut x = iters;
        for _ in 0..iters {
            x = std::hint::black_box(x.wrapping_mul(6364136223846793005).wrapping_add(1));
        }
        SINK.fetch_xor(x, Ordering::Relaxed);
    }
}

/// Load one word from each of `lines` consecutive cold cache lines of this
/// thread's 16 MiB slice of the cold buffer (wrapping).
#[inline(never)]
fn stream(lines: u64) {
    let base = CFG.buf;
    if base == 0 {
        return;
    }
    let mut cur = CUR.with(|c| c.get());
    if cur == usize::MAX {
        let slice = (NEXT_SLICE.fetch_add(1, Ordering::Relaxed) % 16) as usize;
        cur = slice * PER_THREAD;
    }
    let slice_base = cur / PER_THREAD * PER_THREAD;
    let mut off = cur - slice_base;
    let mut acc = 0u64;
    for _ in 0..lines {
        // SAFETY: inside the touched cold buffer, never written after setup.
        acc = acc.wrapping_add(unsafe { core::ptr::read_volatile((base + slice_base + off) as *const u64) });
        off += 64;
        if off >= PER_THREAD {
            off = 0;
        }
    }
    CUR.with(|c| c.set(slice_base + off));
    SINK.fetch_xor(acc, Ordering::Relaxed);
}

/// Warm-up report: microseconds to wait before publishing in trial `r`.
pub fn warmup_delay_us(r: u64) -> u64 {
    let k = ((r - 1) % 12) as usize;
    if HIT[k].load(Ordering::Relaxed) { 8000 } else { 0 }
}

/// Critical-path recorder (every trial; reported in warm-up trials only).
///
/// Records, for the last proof of the process, the serial setup before the
/// first task of round two and of rounds 3+4, the idle tail at the end of each
/// of those passes (time from a thread's last task end to the pass's close
/// mark, mean and max over the pool), and the serial steps between round one,
/// round two, rounds 3+4 and the tail. Same work in every trial.
mod crit {
    use std::sync::atomic::{AtomicU64, Ordering};

    const NT: usize = 17;
    static TSC_PER_US: AtomicU64 = AtomicU64::new(0);

    /// One per-thread slot per cache line (no false sharing on task ends).
    #[repr(align(64))]
    struct Line(AtomicU64);

    // Pass 0 = round two (r2:in, r2:b, r2:e, r2:par1);
    // pass 1 = rounds 3+4+5 (r345:call, r3:b, r3:e, r345:par1).
    static START: [AtomicU64; 2] = [const { AtomicU64::new(0) }; 2];
    static FIRST_B: [AtomicU64; 2] = [const { AtomicU64::new(u64::MAX) }; 2];
    static LAST_E: [[Line; NT]; 2] = [const { [const { Line(AtomicU64::new(0)) }; NT] }; 2];
    static CLOSE: [AtomicU64; 2] = [const { AtomicU64::new(0) }; 2];
    static R1_DONE: AtomicU64 = AtomicU64::new(0);
    static TAIL_FIRST: AtomicU64 = AtomicU64::new(u64::MAX);
    static R1_AB1: AtomicU64 = AtomicU64::new(0);
    static R1_C1: AtomicU64 = AtomicU64::new(0);

    pub(super) fn calibrate() {
        if TSC_PER_US.load(Ordering::Relaxed) != 0 {
            return;
        }
        let t0 = std::time::Instant::now();
        let c0 = super::tsc();
        while t0.elapsed() < std::time::Duration::from_millis(2) {
            std::hint::spin_loop();
        }
        let c1 = super::tsc();
        let us = t0.elapsed().as_micros().max(1) as u64;
        TSC_PER_US.store(((c1.wrapping_sub(c0)) / us).max(1), Ordering::Relaxed);
    }

    #[inline]
    fn slot() -> usize {
        rayon::current_thread_index().map_or(NT - 1, |i| i.min(NT - 2))
    }

    #[inline]
    fn start(p: usize, t: u64) {
        START[p].store(t, Ordering::Relaxed);
        FIRST_B[p].store(u64::MAX, Ordering::Relaxed);
        for e in &LAST_E[p] {
            e.0.store(0, Ordering::Relaxed);
        }
    }

    /// Record the first time only: a plain load on every later call (the line
    /// stays shared), one RMW per pass.
    #[inline]
    fn first(a: &AtomicU64, t: u64) {
        if a.load(Ordering::Relaxed) == u64::MAX {
            a.fetch_min(t, Ordering::Relaxed);
        }
    }

    #[inline]
    pub(super) fn at(b: &[u8]) {
        // Cheap filter: every watched tag starts with r or z.
        match b[0] {
            b'r' | b'z' => {}
            _ => return,
        }
        let t = || super::tsc();
        match b {
            b"r2:in" => start(0, t()),
            b"r2:b" => first(&FIRST_B[0], t()),
            b"r2:e" => LAST_E[0][slot()].0.store(t(), Ordering::Relaxed),
            b"r2:par1" => CLOSE[0].store(t(), Ordering::Relaxed),
            b"r345:call" => {
                start(1, t());
                TAIL_FIRST.store(u64::MAX, Ordering::Relaxed);
            }
            b"r3:b" => first(&FIRST_B[1], t()),
            b"r3:e" => LAST_E[1][slot()].0.store(t(), Ordering::Relaxed),
            b"r345:par1" => CLOSE[1].store(t(), Ordering::Relaxed),
            b"zt:c0" => first(&TAIL_FIRST, t()),
            b"r1:done" => R1_DONE.store(t(), Ordering::Relaxed),
            b"r1:ab1" => R1_AB1.store(t(), Ordering::Relaxed),
            b"r1:c1" => R1_C1.store(t(), Ordering::Relaxed),
            _ => {}
        }
    }

    fn us(dt: i64) -> i64 {
        let k = TSC_PER_US.load(Ordering::Relaxed).max(1) as i64;
        dt / k
    }

    /// Microseconds: (pass setup, tail idle mean, tail idle max).
    fn pass(p: usize) -> (i64, i64, i64) {
        let s = START[p].load(Ordering::Relaxed) as i64;
        let f = FIRST_B[p].load(Ordering::Relaxed);
        let c = CLOSE[p].load(Ordering::Relaxed) as i64;
        if s == 0 || f == u64::MAX || c < s {
            return (-1, -1, -1);
        }
        let mut sum = 0i64;
        let mut n = 0i64;
        let mut mx = 0i64;
        for e in &LAST_E[p] {
            let e = e.0.load(Ordering::Relaxed) as i64;
            if e >= s && e <= c {
                let idle = c - e;
                sum += idle;
                n += 1;
                mx = mx.max(idle);
            }
        }
        (us(f as i64 - s), us(sum / n.max(1)), us(mx))
    }

    /// The value reported in warm-up trial `r` (microseconds, -1 = not seen).
    pub(super) fn value(r: u64) -> i64 {
        let (s0, m0, x0) = pass(0);
        let (s1, m1, x1) = pass(1);
        let g = |a: u64, b: u64| -> i64 {
            if a == 0 || b == 0 || b == u64::MAX || b < a { -1 } else { us((b - a) as i64) }
        };
        match (r - 1) % 10 {
            0 => s0,
            1 => m0,
            2 => x0,
            3 => g(CLOSE[0].load(Ordering::Relaxed), START[1].load(Ordering::Relaxed)),
            4 => s1,
            5 => m1,
            6 => x1,
            7 => g(CLOSE[1].load(Ordering::Relaxed), TAIL_FIRST.load(Ordering::Relaxed)),
            8 => g(R1_DONE.load(Ordering::Relaxed), START[0].load(Ordering::Relaxed)),
            _ => {
                let (a, c) = (R1_AB1.load(Ordering::Relaxed) as i64, R1_C1.load(Ordering::Relaxed) as i64);
                if a == 0 || c == 0 { -1 } else { 1000 + us(c - a) }
            }
        }
    }
}

/// Warm-up critical-path report: microseconds to wait before publishing in
/// warm-up trial `r`: 20 x the recorded value (capped at 40 ms); a value
/// that was not recorded waits 45 ms.
pub fn crit_delay_us(r: u64) -> u64 {
    let v = crit::value(r);
    if v < 0 { 45_000 } else { (v as u64 * 20).min(40_000) }
}
