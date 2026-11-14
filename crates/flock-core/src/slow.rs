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
    ("p4:b", "p4:e", "FLOCK_SLOW_L0_C", Kind::C),
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
