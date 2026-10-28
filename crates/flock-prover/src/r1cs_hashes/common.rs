use std::sync::OnceLock;

use flock_core::bits::transpose_8_u64s_to_64_bytes;
use flock_core::field::F128;
use flock_core::r1cs::{BlockR1cs, SparseBinaryMatrix, WitnessLayout};

#[inline(always)]
pub(crate) fn or_u32_at_bit(buf: &mut [u64], bit_off: usize, val: u32) {
    let u64_idx = bit_off >> 6;
    let shift = bit_off & 63;
    buf[u64_idx] |= (val as u64) << shift;
    if shift > 32 {
        buf[u64_idx + 1] |= (val as u64) >> (64 - shift);
    }
}

#[inline(always)]
pub(crate) fn or_bit_at(buf: &mut [u64], bit_off: usize) {
    buf[bit_off >> 6] |= 1u64 << (bit_off & 63);
}

pub(crate) struct BitRecord<const NW: usize> {
    w: [u64; NW],
}

impl<const NW: usize> BitRecord<NW> {
    #[inline(always)]
    pub(crate) fn new() -> Self {
        Self { w: [0u64; NW] }
    }

    #[inline(always)]
    pub(crate) fn push<const POS: usize>(&mut self, val: u32) {
        let v = val as u64;
        let idx = POS >> 6;
        let s = POS & 63;
        self.w[idx] |= v << s;
        if s > 32 {
            self.w[idx + 1] |= v >> (64 - s);
        }
    }

    #[inline(always)]
    pub(crate) fn flush(&self, buf: &mut [u64], base_bit: usize) {
        let bi = base_bit >> 6;
        let s = base_bit & 63;
        let mut spill = 0u64;
        for j in 0..NW {
            buf[bi + j] |= (self.w[j] << s) | spill;
            spill = (self.w[j] >> 1) >> (63 - s);
        }
        buf[bi + NW] |= spill;
    }
}

#[inline(always)]
pub(crate) fn add_carry_parts(x: u32, y: u32) -> (u32, u32, u32, u32) {
    unsafe {
        let xu = x as u64;
        let yu = y as u64;
        let sc = flock_core::gf2_kernels::gf2_kern_blake3_add_sum_carry(xu, yu);
        let lr = flock_core::gf2_kernels::gf2_kern_blake3_add_lr(xu, yu);
        (sc as u32, lr as u32, (lr >> 32) as u32, (sc >> 32) as u32)
    }
}

pub(crate) fn empty_matrix(k: usize) -> SparseBinaryMatrix {
    SparseBinaryMatrix {
        num_rows: k,
        num_cols: k,
        rows: vec![Vec::new(); k],
    }
}

pub(crate) fn identity(k: usize) -> SparseBinaryMatrix {
    SparseBinaryMatrix {
        num_rows: k,
        num_cols: k,
        rows: (0..k).map(|i| vec![i]).collect(),
    }
}

pub(crate) fn build_block_r1cs_empty_stub(
    n_blocks_log: usize,
    k_log: usize,
    k_skip: usize,
    useful_bits: usize,
) -> BlockR1cs {
    let k = 1usize << k_log;
    build_block_r1cs_with_matrices(
        n_blocks_log,
        k_log,
        k_skip,
        useful_bits,
        empty_matrix(k),
        empty_matrix(k),
        None,
    )
}

#[allow(clippy::too_many_arguments)]
pub(crate) fn build_block_r1cs_with_matrices(
    n_blocks_log: usize,
    k_log: usize,
    k_skip: usize,
    useful_bits: usize,
    a_0: SparseBinaryMatrix,
    b_0: SparseBinaryMatrix,
    const_pin: Option<usize>,
) -> BlockR1cs {
    assert!(
        n_blocks_log >= 3,
        "lincheck needs n_outer ≥ 8 — pick n_blocks_log ≥ 3"
    );
    let k = 1usize << k_log;
    assert!(
        useful_bits <= k,
        "useful_bits ({useful_bits}) must be ≤ 2^k_log ({k})"
    );
    BlockR1cs {
        m: k_log + n_blocks_log,
        k_log,
        k_skip,
        useful_bits,
        a_0,
        b_0,
        c_0: identity(k),
        layout: WitnessLayout::RowMajor,
        const_pin,
        digest_cache: OnceLock::new(),
        csc_cache: OnceLock::new(),
    }
}

pub(crate) fn drive_witness_packed_and_lincheck<S: Sync, F>(
    initial_states: &[S],
    padding: Option<&S>,
    n_blocks_log: usize,
    k_log: usize,
    per_block: F,
) -> (Vec<F128>, Vec<F128>, Vec<F128>, Vec<u8>)
where
    F: Fn(&S, &mut [u64], &mut [u64], &mut [u64]) + Sync,
{
    use rayon::prelude::*;

    let k = 1usize << k_log;
    let f128_per_block = k / 128;
    let u64_per_block = k / 64;
    let n_total = 1usize << n_blocks_log;
    let n_blocks = initial_states.len();
    assert!(
        n_blocks <= n_total,
        "{n_blocks} blocks > 2^{n_blocks_log} = {n_total} slots"
    );
    assert!(
        n_total >= 8 && n_total.is_multiple_of(8),
        "lincheck stripe layout requires n_total ≥ 8 and divisible by 8"
    );

    let total_f128 = n_total * f128_per_block;
    let mut z = flock_core::scratch::take_f128(total_f128);
    let mut a = flock_core::scratch::take_f128(total_f128);
    let mut b = flock_core::scratch::take_f128(total_f128);
    let mut z_lincheck = vec![0u8; (n_total / 8) * k];

    z.par_chunks_mut(8 * f128_per_block)
        .zip(a.par_chunks_mut(8 * f128_per_block))
        .zip(b.par_chunks_mut(8 * f128_per_block))
        .zip(z_lincheck.par_chunks_mut(k))
        .enumerate()
        .for_each(|(g, (((z_grp, a_grp), b_grp), stripe))| {
            unsafe {
                std::ptr::write_bytes(z_grp.as_mut_ptr(), 0, z_grp.len());
                std::ptr::write_bytes(a_grp.as_mut_ptr(), 0, a_grp.len());
                std::ptr::write_bytes(b_grp.as_mut_ptr(), 0, b_grp.len());
            }
            for k_in in 0..8 {
                let global_idx = 8 * g + k_in;
                let init: &S = if global_idx < n_blocks {
                    &initial_states[global_idx]
                } else if let Some(p) = padding {
                    p
                } else {
                    continue;
                };
                let z_chunk = &mut z_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                let a_chunk = &mut a_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                let b_chunk = &mut b_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                let z_u64: &mut [u64] = unsafe {
                    std::slice::from_raw_parts_mut(
                        z_chunk.as_mut_ptr() as *mut u64,
                        z_chunk.len() * 2,
                    )
                };
                let a_u64: &mut [u64] = unsafe {
                    std::slice::from_raw_parts_mut(
                        a_chunk.as_mut_ptr() as *mut u64,
                        a_chunk.len() * 2,
                    )
                };
                let b_u64: &mut [u64] = unsafe {
                    std::slice::from_raw_parts_mut(
                        b_chunk.as_mut_ptr() as *mut u64,
                        b_chunk.len() * 2,
                    )
                };
                per_block(init, z_u64, a_u64, b_u64);
            }

            let z_u64_all: &[u64] = unsafe {
                std::slice::from_raw_parts(z_grp.as_ptr() as *const u64, z_grp.len() * 2)
            };
            for i in 0..u64_per_block {
                let lanes: [u64; 8] = [
                    z_u64_all[0 * u64_per_block + i],
                    z_u64_all[u64_per_block + i],
                    z_u64_all[2 * u64_per_block + i],
                    z_u64_all[3 * u64_per_block + i],
                    z_u64_all[4 * u64_per_block + i],
                    z_u64_all[5 * u64_per_block + i],
                    z_u64_all[6 * u64_per_block + i],
                    z_u64_all[7 * u64_per_block + i],
                ];
                transpose_8_u64s_to_64_bytes(&lanes, &mut stripe[i * 64..i * 64 + 64]);
            }
        });

    (z, a, b, z_lincheck)
}

pub(crate) fn drive_witness_packed<S: Sync, F>(
    initial_states: &[S],
    padding: &S,
    n_blocks_log: usize,
    k_log: usize,
    per_block: F,
) -> (Vec<F128>, Vec<F128>, Vec<F128>)
where
    F: Fn(&S, &mut [u64], &mut [u64], &mut [u64]) + Sync,
{
    use rayon::prelude::*;

    let k = 1usize << k_log;
    let f128_per_block = k / 128;
    let n_total = 1usize << n_blocks_log;
    assert!(initial_states.len() <= n_total);
    assert!(
        n_total >= 8 && n_total.is_multiple_of(8),
        "row-major witness driver requires at least 8 block slots"
    );

    let total_f128 = n_total * f128_per_block;
    let mut z = flock_core::scratch::take_f128(total_f128);
    let mut a = flock_core::scratch::take_f128(total_f128);
    let mut b = flock_core::scratch::take_f128(total_f128);

    let use_nt = cfg!(target_arch = "aarch64")
        && u64_per_block_is_nt_compatible(f128_per_block * 2)
        && std::env::var_os("FLOCK_NO_WITNESS_NT").is_none();

    z.par_chunks_mut(8 * f128_per_block)
        .zip(a.par_chunks_mut(8 * f128_per_block))
        .zip(b.par_chunks_mut(8 * f128_per_block))
        .enumerate()
        .for_each_init(
            || {
                if use_nt {
                    let u64s = f128_per_block * 2;
                    (vec![0u64; u64s], vec![0u64; u64s], vec![0u64; u64s])
                } else {
                    (Vec::new(), Vec::new(), Vec::new())
                }
            },
            |(z_stage, a_stage, b_stage), (g, ((z_grp, a_grp), b_grp))| {
                for k_in in 0..8 {
                    let global_idx = 8 * g + k_in;
                    let initial = initial_states.get(global_idx).unwrap_or(padding);
                    let z_chunk = &mut z_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                    let a_chunk = &mut a_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                    let b_chunk = &mut b_grp[k_in * f128_per_block..(k_in + 1) * f128_per_block];
                    if use_nt {
                        per_block(initial, z_stage, a_stage, b_stage);
                        let n = z_stage.len();
                        unsafe {
                            nt_copy_u64s(z_stage.as_ptr(), z_chunk.as_mut_ptr() as *mut u64, n);
                            nt_copy_u64s(a_stage.as_ptr(), a_chunk.as_mut_ptr() as *mut u64, n);
                            nt_copy_u64s(b_stage.as_ptr(), b_chunk.as_mut_ptr() as *mut u64, n);
                        }
                        continue;
                    }
                    let z_u64 = unsafe {
                        std::slice::from_raw_parts_mut(
                            z_chunk.as_mut_ptr() as *mut u64,
                            z_chunk.len() * 2,
                        )
                    };
                    let a_u64 = unsafe {
                        std::slice::from_raw_parts_mut(
                            a_chunk.as_mut_ptr() as *mut u64,
                            a_chunk.len() * 2,
                        )
                    };
                    let b_u64 = unsafe {
                        std::slice::from_raw_parts_mut(
                            b_chunk.as_mut_ptr() as *mut u64,
                            b_chunk.len() * 2,
                        )
                    };
                    per_block(initial, z_u64, a_u64, b_u64);
                }
            },
        );

    (z, a, b)
}

#[inline]
pub(crate) fn u64_per_block_is_nt_compatible(u64s: usize) -> bool {
    u64s.is_multiple_of(16)
}

pub(crate) fn xor_dedup(mut v: Vec<usize>) -> Vec<usize> {
    v.sort();
    let mut out = Vec::with_capacity(v.len());
    let mut i = 0;
    while i < v.len() {
        let val = v[i];
        let mut count = 0;
        while i < v.len() && v[i] == val {
            count += 1;
            i += 1;
        }
        if count % 2 == 1 {
            out.push(val);
        }
    }
    out
}

pub(crate) const BM_V: usize = 8;
pub(crate) type BmRow = [u64; BM_V];

#[derive(Copy, Clone)]
pub(crate) struct SendPtr(pub *mut u64);
unsafe impl Send for SendPtr {}
unsafe impl Sync for SendPtr {}
impl SendPtr {
    pub(crate) fn get(self) -> *mut u64 {
        self.0
    }
}

#[inline(always)]
pub(crate) fn or_u32_row(rows: &mut [BmRow], bit: usize, vals: &[u32; BM_V]) {
    let w = bit >> 6;
    let s = bit & 63;
    for j in 0..BM_V {
        rows[w][j] |= (vals[j] as u64) << s;
    }
    if s > 32 {
        for j in 0..BM_V {
            rows[w + 1][j] |= (vals[j] as u64) >> (64 - s);
        }
    }
}

#[inline(always)]
pub(crate) fn or_bit_row(rows: &mut [BmRow], bit: usize) {
    let w = bit >> 6;
    let s = bit & 63;
    for j in 0..BM_V {
        rows[w][j] |= 1u64 << s;
    }
}

#[inline(always)]
pub(crate) unsafe fn nt_store_row(src: *const u64, dst: *mut u64) {
    #[cfg(target_arch = "aarch64")]
    unsafe {
        std::arch::asm!(
            "ldp {t0:q}, {t1:q}, [{s}]",
            "stnp {t0:q}, {t1:q}, [{d}]",
            "ldp {t0:q}, {t1:q}, [{s}, #32]",
            "stnp {t0:q}, {t1:q}, [{d}, #32]",
            "ldp {t0:q}, {t1:q}, [{s}, #64]",
            "stnp {t0:q}, {t1:q}, [{d}, #64]",
            "ldp {t0:q}, {t1:q}, [{s}, #96]",
            "stnp {t0:q}, {t1:q}, [{d}, #96]",
            s = in(reg) src, d = in(reg) dst,
            t0 = out(vreg) _, t1 = out(vreg) _,
            options(nostack),
        );
    }
    #[cfg(not(target_arch = "aarch64"))]
    unsafe {
        std::ptr::copy_nonoverlapping(src, dst, 2 * BM_V);
    }
}

#[inline]
pub(crate) unsafe fn nt_copy_u64s(src: *const u64, dst: *mut u64, n: usize) {
    debug_assert!(n.is_multiple_of(16));
    let mut i = 0;
    while i < n {
        unsafe { nt_store_row(src.add(i), dst.add(i)) };
        i += 16;
    }
}

#[inline]
pub(crate) unsafe fn flush_rows_nt(
    rows: &[BmRow],
    dest: *mut u64,
    o0: usize,
    n_log: usize,
    useful_chunks: usize,
) {
    debug_assert!(2 * useful_chunks <= rows.len());
    for c in 0..useful_chunks {
        let even = &rows[2 * c];
        let odd = &rows[2 * c + 1];
        let mut buf = [0u64; 2 * BM_V];
        for j in 0..BM_V {
            buf[2 * j] = even[j];
            buf[2 * j + 1] = odd[j];
        }
        unsafe {
            nt_store_row(buf.as_ptr(), dest.add(((c << n_log) + o0) * 2));
        }
    }
}

#[inline]
pub(crate) unsafe fn stripe_from_rows(
    rows: &[BmRow],
    stripe: *mut u8,
    o0: usize,
    u64_per_block: usize,
    useful_words: usize,
) {
    let base = (o0 / 8) * u64_per_block * 64;
    for (w, row) in rows.iter().enumerate().take(useful_words) {
        let out = unsafe { std::slice::from_raw_parts_mut(stripe.add(base + w * 64), 64) };
        transpose_8_u64s_to_64_bytes(row, out);
    }
}

#[inline(always)]
pub(crate) fn add_carry_parts_v(
    x: &[u32; BM_V],
    y: &[u32; BM_V],
) -> ([u32; BM_V], [u32; BM_V], [u32; BM_V], [u32; BM_V]) {
    const MASK_LO31: u32 = 0x7FFF_FFFF;
    let mut sum = [0u32; BM_V];
    let mut left = [0u32; BM_V];
    let mut right = [0u32; BM_V];
    let mut carry = [0u32; BM_V];
    for j in 0..BM_V {
        let s = x[j].wrapping_add(y[j]);
        let cin = s ^ x[j] ^ y[j];
        let l = (x[j] ^ cin) & MASK_LO31;
        let r = (y[j] ^ cin) & MASK_LO31;
        sum[j] = s;
        left[j] = l;
        right[j] = r;
        carry[j] = l & r;
    }
    (sum, left, right, carry)
}

pub(crate) fn drive_witness_batch_major<S: Sync, F>(
    inputs: &[S],
    padding: &S,
    n_blocks_log: usize,
    k_log: usize,
    useful_bits: usize,
    per_group: F,
) -> (Vec<F128>, Vec<F128>, Vec<F128>, Vec<u8>)
where
    F: Fn([&S; BM_V], &mut [BmRow], &mut [BmRow], &mut [BmRow]) + Sync + Send,
{
    use rayon::prelude::*;

    let n_total = 1usize << n_blocks_log;
    assert!(inputs.len() <= n_total);
    assert!(n_total >= BM_V);
    let u64_per_block = (1usize << k_log) / 64;
    let useful_chunks = useful_bits.div_ceil(128);
    let useful_words = useful_bits.div_ceil(64);
    let total_f128 = n_total * (u64_per_block / 2);

    let mut z = flock_core::scratch::take_f128(total_f128);
    let mut a = flock_core::scratch::take_f128(total_f128);
    let mut b = flock_core::scratch::take_f128(total_f128);
    let stripe = vec![0u8; n_total * u64_per_block * 8];
    let tail = useful_chunks << n_blocks_log;
    for buf in [&mut z, &mut a, &mut b] {
        buf[tail..]
            .par_chunks_mut(1 << 16)
            .for_each(|c| c.fill(F128::ZERO));
    }

    let (zp, ap, bp) = (
        SendPtr(z.as_mut_ptr() as *mut u64),
        SendPtr(a.as_mut_ptr() as *mut u64),
        SendPtr(b.as_mut_ptr() as *mut u64),
    );
    let sp = SendPtr(stripe.as_ptr() as *mut u64);
    let inputs_ref = inputs;

    (0..n_total / BM_V).into_par_iter().for_each_init(
        || {
            (
                vec![[0u64; BM_V]; u64_per_block],
                vec![[0u64; BM_V]; u64_per_block],
                vec![[0u64; BM_V]; u64_per_block],
            )
        },
        move |(rz, ra, rb), g| {
            rz[..useful_words].fill([0u64; BM_V]);
            ra[..useful_words].fill([0u64; BM_V]);
            rb[..useful_words].fill([0u64; BM_V]);
            let o0 = g * BM_V;
            let group: [&S; BM_V] =
                std::array::from_fn(|j| inputs_ref.get(o0 + j).unwrap_or(padding));
            per_group(group, rz, ra, rb);
            unsafe {
                flush_rows_nt(rz, zp.get(), o0, n_blocks_log, useful_chunks);
                flush_rows_nt(ra, ap.get(), o0, n_blocks_log, useful_chunks);
                flush_rows_nt(rb, bp.get(), o0, n_blocks_log, useful_chunks);
                stripe_from_rows(rz, sp.get() as *mut u8, o0, u64_per_block, useful_words);
            }
        },
    );

    (z, a, b, stripe)
}
