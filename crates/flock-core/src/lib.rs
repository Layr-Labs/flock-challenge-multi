pub mod bits;
pub mod challenger;
pub mod field;
pub mod gaptime;
pub mod gpu;
pub mod hash;
pub mod lincheck;
pub mod merkle;
pub mod ntt;
pub mod pcs;
pub mod permutation;
pub mod proof;
pub mod r1cs;
pub mod scratch;
pub mod stage_ir;
pub use stage_ir as gf2_kernels;
#[cfg(all(target_arch = "aarch64", target_os = "macos"))]
pub mod gf2_shaders;
pub mod verifier;
pub mod zerocheck;

pub fn init_perf_thread_pool() -> Option<usize> {
    let built = init_global_pool();
    smt_split::init();
    built
}

fn init_global_pool() -> Option<usize> {
    if let Some(n) = topology_pool::try_build_global() {
        return Some(n);
    }
    if std::env::var("RAYON_NUM_THREADS").is_ok() {
        return None;
    }
    let n = perf_core_count();
    match rayon::ThreadPoolBuilder::new()
        .num_threads(n)
        .build_global()
    {
        Ok(()) => Some(n),
        Err(_) => None,
    }
}

pub(crate) mod topology_pool {
    pub(crate) const POOL_MODE: &str = "pin16";

    #[cfg(target_os = "linux")]
    fn sibling_groups() -> Option<Vec<Vec<usize>>> {
        let n = std::thread::available_parallelism().ok()?.get();
        let mut groups: Vec<Vec<usize>> = Vec::new();
        let mut seen = vec![false; n];
        for cpu in 0..n {
            if seen[cpu] {
                continue;
            }
            let path = format!("/sys/devices/system/cpu/cpu{cpu}/topology/thread_siblings_list");
            let list = std::fs::read_to_string(path).ok()?;
            let mut g = Vec::new();
            for part in list.trim().split(',') {
                if let Some((a, b)) = part.split_once('-') {
                    let (a, b): (usize, usize) = (a.parse().ok()?, b.parse().ok()?);
                    g.extend(a..=b);
                } else {
                    g.push(part.parse().ok()?);
                }
            }
            g.retain(|&c| c < n);
            g.sort_unstable();
            g.dedup();
            for &c in &g {
                seen[c] = true;
            }
            groups.push(g);
        }
        Some(groups)
    }

    #[cfg(target_os = "linux")]
    unsafe extern "C" {
        fn sched_setaffinity(pid: i32, cpusetsize: usize, mask: *const u64) -> i32;
    }

    #[cfg(target_os = "linux")]
    fn pin_to(cpu: usize) {
        let mut mask = [0u64; 16];
        if cpu >= 1024 {
            return;
        }
        mask[cpu / 64] |= 1u64 << (cpu % 64);
        unsafe {
            let _ = sched_setaffinity(0, core::mem::size_of_val(&mask), mask.as_ptr());
        }
    }

    pub(crate) fn try_build_global() -> Option<usize> {
        #[cfg(not(target_os = "linux"))]
        {
            return None;
        }
        #[cfg(target_os = "linux")]
        {
            if std::env::var_os("FLOCK_NO_TOPOLOGY_POOL").is_some() {
                return None;
            }
            let want: usize = std::env::var("RAYON_NUM_THREADS").ok()?.parse().ok()?;
            let logical = std::thread::available_parallelism().ok()?.get();
            if want != logical {
                return None;
            }
            let groups = sibling_groups()?;
            let cores = groups.len();
            if cores == 0 || logical != 2 * cores || groups.iter().any(|g| g.len() != 2) {
                return None;
            }
            let mut order: Vec<usize> = Vec::with_capacity(logical);
            for s in 0..2 {
                for g in &groups {
                    order.push(g[s]);
                }
            }
            let n = if POOL_MODE == "phys8" { cores } else { logical };
            let order = std::sync::Arc::new(order);
            let o2 = order.clone();
            match rayon::ThreadPoolBuilder::new()
                .num_threads(n)
                .stack_size(super::RANKED_WORKER_STACK)
                .start_handler(move |i| {
                    crate::hot_pool::record_top();
                    if let Some(&cpu) = o2.get(i) {
                        pin_to(cpu);
                    }
                })
                .build_global()
            {
                Ok(()) => {
                    super::RANKED_POOL_BUILT.store(true, std::sync::atomic::Ordering::Release);
                    Some(n)
                }
                Err(_) => None,
            }
        }
    }
}

pub const RANKED_WORKER_STACK: usize = 32 << 20;

static RANKED_POOL_BUILT: std::sync::atomic::AtomicBool = std::sync::atomic::AtomicBool::new(false);

std::thread_local! {
    static POOL_OWNER: core::cell::Cell<bool> = const { core::cell::Cell::new(false) };
}

pub fn set_pool_owner(on: bool) {
    POOL_OWNER.with(|c| c.set(on));
}

#[inline]
pub fn is_pool_owner() -> bool {
    POOL_OWNER.with(|c| c.get())
}

#[inline]
pub fn owns_whole_pool() -> bool {
    rayon::current_thread_index().is_none() || POOL_OWNER.with(|c| c.get())
}

pub fn ranked_pool_built() -> bool {
    RANKED_POOL_BUILT.load(std::sync::atomic::Ordering::Acquire)
}

pub(crate) mod smt_split {
    use rayon::ThreadPool;
    use std::sync::OnceLock;

    pub(crate) const ZC_R1_SMT_SPLIT: bool = true;

    const ZC_R1_AB_REBALANCE: bool = false;

    static POOLS: OnceLock<Option<(ThreadPool, ThreadPool)>> = OnceLock::new();

    #[cfg(any(test, all(target_os = "linux", target_arch = "x86_64")))]
    fn arm_cpus(groups: &[Vec<usize>], rebalance: bool) -> (Vec<usize>, Vec<usize>) {
        let mut ab: Vec<usize> = groups.iter().map(|g| g[0]).collect();
        let mut c: Vec<usize> = groups.iter().map(|g| g[1]).collect();
        if rebalance && groups.len() == 8 {
            ab.push(c.pop().expect("eight sibling groups"));
        }
        (ab, c)
    }

    #[cfg(test)]
    mod tests {
        #[test]
        fn arm_partition_rebalances_eight_cores_without_losing_or_sharing_cpus() {
            for cores in [2usize, 4, 8, 16] {
                let groups: Vec<Vec<usize>> = (0..cores).map(|i| vec![i, i + cores]).collect();
                for rebalance in [false, true] {
                    let (ab, c) = super::arm_cpus(&groups, rebalance);
                    let moved = usize::from(rebalance && cores == 8);
                    assert_eq!((ab.len(), c.len()), (cores + moved, cores - moved));
                    let mut all: Vec<usize> = ab.iter().chain(&c).copied().collect();
                    all.sort_unstable();
                    assert_eq!(all, (0..2 * cores).collect::<Vec<_>>());
                    assert_eq!(&ab[..cores], &(0..cores).collect::<Vec<_>>());
                    assert_eq!(c, (cores..2 * cores - moved).collect::<Vec<_>>());
                    if moved != 0 {
                        assert_eq!(ab.last(), Some(&(2 * cores - 1)));
                    }
                }
            }
        }
    }

    #[inline]
    pub(crate) fn zc_r1_pools() -> Option<&'static (ThreadPool, ThreadPool)> {
        POOLS.get().and_then(Option::as_ref)
    }

    pub(crate) fn init() {
        #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
        {
            if !ZC_R1_SMT_SPLIT {
                return;
            }
            let _ = POOLS.set(imp::build());
        }
    }

    #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
    mod imp {
        use rayon::ThreadPool;

        unsafe extern "C" {
            fn sched_setaffinity(pid: i32, cpusetsize: usize, mask: *const u64) -> i32;
            fn sched_getaffinity(pid: i32, cpusetsize: usize, mask: *mut u64) -> i32;
        }

        type Mask = [u64; 16];

        fn affinity() -> Mask {
            let mut m: Mask = [0; 16];
            unsafe {
                sched_getaffinity(0, core::mem::size_of::<Mask>(), m.as_mut_ptr());
            }
            m
        }

        fn pin_to(cpu: usize) {
            if cpu >= 1024 {
                return;
            }
            let mut mask: Mask = [0; 16];
            mask[cpu / 64] |= 1u64 << (cpu % 64);
            unsafe {
                let _ = sched_setaffinity(0, core::mem::size_of_val(&mask), mask.as_ptr());
            }
        }

        fn present_cpus() -> usize {
            let Ok(s) = std::fs::read_to_string("/sys/devices/system/cpu/present") else {
                return 0;
            };
            let mut hi = 0usize;
            for part in s.trim().split(',') {
                let last = part.split('-').next_back().unwrap_or("");
                if let Ok(v) = last.parse::<usize>() {
                    hi = hi.max(v);
                }
            }
            hi + 1
        }

        fn sibling_groups() -> Vec<Vec<usize>> {
            let n = present_cpus();
            if n == 0 {
                return Vec::new();
            }
            let mut groups: Vec<Vec<usize>> = Vec::new();
            let mut seen = vec![false; n];
            for cpu in 0..n {
                if seen[cpu] {
                    continue;
                }
                let path =
                    format!("/sys/devices/system/cpu/cpu{cpu}/topology/thread_siblings_list");
                let Ok(list) = std::fs::read_to_string(path) else {
                    return Vec::new();
                };
                let mut g = Vec::new();
                for part in list.trim().split(',') {
                    if let Some((a, b)) = part.split_once('-') {
                        let (Ok(a), Ok(b)) = (a.parse::<usize>(), b.parse::<usize>()) else {
                            return Vec::new();
                        };
                        g.extend(a..=b);
                    } else if let Ok(v) = part.parse::<usize>() {
                        g.push(v);
                    } else {
                        return Vec::new();
                    }
                }
                g.retain(|&c| c < n);
                g.sort_unstable();
                g.dedup();
                for &c in &g {
                    seen[c] = true;
                }
                groups.push(g);
            }
            groups
        }

        fn half(sibling: usize, cpus: Vec<usize>, debug: bool) -> ThreadPool {
            if debug {
                eprintln!("[smt_split] pool sibling{sibling} cpus {cpus:?}");
            }
            let n = cpus.len();
            rayon::ThreadPoolBuilder::new()
                .num_threads(n)
                .thread_name(move |i| format!("zcr1s{sibling}-{i}"))
                .start_handler(move |i| {
                    if let Some(&c) = cpus.get(i) {
                        pin_to(c);
                    }
                })
                .build()
                .expect("zc_r1 half pool")
        }

        pub(super) fn build() -> Option<(ThreadPool, ThreadPool)> {
            let debug = std::env::var_os("FLOCK_SMT_SPLIT_DEBUG").is_some();
            if std::env::var_os("FLOCK_NO_ZC_R1_SMT_SPLIT").is_some() {
                if debug {
                    eprintln!("[smt_split] disabled by FLOCK_NO_ZC_R1_SMT_SPLIT");
                }
                return None;
            }
            let groups = sibling_groups();
            let cores = groups.len();
            if cores < 2
                || groups.iter().any(|g| g.len() != 2)
                || present_cpus() != 2 * cores
                || rayon::current_num_threads() != 2 * cores
            {
                if debug {
                    eprintln!(
                        "[smt_split] declined: cores={cores} present={} rayon={}",
                        present_cpus(),
                        rayon::current_num_threads()
                    );
                }
                return None;
            }
            let m = affinity();
            for g in &groups {
                for &c in g {
                    if c >= 1024 || m[c / 64] & (1u64 << (c % 64)) == 0 {
                        if debug {
                            eprintln!("[smt_split] declined: cpu {c} outside affinity mask");
                        }
                        return None;
                    }
                }
            }
            let rebalance = (super::ZC_R1_AB_REBALANCE
                || std::env::var_os("FLOCK_ZC_R1_AB_REBALANCE").is_some())
                && std::env::var_os("FLOCK_NO_ZC_R1_AB_REBALANCE").is_none();
            let (s0, s1) = super::arm_cpus(&groups, rebalance);
            let p0 = half(0, s0, debug);
            let p1 = half(1, s1, debug);
            if std::env::var_os("FLOCK_ZC_R1_SMT_SPLIT_IDLE").is_some() {
                if debug {
                    eprintln!("[smt_split] built but IDLE (FLOCK_ZC_R1_SMT_SPLIT_IDLE)");
                }
                core::mem::forget(p0);
                core::mem::forget(p1);
                return None;
            }
            Some((p0, p1))
        }
    }
}

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
fn advise_hugepages(ptr: *mut u8, bytes: usize) {
    const HUGE: usize = 1 << 21;
    if bytes < HUGE {
        return;
    }
    static DISABLED: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_HUGEPAGES").is_some());
    if *DISABLED {
        return;
    }
    const PAGE: usize = 4096;
    let start = (ptr as usize).next_multiple_of(PAGE);
    let end = ptr as usize + bytes;
    if end <= start {
        return;
    }
    const SYS_MADVISE: usize = 28;
    const MADV_HUGEPAGE: usize = 14;
    unsafe {
        let ret: isize;
        core::arch::asm!(
            "syscall",
            inlateout("rax") SYS_MADVISE as isize => ret,
            in("rdi") start,
            in("rsi") end - start,
            in("rdx") MADV_HUGEPAGE,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack)
        );
        let _ = ret;
    }
}

#[cfg(not(all(target_os = "linux", target_arch = "x86_64")))]
fn advise_hugepages(_ptr: *mut u8, _bytes: usize) {}

pub mod hot_pool {
    use std::sync::Arc;
    use std::sync::atomic::{AtomicBool, Ordering};

    fn enabled() -> bool {
        static OFF: std::sync::LazyLock<bool> =
            std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_HOT_POOL").is_some());
        !*OFF
    }

    std::thread_local! {
        static TOP_SP: core::cell::Cell<usize> = const { core::cell::Cell::new(0) };
        static CALLBACK_ACTIVE: core::cell::Cell<bool> = const { core::cell::Cell::new(false) };
    }

    const TOP_LEVEL_DEPTH: usize = 1024;

    #[inline(never)]
    pub(crate) fn record_top() {
        let marker = 0u8;
        TOP_SP.with(|t| t.set(core::hint::black_box(&marker) as *const u8 as usize));
    }

    #[inline(never)]
    fn at_top_level() -> bool {
        let marker = 0u8;
        let here = core::hint::black_box(&marker) as *const u8 as usize;
        let top = TOP_SP.with(|t| t.get());
        top != 0 && here <= top && top - here < TOP_LEVEL_DEPTH
    }

    #[must_use = "keep the guard alive for the whole warming callback"]
    pub struct CallbackGuard(core::marker::PhantomData<*mut ()>);

    impl CallbackGuard {
        pub fn enter() -> Option<Self> {
            if CALLBACK_ACTIVE.with(|active| active.get()) || !at_top_level() {
                return None;
            }
            CALLBACK_ACTIVE.with(|active| active.set(true));
            Some(Self(core::marker::PhantomData))
        }
    }

    impl Drop for CallbackGuard {
        fn drop(&mut self) {
            CALLBACK_ACTIVE.with(|active| active.set(false));
        }
    }

    fn spins_per_job() -> usize {
        static V: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
            std::env::var("FLOCK_HOT_POOL_SPINS")
                .ok()
                .and_then(|v| v.parse().ok())
                .unwrap_or(2048)
        });
        *V
    }

    fn spinner(run: Arc<AtomicBool>, owner: usize, backoff: usize) {
        if rayon::current_thread_index() == Some(owner) {
            return;
        }
        let Some(_callback) = CallbackGuard::enter() else {
            return;
        };
        for _ in 0..spins_per_job() {
            if !run.load(Ordering::Acquire) {
                return;
            }
            if !matches!(rayon::yield_now(), Some(rayon::Yield::Executed)) {
                for _ in 0..backoff {
                    core::hint::spin_loop();
                }
            }
        }
        rayon::spawn(move || spinner(run, owner, backoff));
    }

    pub struct HotPool(Arc<AtomicBool>);

    impl HotPool {
        pub fn start() -> Option<Self> {
            if !enabled() {
                return None;
            }
            if TOP_SP.with(|top| top.get()) == 0 {
                return None;
            }
            let owner = rayon::current_thread_index()?;
            let n = rayon::current_num_threads();
            let sibling = (owner + n / 2) % n.max(1);
            let run = Arc::new(AtomicBool::new(true));
            let flag = run.clone();
            rayon::spawn_broadcast(move |ctx| {
                let me = ctx.index();
                if me != owner {
                    spinner(flag.clone(), owner, if me == sibling { 64 } else { 8 });
                }
            });
            Some(Self(run))
        }
    }

    impl Drop for HotPool {
        fn drop(&mut self) {
            self.0.store(false, Ordering::Release);
        }
    }

    #[cfg(test)]
    mod tests {
        use super::*;

        #[test]
        fn callback_admission_requires_recorded_stack() {
            assert!(CallbackGuard::enter().is_none());
        }

        #[test]
        fn callback_admission_excludes_descendants_and_recovers_after_unwind() {
            record_top();
            {
                let _callback = CallbackGuard::enter().expect("recorded stack");
                assert!(CallbackGuard::enter().is_none(), "nested callback admitted");
            }
            let result = std::panic::catch_unwind(|| {
                let _callback = CallbackGuard::enter().expect("previous callback returned");
                panic!("exercise callback unwinding");
            });
            assert!(result.is_err());
            let _callback = CallbackGuard::enter().expect("unwinding must release admission");
        }
    }
}

pub fn in_pool<R: Send>(op: impl FnOnce() -> R + Send) -> R {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_IN_POOL").is_none());
    if !*ON || rayon::current_thread_index().is_some() {
        return op();
    }
    rayon::join(op, || ()).0
}

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
pub(crate) fn collapse_hugepages(ptr: *mut u8, bytes: usize) -> bool {
    const HUGE: usize = 1 << 21;
    if bytes < HUGE {
        return true;
    }
    static DISABLED: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_MADV_COLLAPSE").is_some());
    if *DISABLED {
        return false;
    }
    const PAGE: usize = 4096;
    let start = (ptr as usize).next_multiple_of(PAGE);
    let end = ptr as usize + bytes;
    if end <= start {
        return true;
    }
    const SYS_MADVISE: usize = 28;
    const MADV_COLLAPSE: usize = 25;
    unsafe {
        let ret: isize;
        core::arch::asm!(
            "syscall",
            inlateout("rax") SYS_MADVISE as isize => ret,
            in("rdi") start,
            in("rsi") end - start,
            in("rdx") MADV_COLLAPSE,
            lateout("rcx") _,
            lateout("r11") _,
            options(nostack),
        );
        ret == 0
    }
}

#[cfg(not(all(target_os = "linux", target_arch = "x86_64")))]
pub(crate) fn collapse_hugepages(_ptr: *mut u8, _bytes: usize) -> bool {
    true
}

#[doc(hidden)]
pub const UNINIT_VEC_LARGE_MIN_BYTES: usize = 2 << 20;
#[doc(hidden)]
pub const UNINIT_VEC_TAIL_PAGES: usize = 96;

#[allow(clippy::uninit_vec)]
pub(crate) fn alloc_uninit_vec<T: Copy>(n: usize) -> Vec<T> {
    const EY_TAIL_PAGES: usize = UNINIT_VEC_TAIL_PAGES;
    let bytes = n * core::mem::size_of::<T>();
    let tail = if bytes >= UNINIT_VEC_LARGE_MIN_BYTES {
        core::hint::black_box(EY_TAIL_PAGES) * 4096 / core::mem::size_of::<T>().max(1)
    } else {
        0
    };
    LAST_ALLOC_RECYCLED.with(|c| c.set(false));
    let mut v: Vec<T> = Vec::with_capacity(n + tail);
    unsafe {
        v.set_len(n);
    }
    if !LAST_ALLOC_RECYCLED.with(|c| c.get()) || always_advise() {
        advise_hugepages(v.as_mut_ptr().cast::<u8>(), n * core::mem::size_of::<T>());
    }
    crate::scratch::void_pending_tag(v.as_ptr().cast::<crate::field::F128>());
    v
}

thread_local! {
    pub static LAST_ALLOC_RECYCLED: core::cell::Cell<bool> = const { core::cell::Cell::new(false) };
}

fn always_advise() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_ALWAYS_ADVISE").is_some());
    *ON
}

pub(crate) fn alloc_uninit_f128_vec(n: usize) -> Vec<crate::field::F128> {
    alloc_uninit_vec::<crate::field::F128>(n)
}

pub(crate) fn serial_par_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_SERIAL_PAR").is_none());
    *ON
}

#[cfg(target_arch = "aarch64")]
pub(crate) fn perf_core_count_cached() -> usize {
    use std::sync::OnceLock;
    static N: OnceLock<usize> = OnceLock::new();
    *N.get_or_init(perf_core_count)
}

fn perf_core_count() -> usize {
    #[cfg(target_os = "macos")]
    {
        if let Ok(out) = std::process::Command::new("sysctl")
            .args(["-n", "hw.perflevel0.physicalcpu"])
            .output()
            && let Ok(s) = std::str::from_utf8(&out.stdout)
            && let Ok(n) = s.trim().parse::<usize>()
            && n > 0
        {
            return n;
        }
    }
    #[cfg(target_os = "linux")]
    {
        if let Some(n) = linux_physical_cores()
            && n > 0
        {
            let available = std::thread::available_parallelism()
                .map(|n| n.get())
                .unwrap_or(1);
            return n.min(available);
        }
    }
    std::thread::available_parallelism()
        .map(|n| n.get())
        .unwrap_or(1)
}

#[cfg(target_os = "linux")]
fn linux_physical_cores() -> Option<usize> {
    use std::collections::HashSet;
    let mut cores: HashSet<(String, String)> = HashSet::new();
    for entry in std::fs::read_dir("/sys/devices/system/cpu").ok()? {
        let Ok(entry) = entry else {
            continue;
        };
        let path = entry.path();
        let name = path.file_name().and_then(|s| s.to_str()).unwrap_or("");
        let Some(rest) = name.strip_prefix("cpu") else {
            continue;
        };
        if rest.is_empty() || !rest.bytes().all(|b| b.is_ascii_digit()) {
            continue; // skip "cpufreq", "cpuidle", etc.
        }
        let topo = path.join("topology");
        let core_id = std::fs::read_to_string(topo.join("core_id")).ok();
        let pkg = std::fs::read_to_string(topo.join("physical_package_id")).ok();
        if let (Some(c), Some(p)) = (core_id, pkg) {
            cores.insert((p.trim().to_owned(), c.trim().to_owned()));
        }
    }
    (!cores.is_empty()).then_some(cores.len())
}
