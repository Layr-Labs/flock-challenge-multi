//! `FLOCK_GAP_TIMING`: wall-clock boundary instrumentation for the fast
//! prover. When the env var is set, [`mark`] prints one line per phase
//! boundary with the delta since the previous mark and the offset since
//! [`begin`] — the sum of the deltas accounts for the FULL prove wall time,
//! unlike per-phase stopwatches which silently drop the time BETWEEN phases
//! (pool installs, buffer drops, challenger hashing, allocator churn).
//!
//! DIAGNOSTIC BUILD: every mark is also recorded (wall and process CPU
//! time) for the current prove, so the seed pipe can report one interval
//! per ranked trial through its publication delay.

use std::sync::{LazyLock, Mutex};
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::Instant;

/// Cached `FLOCK_GAP_TIMING` presence. Read once per process.
fn print_enabled() -> bool {
    static ON: LazyLock<bool> = LazyLock::new(|| std::env::var_os("FLOCK_GAP_TIMING").is_some());
    *ON
}

/// Diagnostic build: marks always record.
pub fn enabled() -> bool {
    true
}

/// Process-wide monotonic epoch all marks are measured against.
static PROC_EPOCH: LazyLock<Instant> = LazyLock::new(Instant::now);
/// Nanos-since-`PROC_EPOCH` of the current prove's `begin`.
static BEGIN_NS: AtomicU64 = AtomicU64::new(0);
/// Nanos-since-`PROC_EPOCH` of the previous mark.
static LAST_NS: AtomicU64 = AtomicU64::new(0);

/// One recorded boundary of the current prove.
#[derive(Clone, Copy, Debug)]
pub struct Rec {
    pub label: &'static str,
    pub wall_ns: u64,
    pub cpu_ns: u64,
}

static LOG: Mutex<Vec<Rec>> = Mutex::new(Vec::new());

pub fn now_ns() -> u64 {
    PROC_EPOCH.elapsed().as_nanos() as u64
}

#[repr(C)]
struct Timespec {
    tv_sec: i64,
    tv_nsec: i64,
}

unsafe extern "C" {
    fn clock_gettime(clk: i32, tp: *mut Timespec) -> i32;
}

/// Process CPU time (all threads), nanoseconds.
pub fn cpu_ns() -> u64 {
    const CLOCK_PROCESS_CPUTIME_ID: i32 = 2;
    let mut ts = Timespec { tv_sec: 0, tv_nsec: 0 };
    // SAFETY: valid out-pointer; clock id is a Linux constant.
    unsafe { clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &mut ts) };
    ts.tv_sec as u64 * 1_000_000_000 + ts.tv_nsec as u64
}

fn record(label: &'static str) -> u64 {
    let now = now_ns();
    let cpu = cpu_ns();
    let mut log = LOG.lock().unwrap_or_else(|e| e.into_inner());
    if log.capacity() == 0 {
        log.reserve(1024);
    }
    if log.len() < 1024 {
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
    if print_enabled() {
        eprintln!("[gap] ======== {label} ========");
    }
}

/// Record a boundary: prints `+delta_ms @offset_ms label` when enabled.
pub fn mark(label: &'static str) {
    let now = record(label);
    if !print_enabled() {
        return;
    }
    let last = LAST_NS.swap(now, Ordering::Relaxed);
    let begin = BEGIN_NS.load(Ordering::Relaxed);
    let d_ms = now.saturating_sub(last) as f64 / 1e6;
    let t_ms = now.saturating_sub(begin) as f64 / 1e6;
    eprintln!("[gap] +{d_ms:9.3} ms  @{t_ms:9.3} ms  {label}");
}

/// Snapshot of the current prove's record.
pub fn snapshot() -> Vec<Rec> {
    LOG.lock().unwrap_or_else(|e| e.into_inner()).clone()
}

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

/// Number of profile metrics; run r reports metric (r - 1) % METRIC_COUNT.
pub const METRIC_COUNT: usize = 20;

/// Metric slot of this process (None outside the ranked harness).
pub fn metric_slot() -> Option<usize> {
    let r = run_index();
    (r >= 1).then(|| (r - 1) % METRIC_COUNT)
}

/// Lever A/B: the b-side hoist into the fold8 f pass is on only in the
/// "ON" slots (47, 49), or everywhere when `FLOCK_DIAG_HOIST=1`.
pub fn lever_hoist_on() -> bool {
    static ON: LazyLock<bool> = LazyLock::new(|| {
        std::env::var_os("FLOCK_DIAG_HOIST").is_some()
            || false
    });
    *ON
}

/// Lever A/B: zerocheck round 1 on the global pool (plain `rayon::join`)
/// instead of the SMT half-pools, in slots 13-16 and 18.
pub fn lever_r1_plain_join_on() -> bool {
    static ON: LazyLock<bool> = LazyLock::new(|| {
        std::env::var_os("FLOCK_DIAG_R1_PLAIN").is_some()
            || matches!(metric_slot(), Some(13) | Some(14) | Some(15) | Some(16) | Some(18))
    });
    *ON
}
