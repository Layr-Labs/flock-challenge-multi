use std::sync::{Arc, OnceLock};

use crate::field::F128;

mod kernels;

fn generate_evals_from_subspace(basis: &[F128]) -> Vec<Vec<F128>> {
    let l = basis.len();
    let mut evals: Vec<Vec<F128>> = Vec::with_capacity(l);

    evals.push(basis.to_vec());

    for i in 1..l {
        let mut row = Vec::with_capacity(l - i);
        for k in 1..evals[i - 1].len() {
            let val = evals[i - 1][k] * (evals[i - 1][k] + evals[i - 1][0]);
            row.push(val);
        }
        evals.push(row);
    }

    for row in evals.iter_mut() {
        let inv = row[0].inv();
        for v in row.iter_mut() {
            *v *= inv;
        }
    }

    evals
}

#[cold]
#[inline(never)]
fn span_get(basis: &[F128], idx: usize) -> F128 {
    let mut acc = F128::ZERO;
    for (j, &b) in basis.iter().enumerate() {
        if (idx >> j) & 1 == 1 {
            acc += b;
        }
    }
    acc
}

const MAX_PRECOMPUTED_TWIDDLE_LOG: usize = 20;

fn precompute_twiddles(evals: &[Vec<F128>]) -> Option<Vec<F128>> {
    let log_d = evals.len();
    if log_d > MAX_PRECOMPUTED_TWIDDLE_LOG {
        return None;
    }

    let mut twiddles = Vec::with_capacity((1usize << log_d) - 1);
    for layer in 0..log_d {
        let layer_start = twiddles.len();
        let eval_row = &evals[log_d - layer - 1];
        debug_assert_eq!(eval_row.len(), layer + 1);

        twiddles.push(F128::ZERO);
        for (bit, &basis_value) in eval_row[1..].iter().enumerate() {
            let half = 1usize << bit;
            for block in 0..half {
                let value = twiddles[layer_start + block] + basis_value;
                twiddles.push(value);
            }
        }
        debug_assert_eq!(twiddles.len() - layer_start, 1usize << layer);
    }
    Some(twiddles)
}

fn cached_standard_evals(dim: usize) -> Arc<Vec<Vec<F128>>> {
    let build = || {
        let basis: Vec<F128> = (0..dim).map(|i| F128::new(1u64 << i, 0)).collect();
        Arc::new(generate_evals_from_subspace(&basis))
    };
    static DISABLED: std::sync::LazyLock<bool> = std::sync::LazyLock::new(
        || matches!(std::env::var_os("FLOCK_NO_EVALS_CACHE"), Some(v) if v == "1"),
    );
    if *DISABLED {
        return build();
    }
    static TABLES: OnceLock<[OnceLock<Arc<Vec<Vec<F128>>>>; 65]> = OnceLock::new();
    let tables = TABLES.get_or_init(|| std::array::from_fn(|_| OnceLock::new()));
    Arc::clone(tables[dim].get_or_init(build))
}

fn cached_standard_twiddles(dim: usize, evals: &[Vec<F128>]) -> Option<Arc<[F128]>> {
    if dim > MAX_PRECOMPUTED_TWIDDLE_LOG {
        return None;
    }

    static TABLES: OnceLock<[OnceLock<Arc<[F128]>>; MAX_PRECOMPUTED_TWIDDLE_LOG + 1]> =
        OnceLock::new();
    let tables = TABLES.get_or_init(|| std::array::from_fn(|_| OnceLock::new()));
    Some(
        tables[dim]
            .get_or_init(|| {
                Arc::from(
                    precompute_twiddles(evals)
                        .expect("standard production domain should fit twiddle cache"),
                )
            })
            .clone(),
    )
}

const ZERO_TAIL_NUM_NTTS: usize = 64;

const ZERO_TAIL_LOG_D: usize = 20;

static ZERO_ODD_TAIL_LANES: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);

#[inline]
fn zero_lane_skip_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_ZERO_LANE_SKIP").is_some())
}

fn ntt_lone_top_bump_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_LONE_TOP_BUMP").is_some())
}

fn ntt_top_fusion_disabled() -> bool {
    #[cfg(test)]
    if TOP_FUSION_TEST_OFF.load(std::sync::atomic::Ordering::Relaxed) {
        return true;
    }
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_TOP_FUSION").is_some())
}

#[cfg(test)]
static TOP_FUSION_TEST_OFF: std::sync::atomic::AtomicBool =
    std::sync::atomic::AtomicBool::new(false);

fn ntt_seed_top_fusion_disabled() -> bool {
    #[cfg(test)]
    if SEED_TOP_FUSION_TEST_OFF.load(std::sync::atomic::Ordering::Relaxed) {
        return true;
    }
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_SEED_TOP_FUSION").is_some())
}

#[inline]
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
fn ntt_direct_fused2_publish_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_DIRECT_FUSED2_PUBLISH").is_some())
}

#[inline]
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
fn ntt_seed_hold4_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_SEED_HOLD4").is_some())
}

#[inline]
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
fn ntt_seed_odd_tail_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_SEED_ODD_TAIL").is_some())
}

#[cfg(test)]
static SEED_TOP_FUSION_TEST_OFF: std::sync::atomic::AtomicBool =
    std::sync::atomic::AtomicBool::new(false);

#[cfg(test)]
static TOP_FUSION_HITS: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);
#[cfg(test)]
static SEED_TOP_FUSION_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

fn ntt_kernel_diet_disabled() -> bool {
    static OFF: OnceLock<bool> = OnceLock::new();
    *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_KERNEL_DIET").is_some())
}

#[inline]
fn ntt_lane_round_disabled() -> bool {
    #[cfg(test)]
    if KERNEL_DIET_TEST_OFF.load(std::sync::atomic::Ordering::Relaxed) & 1 != 0 {
        return true;
    }
    static OFF: OnceLock<bool> = OnceLock::new();
    ntt_kernel_diet_disabled()
        || *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_LANE_ROUND").is_some())
}

#[inline]
fn deep_block_fuse_enabled() -> bool {
    static ON: OnceLock<bool> = OnceLock::new();
    *ON.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_DEEP_BLOCK_FUSE").is_none())
}

#[allow(clippy::manual_is_multiple_of)]
#[cfg(target_os = "linux")]
fn deep_split_pairs() -> Option<&'static Vec<(usize, usize)>> {
    static P: std::sync::LazyLock<Option<Vec<(usize, usize)>>> = std::sync::LazyLock::new(|| {
        if std::env::var_os("FLOCK_NO_NTT_DEEP_SPLIT").is_some() {
            return None;
        }
        let n = rayon::current_num_threads();
        if n % 2 != 0 || n < 4 {
            return None;
        }
        let mut pairs: Vec<(usize, usize)> = Vec::with_capacity(n / 2);
        let mut seen = vec![false; n];
        for c in 0..n {
            if seen[c] {
                continue;
            }
            let list = std::fs::read_to_string(format!(
                "/sys/devices/system/cpu/cpu{c}/topology/thread_siblings_list"
            ))
            .ok()?;
            let mut ids = Vec::new();
            for part in list.trim().split(',') {
                ids.push(part.trim().parse::<usize>().ok()?);
            }
            if ids.len() != 2 || ids[0] != c || ids[1] >= n || seen[ids[1]] {
                return None;
            }
            seen[c] = true;
            seen[ids[1]] = true;
            pairs.push((ids[0], ids[1]));
        }
        if pairs.len() != n / 2 {
            return None;
        }
        let mask = affinity::get();
        for c in 0..n {
            if mask[c / 64] & (1u64 << (c % 64)) == 0 {
                return None;
            }
        }
        Some(pairs)
    });
    P.as_ref()
}

#[cfg(target_os = "linux")]
static DEEP_SPLIT_BUSY: std::sync::atomic::AtomicBool = std::sync::atomic::AtomicBool::new(false);

#[cfg(target_os = "linux")]
struct DeepSplitClaim;

#[cfg(target_os = "linux")]
impl DeepSplitClaim {
    fn take() -> Option<Self> {
        use std::sync::atomic::Ordering;
        DEEP_SPLIT_BUSY
            .compare_exchange(false, true, Ordering::AcqRel, Ordering::Acquire)
            .ok()
            .map(|_| Self)
    }
}

#[cfg(target_os = "linux")]
impl Drop for DeepSplitClaim {
    fn drop(&mut self) {
        DEEP_SPLIT_BUSY.store(false, std::sync::atomic::Ordering::Release);
    }
}

#[cfg(target_os = "linux")]
#[inline]
fn select_deep_split_depth(requested: Option<usize>) -> usize {
    requested
        .unwrap_or(DeepQueue::DEFAULT_DEPTH)
        .clamp(1, DeepQueue::CAP)
}

#[cfg(target_os = "linux")]
fn deep_share_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_DEEP_SHARE").is_none());
    *ON
}

#[cfg(target_os = "linux")]
fn merged_pass_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_MERGED_PASS").is_none());
    *ON
}

#[cfg(target_os = "linux")]
fn deep_split_depth() -> usize {
    static D: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
        select_deep_split_depth(
            std::env::var("FLOCK_NTT_DEEP_SPLIT_DEPTH")
                .ok()
                .and_then(|v| v.parse::<usize>().ok()),
        )
    });
    *D
}

#[cfg(target_os = "linux")]
mod affinity {
    unsafe extern "C" {
        fn sched_setaffinity(pid: i32, cpusetsize: usize, mask: *const u64) -> i32;
        fn sched_getaffinity(pid: i32, cpusetsize: usize, mask: *mut u64) -> i32;
    }
    pub type Mask = [u64; 16];
    pub fn get() -> Mask {
        let mut m: Mask = [0; 16];
        unsafe {
            sched_getaffinity(0, core::mem::size_of::<Mask>(), m.as_mut_ptr());
        }
        m
    }
    pub fn set(m: &Mask) {
        unsafe {
            sched_setaffinity(0, core::mem::size_of::<Mask>(), m.as_ptr());
        }
    }
    pub fn pin(cpu: usize) {
        let mut m: Mask = [0; 16];
        m[cpu / 64] = 1u64 << (cpu % 64);
        set(&m);
    }
}

#[cfg(target_os = "linux")]
struct DeepSplitState {
    queues: Vec<DeepQueue>,
    next_sub: std::sync::atomic::AtomicUsize,
    prod_done: std::sync::atomic::AtomicUsize,
}

#[cfg(target_os = "linux")]
impl DeepSplitState {
    fn new(n_pairs: usize) -> Self {
        Self {
            queues: (0..n_pairs).map(|_| DeepQueue::new()).collect(),
            next_sub: std::sync::atomic::AtomicUsize::new(0),
            prod_done: std::sync::atomic::AtomicUsize::new(0),
        }
    }
}

#[cfg(target_os = "linux")]
#[derive(Clone, Copy)]
struct DeepBlock {
    lo: usize,
}

#[cfg(target_os = "linux")]
impl DeepBlock {
    const ROWS: usize = 128;

    #[inline]
    fn from_finished(
        range: &core::ops::Range<usize>,
        blk: &[F128],
        base_addr: usize,
        columns: usize,
    ) -> Option<Self> {
        if range.end - range.start == Self::ROWS
            && blk.len() == Self::ROWS * columns
            && blk.as_ptr() as usize
                == base_addr + range.start * columns * core::mem::size_of::<F128>()
        {
            Some(Self { lo: range.start })
        } else {
            None
        }
    }
}

#[cfg(target_os = "linux")]
#[repr(align(64))]
struct DeepQueue {
    slots: Vec<std::sync::atomic::AtomicUsize>,
    head: std::sync::atomic::AtomicUsize,
    tail: std::sync::atomic::AtomicUsize,
    done: std::sync::atomic::AtomicBool,
    gone: std::sync::atomic::AtomicBool,
}

#[cfg(target_os = "linux")]
impl DeepQueue {
    const CAP: usize = 64;
    const DEFAULT_DEPTH: usize = 8;
    fn new() -> Self {
        Self {
            slots: (0..Self::CAP)
                .map(|_| std::sync::atomic::AtomicUsize::new(0))
                .collect(),
            head: std::sync::atomic::AtomicUsize::new(0),
            tail: std::sync::atomic::AtomicUsize::new(0),
            done: std::sync::atomic::AtomicBool::new(false),
            gone: std::sync::atomic::AtomicBool::new(false),
        }
    }
    fn push(&self, b: DeepBlock, depth: usize) -> bool {
        use std::sync::atomic::Ordering;
        let h = self.head.load(Ordering::Relaxed);
        while h - self.tail.load(Ordering::Acquire) >= depth {
            if self.gone.load(Ordering::Acquire) {
                return false;
            }
            std::hint::spin_loop();
        }
        self.slots[h % Self::CAP].store(b.lo, Ordering::Relaxed);
        self.head.store(h + 1, Ordering::Release);
        true
    }
    fn try_push(&self, b: DeepBlock, depth: usize) -> bool {
        use std::sync::atomic::Ordering;
        let h = self.head.load(Ordering::Relaxed);
        if h - self.tail.load(Ordering::Acquire) >= depth {
            return false;
        }
        self.slots[h % Self::CAP].store(b.lo, Ordering::Relaxed);
        self.head.store(h + 1, Ordering::Release);
        true
    }
    fn try_pop(&self) -> Option<DeepBlock> {
        use std::sync::atomic::Ordering;
        let mut t = self.tail.load(Ordering::Acquire);
        loop {
            if self.head.load(Ordering::Acquire) <= t {
                return None;
            }
            let b = DeepBlock {
                lo: self.slots[t % Self::CAP].load(Ordering::Relaxed),
            };
            match self
                .tail
                .compare_exchange_weak(t, t + 1, Ordering::AcqRel, Ordering::Acquire)
            {
                Ok(_) => return Some(b),
                Err(cur) => t = cur,
            }
        }
    }
    fn is_empty(&self) -> bool {
        use std::sync::atomic::Ordering;
        self.head.load(Ordering::Acquire) <= self.tail.load(Ordering::Acquire)
    }
    fn pop(&self) -> Option<DeepBlock> {
        use std::sync::atomic::Ordering;
        let t = self.tail.load(Ordering::Relaxed);
        loop {
            if self.head.load(Ordering::Acquire) > t {
                let b = DeepBlock {
                    lo: self.slots[t % Self::CAP].load(Ordering::Relaxed),
                };
                self.tail.store(t + 1, Ordering::Release);
                return Some(b);
            }
            if self.done.load(Ordering::Acquire) {
                if self.head.load(Ordering::Acquire) > t {
                    continue;
                }
                return None;
            }
            std::hint::spin_loop();
        }
    }
}

#[cfg(target_os = "linux")]
fn deep_pf_hint() -> u8 {
    static H: std::sync::LazyLock<u8> = std::sync::LazyLock::new(|| {
        if std::env::var_os("FLOCK_NO_NTT_DEEP_PF").is_some() {
            return 0;
        }
        std::env::var("FLOCK_NTT_DEEP_PF_HINT")
            .ok()
            .and_then(|v| v.parse::<u8>().ok())
            .unwrap_or(1)
    });
    *H
}

#[cfg(test)]
static NTT_SHAPED_TEST_OFF: std::sync::atomic::AtomicBool =
    std::sync::atomic::AtomicBool::new(false);

#[cfg_attr(
    not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )),
    allow(dead_code)
)]
fn ntt_shaped_enabled() -> bool {
    #[cfg(test)]
    if NTT_SHAPED_TEST_OFF.load(std::sync::atomic::Ordering::Relaxed) {
        return false;
    }
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_SHAPED").is_none());
    *ON
}

#[inline]
fn ntt_fused3_disabled() -> bool {
    #[cfg(test)]
    if KERNEL_DIET_TEST_OFF.load(std::sync::atomic::Ordering::Relaxed) & 2 != 0 {
        return true;
    }
    static OFF: OnceLock<bool> = OnceLock::new();
    ntt_kernel_diet_disabled()
        || *OFF.get_or_init(|| std::env::var_os("FLOCK_NO_NTT_FUSED3").is_some())
}

#[cfg(test)]
static KERNEL_DIET_TEST_OFF: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

#[cfg(test)]
static FUSED3_HITS: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
enum StagingInit {
    Uninit,
    Zero,
    #[cfg(test)]
    Poison,
}

#[cfg(test)]
static STAGING_INIT_TEST_MODE: std::sync::atomic::AtomicU8 = std::sync::atomic::AtomicU8::new(0);

#[cfg(test)]
const STAGING_POISON: F128 = F128 {
    lo: 0xDEAD_BEEF_FEED_FACE,
    hi: 0xBAAD_F00D_C0DE_D00D,
};

fn staging_init_mode() -> StagingInit {
    #[cfg(test)]
    {
        match STAGING_INIT_TEST_MODE.load(std::sync::atomic::Ordering::Relaxed) {
            1 => return StagingInit::Zero,
            2 => return StagingInit::Poison,
            3 => return StagingInit::Uninit,
            _ => {}
        }
    }
    static MODE: std::sync::LazyLock<StagingInit> =
        std::sync::LazyLock::new(|| match std::env::var_os("FLOCK_NO_UNINIT_STAGING") {
            Some(v) if v == "1" => StagingInit::Zero,
            _ => StagingInit::Uninit,
        });
    *MODE
}

fn staging_block(rows: usize, row_len: usize) -> Vec<F128> {
    let n = rows * row_len;
    match staging_init_mode() {
        StagingInit::Uninit => crate::alloc_uninit_vec::<F128>(n),
        StagingInit::Zero => vec![F128::ZERO; n],
        #[cfg(test)]
        StagingInit::Poison => {
            let mut v = crate::alloc_uninit_vec::<F128>(n);
            v.fill(STAGING_POISON);
            v
        }
    }
}

#[inline]
pub(crate) fn ranked_zero_odd_tail_lanes(log_d: usize, num_ntts: usize) -> usize {
    if log_d != ZERO_TAIL_LOG_D || num_ntts != ZERO_TAIL_NUM_NTTS || zero_lane_skip_disabled() {
        return 0;
    }
    let tail = ZERO_ODD_TAIL_LANES.load(std::sync::atomic::Ordering::Relaxed);
    if tail >= num_ntts {
        return 0;
    }
    if ntt_lane_round_disabled() {
        tail
    } else {
        tail & !3
    }
}

#[must_use = "the skip is active only while the guard is alive"]
pub struct ZeroOddTailLanes(usize);

impl ZeroOddTailLanes {
    pub fn scope(num_ntts: usize, lanes: usize) -> Self {
        let lanes = if num_ntts == ZERO_TAIL_NUM_NTTS && lanes < num_ntts {
            lanes
        } else {
            0
        };
        Self(ZERO_ODD_TAIL_LANES.swap(lanes, std::sync::atomic::Ordering::Relaxed))
    }

    pub fn lanes_for_padding(num_ntts: usize, k_log: usize, useful_bits_per_block: usize) -> usize {
        const LOG_PACKING: usize = 7;
        if num_ntts != ZERO_TAIL_NUM_NTTS || k_log < LOG_PACKING {
            return 0;
        }
        let words_per_block = 1usize << (k_log - LOG_PACKING);
        if words_per_block != 2 * num_ntts {
            return 0;
        }
        let used_words = useful_bits_per_block.div_ceil(1 << LOG_PACKING);
        if used_words > words_per_block {
            return 0;
        }
        let zero_words = words_per_block - used_words;
        if zero_words < num_ntts { zero_words } else { 0 }
    }
}

impl Drop for ZeroOddTailLanes {
    fn drop(&mut self) {
        ZERO_ODD_TAIL_LANES.store(self.0, std::sync::atomic::Ordering::Relaxed);
    }
}

#[inline]
fn row_lanes(r: usize, num_ntts: usize, odd_tail: usize) -> usize {
    if r & 1 == 1 {
        num_ntts - odd_tail
    } else {
        num_ntts
    }
}

#[inline]
#[cfg(any(
    test,
    all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )
))]
const fn direct_fused2_publish_shape(log_d: usize, num_ntts: usize, odd_tail: usize) -> bool {
    log_d == 20 && num_ntts == 64 && (odd_tail == 0 || odd_tail == 4)
}

#[inline]
const fn seed_top_stage_row(k: usize, permuted: bool) -> usize {
    if permuted { (k & 3) * 16 + (k >> 2) } else { k }
}

#[inline]
#[cfg(any(
    test,
    all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )
))]
const fn seed_top_codeword_row(
    block: usize,
    r: usize,
    k: usize,
    block_size: usize,
    sub_stride: usize,
) -> usize {
    block * block_size + r + k * sub_stride
}

#[derive(Clone, Debug)]
pub struct AdditiveNttF128 {
    evals: Arc<Vec<Vec<F128>>>,
    precomputed_twiddles: Option<Arc<[F128]>>,
}

#[cfg(target_arch = "x86_64")]
fn seed_pf_params() -> (usize, usize, bool) {
    static P: std::sync::LazyLock<(usize, usize, bool)> = std::sync::LazyLock::new(|| {
        if std::env::var_os("FLOCK_NO_NTT_SEED_PF").is_some() {
            return (0, 0, false);
        }
        let g = |k: &str, d: usize| {
            std::env::var(k)
                .ok()
                .and_then(|v| v.parse::<usize>().ok())
                .unwrap_or(d)
        };
        (
            g("FLOCK_NTT_SEED_PF_DIST", 1),
            g("FLOCK_NTT_SEED_PF_LINES", 8),
            std::env::var_os("FLOCK_NO_NTT_SEED_PF_SPREAD").is_none(),
        )
    });
    *P
}

#[cfg(target_arch = "x86_64")]
#[inline(always)]
unsafe fn pf_msg_rows(
    src: *const F128,
    row: usize,
    block_size: usize,
    row_len: usize,
    lines: usize,
) {
    use core::arch::x86_64::*;
    unsafe {
        for i in 0..4 {
            let p = src.add((i * block_size + row) * row_len) as *const i8;
            for l in 0..lines {
                _mm_prefetch::<_MM_HINT_T0>(p.add(l * 64));
            }
        }
    }
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
fn st_fmp_pairs() -> Option<&'static Vec<(usize, usize)>> {
    static P: std::sync::LazyLock<Option<Vec<(usize, usize)>>> = std::sync::LazyLock::new(|| {
        if std::env::var_os("FLOCK_NO_NTT_ST_FMP").is_some() {
            return None;
        }
        let n = rayon::current_num_threads();
        if n % 2 != 0 || n < 4 {
            return None;
        }
        let mut pairs: Vec<(usize, usize)> = Vec::with_capacity(n / 2);
        let mut seen = vec![false; n];
        for c in 0..n {
            if seen[c] {
                continue;
            }
            let list = std::fs::read_to_string(format!(
                "/sys/devices/system/cpu/cpu{c}/topology/thread_siblings_list"
            ))
            .ok()?;
            let mut ids = Vec::new();
            for part in list.trim().split(',') {
                ids.push(part.trim().parse::<usize>().ok()?);
            }
            if ids.len() != 2 || ids[0] != c || ids[1] >= n || seen[ids[1]] {
                return None;
            }
            seen[c] = true;
            seen[ids[1]] = true;
            pairs.push((ids[0], ids[1]));
        }
        if pairs.len() != n / 2 {
            return None;
        }
        let mask = affinity::get();
        for c in 0..n {
            if mask[c / 64] & (1u64 << (c % 64)) == 0 {
                return None;
            }
        }
        Some(pairs)
    });
    P.as_ref()
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
static ST_FMP_BUSY: std::sync::atomic::AtomicBool = std::sync::atomic::AtomicBool::new(false);

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
struct StFmpClaim;

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
impl StFmpClaim {
    fn take() -> Option<Self> {
        use std::sync::atomic::Ordering;
        ST_FMP_BUSY
            .compare_exchange(false, true, Ordering::AcqRel, Ordering::Acquire)
            .ok()
            .map(|_| Self)
    }
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
impl Drop for StFmpClaim {
    fn drop(&mut self) {
        ST_FMP_BUSY.store(false, std::sync::atomic::Ordering::Release);
    }
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
const ST_FMP_CAP: usize = 4;

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline]
fn select_st_fmp_bufs(requested: Option<usize>) -> usize {
    requested.unwrap_or(2).clamp(2, ST_FMP_CAP)
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
fn st_fmp_bufs() -> usize {
    static N: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
        select_st_fmp_bufs(
            std::env::var("FLOCK_NTT_ST_FMP_BUFS")
                .ok()
                .and_then(|v| v.parse::<usize>().ok()),
        )
    });
    *N
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[repr(align(64))]
struct StFmpPair {
    seeded: std::sync::atomic::AtomicUsize,
    folded: std::sync::atomic::AtomicUsize,
    total: std::sync::atomic::AtomicUsize,
    bufp: std::sync::atomic::AtomicUsize,
    f_gone: std::sync::atomic::AtomicBool,
    slot_r: [std::cell::UnsafeCell<usize>; ST_FMP_CAP],
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
unsafe impl Sync for StFmpPair {}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
impl StFmpPair {
    fn new() -> Self {
        use std::sync::atomic::{AtomicBool, AtomicUsize};
        Self {
            seeded: AtomicUsize::new(0),
            folded: AtomicUsize::new(0),
            total: AtomicUsize::new(usize::MAX),
            bufp: AtomicUsize::new(0),
            f_gone: AtomicBool::new(false),
            slot_r: [const { std::cell::UnsafeCell::new(0) }; ST_FMP_CAP],
        }
    }

    fn wait_folded(&self, k: usize) -> bool {
        use std::sync::atomic::Ordering;
        loop {
            if self.folded.load(Ordering::Acquire) >= k {
                return true;
            }
            if self.f_gone.load(Ordering::Acquire) {
                return self.folded.load(Ordering::Acquire) >= k;
            }
            std::hint::spin_loop();
        }
    }
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline(never)]
fn st_fmp_run(
    n_tasks: usize,
    row_len: usize,
    seed: &(dyn Fn(*mut F128, usize) + Sync),
    fold: &(dyn Fn(*mut F128, usize) + Sync),
    publish: &(dyn Fn(*mut F128, usize) + Sync),
    after: Option<&(dyn Fn(usize) + Sync)>,
) -> bool {
    use std::sync::atomic::{AtomicUsize, Ordering};
    let Some(pairs) = st_fmp_pairs() else {
        return false;
    };
    let n_pairs = pairs.len();
    let nbuf = st_fmp_bufs();
    if n_pairs * 2 != rayon::current_num_threads()
        || n_tasks < 4 * nbuf * n_pairs
        || !crate::owns_whole_pool()
    {
        return false;
    }
    let Some(_claim) = StFmpClaim::take() else {
        return false;
    };
    {
        static DBG: std::sync::LazyLock<bool> =
            std::sync::LazyLock::new(|| std::env::var_os("FLOCK_ST_FMP_DEBUG").is_some());
        if *DBG {
            eprintln!(
                "[st-fmp] engaged pairs={n_pairs} bufs={nbuf} tasks={n_tasks} row_len={row_len}"
            );
        }
    }
    let stride = 512 * row_len;
    let states: Vec<StFmpPair> = (0..n_pairs).map(|_| StFmpPair::new()).collect();
    let next = AtomicUsize::new(0);
    let states = &states;
    let next = &next;
    let st_body = |idx: usize| {
        if idx >= 2 * n_pairs {
            return;
        }
        let is_mp = idx < n_pairs;
        let slot = if is_mp { idx } else { idx - n_pairs };
        let st = &states[slot];
        let cpu = if is_mp { pairs[slot].0 } else { pairs[slot].1 };
        struct EndGuard {
            saved: affinity::Mask,
        }
        impl Drop for EndGuard {
            fn drop(&mut self) {
                affinity::set(&self.saved);
            }
        }
        let _end = EndGuard {
            saved: affinity::get(),
        };
        affinity::pin(cpu);

        if !is_mp {
            struct FGuard<'a> {
                st: &'a StFmpPair,
            }
            impl Drop for FGuard<'_> {
                fn drop(&mut self) {
                    self.st
                        .f_gone
                        .store(true, std::sync::atomic::Ordering::Release);
                }
            }
            let _fg = FGuard { st };
            let mut i = 0usize;
            loop {
                loop {
                    if st.seeded.load(Ordering::Acquire) > i {
                        break;
                    }
                    if st.total.load(Ordering::Acquire) <= i {
                        return;
                    }
                    std::hint::spin_loop();
                }
                let bufp = st.bufp.load(Ordering::Acquire) as *mut F128;
                let s = i % nbuf;
                unsafe {
                    fold(bufp.add(s * stride), *st.slot_r[s].get());
                }
                st.folded.store(i + 1, Ordering::Release);
                i += 1;
            }
        }

        let mut staging = staging_block(512 * nbuf, row_len);
        let bufp = staging.as_mut_ptr();
        st.bufp.store(bufp as usize, Ordering::Release);
        struct DrainGuard<'a> {
            st: &'a StFmpPair,
        }
        impl Drop for DrainGuard<'_> {
            fn drop(&mut self) {
                use std::sync::atomic::Ordering;
                self.st
                    .total
                    .store(self.st.seeded.load(Ordering::Relaxed), Ordering::Release);
                while !self.st.f_gone.load(Ordering::Acquire) {
                    std::hint::spin_loop();
                }
            }
        }
        let _drain = DrainGuard { st };
        let mut i = 0usize;
        loop {
            let r = next.fetch_add(1, Ordering::Relaxed);
            if r >= n_tasks {
                break;
            }
            if i >= nbuf {
                let j = i - nbuf;
                if !st.wait_folded(j + 1) {
                    return;
                }
                unsafe {
                    publish(bufp.add((j % nbuf) * stride), *st.slot_r[j % nbuf].get());
                }
            }
            let s = i % nbuf;
            unsafe {
                seed(bufp.add(s * stride), r);
                *st.slot_r[s].get() = r;
            }
            st.seeded.store(i + 1, Ordering::Release);
            i += 1;
        }
        st.total.store(i, Ordering::Release);
        for j in i.saturating_sub(nbuf)..i {
            if !st.wait_folded(j + 1) {
                return;
            }
            unsafe {
                publish(bufp.add((j % nbuf) * stride), *st.slot_r[j % nbuf].get());
            }
        }
    };
    let Some(after) = after else {
        rayon::broadcast(|ctx| st_body(ctx.index()));
        return true;
    };
    let arrived = AtomicUsize::new(0);
    let poisoned = std::sync::atomic::AtomicBool::new(false);
    let n_workers = 2 * n_pairs;
    rayon::broadcast(|ctx| {
        let idx = ctx.index();
        if idx >= n_workers {
            return;
        }
        struct Arrive<'a> {
            arrived: &'a AtomicUsize,
            poisoned: &'a std::sync::atomic::AtomicBool,
            n: usize,
        }
        impl Drop for Arrive<'_> {
            fn drop(&mut self) {
                use std::sync::atomic::Ordering;
                if std::thread::panicking() {
                    self.poisoned.store(true, Ordering::Release);
                }
                if self.arrived.fetch_add(1, Ordering::AcqRel) + 1 == self.n {
                    crate::gaptime::mark("ntt: seed+top fused pass done");
                }
            }
        }
        {
            let _arrive = Arrive {
                arrived: &arrived,
                poisoned: &poisoned,
                n: n_workers,
            };
            st_body(idx);
        }
        while arrived.load(Ordering::Acquire) < n_workers {
            std::hint::spin_loop();
        }
        if poisoned.load(Ordering::Acquire) {
            return;
        }
        after(idx);
    });
    true
}

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[target_feature(enable = "avx512f,vpclmulqdq")]
#[allow(clippy::too_many_arguments)]
#[inline]
unsafe fn st_fmp_fold4(
    bufp: *mut F128,
    row_len: usize,
    sub_stride: usize,
    r: usize,
    lanes4_tail: usize,
    stage_perm: bool,
    tw4: &[kernels::FourBlock],
) {
    let (g4_stride, g4_base): (usize, usize) = if stage_perm { (1, 16) } else { (4, 1) };
    unsafe {
        for block in 0..8 {
            let region = bufp.add(block * 64 * row_len);
            let tw = &tw4[block];
            for j in 0..4 {
                let lanes4 = row_lanes(r + j * sub_stride, row_len, lanes4_tail);
                kernels::butterfly_fused_4layer_cached(
                    region.add(j * g4_base * row_len),
                    g4_stride,
                    row_len,
                    lanes4,
                    0,
                    tw,
                );
            }
        }
    }
}

impl AdditiveNttF128 {
    pub fn new(basis: &[F128]) -> Self {
        let evals = Arc::new(generate_evals_from_subspace(basis));
        let precomputed_twiddles = precompute_twiddles(&evals).map(Arc::from);
        Self {
            evals,
            precomputed_twiddles,
        }
    }

    pub fn standard(dim: usize) -> Self {
        assert!(dim <= 64, "standard NTT requires dim ≤ 64");
        let evals = cached_standard_evals(dim);
        let precomputed_twiddles = cached_standard_twiddles(dim, &evals);
        Self {
            evals,
            precomputed_twiddles,
        }
    }

    #[inline]
    pub fn log_domain_size(&self) -> usize {
        self.evals.len()
    }

    #[inline]
    pub fn twiddle(&self, layer: usize, block: usize) -> F128 {
        debug_assert!(layer < self.log_domain_size());
        debug_assert!(block < 1usize << layer);
        if let Some(twiddles) = &self.precomputed_twiddles {
            return twiddles[(1usize << layer) - 1 + block];
        }
        let v = &self.evals[self.log_domain_size() - layer - 1];
        span_get(&v[1..], block)
    }

    pub fn forward_transform(&self, data: &mut [F128]) {
        #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
        {
            self.forward_transform_batched(data);
        }
        #[cfg(not(all(target_arch = "aarch64", target_feature = "aes")))]
        {
            self.forward_transform_scalar(data);
        }
    }

    pub fn forward_transform_interleaved(&self, data: &mut [F128], num_ntts: usize) {
        self.forward_transform_interleaved_from_layer(data, num_ntts, 0);
    }

    pub fn forward_transform_interleaved_from_layer(
        &self,
        data: &mut [F128],
        num_ntts: usize,
        start_layer: usize,
    ) {
        assert!(num_ntts.is_power_of_two() && num_ntts > 0);
        let n_total = data.len();
        assert_eq!(n_total % num_ntts, 0);
        let log_d = log2_pow2(n_total / num_ntts);
        assert!(log_d <= self.log_domain_size());
        assert!(start_layer <= log_d);

        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        {
            self.forward_transform_interleaved_parallel_from_layer(data, num_ntts, start_layer);
        }
        #[cfg(not(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        )))]
        {
            self.forward_transform_interleaved_scalar_from_layer(data, num_ntts, start_layer);
        }
    }

    pub(crate) fn rs_encode_interleaved(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
    ) {
        assert!(num_ntts.is_power_of_two() && num_ntts > 0);
        assert!(!msg.is_empty());
        assert_eq!(msg.len() % num_ntts, 0);
        assert_eq!(codeword.len() % msg.len(), 0);

        let inv_rate = codeword.len() / msg.len();
        assert!(inv_rate.is_power_of_two() && inv_rate > 1);
        let log_inv_rate = log2_pow2(inv_rate);
        let n_positions = codeword.len() / num_ntts;
        let log_d = log2_pow2(n_positions);
        assert!(log_inv_rate <= log_d);
        assert_eq!(msg.len() / num_ntts, 1usize << (log_d - log_inv_rate));
        assert!(log_d <= self.log_domain_size());

        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        if log_inv_rate == 1 && log_d >= 12 && !rate_half_seed_disabled() {
            self.seed_rate_half_then_transform(msg, codeword, num_ntts, log_d, None);
            return;
        }

        replicate_message_fill(codeword, msg);
        self.forward_transform_interleaved_from_layer(codeword, num_ntts, log_inv_rate);
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    fn seed_rate_half_then_transform(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
        log_d: usize,
        on_sub_done: Option<&(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync)>,
    ) {
        let n_top = Self::interleaved_n_top(log_d, num_ntts);
        let fuse_seed = Self::top_fusion_available()
            && !ntt_top_fusion_disabled()
            && !ntt_seed_top_fusion_disabled()
            && n_top >= 9
            && log_d >= 9;
        if fuse_seed {
            self.forward_transform_interleaved_parallel_from_layer_impl(
                codeword,
                num_ntts,
                3,
                None,
                on_sub_done,
                Some(msg),
            );
        } else {
            self.seed_rate_half_layers_1_through_2(msg, codeword, num_ntts);
            self.forward_transform_interleaved_parallel_from_layer_impl(
                codeword,
                num_ntts,
                3,
                None,
                on_sub_done,
                None,
            );
        }
    }

    #[inline]
    const fn top_fusion_available() -> bool {
        cfg!(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        )) || cfg!(test)
    }

    pub(crate) fn rs_encode_interleaved_on_range_done(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
        on_range_done: &(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync),
    ) {
        assert!(num_ntts.is_power_of_two() && num_ntts > 0);
        assert!(!msg.is_empty());
        assert_eq!(msg.len() % num_ntts, 0);
        assert_eq!(codeword.len() % msg.len(), 0);

        let inv_rate = codeword.len() / msg.len();
        assert!(inv_rate.is_power_of_two() && inv_rate > 1);
        let log_inv_rate = log2_pow2(inv_rate);
        let n_positions = codeword.len() / num_ntts;
        let log_d = log2_pow2(n_positions);
        assert!(log_inv_rate <= log_d);
        assert_eq!(msg.len() / num_ntts, 1usize << (log_d - log_inv_rate));
        assert!(log_d <= self.log_domain_size());

        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        if log_inv_rate == 1 && log_d >= 12 && !rate_half_seed_disabled() {
            self.seed_rate_half_then_transform(msg, codeword, num_ntts, log_d, Some(on_range_done));
            return;
        }

        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        if log_inv_rate >= 2
            && log_inv_rate + 2 <= log_d
            && msg.len() / num_ntts >= 4
            && !rate_seed_disabled()
        {
            self.seed_layers_pair_from_msg(msg, codeword, num_ntts, log_inv_rate);
            self.forward_transform_interleaved_parallel_from_layer_impl(
                codeword,
                num_ntts,
                log_inv_rate + 2,
                None,
                Some(on_range_done),
                None,
            );
            return;
        }

        static NTT_TIMING: std::sync::LazyLock<bool> =
            std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NTT_TIMING").is_some());
        let ntt_timing = *NTT_TIMING;
        let t_fill = std::time::Instant::now();
        replicate_message_fill(codeword, msg);
        let fill_ms = t_fill.elapsed().as_secs_f64() * 1e3;
        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        {
            let t_tr = std::time::Instant::now();
            self.forward_transform_interleaved_parallel_from_layer_impl(
                codeword,
                num_ntts,
                log_inv_rate,
                None,
                Some(on_range_done),
                None,
            );
            if ntt_timing {
                eprintln!(
                    "[ntt-timing] rs_encode_on_range_done log_d={log_d} n={num_ntts} rate=1/{}: fill {fill_ms:.2} ms transform {:.2} ms",
                    1usize << log_inv_rate,
                    t_tr.elapsed().as_secs_f64() * 1e3
                );
            }
        }
        #[cfg(not(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        )))]
        {
            self.forward_transform_interleaved_from_layer(codeword, num_ntts, log_inv_rate);
            on_range_done(0..n_positions, codeword);
        }
    }

    pub fn rs_encode_interleaved_streamed(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
        n_chunks: usize,
        on_chunk: &mut (dyn FnMut(usize, core::ops::Range<usize>) + Send),
    ) {
        assert!(num_ntts.is_power_of_two() && num_ntts > 0);
        assert!(!msg.is_empty());
        assert_eq!(msg.len() % num_ntts, 0);
        assert_eq!(codeword.len() % msg.len(), 0);

        let inv_rate = codeword.len() / msg.len();
        assert!(inv_rate.is_power_of_two() && inv_rate > 1);
        let log_inv_rate = log2_pow2(inv_rate);
        let n_positions = codeword.len() / num_ntts;
        let log_d = log2_pow2(n_positions);
        assert!(log_inv_rate <= log_d);
        assert_eq!(msg.len() / num_ntts, 1usize << (log_d - log_inv_rate));
        assert!(log_d <= self.log_domain_size());

        #[cfg(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        ))]
        {
            if log_inv_rate == 1 && log_d >= 12 && !rate_half_seed_disabled() {
                self.seed_rate_half_layers_1_through_2(msg, codeword, num_ntts);
                self.forward_transform_interleaved_parallel_from_layer_impl(
                    codeword,
                    num_ntts,
                    3,
                    Some((n_chunks, on_chunk)),
                    None,
                    None,
                );
                return;
            }
            replicate_message_fill(codeword, msg);
            self.forward_transform_interleaved_parallel_from_layer_impl(
                codeword,
                num_ntts,
                log_inv_rate,
                Some((n_chunks, on_chunk)),
                None,
                None,
            );
        }
        #[cfg(not(any(
            all(target_arch = "aarch64", target_feature = "aes"),
            all(target_arch = "x86_64", target_feature = "pclmulqdq"),
        )))]
        {
            let _ = n_chunks;
            replicate_message_fill(codeword, msg);
            self.forward_transform_interleaved_scalar_from_layer(codeword, num_ntts, log_inv_rate);
            on_chunk(0, 0..n_positions);
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    fn seed_rate_half_layers_1_through_2(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
    ) {
        self.seed_layers_pair_from_msg(msg, codeword, num_ntts, 1);
    }

    fn seed_layers_pair_from_msg(
        &self,
        msg: &[F128],
        codeword: &mut [F128],
        num_ntts: usize,
        k: usize,
    ) {
        use rayon::prelude::*;

        let blocks = codeword.len() / msg.len();
        debug_assert_eq!(blocks, 1usize << k);
        let msg_positions = msg.len() / num_ntts;
        debug_assert!(msg_positions >= 4 && msg_positions.is_power_of_two());
        let quarter = msg_positions >> 2;

        let twiddles: Vec<[F128; 3]> = (0..blocks)
            .map(|block| {
                [
                    self.twiddle(k, block),
                    self.twiddle(k + 1, 2 * block),
                    self.twiddle(k + 1, 2 * block + 1),
                ]
            })
            .collect();
        debug_assert_eq!(twiddles[0][0], F128::ZERO);
        debug_assert_eq!(twiddles[0][1], F128::ZERO);

        let src = msg.as_ptr() as usize;
        let dst = codeword.as_mut_ptr() as usize;
        let msg_len = msg.len();
        #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
        let use_nt = blocks == 2
            && num_ntts % 8 == 0
            && num_ntts <= kernels::SEED_NT_MAX_NTTS
            && dst % 128 == 0
            && (msg_len * core::mem::size_of::<F128>()) % 128 == 0
            && seed_nt_enabled();
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let use_nt = dst % 16 == 0 && num_ntts.is_multiple_of(4) && seed_nt_enabled();
        let twiddles = &twiddles;
        let seed_row = |r| unsafe {
            #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
            if use_nt {
                kernels::seed_fused_2layer_row_group_nt(
                    src as *const F128,
                    dst as *mut F128,
                    quarter,
                    num_ntts,
                    msg_len,
                    r,
                    twiddles[0][2],
                    &twiddles[1],
                );
                return;
            }
            #[cfg(all(
                target_arch = "x86_64",
                target_feature = "avx512f",
                target_feature = "vpclmulqdq"
            ))]
            if use_nt {
                kernels::butterfly_fused_2layer_row_from_sparse_nt(
                    src as *const F128,
                    dst as *mut F128,
                    quarter,
                    num_ntts,
                    r,
                    twiddles[0][2],
                );
                for (b, tw) in twiddles.iter().enumerate().skip(1) {
                    kernels::butterfly_fused_2layer_row_from_nt(
                        src as *const F128,
                        (dst as *mut F128).add(b * msg_len),
                        quarter,
                        num_ntts,
                        r,
                        tw,
                    );
                }
                return;
            }
            kernels::butterfly_fused_2layer_row_from_sparse(
                src as *const F128,
                dst as *mut F128,
                quarter,
                num_ntts,
                r,
                twiddles[0][2],
            );
            for (b, tw) in twiddles.iter().enumerate().skip(1) {
                kernels::butterfly_fused_2layer_row_from(
                    src as *const F128,
                    (dst as *mut F128).add(b * msg_len),
                    quarter,
                    num_ntts,
                    r,
                    tw,
                );
            }
        };

        const PARALLEL_ROW_THRESHOLD: usize = 256;
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        struct SeedNtFence;
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        impl Drop for SeedNtFence {
            fn drop(&mut self) {
                unsafe { core::arch::x86_64::_mm_sfence() };
            }
        }
        if quarter < PARALLEL_ROW_THRESHOLD {
            for r in 0..quarter {
                seed_row(r);
            }
            #[cfg(all(
                target_arch = "x86_64",
                target_feature = "avx512f",
                target_feature = "vpclmulqdq"
            ))]
            if use_nt {
                unsafe { core::arch::x86_64::_mm_sfence() };
            }
        } else {
            #[cfg(all(
                target_arch = "x86_64",
                target_feature = "avx512f",
                target_feature = "vpclmulqdq"
            ))]
            if use_nt {
                (0..quarter)
                    .into_par_iter()
                    .for_each_init(|| SeedNtFence, |_, r| seed_row(r));
            } else {
                (0..quarter).into_par_iter().for_each(seed_row);
            }
            #[cfg(not(all(
                target_arch = "x86_64",
                target_feature = "avx512f",
                target_feature = "vpclmulqdq"
            )))]
            (0..quarter).into_par_iter().for_each(seed_row);
        }
    }

    fn top_fused6_pass(
        &self,
        data: &mut [F128],
        num_ntts: usize,
        layer: usize,
        log_d: usize,
        odd_tail: usize,
    ) {
        use rayon::prelude::*;
        #[cfg(test)]
        TOP_FUSION_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        debug_assert!(layer + 6 <= log_d);
        let num_blocks = 1usize << layer;
        let block_size = 1usize << (log_d - layer);
        let block_bytes = block_size * num_ntts;
        let sub_stride = block_size >> 6;
        debug_assert!(sub_stride >= 1);
        let sixteenth = block_size >> 4;
        let quarter = sub_stride;
        let lanes4_tail = if sixteenth.is_multiple_of(2) {
            odd_tail
        } else {
            0
        };
        let lanes2_tail = if quarter.is_multiple_of(2) {
            odd_tail
        } else {
            0
        };

        let tw4: Vec<kernels::FourBlock> = (0..num_blocks)
            .map(|block| {
                let mut tw = [F128 { lo: 0, hi: 0 }; 15];
                tw[0] = self.twiddle(layer, block);
                for s in 0..2 {
                    tw[1 + s] = self.twiddle(layer + 1, 2 * block + s);
                }
                for s in 0..4 {
                    tw[3 + s] = self.twiddle(layer + 2, 4 * block + s);
                }
                for s in 0..8 {
                    tw[7 + s] = self.twiddle(layer + 3, 8 * block + s);
                }
                kernels::FourBlock::new(tw)
            })
            .collect();

        let base_addr = data.as_mut_ptr() as usize;
        let n_tasks = num_blocks * sub_stride;
        let row_len = num_ntts;
        let task = |buf: &mut Vec<F128>, idx: usize| {
            let block = idx / sub_stride;
            let r = idx % sub_stride;
            let block_start = block * block_bytes;
            let lanes2 = row_lanes(r, num_ntts, lanes2_tail);
            unsafe {
                let base = base_addr as *mut F128;
                let row_ptr = |k: usize| base.add(block_start + (r + k * sub_stride) * row_len);
                for k in 0..64 {
                    core::ptr::copy_nonoverlapping(
                        row_ptr(k),
                        buf.as_mut_ptr().add(k * row_len),
                        row_len,
                    );
                }
                let tw = &tw4[block];
                for j in 0..4 {
                    let lanes4 = row_lanes(r + j * sub_stride, num_ntts, lanes4_tail);
                    kernels::butterfly_fused_4layer_cached(
                        buf.as_mut_ptr(),
                        4,
                        row_len,
                        lanes4,
                        j,
                        tw,
                    );
                }
                for m in 0..16 {
                    let outer_block = block * 16 + m;
                    let t_outer = self.twiddle(layer + 4, outer_block);
                    let t_inner_a = self.twiddle(layer + 5, 2 * outer_block);
                    let t_inner_b = self.twiddle(layer + 5, 2 * outer_block + 1);
                    let p = buf.as_mut_ptr().add(4 * m * row_len);
                    let a = std::slice::from_raw_parts_mut(p, lanes2);
                    let b = std::slice::from_raw_parts_mut(p.add(row_len), lanes2);
                    let c = std::slice::from_raw_parts_mut(p.add(2 * row_len), lanes2);
                    let d = std::slice::from_raw_parts_mut(p.add(3 * row_len), lanes2);
                    kernels::butterfly_fused_2layer(a, b, c, d, t_outer, t_inner_a, t_inner_b);
                }
                for k in 0..64 {
                    core::ptr::copy_nonoverlapping(
                        buf.as_ptr().add(k * row_len),
                        row_ptr(k),
                        row_len,
                    );
                }
            }
        };

        const PARALLEL_TASK_THRESHOLD: usize = 32;
        if n_tasks < PARALLEL_TASK_THRESHOLD {
            let mut buf = staging_block(64, row_len);
            for idx in 0..n_tasks {
                task(&mut buf, idx);
            }
        } else {
            (0..n_tasks)
                .into_par_iter()
                .for_each_init(|| staging_block(64, row_len), |buf, idx| task(buf, idx));
        }
    }

    #[cfg(target_arch = "x86_64")]
    fn scatter_nt_enabled() -> bool {
        static ON: std::sync::LazyLock<bool> =
            std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_SCATTER_NT").is_none());
        *ON
    }

    fn stage_perm_enabled() -> bool {
        static ON: std::sync::LazyLock<bool> =
            std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_STAGE_PERM").is_none());
        *ON
    }

    #[cfg(target_arch = "x86_64")]
    #[inline]
    unsafe fn publish_row_nt(src: *const F128, dst: *mut F128, row_len: usize) {
        use core::arch::x86_64::*;
        unsafe {
            #[cfg(target_feature = "avx512f")]
            if dst as usize % 64 == 0 {
                let s = src as *const __m512i;
                let d = dst as *mut __m512i;
                for i in 0..row_len / 4 {
                    _mm512_stream_si512(d.add(i), _mm512_loadu_si512(s.add(i)));
                }
                let done = (row_len / 4) * 4;
                let s = src as *const __m128i;
                let d = dst as *mut __m128i;
                for i in done..row_len {
                    _mm_stream_si128(d.add(i), _mm_loadu_si128(s.add(i)));
                }
                return;
            }
            let s = src as *const __m128i;
            let d = dst as *mut __m128i;
            for i in 0..row_len {
                _mm_stream_si128(d.add(i), _mm_loadu_si128(s.add(i)));
            }
        }
    }

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[target_feature(enable = "avx512f,vpclmulqdq")]
    #[allow(clippy::too_many_arguments)]
    #[inline]
    unsafe fn seed_top_direct_fused2_publish<const ALIGNED_ZMM: bool>(
        &self,
        bufp: *mut F128,
        base: *mut F128,
        row_len: usize,
        block_size: usize,
        sub_stride: usize,
        r: usize,
        lanes2: usize,
        lanes4_tail: usize,
        stage_perm: bool,
        tw4: &[kernels::FourBlock],
        tw2: &[[[F128; 3]; 16]],
    ) {
        debug_assert_eq!(row_len, 64);
        debug_assert_eq!(block_size, 1 << 17);
        debug_assert_eq!(sub_stride, 1 << 11);
        debug_assert!(lanes2 == 60 || lanes2 == 64);
        debug_assert!(lanes2 == 64 || lanes4_tail == 4);
        debug_assert_eq!(base as usize % 16, 0);
        debug_assert!(!ALIGNED_ZMM || base as usize % 64 == 0);
        let (g4_stride, g4_base): (usize, usize) = if stage_perm { (1, 16) } else { (4, 1) };

        unsafe {
            for block in 0..8 {
                let region = bufp.add(block * 64 * row_len);
                let tw = &tw4[block];
                for j in 0..4 {
                    let lanes4 = row_lanes(r + j * sub_stride, row_len, lanes4_tail);
                    kernels::butterfly_fused_4layer_cached(
                        region.add(j * g4_base * row_len),
                        g4_stride,
                        row_len,
                        lanes4,
                        0,
                        tw,
                    );
                }
                self.seed_top_publish2_block::<ALIGNED_ZMM>(
                    region,
                    base,
                    block,
                    row_len,
                    block_size,
                    sub_stride,
                    r,
                    lanes2,
                    stage_perm,
                    &tw2[block],
                );
            }
        }
    }

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[target_feature(enable = "avx512f,vpclmulqdq")]
    #[allow(clippy::too_many_arguments)]
    #[inline]
    unsafe fn seed_top_direct_publish2<const ALIGNED_ZMM: bool>(
        &self,
        bufp: *mut F128,
        base: *mut F128,
        row_len: usize,
        block_size: usize,
        sub_stride: usize,
        r: usize,
        lanes2: usize,
        stage_perm: bool,
        tw2: &[[[F128; 3]; 16]],
    ) {
        debug_assert_eq!(row_len, 64);
        debug_assert_eq!(block_size, 1 << 17);
        debug_assert_eq!(sub_stride, 1 << 11);
        debug_assert!(lanes2 == 60 || lanes2 == 64);
        debug_assert_eq!(base as usize % 16, 0);
        debug_assert!(!ALIGNED_ZMM || base as usize % 64 == 0);
        unsafe {
            for block in 0..8 {
                let region = bufp.add(block * 64 * row_len);
                self.seed_top_publish2_block::<ALIGNED_ZMM>(
                    region,
                    base,
                    block,
                    row_len,
                    block_size,
                    sub_stride,
                    r,
                    lanes2,
                    stage_perm,
                    &tw2[block],
                );
            }
        }
    }

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[allow(clippy::too_many_arguments)]
    #[inline(never)]
    unsafe fn seed_top_publish2_block<const ALIGNED_ZMM: bool>(
        &self,
        region: *mut F128,
        base: *mut F128,
        block: usize,
        row_len: usize,
        block_size: usize,
        sub_stride: usize,
        r: usize,
        lanes2: usize,
        stage_perm: bool,
        tw2_block: &[[F128; 3]; 16],
    ) {
        let g2_stride: usize = if stage_perm { 16 } else { 1 };
        unsafe {
            for (m, &[t_outer, t_inner_a, t_inner_b]) in tw2_block.iter().enumerate() {
                let k = 4 * m;
                let p = region.add(seed_top_stage_row(k, stage_perm) * row_len);
                let step = g2_stride * row_len;
                let dst = |k: usize| {
                    base.add(seed_top_codeword_row(block, r, k, block_size, sub_stride) * row_len)
                };
                kernels::butterfly_fused_2layer_publish_nt::<ALIGNED_ZMM>(
                    p,
                    step,
                    dst(k),
                    dst(k + 1),
                    dst(k + 2),
                    dst(k + 3),
                    lanes2,
                    t_outer,
                    t_inner_a,
                    t_inner_b,
                );
            }
        }
    }

    #[allow(clippy::manual_is_multiple_of)]
    fn seed_top_fused8_pass(
        &self,
        msg: &[F128],
        data: &mut [F128],
        num_ntts: usize,
        log_d: usize,
        odd_tail: usize,
        after: Option<&(dyn Fn(usize) + Sync)>,
    ) -> bool {
        use rayon::prelude::*;
        #[cfg(test)]
        SEED_TOP_FUSION_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        const LAYER: usize = 3;
        debug_assert!(log_d >= 9);
        debug_assert_eq!(data.len(), 2 * msg.len());
        let block_size = 1usize << (log_d - LAYER);
        let msg_positions = msg.len() / num_ntts;
        debug_assert_eq!(msg_positions >> 2, block_size);
        let block_bytes = block_size * num_ntts;
        let sub_stride = block_size >> 6;
        debug_assert!(sub_stride >= 1);
        let sixteenth = block_size >> 4;
        let quarter = sub_stride;
        let lanes4_tail = if sixteenth.is_multiple_of(2) {
            odd_tail
        } else {
            0
        };
        let lanes2_tail = if quarter.is_multiple_of(2) {
            odd_tail
        } else {
            0
        };
        let row_len = num_ntts;

        let mut seed_tw = [[F128::ZERO; 3]; 2];
        for (block, tw) in seed_tw.iter_mut().enumerate() {
            tw[0] = self.twiddle(1, block);
            for s in 0..2 {
                tw[1 + s] = self.twiddle(2, 2 * block + s);
            }
        }
        debug_assert_eq!(seed_tw[0][0], F128::ZERO);
        debug_assert_eq!(seed_tw[0][1], F128::ZERO);
        let seed_right = seed_tw[0][2];
        let seed_dense = seed_tw[1];

        let tw4: Vec<kernels::FourBlock> = (0..8)
            .map(|block| {
                let mut tw = [F128 { lo: 0, hi: 0 }; 15];
                tw[0] = self.twiddle(LAYER, block);
                for s in 0..2 {
                    tw[1 + s] = self.twiddle(LAYER + 1, 2 * block + s);
                }
                for s in 0..4 {
                    tw[3 + s] = self.twiddle(LAYER + 2, 4 * block + s);
                }
                for s in 0..8 {
                    tw[7 + s] = self.twiddle(LAYER + 3, 8 * block + s);
                }
                kernels::FourBlock::new(tw)
            })
            .collect();

        let tw2: Vec<[[F128; 3]; 16]> = (0..8)
            .map(|block| {
                core::array::from_fn(|m| {
                    let outer_block = block * 16 + m;
                    [
                        self.twiddle(LAYER + 4, outer_block),
                        self.twiddle(LAYER + 5, 2 * outer_block),
                        self.twiddle(LAYER + 5, 2 * outer_block + 1),
                    ]
                })
            })
            .collect();

        let src_addr = msg.as_ptr() as usize;
        let base_addr = data.as_mut_ptr() as usize;
        #[cfg(target_arch = "x86_64")]
        let publish_nt = Self::scatter_nt_enabled() && base_addr % 16 == 0;
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let direct_publish = publish_nt
            && direct_fused2_publish_shape(log_d, num_ntts, odd_tail)
            && !ntt_direct_fused2_publish_disabled();
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let direct_publish_zmm = direct_publish && base_addr % 64 == 0;
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let seed_odd_tail = direct_publish && odd_tail == 4 && !ntt_seed_odd_tail_disabled();
        let stage_perm = Self::stage_perm_enabled();
        #[cfg(target_arch = "x86_64")]
        let (pf_dist, pf_lines, pf_spread) = seed_pf_params();
        let perm = |k: usize| seed_top_stage_row(k, stage_perm);
        let (g4_stride, g4_base, g2_stride): (usize, usize, usize) =
            if stage_perm { (1, 16, 16) } else { (4, 1, 1) };
        let seed = |bufp: *mut F128, r: usize| unsafe {
            let src = src_addr as *const F128;
            #[cfg(target_arch = "x86_64")]
            if pf_dist != 0 {
                for k in 0..pf_dist.min(64) {
                    pf_msg_rows(src, r + k * sub_stride, block_size, row_len, pf_lines);
                }
            }
            static PF2: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
                std::env::var("DIAG_PF2")
                    .ok()
                    .and_then(|v| v.parse().ok())
                    .unwrap_or(0)
            });
            static PF2L: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
                std::env::var("DIAG_PF2L")
                    .ok()
                    .and_then(|v| v.parse().ok())
                    .unwrap_or(16)
            });
            let pf2 = *PF2;
            if pf2 != 0 {
                for k in 1..pf2.min(64) {
                    for i in 0..4 {
                        let p =
                            src.add((i * block_size + r + k * sub_stride) * row_len) as *const i8;
                        for l in 0..*PF2L {
                            core::arch::x86_64::_mm_prefetch::<{ core::arch::x86_64::_MM_HINT_T1 }>(
                                p.add(l * 64),
                            );
                        }
                    }
                }
            }
            for k in 0..64 {
                let r_s = r + k * sub_stride;
                let kp = perm(k);
                if pf2 != 0 && k + pf2 < 64 {
                    for i in 0..4 {
                        let p = src.add((i * block_size + r_s + pf2 * sub_stride) * row_len)
                            as *const i8;
                        for l in 0..*PF2L {
                            core::arch::x86_64::_mm_prefetch::<{ core::arch::x86_64::_MM_HINT_T1 }>(
                                p.add(l * 64),
                            );
                        }
                    }
                }
                let mut pf_next: *const F128 = core::ptr::null();
                #[cfg(target_arch = "x86_64")]
                if pf_dist != 0 && k + pf_dist < 64 {
                    if pf_spread {
                        pf_next = src.add((r_s + pf_dist * sub_stride) * row_len);
                    } else {
                        pf_msg_rows(
                            src,
                            r_s + pf_dist * sub_stride,
                            block_size,
                            row_len,
                            pf_lines,
                        );
                    }
                }
                #[cfg(all(
                    target_arch = "x86_64",
                    target_feature = "avx512f",
                    target_feature = "vpclmulqdq"
                ))]
                if !ntt_seed_hold4_disabled() {
                    let seed_active_lanes = if seed_odd_tail && r & 1 == 1 {
                        row_len - odd_tail
                    } else {
                        row_len
                    };
                    static NOREAD: std::sync::LazyLock<bool> =
                        std::sync::LazyLock::new(|| std::env::var_os("DIAG_NOREAD").is_some());
                    let (q_, rs_, pf_) = if *NOREAD {
                        (1024usize, r_s & 1023, core::ptr::null())
                    } else {
                        (block_size, r_s, pf_next)
                    };
                    kernels::butterfly_fused_2layer_row_from_sparse_dense_geo(
                        src,
                        q_,
                        rs_,
                        bufp.add(kp * row_len),
                        bufp.add((256 + kp) * row_len),
                        64,
                        row_len,
                        seed_active_lanes,
                        seed_right,
                        &seed_dense,
                        pf_,
                    );
                } else if pf_next.is_null() {
                    kernels::butterfly_fused_2layer_row_from_sparse_geo(
                        src,
                        block_size,
                        r_s,
                        bufp.add(kp * row_len),
                        64,
                        0,
                        row_len,
                        seed_right,
                    );
                    kernels::butterfly_fused_2layer_row_from_geo(
                        src,
                        block_size,
                        r_s,
                        bufp.add((256 + kp) * row_len),
                        64,
                        0,
                        row_len,
                        &seed_dense,
                    );
                } else {
                    kernels::butterfly_fused_2layer_row_from_sparse_geo_pf(
                        src,
                        block_size,
                        r_s,
                        bufp.add(kp * row_len),
                        64,
                        0,
                        row_len,
                        seed_right,
                        pf_next,
                    );
                    kernels::butterfly_fused_2layer_row_from_geo(
                        src,
                        block_size,
                        r_s,
                        bufp.add((256 + kp) * row_len),
                        64,
                        0,
                        row_len,
                        &seed_dense,
                    );
                }
                #[cfg(not(all(
                    target_arch = "x86_64",
                    target_feature = "avx512f",
                    target_feature = "vpclmulqdq"
                )))]
                {
                    if pf_next.is_null() {
                        kernels::butterfly_fused_2layer_row_from_sparse_geo(
                            src,
                            block_size,
                            r_s,
                            bufp.add(kp * row_len),
                            64,
                            0,
                            row_len,
                            seed_right,
                        );
                    } else {
                        kernels::butterfly_fused_2layer_row_from_sparse_geo_pf(
                            src,
                            block_size,
                            r_s,
                            bufp.add(kp * row_len),
                            64,
                            0,
                            row_len,
                            seed_right,
                            pf_next,
                        );
                    }
                    kernels::butterfly_fused_2layer_row_from_geo(
                        src,
                        block_size,
                        r_s,
                        bufp.add((256 + kp) * row_len),
                        64,
                        0,
                        row_len,
                        &seed_dense,
                    );
                }
            }
        };
        let task = |buf: &mut Vec<F128>, r: usize| {
            let lanes2 = row_lanes(r, num_ntts, lanes2_tail);
            let bufp = buf.as_mut_ptr();
            seed(bufp, r);
            unsafe {
                let base = base_addr as *mut F128;
                #[cfg(all(
                    target_arch = "x86_64",
                    target_feature = "avx512f",
                    target_feature = "vpclmulqdq"
                ))]
                if direct_publish {
                    if direct_publish_zmm {
                        self.seed_top_direct_fused2_publish::<true>(
                            bufp,
                            base,
                            row_len,
                            block_size,
                            sub_stride,
                            r,
                            lanes2,
                            lanes4_tail,
                            stage_perm,
                            &tw4,
                            &tw2,
                        );
                    } else {
                        self.seed_top_direct_fused2_publish::<false>(
                            bufp,
                            base,
                            row_len,
                            block_size,
                            sub_stride,
                            r,
                            lanes2,
                            lanes4_tail,
                            stage_perm,
                            &tw4,
                            &tw2,
                        );
                    }
                    core::arch::x86_64::_mm_sfence();
                    return;
                }
                for block in 0..8 {
                    let region = bufp.add(block * 64 * row_len);
                    let tw = &tw4[block];
                    for j in 0..4 {
                        let lanes4 = row_lanes(r + j * sub_stride, num_ntts, lanes4_tail);
                        kernels::butterfly_fused_4layer_cached(
                            region.add(j * g4_base * row_len),
                            g4_stride,
                            row_len,
                            lanes4,
                            0,
                            tw,
                        );
                    }
                    for (m, &[t_outer, t_inner_a, t_inner_b]) in tw2[block].iter().enumerate() {
                        let p = region.add(perm(4 * m) * row_len);
                        let step = g2_stride * row_len;
                        let a = std::slice::from_raw_parts_mut(p, lanes2);
                        let b = std::slice::from_raw_parts_mut(p.add(step), lanes2);
                        let c = std::slice::from_raw_parts_mut(p.add(2 * step), lanes2);
                        let d = std::slice::from_raw_parts_mut(p.add(3 * step), lanes2);
                        kernels::butterfly_fused_2layer(a, b, c, d, t_outer, t_inner_a, t_inner_b);
                    }
                }
                #[cfg(target_arch = "x86_64")]
                if publish_nt {
                    for block in 0..8 {
                        for k in 0..64 {
                            Self::publish_row_nt(
                                bufp.add((block * 64 + perm(k)) * row_len),
                                base.add(block * block_bytes + (r + k * sub_stride) * row_len),
                                row_len,
                            );
                        }
                    }
                    core::arch::x86_64::_mm_sfence();
                    return;
                }
                for block in 0..8 {
                    for k in 0..64 {
                        core::ptr::copy_nonoverlapping(
                            bufp.add((block * 64 + perm(k)) * row_len),
                            base.add(block * block_bytes + (r + k * sub_stride) * row_len),
                            row_len,
                        );
                    }
                }
            }
        };

        #[cfg(all(
            target_os = "linux",
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let fold4 = |bufp: *mut F128, r: usize| unsafe {
            st_fmp_fold4(bufp, row_len, sub_stride, r, lanes4_tail, stage_perm, &tw4);
        };
        #[cfg(all(
            target_os = "linux",
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        let publish2 = |bufp: *mut F128, r: usize| {
            let lanes2 = row_lanes(r, num_ntts, lanes2_tail);
            unsafe {
                let base = base_addr as *mut F128;
                if direct_publish_zmm {
                    self.seed_top_direct_publish2::<true>(
                        bufp, base, row_len, block_size, sub_stride, r, lanes2, stage_perm, &tw2,
                    );
                } else {
                    self.seed_top_direct_publish2::<false>(
                        bufp, base, row_len, block_size, sub_stride, r, lanes2, stage_perm, &tw2,
                    );
                }
                core::arch::x86_64::_mm_sfence();
            }
        };

        const PARALLEL_TASK_THRESHOLD: usize = 32;
        if sub_stride < PARALLEL_TASK_THRESHOLD {
            let mut buf = staging_block(512, row_len);
            for r in 0..sub_stride {
                task(&mut buf, r);
            }
        } else {
            #[cfg(all(
                target_os = "linux",
                target_arch = "x86_64",
                target_feature = "avx512f",
                target_feature = "vpclmulqdq"
            ))]
            if direct_publish && st_fmp_run(sub_stride, row_len, &seed, &fold4, &publish2, after) {
                return after.is_some();
            }
            (0..sub_stride)
                .into_par_iter()
                .for_each_init(|| staging_block(512, row_len), |buf, r| task(buf, r));
        }
        let _ = after;
        false
    }

    pub fn forward_transform_interleaved_scalar(&self, data: &mut [F128], num_ntts: usize) {
        self.forward_transform_interleaved_scalar_from_layer(data, num_ntts, 0);
    }

    pub fn forward_transform_interleaved_scalar_from_layer(
        &self,
        data: &mut [F128],
        num_ntts: usize,
        start_layer: usize,
    ) {
        let n_total = data.len();
        let log_d = log2_pow2(n_total / num_ntts);

        for layer in start_layer..log_d {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_size_half = block_size >> 1;
            let block_size_bytes = block_size * num_ntts;
            for block in 0..num_blocks {
                let twiddle = self.twiddle(layer, block);
                let block_start = block * block_size_bytes;
                for row in 0..block_size_half {
                    let off_top = block_start + row * num_ntts;
                    let off_bot = off_top + block_size_half * num_ntts;
                    for lane in 0..num_ntts {
                        let v = data[off_bot + lane];
                        let new_u = data[off_top + lane] + v * twiddle;
                        data[off_top + lane] = new_u;
                        data[off_bot + lane] = v + new_u;
                    }
                }
            }
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    pub fn forward_transform_interleaved_parallel(&self, data: &mut [F128], num_ntts: usize) {
        self.forward_transform_interleaved_parallel_from_layer(data, num_ntts, 0);
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    pub fn forward_transform_interleaved_parallel_from_layer(
        &self,
        data: &mut [F128],
        num_ntts: usize,
        start_layer: usize,
    ) {
        self.forward_transform_interleaved_parallel_from_layer_impl(
            data,
            num_ntts,
            start_layer,
            None,
            None,
            None,
        );
    }

    fn interleaved_n_top(log_d: usize, num_ntts: usize) -> usize {
        let target_subgroup_log_bytes: usize = {
            static V: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
                std::env::var("FLOCK_NTT_SUBGROUP_LOG")
                    .ok()
                    .and_then(|s| s.parse().ok())
                    .filter(|v| (14..=24).contains(v))
                    .unwrap_or(21)
            });
            *V
        };
        let log_bytes_per_position = 4 + log2_pow2(num_ntts);
        let target_log_positions = target_subgroup_log_bytes.saturating_sub(log_bytes_per_position);
        let cache_n_top = log_d.saturating_sub(target_log_positions);

        const PARALLEL_FLOOR_LOG_D: usize = 12;
        const MIN_SUB_LOG: usize = 8;
        if log_d >= PARALLEL_FLOOR_LOG_D {
            let want_subs_log = log2_pow2(rayon::current_num_threads().next_power_of_two());
            let max_n_top = log_d.saturating_sub(MIN_SUB_LOG);
            cache_n_top.max(want_subs_log.min(max_n_top))
        } else {
            cache_n_top
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[allow(
        clippy::collapsible_if,
        clippy::manual_option_zip,
        clippy::unnecessary_unwrap
    )]
    fn forward_transform_interleaved_parallel_from_layer_impl(
        &self,
        data: &mut [F128],
        num_ntts: usize,
        start_layer: usize,
        stream: Option<(
            usize,
            &mut (dyn FnMut(usize, core::ops::Range<usize>) + Send),
        )>,
        on_sub_done: Option<&(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync)>,
        seed_msg: Option<&[F128]>,
    ) {
        use rayon::prelude::*;
        let n_total = data.len();
        let log_d = log2_pow2(n_total / num_ntts);
        let odd_tail = ranked_zero_odd_tail_lanes(log_d, num_ntts);

        let mut n_top = Self::interleaved_n_top(log_d, num_ntts);
        if n_top == start_layer + 1 && n_top + 1 + 8 <= log_d && !ntt_lone_top_bump_disabled() {
            n_top += 1;
        }
        let top_fusion_ok =
            Self::top_fusion_available() && stream.is_none() && !ntt_top_fusion_disabled();
        let mut seed_msg = seed_msg;
        if let Some(msg) = seed_msg {
            let fits = start_layer == 3 && top_fusion_ok && n_top >= 9 && log_d >= 9;
            if !fits {
                self.seed_rate_half_layers_1_through_2(msg, data, num_ntts);
                seed_msg = None;
            }
        }
        if n_top == 0 || log_d < 8 {
            self.forward_transform_interleaved_scalar_from_layer(data, num_ntts, start_layer);
            let n_positions = n_total / num_ntts;
            if let Some(cb) = on_sub_done {
                cb(0..n_positions, data);
            }
            if let Some((_, on_chunk)) = stream {
                on_chunk(0, 0..n_positions);
            }
            return;
        }

        let fused4_ok = cfg!(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ));
        let deep_fused4_ok = fused4_ok || cfg!(test);
        let sub_size_positions = 1usize << (log_d - n_top);
        let sub_bytes = sub_size_positions * num_ntts;

        let fuse_blocks = deep_fused4_ok
            && log_d == n_top + 11
            && start_layer <= n_top
            && !ntt_fused3_disabled()
            && deep_block_fuse_enabled();

        let deep_sub = |sub_idx: usize,
                        sub_data: &mut [F128],
                        block_cb: Option<&(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync)>,
                        hint: u8|
         -> bool {
            if fuse_blocks && let Some(cb) = block_cb {
                #[cfg(all(
                    target_arch = "x86_64",
                    target_feature = "avx512f",
                    target_feature = "vpclmulqdq"
                ))]
                return unsafe {
                    self.deep_sub_fused_blocks_x86(
                        sub_idx,
                        sub_data,
                        cb,
                        n_top,
                        log_d,
                        num_ntts,
                        odd_tail,
                        sub_size_positions,
                        hint,
                    )
                };
                #[cfg(not(all(
                    target_arch = "x86_64",
                    target_feature = "avx512f",
                    target_feature = "vpclmulqdq"
                )))]
                return self.deep_sub_fused_blocks_fallback(
                    sub_idx,
                    sub_data,
                    cb,
                    n_top,
                    log_d,
                    num_ntts,
                    odd_tail,
                    sub_size_positions,
                    hint,
                );
            }
            if deep_fused4_ok {
                let mut layer = n_top.max(start_layer);
                while layer < log_d {
                    let layer_in_sub = layer - n_top;
                    let num_blocks_in_sub = 1usize << layer_in_sub;
                    let block_size = 1usize << (log_d - layer);
                    let block_bytes = block_size * num_ntts;

                    if layer + 3 < log_d {
                        let sixteenth = block_size >> 4;
                        for block_in_sub in 0..num_blocks_in_sub {
                            let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                            let mut tw = [F128 { lo: 0, hi: 0 }; 15];
                            tw[0] = self.twiddle(layer, global_block);
                            for s in 0..2 {
                                tw[1 + s] = self.twiddle(layer + 1, 2 * global_block + s);
                            }
                            for s in 0..4 {
                                tw[3 + s] = self.twiddle(layer + 2, 4 * global_block + s);
                            }
                            for s in 0..8 {
                                tw[7 + s] = self.twiddle(layer + 3, 8 * global_block + s);
                            }
                            let block_start = block_in_sub * block_bytes;
                            butterfly_interleaved_fused_4layer_rows(
                                &mut sub_data[block_start..block_start + block_bytes],
                                &tw,
                                sixteenth,
                                num_ntts,
                                if sixteenth.is_multiple_of(2) {
                                    odd_tail
                                } else {
                                    0
                                },
                                hint,
                            );
                        }
                        layer += 4;
                    } else if layer + 3 == log_d && !ntt_fused3_disabled() {
                        debug_assert_eq!(block_size, 8);
                        #[cfg(test)]
                        FUSED3_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                        let dense_lanes = num_ntts - odd_tail;
                        for block_in_sub in 0..num_blocks_in_sub {
                            let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                            let mut tw = [F128 { lo: 0, hi: 0 }; 7];
                            tw[0] = self.twiddle(layer, global_block);
                            for s in 0..2 {
                                tw[1 + s] = self.twiddle(layer + 1, 2 * global_block + s);
                            }
                            for s in 0..4 {
                                tw[3 + s] = self.twiddle(layer + 2, 4 * global_block + s);
                            }
                            let block_start = block_in_sub * block_bytes;
                            let block = &mut sub_data[block_start..block_start + block_bytes];
                            debug_assert_eq!(block.len(), 8 * num_ntts);
                            unsafe {
                                kernels::butterfly_fused_3layer_rows(
                                    block.as_mut_ptr(),
                                    num_ntts,
                                    dense_lanes,
                                    &tw,
                                );
                            }
                        }
                        layer += 3;
                    } else if layer + 1 < log_d {
                        let quarter = block_size >> 2;
                        for block_in_sub in 0..num_blocks_in_sub {
                            let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                            let t_outer = self.twiddle(layer, global_block);
                            let t_inner_a = self.twiddle(layer + 1, 2 * global_block);
                            let t_inner_b = self.twiddle(layer + 1, 2 * global_block + 1);
                            let block_start = block_in_sub * block_bytes;
                            butterfly_interleaved_fused_2layer_par_rows(
                                &mut sub_data[block_start..block_start + block_bytes],
                                t_outer,
                                t_inner_a,
                                t_inner_b,
                                quarter,
                                num_ntts,
                                if quarter.is_multiple_of(2) {
                                    odd_tail
                                } else {
                                    0
                                },
                            );
                        }
                        layer += 2;
                    } else {
                        let block_size_half = block_size >> 1;
                        for block_in_sub in 0..num_blocks_in_sub {
                            let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                            let twiddle = self.twiddle(layer, global_block);
                            let block_start = block_in_sub * block_bytes;
                            let block = &mut sub_data[block_start..block_start + block_bytes];
                            butterfly_interleaved_block(
                                block,
                                twiddle,
                                block_size_half,
                                num_ntts,
                                if block_size_half.is_multiple_of(2) {
                                    odd_tail
                                } else {
                                    0
                                },
                            );
                        }
                        layer += 1;
                    }
                }
                return false;
            }

            for layer in n_top.max(start_layer)..log_d {
                let layer_in_sub = layer - n_top;
                let num_blocks_in_sub = 1usize << layer_in_sub;
                let block_size = 1usize << (log_d - layer);
                let block_size_half = block_size >> 1;
                let block_bytes = block_size * num_ntts;

                for block_in_sub in 0..num_blocks_in_sub {
                    let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                    let twiddle = self.twiddle(layer, global_block);
                    let block_start = block_in_sub * block_bytes;
                    let block = &mut sub_data[block_start..block_start + block_bytes];
                    butterfly_interleaved_block(
                        block,
                        twiddle,
                        block_size_half,
                        num_ntts,
                        if block_size_half.is_multiple_of(2) {
                            odd_tail
                        } else {
                            0
                        },
                    );
                }
            }
            false
        };

        #[cfg(target_os = "linux")]
        let split_claim = {
            let big = stream.is_none() && on_sub_done.is_some() && n_total >= (1usize << 24);
            deep_split_pairs()
                .filter(|p| big && fuse_blocks && p.len() * 2 == rayon::current_num_threads())
                .filter(|_| crate::owns_whole_pool())
                .and_then(|p| DeepSplitClaim::take().map(|c| (p, c)))
        };
        #[cfg(target_os = "linux")]
        let split_state = split_claim
            .as_ref()
            .map(|(pairs, _)| DeepSplitState::new(pairs.len()));
        #[cfg(target_os = "linux")]
        let deep_base_addr = data.as_mut_ptr() as usize;
        #[cfg(target_os = "linux")]
        let deep_role = |idx: usize| {
            use std::sync::atomic::{AtomicUsize, Ordering};
            let (Some((pairs, _)), Some(stt), Some(cb)) =
                (split_claim.as_ref(), split_state.as_ref(), on_sub_done)
            else {
                return;
            };
            let n_pairs = pairs.len();
            if idx >= 2 * n_pairs {
                return;
            }
            let n_subs = n_total / sub_bytes;
            let depth = deep_split_depth();
            let hint = deep_pf_hint();
            let share = deep_share_enabled();
            let queues = &stt.queues;
            let next_sub = &stt.next_sub;
            let prod_done = &stt.prod_done;
            let producer = idx < n_pairs;
            let slot = if producer { idx } else { idx - n_pairs };
            let q = &queues[slot];
            let cpu = if producer {
                pairs[slot].0
            } else {
                pairs[slot].1
            };
            struct Guard<'a> {
                saved: affinity::Mask,
                q: &'a DeepQueue,
                producer: bool,
                prod_done: &'a AtomicUsize,
                counted: core::cell::Cell<bool>,
            }
            impl Drop for Guard<'_> {
                fn drop(&mut self) {
                    use std::sync::atomic::Ordering;
                    if self.producer {
                        self.q.done.store(true, Ordering::Release);
                        if !self.counted.get() {
                            self.prod_done.fetch_add(1, Ordering::AcqRel);
                        }
                    } else {
                        self.q.gone.store(true, Ordering::Release);
                    }
                    affinity::set(&self.saved);
                }
            }
            let guard = Guard {
                saved: affinity::get(),
                q,
                producer,
                prod_done,
                counted: core::cell::Cell::new(false),
            };
            affinity::pin(cpu);
            let run = |b: DeepBlock| {
                let ptr = (deep_base_addr as *const F128).wrapping_add(b.lo * num_ntts);
                let blk = unsafe { std::slice::from_raw_parts(ptr, DeepBlock::ROWS * num_ntts) };
                cb(b.lo..b.lo + DeepBlock::ROWS, blk);
            };
            let help = |own: usize| loop {
                if let Some(b) = queues[own].try_pop() {
                    run(b);
                    continue;
                }
                let mut got = false;
                for k in 1..n_pairs {
                    if let Some(b) = queues[(own + k) % n_pairs].try_pop() {
                        run(b);
                        got = true;
                        break;
                    }
                }
                if got {
                    continue;
                }
                if prod_done.load(Ordering::Acquire) == n_pairs
                    && queues.iter().all(|q| q.is_empty())
                {
                    return;
                }
                std::hint::spin_loop();
            };
            if producer {
                let enqueue = |range: core::ops::Range<usize>, blk: &[F128]| {
                    let Some(b) = DeepBlock::from_finished(&range, blk, deep_base_addr, num_ntts)
                    else {
                        cb(range, blk);
                        return;
                    };
                    let queued = if share {
                        q.try_push(b, depth)
                    } else {
                        q.push(b, depth)
                    };
                    if !queued {
                        cb(range, blk);
                    }
                };
                loop {
                    let i = next_sub.fetch_add(1, Ordering::Relaxed);
                    if i >= n_subs {
                        break;
                    }
                    let sub_data = unsafe {
                        std::slice::from_raw_parts_mut(
                            (deep_base_addr as *mut F128).add(i * sub_bytes),
                            sub_bytes,
                        )
                    };
                    if !deep_sub(i, sub_data, Some(&enqueue), hint) {
                        enqueue(
                            i * sub_size_positions..(i + 1) * sub_size_positions,
                            sub_data,
                        );
                    }
                }
                if share {
                    q.done.store(true, Ordering::Release);
                    guard.counted.set(true);
                    prod_done.fetch_add(1, Ordering::AcqRel);
                    help(slot);
                }
            } else if share {
                help(slot);
            } else {
                while let Some(b) = q.pop() {
                    run(b);
                }
            }
        };

        let mut layer = start_layer.min(n_top);
        while layer < n_top {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_bytes = block_size * num_ntts;

            if let Some(msg) = seed_msg.take() {
                debug_assert!(layer == 3 && top_fusion_ok && layer + 5 < n_top);
                #[cfg(target_os = "linux")]
                let after: Option<&(dyn Fn(usize) + Sync)> =
                    if split_claim.is_some() && merged_pass_enabled() {
                        Some(&deep_role)
                    } else {
                        None
                    };
                #[cfg(not(target_os = "linux"))]
                let after: Option<&(dyn Fn(usize) + Sync)> = None;
                if self.seed_top_fused8_pass(msg, data, num_ntts, log_d, odd_tail, after) {
                    crate::gaptime::mark("ntt: deep pass done");
                    return;
                }
                crate::gaptime::mark("ntt: seed+top fused pass done");
                layer += 6;
            } else if top_fusion_ok && layer + 5 < n_top {
                self.top_fused6_pass(data, num_ntts, layer, log_d, odd_tail);
                layer += 6;
            } else if fused4_ok && layer + 3 < n_top && block_size >= 16 {
                let sixteenth = block_size >> 4;
                for block in 0..num_blocks {
                    let mut tw = [F128 { lo: 0, hi: 0 }; 15];
                    tw[0] = self.twiddle(layer, block);
                    for s in 0..2 {
                        tw[1 + s] = self.twiddle(layer + 1, 2 * block + s);
                    }
                    for s in 0..4 {
                        tw[3 + s] = self.twiddle(layer + 2, 4 * block + s);
                    }
                    for s in 0..8 {
                        tw[7 + s] = self.twiddle(layer + 3, 8 * block + s);
                    }
                    let start = block * block_bytes;
                    butterfly_interleaved_fused_4layer_par_rows(
                        &mut data[start..start + block_bytes],
                        &tw,
                        sixteenth,
                        num_ntts,
                        if sixteenth.is_multiple_of(2) {
                            odd_tail
                        } else {
                            0
                        },
                    );
                }
                layer += 4;
            } else if layer + 1 < n_top && block_size >= 4 {
                let quarter = block_size >> 2;
                const PARALLEL_ROW_THRESHOLD: usize = 256;
                if quarter < PARALLEL_ROW_THRESHOLD {
                    for block in 0..num_blocks {
                        let t_outer = self.twiddle(layer, block);
                        let t_inner_a = self.twiddle(layer + 1, 2 * block);
                        let t_inner_b = self.twiddle(layer + 1, 2 * block + 1);
                        let start = block * block_bytes;
                        butterfly_interleaved_fused_2layer_par_rows(
                            &mut data[start..start + block_bytes],
                            t_outer,
                            t_inner_a,
                            t_inner_b,
                            quarter,
                            num_ntts,
                            if quarter.is_multiple_of(2) {
                                odd_tail
                            } else {
                                0
                            },
                        );
                    }
                } else {
                    let base_addr = data.as_mut_ptr() as usize;
                    let log_quarter = log2_pow2(quarter);
                    let stride = quarter * num_ntts;
                    (0..num_blocks << log_quarter)
                        .into_par_iter()
                        .for_each(|idx| {
                            let block = idx >> log_quarter;
                            let r = idx & (quarter - 1);
                            let t_outer = self.twiddle(layer, block);
                            let t_inner_a = self.twiddle(layer + 1, 2 * block);
                            let t_inner_b = self.twiddle(layer + 1, 2 * block + 1);
                            let row = block * block_bytes + r * num_ntts;
                            let lanes = row_lanes(
                                r,
                                num_ntts,
                                if quarter.is_multiple_of(2) {
                                    odd_tail
                                } else {
                                    0
                                },
                            );
                            unsafe {
                                let base = base_addr as *mut F128;
                                let a = std::slice::from_raw_parts_mut(base.add(row), lanes);
                                let b =
                                    std::slice::from_raw_parts_mut(base.add(row + stride), lanes);
                                let c = std::slice::from_raw_parts_mut(
                                    base.add(row + 2 * stride),
                                    lanes,
                                );
                                let d = std::slice::from_raw_parts_mut(
                                    base.add(row + 3 * stride),
                                    lanes,
                                );
                                kernels::butterfly_fused_2layer(
                                    a, b, c, d, t_outer, t_inner_a, t_inner_b,
                                );
                            }
                        });
                }
                layer += 2;
            } else {
                let block_size_half = block_size >> 1;
                for block in 0..num_blocks {
                    let t = self.twiddle(layer, block);
                    let start = block * block_bytes;
                    butterfly_interleaved_block_par_rows(
                        &mut data[start..start + block_bytes],
                        t,
                        block_size_half,
                        num_ntts,
                        if block_size_half.is_multiple_of(2) {
                            odd_tail
                        } else {
                            0
                        },
                    );
                }
                layer += 1;
            }
        }

        match stream {
            None => {
                let big = on_sub_done.is_some() && n_total >= (1usize << 24);
                #[cfg(target_os = "linux")]
                if split_claim.is_some() {
                    rayon::broadcast(|ctx| deep_role(ctx.index()));
                    crate::gaptime::mark("ntt: deep pass done");
                    return;
                }
                data.par_chunks_mut(sub_bytes)
                    .enumerate()
                    .for_each(|(sub_idx, sub_data)| {
                        if !deep_sub(sub_idx, sub_data, on_sub_done, 0) {
                            if let Some(cb) = on_sub_done {
                                let lo = sub_idx * sub_size_positions;
                                cb(lo..lo + sub_size_positions, sub_data);
                            }
                        }
                    });
                if big {
                    crate::gaptime::mark("ntt: deep pass done");
                }
            }
            Some((n_chunks, on_chunk)) => {
                let n_subs = 1usize << n_top;
                let chunks = n_chunks.clamp(1, n_subs);

                if std::env::var_os("FLOCK_NTT_STREAM_BARRIERS").is_some() {
                    let mut rest: &mut [F128] = data;
                    let mut sub_cursor = 0usize;
                    for c in 0..chunks {
                        let end_sub = ((c + 1) * n_subs) / chunks;
                        let take = end_sub - sub_cursor;
                        let (cur, tail) = std::mem::take(&mut rest).split_at_mut(take * sub_bytes);
                        rest = tail;
                        cur.par_chunks_mut(sub_bytes)
                            .enumerate()
                            .for_each(|(i, sub_data)| {
                                deep_sub(sub_cursor + i, sub_data, None, 0);
                            });
                        on_chunk(
                            c,
                            sub_cursor * sub_size_positions..end_sub * sub_size_positions,
                        );
                        sub_cursor = end_sub;
                    }
                    return;
                }

                use std::sync::Mutex;
                use std::sync::atomic::{AtomicUsize, Ordering};

                let mut bounds = Vec::with_capacity(chunks + 1);
                for c in 0..=chunks {
                    bounds.push(c * n_subs / chunks);
                }
                let remaining: Vec<AtomicUsize> = (0..chunks)
                    .map(|c| AtomicUsize::new(bounds[c + 1] - bounds[c]))
                    .collect();
                let committer = Mutex::new((0usize, on_chunk));

                let drain = |blocking: bool| loop {
                    let mut guard = if blocking {
                        committer
                            .lock()
                            .unwrap_or_else(std::sync::PoisonError::into_inner)
                    } else {
                        match committer.try_lock() {
                            Ok(g) => g,
                            Err(_) => return,
                        }
                    };
                    let (next, cb) = &mut *guard;
                    while *next < chunks && remaining[*next].load(Ordering::Acquire) == 0 {
                        let lo = bounds[*next] * sub_size_positions;
                        let hi = bounds[*next + 1] * sub_size_positions;
                        cb(*next, lo..hi);
                        *next += 1;
                    }
                    let n = *next;
                    drop(guard);
                    if blocking || n >= chunks || remaining[n].load(Ordering::Acquire) != 0 {
                        return;
                    }
                };

                let next_sub = AtomicUsize::new(0);
                let base_addr = data.as_mut_ptr() as usize;
                (0..n_subs).into_par_iter().with_max_len(1).for_each(|_| {
                    let i = next_sub.fetch_add(1, Ordering::Relaxed);
                    let sub_data = unsafe {
                        std::slice::from_raw_parts_mut(
                            (base_addr as *mut F128).add(i * sub_bytes),
                            sub_bytes,
                        )
                    };
                    deep_sub(i, sub_data, None, 0);
                    let c = bounds.partition_point(|&b| b <= i) - 1;
                    if remaining[c].fetch_sub(1, Ordering::AcqRel) == 1 {
                        drain(false);
                    }
                });
                drain(true);
            }
        }
    }

    pub fn forward_transform_scalar(&self, data: &mut [F128]) {
        let log_d = log2_pow2(data.len());
        assert!(log_d <= self.log_domain_size());

        for layer in 0..log_d {
            let num_blocks = 1usize << layer;
            let block_size_half = 1usize << (log_d - layer - 1);
            for block in 0..num_blocks {
                let twiddle = self.twiddle(layer, block);
                let block_start = block << (log_d - layer);
                for idx0 in block_start..(block_start + block_size_half) {
                    let idx1 = idx0 | block_size_half;
                    let v = data[idx1];
                    let new_u = data[idx0] + v * twiddle;
                    data[idx0] = new_u;
                    data[idx1] = v + new_u;
                }
            }
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    pub fn forward_transform_neon(&self, data: &mut [F128]) {
        let log_d = log2_pow2(data.len());
        assert!(log_d <= self.log_domain_size());

        for layer in 0..log_d {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_size_half = block_size >> 1;
            unsafe {
                if block_size_half >= 2 {
                    for block in 0..num_blocks {
                        let twiddle = self.twiddle(layer, block);
                        let block_start = block * block_size;
                        let chunk = &mut data[block_start..block_start + block_size];
                        kernels::butterfly_neon_block(chunk, twiddle, block_size_half);
                    }
                } else {
                    debug_assert_eq!(block_size_half, 1);
                    let mut block = 0;
                    while block + 1 < num_blocks {
                        let t_a = self.twiddle(layer, block);
                        let t_b = self.twiddle(layer, block + 1);
                        kernels::butterfly_neon_block_pair(data, block * 2, t_a, t_b);
                        block += 2;
                    }
                    while block < num_blocks {
                        let twiddle = self.twiddle(layer, block);
                        let idx0 = block * 2;
                        let idx1 = idx0 + 1;
                        let v = data[idx1];
                        let new_u = data[idx0] + v * twiddle;
                        data[idx0] = new_u;
                        data[idx1] = v + new_u;
                        block += 1;
                    }
                }
            }
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    pub fn forward_transform_parallel(&self, data: &mut [F128]) {
        use rayon::prelude::*;
        let log_d = log2_pow2(data.len());
        assert!(log_d <= self.log_domain_size());

        const PARALLEL_THRESHOLD_LOG: usize = 14;
        if log_d <= PARALLEL_THRESHOLD_LOG {
            self.forward_transform_neon(data);
            return;
        }

        for layer in 0..log_d {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_size_half = block_size >> 1;

            if num_blocks >= 4 && block_size_half >= 2 {
                let twiddles: Vec<F128> = (0..num_blocks).map(|b| self.twiddle(layer, b)).collect();
                data.par_chunks_mut(block_size)
                    .zip(twiddles.par_iter())
                    .for_each(|(chunk, &twiddle)| {
                        unsafe { kernels::butterfly_neon_block(chunk, twiddle, block_size_half) };
                    });
            } else if block_size_half >= 2 {
                unsafe {
                    for block in 0..num_blocks {
                        let twiddle = self.twiddle(layer, block);
                        let block_start = block * block_size;
                        kernels::butterfly_neon_block(
                            &mut data[block_start..block_start + block_size],
                            twiddle,
                            block_size_half,
                        );
                    }
                }
            } else {
                debug_assert_eq!(block_size_half, 1);
                if num_blocks >= 2 {
                    let twiddles: Vec<F128> =
                        (0..num_blocks).map(|b| self.twiddle(layer, b)).collect();
                    data.par_chunks_mut(4).zip(twiddles.par_chunks(2)).for_each(
                        |(chunk, twiddle_pair)| {
                            unsafe {
                                kernels::butterfly_neon_block_pair_chunk(
                                    chunk,
                                    twiddle_pair[0],
                                    twiddle_pair[1],
                                )
                            };
                        },
                    );
                } else {
                    let twiddle = self.twiddle(layer, 0);
                    let v = data[1];
                    let new_u = data[0] + v * twiddle;
                    data[0] = new_u;
                    data[1] = v + new_u;
                }
            }
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    pub fn forward_transform_batched(&self, data: &mut [F128]) {
        use rayon::prelude::*;
        let log_d = log2_pow2(data.len());
        assert!(log_d <= self.log_domain_size());

        const TARGET_SUB_NTT_LOG: usize = 17;
        if log_d <= TARGET_SUB_NTT_LOG {
            self.forward_transform_parallel(data);
            return;
        }
        let n_top = log_d - TARGET_SUB_NTT_LOG;
        let sub_ntt_size = 1usize << (log_d - n_top);

        for layer in 0..n_top {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_size_half = block_size >> 1;

            if num_blocks >= 4 {
                let twiddles: Vec<F128> = (0..num_blocks).map(|b| self.twiddle(layer, b)).collect();
                data.par_chunks_mut(block_size)
                    .zip(twiddles.par_iter())
                    .for_each(|(chunk, &t)| {
                        unsafe { kernels::butterfly_neon_block(chunk, t, block_size_half) };
                    });
            } else {
                unsafe {
                    for block in 0..num_blocks {
                        let t = self.twiddle(layer, block);
                        let block_start = block * block_size;
                        kernels::butterfly_neon_block(
                            &mut data[block_start..block_start + block_size],
                            t,
                            block_size_half,
                        );
                    }
                }
            }
        }

        data.par_chunks_mut(sub_ntt_size)
            .enumerate()
            .for_each(|(sub_idx, sub_data)| {
                for layer in n_top..log_d {
                    let layer_in_sub = layer - n_top;
                    let num_blocks_in_sub = 1usize << layer_in_sub;
                    let block_size = 1usize << (log_d - layer);
                    let block_size_half = block_size >> 1;

                    for block_in_sub in 0..num_blocks_in_sub {
                        let global_block = sub_idx * num_blocks_in_sub + block_in_sub;
                        let twiddle = self.twiddle(layer, global_block);
                        let block_start = block_in_sub * block_size;
                        let block = &mut sub_data[block_start..block_start + block_size];
                        if block_size_half >= 2 {
                            unsafe {
                                kernels::butterfly_neon_block(block, twiddle, block_size_half)
                            };
                        } else {
                            let v = block[1];
                            let new_u = block[0] + v * twiddle;
                            block[0] = new_u;
                            block[1] = v + new_u;
                        }
                    }
                }
            });
    }

    pub fn inverse_transform(&self, data: &mut [F128]) {
        let log_d = log2_pow2(data.len());
        assert!(log_d <= self.log_domain_size());

        for layer in (0..log_d).rev() {
            let num_blocks = 1usize << layer;
            let block_size_half = 1usize << (log_d - layer - 1);
            for block in 0..num_blocks {
                let twiddle = self.twiddle(layer, block);
                let block_start = block << (log_d - layer);
                for idx0 in block_start..(block_start + block_size_half) {
                    let idx1 = idx0 | block_size_half;
                    let u = data[idx0];
                    let new_v = data[idx1] + u;
                    data[idx1] = new_v;
                    data[idx0] = u + new_v * twiddle;
                }
            }
        }
    }

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[target_feature(enable = "avx512f,vpclmulqdq")]
    #[inline(never)]
    #[allow(clippy::too_many_arguments)]
    unsafe fn deep_sub_fused_blocks_x86(
        &self,
        sub_idx: usize,
        sub_data: &mut [F128],
        cb: &(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync),
        n_top: usize,
        log_d: usize,
        num_ntts: usize,
        odd_tail: usize,
        sub_size_positions: usize,
        hint: u8,
    ) -> bool {
        self.deep_sub_fused_blocks_fallback(
            sub_idx,
            sub_data,
            cb,
            n_top,
            log_d,
            num_ntts,
            odd_tail,
            sub_size_positions,
            hint,
        )
    }

    #[inline(always)]
    #[allow(clippy::too_many_arguments)]
    fn deep_sub_fused_blocks_fallback(
        &self,
        sub_idx: usize,
        sub_data: &mut [F128],
        cb: &(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync),
        n_top: usize,
        log_d: usize,
        num_ntts: usize,
        odd_tail: usize,
        sub_size_positions: usize,
        hint: u8,
    ) -> bool {
        {
            let layer = n_top;
            let block_size = 1usize << (log_d - layer);
            let sixteenth = block_size >> 4;
            let global_block = sub_idx;
            let mut tw = [F128 { lo: 0, hi: 0 }; 15];
            tw[0] = self.twiddle(layer, global_block);
            for s in 0..2 {
                tw[1 + s] = self.twiddle(layer + 1, 2 * global_block + s);
            }
            for s in 0..4 {
                tw[3 + s] = self.twiddle(layer + 2, 4 * global_block + s);
            }
            for s in 0..8 {
                tw[7 + s] = self.twiddle(layer + 3, 8 * global_block + s);
            }
            butterfly_interleaved_fused_4layer_rows(
                sub_data,
                &tw,
                sixteenth,
                num_ntts,
                if sixteenth.is_multiple_of(2) {
                    odd_tail
                } else {
                    0
                },
                hint,
            );
        }
        let layer4 = n_top + 4;
        let block_size4 = 1usize << (log_d - layer4);
        let block_bytes4 = block_size4 * num_ntts;
        let sixteenth4 = block_size4 >> 4;
        let layer3 = n_top + 8;
        let dense_lanes = num_ntts - odd_tail;
        #[cfg(test)]
        FUSED3_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        for b in 0..16usize {
            let g4 = sub_idx * 16 + b;
            let mut tw = [F128 { lo: 0, hi: 0 }; 15];
            tw[0] = self.twiddle(layer4, g4);
            for s in 0..2 {
                tw[1 + s] = self.twiddle(layer4 + 1, 2 * g4 + s);
            }
            for s in 0..4 {
                tw[3 + s] = self.twiddle(layer4 + 2, 4 * g4 + s);
            }
            for s in 0..8 {
                tw[7 + s] = self.twiddle(layer4 + 3, 8 * g4 + s);
            }
            let blk = &mut sub_data[b * block_bytes4..(b + 1) * block_bytes4];
            butterfly_interleaved_fused_4layer_rows(
                blk,
                &tw,
                sixteenth4,
                num_ntts,
                if sixteenth4.is_multiple_of(2) {
                    odd_tail
                } else {
                    0
                },
                hint,
            );
            for j in 0..16usize {
                let g8 = g4 * 16 + j;
                let mut tw3 = [F128 { lo: 0, hi: 0 }; 7];
                tw3[0] = self.twiddle(layer3, g8);
                for s in 0..2 {
                    tw3[1 + s] = self.twiddle(layer3 + 1, 2 * g8 + s);
                }
                for s in 0..4 {
                    tw3[3 + s] = self.twiddle(layer3 + 2, 4 * g8 + s);
                }
                let eight = &mut blk[j * 8 * num_ntts..(j + 1) * 8 * num_ntts];
                unsafe {
                    kernels::butterfly_fused_3layer_rows(
                        eight.as_mut_ptr(),
                        num_ntts,
                        dense_lanes,
                        &tw3,
                    );
                }
            }
            let lo = sub_idx * sub_size_positions + b * block_size4;
            cb(
                lo..lo + block_size4,
                &sub_data[b * block_bytes4..(b + 1) * block_bytes4],
            );
        }
        true
    }
}

#[inline]
fn butterfly_interleaved_block_par_rows(
    block: &mut [F128],
    twiddle: F128,
    block_size_half: usize,
    num_ntts: usize,
    odd_tail: usize,
) {
    use rayon::prelude::*;
    const PARALLEL_ROW_THRESHOLD: usize = 512;
    debug_assert!(odd_tail == 0 || block_size_half.is_multiple_of(2));
    if block_size_half < PARALLEL_ROW_THRESHOLD {
        butterfly_interleaved_block(block, twiddle, block_size_half, num_ntts, odd_tail);
        return;
    }
    let half_offset = block_size_half * num_ntts;
    let (top, bot) = block.split_at_mut(half_offset);
    top.par_chunks_mut(num_ntts)
        .zip(bot.par_chunks_mut(num_ntts))
        .enumerate()
        .for_each(|(r, (top_row, bot_row))| {
            let lanes = row_lanes(r, num_ntts, odd_tail);
            kernels::butterfly_row_pair(&mut top_row[..lanes], &mut bot_row[..lanes], twiddle);
        });
}

#[inline]
fn butterfly_interleaved_fused_2layer_par_rows(
    block: &mut [F128],
    t_outer: F128,
    t_inner_a: F128,
    t_inner_b: F128,
    quarter: usize,
    num_ntts: usize,
    odd_tail: usize,
) {
    use rayon::prelude::*;
    const PARALLEL_ROW_THRESHOLD: usize = 256;
    let stride = quarter * num_ntts;
    debug_assert_eq!(block.len(), 4 * stride);
    debug_assert!(odd_tail == 0 || quarter.is_multiple_of(2));

    let do_one = |lanes: usize,
                  row_a: &mut [F128],
                  row_b: &mut [F128],
                  row_c: &mut [F128],
                  row_d: &mut [F128]| {
        kernels::butterfly_fused_2layer(
            &mut row_a[..lanes],
            &mut row_b[..lanes],
            &mut row_c[..lanes],
            &mut row_d[..lanes],
            t_outer,
            t_inner_a,
            t_inner_b,
        );
    };

    let (top_half, bot_half) = block.split_at_mut(2 * stride);
    let (q1, q2) = top_half.split_at_mut(stride);
    let (q3, q4) = bot_half.split_at_mut(stride);

    if quarter < PARALLEL_ROW_THRESHOLD {
        for r in 0..quarter {
            let off = r * num_ntts;
            let (q1r, q1_rest) = q1[off..].split_at_mut(num_ntts);
            let _ = q1_rest;
            let (q2r, _) = q2[off..].split_at_mut(num_ntts);
            let (q3r, _) = q3[off..].split_at_mut(num_ntts);
            let (q4r, _) = q4[off..].split_at_mut(num_ntts);
            do_one(row_lanes(r, num_ntts, odd_tail), q1r, q2r, q3r, q4r);
        }
    } else {
        q1.par_chunks_mut(num_ntts)
            .zip(q2.par_chunks_mut(num_ntts))
            .zip(q3.par_chunks_mut(num_ntts))
            .zip(q4.par_chunks_mut(num_ntts))
            .enumerate()
            .for_each(|(r, (((row_a, row_b), row_c), row_d))| {
                do_one(row_lanes(r, num_ntts, odd_tail), row_a, row_b, row_c, row_d);
            });
    }
}

#[inline]
fn butterfly_interleaved_block(
    block: &mut [F128],
    twiddle: F128,
    block_size_half: usize,
    num_ntts: usize,
    odd_tail: usize,
) {
    debug_assert!(odd_tail == 0 || block_size_half.is_multiple_of(2));
    let off_bot = block_size_half * num_ntts;
    let (top, bot) = block.split_at_mut(off_bot);
    for r in 0..block_size_half {
        let o = r * num_ntts;
        let lanes = row_lanes(r, num_ntts, odd_tail);
        kernels::butterfly_row_pair(&mut top[o..o + lanes], &mut bot[o..o + lanes], twiddle);
    }
}

#[inline]
fn butterfly_interleaved_fused_4layer_par_rows(
    block: &mut [F128],
    t: &[F128; 15],
    sixteenth: usize,
    num_ntts: usize,
    odd_tail: usize,
) {
    use rayon::prelude::*;
    const PARALLEL_ROW_THRESHOLD: usize = 256;
    debug_assert_eq!(block.len(), 16 * sixteenth * num_ntts);
    debug_assert!(odd_tail == 0 || sixteenth.is_multiple_of(2));
    let base = block.as_mut_ptr() as usize;
    if sixteenth < PARALLEL_ROW_THRESHOLD {
        for r in 0..sixteenth {
            unsafe {
                kernels::butterfly_fused_4layer_row(
                    base as *mut F128,
                    sixteenth,
                    num_ntts,
                    row_lanes(r, num_ntts, odd_tail),
                    r,
                    t,
                )
            };
        }
    } else {
        (0..sixteenth).into_par_iter().for_each(|r| {
            unsafe {
                kernels::butterfly_fused_4layer_row(
                    base as *mut F128,
                    sixteenth,
                    num_ntts,
                    row_lanes(r, num_ntts, odd_tail),
                    r,
                    t,
                )
            };
        });
    }
}

#[inline]
fn butterfly_interleaved_fused_4layer_rows(
    block: &mut [F128],
    t: &[F128; 15],
    sixteenth: usize,
    num_ntts: usize,
    odd_tail: usize,
    hint: u8,
) {
    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    return unsafe {
        butterfly_interleaved_fused_4layer_rows_x86(block, t, sixteenth, num_ntts, odd_tail, hint)
    };
    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    butterfly_interleaved_fused_4layer_rows_fallback(block, t, sixteenth, num_ntts, odd_tail, hint)
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[target_feature(enable = "avx512f,vpclmulqdq")]
#[inline]
unsafe fn butterfly_interleaved_fused_4layer_rows_x86(
    block: &mut [F128],
    t: &[F128; 15],
    sixteenth: usize,
    num_ntts: usize,
    odd_tail: usize,
    hint: u8,
) {
    if let Some(prepared) = unsafe { kernels::prepare_four(t) } {
        let base = block.as_mut_ptr();
        for r in 0..sixteenth {
            let lanes = row_lanes(r, num_ntts, odd_tail);
            unsafe {
                if hint == 0 || r + 1 >= sixteenth {
                    kernels::row_prepared::<0>(
                        base, sixteenth, num_ntts, lanes, r, t, 0, &prepared,
                    );
                } else if hint == 1 {
                    kernels::row_prepared::<1>(
                        base,
                        sixteenth,
                        num_ntts,
                        lanes,
                        r,
                        t,
                        r + 1,
                        &prepared,
                    );
                } else {
                    kernels::row_prepared::<2>(
                        base,
                        sixteenth,
                        num_ntts,
                        lanes,
                        r,
                        t,
                        r + 1,
                        &prepared,
                    );
                }
            }
        }
        return;
    }
    butterfly_interleaved_fused_4layer_rows_fallback(block, t, sixteenth, num_ntts, odd_tail, hint)
}

#[inline(always)]
fn butterfly_interleaved_fused_4layer_rows_fallback(
    block: &mut [F128],
    t: &[F128; 15],
    sixteenth: usize,
    num_ntts: usize,
    odd_tail: usize,
    hint: u8,
) {
    debug_assert_eq!(block.len(), 16 * sixteenth * num_ntts);
    debug_assert!(odd_tail == 0 || sixteenth.is_multiple_of(2));
    let base = block.as_mut_ptr();
    for r in 0..sixteenth {
        let lanes = row_lanes(r, num_ntts, odd_tail);
        unsafe {
            if hint == 0 || r + 1 >= sixteenth {
                kernels::butterfly_fused_4layer_row(base, sixteenth, num_ntts, lanes, r, t)
            } else if hint == 1 {
                kernels::butterfly_fused_4layer_row_pf::<1>(
                    base,
                    sixteenth,
                    num_ntts,
                    lanes,
                    r,
                    t,
                    r + 1,
                )
            } else {
                kernels::butterfly_fused_4layer_row_pf::<2>(
                    base,
                    sixteenth,
                    num_ntts,
                    lanes,
                    r,
                    t,
                    r + 1,
                )
            }
        };
    }
}

#[inline]
fn log2_pow2(n: usize) -> usize {
    assert!(
        n.is_power_of_two() && n > 0,
        "length must be a positive power of 2"
    );
    n.trailing_zeros() as usize
}

#[cfg(any(
    all(target_arch = "aarch64", target_feature = "aes"),
    all(target_arch = "x86_64", target_feature = "pclmulqdq"),
))]
#[inline]
fn rate_half_seed_disabled() -> bool {
    std::env::var_os("FLOCK_NO_RATE_HALF_SEED").is_some()
}

fn rate_seed_disabled() -> bool {
    static OFF: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_NTT_RATE_SEED").is_some());
    *OFF
}

#[allow(dead_code)]
fn seed_nt_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_SEED_NT").is_none());
    *ON
}

fn replicate_message_fill(codeword: &mut [F128], msg: &[F128]) {
    use rayon::prelude::*;

    let msg_len = msg.len();
    debug_assert!(codeword.len().is_multiple_of(msg_len));
    const COPY_CHUNK: usize = 1 << 16;
    if msg_len >= COPY_CHUNK {
        codeword
            .par_chunks_mut(COPY_CHUNK)
            .enumerate()
            .for_each(|(i, dst)| {
                let src_off = (i * COPY_CHUNK) & (msg_len - 1);
                dst.copy_from_slice(&msg[src_off..src_off + dst.len()]);
            });
    } else {
        for replica in codeword.chunks_mut(msg_len) {
            replica.copy_from_slice(msg);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn shaped_row_kernels_match_generic() {
        use std::sync::atomic::Ordering;

        fn next(seed: &mut u64) -> u64 {
            *seed ^= *seed << 13;
            *seed ^= *seed >> 7;
            *seed ^= *seed << 17;
            *seed
        }
        fn rnd(seed: &mut u64) -> F128 {
            F128 {
                lo: next(seed),
                hi: next(seed),
            }
        }

        let mut seed = 0x1234_5678_9abc_def0u64;
        const NN: usize = 64;

        let cases: [(usize, &[u8], &[usize]); 3] = [
            (128, &[0, 1, 2], &[NN]),
            (8, &[0, 1, 2], &[NN, NN - 3]),
            (1, &[0], &[NN, NN - 3]),
        ];
        for &(sixteenth, hints, lane_counts) in cases.iter() {
            let n = 16 * sixteenth * NN;
            let src: Vec<F128> = (0..n).map(|_| rnd(&mut seed)).collect();
            let tw: [F128; 15] = std::array::from_fn(|_| rnd(&mut seed));
            for &hint in hints {
                for &lanes in lane_counts {
                    let run = |off: bool| {
                        let mut data = src.clone();
                        NTT_SHAPED_TEST_OFF.store(off, Ordering::Relaxed);
                        for r in 0..sixteenth {
                            unsafe {
                                match hint {
                                    0 => kernels::butterfly_fused_4layer_row(
                                        data.as_mut_ptr(),
                                        sixteenth,
                                        NN,
                                        lanes,
                                        r,
                                        &tw,
                                    ),
                                    1 => kernels::butterfly_fused_4layer_row_pf::<1>(
                                        data.as_mut_ptr(),
                                        sixteenth,
                                        NN,
                                        lanes,
                                        r,
                                        &tw,
                                        (r + 1) % sixteenth,
                                    ),
                                    _ => kernels::butterfly_fused_4layer_row_pf::<2>(
                                        data.as_mut_ptr(),
                                        sixteenth,
                                        NN,
                                        lanes,
                                        r,
                                        &tw,
                                        (r + 1) % sixteenth,
                                    ),
                                }
                            }
                        }
                        NTT_SHAPED_TEST_OFF.store(false, Ordering::Relaxed);
                        data
                    };
                    let generic = run(true);
                    let shaped = run(false);
                    assert_eq!(
                        generic, shaped,
                        "fused4 s16={sixteenth} hint={hint} lanes={lanes}"
                    );
                }
            }
        }

        for low in [true, false] {
            let mut tw: [F128; 7] = std::array::from_fn(|_| rnd(&mut seed));
            if low {
                for t in tw[1..].iter_mut() {
                    t.hi = 0;
                }
            }
            for &dense in &[NN, NN - 8] {
                let mut src: Vec<F128> = (0..8 * NN).map(|_| rnd(&mut seed)).collect();
                for row in [1usize, 3, 5, 7] {
                    for lane in dense..NN {
                        src[row * NN + lane] = F128 { lo: 0, hi: 0 };
                    }
                }
                let run = |off: bool| {
                    let mut data = src.clone();
                    NTT_SHAPED_TEST_OFF.store(off, Ordering::Relaxed);
                    unsafe {
                        kernels::butterfly_fused_3layer_rows(data.as_mut_ptr(), NN, dense, &tw);
                    }
                    NTT_SHAPED_TEST_OFF.store(false, Ordering::Relaxed);
                    data
                };
                let generic = run(true);
                let shaped = run(false);
                assert_eq!(generic, shaped, "fused3 low={low} dense={dense}");
            }
        }

        const NN8: usize = 8;
        for &sixteenth in &[1024usize, 128, 64, 16, 8, 4, 2, 1] {
            let n = 16 * sixteenth * NN8;
            let src: Vec<F128> = (0..n).map(|_| rnd(&mut seed)).collect();
            let tw: [F128; 15] = std::array::from_fn(|_| rnd(&mut seed));
            let run = |off: bool| {
                let mut data = src.clone();
                NTT_SHAPED_TEST_OFF.store(off, Ordering::Relaxed);
                for r in 0..sixteenth {
                    unsafe {
                        kernels::butterfly_fused_4layer_row(
                            data.as_mut_ptr(),
                            sixteenth,
                            NN8,
                            NN8,
                            r,
                            &tw,
                        );
                    }
                }
                NTT_SHAPED_TEST_OFF.store(false, Ordering::Relaxed);
                data
            };
            assert_eq!(run(true), run(false), "fused4 nn=8 s16={sixteenth}");
        }
        for low_inner in [true, false] {
            for outer_hi in [0u64, 1u64, 7u64] {
                let mut tw: [F128; 7] = std::array::from_fn(|_| rnd(&mut seed));
                tw[0].hi = outer_hi;
                if low_inner {
                    for t in tw[1..].iter_mut() {
                        t.hi = 0;
                    }
                }
                let src: Vec<F128> = (0..8 * NN8).map(|_| rnd(&mut seed)).collect();
                let run = |off: bool| {
                    let mut data = src.clone();
                    NTT_SHAPED_TEST_OFF.store(off, Ordering::Relaxed);
                    unsafe {
                        kernels::butterfly_fused_3layer_rows(data.as_mut_ptr(), NN8, NN8, &tw);
                    }
                    NTT_SHAPED_TEST_OFF.store(false, Ordering::Relaxed);
                    data
                };
                assert_eq!(
                    run(true),
                    run(false),
                    "fused3 nn=8 low_inner={low_inner} outer_hi={outer_hi}"
                );
            }
        }
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn deep_queue_metadata_is_cacheline_isolated() {
        const CACHE_LINE: usize = 64;
        assert_eq!(core::mem::align_of::<DeepQueue>(), CACHE_LINE);
        assert_eq!(core::mem::size_of::<DeepQueue>(), CACHE_LINE);

        for offset in [
            core::mem::offset_of!(DeepQueue, head),
            core::mem::offset_of!(DeepQueue, tail),
            core::mem::offset_of!(DeepQueue, done),
            core::mem::offset_of!(DeepQueue, gone),
        ] {
            assert!(offset < CACHE_LINE);
        }

        let queues: Vec<DeepQueue> = (0..8).map(|_| DeepQueue::new()).collect();
        let base = queues.as_ptr() as usize;
        assert_eq!(base % CACHE_LINE, 0);
        for (i, queue) in queues.iter().enumerate() {
            let addr = queue as *const DeepQueue as usize;
            assert_eq!(addr, base + i * CACHE_LINE);
            assert_eq!(
                core::ptr::addr_of!(queue.head) as usize / CACHE_LINE,
                addr / CACHE_LINE
            );
            assert_eq!(
                core::ptr::addr_of!(queue.tail) as usize / CACHE_LINE,
                addr / CACHE_LINE
            );
        }
    }

    #[cfg(all(
        target_os = "linux",
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[test]
    fn st_fmp_bufs_default_override_and_clamp() {
        assert_eq!(select_st_fmp_bufs(None), 2);
        assert_eq!(select_st_fmp_bufs(Some(0)), 2);
        assert_eq!(select_st_fmp_bufs(Some(1)), 2);
        assert_eq!(select_st_fmp_bufs(Some(2)), 2);
        assert_eq!(select_st_fmp_bufs(Some(3)), 3);
        assert_eq!(select_st_fmp_bufs(Some(ST_FMP_CAP)), ST_FMP_CAP);
        assert_eq!(select_st_fmp_bufs(Some(ST_FMP_CAP + 1)), ST_FMP_CAP);
        assert_eq!(select_st_fmp_bufs(Some(usize::MAX)), ST_FMP_CAP);
    }

    #[cfg(all(
        target_os = "linux",
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[test]
    fn st_fmp_pair_state_is_one_cache_line_aligned() {
        const CACHE_LINE: usize = 64;
        assert_eq!(core::mem::align_of::<StFmpPair>() % CACHE_LINE, 0);
        let v: Vec<StFmpPair> = (0..4).map(|_| StFmpPair::new()).collect();
        for w in v.windows(2) {
            let a = core::ptr::addr_of!(w[0]) as usize;
            let b = core::ptr::addr_of!(w[1]) as usize;
            assert_ne!(a / CACHE_LINE, b / CACHE_LINE);
        }
    }

    #[cfg(all(
        target_os = "linux",
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    #[test]
    fn st_fmp_split_hands_every_task_over_exactly_once() {
        use std::sync::atomic::{AtomicUsize, Ordering};
        let Some(pairs) = st_fmp_pairs() else {
            return;
        };
        let n_pairs = pairs.len();
        const ROW_LEN: usize = 4;
        let n_tasks = 64 * n_pairs;
        for nbuf in 2..=ST_FMP_CAP {
            let _ = select_st_fmp_bufs(Some(nbuf));
            for rep in 0..16 {
                let seeded: Vec<AtomicUsize> = (0..n_tasks).map(|_| AtomicUsize::new(0)).collect();
                let folded: Vec<AtomicUsize> = (0..n_tasks).map(|_| AtomicUsize::new(0)).collect();
                let published: Vec<AtomicUsize> =
                    (0..n_tasks).map(|_| AtomicUsize::new(0)).collect();
                let stamp = |r: usize| F128 {
                    lo: r as u64 + 1,
                    hi: rep as u64 + 1,
                };
                let cooked = |r: usize| F128 {
                    lo: !(r as u64),
                    hi: rep as u64 + 1,
                };
                let seed = |p: *mut F128, r: usize| {
                    seeded[r].fetch_add(1, Ordering::Relaxed);
                    unsafe {
                        *p = stamp(r);
                        *p.add(1) = F128 { lo: 0, hi: 0 };
                        *p.add(511 * ROW_LEN) = stamp(r);
                    }
                };
                let fold = |p: *mut F128, r: usize| {
                    unsafe {
                        assert_eq!(*p, stamp(r), "fold saw a stale or foreign seed");
                        assert_eq!(*p.add(511 * ROW_LEN), stamp(r), "fold saw a torn block");
                        *p.add(1) = cooked(r);
                    }
                    folded[r].fetch_add(1, Ordering::Relaxed);
                };
                let publish = |p: *mut F128, r: usize| {
                    unsafe {
                        assert_eq!(*p, stamp(r), "publish saw a stale or foreign seed");
                        assert_eq!(*p.add(1), cooked(r), "publish saw an unfolded block");
                    }
                    published[r].fetch_add(1, Ordering::Relaxed);
                };
                assert!(st_fmp_run(n_tasks, ROW_LEN, &seed, &fold, &publish, None));
                for r in 0..n_tasks {
                    assert_eq!(seeded[r].load(Ordering::Relaxed), 1, "task {r} seeded");
                    assert_eq!(folded[r].load(Ordering::Relaxed), 1, "task {r} folded");
                    assert_eq!(
                        published[r].load(Ordering::Relaxed),
                        1,
                        "task {r} published"
                    );
                }
            }
        }
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn deep_queue_atomic_index_stalled_wrap() {
        use std::sync::atomic::Ordering;
        for after_wrap in [false, true] {
            let q = DeepQueue::new();
            assert!(q.try_push(DeepBlock { lo: 0 }, 8));
            let stale = q.tail.load(Ordering::Acquire);
            assert!(q.head.load(Ordering::Acquire) > stale);
            let before = q.slots[stale % DeepQueue::CAP].load(Ordering::Relaxed);
            for i in 0..DeepQueue::CAP {
                assert_eq!(q.try_pop().unwrap().lo, i * DeepBlock::ROWS);
                assert!(q.try_push(
                    DeepBlock {
                        lo: (i + 1) * DeepBlock::ROWS
                    },
                    8
                ));
            }
            let copied = if after_wrap {
                q.slots[stale % DeepQueue::CAP].load(Ordering::Relaxed)
            } else {
                before
            };
            assert_eq!(
                copied,
                if after_wrap {
                    DeepQueue::CAP * DeepBlock::ROWS
                } else {
                    0
                }
            );
            assert!(
                q.tail
                    .compare_exchange(stale, stale + 1, Ordering::AcqRel, Ordering::Acquire)
                    .is_err()
            );
            assert_eq!(q.try_pop().unwrap().lo, DeepQueue::CAP * DeepBlock::ROWS);
            assert!(q.is_empty());
        }
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn fixed_deep_token_rejects_noncanonical_ranges() {
        let columns = 8;
        let data = vec![F128::ZERO; 256 * columns];
        let base = data.as_ptr() as usize;
        assert_eq!(
            DeepBlock::from_finished(&(0..128), &data[..128 * columns], base, columns)
                .unwrap()
                .lo,
            0
        );
        assert_eq!(
            DeepBlock::from_finished(&(128..256), &data[128 * columns..], base, columns)
                .unwrap()
                .lo,
            128
        );
        assert!(DeepBlock::from_finished(&(0..256), &data, base, columns).is_none());
        assert!(
            DeepBlock::from_finished(&(0..128), &data[128 * columns..], base, columns).is_none()
        );
        assert!(
            DeepBlock::from_finished(&(0..128), &data[..64 * columns], base, columns).is_none()
        );
        assert!(
            DeepBlock::from_finished(&(0..128), &data[..128 * columns], base, columns + 1)
                .is_none()
        );
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn atomic_index_queue_reconstructs_finished_callbacks() {
        use std::sync::Mutex;
        let mut rng = Rng::new(0x8a17_c103);
        let ntt = AdditiveNttF128::standard(13);
        let mut cases = 0;
        let mut callbacks = 0;
        for columns in [1usize, 8, 64] {
            for sub_idx in [0usize, 3] {
                let mut data = rand_vec(&mut rng, (1 << 13) * columns);
                let base = data.as_ptr() as usize;
                let snapshots = Mutex::new(Vec::new());
                let q = DeepQueue::new();
                let callback = |range: core::ops::Range<usize>, block: &[F128]| {
                    let token = DeepBlock::from_finished(&range, block, base, columns)
                        .expect("fixed callback");
                    assert!(q.try_push(token, 8));
                    let got = q.try_pop().unwrap();
                    let ptr = (base as *const F128).wrapping_add(got.lo * columns);
                    let restored =
                        unsafe { std::slice::from_raw_parts(ptr, DeepBlock::ROWS * columns) };
                    assert_eq!(range, got.lo..got.lo + DeepBlock::ROWS);
                    assert_eq!(restored.as_ptr(), block.as_ptr());
                    assert_eq!(restored, block);
                    snapshots.lock().unwrap().push((range, block.to_vec()));
                };
                let lo = sub_idx * 2048 * columns;
                assert!(ntt.deep_sub_fused_blocks_fallback(
                    sub_idx,
                    &mut data[lo..lo + 2048 * columns],
                    &callback,
                    2,
                    13,
                    columns,
                    0,
                    2048,
                    0,
                ));
                let snapshots = snapshots.into_inner().unwrap();
                assert_eq!(snapshots.len(), 16);
                for (j, (range, values)) in snapshots.into_iter().enumerate() {
                    assert_eq!(range.start, sub_idx * 2048 + j * DeepBlock::ROWS);
                    assert_eq!(values, data[range.start * columns..range.end * columns]);
                    callbacks += 1;
                }
                assert!(q.is_empty());
                cases += 1;
            }
        }
        println!("atomic token cases={cases} finalized_callbacks={callbacks}");
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn deep_split_depth_default_override_and_clamp() {
        assert_eq!(select_deep_split_depth(None), 8);
        assert_eq!(select_deep_split_depth(Some(0)), 1);
        assert_eq!(select_deep_split_depth(Some(1)), 1);
        assert_eq!(select_deep_split_depth(Some(7)), 7);
        assert_eq!(select_deep_split_depth(Some(8)), 8);
        assert_eq!(select_deep_split_depth(Some(63)), 63);
        assert_eq!(select_deep_split_depth(Some(64)), 64);
        assert_eq!(select_deep_split_depth(Some(65)), 64);
        assert_eq!(select_deep_split_depth(Some(usize::MAX)), 64);
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn deep_queue_depth_eight_wraps_without_loss_or_reordering() {
        use std::sync::atomic::Ordering;

        const N: usize = DeepQueue::CAP * 64;
        let queue = DeepQueue::new();
        let (all_published, initial_head, seen) = std::thread::scope(|scope| {
            let producer = scope.spawn(|| {
                let mut all_published = true;
                for i in 0..N {
                    all_published &= queue.push(DeepBlock { lo: i * 2 }, DeepQueue::DEFAULT_DEPTH);
                }
                queue.done.store(true, Ordering::Release);
                all_published
            });

            let initial_head = loop {
                let head = queue.head.load(Ordering::Acquire);
                if head >= DeepQueue::DEFAULT_DEPTH {
                    break head;
                }
                std::hint::spin_loop();
            };
            let mut seen = Vec::with_capacity(N);
            while let Some(block) = queue.pop() {
                seen.push(block.lo);
            }
            (producer.join().unwrap(), initial_head, seen)
        });

        assert!(all_published);
        assert_eq!(initial_head, DeepQueue::DEFAULT_DEPTH);
        assert_eq!(seen.len(), N);
        for (i, block) in seen.into_iter().enumerate() {
            assert_eq!(block, i * 2);
        }
        assert_eq!(queue.head.load(Ordering::Relaxed), N);
        assert_eq!(queue.tail.load(Ordering::Relaxed), N);
    }

    struct Rng(u64);
    impl Rng {
        fn new(seed: u64) -> Self {
            Self(seed)
        }
        fn next_u64(&mut self) -> u64 {
            self.0 = self.0.wrapping_add(0x9E3779B97F4A7C15);
            let mut z = self.0;
            z = (z ^ (z >> 30)).wrapping_mul(0xBF58476D1CE4E5B9);
            z = (z ^ (z >> 27)).wrapping_mul(0x94D049BB133111EB);
            z ^ (z >> 31)
        }
        fn f128(&mut self) -> F128 {
            F128 {
                lo: self.next_u64(),
                hi: self.next_u64(),
            }
        }
    }

    fn rand_vec(rng: &mut Rng, n: usize) -> Vec<F128> {
        (0..n).map(|_| rng.f128()).collect()
    }

    #[test]
    fn rate_seed_pair_matches_replicate_fill() {
        let shapes = [
            (4usize, 0usize, 2usize),
            (6, 3, 2),
            (8, 3, 3),
            (5, 1, 4),
            (7, 2, 2),
            (4, 3, 5),
            (10, 3, 2),
            (2, 0, 1),
        ];
        for (si, &(log_msg_pos, log_ntts, k)) in shapes.iter().enumerate() {
            let num_ntts = 1usize << log_ntts;
            let msg_pos = 1usize << log_msg_pos;
            let log_d = log_msg_pos + k;
            if k + 2 > log_d {
                continue;
            }
            let ntt = AdditiveNttF128::standard(log_d);
            let mut rng = Rng::new(0x5EED_0000 ^ si as u64);
            let msg = rand_vec(&mut rng, msg_pos * num_ntts);
            let cw_len = (msg_pos << k) * num_ntts;

            let mut want = vec![F128::ZERO; cw_len];
            replicate_message_fill(&mut want, &msg);
            ntt.forward_transform_interleaved_scalar_from_layer(&mut want, num_ntts, k);

            let mut got = vec![F128::ZERO; cw_len];
            ntt.seed_layers_pair_from_msg(&msg, &mut got, num_ntts, k);
            ntt.forward_transform_interleaved_scalar_from_layer(&mut got, num_ntts, k + 2);

            assert_eq!(
                got, want,
                "shape {si}: log_msg_pos={log_msg_pos} ntts={num_ntts} k={k}"
            );
        }
    }

    #[test]
    fn forward_inverse_roundtrip() {
        let mut rng = Rng::new(0xAB1);
        for log_d in [1usize, 2, 3, 4, 6, 8] {
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, 1 << log_d);
            let mut v = original.clone();
            ntt.forward_transform(&mut v);
            ntt.inverse_transform(&mut v);
            assert_eq!(v, original, "roundtrip failed at log_d={log_d}");
        }
    }

    #[test]
    fn inverse_forward_roundtrip() {
        let mut rng = Rng::new(0xAB2);
        for log_d in [1usize, 2, 3, 4, 6, 8] {
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, 1 << log_d);
            let mut v = original.clone();
            ntt.inverse_transform(&mut v);
            ntt.forward_transform(&mut v);
            assert_eq!(
                v, original,
                "inverse∘forward roundtrip failed at log_d={log_d}"
            );
        }
    }

    #[test]
    fn forward_is_linear() {
        let mut rng = Rng::new(0xAB3);
        for log_d in [1usize, 2, 3, 5] {
            let ntt = AdditiveNttF128::standard(log_d);
            let n = 1 << log_d;
            let a = rand_vec(&mut rng, n);
            let b = rand_vec(&mut rng, n);
            let ab: Vec<F128> = a.iter().zip(&b).map(|(x, y)| *x + *y).collect();

            let mut fa = a.clone();
            ntt.forward_transform(&mut fa);
            let mut fb = b.clone();
            ntt.forward_transform(&mut fb);
            let mut fab = ab.clone();
            ntt.forward_transform(&mut fab);

            for i in 0..n {
                assert_eq!(
                    fa[i] + fb[i],
                    fab[i],
                    "linearity fails at i={i}, log_d={log_d}"
                );
            }
        }
    }

    #[test]
    fn ntt_of_zero_is_zero() {
        for log_d in [1usize, 2, 3, 6] {
            let ntt = AdditiveNttF128::standard(log_d);
            let mut v = vec![F128::ZERO; 1 << log_d];
            ntt.forward_transform(&mut v);
            assert!(v.iter().all(|&x| x == F128::ZERO));
        }
    }

    #[test]
    fn twiddle_at_layer_0_uses_full_basis_minus_one() {
        let ntt = AdditiveNttF128::standard(4);
        assert_eq!(ntt.twiddle(0, 0), F128::ZERO);
    }

    #[test]
    fn precomputed_twiddles_match_span_reference_and_cap() {
        for log_d in [1usize, 2, 5, 8, 12] {
            let ntt = AdditiveNttF128::standard(log_d);
            let table = ntt
                .precomputed_twiddles
                .as_ref()
                .expect("production-size domain should cache twiddles");
            assert_eq!(table.len(), (1usize << log_d) - 1);

            for layer in 0..log_d {
                let eval_row = &ntt.evals[log_d - layer - 1];
                for block in 0..(1usize << layer) {
                    assert_eq!(
                        ntt.twiddle(layer, block),
                        span_get(&eval_row[1..], block),
                        "cached twiddle mismatch at log_d={log_d}, layer={layer}, block={block}"
                    );
                }
            }
        }

        let cached_a = AdditiveNttF128::standard(8);
        let cached_b = AdditiveNttF128::standard(8);
        assert!(Arc::ptr_eq(
            cached_a.precomputed_twiddles.as_ref().unwrap(),
            cached_b.precomputed_twiddles.as_ref().unwrap()
        ));

        let fallback = AdditiveNttF128::standard(MAX_PRECOMPUTED_TWIDDLE_LOG + 1);
        assert!(fallback.precomputed_twiddles.is_none());
        let layer = MAX_PRECOMPUTED_TWIDDLE_LOG;
        let block = (1usize << layer) - 1;
        let eval_row = &fallback.evals[fallback.log_domain_size() - layer - 1];
        assert_eq!(
            fallback.twiddle(layer, block),
            span_get(&eval_row[1..], block)
        );
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    #[test]
    fn neon_matches_scalar() {
        let mut rng = Rng::new(0xBB1);
        for log_d in 1..=10 {
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, 1 << log_d);
            let mut v_scalar = original.clone();
            ntt.forward_transform_scalar(&mut v_scalar);
            let mut v_neon = original.clone();
            ntt.forward_transform_neon(&mut v_neon);
            assert_eq!(
                v_neon, v_scalar,
                "NEON disagrees with scalar at log_d={log_d}"
            );
        }
    }

    #[test]
    fn interleaved_matches_per_lane() {
        let mut rng = Rng::new(0xCC1);
        for log_d in [3usize, 4, 8] {
            for num_ntts in [1usize, 2, 4, 8] {
                let ntt = AdditiveNttF128::standard(log_d);
                let n_total = (1 << log_d) * num_ntts;
                let original = rand_vec(&mut rng, n_total);

                let mut v_inter = original.clone();
                ntt.forward_transform_interleaved_scalar(&mut v_inter, num_ntts);

                let mut v_ref = original.clone();
                for lane in 0..num_ntts {
                    let mut sub: Vec<F128> = (0..(1 << log_d))
                        .map(|pos| v_ref[pos * num_ntts + lane])
                        .collect();
                    ntt.forward_transform_scalar(&mut sub);
                    for pos in 0..(1 << log_d) {
                        v_ref[pos * num_ntts + lane] = sub[pos];
                    }
                }

                assert_eq!(
                    v_inter, v_ref,
                    "interleaved mismatch at log_d={log_d}, num_ntts={num_ntts}"
                );
            }
        }
    }

    #[test]
    fn rs_encode_matches_zero_padded_full_ntt() {
        let mut rng = Rng::new(0x5EED);
        for (log_d, num_ntts, log_inv_rate) in [
            (4usize, 1usize, 1usize),
            (5, 2, 1),
            (8, 8, 1),
            (10, 8, 2),
            (12, 64, 1),
        ] {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> log_inv_rate;
            let msg = rand_vec(&mut rng, msg_len);

            let mut encoded = rand_vec(&mut rng, codeword_len);
            ntt.rs_encode_interleaved(&msg, &mut encoded, num_ntts);

            let mut oracle = vec![F128::ZERO; codeword_len];
            oracle[..msg_len].copy_from_slice(&msg);
            ntt.forward_transform_interleaved_scalar(&mut oracle, num_ntts);
            assert_eq!(
                encoded, oracle,
                "RS encoding mismatch at log_d={log_d}, num_ntts={num_ntts}, r={log_inv_rate}"
            );
        }
    }

    #[test]
    fn rs_encode_streamed_matches_plain_and_ranges_are_final() {
        let mut rng = Rng::new(0x57AE);
        for (log_d, num_ntts, log_inv_rate, n_chunks, threads, min_callbacks) in [
            (4usize, 1usize, 1usize, 8usize, 0usize, 1usize),
            (8, 8, 1, 8, 0, 1),
            (10, 8, 2, 4, 0, 1),
            (12, 64, 1, 8, 0, 1),
            (13, 8, 1, 8, 0, 1),
            (13, 8, 1, 8, 8, 8),
            (13, 8, 1, 5, 8, 5),
            (14, 32, 1, 8, 8, 8),
            (14, 8, 2, 3, 4, 3),
        ] {
            for _rep in 0..if threads > 0 { 4 } else { 1 } {
                let ntt = AdditiveNttF128::standard(log_d);
                let codeword_len = (1usize << log_d) * num_ntts;
                let msg_len = codeword_len >> log_inv_rate;
                let msg = rand_vec(&mut rng, msg_len);

                let mut plain = rand_vec(&mut rng, codeword_len);
                ntt.rs_encode_interleaved(&msg, &mut plain, num_ntts);

                let mut streamed = rand_vec(&mut rng, codeword_len);
                let mut seen: Vec<(usize, core::ops::Range<usize>)> = Vec::new();
                let mut snapshots: Vec<u64> = Vec::new();
                let base = streamed.as_ptr() as usize;
                let checksum = |lo: usize, hi: usize| -> u64 {
                    let mut acc = 0u64;
                    for i in lo * num_ntts..hi * num_ntts {
                        let v = unsafe { *(base as *const F128).add(i) };
                        acc = acc
                            .wrapping_mul(0x9E37_79B9_7F4A_7C15)
                            .wrapping_add(v.lo ^ v.hi);
                    }
                    acc
                };
                let mut on_chunk = |idx: usize, range: core::ops::Range<usize>| {
                    snapshots.push(checksum(range.start, range.end));
                    seen.push((idx, range));
                };
                if threads > 0 {
                    rayon::ThreadPoolBuilder::new()
                        .num_threads(threads)
                        .build()
                        .unwrap()
                        .install(|| {
                            ntt.rs_encode_interleaved_streamed(
                                &msg,
                                &mut streamed,
                                num_ntts,
                                n_chunks,
                                &mut on_chunk,
                            );
                        });
                } else {
                    ntt.rs_encode_interleaved_streamed(
                        &msg,
                        &mut streamed,
                        num_ntts,
                        n_chunks,
                        &mut on_chunk,
                    );
                }

                assert_eq!(
                    plain, streamed,
                    "streamed codeword mismatch at log_d={log_d} num_ntts={num_ntts} rate={log_inv_rate}"
                );
                assert!(
                    seen.len() >= min_callbacks,
                    "expected >= {min_callbacks} callbacks, got {} (log_d={log_d} \
                 num_ntts={num_ntts} threads={threads})",
                    seen.len()
                );
                let n_positions = 1usize << log_d;
                let mut expect_start = 0usize;
                for (i, (idx, range)) in seen.iter().enumerate() {
                    assert_eq!(*idx, i, "chunk indices must be sequential");
                    assert_eq!(range.start, expect_start, "ranges must be contiguous");
                    assert!(range.end > range.start);
                    expect_start = range.end;
                }
                assert_eq!(expect_start, n_positions, "ranges must cover the codeword");
                for ((_, range), snap) in seen.iter().zip(&snapshots) {
                    assert_eq!(
                        checksum(range.start, range.end),
                        *snap,
                        "chunk {range:?} changed after its callback (not final)"
                    );
                }
            }
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    #[test]
    fn rate_half_layer2_seed_matches_full_ntt() {
        let mut rng = Rng::new(0xD1EC7);
        for (log_d, num_ntts, threads) in
            [(4usize, 1usize, 1usize), (5, 2, 1), (8, 8, 1), (12, 64, 4)]
        {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);
            let mut encoded = rand_vec(&mut rng, codeword_len);

            rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap()
                .install(|| {
                    ntt.seed_rate_half_layers_1_through_2(&msg, &mut encoded, num_ntts);
                    ntt.forward_transform_interleaved_from_layer(&mut encoded, num_ntts, 3);
                });

            let mut oracle = vec![F128::ZERO; codeword_len];
            oracle[..msg_len].copy_from_slice(&msg);
            ntt.forward_transform_interleaved_scalar(&mut oracle, num_ntts);
            assert_eq!(
                encoded, oracle,
                "direct seed mismatch at log_d={log_d}, num_ntts={num_ntts}, threads={threads}"
            );
        }
    }

    #[cfg(all(target_arch = "x86_64", target_feature = "pclmulqdq"))]
    #[test]
    fn rate_half_layer2_seed_matches_full_ntt_x86() {
        let mut rng = Rng::new(0xD1EC7);
        for (log_d, num_ntts, threads) in
            [(4usize, 1usize, 1usize), (5, 2, 1), (8, 8, 1), (12, 64, 4)]
        {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);
            let mut encoded = junk_vec(codeword_len);

            rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap()
                .install(|| {
                    ntt.seed_rate_half_layers_1_through_2(&msg, &mut encoded, num_ntts);
                    ntt.forward_transform_interleaved_from_layer(&mut encoded, num_ntts, 3);
                });

            let mut oracle = vec![F128::ZERO; codeword_len];
            oracle[..msg_len].copy_from_slice(&msg);
            ntt.forward_transform_interleaved_scalar(&mut oracle, num_ntts);
            assert_eq!(
                encoded, oracle,
                "x86 direct seed mismatch at log_d={log_d}, num_ntts={num_ntts}, threads={threads}"
            );
        }
    }

    const JUNK_F128: F128 = F128 {
        lo: 0xA5A5A5A5A5A5A5A5,
        hi: 0xA5A5A5A5A5A5A5A5,
    };

    fn junk_vec(n: usize) -> Vec<F128> {
        vec![JUNK_F128; n]
    }

    fn apply_interleaved_layers_scalar(
        ntt: &AdditiveNttF128,
        data: &mut [F128],
        num_ntts: usize,
        start_layer: usize,
        end_layer: usize,
    ) {
        let log_d = log2_pow2(data.len() / num_ntts);
        let end_layer = end_layer.min(log_d);
        for layer in start_layer..end_layer {
            let num_blocks = 1usize << layer;
            let block_size = 1usize << (log_d - layer);
            let block_size_half = block_size >> 1;
            let block_size_bytes = block_size * num_ntts;
            for block in 0..num_blocks {
                let twiddle = ntt.twiddle(layer, block);
                let block_start = block * block_size_bytes;
                for row in 0..block_size_half {
                    let off_top = block_start + row * num_ntts;
                    let off_bot = off_top + block_size_half * num_ntts;
                    for lane in 0..num_ntts {
                        let v = data[off_bot + lane];
                        let new_u = data[off_top + lane] + v * twiddle;
                        data[off_top + lane] = new_u;
                        data[off_bot + lane] = v + new_u;
                    }
                }
            }
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn seed_matches_replica_layers_1_2() {
        let mut rng = Rng::new(0x5EED_A5);
        for (log_d, num_ntts) in [(12usize, 8usize), (12, 64), (14, 16)] {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);

            let mut reference = junk_vec(codeword_len);
            replicate_message_fill(&mut reference, &msg);
            apply_interleaved_layers_scalar(&ntt, &mut reference, num_ntts, 1, 3);

            let mut seeded = junk_vec(codeword_len);
            ntt.seed_rate_half_layers_1_through_2(&msg, &mut seeded, num_ntts);
            assert_eq!(
                seeded, reference,
                "seed != replica+layers 1-2 at log_d={log_d} num_ntts={num_ntts}"
            );
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn seed_then_layer3_matches_today_encode() {
        let mut rng = Rng::new(0x5EED_03);
        for (log_d, num_ntts) in [(12usize, 8usize), (12, 64), (14, 16)] {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);

            let mut replica = junk_vec(codeword_len);
            replicate_message_fill(&mut replica, &msg);
            ntt.forward_transform_interleaved_from_layer(&mut replica, num_ntts, 1);

            let mut seeded = junk_vec(codeword_len);
            ntt.seed_rate_half_layers_1_through_2(&msg, &mut seeded, num_ntts);
            ntt.forward_transform_interleaved_from_layer(&mut seeded, num_ntts, 3);
            assert_eq!(
                seeded, replica,
                "seed+from_layer(3) != replica+from_layer(1) at log_d={log_d} num_ntts={num_ntts}"
            );

            let mut oracle = vec![F128::ZERO; codeword_len];
            oracle[..msg_len].copy_from_slice(&msg);
            ntt.forward_transform_interleaved_scalar(&mut oracle, num_ntts);
            assert_eq!(
                seeded, oracle,
                "seed+from_layer(3) != scalar full NTT at log_d={log_d} num_ntts={num_ntts}"
            );

            let mut encoded = junk_vec(codeword_len);
            ntt.rs_encode_interleaved(&msg, &mut encoded, num_ntts);
            assert_eq!(
                encoded, replica,
                "rs_encode_interleaved != replica+from_layer(1) at log_d={log_d} num_ntts={num_ntts}"
            );

            let mut ranged = junk_vec(codeword_len);
            let n_positions = 1usize << log_d;
            let covered = std::sync::atomic::AtomicUsize::new(0);
            ntt.rs_encode_interleaved_on_range_done(&msg, &mut ranged, num_ntts, &|range, _| {
                assert!(range.start < range.end);
                covered.fetch_add(
                    range.end - range.start,
                    std::sync::atomic::Ordering::Relaxed,
                );
            });
            assert_eq!(
                ranged, replica,
                "on_range_done != replica+from_layer(1) at log_d={log_d} num_ntts={num_ntts}"
            );
            assert_eq!(
                covered.load(std::sync::atomic::Ordering::Relaxed),
                n_positions,
                "on_range_done ranges must cover"
            );

            let mut streamed = junk_vec(codeword_len);
            let mut on_chunk = |_idx: usize, _range: core::ops::Range<usize>| {};
            ntt.rs_encode_interleaved_streamed(&msg, &mut streamed, num_ntts, 8, &mut on_chunk);
            assert_eq!(
                streamed, replica,
                "streamed != replica+from_layer(1) at log_d={log_d} num_ntts={num_ntts}"
            );
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn seed_then_from_layer_1_disagrees() {
        let mut rng = Rng::new(0x5EED_01);
        let (log_d, num_ntts) = (12usize, 64usize);
        let ntt = AdditiveNttF128::standard(log_d);
        let codeword_len = (1usize << log_d) * num_ntts;
        let msg = rand_vec(&mut rng, codeword_len >> 1);

        let mut replica = junk_vec(codeword_len);
        replicate_message_fill(&mut replica, &msg);
        ntt.forward_transform_interleaved_from_layer(&mut replica, num_ntts, 1);

        let mut wrong = junk_vec(codeword_len);
        ntt.seed_rate_half_layers_1_through_2(&msg, &mut wrong, num_ntts);
        ntt.forward_transform_interleaved_from_layer(&mut wrong, num_ntts, 1);
        assert_ne!(
            wrong, replica,
            "seed+from_layer(1) must disagree with replica+from_layer(1)"
        );
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn seed_gate_off_uses_replica_from_layer() {
        let mut rng = Rng::new(0x5EED_0F);
        for (log_d, num_ntts, log_inv_rate) in [(12usize, 8usize, 2usize), (10, 8, 1)] {
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> log_inv_rate;
            let msg = rand_vec(&mut rng, msg_len);

            let mut replica = junk_vec(codeword_len);
            replicate_message_fill(&mut replica, &msg);
            ntt.forward_transform_interleaved_from_layer(&mut replica, num_ntts, log_inv_rate);

            let mut encoded = junk_vec(codeword_len);
            ntt.rs_encode_interleaved(&msg, &mut encoded, num_ntts);
            assert_eq!(
                encoded, replica,
                "off-gate encode != replica+from_layer({log_inv_rate}) at log_d={log_d}"
            );

            let mut ranged = junk_vec(codeword_len);
            ntt.rs_encode_interleaved_on_range_done(&msg, &mut ranged, num_ntts, &|_, _| {});
            assert_eq!(
                ranged, replica,
                "off-gate on_range_done != replica at log_d={log_d} r={log_inv_rate}"
            );

            let mut streamed = junk_vec(codeword_len);
            let mut on_chunk = |_idx: usize, _range: core::ops::Range<usize>| {};
            ntt.rs_encode_interleaved_streamed(&msg, &mut streamed, num_ntts, 4, &mut on_chunk);
            assert_eq!(
                streamed, replica,
                "off-gate streamed != replica at log_d={log_d} r={log_inv_rate}"
            );
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq")
    ))]
    #[test]
    fn interleaved_parallel_matches_scalar() {
        let mut rng = Rng::new(0xCC2);
        for log_d in [4usize, 10, 14, 17, 19] {
            for &num_ntts in &[1usize, 2, 8, 32, 64] {
                let n_total = (1 << log_d) * num_ntts;
                if n_total > 1 << 24 {
                    continue;
                }
                let ntt = AdditiveNttF128::standard(log_d);
                let original = rand_vec(&mut rng, n_total);
                let mut v_scalar = original.clone();
                ntt.forward_transform_interleaved_scalar(&mut v_scalar, num_ntts);
                let mut v_par = original.clone();
                ntt.forward_transform_interleaved_parallel(&mut v_par, num_ntts);
                assert_eq!(
                    v_par, v_scalar,
                    "interleaved parallel mismatch at log_d={log_d}, num_ntts={num_ntts}"
                );
            }
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq")
    ))]
    #[test]
    fn interleaved_parallel_from_deep_layer_matches_scalar() {
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(4)
            .build()
            .unwrap();
        pool.install(|| {
            let log_d = 12;
            let num_ntts = 64;
            let ntt = AdditiveNttF128::standard(log_d);
            let mut rng = Rng::new(0xCC3);
            let original = rand_vec(&mut rng, (1 << log_d) * num_ntts);

            for start_layer in 5..=9 {
                let mut expected = original.clone();
                ntt.forward_transform_interleaved_scalar_from_layer(
                    &mut expected,
                    num_ntts,
                    start_layer,
                );
                let mut actual = original.clone();
                ntt.forward_transform_interleaved_parallel_from_layer(
                    &mut actual,
                    num_ntts,
                    start_layer,
                );
                assert_eq!(
                    actual, expected,
                    "deep from-layer mismatch at start_layer={start_layer}"
                );
            }
        });
    }

    #[test]
    fn top_fusion_matches_incumbent_schedule() {
        use std::sync::atomic::Ordering;
        let mut rng = Rng::new(0x70F6);
        for &(log_d, num_ntts, start_layer, threads) in &[
            (17usize, 64usize, 0usize, 4usize),
            (17, 8, 3, 512),
            (17, 8, 0, 512),
            (16, 8, 1, 512),
            (15, 4, 0, 512),
        ] {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap();
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, (1 << log_d) * num_ntts);
            let (control, candidate) = pool.install(|| {
                TOP_FUSION_TEST_OFF.store(true, Ordering::Relaxed);
                let mut control = original.clone();
                ntt.forward_transform_interleaved_parallel_from_layer(
                    &mut control,
                    num_ntts,
                    start_layer,
                );
                TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
                let hits_before = TOP_FUSION_HITS.load(Ordering::Relaxed);
                let mut candidate = original.clone();
                ntt.forward_transform_interleaved_parallel_from_layer(
                    &mut candidate,
                    num_ntts,
                    start_layer,
                );
                assert!(
                    TOP_FUSION_HITS.load(Ordering::Relaxed) > hits_before,
                    "top fusion did not run at log_d={log_d} num_ntts={num_ntts} start={start_layer}"
                );
                (control, candidate)
            });
            let mut expected = original.clone();
            ntt.forward_transform_interleaved_scalar_from_layer(
                &mut expected,
                num_ntts,
                start_layer,
            );
            assert!(
                control == expected,
                "incumbent schedule mismatch at log_d={log_d} num_ntts={num_ntts} start={start_layer}"
            );
            assert!(
                candidate == expected,
                "top fusion mismatch at log_d={log_d} num_ntts={num_ntts} start={start_layer}"
            );
        }
    }

    #[test]
    fn direct_fused2_publish_mapping_is_exact() {
        const BLOCK_SIZE: usize = 1 << 17;
        const SUB_STRIDE: usize = BLOCK_SIZE / 64;
        const ROWS: usize = 1 << 20;

        for permuted in [false, true] {
            let mut stage_seen = [false; 64];
            for k in 0..64 {
                let physical = seed_top_stage_row(k, permuted);
                assert!(physical < 64);
                assert!(!stage_seen[physical], "duplicate staging row {physical}");
                stage_seen[physical] = true;
            }
            assert!(stage_seen.into_iter().all(|seen| seen));

            let step = if permuted { 16 } else { 1 };
            for m in 0..16 {
                let first = seed_top_stage_row(4 * m, permuted);
                for t in 0..4 {
                    assert_eq!(first + t * step, seed_top_stage_row(4 * m + t, permuted));
                }
            }
        }

        let mut visited = vec![false; ROWS];
        for block in 0..8 {
            for r in 0..SUB_STRIDE {
                for k in 0..64 {
                    let row = seed_top_codeword_row(block, r, k, BLOCK_SIZE, SUB_STRIDE);
                    assert!(row < ROWS);
                    assert!(!visited[row], "codeword row {row} visited twice");
                    visited[row] = true;
                }
            }
        }
        assert!(visited.into_iter().all(|seen| seen));
        assert_eq!(seed_top_codeword_row(0, 0, 0, BLOCK_SIZE, SUB_STRIDE), 0);
        assert_eq!(
            seed_top_codeword_row(7, SUB_STRIDE - 1, 63, BLOCK_SIZE, SUB_STRIDE),
            ROWS - 1
        );
    }

    #[test]
    fn direct_fused2_publish_shape_falls_back_safely() {
        assert!(direct_fused2_publish_shape(20, 64, 0));
        assert!(direct_fused2_publish_shape(20, 64, 4));
        assert!(!direct_fused2_publish_shape(20, 64, 7));
        assert!(!direct_fused2_publish_shape(19, 64, 4));
        assert!(!direct_fused2_publish_shape(20, 32, 4));
        assert!(!direct_fused2_publish_shape(20, 64, 8));
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn seed_top_fusion_matches_seed_pass() {
        use std::sync::atomic::Ordering;
        let mut rng = Rng::new(0x5EED_F8);
        for &(log_d, num_ntts, threads) in
            &[(17usize, 8usize, 512usize), (17, 4, 512), (18, 8, 512)]
        {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap();
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);
            let (control, candidate, ranges_ok) = pool.install(|| {
                assert!(
                    AdditiveNttF128::interleaved_n_top(log_d, num_ntts) >= 9,
                    "test shape must have ≥ 9 top layers"
                );
                SEED_TOP_FUSION_TEST_OFF.store(true, Ordering::Relaxed);
                let mut control = junk_vec(codeword_len);
                ntt.rs_encode_interleaved(&msg, &mut control, num_ntts);
                SEED_TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
                let mut candidate = junk_vec(codeword_len);
                let hits_before = SEED_TOP_FUSION_HITS.load(Ordering::Relaxed);
                let covered = std::sync::atomic::AtomicUsize::new(0);
                ntt.rs_encode_interleaved_on_range_done(
                    &msg,
                    &mut candidate,
                    num_ntts,
                    &|range, sub| {
                        assert_eq!(sub.len(), range.len() * num_ntts);
                        covered.fetch_add(range.len(), Ordering::Relaxed);
                    },
                );
                assert!(
                    SEED_TOP_FUSION_HITS.load(Ordering::Relaxed) > hits_before,
                    "seed fusion did not run at log_d={log_d} num_ntts={num_ntts}"
                );
                (
                    control,
                    candidate,
                    covered.load(Ordering::Relaxed) == 1 << log_d,
                )
            });
            assert!(
                ranges_ok,
                "on_range_done did not cover the codeword once at log_d={log_d}"
            );
            let mut oracle = vec![F128::ZERO; codeword_len];
            oracle[..msg_len].copy_from_slice(&msg);
            ntt.forward_transform_interleaved_scalar(&mut oracle, num_ntts);
            assert!(
                control == oracle,
                "separate seed pass mismatch at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                candidate == oracle,
                "seed fusion mismatch at log_d={log_d} num_ntts={num_ntts}"
            );
        }
    }

    #[test]
    fn cached_standard_evals_match_fresh_build() {
        for dim in [1usize, 2, 4, 12, 16, 19, 20, 21, 64] {
            let basis: Vec<F128> = (0..dim).map(|i| F128::new(1u64 << i, 0)).collect();
            let fresh = generate_evals_from_subspace(&basis);
            let cached = cached_standard_evals(dim);
            assert_eq!(*cached, fresh, "evals mismatch at dim={dim}");
            let again = cached_standard_evals(dim);
            assert_eq!(*again, fresh, "evals mismatch on second call at dim={dim}");
            let cache_on = !matches!(std::env::var_os("FLOCK_NO_EVALS_CACHE"), Some(v) if v == "1");
            if cache_on {
                assert!(Arc::ptr_eq(&cached, &again), "dim={dim} was rebuilt");
            }
            if dim > 0 && dim <= 20 {
                let a = AdditiveNttF128::standard(dim);
                let b = AdditiveNttF128::new(&basis);
                assert_eq!(a.log_domain_size(), b.log_domain_size());
                for layer in 0..dim {
                    for block in 0..(1usize << layer).min(64) {
                        assert_eq!(
                            a.twiddle(layer, block),
                            b.twiddle(layer, block),
                            "twiddle mismatch dim={dim} layer={layer} block={block}"
                        );
                    }
                }
            }
        }
    }

    #[test]
    #[ignore]
    fn standard_ctor_cost_probe() {
        for dim in [12usize, 16, 19, 20] {
            let t0 = std::time::Instant::now();
            std::hint::black_box(AdditiveNttF128::standard(dim));
            let cold = t0.elapsed().as_secs_f64() * 1e3;
            let reps = 200;
            let t = std::time::Instant::now();
            for _ in 0..reps {
                std::hint::black_box(AdditiveNttF128::standard(dim));
            }
            let per = t.elapsed().as_secs_f64() * 1e6 / reps as f64;
            eprintln!(
                "[probe] AdditiveNttF128::standard({dim}) = {per:.2} us/call warm (first call {cold:.2} ms, one-time twiddle build)"
            );
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn fused_staging_poison_does_not_change_output() {
        use std::sync::atomic::Ordering;
        static GUARD: std::sync::Mutex<()> = std::sync::Mutex::new(());
        let _g = GUARD.lock().unwrap_or_else(|e| e.into_inner());

        let mut rng = Rng::new(0x5741_6E47);
        for &(log_d, num_ntts, threads) in &[(17usize, 8usize, 512usize), (17, 4, 512)] {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap();
            let ntt = AdditiveNttF128::standard(log_d);
            let codeword_len = (1usize << log_d) * num_ntts;
            let msg_len = codeword_len >> 1;
            let msg = rand_vec(&mut rng, msg_len);
            let dense = rand_vec(&mut rng, codeword_len);

            let run = |mode: u8| -> (Vec<F128>, Vec<F128>, bool, bool) {
                STAGING_INIT_TEST_MODE.store(mode, Ordering::SeqCst);
                let out = pool.install(|| {
                    let seed_before = SEED_TOP_FUSION_HITS.load(Ordering::Relaxed);
                    let mut encoded = junk_vec(codeword_len);
                    ntt.rs_encode_interleaved(&msg, &mut encoded, num_ntts);
                    let seed_fired = SEED_TOP_FUSION_HITS.load(Ordering::Relaxed) > seed_before;

                    let top_before = TOP_FUSION_HITS.load(Ordering::Relaxed);
                    let mut forward = dense.clone();
                    ntt.forward_transform_interleaved_parallel_from_layer(
                        &mut forward,
                        num_ntts,
                        0,
                    );
                    let top_fired = TOP_FUSION_HITS.load(Ordering::Relaxed) > top_before;
                    (encoded, forward, seed_fired, top_fired)
                });
                STAGING_INIT_TEST_MODE.store(0, Ordering::SeqCst);
                out
            };

            let (enc_zero, fwd_zero, seed_fired, top_fired) = run(1);
            assert!(
                seed_fired,
                "seed fusion did not run at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                top_fired,
                "top fusion did not run at log_d={log_d} num_ntts={num_ntts}"
            );
            let (enc_poison, fwd_poison, ..) = run(2);
            let (enc_uninit, fwd_uninit, ..) = run(3);

            assert!(
                enc_zero == enc_poison,
                "poisoned staging changed the codeword at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                enc_zero == enc_uninit,
                "uninit staging changed the codeword at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                fwd_zero == fwd_poison,
                "poisoned staging changed the forward transform at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                fwd_zero == fwd_uninit,
                "uninit staging changed the forward transform at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                !enc_poison.contains(&STAGING_POISON) && !fwd_poison.contains(&STAGING_POISON),
                "poison sentinel leaked into the output at log_d={log_d} num_ntts={num_ntts}"
            );
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    #[test]
    fn batched_matches_scalar() {
        let mut rng = Rng::new(0xBB4);
        for log_d in [4usize, 8, 12, 17, 18, 19, 20] {
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, 1 << log_d);
            let mut v_scalar = original.clone();
            ntt.forward_transform_scalar(&mut v_scalar);
            let mut v_batched = original.clone();
            ntt.forward_transform_batched(&mut v_batched);
            assert_eq!(
                v_batched, v_scalar,
                "batched disagrees with scalar at log_d={log_d}"
            );
        }
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    #[test]
    fn parallel_matches_scalar() {
        let mut rng = Rng::new(0xBB2);
        for log_d in [4usize, 8, 12, 15, 16] {
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, 1 << log_d);
            let mut v_scalar = original.clone();
            ntt.forward_transform_scalar(&mut v_scalar);
            let mut v_par = original.clone();
            ntt.forward_transform_parallel(&mut v_par);
            assert_eq!(
                v_par, v_scalar,
                "parallel disagrees with scalar at log_d={log_d}"
            );
        }
    }

    #[test]
    fn deepest_layer_twiddle_count() {
        let log_d = 4;
        let ntt = AdditiveNttF128::standard(log_d);
        for b in 0..8 {
            let _t = ntt.twiddle(log_d - 1, b);
        }
    }

    #[test]
    fn fused3_leaf_matches_incumbent_sweeps() {
        let mut rng = Rng::new(0xF3F3_0BEE);
        for &num_ntts in &[1usize, 3, 4, 5, 7, 8, 13, 16, 64] {
            let mut tw = [F128::ZERO; 7];
            for t in tw.iter_mut() {
                *t = rng.f128();
            }
            let base = rand_vec(&mut rng, 8 * num_ntts);

            let mut expected = base.clone();
            for parity in 0..2usize {
                let mut rows: [Vec<F128>; 4] = [
                    expected[(parity) * num_ntts..(parity + 1) * num_ntts].to_vec(),
                    expected[(parity + 2) * num_ntts..(parity + 3) * num_ntts].to_vec(),
                    expected[(parity + 4) * num_ntts..(parity + 5) * num_ntts].to_vec(),
                    expected[(parity + 6) * num_ntts..(parity + 7) * num_ntts].to_vec(),
                ];
                let (a, rest) = rows.split_at_mut(1);
                let (b, rest) = rest.split_at_mut(1);
                let (c, d) = rest.split_at_mut(1);
                kernels::butterfly_fused_2layer(
                    &mut a[0], &mut b[0], &mut c[0], &mut d[0], tw[0], tw[1], tw[2],
                );
                for (k, row) in rows.iter().enumerate() {
                    let base_row = parity + 2 * k;
                    expected[base_row * num_ntts..(base_row + 1) * num_ntts].copy_from_slice(row);
                }
            }
            for s in 0..4usize {
                let (top, bot) = expected.split_at_mut((2 * s + 1) * num_ntts);
                kernels::butterfly_row_pair(
                    &mut top[2 * s * num_ntts..],
                    &mut bot[..num_ntts],
                    tw[3 + s],
                );
            }

            let mut dense = base.clone();
            unsafe {
                kernels::butterfly_fused_3layer_rows(dense.as_mut_ptr(), num_ntts, num_ntts, &tw);
            }
            assert!(
                dense == expected,
                "fused3 leaf mismatch at num_ntts={num_ntts}"
            );

            for tail in 1..num_ntts.min(9) {
                let dense_lanes = num_ntts - tail;
                let mut armed = base.clone();
                for i in [1usize, 3, 5, 7] {
                    for lane in dense_lanes..num_ntts {
                        armed[i * num_ntts + lane] = F128::ZERO;
                    }
                }
                let mut want = armed.clone();
                unsafe {
                    kernels::butterfly_fused_3layer_rows(
                        want.as_mut_ptr(),
                        num_ntts,
                        num_ntts,
                        &tw,
                    );
                }
                let mut got = armed;
                unsafe {
                    kernels::butterfly_fused_3layer_rows(
                        got.as_mut_ptr(),
                        num_ntts,
                        dense_lanes,
                        &tw,
                    );
                }
                assert!(
                    got == want,
                    "fused3 zero-odd tail mismatch at num_ntts={num_ntts} tail={tail}"
                );
            }
        }
    }

    #[cfg(any(
        all(target_arch = "aarch64", target_feature = "aes"),
        all(target_arch = "x86_64", target_feature = "pclmulqdq"),
    ))]
    #[test]
    fn deep_fused3_matches_incumbent_schedule() {
        use std::sync::atomic::Ordering;
        let mut rng = Rng::new(0xDEE9_F3);
        for &(log_d, num_ntts, start_layer, threads) in &[
            (13usize, 4usize, 0usize, 4usize),
            (13, 8, 0, 4),
            (13, 8, 2, 4),
            (15, 64, 0, 4),
        ] {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(threads)
                .build()
                .unwrap();
            let ntt = AdditiveNttF128::standard(log_d);
            let original = rand_vec(&mut rng, (1 << log_d) * num_ntts);
            let (control, candidate) = pool.install(|| {
                assert_eq!(
                    log_d - AdditiveNttF128::interleaved_n_top(log_d, num_ntts),
                    11,
                    "shape ({log_d}, {num_ntts}) is not an 11-layer deep region"
                );
                KERNEL_DIET_TEST_OFF.store(3, Ordering::Relaxed);
                let mut control = original.clone();
                ntt.forward_transform_interleaved_parallel_from_layer(
                    &mut control,
                    num_ntts,
                    start_layer,
                );
                KERNEL_DIET_TEST_OFF.store(0, Ordering::Relaxed);
                let hits_before = FUSED3_HITS.load(Ordering::Relaxed);
                let mut candidate = original.clone();
                ntt.forward_transform_interleaved_parallel_from_layer(
                    &mut candidate,
                    num_ntts,
                    start_layer,
                );
                assert!(
                    FUSED3_HITS.load(Ordering::Relaxed) > hits_before,
                    "fused-three deep tail did not run at log_d={log_d} num_ntts={num_ntts}"
                );
                (control, candidate)
            });
            let mut expected = original.clone();
            ntt.forward_transform_interleaved_scalar_from_layer(
                &mut expected,
                num_ntts,
                start_layer,
            );
            assert!(
                control == expected,
                "incumbent deep tail mismatch at log_d={log_d} num_ntts={num_ntts}"
            );
            assert!(
                candidate == expected,
                "fused-three deep tail mismatch at log_d={log_d} num_ntts={num_ntts}"
            );
        }
    }

    fn portable_row_from_replica(
        src: &[F128],
        dst: &mut [F128],
        quarter: usize,
        num_ntts: usize,
        r: usize,
        twiddles: [F128; 3],
    ) {
        let [t_outer, t_inner_a, t_inner_b] = twiddles;
        for lane in 0..num_ntts {
            let mut a = src[r * num_ntts + lane];
            let mut b = src[(quarter + r) * num_ntts + lane];
            let mut c = src[(2 * quarter + r) * num_ntts + lane];
            let mut d = src[(3 * quarter + r) * num_ntts + lane];

            let new_a = a + c * t_outer;
            c += new_a;
            a = new_a;
            let new_b = b + d * t_outer;
            d += new_b;
            b = new_b;

            let new_a = a + b * t_inner_a;
            b += new_a;
            a = new_a;
            let new_c = c + d * t_inner_b;
            d += new_c;
            c = new_c;

            dst[r * num_ntts + lane] = a;
            dst[(quarter + r) * num_ntts + lane] = b;
            dst[(2 * quarter + r) * num_ntts + lane] = c;
            dst[(3 * quarter + r) * num_ntts + lane] = d;
        }
    }

    fn portable_row_from_sparse_replica(
        src: &[F128],
        dst: &mut [F128],
        quarter: usize,
        num_ntts: usize,
        r: usize,
        right_twiddle: F128,
    ) {
        for lane in 0..num_ntts {
            let a = src[r * num_ntts + lane];
            let mut b = src[(quarter + r) * num_ntts + lane];
            let mut c = src[(2 * quarter + r) * num_ntts + lane];
            let mut d = src[(3 * quarter + r) * num_ntts + lane];

            c += a;
            d += b;
            b += a;
            let new_c = c + d * right_twiddle;
            d += new_c;
            c = new_c;

            dst[r * num_ntts + lane] = a;
            dst[(quarter + r) * num_ntts + lane] = b;
            dst[(2 * quarter + r) * num_ntts + lane] = c;
            dst[(3 * quarter + r) * num_ntts + lane] = d;
        }
    }

    #[cfg(all(target_arch = "x86_64", target_feature = "pclmulqdq"))]
    #[test]
    fn avx512_row_from_matches_portable_replica() {
        let mut rng = Rng::new(0xA512_F20);
        for (quarter, num_ntts) in [
            (1usize, 1usize),
            (2, 3),
            (4, 5),
            (4, 7),
            (8, 8),
            (8, 64),
            (16, 64),
        ] {
            let n = 4 * quarter * num_ntts;
            let src = rand_vec(&mut rng, n);
            let twiddles = [rng.f128(), rng.f128(), rng.f128()];
            let right = rng.f128();

            for r in 0..quarter {
                let mut expect = junk_vec(n);
                portable_row_from_replica(&src, &mut expect, quarter, num_ntts, r, twiddles);
                let mut got = junk_vec(n);
                unsafe {
                    kernels::butterfly_fused_2layer_row_from(
                        src.as_ptr(),
                        got.as_mut_ptr(),
                        quarter,
                        num_ntts,
                        r,
                        &twiddles,
                    );
                }
                assert_eq!(
                    got, expect,
                    "dense row-from mismatch quarter={quarter} num_ntts={num_ntts} r={r}"
                );

                let mut expect_s = junk_vec(n);
                portable_row_from_sparse_replica(&src, &mut expect_s, quarter, num_ntts, r, right);
                let mut got_s = junk_vec(n);
                unsafe {
                    kernels::butterfly_fused_2layer_row_from_sparse(
                        src.as_ptr(),
                        got_s.as_mut_ptr(),
                        quarter,
                        num_ntts,
                        r,
                        right,
                    );
                }
                assert_eq!(
                    got_s, expect_s,
                    "sparse row-from mismatch quarter={quarter} num_ntts={num_ntts} r={r}"
                );
                for lane in 0..num_ntts {
                    assert_eq!(
                        got_s[r * num_ntts + lane],
                        src[r * num_ntts + lane],
                        "sparse must leave a unchanged"
                    );
                }
            }
        }
    }
}

#[cfg(test)]
mod zero_lane_ranked_ab_probe {
    use super::*;

    fn ranked_buffer(seed: u64) -> Vec<F128> {
        const NUM_NTTS: usize = 64;
        const MSG_POS: usize = 1 << 19;
        let mut st = seed | 1;
        let mut next = move || {
            st ^= st << 13;
            st ^= st >> 7;
            st ^= st << 17;
            st
        };
        let mut msg = vec![F128::ZERO; MSG_POS * NUM_NTTS];
        for pos in 0..MSG_POS {
            let live = if pos & 1 == 1 { 57 } else { NUM_NTTS };
            for lane in 0..live {
                msg[pos * NUM_NTTS + lane] = F128 {
                    lo: next(),
                    hi: next(),
                };
            }
        }
        let mut data = Vec::with_capacity(2 * msg.len());
        data.extend_from_slice(&msg);
        data.extend_from_slice(&msg);
        data
    }

    #[test]
    #[ignore = "ranked shape: ~2.5 GiB resident"]
    fn seed_top_fusion_ranked_ab() {
        use std::sync::atomic::Ordering;
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        const MSG_POS: usize = 1 << 19;
        let ntt = AdditiveNttF128::standard(20);
        let msg: Vec<F128> = ranked_buffer(0x5EED_F8_0BEE_D00D)[..MSG_POS * NUM_NTTS].to_vec();
        let _g = ZeroOddTailLanes::scope(NUM_NTTS, 7);

        SEED_TOP_FUSION_TEST_OFF.store(true, Ordering::Relaxed);
        let mut control = vec![F128::ZERO; 2 * msg.len()];
        ntt.rs_encode_interleaved(&msg, &mut control, NUM_NTTS);
        SEED_TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
        let mut candidate = vec![F128 { lo: !0, hi: !0 }; 2 * msg.len()];
        ntt.rs_encode_interleaved(&msg, &mut candidate, NUM_NTTS);
        assert!(
            control == candidate,
            "seed fusion changed the ranked encode output"
        );
        drop(control);

        let mut best = [f64::MAX; 2];
        for rep in 0..6 {
            for arm in 0..2 {
                SEED_TOP_FUSION_TEST_OFF.store(arm == 0, Ordering::Relaxed);
                let t = Instant::now();
                ntt.rs_encode_interleaved(&msg, &mut candidate, NUM_NTTS);
                let ms = t.elapsed().as_secs_f64() * 1e3;
                std::hint::black_box(&candidate);
                if ms < best[arm] {
                    best[arm] = ms;
                }
                let name = if arm == 0 { "seed+top6" } else { "seedtop8" };
                println!("rep={rep} arm={name} ms={ms:.2}");
            }
        }
        SEED_TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
        let delta = (best[0] - best[1]) / best[0] * 100.0;
        println!(
            "MIN seed+top6={:.2} ms  seedtop8={:.2} ms  delta={delta:+.2}%",
            best[0], best[1]
        );
    }

    #[test]
    #[ignore = "ranked shape: ~3 GiB resident"]
    fn top_fusion_ranked_ab() {
        use std::sync::atomic::Ordering;
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        let ntt = AdditiveNttF128::standard(20);
        let pristine = ranked_buffer(0x70F6_0BEE_D00D_5678);
        let _g = ZeroOddTailLanes::scope(NUM_NTTS, 7);

        TOP_FUSION_TEST_OFF.store(true, Ordering::Relaxed);
        let mut control = pristine.clone();
        ntt.forward_transform_interleaved_from_layer(&mut control, NUM_NTTS, 3);
        TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
        let mut candidate = pristine.clone();
        ntt.forward_transform_interleaved_from_layer(&mut candidate, NUM_NTTS, 3);
        assert!(
            control == candidate,
            "top fusion changed the ranked transform output"
        );
        drop(candidate);
        drop(control);

        let mut best = [f64::MAX; 2];
        for rep in 0..6 {
            for arm in 0..2 {
                TOP_FUSION_TEST_OFF.store(arm == 0, Ordering::Relaxed);
                let mut data = pristine.clone();
                let t = Instant::now();
                ntt.forward_transform_interleaved_from_layer(&mut data, NUM_NTTS, 3);
                let ms = t.elapsed().as_secs_f64() * 1e3;
                std::hint::black_box(&data);
                if ms < best[arm] {
                    best[arm] = ms;
                }
                let name = if arm == 0 { "incumbent" } else { "fused6" };
                println!("rep={rep} arm={name} ms={ms:.2}");
            }
        }
        TOP_FUSION_TEST_OFF.store(false, Ordering::Relaxed);
        let delta = (best[0] - best[1]) / best[0] * 100.0;
        println!(
            "MIN incumbent={:.2} ms  fused6={:.2} ms  delta={delta:+.2}%",
            best[0], best[1]
        );
    }

    #[test]
    #[ignore = "timing probe"]
    fn fused3_leaf_ab() {
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        const ROWS: usize = 8;
        let block = ROWS * NUM_NTTS;
        let odd_tail: usize = std::env::var("FLOCK_PROBE_TAIL")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(4);
        let dense_lanes = NUM_NTTS - odd_tail;
        let reps: usize = std::env::var("FLOCK_PROBE_REPS")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(9);

        let mut st = 0x9E37_79B9_7F4A_7C15u64;
        let mut next = move || {
            st ^= st << 13;
            st ^= st >> 7;
            st ^= st << 17;
            st
        };
        let mut tw = [F128::ZERO; 7];
        for t in tw.iter_mut() {
            *t = F128 {
                lo: next(),
                hi: next(),
            };
        }

        for &blocks in &[1usize, 32, 256, 4096, 65536] {
            let mut data: Vec<F128> = (0..blocks * block)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            for b in 0..blocks {
                for i in [1usize, 3, 5, 7] {
                    for lane in dense_lanes..NUM_NTTS {
                        data[b * block + i * NUM_NTTS + lane] = F128::ZERO;
                    }
                }
            }
            let iters = ((1usize << 24) / (blocks * block).max(1)).max(1);
            let mut best = [f64::MAX; 2];
            for _ in 0..reps {
                for arm in 0..2 {
                    let t = Instant::now();
                    for _ in 0..iters {
                        for b in 0..blocks {
                            let blk = &mut data[b * block..(b + 1) * block];
                            if arm == 0 {
                                for parity in 0..2usize {
                                    let lanes = row_lanes(parity, NUM_NTTS, odd_tail);
                                    unsafe {
                                        let p = blk.as_mut_ptr().add(parity * NUM_NTTS);
                                        let a = std::slice::from_raw_parts_mut(p, lanes);
                                        let b2 = std::slice::from_raw_parts_mut(
                                            p.add(2 * NUM_NTTS),
                                            lanes,
                                        );
                                        let c = std::slice::from_raw_parts_mut(
                                            p.add(4 * NUM_NTTS),
                                            lanes,
                                        );
                                        let d = std::slice::from_raw_parts_mut(
                                            p.add(6 * NUM_NTTS),
                                            lanes,
                                        );
                                        kernels::butterfly_fused_2layer(
                                            a, b2, c, d, tw[0], tw[1], tw[2],
                                        );
                                    }
                                }
                                for s in 0..4usize {
                                    let (top, bot) = blk.split_at_mut((2 * s + 1) * NUM_NTTS);
                                    kernels::butterfly_row_pair(
                                        &mut top[2 * s * NUM_NTTS..],
                                        &mut bot[..NUM_NTTS],
                                        tw[3 + s],
                                    );
                                }
                            } else {
                                unsafe {
                                    kernels::butterfly_fused_3layer_rows(
                                        blk.as_mut_ptr(),
                                        NUM_NTTS,
                                        dense_lanes,
                                        &tw,
                                    );
                                }
                            }
                        }
                    }
                    let ns =
                        t.elapsed().as_secs_f64() * 1e9 / (iters * blocks * ROWS * NUM_NTTS) as f64;
                    std::hint::black_box(&data);
                    if ns < best[arm] {
                        best[arm] = ns;
                    }
                }
            }
            println!(
                "blocks={blocks:5} ({:6} KiB)  incumbent={:.4} ns/elem  fused3={:.4} ns/elem  delta={:+.2}%",
                blocks * block * 16 / 1024,
                best[0],
                best[1],
                (best[0] - best[1]) / best[0] * 100.0
            );
        }
    }

    #[test]
    #[ignore = "ranked shape: ~3 GiB resident"]
    fn kernel_diet_ranked_ab() {
        use std::sync::atomic::Ordering;
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        let ntt = AdditiveNttF128::standard(20);
        let pristine = ranked_buffer(0xD1E7_0BEE_D00D_9ABC);
        let _g = ZeroOddTailLanes::scope(NUM_NTTS, 7);

        KERNEL_DIET_TEST_OFF.store(3, Ordering::Relaxed);
        let mut control = pristine.clone();
        ntt.forward_transform_interleaved_from_layer(&mut control, NUM_NTTS, 3);
        KERNEL_DIET_TEST_OFF.store(0, Ordering::Relaxed);
        let hits_before = FUSED3_HITS.load(Ordering::Relaxed);
        let mut candidate = pristine.clone();
        ntt.forward_transform_interleaved_from_layer(&mut candidate, NUM_NTTS, 3);
        assert!(
            FUSED3_HITS.load(Ordering::Relaxed) > hits_before,
            "fused-three deep tail did not run at the ranked shape"
        );
        assert!(
            control == candidate,
            "kernel diet changed the ranked transform output"
        );
        drop(control);
        drop(candidate);

        let mut data = pristine;
        let arms = [3usize, 1, 2, 0];
        let names = ["incumbent", "fused3only", "laneonly", "diet"];
        let reps: usize = std::env::var("FLOCK_PROBE_REPS")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(12);
        for start in [17usize, 9, 3] {
            let mut samples = (0..4).map(|_| Vec::with_capacity(reps)).collect::<Vec<_>>();
            for rep in 0..reps {
                for pos in 0..4usize {
                    let k = (pos + rep) % 4;
                    let arm = arms[k];
                    KERNEL_DIET_TEST_OFF.store(arm, Ordering::Relaxed);
                    let t = Instant::now();
                    ntt.forward_transform_interleaved_from_layer(&mut data, NUM_NTTS, start);
                    let ms = t.elapsed().as_secs_f64() * 1e3;
                    std::hint::black_box(&data);
                    samples[k].push(ms);
                }
            }
            KERNEL_DIET_TEST_OFF.store(0, Ordering::Relaxed);
            let mut stat = [(0f64, 0f64); 4];
            for k in 0..4 {
                samples[k].sort_by(|a, b| a.partial_cmp(b).unwrap());
                stat[k] = (samples[k][0], samples[k][reps / 2]);
            }
            for k in 0..4 {
                println!(
                    "start={start} arm={:>10} min={:.2} med={:.2} ms  dmin={:+.2}% dmed={:+.2}%",
                    names[k],
                    stat[k].0,
                    stat[k].1,
                    (stat[0].0 - stat[k].0) / stat[0].0 * 100.0,
                    (stat[0].1 - stat[k].1) / stat[0].1 * 100.0,
                );
            }
        }
    }

    #[test]
    #[ignore = "ranked shape: ~3 GiB resident"]
    fn zero_lane_ranked_ab() {
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        let ntt = AdditiveNttF128::standard(20);
        let pristine = ranked_buffer(0x5EED_0BEE_D00D_1234);

        let mut control = pristine.clone();
        {
            let _g = ZeroOddTailLanes::scope(NUM_NTTS, 0);
            ntt.forward_transform_interleaved_from_layer(&mut control, NUM_NTTS, 3);
        }
        let mut candidate = pristine.clone();
        {
            let _g = ZeroOddTailLanes::scope(NUM_NTTS, 7);
            ntt.forward_transform_interleaved_from_layer(&mut candidate, NUM_NTTS, 3);
        }
        assert!(
            control == candidate,
            "zero-lane skip changed the transform output"
        );
        drop(candidate);
        drop(control);

        let mut best = [f64::MAX; 2];
        for rep in 0..6 {
            for arm in 0..2 {
                let lanes = if arm == 0 { 0 } else { 7 };
                let mut data = pristine.clone();
                let _g = ZeroOddTailLanes::scope(NUM_NTTS, lanes);
                let t = Instant::now();
                ntt.forward_transform_interleaved_from_layer(&mut data, NUM_NTTS, 3);
                let ms = t.elapsed().as_secs_f64() * 1e3;
                std::hint::black_box(&data);
                if ms < best[arm] {
                    best[arm] = ms;
                }
                let name = if arm == 0 { "dense" } else { "skip" };
                println!("rep={rep} arm={name} ms={ms:.2}");
            }
        }
        let delta = (best[0] - best[1]) / best[0] * 100.0;
        println!(
            "MIN dense={:.2} ms  skip={:.2} ms  delta={delta:+.2}%",
            best[0], best[1]
        );
    }
}

#[cfg(test)]
mod low_twiddle_ranked_ab_probe {
    use super::*;

    #[test]
    #[ignore = "ranked shape: ~2 GiB resident"]
    fn low_twiddle_ranked_ab() {
        use std::time::Instant;
        const NUM_NTTS: usize = 64;
        const MSG_POS: usize = 1 << 19;

        let mut st = 0x5EED_0BEE_D00D_1234u64;
        let mut next = move || {
            st ^= st << 13;
            st ^= st >> 7;
            st ^= st << 17;
            st
        };
        let mut msg = vec![F128::ZERO; MSG_POS * NUM_NTTS];
        for pos in 0..MSG_POS {
            let live = if pos & 1 == 1 { 57 } else { NUM_NTTS };
            for lane in 0..live {
                msg[pos * NUM_NTTS + lane] = F128 {
                    lo: next(),
                    hi: next(),
                };
            }
        }
        let mut pristine = Vec::with_capacity(2 * msg.len());
        pristine.extend_from_slice(&msg);
        pristine.extend_from_slice(&msg);
        drop(msg);

        let ntt = AdditiveNttF128::standard(20);
        let mut best = f64::MAX;
        let mut digest = 0u64;
        for rep in 0..6 {
            let mut data = pristine.clone();
            let _g = ZeroOddTailLanes::scope(NUM_NTTS, 7);
            let t = Instant::now();
            ntt.forward_transform_interleaved_from_layer(&mut data, NUM_NTTS, 3);
            let ms = t.elapsed().as_secs_f64() * 1e3;
            if ms < best {
                best = ms;
            }
            if rep == 0 {
                let mut h = 0xcbf29ce484222325u64;
                for v in &data {
                    for limb in [v.lo, v.hi] {
                        h ^= limb;
                        h = h.wrapping_mul(0x100000001b3);
                    }
                }
                digest = h;
            }
            println!("rep={rep} ms={ms:.2}");
        }
        println!(
            "LOWTWIDDLE off={} min_ms={best:.2} digest={digest:016x}",
            std::env::var_os("FLOCK_NO_LOW_TWIDDLE").is_some(),
            best = best,
        );
    }
}

#[cfg(test)]
mod low_twiddle_invariant {
    use super::*;

    #[test]
    fn deepest_standard_twiddle_layers_have_zero_high_limb() {
        for dim in 12..=22usize {
            let ntt = AdditiveNttF128::standard(dim);
            for layer in [dim - 2, dim - 1] {
                for block in 0..(1usize << layer) {
                    let t = ntt.twiddle(layer, block);
                    assert_eq!(t.hi, 0, "dim={dim} layer={layer} block={block} t={t:?}");
                }
            }
        }
    }
}

#[cfg(test)]
mod prepared_four_composition_tests {
    use super::*;

    #[test]
    fn prepared_four_owned_and_block_drivers_match_raw_rows() {
        let shapes = [
            (1usize, 64usize),
            (4, 64),
            (8, 64),
            (128, 64),
            (1, 8),
            (2, 8),
            (4, 8),
            (8, 8),
            (16, 8),
            (64, 8),
            (128, 8),
            (1024, 8),
            (3, 7),
            (2, 13),
            (5, 16),
        ];
        let mut state = 0x173529ad618203efu64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let guard = F128::new(0x85349617a2834619, 0x6396517b35612893);
        let mut cases = 0usize;
        for (sixteenth, num_ntts) in shapes {
            for hint in 0..3u8 {
                for tail in [0usize, num_ntts - 1] {
                    if tail != 0 && sixteenth % 2 != 0 {
                        continue;
                    }
                    for pattern in 0..3 {
                        let offset = 4 + cases % 4;
                        let n = 16 * sixteenth * num_ntts;
                        let mut original = vec![guard; offset + n + 4];
                        for v in &mut original[offset..offset + n] {
                            *v = F128::new(next(), next());
                        }
                        let tw = std::array::from_fn(|_| match pattern {
                            0 => F128::ZERO,
                            1 => F128::ONE,
                            _ => F128::new(next(), next()),
                        });
                        let mut expected = original.clone();
                        butterfly_interleaved_fused_4layer_rows_fallback(
                            &mut expected[offset..offset + n],
                            &tw,
                            sixteenth,
                            num_ntts,
                            tail,
                            hint,
                        );
                        let mut block = original.clone();
                        butterfly_interleaved_fused_4layer_rows(
                            &mut block[offset..offset + n],
                            &tw,
                            sixteenth,
                            num_ntts,
                            tail,
                            hint,
                        );
                        assert_eq!(
                            block, expected,
                            "block s={sixteenth} nn={num_ntts} h={hint} tail={tail} p={pattern}"
                        );
                        let owned = kernels::FourBlock::new(tw);
                        let mut cached = original;
                        for r in 0..sixteenth {
                            unsafe {
                                kernels::butterfly_fused_4layer_cached(
                                    cached.as_mut_ptr().add(offset),
                                    sixteenth,
                                    num_ntts,
                                    row_lanes(r, num_ntts, tail),
                                    r,
                                    &owned,
                                );
                            }
                        }
                        assert_eq!(
                            cached, expected,
                            "owned s={sixteenth} nn={num_ntts} h={hint} tail={tail} p={pattern}"
                        );
                        cases += 1;
                    }
                }
            }
        }
        eprintln!(
            "{cases} complete prepared-four block and owned-table cases matched raw rows with guards"
        );
    }
}
