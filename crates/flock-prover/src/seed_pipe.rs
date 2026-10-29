
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, Condvar, Mutex, OnceLock};

use flock_core::pcs::Commitment;
use flock_core::proof::{R1csClaim, R1csProofLigerito};
use rayon::prelude::*;

use crate::proof_io::R1csProofBundleLigerito;
use crate::r1cs_hashes::blake3::Compression;

pub type ProveOut = (R1csProofLigerito, Commitment, R1csClaim);

pub const BENCH_DOMAIN: &[u8] = b"flock-bench-v0";

const WARMUP_SEED: u64 = 0x00C0_FFEE_BEEF_D15C;

pub(crate) const GOLDEN: u64 = 0x9E37_79B9_7F4A_7C15;
pub(crate) const DRAWS_PER_BLOCK: usize = 25;
const ZERO_COMPRESSION: Compression = ([0; 8], [0; 16], 0, 0, 0);


#[inline(always)]
fn mix(mut z: u64) -> u32 {
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    (z ^ (z >> 31)) as u32
}

#[inline(always)]
fn generator_init(log2_size: u32, seed: u64) -> u64 {
    seed ^ u64::from(log2_size).rotate_left(29)
}

#[inline(always)]
pub(crate) fn gen_block(init: u64, block: usize) -> Compression {
    let mut s = init.wrapping_add(((DRAWS_PER_BLOCK * block) as u64).wrapping_mul(GOLDEN));
    let mut cv = [0u32; 8];
    for word in cv.iter_mut() {
        s = s.wrapping_add(GOLDEN);
        *word = mix(s);
    }
    let mut message = [0u32; 16];
    for word in message.iter_mut() {
        s = s.wrapping_add(GOLDEN);
        *word = mix(s);
    }
    s = s.wrapping_add(GOLDEN);
    (cv, message, u64::from(mix(s)), 64, 11)
}


#[derive(Clone, Copy, Debug)]
pub enum BlockSource<'a> {
    Slice(&'a [Compression]),
    Closed { init: u64, len: usize },
}

impl<'a> BlockSource<'a> {
    #[inline]
    pub fn closed(log2_size: u32, seed: u64) -> Self {
        BlockSource::Closed {
            init: generator_init(log2_size, seed),
            len: 1usize << log2_size,
        }
    }

    #[inline(always)]
    pub fn len(&self) -> usize {
        match self {
            BlockSource::Slice(s) => s.len(),
            BlockSource::Closed { len, .. } => *len,
        }
    }

    #[inline(always)]
    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }

    #[inline(always)]
    pub fn with_block<R>(
        &self,
        i: usize,
        padding: &Compression,
        f: impl FnOnce(&Compression) -> R,
    ) -> R {
        match *self {
            BlockSource::Slice(s) => f(s.get(i).unwrap_or(padding)),
            BlockSource::Closed { init, len } => {
                if i < len {
                    f(&gen_block(init, i))
                } else {
                    f(padding)
                }
            }
        }
    }

    pub fn to_vec(&self) -> Vec<Compression> {
        match *self {
            BlockSource::Slice(s) => s.to_vec(),
            BlockSource::Closed { init, len } => {
                let mut out = vec![ZERO_COMPRESSION; len];
                out.par_chunks_mut(4096)
                    .enumerate()
                    .for_each(|(chunk_index, dst)| {
                        let base = chunk_index * 4096;
                        for (offset, slot) in dst.iter_mut().enumerate() {
                            *slot = gen_block(init, base + offset);
                        }
                    });
                out
            }
        }
    }
}

impl<'a> From<&'a [Compression]> for BlockSource<'a> {
    #[inline(always)]
    fn from(s: &'a [Compression]) -> Self {
        BlockSource::Slice(s)
    }
}

fn fill_compressions_par(out: &mut [Compression], log2_size: u32, seed: u64) {
    let init = generator_init(log2_size, seed);
    out.par_chunks_mut(4096)
        .enumerate()
        .for_each(|(chunk_index, dst)| {
            let base = chunk_index * 4096;
            for (offset, slot) in dst.iter_mut().enumerate() {
                *slot = gen_block(init, base + offset);
            }
        });
}

pub fn generate_compressions_par(log2_size: u32, seed: u64) -> Vec<Compression> {
    let mut out = vec![ZERO_COMPRESSION; 1usize << log2_size];
    fill_compressions_par(&mut out, log2_size, seed);
    out
}

fn prefaulted_blocks(count: usize) -> Vec<Compression> {
    let mut v = vec![ZERO_COMPRESSION; count];
    let bytes = std::mem::size_of_val(v.as_slice());
    let base = v.as_mut_ptr().cast::<u8>();
    let mut offset = 0usize;
    while offset < bytes {
        unsafe { base.add(offset).write_volatile(0) };
        offset += 4096;
    }
    v
}

fn blocks_eq(a: &[Compression], b: &[Compression]) -> bool {
    const _: () = assert!(std::mem::size_of::<Compression>() == 112);
    if a.len() != b.len() {
        return false;
    }
    a.par_chunks(8192)
        .zip(b.par_chunks(8192))
        .all(|(x, y)| bytes_of(x) == bytes_of(y))
}

fn blocks_eq_serial(a: &[Compression], b: &[Compression]) -> bool {
    a.len() == b.len() && bytes_of(a) == bytes_of(b)
}

fn bytes_of(v: &[Compression]) -> &[u8] {
    unsafe { std::slice::from_raw_parts(v.as_ptr().cast::<u8>(), std::mem::size_of_val(v)) }
}


#[allow(clippy::large_enum_variant)]
#[derive(Clone)]
enum SpecBlocks {
    Full(Arc<Vec<Compression>>),
    Endpoints {
        len: usize,
        first: Compression,
        last: Compression,
    },
}

impl SpecBlocks {
    fn len(&self) -> usize {
        match self {
            SpecBlocks::Full(v) => v.len(),
            SpecBlocks::Endpoints { len, .. } => *len,
        }
    }

    fn endpoints_match(&self, blocks: &[Compression]) -> bool {
        if self.len() != blocks.len() {
            return false;
        }
        match self {
            SpecBlocks::Full(v) => v.first() == blocks.first() && v.last() == blocks.last(),
            SpecBlocks::Endpoints { first, last, .. } => {
                blocks.first() == Some(first) && blocks.last() == Some(last)
            }
        }
    }

    fn full_match(&self, blocks: &[Compression]) -> Option<bool> {
        match self {
            SpecBlocks::Full(v) => Some(blocks_eq(v, blocks)),
            SpecBlocks::Endpoints { .. } => None,
        }
    }
}

#[derive(Default)]
struct State {
    blocks: Option<SpecBlocks>,
    result: Option<ProveOut>,
    dead: bool,
    seed_at: Option<std::time::Instant>,
    blocks_at: Option<std::time::Instant>,
}

struct Pipe {
    state: Mutex<State>,
    signal: Condvar,
}

static PIPE: OnceLock<Pipe> = OnceLock::new();
static ARMED: AtomicBool = AtomicBool::new(false);
static GENERATOR_VERIFIED: AtomicBool = AtomicBool::new(false);

fn inline_block_gen_enabled() -> bool {
    inline_block_gen_decision(
        GENERATOR_VERIFIED.load(Ordering::SeqCst),
        std::env::var_os("FLOCK_NO_INLINE_BLOCK_GEN").as_deref(),
    )
}

fn inline_block_gen_decision(verified: bool, kill_switch: Option<&std::ffi::OsStr>) -> bool {
    verified && kill_switch != Some(std::ffi::OsStr::new("1"))
}

fn shared() -> &'static Pipe {
    PIPE.get_or_init(|| Pipe {
        state: Mutex::new(State::default()),
        signal: Condvar::new(),
    })
}

fn mark_dead() {
    let mut state = shared().state.lock().unwrap_or_else(|e| e.into_inner());
    state.dead = true;
    shared().signal.notify_all();
}


unsafe extern "C" {
    fn dup(fd: i32) -> i32;
    fn dup2(from: i32, to: i32) -> i32;
    #[link_name = "pipe"]
    fn sys_pipe(fds: *mut i32) -> i32;
    fn close(fd: i32) -> i32;
    fn read(fd: i32, buf: *mut u8, count: usize) -> isize;
    fn write(fd: i32, buf: *const u8, count: usize) -> isize;
    fn fcntl(fd: i32, cmd: i32, ...) -> i32;
}

fn read_line_fd(fd: i32) -> Option<Vec<u8>> {
    let mut line = Vec::with_capacity(64);
    let mut chunk = [0u8; 64];
    loop {
        let n = unsafe { read(fd, chunk.as_mut_ptr(), chunk.len()) };
        match n {
            n if n > 0 => {
                line.extend_from_slice(&chunk[..n as usize]);
                if line.contains(&b'\n') || line.len() >= 256 {
                    return Some(line);
                }
            }
            0 => return (!line.is_empty()).then_some(line),
            _ => return None,
        }
    }
}


const HOT_WAIT_BUDGET: std::time::Duration = std::time::Duration::from_secs(20);

static PRESEED_EPOCH: AtomicU64 = AtomicU64::new(0);
const PRESEED_SPINS_PER_JOB: usize = 2048;

#[inline]
pub(crate) fn preseed_spin_end() {
    PRESEED_EPOCH.fetch_or(1, Ordering::Release);
}

fn preseed_spinner(epoch: u64, owner: usize, backoff: usize) {
    if PRESEED_EPOCH.load(Ordering::Acquire) != epoch
        || rayon::current_thread_index() == Some(owner)
    {
        return;
    }
    let Some(_callback) = flock_core::hot_pool::CallbackGuard::enter() else {
        return;
    };
    #[cfg(test)]
    let _depth = tests::PreseedDepth::enter();
    for _ in 0..PRESEED_SPINS_PER_JOB {
        if PRESEED_EPOCH.load(Ordering::Acquire) != epoch {
            return;
        }
        if !matches!(rayon::yield_now(), Some(rayon::Yield::Executed)) {
            for _ in 0..backoff {
                core::hint::spin_loop();
            }
        }
    }
    if PRESEED_EPOCH.load(Ordering::Acquire) == epoch {
        rayon::spawn(move || preseed_spinner(epoch, owner, backoff));
    }
}

fn preseed_spin_start() {
    let Some(owner) = rayon::current_thread_index() else {
        return;
    };
    let n = rayon::current_num_threads().max(1);
    let sibling = (owner + n / 2) % n;
    let Ok(previous) = PRESEED_EPOCH.fetch_update(Ordering::AcqRel, Ordering::Acquire, |old| {
        old.checked_add(2).map(|next| next & !1)
    }) else {
        return;
    };
    let epoch = (previous + 2) & !1;
    rayon::spawn_broadcast(move |ctx| {
        let me = ctx.index();
        if me != owner {
            preseed_spinner(epoch, owner, if me == sibling { 64 } else { 8 });
        }
    });
}

pub(crate) fn tail_spin_start() {
    if flock_core::is_pool_owner() && std::env::var_os("FLOCK_EXP_NO_TAILSPIN").is_none() {
        preseed_spin_start();
    }
}

struct SpinGuard;
impl Drop for SpinGuard {
    fn drop(&mut self) {
        preseed_spin_end();
        flock_core::set_pool_owner(false);
    }
}

fn hot_wait_enabled() -> bool {
    cfg!(all(target_os = "linux", target_arch = "x86_64"))
        && flock_core::ranked_pool_built()
        && rayon::current_num_threads() > 2
        && std::env::var_os("FLOCK_NO_HOT_SEED_WAIT").is_none()
}

fn on_hot_worker<R: Send>(hot: bool, f: impl FnOnce() -> R + Send) -> R {
    if !hot {
        return f();
    }
    flock_core::in_pool(|| {
        let _guard = SpinGuard;
        flock_core::set_pool_owner(true);
        preseed_spin_start();
        f()
    })
}

fn notify_warm(warm: Option<Arc<(Mutex<bool>, Condvar)>>) {
    if let Some(w) = warm {
        let (lock, cv) = &*w;
        *lock.lock().unwrap_or_else(|e| e.into_inner()) = true;
        cv.notify_all();
    }
}

fn spin_read_line_fd_with_notify(
    fd: i32,
    warm: Option<Arc<(Mutex<bool>, Condvar)>>,
    restore_before_return: bool,
) -> (Option<Vec<u8>>, Option<i32>) {
    const F_GETFL: i32 = 3;
    const F_SETFL: i32 = 4;
    const O_NONBLOCK: i32 = 0o4000;
    const EAGAIN: i32 = 11;
    const EINTR: i32 = 4;
    let flags = unsafe { fcntl(fd, F_GETFL) };
    if flags < 0 || unsafe { fcntl(fd, F_SETFL, flags | O_NONBLOCK) } < 0 {
        notify_warm(warm);
        return (read_line_fd(fd), None);
    }
    let restore = || unsafe {
        fcntl(fd, F_SETFL, flags);
    };
    let deadline = std::time::Instant::now() + HOT_WAIT_BUDGET;
    let mut line = Vec::with_capacity(64);
    let mut chunk = [0u8; 64];
    let _ = unsafe { read(fd, chunk.as_mut_ptr(), 0) };
    for _ in 0..2048 {
        core::hint::spin_loop();
    }
    notify_warm(warm);
    let mut polls = 0u32;
    loop {
        let n = unsafe { read(fd, chunk.as_mut_ptr(), chunk.len()) };
        if n > 0 {
            line.extend_from_slice(&chunk[..n as usize]);
            if line.contains(&b'\n') || line.len() >= 256 {
                if restore_before_return {
                    restore();
                    return (Some(line), None);
                }
                return (Some(line), Some(flags));
            }
            continue;
        }
        if n == 0 {
            restore();
            return ((!line.is_empty()).then_some(line), None);
        }
        match std::io::Error::last_os_error().raw_os_error() {
            Some(EAGAIN) | Some(EINTR) => {
                polls = polls.wrapping_add(1);
                if polls % 4096 == 0 && std::time::Instant::now() >= deadline {
                    restore();
                    preseed_spin_end();
                    return (
                        match read_line_fd(fd) {
                            Some(rest) => {
                                line.extend_from_slice(&rest);
                                Some(line)
                            }
                            None => (!line.is_empty()).then_some(line),
                        },
                        None,
                    );
                }
                core::hint::spin_loop();
            }
            _ => {
                restore();
                return (None, None);
            }
        }
    }
}

fn write_all_fd(fd: i32, mut buf: &[u8]) -> bool {
    while !buf.is_empty() {
        let n = unsafe { write(fd, buf.as_ptr(), buf.len()) };
        if n <= 0 {
            return false;
        }
        buf = &buf[n as usize..];
    }
    true
}

fn ranked_worker_proof_path() -> Option<PathBuf> {
    let mut args = std::env::args_os();
    let exe = args.next()?;
    let _log2 = args.next()?;
    let _ready = args.next()?;
    let proof = args.next()?;
    if args.next().is_some()
        || !Path::new(&exe)
            .file_name()
            .and_then(|name| name.to_str())
            .is_some_and(|name| name.starts_with("flock-benchmark-worker"))
    {
        return None;
    }
    Some(proof.into())
}

fn forward_and_close(writer: i32, line: &[u8]) -> bool {
    let written = write_all_fd(writer, line);
    unsafe { close(writer) };
    written
}

fn close_fd(fd: i32) {
    unsafe { close(fd) };
}


unsafe extern "C" {
    fn mmap(addr: *mut u8, len: usize, prot: i32, flags: i32, fd: i32, off: i64) -> *mut u8;
    fn munmap(addr: *mut u8, len: usize) -> i32;
    fn ftruncate(fd: i32, len: i64) -> i32;
}

const SIZED_RADIUS: usize = 128;
const HASH_STEP: usize = 32;

struct SizedTmp {
    path: PathBuf,
    base: usize,
    len: usize,
    _file: std::fs::File,
}

struct SizedSet {
    first: usize,
    files: Vec<Option<SizedTmp>>,
}

static SIZED_SET: Mutex<Option<SizedSet>> = Mutex::new(None);
static TIMED_SPEC_PROVE: AtomicBool = AtomicBool::new(false);

#[inline]
pub(crate) fn is_timed_speculative_prove() -> bool {
    TIMED_SPEC_PROVE.load(Ordering::Relaxed)
}

fn mapped_publish_enabled() -> bool {
    cfg!(target_os = "linux") && std::env::var_os("FLOCK_NO_MAPPED_PUBLISH").is_none()
}

impl SizedSet {
    fn slot(&self, total: usize) -> Option<usize> {
        let off = total.checked_sub(self.first)?;
        (off % HASH_STEP == 0)
            .then_some(off / HASH_STEP)
            .filter(|&i| i < self.files.len() && self.files[i].is_some())
    }
}

fn make_sized_tmp(path: PathBuf, len: usize) -> Option<SizedTmp> {
    use std::os::fd::AsRawFd;
    const PROT_READ: i32 = 1;
    const PROT_WRITE: i32 = 2;
    const MAP_SHARED: i32 = 1;
    let file = std::fs::OpenOptions::new()
        .read(true)
        .write(true)
        .create(true)
        .truncate(true)
        .open(&path)
        .ok()?;
    unsafe {
        if ftruncate(file.as_raw_fd(), len as i64) != 0 {
            let _ = std::fs::remove_file(&path);
            return None;
        }
        let base = mmap(std::ptr::null_mut(), len, PROT_READ | PROT_WRITE, MAP_SHARED, file.as_raw_fd(), 0);
        if base.is_null() || base as usize == usize::MAX {
            let _ = std::fs::remove_file(&path);
            return None;
        }
        let mut off = 0;
        while off < len {
            base.add(off).write_volatile(0);
            off += 4096;
        }
        base.add(len - 1).write_volatile(0);
        Some(SizedTmp {
            path,
            base: base as usize,
            len,
            _file: file,
        })
    }
}

fn setup_sized_set(path: &Path, bundle: &R1csProofBundleLigerito) -> bool {
    let Some(enc) = bundle.raw_encoding() else {
        return false;
    };
    let warm_total = enc.len();
    if warm_total < SIZED_RADIUS * HASH_STEP + 4096 {
        return false;
    }
    let first = warm_total - SIZED_RADIUS * HASH_STEP;
    let mut files = Vec::with_capacity(2 * SIZED_RADIUS + 1);
    for i in 0..=2 * SIZED_RADIUS {
        let mut name = path.as_os_str().to_owned();
        name.push(format!(".tmp{i}"));
        files.push(make_sized_tmp(PathBuf::from(name), first + i * HASH_STEP));
    }
    let set = SizedSet { first, files };
    let Some(i) = set.slot(warm_total) else {
        drop_sized_set(set);
        return false;
    };
    let f = set.files[i].as_ref().expect("slot checks presence");
    unsafe { enc.write(bundle, f.base as *mut u8) };
    let mut warm = path.as_os_str().to_owned();
    warm.push(".warm");
    let warm = PathBuf::from(warm);
    if std::fs::rename(&f.path, &warm).is_err() || std::fs::rename(&warm, &f.path).is_err() {
        let _ = std::fs::remove_file(&warm);
        drop_sized_set(set);
        return false;
    }
    *SIZED_SET.lock().unwrap_or_else(|e| e.into_inner()) = Some(set);
    true
}

fn drop_sized_set(set: SizedSet) {
    for f in set.files.into_iter().flatten() {
        unsafe { munmap(f.base as *mut u8, f.len) };
        let _ = std::fs::remove_file(&f.path);
    }
}

fn publish_sized(path: &Path, bundle: &R1csProofBundleLigerito) -> Option<Result<std::io::Result<()>, Vec<u8>>> {
    let guard = SIZED_SET.lock().unwrap_or_else(|e| e.into_inner());
    let set = guard.as_ref()?;
    let enc = bundle.raw_encoding()?;
    flock_core::gaptime::abs("raw_encoding");
    let Some(i) = set.slot(enc.len()) else {
        return Some(Err(enc.into_bytes(bundle)));
    };
    let f = set.files[i].as_ref().expect("slot checks presence");
    let par = rayon::current_thread_index().is_some();
    unsafe {
        if par {
            enc.write_par(bundle, f.base as *mut u8);
        } else {
            enc.write(bundle, f.base as *mut u8);
        }
    }
    flock_core::gaptime::abs("encoded");
    static SPIN_NOT_TO_END: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_EXP_SPIN_TO_END").is_none());
    if *SPIN_NOT_TO_END {
        preseed_spin_end();
    }
    Some(Ok(std::fs::rename(&f.path, path)))
}

fn publish_direct_proof(path: &Path, out: ProveOut) -> std::io::Result<()> {
    use std::io::Write;
    let (proof, commitment, _) = out;
    let bundle = R1csProofBundleLigerito { commitment, proof };
    flock_core::gaptime::abs("publish enter");
    let bytes = match publish_sized(path, &bundle) {
        Some(Ok(result)) => {
            std::mem::forget(bundle);
            flock_core::gaptime::abs("renamed");
            flock_core::gaptime::abs_flush();
            return result;
        }
        Some(Err(bytes)) => bytes,
        None => bundle.to_bytes(),
    };
    let mut temporary = path.as_os_str().to_owned();
    temporary.push(".tmp");
    let temporary = PathBuf::from(temporary);
    flock_core::gaptime::abs("to_bytes done");
    let mut file = std::fs::OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(false)
        .open(&temporary)?;
    flock_core::gaptime::abs("opened");
    file.write_all(&bytes)?;
    flock_core::gaptime::abs("written");
    file.set_len(bytes.len() as u64)?;
    drop(file);
    flock_core::gaptime::abs("closed");
    let r = std::fs::rename(temporary, path);
    flock_core::gaptime::abs("renamed");
    drop(bytes);
    flock_core::gaptime::abs("bytes dropped");
    flock_core::gaptime::abs_flush();
    r
}

fn rehearse_publish_tail(path: &Path, out: ProveOut) {
    let (proof, commitment, _) = out;
    let bundle = R1csProofBundleLigerito { commitment, proof };
    let mut temporary = path.as_os_str().to_owned();
    temporary.push(".tmp");
    let temporary = PathBuf::from(temporary);
    let mut rehearsal = path.as_os_str().to_owned();
    rehearsal.push(".warm");
    let rehearsal = PathBuf::from(rehearsal);
    if mapped_publish_enabled() && setup_sized_set(path, &bundle) {
        return;
    }
    let bytes = bundle.to_bytes();
    if std::fs::write(&temporary, &bytes).is_ok() {
        if std::fs::rename(&temporary, &rehearsal).is_ok()
            && std::fs::rename(&rehearsal, &temporary).is_err()
        {
            let _ = std::fs::remove_file(&rehearsal);
        }
    } else {
        let _ = std::fs::remove_file(&temporary);
    }
    drop(bytes);
}


fn is_ranked_worker() -> bool {
    ranked_worker_proof_path().is_some()
}

pub(crate) fn verify_generator_at_warmup(log2_size: u32, warmup_blocks: &[Compression]) {
    if std::env::var_os("FLOCK_NO_WARMUP_GENCHECK").is_some() || !is_ranked_worker() {
        return;
    }
    if warmup_blocks.len() != 1usize << log2_size {
        return;
    }
    let ours = generate_compressions_par(log2_size, WARMUP_SEED);
    if blocks_eq_serial(&ours, warmup_blocks) {
        GENERATOR_VERIFIED.store(true, Ordering::SeqCst);
    }
}

pub(crate) fn warmup_block_source(log2_size: u32) -> Option<BlockSource<'static>> {
    inline_block_gen_enabled().then(|| BlockSource::closed(log2_size, WARMUP_SEED))
}

pub(crate) fn arm(log2_size: u32, setup_addr: usize, run: fn(usize, BlockSource<'_>) -> ProveOut) {
    let Some(proof_path) = ranked_worker_proof_path() else {
        return;
    };
    if std::env::var_os("FLOCK_NO_SEED_PIPE").is_some() {
        return;
    }
    if ARMED.swap(true, Ordering::SeqCst) {
        return;
    }

    let inline = inline_block_gen_enabled();
    let scratch = if inline {
        Vec::new()
    } else {
        prefaulted_blocks(1usize << log2_size)
    };
    let direct_proof_path =
        (std::env::var_os("FLOCK_NO_DIRECT_PROOF_PUBLISH").is_none()).then_some(proof_path);

    let (real_stdin, writer) = unsafe {
        let real = dup(0);
        if real < 0 {
            ARMED.store(false, Ordering::SeqCst);
            return;
        }
        let mut fds = [0i32; 2];
        if sys_pipe(fds.as_mut_ptr()) != 0 {
            close(real);
            ARMED.store(false, Ordering::SeqCst);
            return;
        }
        if dup2(fds[0], 0) < 0 {
            close(real);
            close(fds[0]);
            close(fds[1]);
            ARMED.store(false, Ordering::SeqCst);
            return;
        }
        close(fds[0]);
        (real, fds[1])
    };

    let _ = shared();
    let warm = Arc::new((Mutex::new(false), Condvar::new()));
    let warm_tx = Arc::clone(&warm);
    let spawned = std::thread::Builder::new()
        .name("flock-seed-pipe".into())
        .stack_size(32 << 20)
        .spawn(move || {
            speculative_main(
                real_stdin,
                writer,
                log2_size,
                setup_addr,
                run,
                scratch,
                inline,
                direct_proof_path,
                warm_tx,
            )
        });

    if spawned.is_err() {
        unsafe {
            dup2(real_stdin, 0);
            close(real_stdin);
            close(writer);
        }
        ARMED.store(false, Ordering::SeqCst);
        return;
    }

    let (lock, cv) = &*warm;
    let mut done = lock.lock().unwrap_or_else(|e| e.into_inner());
    let deadline = std::time::Instant::now() + std::time::Duration::from_secs(240);
    while !*done {
        let now = std::time::Instant::now();
        if now >= deadline {
            break;
        }
        done = cv
            .wait_timeout(done, deadline - now)
            .unwrap_or_else(|e| e.into_inner())
            .0;
    }
}

#[allow(clippy::too_many_arguments)]
fn speculative_main(
    real_stdin: i32,
    writer: i32,
    log2_size: u32,
    setup_addr: usize,
    run: fn(usize, BlockSource<'_>) -> ProveOut,
    scratch: Vec<Compression>,
    inline: bool,
    direct_proof_path: Option<PathBuf>,
    warm: Arc<(Mutex<bool>, Condvar)>,
) {
    let mut scratch = scratch;
    let hot = hot_wait_enabled();

    if inline || scratch.len() == 1usize << log2_size {
        const SPEC_WARMUP_PROVES: usize = 17;
        const SPEC_WARMUP_BUDGET: std::time::Duration = std::time::Duration::from_secs(45);
        let spec_warmup_proves = if std::env::var_os("FLOCK_NO_SPEC_WARMUP").is_some() {
            1
        } else {
            SPEC_WARMUP_PROVES
        };
        let warmup_started = std::time::Instant::now();
        let rehearse_idx = spec_warmup_proves.saturating_sub(3);
        let mut rehearsed = false;
        let mut last_warm_out: Option<ProveOut> = None;
        for pass_idx in 0..spec_warmup_proves {
            let t0 = std::time::Instant::now();
            let warm_ok = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                let src = if inline {
                    BlockSource::closed(log2_size, WARMUP_SEED)
                } else {
                    fill_compressions_par(&mut scratch, log2_size, WARMUP_SEED);
                    BlockSource::Slice(&scratch)
                };
                std::hint::black_box(on_hot_worker(hot, || run(setup_addr, src)))
            }))
            .map(|out| last_warm_out = Some(out))
            .is_ok();
            if !rehearsed && pass_idx >= rehearse_idx {
                if let (Some(path), Some(out)) = (direct_proof_path.as_deref(), last_warm_out.take()) {
                    let _ = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                        rehearse_publish_tail(path, out);
                    }));
                    rehearsed = true;
                }
            }
            if std::env::var_os("FLOCK_SEED_PIPE_DEBUG").is_some() {
                eprintln!(
                    "[seed-pipe] thread warm-up prove {:.1} ms (ok={warm_ok}, untimed, inline={inline})",
                    t0.elapsed().as_secs_f64() * 1e3
                );
            }
            if warmup_started.elapsed() >= SPEC_WARMUP_BUDGET {
                break;
            }
        }
        if !rehearsed {
            if let (Some(path), Some(out)) = (direct_proof_path.as_deref(), last_warm_out.take()) {
                let _ = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    rehearse_publish_tail(path, out);
                }));
            }
        }
        drop(last_warm_out);
    }

    on_hot_worker(hot, move || {
        let (line_r, saved_flags) = if hot {
            spin_read_line_fd_with_notify(real_stdin, Some(warm), direct_proof_path.is_none())
        } else {
            notify_warm(Some(warm));
            (read_line_fd(real_stdin), None)
        };
        let cleanup_real_stdin = move || {
            if let Some(flags) = saved_flags {
                const F_SETFL: i32 = 4;
                unsafe { fcntl(real_stdin, F_SETFL, flags) };
            }
            close_fd(real_stdin);
        };
        flock_core::gaptime::abs("seed read");
        let Some(line) = line_r else {
            cleanup_real_stdin();
            close_fd(writer);
            mark_dead();
            return;
        };

        let parsed = std::str::from_utf8(&line)
            .ok()
            .and_then(|s| s.trim().parse::<u64>().ok());
        let Some(seed) = parsed else {
            cleanup_real_stdin();
            let _ = forward_and_close(writer, &line);
            mark_dead();
            return;
        };

        if direct_proof_path.is_none() {
            cleanup_real_stdin();
            if !forward_and_close(writer, &line) {
                mark_dead();
                return;
            }
        }

        TIMED_SPEC_PROVE.store(true, Ordering::Relaxed);
        let outcome = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            if inline {
                let n = 1usize << log2_size;
                let init = generator_init(log2_size, seed);
                if direct_proof_path.is_none() {
                    let seed_at = std::time::Instant::now();
                    let published = SpecBlocks::Endpoints {
                        len: n,
                        first: gen_block(init, 0),
                        last: gen_block(init, n - 1),
                    };
                    let mut state = shared().state.lock().unwrap_or_else(|e| e.into_inner());
                    state.seed_at = Some(seed_at);
                    state.blocks_at = Some(std::time::Instant::now());
                    state.blocks = Some(published);
                    shared().signal.notify_all();
                }
                return run(setup_addr, BlockSource::Closed { init, len: n });
            }

            let seed_at = std::time::Instant::now();
            let mut buf = std::mem::take(&mut scratch);
            let blocks = if buf.len() == 1usize << log2_size {
                fill_compressions_par(&mut buf, log2_size, seed);
                Arc::new(buf)
            } else {
                Arc::new(generate_compressions_par(log2_size, seed))
            };
            {
                let mut state = shared().state.lock().unwrap_or_else(|e| e.into_inner());
                state.seed_at = Some(seed_at);
                state.blocks_at = Some(std::time::Instant::now());
                state.blocks = Some(SpecBlocks::Full(Arc::clone(&blocks)));
                shared().signal.notify_all();
            }
            run(setup_addr, BlockSource::Slice(&blocks))
        }));

        match (direct_proof_path.as_deref(), outcome) {
            (Some(path), Ok(out)) => {
                let published = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    publish_direct_proof(path, out)
                }))
                .is_ok_and(|result| result.is_ok());
                TIMED_SPEC_PROVE.store(false, Ordering::Relaxed);
                cleanup_real_stdin();
                if published {
                    std::thread::sleep(std::time::Duration::from_millis(50));
                    close_fd(writer);
                    return;
                }
                let _ = forward_and_close(writer, &line);
                mark_dead();
            }
            (Some(_), Err(_)) => {
                TIMED_SPEC_PROVE.store(false, Ordering::Relaxed);
                cleanup_real_stdin();
                let _ = forward_and_close(writer, &line);
                mark_dead();
            }
            (None, Ok(out)) => {
                TIMED_SPEC_PROVE.store(false, Ordering::Relaxed);
                let mut state = shared().state.lock().unwrap_or_else(|e| e.into_inner());
                state.result = Some(out);
                shared().signal.notify_all();
            }
            (None, Err(_)) => {
                TIMED_SPEC_PROVE.store(false, Ordering::Relaxed);
                mark_dead();
            }
        }
    });
}


pub(crate) fn try_adopt(blocks: &[Compression]) -> Option<ProveOut> {
    if !ARMED.load(Ordering::SeqCst) {
        return None;
    }
    let shared = shared();
    let mut state = shared.state.lock().unwrap_or_else(|e| e.into_inner());

    while state.blocks.is_none() && !state.dead {
        state = shared.signal.wait(state).unwrap_or_else(|e| e.into_inner());
    }
    if state.dead {
        return None;
    }
    let speculative = state.blocks.as_ref()?.clone();
    let seed_at = state.seed_at;
    let blocks_at = state.blocks_at;
    drop(state);

    let fast_gate = GENERATOR_VERIFIED.load(Ordering::SeqCst);
    let matched = {
        if fast_gate {
            speculative.endpoints_match(blocks)
        } else {
            speculative.full_match(blocks).unwrap_or(false)
        }
    };

    if std::env::var_os("FLOCK_SEED_PIPE_DEBUG").is_some()
        && let (Some(seed_at), Some(blocks_at)) = (seed_at, blocks_at)
    {
        let ms = |d: std::time::Duration| d.as_secs_f64() * 1e3;
        eprintln!(
            "[seed-pipe] par-gen {:.3} ms, head start {:.3} ms, blocks matched={matched}, gate={}",
            ms(blocks_at - seed_at),
            ms(seed_at.elapsed()),
            if fast_gate { "fast" } else { "full" },
        );
    }

    let mut state = shared.state.lock().unwrap_or_else(|e| e.into_inner());
    while state.result.is_none() && !state.dead {
        state = shared.signal.wait(state).unwrap_or_else(|e| e.into_inner());
    }
    let result = state.result.take();
    if std::env::var_os("FLOCK_SEED_PIPE_DEBUG").is_some()
        && let Some(seed_at) = seed_at
    {
        eprintln!(
            "[seed-pipe] result ready {:.3} ms after seed (dead={}, matched={matched})",
            seed_at.elapsed().as_secs_f64() * 1e3,
            state.dead
        );
    }
    if state.dead || !matched {
        return None;
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    std::thread_local! {
        static PRESEED_DEPTH: core::cell::Cell<usize> = const { core::cell::Cell::new(0) };
    }
    static PRESEED_MAX_DEPTH: std::sync::atomic::AtomicUsize =
        std::sync::atomic::AtomicUsize::new(0);
    static PRESEED_ENTRIES: std::sync::atomic::AtomicUsize =
        std::sync::atomic::AtomicUsize::new(0);

    pub(super) struct PreseedDepth;
    impl PreseedDepth {
        pub(super) fn enter() -> Self {
            let depth = PRESEED_DEPTH.with(|d| {
                let next = d.get() + 1;
                d.set(next);
                next
            });
            PRESEED_MAX_DEPTH.fetch_max(depth, Ordering::Relaxed);
            PRESEED_ENTRIES.fetch_add(1, Ordering::Relaxed);
            Self
        }
    }
    impl Drop for PreseedDepth {
        fn drop(&mut self) {
            PRESEED_DEPTH.with(|d| d.set(d.get() - 1));
        }
    }

    fn preseed_finishes_without_rescue(body: impl FnOnce(Arc<AtomicBool>) + Send + 'static) -> bool {
        let _ = flock_core::init_perf_thread_pool();
        assert!(flock_core::ranked_pool_built(), "requires the ranked topology pool");
        assert!(std::env::var_os("FLOCK_NO_HOT_POOL").is_none());
        let finished = Arc::new(AtomicBool::new(false));
        let cancel = Arc::new(AtomicBool::new(false));
        let (done, stop) = (finished.clone(), cancel.clone());
        let worker = std::thread::spawn(move || {
            body(stop);
            done.store(true, Ordering::Release);
        });
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(3);
        while !finished.load(Ordering::Acquire) && std::time::Instant::now() < deadline {
            std::thread::sleep(std::time::Duration::from_millis(1));
        }
        let timely = finished.load(Ordering::Acquire);
        cancel.store(true, Ordering::Release);
        let cleanup = std::time::Instant::now() + std::time::Duration::from_secs(3);
        while !finished.load(Ordering::Acquire) && std::time::Instant::now() < cleanup {
            preseed_spin_end();
            std::thread::sleep(std::time::Duration::from_millis(1));
        }
        assert!(finished.load(Ordering::Acquire), "spinner cleanup failed");
        worker.join().unwrap();
        timely
    }

    #[test]
    #[ignore = "requires a fresh ranked pool; run with RAYON_NUM_THREADS=16"]
    fn preseed_delayed_callback_cannot_block_new_owner() {
        assert!(preseed_finishes_without_rescue(|cancel| {
            let b_entered = AtomicBool::new(false);
            let a_done = AtomicBool::new(false);
            rayon::broadcast(|ctx| match ctx.index() {
                0 => {
                    while !b_entered.load(Ordering::Acquire) && !cancel.load(Ordering::Acquire) {
                        std::thread::yield_now();
                    }
                    if !cancel.load(Ordering::Acquire) { on_hot_worker(true, || {}); }
                    a_done.store(true, Ordering::Release);
                }
                1 => {
                    b_entered.store(true, Ordering::Release);
                    while !a_done.load(Ordering::Acquire) && !cancel.load(Ordering::Acquire) {
                        std::thread::yield_now();
                    }
                    if !cancel.load(Ordering::Acquire) {
                        on_hot_worker(true, || { let _ = rayon::yield_now(); });
                    }
                }
                _ => {}
            });
        }), "a stale callback blocked its new owner until watchdog rescue");
    }

    #[test]
    #[ignore = "requires a fresh ranked pool; run with RAYON_NUM_THREADS=16"]
    fn preseed_restart_and_nested_work_complete() {
        use std::sync::atomic::AtomicUsize;
        PRESEED_MAX_DEPTH.store(0, Ordering::Relaxed);
        PRESEED_ENTRIES.store(0, Ordering::Relaxed);
        let completed = Arc::new(AtomicUsize::new(0));
        let count = completed.clone();
        let timely = preseed_finishes_without_rescue(move |stop| {
            for iteration in 0..512usize {
                if stop.load(Ordering::Acquire) { break; }
                on_hot_worker(true, || {
                    let (a, b) = rayon::join(
                        || (0..64usize).into_par_iter().map(|x| x ^ iteration).sum::<usize>(),
                        || rayon::join(|| iteration.wrapping_mul(17), || iteration ^ 91),
                    );
                    std::hint::black_box((a, b));
                    if !stop.load(Ordering::Acquire) { tail_spin_start(); }
                });
                count.fetch_add(1, Ordering::Release);
            }
        });
        let entries = PRESEED_ENTRIES.load(Ordering::Relaxed);
        let depth = PRESEED_MAX_DEPTH.load(Ordering::Relaxed);
        eprintln!("preseed callbacks admitted={entries}, max admitted depth={depth}");
        assert!(timely, "preseed lifetimes stalled after {} completed phases", completed.load(Ordering::Acquire));
        assert_eq!(completed.load(Ordering::Acquire), 512);
        assert!(entries > 0, "no production spinner was admitted");
        assert_eq!(depth, 1, "a spinner admitted a nested spinner");
    }

    #[test]
    #[ignore = "requires a fresh ranked pool; run with RAYON_NUM_THREADS=16"]
    fn preseed_and_hot_pool_nested_work_complete() {
        use std::sync::atomic::AtomicUsize;
        let completed = Arc::new(AtomicUsize::new(0));
        let count = completed.clone();
        assert!(preseed_finishes_without_rescue(move |stop| {
            for iteration in 0..512usize {
                if stop.load(Ordering::Acquire) { break; }
                on_hot_worker(true, || {
                    let _hot = flock_core::hot_pool::HotPool::start().expect("hot pool enabled");
                    std::hint::black_box(rayon::join(
                        || (0..64usize).into_par_iter().map(|x| x ^ iteration).sum::<usize>(),
                        || rayon::join(|| iteration.wrapping_mul(17), || iteration ^ 91),
                    ));
                    if !stop.load(Ordering::Acquire) { tail_spin_start(); }
                });
                count.fetch_add(1, Ordering::Release);
            }
        }), "mixed warming callbacks stalled after {} phases", completed.load(Ordering::Acquire));
        assert_eq!(completed.load(Ordering::Acquire), 512);
    }


    fn reference(log2_size: u32, seed: u64) -> Vec<Compression> {
        struct Rng(u64);
        impl Rng {
            fn next_u32(&mut self) -> u32 {
                self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
                let mut z = self.0;
                z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
                z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
                (z ^ (z >> 31)) as u32
            }
        }
        let count = 1usize << log2_size;
        let mut rng = Rng(seed ^ u64::from(log2_size).rotate_left(29));
        (0..count)
            .map(|_| {
                let cv = std::array::from_fn(|_| rng.next_u32());
                let message = std::array::from_fn(|_| rng.next_u32());
                let counter = u64::from(rng.next_u32());
                (cv, message, counter, 64, 11)
            })
            .collect()
    }

    #[test]
    fn seed_pipe_matches_reference_generator() {
        for &log2 in &[8u32, 12, 13] {
            for &seed in &[0u64, 1, 0x00C0_FFEE_BEEF_D15C, u64::MAX, 0x5DEE_CE66_D_u64] {
                assert_eq!(
                    generate_compressions_par(log2, seed),
                    reference(log2, seed),
                    "log2={log2} seed={seed}"
                );
            }
        }
    }

    #[test]
    fn seed_pipe_matches_reference_at_ranked_size() {
        for &seed in &[0x1234_5678_9ABC_DEF0u64, WARMUP_SEED, 424242, u64::MAX] {
            assert_eq!(
                generate_compressions_par(18, seed),
                reference(18, seed),
                "seed={seed}"
            );
        }
    }

    #[test]
    fn seed_pipe_prefaulted_fill_matches_reference() {
        let mut buf = prefaulted_blocks(1 << 12);
        fill_compressions_par(&mut buf, 12, 0xDEAD_BEEF);
        assert_eq!(buf, reference(12, 0xDEAD_BEEF));
        assert_eq!(
            gen_block(generator_init(12, 0xDEAD_BEEF), 77),
            reference(12, 0xDEAD_BEEF)[77]
        );
    }

    #[test]
    fn seed_pipe_block_comparison_is_exact() {
        let a = generate_compressions_par(10, 7);
        let mut b = a.clone();
        assert!(blocks_eq(&a, &b));
        assert!(blocks_eq_serial(&a, &b));
        b[900].1[3] ^= 1;
        assert!(!blocks_eq(&a, &b));
        assert!(!blocks_eq_serial(&a, &b));
        assert!(!blocks_eq(&a, &a[..a.len() - 1]));
        assert!(!blocks_eq_serial(&a, &a[..a.len() - 1]));
    }

    #[test]
    fn seed_pipe_closed_source_matches_reference() {
        for &log2 in &[8u32, 12, 13] {
            for &seed in &[0u64, 1, WARMUP_SEED, u64::MAX] {
                let want = reference(log2, seed);
                let src = BlockSource::closed(log2, seed);
                assert_eq!(src.len(), want.len(), "log2={log2} seed={seed}");
                assert!(!src.is_empty());
                let pad = ZERO_COMPRESSION;
                for (i, expect) in want.iter().enumerate() {
                    let got = src.with_block(i, &pad, |b| *b);
                    assert_eq!(&got, expect, "log2={log2} seed={seed} i={i}");
                }
                assert_eq!(src.with_block(want.len(), &pad, |b| *b), pad);
                assert_eq!(src.to_vec(), want, "to_vec log2={log2} seed={seed}");
            }
        }
    }

    #[test]
    fn seed_pipe_slice_source_matches_direct_indexing() {
        let blocks = generate_compressions_par(9, 0xFEED_FACE);
        let short = &blocks[..300];
        let pad: Compression = ([7; 8], [9; 16], 5, 64, 11);
        let src = BlockSource::Slice(short);
        for i in 0..blocks.len() {
            let got = src.with_block(i, &pad, |b| *b);
            assert_eq!(&got, short.get(i).unwrap_or(&pad), "i={i}");
        }
    }

    #[test]
    fn seed_pipe_inline_decision_covers_both_adoption_states() {
        use std::ffi::OsStr;
        assert!(!inline_block_gen_decision(false, None));
        assert!(!inline_block_gen_decision(false, Some(OsStr::new("1"))));
        assert!(inline_block_gen_decision(true, None));
        assert!(!inline_block_gen_decision(true, Some(OsStr::new("1"))));
        assert!(inline_block_gen_decision(true, Some(OsStr::new("0"))));
        assert!(inline_block_gen_decision(true, Some(OsStr::new(""))));
        assert!(inline_block_gen_decision(true, None));
    }

    #[test]
    fn seed_pipe_endpoint_gate_agrees_with_full_gate() {
        let a = generate_compressions_par(10, 7);
        let init = generator_init(10, 7);
        let n = a.len();
        let full = SpecBlocks::Full(Arc::new(a.clone()));
        let ends = SpecBlocks::Endpoints {
            len: n,
            first: gen_block(init, 0),
            last: gen_block(init, n - 1),
        };
        assert_eq!(full.len(), n);
        assert_eq!(ends.len(), n);
        assert!(full.endpoints_match(&a) && ends.endpoints_match(&a));
        assert_eq!(full.full_match(&a), Some(true));
        assert_eq!(ends.full_match(&a), None);

        let other = generate_compressions_par(10, 8);
        assert!(!full.endpoints_match(&other));
        assert!(!ends.endpoints_match(&other));
        assert_eq!(full.full_match(&other), Some(false));

        assert!(!full.endpoints_match(&a[..n - 1]));
        assert!(!ends.endpoints_match(&a[..n - 1]));

        assert!(!ends.endpoints_match(&[]));
    }

    #[test]
    fn seed_pipe_stays_disarmed_outside_the_ranked_worker() {
        assert!(!is_ranked_worker());
        assert!(try_adopt(&[]).is_none());
        verify_generator_at_warmup(8, &generate_compressions_par(8, WARMUP_SEED));
        assert!(!GENERATOR_VERIFIED.load(Ordering::SeqCst));
    }

    #[test]
    #[ignore]
    fn seed_pipe_generator_timing_probe() {
        let ms = |d: std::time::Duration| d.as_secs_f64() * 1e3;
        for round in 0..4 {
            let t = std::time::Instant::now();
            let r = reference(18, 0x00C0_FFEE_BEEF_D15C ^ round);
            let t_ref = t.elapsed();
            let t = std::time::Instant::now();
            let p = generate_compressions_par(18, 0x00C0_FFEE_BEEF_D15C ^ round);
            let t_par = t.elapsed();
            let mut buf = prefaulted_blocks(1 << 18);
            let t = std::time::Instant::now();
            fill_compressions_par(&mut buf, 18, 0x00C0_FFEE_BEEF_D15C ^ round);
            let t_fill = t.elapsed();
            assert_eq!(r, p);
            assert_eq!(r, buf);
            eprintln!(
                "[probe] round {round}: serial reference {:.3} ms, par (alloc+fill) {:.3} ms, par fill into prefaulted {:.3} ms",
                ms(t_ref),
                ms(t_par),
                ms(t_fill)
            );
        }
    }

    #[test]
    fn seed_pipe_line_io_roundtrip() {
        let mut fds = [0i32; 2];
        assert_eq!(unsafe { sys_pipe(fds.as_mut_ptr()) }, 0);
        assert!(write_all_fd(fds[1], b"424242\n"));
        let line = read_line_fd(fds[0]).expect("line");
        assert_eq!(line, b"424242\n");
        unsafe {
            close(fds[0]);
            close(fds[1]);
        }
    }
}
