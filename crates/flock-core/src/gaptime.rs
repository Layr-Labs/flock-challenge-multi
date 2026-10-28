//! `FLOCK_GAP_TIMING`: wall-clock boundary instrumentation for the fast
//! prover. When the env var is set, [`mark`] prints one line per phase
//! boundary with the delta since the previous mark and the offset since
//! [`begin`] — the sum of the deltas accounts for the FULL prove wall time,
//! unlike per-phase stopwatches which silently drop the time BETWEEN phases
//! (pool installs, buffer drops, challenger hashing, allocator churn).
//!
//! DIAGNOSTIC BUILD: every `begin`/`mark` is also recorded (wall time and
//! process CPU time) for the current prove, so the seed pipe can report one
//! interval per ranked trial through its publication delay. Printing still
//! needs the env var, which the ranked worker's cleared env never sets.
//! Output goes to stderr so it never mixes with bench stdout parsing.

use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{LazyLock, Mutex};
use std::time::Instant;

/// Cached `FLOCK_GAP_TIMING` presence. Read once per process.
pub fn enabled() -> bool {
    static ON: LazyLock<bool> = LazyLock::new(|| std::env::var_os("FLOCK_GAP_TIMING").is_some());
    *ON
}

/// Process-wide monotonic epoch all marks are measured against.
static PROC_EPOCH: LazyLock<Instant> = LazyLock::new(Instant::now);
/// Nanos-since-`PROC_EPOCH` of the current prove's `begin`.
static BEGIN_NS: AtomicU64 = AtomicU64::new(0);
/// Nanos-since-`PROC_EPOCH` of the previous mark.
static LAST_NS: AtomicU64 = AtomicU64::new(0);

pub fn now_ns() -> u64 {
    PROC_EPOCH.elapsed().as_nanos() as u64
}

/// One recorded boundary of the current prove.
#[derive(Clone, Copy, Debug)]
pub struct Rec {
    pub label: &'static str,
    pub wall_ns: u64,
    pub cpu_ns: u64,
}

/// Boundaries of the current prove. Capacity is reserved by the first
/// (untimed warm-up) prove, so the timed prove never allocates here.
static LOG: Mutex<Vec<Rec>> = Mutex::new(Vec::new());
const LOG_CAP: usize = 1024;

/// CPU time of the whole process (all threads), nanoseconds.
pub fn cpu_ns() -> u64 {
    const CLOCK_PROCESS_CPUTIME_ID: i32 = 2;
    let mut ts = Ts { s: 0, ns: 0 };
    // SAFETY: valid out-pointer; the clock id is a Linux constant.
    unsafe { clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &mut ts) };
    ts.s as u64 * 1_000_000_000 + ts.ns as u64
}

fn record(label: &'static str) -> u64 {
    let now = now_ns();
    let cpu = cpu_ns();
    let mut log = LOG.lock().unwrap_or_else(|e| e.into_inner());
    if log.capacity() == 0 {
        log.reserve(LOG_CAP);
    }
    if log.len() < LOG_CAP {
        log.push(Rec { label, wall_ns: now, cpu_ns: cpu });
    }
    now
}

/// Reset the epoch and the record at the start of a prove.
pub fn begin(label: &'static str) {
    LOG.lock().unwrap_or_else(|e| e.into_inner()).clear();
    let now = record(label);
    BEGIN_NS.store(now, Ordering::Relaxed);
    LAST_NS.store(now, Ordering::Relaxed);
    if enabled() {
        eprintln!("[gap] ======== {label} ========");
    }
}

/// Record a boundary; prints `+delta_ms @offset_ms label` when enabled.
pub fn mark(label: &'static str) {
    let now = record(label);
    if !enabled() {
        return;
    }
    let last = LAST_NS.swap(now, Ordering::Relaxed);
    let begin = BEGIN_NS.load(Ordering::Relaxed);
    let d_ms = now.saturating_sub(last) as f64 / 1e6;
    let t_ms = now.saturating_sub(begin) as f64 / 1e6;
    eprintln!("[gap] +{d_ms:9.3} ms  @{t_ms:9.3} ms  {label}");
}

/// Copy of the current prove's record.
pub fn snapshot() -> Vec<Rec> {
    LOG.lock().unwrap_or_else(|e| e.into_inner()).clone()
}

// ---------------------------------------------------------------------------
// DIAGNOSTIC BUILD: fold-3 de-risking arms, selected per worker process by the
// harness run index (`run-{r}.proof`). Slot (r - 1) % DIAG_SLOTS picks the arm
// (slot / 4) and the measured interval (slot % 4, see the seed pipe).
// ---------------------------------------------------------------------------

pub const DIAG_SLOTS: usize = 12;
pub const ARM_CONTROL: u8 = 0;
/// Round 2 also accumulates the bivariate round-four lookahead products.
pub const ARM_COST: u8 = 1;
/// Level 0 streams 256 MiB more stores; level 1 reads them back.
pub const ARM_TRAFFIC: u8 = 2;

/// Harness run index from the worker's `run-{r}.proof` argument (0 if absent).
pub fn run_index() -> usize {
    static RUN: LazyLock<usize> = LazyLock::new(|| {
        std::env::args()
            .filter_map(|a| {
                let name = std::path::Path::new(&a).file_name()?.to_str()?.to_owned();
                name.strip_prefix("run-")?.strip_suffix(".proof")?.parse().ok()
            })
            .next()
            .unwrap_or(0)
    });
    *RUN
}

/// This process's arm; `FLOCK_DIAG_ARM=0|1|2` overrides it for local checks.
pub fn diag_arm() -> u8 {
    static ARM: LazyLock<u8> = LazyLock::new(|| {
        if let Some(v) = std::env::var_os("FLOCK_DIAG_ARM") {
            return v.to_str().and_then(|s| s.parse().ok()).unwrap_or(ARM_CONTROL);
        }
        match run_index() {
            0 => ARM_CONTROL,
            r => (((r - 1) % DIAG_SLOTS) / 4) as u8,
        }
    });
    *ARM
}

/// Size of the traffic arm's scratch stream.
pub const DIAG_TRAFFIC_BYTES: usize = 256 << 20;

/// The traffic arm's 64-byte aligned scratch buffer. Allocated by the first
/// (untimed warm-up) prove that reaches level 0 in that arm.
pub fn diag_traffic_buf() -> *mut u8 {
    static BUF: LazyLock<usize> = LazyLock::new(|| {
        let layout = std::alloc::Layout::from_size_align(DIAG_TRAFFIC_BYTES, 4096).unwrap();
        // SAFETY: non-zero size; the buffer is never freed (process lifetime).
        let p = unsafe { std::alloc::alloc_zeroed(layout) };
        assert!(!p.is_null(), "traffic arm scratch allocation failed");
        p as usize
    });
    *BUF as *mut u8
}

// TEMP-ABS-TRACE
#[repr(C)]
struct Ts { s: i64, ns: i64 }
unsafe extern "C" { fn clock_gettime(clk: i32, ts: *mut Ts) -> i32; }
pub fn abs_enabled() -> bool {
    static ON: LazyLock<bool> = LazyLock::new(|| std::env::var_os("FLOCK_ABS_TRACE").is_some());
    *ON
}
static ABS_BUF: std::sync::Mutex<Vec<(u64, &'static str)>> = std::sync::Mutex::new(Vec::new());
pub fn abs(label: &'static str) {
    if !abs_enabled() { return; }
    let mut t = Ts { s: 0, ns: 0 };
    unsafe { clock_gettime(1, &mut t) };
    let ns = t.s as u64 * 1_000_000_000 + t.ns as u64;
    ABS_BUF.lock().unwrap().push((ns, label));
}
pub fn abs_flush() {
    if !abs_enabled() { return; }
    let st = std::fs::read_to_string("/proc/self/stat").unwrap_or_default();
    let f: Vec<&str> = st.rsplit(')').next().unwrap_or("").split_whitespace().collect();
    let minflt = f.get(7).copied().unwrap_or("?");
    for (ns, l) in ABS_BUF.lock().unwrap().drain(..) {
        eprintln!("[abs] {ns} {l} minflt={minflt}");
    }
}
