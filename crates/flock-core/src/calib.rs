//! Warm-up self-calibration of bit-identical schedule variants.
//!
//! A few code paths have two implementations that produce the same bytes but
//! whose relative speed depends on the core: the work-conserving deep-pass
//! pairing ([`crate::ntt::additive_ntt_f128`]) helps when the pass is limited
//! by memory parallelism and is neutral when it is port-bound, and the
//! 32-bit offset reads in the witness projection trade scalar shifts for loads
//! (see `ntt::inv_table::side_offsets`), and keeping idle workers spinning
//! through the latency-bound proof tail (`crate::hot_pool`) trades wake-up
//! latency for issue slots on the busy siblings. Instead of guessing for the ranked
//! machine, the ranked worker's untimed extra warm-up proves alternate each
//! variant ([`Variant::set`]), the phase that variant affects records its wall
//! time ([`Phase`]), and [`Calibration::finish`] latches the faster arm of every
//! variant for the timed prove. Nothing here can change a proof byte: every
//! arm computes the same values, and only which arm runs is chosen.
//!
//! Defaults (no calibration ran, e.g. tests and library callers) are the
//! incumbent arms. `FLOCK_CALIB=0` skips calibration (defaults stay),
//! `FLOCK_CALIB_LOG=1` prints the per-arm samples and the decision.

use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::time::Instant;

/// One bit-identical alternative, `false` = incumbent arm.
pub struct Variant {
    on: AtomicBool,
    name: &'static str,
}

impl Variant {
    const fn new(name: &'static str) -> Self {
        Self {
            on: AtomicBool::new(false),
            name,
        }
    }

    #[inline(always)]
    pub fn get(&self) -> bool {
        self.on.load(Ordering::Relaxed)
    }

    pub fn set(&self, on: bool) {
        self.on.store(on, Ordering::Relaxed);
    }
}

/// Work-conserving deep-pass SMT pairs (idle hash sibling steals sub-groups).
pub static DEEP_BALANCE: Variant = Variant::new("deep_balance");
/// Witness projection reads its row offsets as 32-bit pairs.
pub static WITNESS_LD32: Variant = Variant::new("witness_ld32");
/// Keep idle workers spinning through the latency-bound tail (zerocheck
/// rounds 2.., lincheck, PCS open; see `crate::hot_pool`).
pub static HOT_POOL: Variant = Variant::new("hot_pool");
/// Build the witness in strided units and run the commit's seed+top pass
/// inside the witness phase (`pcs::FusedTop`).
pub static WITNESS_FUSE: Variant = Variant::new("witness_fuse");
/// Diagnostics only (not calibrated): under `WITNESS_FUSE`, run the fused
/// units with every worker doing both stages back to back instead of the
/// SMT-paired producer/consumer schedule.
pub static WITNESS_UNPAIRED: Variant = Variant::new("witness_unpaired");

/// A timed phase: the most recent wall time between [`Phase::begin`] and
/// [`Phase::end`], in nanoseconds (0 = not observed since the last reset).
pub struct Phase {
    start: AtomicU64,
    last: AtomicU64,
}

static EPOCH: std::sync::LazyLock<Instant> = std::sync::LazyLock::new(Instant::now);

fn now_ns() -> u64 {
    EPOCH.elapsed().as_nanos() as u64 + 1
}

impl Phase {
    const fn new() -> Self {
        Self {
            start: AtomicU64::new(0),
            last: AtomicU64::new(0),
        }
    }

    #[inline]
    pub fn begin(&self) {
        self.start.store(now_ns(), Ordering::Relaxed);
    }

    #[inline]
    pub fn end(&self) {
        let s = self.start.swap(0, Ordering::Relaxed);
        if s != 0 {
            self.last.store(now_ns() - s, Ordering::Relaxed);
        }
    }

    fn take(&self) -> u64 {
        self.last.swap(0, Ordering::Relaxed)
    }
}

/// Witness generation + projection (`witness: pool entered` .. `work done`).
pub static WITNESS: Phase = Phase::new();
/// Commit deep pass (end of the seed+top pass .. end of the deep pass).
pub static DEEP: Phase = Phase::new();
/// Proof tail: zerocheck round-1 challenge .. end of the PCS open.
pub static TAIL: Phase = Phase::new();
/// Witness start .. start of the commit deep pass (witness + seed+top).
pub static FRONT: Phase = Phase::new();

struct Experiment {
    variant: &'static Variant,
    phase: &'static Phase,
    /// Phase time per design point `q` (0 = not observed).
    samples: [u64; DESIGN],
}

/// Full factorial over the experiments: design point `q` runs experiment `j`
/// on its arm `(q >> j) & 1`, so points `q` and `q ^ (1 << j)` differ only in
/// experiment `j`.
const DESIGN: usize = 16;

/// Driver for one warm-up calibration run.
pub struct Calibration {
    experiments: Vec<Experiment>,
    pass: usize,
    log: bool,
}

/// Whether the ranked worker should calibrate (`FLOCK_CALIB=0` disables).
pub fn enabled() -> bool {
    std::env::var_os("FLOCK_CALIB").is_none_or(|v| v != "0")
}

impl Calibration {
    /// Every experiment, each tied to the phase it affects.
    pub fn new() -> Self {
        let mk = |variant, phase| Experiment {
            variant,
            phase,
            samples: [0; DESIGN],
        };
        Self {
            experiments: vec![
                mk(&DEEP_BALANCE, &DEEP),
                mk(&WITNESS_LD32, &WITNESS),
                mk(&HOT_POOL, &TAIL),
                mk(&WITNESS_FUSE, &FRONT),
            ],
            pass: 0,
            log: std::env::var_os("FLOCK_CALIB_LOG").is_some(),
        }
    }

    /// Design point of the current pass. Pass 0 is a discarded first-touch
    /// pass; passes 1..=16 visit every point once.
    fn point(&self) -> usize {
        self.pass.wrapping_sub(1) % DESIGN
    }

    /// Choose the arms for the next warm-up prove.
    pub fn before_pass(&mut self) {
        let q = self.point();
        for (j, e) in self.experiments.iter().enumerate() {
            e.variant.set((q >> j) & 1 == 1);
            e.phase.take();
        }
    }

    /// Record the phase times of the prove that just ran. `warm` = false
    /// discards it (first-touch passes are not representative).
    pub fn after_pass(&mut self, warm: bool) {
        let q = self.point();
        for e in &mut self.experiments {
            let t = e.phase.take();
            if warm && t != 0 {
                e.samples[q] = t;
            }
        }
        self.pass += 1;
    }

    /// Latch each variant to its arm by the median of the paired differences
    /// `t(q with j on) - t(q with j off)` over the points observed in both
    /// arms; no pairs, or a median that is not negative, keep the incumbent.
    /// Then apply [`apply_overrides`].
    pub fn finish(self) {
        for (j, e) in self.experiments.iter().enumerate() {
            let bit = 1usize << j;
            let mut d: Vec<i64> = (0..DESIGN)
                .filter(|q| q & bit == 0)
                .filter(|&q| e.samples[q] != 0 && e.samples[q | bit] != 0)
                .map(|q| e.samples[q | bit] as i64 - e.samples[q] as i64)
                .collect();
            d.sort_unstable();
            let med = match d.len() {
                0 => 0,
                n if n % 2 == 1 => d[n / 2],
                n => (d[n / 2 - 1] + d[n / 2]) / 2,
            };
            let pick = med < 0;
            e.variant.set(pick);
            if self.log {
                let ms: Vec<String> = d.iter().map(|&t| format!("{:+.2}", t as f64 / 1e6)).collect();
                eprintln!(
                    "[calib] {}: on-off {:?} -> {}",
                    e.variant.name,
                    ms,
                    if pick { "on" } else { "off" }
                );
            }
        }
        apply_overrides();
    }
}

/// Diagnostics: `FLOCK_CALIB_<NAME>=0|1` (e.g. `FLOCK_CALIB_DEEP_BALANCE=1`)
/// forces an arm after calibration or in place of it. The ranked harness
/// clears the environment, so this never applies to a scored run.
pub fn apply_overrides() {
    for v in [&DEEP_BALANCE, &WITNESS_LD32, &HOT_POOL, &WITNESS_FUSE, &WITNESS_UNPAIRED] {
        let key = format!("FLOCK_CALIB_{}", v.name.to_ascii_uppercase());
        if let Some(val) = std::env::var_os(&key) {
            v.set(val != "0");
        }
    }
}

/// Runner factorial probe: the trusted harness names trial `N`'s files
/// `run-N.ready` / `run-N.proof` and passes them on the worker's command
/// line, one fresh process per trial. When that shape is present, trial `N`
/// runs design point `(N - 1) mod 16` (bit 0 `witness_fuse`, bit 1
/// `deep_balance`, bit 2 `witness_ld32`, bit 3 `hot_pool`) instead of
/// calibrating, so the 120 trials of one evaluation measure every variant's
/// main effect on the runner, interleaved in time. Returns the point, or
/// `None` for any other invocation. `FLOCK_CALIB_PROBE=0` disables.
pub fn probe_point() -> Option<usize> {
    if std::env::var_os("FLOCK_CALIB_PROBE").is_some_and(|v| v == "0") {
        return None;
    }
    std::env::args_os().skip(1).find_map(|a| {
        let name = std::path::Path::new(&a).file_name()?.to_str()?.to_owned();
        let digits = name.strip_prefix("run-")?.strip_suffix(".ready")?;
        if digits.is_empty() || !digits.bytes().all(|b| b.is_ascii_digit()) {
            return None;
        }
        let n: usize = digits.parse().ok()?;
        (n >= 1).then(|| (n - 1) % DESIGN)
    })
}

/// Set the arms of design point `q` (see [`probe_point`]), then apply
/// [`apply_overrides`].
pub fn apply_probe(q: usize) {
    WITNESS_FUSE.set(q & 1 != 0);
    DEEP_BALANCE.set(q & 2 != 0);
    WITNESS_LD32.set(q & 4 != 0);
    HOT_POOL.set(q & 8 != 0);
    apply_overrides();
}

impl Default for Calibration {
    fn default() -> Self {
        Self::new()
    }
}
