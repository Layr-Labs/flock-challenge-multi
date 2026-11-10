//! `FLOCK_RS_TRACE`: lane-rs diagnostics. Absolute-time event log for the
//! Ligerito open (per-step and per-thread marks). Read once per process;
//! disabled path is one cached-bool load. Never set by the ranked worker.

use std::sync::LazyLock;
use std::sync::atomic::{AtomicU32, AtomicU64, AtomicUsize, Ordering};
use std::time::Instant;

pub fn level() -> u8 {
    static L: LazyLock<u8> = LazyLock::new(|| {
        std::env::var("FLOCK_RS_TRACE").ok().map(|s| s.parse().unwrap_or(1)).unwrap_or(0)
    });
    *L
}

pub fn on() -> bool {
    level() > 0
}

/// Detail event (per task / per thread): recorded only at FLOCK_RS_TRACE=2.
#[inline]
pub fn evd(tag: &'static str, arg: u32) {
    if level() >= 2 {
        ev(tag, arg);
    }
}

static EPOCH: LazyLock<Instant> = LazyLock::new(Instant::now);
const CAP: usize = 1 << 16;
// Lock-free slots: (ns, tag ptr, tag len, arg|tid<<32|cpu<<48).
static SLOTS: LazyLock<Vec<[AtomicU64; 4]>> = LazyLock::new(|| {
    (0..CAP).map(|_| [AtomicU64::new(0), AtomicU64::new(0), AtomicU64::new(0), AtomicU64::new(0)]).collect()
});
static NEXT: AtomicUsize = AtomicUsize::new(0);
static NEXT_TID: AtomicU32 = AtomicU32::new(0);
thread_local! {
    static TID: u32 = NEXT_TID.fetch_add(1, Ordering::Relaxed);
}

#[cfg(target_os = "linux")]
fn cpu() -> i32 {
    unsafe extern "C" {
        fn sched_getcpu() -> i32;
    }
    unsafe { sched_getcpu() }
}
#[cfg(not(target_os = "linux"))]
fn cpu() -> i32 {
    -1
}

/// Record `(now, tag, arg, thread, cpu)`.
#[inline]
pub fn ev(tag: &'static str, arg: u32) {
    if !on() {
        return;
    }
    let ns = EPOCH.elapsed().as_nanos() as u64;
    let tid = TID.with(|t| *t) as u64;
    let c = (cpu() as u64) & 0xffff;
    let i = NEXT.fetch_add(1, Ordering::Relaxed);
    if i >= CAP {
        return;
    }
    let s = &SLOTS[i];
    s[0].store(ns, Ordering::Relaxed);
    s[1].store(tag.as_ptr() as u64, Ordering::Relaxed);
    s[2].store(tag.len() as u64, Ordering::Relaxed);
    s[3].store(arg as u64 | (tid & 0xffff) << 32 | c << 48, Ordering::Release);
}

/// Print and clear every recorded event, relative to the first one.
pub fn dump(header: &str) {
    if !on() {
        return;
    }
    let n = NEXT.swap(0, Ordering::AcqRel).min(CAP);
    let mut v: Vec<(u64, &'static str, u32, u32, i32)> = (0..n)
        .map(|i| {
            let s = &SLOTS[i];
            let w = s[3].load(Ordering::Acquire);
            let tag: &'static str = unsafe {
                core::str::from_utf8_unchecked(core::slice::from_raw_parts(
                    s[1].load(Ordering::Relaxed) as *const u8,
                    s[2].load(Ordering::Relaxed) as usize,
                ))
            };
            (s[0].load(Ordering::Relaxed), tag, w as u32, ((w >> 32) & 0xffff) as u32, ((w >> 48) & 0xffff) as i32)
        })
        .collect();
    v.sort_by_key(|e| e.0);
    let t0 = v.first().map(|e| e.0).unwrap_or(0);
    eprintln!("[rs] ==== {header} ({} events)", v.len());
    for (ns, tag, arg, tid, c) in v {
        eprintln!("[rs] {:10.4} t{tid:<3} c{c:<3} {tag} {arg}", (ns - t0) as f64 / 1e6);
    }
}
