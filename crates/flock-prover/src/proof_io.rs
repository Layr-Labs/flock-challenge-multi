
use std::io;
use std::path::Path;

use serde::{Deserialize, Serialize};

use flock_core::pcs::Commitment;

pub const MAGIC: [u8; 5] = *b"FLOCK";

pub const VERSION: u8 = 4;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum HashKind {
    Blake3,
    Sha2,
    Keccak,
}

impl HashKind {
    pub fn parse(s: &str) -> Option<Self> {
        match s.to_ascii_lowercase().as_str() {
            "blake3" => Some(Self::Blake3),
            "sha2" | "sha256" | "sha-2" | "sha-256" => Some(Self::Sha2),
            "keccak" | "keccak_f" | "keccak-f" => Some(Self::Keccak),
            _ => None,
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Blake3 => "blake3",
            Self::Sha2 => "sha2",
            Self::Keccak => "keccak",
        }
    }
}

const FLAVOR_R1CS_LIGERITO: u8 = 2;
const FLAVOR_CHAIN_LIGERITO: u8 = 3;

const HEADER_LEN: usize = 7;

#[derive(Debug)]
pub enum DeserializeError {
    BadMagic,
    UnsupportedVersion(u8),
    UnknownFlavor(u8),
    Truncated,
    FlavorMismatch { expected: u8, found: u8 },
    Bincode(bincode::Error),
}

impl std::fmt::Display for DeserializeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::BadMagic => write!(f, "bad magic: not a FLOCK proof file"),
            Self::UnsupportedVersion(v) => {
                write!(f, "unsupported version {v} (this build expects {VERSION})")
            }
            Self::UnknownFlavor(v) => write!(f, "unknown flavor byte: {v}"),
            Self::Truncated => write!(f, "input shorter than header ({HEADER_LEN} bytes)"),
            Self::FlavorMismatch { expected, found } => {
                write!(f, "flavor mismatch: expected {expected}, found {found}")
            }
            Self::Bincode(e) => write!(f, "bincode error: {e}"),
        }
    }
}

impl std::error::Error for DeserializeError {}

impl From<bincode::Error> for DeserializeError {
    fn from(e: bincode::Error) -> Self {
        Self::Bincode(e)
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct R1csProofBundleLigerito {
    pub commitment: Commitment,
    pub proof: flock_core::proof::R1csProofLigerito,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ChainProofBundleLigerito {
    pub hash_kind: HashKind,
    pub commitment: Commitment,
    pub proof: crate::r1cs_hashes::chain_common::ChainProofLigerito,
    pub cv_0_phys: Vec<bool>,
    pub cv_last_phys: Vec<bool>,
}

impl R1csProofBundleLigerito {
    pub fn to_bytes(&self) -> Vec<u8> {
        if let Some(mut out) = take_matching_pre_encoded(self) {
            flock_core::gaptime::abs("stash taken");
            encode_pcs_open_into(&mut out, &self.proof.pcs_open);
            return out;
        }
        let mut out = Vec::with_capacity(HEADER_LEN + 460_000);
        write_header(&mut out, FLAVOR_R1CS_LIGERITO);
        if fast_pcs_open_encode_enabled() {
            bincode::serialize_into(&mut out, &self.commitment)
                .expect("bincode serialize Commitment");
            bincode::serialize_into(&mut out, &self.proof.zerocheck)
                .expect("bincode serialize ZerocheckProof");
            bincode::serialize_into(&mut out, &self.proof.lincheck)
                .expect("bincode serialize LincheckProof");
            encode_pcs_open_into(&mut out, &self.proof.pcs_open);
        } else {
            bincode::serialize_into(&mut out, self)
                .expect("bincode serialize R1csProofBundleLigerito");
        }
        out
    }
    pub(crate) fn raw_encoding(&self) -> Option<RawEncoding> {
        if !fast_pcs_open_encode_enabled() {
            return None;
        }
        let prefix = take_matching_pre_encoded(self)?;
        let (mut small, mut jobs) = take_plan_scratch();
        small.clear();
        jobs.clear();
        let mut plan = PlanSink {
            pos: 0,
            small,
            small_overflow: Vec::new(),
            jobs,
        };
        plan.put(&prefix);
        encode_pcs_open_flat(&mut plan, &self.proof.pcs_open);
        Some(RawEncoding { prefix, plan })
    }

    pub fn from_bytes(bytes: &[u8]) -> Result<Self, DeserializeError> {
        let payload = parse_header(bytes, FLAVOR_R1CS_LIGERITO)?;
        Ok(bincode::deserialize(payload)?)
    }
}


struct PreEncodedPrefix {
    root: flock_core::merkle::Hash,
    sec_lens: [u64; 3],
    bytes: Vec<u8>,
}

static PRE_ENCODED: std::sync::Mutex<Option<PreEncodedPrefix>> = std::sync::Mutex::new(None);
static STASH_SCRATCH: std::sync::Mutex<Option<Vec<u8>>> = std::sync::Mutex::new(None);
static PLAN_SCRATCH: std::sync::Mutex<Option<(Vec<u8>, Vec<(usize, usize, usize)>)>> =
    std::sync::Mutex::new(None);

pub(crate) fn has_warm_stash_scratch() -> bool {
    let cap = HEADER_LEN + 460_000;
    STASH_SCRATCH
        .lock()
        .ok()
        .is_some_and(|g| g.as_ref().is_some_and(|v| v.capacity() >= cap))
        || PRE_ENCODED
            .lock()
            .ok()
            .is_some_and(|g| g.as_ref().is_some_and(|p| p.bytes.capacity() >= cap))
}

fn take_stash_scratch(prefault: bool) -> Vec<u8> {
    let cap = HEADER_LEN + 460_000;
    if let Ok(mut guard) = STASH_SCRATCH.lock()
        && let Some(mut v) = guard.take()
        && v.capacity() >= cap
    {
        v.clear();
        return v;
    }
    let mut bytes = Vec::with_capacity(cap);
    if prefault {
        prefault_spare_capacity(&mut bytes);
    }
    bytes
}

fn recycle_stash_scratch(mut v: Vec<u8>) {
    if v.capacity() >= HEADER_LEN + 460_000
        && let Ok(mut guard) = STASH_SCRATCH.lock()
    {
        v.clear();
        *guard = Some(v);
    }
}

fn take_plan_scratch() -> (Vec<u8>, Vec<(usize, usize, usize)>) {
    if let Ok(mut guard) = PLAN_SCRATCH.lock()
        && let Some((mut small, mut jobs)) = guard.take()
        && small.capacity() >= PLAN_SMALL_CHUNK
    {
        small.clear();
        jobs.clear();
        return (small, jobs);
    }
    let mut small = Vec::with_capacity(PLAN_SMALL_CHUNK);
    prefault_spare_capacity(&mut small);
    let jobs = Vec::with_capacity(1024);
    (small, jobs)
}

fn recycle_plan_scratch(mut small: Vec<u8>, mut jobs: Vec<(usize, usize, usize)>) {
    if small.capacity() >= PLAN_SMALL_CHUNK
        && let Ok(mut guard) = PLAN_SCRATCH.lock()
    {
        small.clear();
        jobs.clear();
        *guard = Some((small, jobs));
    }
}

pub(crate) fn pre_encode_enabled() -> bool {
    static ON: std::sync::OnceLock<bool> = std::sync::OnceLock::new();
    *ON.get_or_init(|| std::env::var("FLOCK_NO_PRE_ENCODE").map_or(true, |v| v != "1"))
}

fn pubtail_fix_enabled() -> bool {
    static ON: std::sync::OnceLock<bool> = std::sync::OnceLock::new();
    *ON.get_or_init(|| std::env::var("FLOCK_NO_PUBTAIL_FIX").map_or(true, |v| v != "1"))
}

fn prefault_spare_capacity(bytes: &mut Vec<u8>) {
    const PAGE: usize = 4096;
    let cap = bytes.capacity();
    if cap == 0 {
        return;
    }
    let ptr = bytes.as_mut_ptr();
    let mut off = 0usize;
    while off < cap {
        unsafe { std::ptr::write_volatile(ptr.add(off), 0u8) };
        off += PAGE;
    }
    unsafe { std::ptr::write_volatile(ptr.add(cap - 1), 0u8) };
}

pub fn stash_pre_encoded_prefix(
    commitment: &Commitment,
    zerocheck: &flock_core::zerocheck::ZerocheckProof,
    lincheck: &flock_core::lincheck::LincheckProof,
) {
    stash_pre_encoded_prefix_with(commitment, zerocheck, lincheck, pubtail_fix_enabled());
}

type StashJob = Box<dyn FnOnce() + Send>;

pub(crate) enum StashDone {
    Helper(std::sync::mpsc::Receiver<()>),
    Thread(std::thread::JoinHandle<()>),
}

impl StashDone {
    pub(crate) fn wait(self) {
        match self {
            StashDone::Helper(done) => {
                let _ = done.recv();
            }
            StashDone::Thread(handle) => {
                let _ = handle.join();
            }
        }
    }
}

fn stash_helper_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_STASH_HELPER").is_none());
    *ON
}

fn stash_helper() -> Option<&'static std::sync::mpsc::Sender<StashJob>> {
    static HELPER: std::sync::OnceLock<Option<std::sync::mpsc::Sender<StashJob>>> =
        std::sync::OnceLock::new();
    HELPER
        .get_or_init(|| {
            let (queue, jobs) = std::sync::mpsc::channel::<StashJob>();
            std::thread::Builder::new()
                .name("flock-stash".into())
                .spawn(move || {
                    for job in jobs {
                        job();
                    }
                })
                .ok()
                .map(|_| queue)
        })
        .as_ref()
}

pub(crate) fn spawn_stash(job: impl FnOnce() + Send + 'static) -> StashDone {
    if stash_helper_enabled()
        && let Some(queue) = stash_helper()
    {
        let (done_tx, done_rx) = std::sync::mpsc::sync_channel::<()>(1);
        let wrapped: StashJob = Box::new(move || {
            job();
            let _ = done_tx.send(());
        });
        return match queue.send(wrapped) {
            Ok(()) => StashDone::Helper(done_rx),
            Err(std::sync::mpsc::SendError(wrapped)) => {
                StashDone::Thread(std::thread::spawn(move || wrapped()))
            }
        };
    }
    StashDone::Thread(std::thread::spawn(job))
}

fn stash_pre_encoded_prefix_with(
    commitment: &Commitment,
    zerocheck: &flock_core::zerocheck::ZerocheckProof,
    lincheck: &flock_core::lincheck::LincheckProof,
    prefault: bool,
) {
    if !pre_encode_enabled() {
        return;
    }
    if let Ok(mut slot) = PRE_ENCODED.lock()
        && let Some(old) = slot.take()
    {
        recycle_stash_scratch(old.bytes);
    }
    let mut bytes = take_stash_scratch(prefault);
    write_header(&mut bytes, FLAVOR_R1CS_LIGERITO);
    let mut sec_lens = [0u64; 3];
    let mut mark = bytes.len();
    bincode::serialize_into(&mut bytes, commitment).expect("bincode serialize Commitment");
    sec_lens[0] = (bytes.len() - mark) as u64;
    mark = bytes.len();
    bincode::serialize_into(&mut bytes, zerocheck).expect("bincode serialize ZerocheckProof");
    sec_lens[1] = (bytes.len() - mark) as u64;
    mark = bytes.len();
    bincode::serialize_into(&mut bytes, lincheck).expect("bincode serialize LincheckProof");
    sec_lens[2] = (bytes.len() - mark) as u64;
    if let Ok(mut slot) = PRE_ENCODED.lock() {
        *slot = Some(PreEncodedPrefix {
            root: commitment.root,
            sec_lens,
            bytes,
        });
    }
}

fn take_matching_pre_encoded(bundle: &R1csProofBundleLigerito) -> Option<Vec<u8>> {
    if !pre_encode_enabled() {
        return None;
    }
    let stash = PRE_ENCODED.lock().ok()?.take()?;
    if stash.root != bundle.commitment.root {
        return None;
    }
    if !crate::seed_pipe::is_timed_speculative_prove() {
        let sec_lens = [
            bincode::serialized_size(&bundle.commitment).ok()?,
            bincode::serialized_size(&bundle.proof.zerocheck).ok()?,
            bincode::serialized_size(&bundle.proof.lincheck).ok()?,
        ];
        if sec_lens != stash.sec_lens {
            return None;
        }
    }
    let want = HEADER_LEN + stash.sec_lens.iter().sum::<u64>() as usize;
    (stash.bytes.len() == want).then_some(stash.bytes)
}


use flock_core::field::F128;
use flock_core::merkle::Hash as MerkleHash;
use flock_core::pcs::BatchOpeningProofLigerito;
use flock_core::pcs::ligerito::{FinalProof, LigeritoProof, RecursiveProof, SumcheckMessage};
use flock_core::pcs::ring_switch::RingSwitchProof;

fn fast_pcs_open_encode_enabled() -> bool {
    static ON: std::sync::OnceLock<bool> = std::sync::OnceLock::new();
    cfg!(target_endian = "little")
        && *ON.get_or_init(|| std::env::var("FLOCK_NO_FAST_ENCODE").map_or(true, |v| v != "1"))
}

pub(crate) trait ByteSink {
    fn put(&mut self, bytes: &[u8]);
}

impl ByteSink for Vec<u8> {
    #[inline]
    fn put(&mut self, bytes: &[u8]) {
        self.extend_from_slice(bytes);
    }
}

pub(crate) struct PlanSink {
    pos: usize,
    small: Vec<u8>,
    small_overflow: Vec<Vec<u8>>,
    jobs: Vec<(usize, usize, usize)>,
}

const PLAN_SMALL_MAX: usize = 64;
const PLAN_SMALL_CHUNK: usize = 32 << 10;

impl ByteSink for PlanSink {
    #[inline]
    fn put(&mut self, bytes: &[u8]) {
        let len = bytes.len();
        let src = if len > PLAN_SMALL_MAX {
            bytes.as_ptr() as usize
        } else if self.small.capacity() - self.small.len() >= len {
            let at = self.small.len();
            self.small.extend_from_slice(bytes); // within capacity: no reallocation
            self.small.as_ptr() as usize + at
        } else {
            if self
                .small_overflow
                .last()
                .is_none_or(|cur| cur.capacity() - cur.len() < len)
            {
                self.small_overflow.push(Vec::with_capacity(PLAN_SMALL_CHUNK));
            }
            let cur = self.small_overflow.last_mut().expect("chunk pushed above");
            let at = cur.len();
            cur.extend_from_slice(bytes);
            cur.as_ptr() as usize + at
        };
        match self.jobs.last_mut() {
            Some(last) if last.0 + last.2 == self.pos && last.1 + last.2 == src => last.2 += len,
            _ => self.jobs.push((self.pos, src, len)),
        }
        self.pos += len;
    }
}

pub(crate) struct RawEncoding {
    prefix: Vec<u8>,
    plan: PlanSink,
}

impl RawEncoding {
    #[inline]
    pub(crate) fn len(&self) -> usize {
        self.plan.pos
    }

    pub(crate) fn into_bytes(self, bundle: &R1csProofBundleLigerito) -> Vec<u8> {
        recycle_plan_scratch(self.plan.small, self.plan.jobs);
        let mut out = self.prefix;
        encode_pcs_open_into(&mut out, &bundle.proof.pcs_open);
        out
    }

    pub(crate) unsafe fn write(self, _bundle: &R1csProofBundleLigerito, dst: *mut u8) {
        let base = dst as usize;
        for &(d, s, len) in &self.plan.jobs {
            unsafe { std::ptr::copy_nonoverlapping(s as *const u8, (base + d) as *mut u8, len) };
        }
        if crate::seed_pipe::is_timed_speculative_prove() {
            std::mem::forget(self.plan);
            std::mem::forget(self.prefix);
        } else {
            recycle_plan_scratch(self.plan.small, self.plan.jobs);
            recycle_stash_scratch(self.prefix);
        }
    }

    pub(crate) unsafe fn write_par(self, _bundle: &R1csProofBundleLigerito, dst: *mut u8) {
        use rayon::prelude::*;
        const PIECE: usize = 32 << 10;
        let total = self.plan.pos;
        let n_pieces = total.div_ceil(PIECE);
        let jobs = &self.plan.jobs;
        let base = dst as usize;
        (0..n_pieces).into_par_iter().for_each(|p| {
            let piece_start = p * PIECE;
            let piece_end = ((p + 1) * PIECE).min(total);
            let mut idx = jobs.partition_point(|&(d, _, len)| d + len <= piece_start);
            while idx < jobs.len() {
                let (d, s, len) = jobs[idx];
                if d >= piece_end {
                    break;
                }
                let copy_start = d.max(piece_start);
                let copy_end = (d + len).min(piece_end);
                let skip = copy_start - d;
                unsafe {
                    std::ptr::copy_nonoverlapping(
                        (s + skip) as *const u8,
                        (base + copy_start) as *mut u8,
                        copy_end - copy_start,
                    );
                }
                idx += 1;
            }
        });
        if crate::seed_pipe::is_timed_speculative_prove() {
            std::mem::forget(self.plan);
            std::mem::forget(self.prefix);
        } else {
            recycle_plan_scratch(self.plan.small, self.plan.jobs);
            recycle_stash_scratch(self.prefix);
        }
    }
}

fn encode_pcs_open_into(out: &mut Vec<u8>, p: &BatchOpeningProofLigerito) {
    if !fast_pcs_open_encode_enabled() {
        bincode::serialize_into(&mut *out, p).expect("bincode serialize pcs_open");
        return;
    }
    encode_pcs_open_flat(out, p);
}

fn encode_pcs_open_flat<S: ByteSink>(out: &mut S, p: &BatchOpeningProofLigerito) {
    let BatchOpeningProofLigerito {
        ring_switches,
        ligerito,
    } = p;
    put_u64(out, ring_switches.len() as u64);
    for rs in ring_switches {
        let RingSwitchProof { s_hat_v } = rs;
        put_f128_vec(out, s_hat_v);
    }
    let LigeritoProof {
        initial_root,
        initial_proof,
        recursive_roots,
        recursive_proofs,
        final_proof,
        sumcheck_transcript,
        grinding_nonces,
        ood_values,
        fold_grinding_nonces,
    } = ligerito;
    out.put(initial_root);
    put_recursive_proof(out, initial_proof);
    put_hash_vec(out, recursive_roots);
    put_u64(out, recursive_proofs.len() as u64);
    for rp in recursive_proofs {
        put_recursive_proof(out, rp);
    }
    let FinalProof {
        yr,
        opened_rows,
        merkle_proof,
    } = final_proof;
    put_f128_vec(out, yr);
    put_rows(out, opened_rows);
    put_hash_vec(out, merkle_proof);
    put_u64(out, sumcheck_transcript.len() as u64);
    for m in sumcheck_transcript {
        let SumcheckMessage { u_0, u_2 } = m;
        put_f128(out, *u_0);
        put_f128(out, *u_2);
    }
    put_u64_vec(out, grinding_nonces);
    put_f128_vec(out, ood_values);
    put_u64_vec(out, fold_grinding_nonces);
}

fn put_recursive_proof<S: ByteSink>(out: &mut S, rp: &RecursiveProof) {
    let RecursiveProof {
        opened_rows,
        merkle_proof,
    } = rp;
    put_rows(out, opened_rows);
    put_hash_vec(out, merkle_proof);
}

#[inline]
fn put_u64<S: ByteSink>(out: &mut S, v: u64) {
    out.put(&v.to_le_bytes());
}

#[inline]
fn put_f128<S: ByteSink>(out: &mut S, v: F128) {
    put_u64(out, v.lo);
    put_u64(out, v.hi);
}

#[inline]
fn put_f128_vec<S: ByteSink>(out: &mut S, v: &[F128]) {
    put_u64(out, v.len() as u64);
    let bytes =
        unsafe { std::slice::from_raw_parts(v.as_ptr().cast::<u8>(), std::mem::size_of_val(v)) };
    out.put(bytes);
}

#[inline]
fn put_hash_vec<S: ByteSink>(out: &mut S, v: &[MerkleHash]) {
    put_u64(out, v.len() as u64);
    out.put(v.as_flattened());
}

#[inline]
fn put_u64_vec<S: ByteSink>(out: &mut S, v: &[u64]) {
    put_u64(out, v.len() as u64);
    for &x in v {
        put_u64(out, x);
    }
}

fn put_rows<S: ByteSink>(out: &mut S, rows: &[Vec<F128>]) {
    put_u64(out, rows.len() as u64);
    for row in rows {
        put_f128_vec(out, row);
    }
}

impl ChainProofBundleLigerito {
    pub fn to_bytes(&self) -> Vec<u8> {
        let mut out = Vec::with_capacity(HEADER_LEN + 1024);
        write_header(&mut out, FLAVOR_CHAIN_LIGERITO);
        bincode::serialize_into(&mut out, self)
            .expect("bincode serialize ChainProofBundleLigerito");
        out
    }
    pub fn from_bytes(bytes: &[u8]) -> Result<Self, DeserializeError> {
        let payload = parse_header(bytes, FLAVOR_CHAIN_LIGERITO)?;
        Ok(bincode::deserialize(payload)?)
    }
}


fn write_header(out: &mut Vec<u8>, flavor: u8) {
    out.extend_from_slice(&MAGIC);
    out.push(VERSION);
    out.push(flavor);
}

fn parse_header(bytes: &[u8], expected_flavor: u8) -> Result<&[u8], DeserializeError> {
    if bytes.len() < HEADER_LEN {
        return Err(DeserializeError::Truncated);
    }
    if bytes[0..5] != MAGIC {
        return Err(DeserializeError::BadMagic);
    }
    let v = bytes[5];
    if v != VERSION {
        return Err(DeserializeError::UnsupportedVersion(v));
    }
    let flavor = bytes[6];
    if flavor != FLAVOR_R1CS_LIGERITO && flavor != FLAVOR_CHAIN_LIGERITO {
        return Err(DeserializeError::UnknownFlavor(flavor));
    }
    if flavor != expected_flavor {
        return Err(DeserializeError::FlavorMismatch {
            expected: expected_flavor,
            found: flavor,
        });
    }
    Ok(&bytes[HEADER_LEN..])
}


pub fn write_bytes_to_file<P: AsRef<Path>>(path: P, bytes: &[u8]) -> io::Result<()> {
    let path = path.as_ref();
    let tmp = match path.parent() {
        Some(dir) => dir.join(format!(
            ".{}.tmp",
            path.file_name()
                .and_then(|f| f.to_str())
                .unwrap_or("flock-proof")
        )),
        None => Path::new(".flock-proof.tmp").to_path_buf(),
    };
    std::fs::write(&tmp, bytes)?;
    std::fs::rename(&tmp, path)
}

pub fn read_bytes_from_file<P: AsRef<Path>>(path: P) -> io::Result<Vec<u8>> {
    std::fs::read(path)
}

pub fn write_chain_bundle_ligerito_to_file<P: AsRef<Path>>(
    path: P,
    bundle: &ChainProofBundleLigerito,
) -> io::Result<()> {
    write_bytes_to_file(path, &bundle.to_bytes())
}

pub fn read_chain_bundle_ligerito_from_file<P: AsRef<Path>>(
    path: P,
) -> Result<ChainProofBundleLigerito, BundleReadError> {
    let bytes = read_bytes_from_file(path).map_err(BundleReadError::Io)?;
    ChainProofBundleLigerito::from_bytes(&bytes).map_err(BundleReadError::Deserialize)
}

#[derive(Debug)]
pub enum BundleReadError {
    Io(io::Error),
    Deserialize(DeserializeError),
}

impl std::fmt::Display for BundleReadError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Io(e) => write!(f, "I/O error: {e}"),
            Self::Deserialize(e) => write!(f, "deserialize error: {e}"),
        }
    }
}

impl std::error::Error for BundleReadError {}


#[cfg(test)]
mod tests {
    use super::*;
    use crate::r1cs_hashes::blake3::{Blake3Setup, Compression, blake3_compress, cv_to_phys_bits};
    use flock_core::challenger::FsChallenger;

    struct Rng(u64);
    impl Rng {
        fn new(seed: u64) -> Self {
            Self(seed)
        }
        fn nx(&mut self) -> u64 {
            self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
            let mut z = self.0;
            z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
            z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
            z ^ (z >> 31)
        }
    }

    #[test]
    fn flat_pcs_open_encoder_matches_bincode() {
        let f128 = |rng: &mut Rng| F128::new(rng.nx(), rng.nx());
        let f128_vec = |rng: &mut Rng, n: usize| -> Vec<F128> {
            (0..n).map(|_| F128::new(rng.nx(), rng.nx())).collect()
        };
        let hash_vec = |rng: &mut Rng, n: usize| -> Vec<MerkleHash> {
            (0..n)
                .map(|_| std::array::from_fn(|_| rng.nx() as u8))
                .collect()
        };
        let rows = |rng: &mut Rng, n: usize, w: usize| -> Vec<Vec<F128>> {
            (0..n)
                .map(|i| {
                    (0..(w + i % 3))
                        .map(|_| F128::new(rng.nx(), rng.nx()))
                        .collect()
                })
                .collect()
        };

        let mut rng = Rng::new(0x515E_D0F1);
        for (n_rs, n_rec, n_rows, n_msgs) in [
            (0usize, 0usize, 0usize, 0usize),
            (1, 1, 3, 2),
            (3, 4, 17, 55),
        ] {
            let recursive_proof = |rng: &mut Rng| RecursiveProof {
                opened_rows: rows(rng, n_rows, 4),
                merkle_proof: hash_vec(rng, n_rows * 2 + 1),
            };
            let proof = BatchOpeningProofLigerito {
                ring_switches: (0..n_rs)
                    .map(|i| RingSwitchProof {
                        s_hat_v: f128_vec(&mut rng, i * 7),
                    })
                    .collect(),
                ligerito: LigeritoProof {
                    initial_root: std::array::from_fn(|_| rng.nx() as u8),
                    initial_proof: recursive_proof(&mut rng),
                    recursive_roots: hash_vec(&mut rng, n_rec),
                    recursive_proofs: (0..n_rec).map(|_| recursive_proof(&mut rng)).collect(),
                    final_proof: FinalProof {
                        yr: f128_vec(&mut rng, n_msgs * 3),
                        opened_rows: rows(&mut rng, n_rows, 2),
                        merkle_proof: hash_vec(&mut rng, n_rows),
                    },
                    sumcheck_transcript: (0..n_msgs)
                        .map(|_| SumcheckMessage {
                            u_0: f128(&mut rng),
                            u_2: f128(&mut rng),
                        })
                        .collect(),
                    grinding_nonces: (0..n_rec).map(|_| rng.nx()).collect(),
                    ood_values: {
                        let mut v = f128_vec(&mut rng, n_rec);
                        if let Some(first) = v.first_mut() {
                            *first = F128::ZERO;
                        }
                        if let Some(last) = v.last_mut() {
                            *last = F128::new(u64::MAX, u64::MAX);
                        }
                        v
                    },
                    fold_grinding_nonces: (0..n_msgs).map(|_| rng.nx()).collect(),
                },
            };
            let incumbent = bincode::serialize(&proof).expect("bincode serialize");
            let mut flat = Vec::new();
            encode_pcs_open_into(&mut flat, &proof);
            assert_eq!(
                flat, incumbent,
                "flat encoder diverged at shape (n_rs={n_rs}, n_rec={n_rec}, n_rows={n_rows}, n_msgs={n_msgs})"
            );
        }
    }

    fn synthetic_bundle(
        seed: u64,
        n_rows: usize,
        width: usize,
        n_rec: usize,
        n_msgs: usize,
    ) -> R1csProofBundleLigerito {
        let mut rng = Rng::new(seed);
        let f128 = |rng: &mut Rng| F128::new(rng.nx(), rng.nx());
        let f128_vec = |rng: &mut Rng, n: usize| -> Vec<F128> {
            (0..n).map(|_| F128::new(rng.nx(), rng.nx())).collect()
        };
        let hash_vec = |rng: &mut Rng, n: usize| -> Vec<MerkleHash> {
            (0..n)
                .map(|_| std::array::from_fn(|_| rng.nx() as u8))
                .collect()
        };
        let rows = |rng: &mut Rng, n: usize, w: usize| -> Vec<Vec<F128>> {
            (0..n)
                .map(|i| {
                    (0..(w + i % 3))
                        .map(|_| F128::new(rng.nx(), rng.nx()))
                        .collect()
                })
                .collect()
        };
        let recursive_proof = |rng: &mut Rng| RecursiveProof {
            opened_rows: rows(rng, n_rows, width),
            merkle_proof: hash_vec(rng, n_rows * 2 + 1),
        };
        let pcs_open = BatchOpeningProofLigerito {
            ring_switches: (0..3)
                .map(|i| RingSwitchProof {
                    s_hat_v: f128_vec(&mut rng, i * 9 + 5),
                })
                .collect(),
            ligerito: LigeritoProof {
                initial_root: std::array::from_fn(|_| rng.nx() as u8),
                initial_proof: recursive_proof(&mut rng),
                recursive_roots: hash_vec(&mut rng, n_rec),
                recursive_proofs: (0..n_rec).map(|_| recursive_proof(&mut rng)).collect(),
                final_proof: FinalProof {
                    yr: f128_vec(&mut rng, n_msgs * 3),
                    opened_rows: rows(&mut rng, n_rows, width),
                    merkle_proof: hash_vec(&mut rng, n_rows),
                },
                sumcheck_transcript: (0..n_msgs)
                    .map(|_| SumcheckMessage {
                        u_0: f128(&mut rng),
                        u_2: f128(&mut rng),
                    })
                    .collect(),
                grinding_nonces: (0..n_rec).map(|_| rng.nx()).collect(),
                ood_values: f128_vec(&mut rng, n_rec),
                fold_grinding_nonces: (0..n_msgs).map(|_| rng.nx()).collect(),
            },
        };
        R1csProofBundleLigerito {
            commitment: Commitment {
                root: std::array::from_fn(|_| rng.nx() as u8),
                params: flock_core::pcs::PcsParams {
                    m: 32,
                    log_inv_rate: 1,
                    log_batch_size: 5,
                    profile: Default::default(),
                    merkle_hash: Default::default(),
                },
            },
            proof: flock_core::proof::R1csProofLigerito {
                zerocheck: flock_core::zerocheck::ZerocheckProof {
                    round1_ab: f128_vec(&mut rng, 128),
                    round1_c: f128_vec(&mut rng, 128),
                    multilinear_rounds: (0..25)
                        .map(|_| (f128(&mut rng), f128(&mut rng)))
                        .collect(),
                    final_a_eval: f128(&mut rng),
                    final_b_eval: f128(&mut rng),
                    final_c_eval: f128(&mut rng),
                },
                lincheck: flock_core::lincheck::LincheckProof {
                    rounds: (0..11).map(|_| (f128(&mut rng), f128(&mut rng))).collect(),
                    z_partial: f128_vec(&mut rng, 256),
                },
                pcs_open,
            },
        }
    }

    fn first_difference(a: &[u8], b: &[u8]) -> Option<usize> {
        (a != b).then(|| a.iter().zip(b).position(|(x, y)| x != y).unwrap_or(0))
    }

    #[test]
    fn pubtail_prefault_keeps_bytes_identical() {
        for (label, n_rows, width, n_rec, n_msgs) in [
            ("under-capacity", 64usize, 48usize, 4usize, 55usize),
            ("over-capacity", 128, 64, 4, 55),
        ] {
            let bundle = synthetic_bundle(0x5AFE_7A11, n_rows, width, n_rec, n_msgs);

            let mut reference = Vec::new();
            write_header(&mut reference, FLAVOR_R1CS_LIGERITO);
            bincode::serialize_into(&mut reference, &bundle).expect("reference serialize");

            let mut arms: Vec<Vec<u8>> = Vec::new();
            for prefault in [true, false] {
                if let Ok(mut slot) = PRE_ENCODED.lock() {
                    *slot = None;
                }
                stash_pre_encoded_prefix_with(
                    &bundle.commitment,
                    &bundle.proof.zerocheck,
                    &bundle.proof.lincheck,
                    prefault,
                );
                if pre_encode_enabled() {
                    assert!(
                        PRE_ENCODED.lock().expect("stash lock").is_some(),
                        "{label}: stash not written (prefault={prefault})"
                    );
                }
                let bytes = bundle.to_bytes();
                if pre_encode_enabled() {
                    assert!(
                        PRE_ENCODED.lock().expect("stash lock").is_none(),
                        "{label}: fast path did not consume the stash (prefault={prefault})"
                    );
                }
                assert_eq!(
                    bytes.len(),
                    reference.len(),
                    "{label}: length moved (prefault={prefault})"
                );
                if let Some(i) = first_difference(&bytes, &reference) {
                    panic!(
                        "{label}: published bytes moved at index {i} \
                         (prefault={prefault}): got {:#04x}, want {:#04x}",
                        bytes[i], reference[i]
                    );
                }
                arms.push(bytes);
            }
            if let Some(i) = first_difference(&arms[0], &arms[1]) {
                panic!(
                    "{label}: fix ON vs OFF differ at index {i}: {:#04x} vs {:#04x}",
                    arms[0][i], arms[1][i]
                );
            }
            for par in [false, true] {
                stash_pre_encoded_prefix_with(
                    &bundle.commitment,
                    &bundle.proof.zerocheck,
                    &bundle.proof.lincheck,
                    true,
                );
                let enc = bundle.raw_encoding().expect("raw_encoding");
                assert_eq!(enc.len(), reference.len());
                let mut dst = vec![0u8; enc.len()];
                unsafe {
                    if par {
                        enc.write_par(&bundle, dst.as_mut_ptr());
                    } else {
                        enc.write(&bundle, dst.as_mut_ptr());
                    }
                }
                assert_eq!(dst, reference, "{label}: raw_encoding write(par={par}) diverged");
            }
            eprintln!(
                "pubtail prefault {label}: {} bytes identical ON/OFF",
                arms[0].len()
            );
        }
    }

    #[test]
    fn prefault_touches_only_spare_capacity() {
        let payload: Vec<u8> = (0..9_999u32).map(|i| (i % 251) as u8).collect();
        let mut plain = Vec::with_capacity(HEADER_LEN + 460_000);
        plain.extend_from_slice(&payload);

        let mut touched = Vec::with_capacity(HEADER_LEN + 460_000);
        let cap_before = touched.capacity();
        let ptr_before = touched.as_ptr();
        prefault_spare_capacity(&mut touched);
        assert_eq!(touched.len(), 0, "prefault changed len");
        assert_eq!(touched.capacity(), cap_before, "prefault reallocated");
        assert_eq!(touched.as_ptr(), ptr_before, "prefault moved the buffer");
        touched.extend_from_slice(&payload);
        assert_eq!(touched, plain, "prefault perturbed written bytes");

        let mut empty: Vec<u8> = Vec::new();
        prefault_spare_capacity(&mut empty);
        assert!(empty.is_empty());
        let mut tiny: Vec<u8> = Vec::with_capacity(1);
        prefault_spare_capacity(&mut tiny);
        tiny.push(7);
        assert_eq!(tiny, vec![7]);
    }

    fn honest_chain(n: usize, seed: u64) -> (Vec<Compression>, [u32; 8], [u32; 8]) {
        let mut rng = Rng::new(seed);
        let mut cv: [u32; 8] = std::array::from_fn(|_| rng.nx() as u32);
        let cv0 = cv;
        let mut blocks = Vec::with_capacity(n);
        for _ in 0..n {
            let m: [u32; 16] = std::array::from_fn(|_| rng.nx() as u32);
            let counter = 0u64;
            let block_len = 64u32;
            let flags = 0u32;
            blocks.push((cv, m, counter, block_len, flags));
            let st = blake3_compress(&cv, &m, counter, block_len, flags);
            cv = st[0..8].try_into().unwrap();
        }
        (blocks, cv0, cv)
    }

    #[test]
    #[ignore] // Heavier — run with `cargo test r1cs_bundle_roundtrip -- --ignored --nocapture`
    fn r1cs_bundle_roundtrip() {
        let setup = Blake3Setup::new(256);
        let (blocks, _, _) = honest_chain(256, 0xDEAD_5170);
        let mut ch = FsChallenger::new(b"flock-proofio-lig");
        let (proof, commitment, _claim) = setup.prove_fast(&blocks, &mut ch);

        let bundle = R1csProofBundleLigerito {
            commitment: commitment.clone(),
            proof: proof.clone(),
        };
        let bytes = bundle.to_bytes();
        assert_eq!(&bytes[0..5], &MAGIC);
        assert_eq!(bytes[5], VERSION);
        assert_eq!(bytes[6], FLAVOR_R1CS_LIGERITO);

        let mut reference = Vec::new();
        write_header(&mut reference, FLAVOR_R1CS_LIGERITO);
        bincode::serialize_into(&mut reference, &bundle).expect("reference serialize");
        assert_eq!(
            bytes, reference,
            "fast to_bytes diverged from single-shot bincode"
        );

        stash_pre_encoded_prefix(
            &bundle.commitment,
            &bundle.proof.zerocheck,
            &bundle.proof.lincheck,
        );
        assert_eq!(
            bundle.to_bytes(),
            reference,
            "stashed-prefix to_bytes diverged"
        );

        let bundle2 = R1csProofBundleLigerito::from_bytes(&bytes).expect("must round-trip");
        assert_eq!(bundle2.commitment.root, commitment.root);

        let mut chv = FsChallenger::new(b"flock-proofio-lig");
        setup
            .verify(&bundle2.commitment, &bundle2.proof, &mut chv)
            .expect("verify round-tripped Ligerito R1cs proof");

        let flip_at = HEADER_LEN + (bytes.len() - HEADER_LEN) / 2;
        let mut mutated = bytes.clone();
        mutated[flip_at] ^= 0xFF;
        match R1csProofBundleLigerito::from_bytes(&mutated) {
            Err(_) => {}
            Ok(bundle3) => {
                let mut chv = FsChallenger::new(b"flock-proofio-lig");
                let res = setup.verify(&bundle3.commitment, &bundle3.proof, &mut chv);
                assert!(res.is_err(), "verify must reject byte-mutated proof");
            }
        }

        let path = std::env::temp_dir().join("flock-proofio-roundtrip.bin");
        write_bytes_to_file(&path, &bytes).expect("write");
        let read_back = read_bytes_from_file(&path).expect("read");
        let _ = std::fs::remove_file(&path);
        let bundle4 = R1csProofBundleLigerito::from_bytes(&read_back).expect("file round-trip");
        let mut chv = FsChallenger::new(b"flock-proofio-lig");
        setup
            .verify(&bundle4.commitment, &bundle4.proof, &mut chv)
            .expect("verify after file round-trip");

        eprintln!(
            "Ligerito R1csProofBundle: {} bytes ({:.1} KB)",
            bytes.len(),
            bytes.len() as f64 / 1024.0
        );
    }

    #[test]
    #[ignore] // Heavier — run with `cargo test chain_bundle_roundtrip -- --ignored --nocapture`
    fn chain_bundle_roundtrip_and_verify() {
        let setup = Blake3Setup::new(256);
        let (blocks, cv_0, cv_last) = honest_chain(256, 0xC0FFEE);
        let mut ch = FsChallenger::new(b"flock-proofio-test");
        let (proof, commitment) = setup.prove_chain(&blocks, &mut ch);

        let bundle = ChainProofBundleLigerito {
            hash_kind: HashKind::Blake3,
            commitment: commitment.clone(),
            proof: proof.clone(),
            cv_0_phys: cv_to_phys_bits(&cv_0),
            cv_last_phys: cv_to_phys_bits(&cv_last),
        };
        let bytes = bundle.to_bytes();
        assert_eq!(bytes[6], FLAVOR_CHAIN_LIGERITO);

        let bundle2 = ChainProofBundleLigerito::from_bytes(&bytes).expect("chain round-trip");
        assert_eq!(bundle2.cv_0_phys, bundle.cv_0_phys);
        assert_eq!(bundle2.cv_last_phys, bundle.cv_last_phys);

        let mut chv = FsChallenger::new(b"flock-proofio-test");
        setup
            .verify_chain(
                &bundle2.commitment,
                &bundle2.proof,
                &cv_0,
                &cv_last,
                &mut chv,
            )
            .expect("verify round-tripped chain proof");
    }

    #[test]
    fn rejects_bad_magic() {
        let mut bytes = vec![0u8; HEADER_LEN + 10];
        bytes[0..5].copy_from_slice(b"NOPE!");
        bytes[5] = VERSION;
        bytes[6] = FLAVOR_R1CS_LIGERITO;
        let res = R1csProofBundleLigerito::from_bytes(&bytes);
        assert!(matches!(res, Err(DeserializeError::BadMagic)));
    }

    #[test]
    fn rejects_unsupported_version() {
        let mut bytes = vec![0u8; HEADER_LEN + 10];
        bytes[0..5].copy_from_slice(&MAGIC);
        bytes[5] = VERSION.wrapping_add(1);
        bytes[6] = FLAVOR_R1CS_LIGERITO;
        let res = R1csProofBundleLigerito::from_bytes(&bytes);
        assert!(matches!(res, Err(DeserializeError::UnsupportedVersion(_))));
    }

    #[test]
    fn rejects_flavor_mismatch() {
        let mut bytes = vec![0u8; HEADER_LEN + 10];
        bytes[0..5].copy_from_slice(&MAGIC);
        bytes[5] = VERSION;
        bytes[6] = FLAVOR_R1CS_LIGERITO;
        let res = ChainProofBundleLigerito::from_bytes(&bytes);
        assert!(matches!(
            res,
            Err(DeserializeError::FlavorMismatch {
                expected: FLAVOR_CHAIN_LIGERITO,
                found: FLAVOR_R1CS_LIGERITO
            })
        ));
    }

    #[test]
    fn rejects_legacy_basefold_flavor() {
        for legacy in [0u8, 1u8] {
            let mut bytes = vec![0u8; HEADER_LEN + 10];
            bytes[0..5].copy_from_slice(&MAGIC);
            bytes[5] = VERSION;
            bytes[6] = legacy;
            let res = R1csProofBundleLigerito::from_bytes(&bytes);
            assert!(matches!(res, Err(DeserializeError::UnknownFlavor(f)) if f == legacy));
        }
    }

    #[test]
    fn rejects_truncated() {
        let res = R1csProofBundleLigerito::from_bytes(&[0u8; 3]);
        assert!(matches!(res, Err(DeserializeError::Truncated)));
    }
}
