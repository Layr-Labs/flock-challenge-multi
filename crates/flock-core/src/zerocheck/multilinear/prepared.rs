//! Prepared octa consumers. The assembly bodies were checked independently
//! against scalar GF(2^128) oracles; these drivers retain the current message,
//! eq split, canonical-window deltas and unweighted OUT_LM output contracts.
use super::*;
use crate::field::gf2_128::x86_64::{f128x4_extract, ghash_mul_x4_split};
use crate::zerocheck::prepared_octa::{BLOCK_BYTES, PREPARED_B_MASKS};
use core::arch::x86_64::*;
use rayon::prelude::*;

core::arch::global_asm!(include_str!("prepared_r2.S"), include_str!("prepared_c4.S"));
unsafe extern "C" {
    fn flock_r2_prepared_prefold();
    fn flock_c4_two_bank_result();
}

#[repr(C, align(64))]
struct R2FoldMats([u64; 128]);
#[repr(C, align(64))]
struct FoldCache([F128; 64]);
struct DirectMats {
    a: Vec<[R2FoldMats; 2]>,
    b: [R2FoldMats; 2],
    masks: [u8; 32],
}
#[repr(C, align(64))]
struct Bank([[u64; 8]; 64]);
struct PreparedMats {
    a: Bank,
    b: Vec<Bank>,
    masks: [u8; 32],
}
#[repr(C, align(64))]
struct Stage([__m512i; 32]);

#[inline(always)]
fn bits(x: F128) -> u128 {
    x.lo as u128 | ((x.hi as u128) << 64)
}

#[inline(always)]
fn matrices(cols: &[F128; 64], scale: F128, prepared: bool) -> R2FoldMats {
    let sc: [F128; 64] = std::array::from_fn(|i| cols[i] * scale);
    let mut m = [0u64; 128];
    for j in 0..8 {
        for k in 0..16 {
            for bit in 0..8 {
                let mut row = 0;
                for b in 0..8 {
                    row |= (((bits(sc[8 * j + b]) >> (8 * k + bit)) & 1) as u64) << b;
                }
                m[16 * j + k] |= row << (8 * (7 - bit));
            }
        }
    }
    if prepared {
        let old = m;
        for j in 0..8 {
            for k in 0..16 {
                m[16 * j + k] = 0;
                for t in 0..8 {
                    if t & j == t {
                        m[16 * j + k] ^= old[16 * t + k];
                    }
                }
            }
        }
    }
    R2FoldMats(m)
}

#[inline(always)]
unsafe fn prefold(input: *const u8, mats: *const *const u64, out: *mut F128) {
    core::arch::asm!("call {leaf}",leaf=sym flock_r2_prepared_prefold,in("rdi")input,in("rsi")mats,in("rdx")out,lateout("rax")_,
out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,out("zmm4")_,out("zmm5")_,out("zmm6")_,out("zmm7")_);
}

#[inline(never)]
unsafe fn prepared_round2(
    a: *const u8,
    b: *const u8,
    nblocks: usize,
    m: &DirectMats,
    block_weight: &[F128],
) -> [F128; 8] {
    let mut output = [F128::ZERO; 8];
    for octa in 0..nblocks / 8 {
        let mut acc = [[WideGhashX4::zero(); 8]; 2];
        let mut fa = core::mem::MaybeUninit::<FoldCache>::uninit();
        let mut fb = core::mem::MaybeUninit::<FoldCache>::uninit();
        for w in 2..30 {
            let pa = std::array::from_fn::<_, 8, _>(|row| m.a[w - 2][row / 4].0.as_ptr());
            let pb = std::array::from_fn::<_, 8, _>(|row| {
                m.b[usize::from(m.masks[w] & (1 << row) != 0)].0.as_ptr()
            });
            let off = (32 * octa + w) * 512;
            prefold(a.add(off), pa.as_ptr(), fa.as_mut_ptr().cast());
            prefold(b.add(off), pb.as_ptr(), fb.as_mut_ptr().cast());
            for l in 0..8 {
                _mm_prefetch(a.wrapping_add(off + 1536 + 64 * l).cast(), _MM_HINT_T0);
                _mm_prefetch(b.wrapping_add(off + 1536 + 64 * l).cast(), _MM_HINT_T0);
            }
            for half in 0..2 {
                let aa = fa.as_ptr().cast::<__m512i>();
                let bb = fb.as_ptr().cast::<__m512i>();
                let a0 = _mm512_loadu_si512(aa.add(4 * half));
                let a1 = _mm512_loadu_si512(aa.add(4 * half + 1));
                let a2 = _mm512_loadu_si512(aa.add(4 * half + 2));
                let a3 = _mm512_loadu_si512(aa.add(4 * half + 3));
                let c0 = _mm512_loadu_si512(aa.add(8 + 4 * half));
                let c1 = _mm512_loadu_si512(aa.add(8 + 4 * half + 1));
                let c2 = _mm512_loadu_si512(aa.add(8 + 4 * half + 2));
                let c3 = _mm512_loadu_si512(aa.add(8 + 4 * half + 3));
                let b0 = _mm512_loadu_si512(bb.add(4 * half));
                let b1 = _mm512_loadu_si512(bb.add(4 * half + 1));
                let b2 = _mm512_loadu_si512(bb.add(4 * half + 2));
                let b3 = _mm512_loadu_si512(bb.add(4 * half + 3));
                let d0 = _mm512_loadu_si512(bb.add(8 + 4 * half));
                let d1 = _mm512_loadu_si512(bb.add(8 + 4 * half + 1));
                let d2 = _mm512_loadu_si512(bb.add(8 + 4 * half + 2));
                let d3 = _mm512_loadu_si512(bb.add(8 + 4 * half + 3));
                let e = |x, y| _mm512_xor_si512(x, y);
                let ac = &mut acc[half];
                ac[0].mul_acc2(a1, b1, c1, d1);
                ac[1].mul_acc2(e(a0, a1), e(b0, b1), e(c0, c1), e(d0, d1));
                ac[2].mul_acc2(a3, b3, c3, d3);
                ac[3].mul_acc2(e(a2, a3), e(b2, b3), e(c2, c3), e(d2, d3));
                ac[4].mul_acc2(a2, b2, c2, d2);
                ac[5].mul_acc2(e(a0, a2), e(b0, b2), e(c0, c2), e(d0, d2));
                ac[6].mul_acc2(e(a1, a3), e(b1, b3), e(c1, c3), e(d1, d3));
                ac[7].mul_acc2(
                    e(e(a0, a2), e(a1, a3)),
                    e(e(b0, b2), e(b1, b3)),
                    e(e(c0, c2), e(c1, c3)),
                    e(e(d0, d2), e(d1, d3)),
                );
            }
        }
        for half in 0..2 {
            let weight = f128x4_loadu(block_weight.as_ptr().add(8 * octa + 4 * half));
            for i in 0..8 {
                let values = f128x4_extract(ghash_mul_x4(weight, acc[half][i].reduce_lanes()));
                for value in values {
                    output[i] += value;
                }
            }
        }
    }
    output
}

#[inline(always)]
unsafe fn direct_leaf(input: *const u8, m0: *const u64, m1: *const u64) -> [__m512i; 4] {
    let a: __m512i;
    let b: __m512i;
    let c: __m512i;
    let d: __m512i;
    core::arch::asm!("call {leaf}",leaf=sym flock_c4_two_bank_result,in("rdi")input,in("rsi")m0,in("rdx")m1,lateout("rax")_,
 out("zmm8")a,out("zmm9")b,out("zmm10")c,out("zmm11")d,
out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,out("zmm4")_,out("zmm5")_,out("zmm6")_,out("zmm7")_);
    [a, b, c, d]
}

#[inline(always)]
unsafe fn transpose4_lanes(
    o0: core::arch::x86_64::__m512i,
    o1: core::arch::x86_64::__m512i,
    o2: core::arch::x86_64::__m512i,
    o3: core::arch::x86_64::__m512i,
) -> [core::arch::x86_64::__m512i; 4] {
    use core::arch::x86_64::*;
    // SAFETY: register-only; features per the cfg above.
    unsafe {
        let q0 = _mm512_shuffle_i64x2::<0x44>(o0, o1);
        let q1 = _mm512_shuffle_i64x2::<0xEE>(o0, o1);
        let q2 = _mm512_shuffle_i64x2::<0x44>(o2, o3);
        let q3 = _mm512_shuffle_i64x2::<0xEE>(o2, o3);
        [
            _mm512_shuffle_i64x2::<0x88>(q0, q2),
            _mm512_shuffle_i64x2::<0xDD>(q0, q2),
            _mm512_shuffle_i64x2::<0x88>(q1, q3),
            _mm512_shuffle_i64x2::<0xDD>(q1, q3),
        ]
    }
}

#[inline(always)]
unsafe fn publish(stage: *const __m512i, out: *mut F128, octa: usize, tile: usize) {
    for half in 0..2 {
        for residue in 0..4 {
            let a = _mm512_load_si512(stage.add(2 * residue + half));
            let b = _mm512_load_si512(stage.add(2 * (4 + residue) + half));
            let c = _mm512_load_si512(stage.add(2 * (8 + residue) + half));
            let d = _mm512_load_si512(stage.add(2 * (12 + residue) + half));
            let values = transpose4_lanes(a, b, c, d);
            for block in 0..4 {
                _mm512_stream_si512(
                    out.add(64 * (8 * octa + 4 * half + block) + 16 * tile + 4 * residue)
                        .cast(),
                    values[block],
                );
            }
        }
    }
}

#[inline(always)]
unsafe fn read_group(
    a: *const __m512i,
    b: *const __m512i,
    pair: usize,
    half: usize,
    wp: *const F128,
) -> [__m512i; 8] {
    let w = f128x4_loadu(wp);
    let w64 = f128x4_loadu(wp.add(4));
    let aa = std::array::from_fn::<_, 4, _>(|i| {
        ghash_mul_x4_split(_mm512_load_si512(a.add(8 * pair + 2 * i + half)), w, w64)
    });
    let bb = std::array::from_fn::<_, 4, _>(|i| _mm512_load_si512(b.add(8 * pair + 2 * i + half)));
    [aa[0], aa[1], aa[2], aa[3], bb[0], bb[1], bb[2], bb[3]]
}

#[inline(never)]
unsafe fn prepared_c4(
    a: *const u8,
    b: *const u8,
    nblocks: usize,
    ao: *mut F128,
    bo: *mut F128,
    m: &PreparedMats,
    wt: &[F128],
) -> [F128; 8] {
    let mut acc = [WideGhashX4::zero(); 8];
    let mut sa = core::mem::MaybeUninit::<Stage>::uninit();
    let mut sb = core::mem::MaybeUninit::<Stage>::uninit();
    let ap = sa.as_mut_ptr().cast::<__m512i>();
    let bp = sb.as_mut_ptr().cast::<__m512i>();
    let am = m.a.0.as_ptr().cast();
    for octa in 0..nblocks / 8 {
        for tile in 0..4 {
            for local in 0..8 {
                let w = 8 * tile + local;
                let off = (32 * octa + w) * 512;
                let mask = m.masks[w];
                let av = direct_leaf(a.add(off), am, am);
                let bv = direct_leaf(
                    b.add(off),
                    m.b[(mask & 15) as usize].0.as_ptr().cast(),
                    m.b[(mask >> 4) as usize].0.as_ptr().cast(),
                );
                for i in 0..4 {
                    _mm512_store_si512(ap.add(4 * local + i), av[i]);
                    _mm512_store_si512(bp.add(4 * local + i), bv[i]);
                }
                for l in 0..8 {
                    _mm_prefetch(a.wrapping_add(off + 1536 + 64 * l).cast(), _MM_HINT_T0);
                    _mm_prefetch(b.wrapping_add(off + 1536 + 64 * l).cast(), _MM_HINT_T0);
                }
            }
            for pair in [0usize, 2] {
                for half in 0..2 {
                    let wp = wt
                        .as_ptr()
                        .add(((16 * octa + 4 * tile + pair) * 2 + half) * 8);
                    let [a0, a1, a2, a3, b0, b1, b2, b3] = read_group(ap, bp, pair, half, wp);
                    let [c0, c1, c2, c3, d0, d1, d2, d3] =
                        read_group(ap, bp, pair + 1, half, wp.add(16));
                    let e = |x, y| _mm512_xor_si512(x, y);
                    acc[0].mul_acc2(a1, b1, c1, d1);
                    acc[1].mul_acc2(e(a0, a1), e(b0, b1), e(c0, c1), e(d0, d1));
                    acc[2].mul_acc2(a3, b3, c3, d3);
                    acc[3].mul_acc2(e(a2, a3), e(b2, b3), e(c2, c3), e(d2, d3));
                    acc[4].mul_acc2(a2, b2, c2, d2);
                    acc[5].mul_acc2(e(a0, a2), e(b0, b2), e(c0, c2), e(d0, d2));
                    acc[6].mul_acc2(e(a1, a3), e(b1, b3), e(c1, c3), e(d1, d3));
                    acc[7].mul_acc2(
                        e(e(a0, a2), e(a1, a3)),
                        e(e(b0, b2), e(b1, b3)),
                        e(e(c0, c2), e(c1, c3)),
                        e(e(d0, d2), e(d1, d3)),
                    );
                }
            }
            publish(ap, ao, octa, tile);
            publish(bp, bo, octa, tile);
        }
    }
    _mm_sfence();
    std::array::from_fn(|i| acc[i].fold().reduce())
}

fn columns(table: &UniSkipFoldTable) -> [F128; 64] {
    assert_eq!(table.n_chunks, 8);
    assert_eq!(table.data.len(), 8 * 256);
    std::array::from_fn(|i| table.data[(i / 8) * 256 + (1 << (i % 8))])
}

fn sum_chunks(a: [F128; 8], b: [F128; 8]) -> [F128; 8] {
    std::array::from_fn(|i| a[i] + b[i])
}

fn weighted_chunk(value: [F128; 8], weight: F128) -> [F128; 8] {
    std::array::from_fn(|i| value[i] * weight)
}

/// Complete round-two message and round-three lookahead. Only complete octa
/// chunks with the canonical-window delta available may use this entry.
pub(crate) fn round2(
    a: &[u8],
    b: &[u8],
    m: usize,
    table: &UniSkipFoldTable,
    challenges: &[F128],
    padding: &PaddingSpec,
    eq: &SplitEqGhash,
    canon: &[F128],
) -> (F128, F128, Round3Lookahead) {
    assert_eq!(a.len(), (1usize << m) / 8);
    assert_eq!(b.len(), a.len());
    assert_eq!(challenges.len(), m - 6);
    assert_eq!(padding.k_log, 14);
    assert_eq!(padding.useful_bits_per_block, 15_409);
    assert_eq!(canon.len(), CANON_ROWS * 64);
    assert!(eq.n_lo >= 10);
    assert_eq!(eq.lo.len(), 1usize << eq.n_lo);
    assert_eq!(eq.hi.len(), 1usize << eq.n_hi);
    assert_eq!(eq.n_lo + eq.n_hi + 1, challenges.len());
    assert_ne!(challenges[1], F128::ZERO);
    let nblocks = eq.lo.len() / 128;
    let chunk_bytes = nblocks * BLOCK_BYTES;
    assert_eq!(chunk_bytes * eq.hi.len(), a.len());
    let cols = columns(table);
    let low_challenges = &challenges[1..1 + eq.n_lo];
    let within = build_eq(&low_challenges[..7]);
    let block_weights = build_eq(&low_challenges[7..]);
    assert_eq!(block_weights.len(), nblocks);
    let mats = DirectMats {
        a: (2..30)
            .map(|w| std::array::from_fn(|g| matrices(&cols, within[4 * w + 2 * g + 1], true)))
            .collect(),
        b: [
            matrices(&cols, F128::ONE, false),
            matrices(&cols, F128::ONE, true),
        ],
        masks: PREPARED_B_MASKS,
    };
    let sums = a
        .par_chunks(chunk_bytes)
        .zip(b.par_chunks(chunk_bytes))
        .enumerate()
        .map(|(hi, (aa, bb))| {
            // Every chunk starts on an octa boundary; the local block weights
            // are the low tensor and the caller's high tensor stays outside.
            let values = unsafe {
                prepared_round2(aa.as_ptr(), bb.as_ptr(), nblocks, &mats, &block_weights)
            };
            weighted_chunk(values, eq.hi[hi])
        })
        .reduce(|| [F128::ZERO; 8], sum_chunks);
    let (kappa, parity_inv) = lookahead_inv_factors(challenges[1]);
    let agg = std::array::from_fn(|i| sums[i + 2]);
    let mut g1 = kappa * sums[0] + agg[0];
    let mut ginf = kappa * sums[1] + agg[1];
    let mut lookahead = lookahead_from_odd_weighted(&agg, parity_inv);
    let (d1, di, dc) = round2_canonical_window_deltas(table, challenges, canon);
    g1 += d1;
    ginf += di;
    for (value, delta) in lookahead.c.iter_mut().zip(dc) {
        *value += delta;
    }
    (challenges[0] * g1, ginf, lookahead)
}

/// Build the raw four-residue map once, then invert the representation with
/// XORs. Field multiplication is performed only for the 4 * 64 input columns.
fn c4_banks(cols: &[F128; 64], coeff: [F128; 4]) -> PreparedMats {
    let scaled: [[F128; 64]; 4] =
        std::array::from_fn(|a| std::array::from_fn(|i| cols[i] * coeff[a]));
    let mut raw = [[0u64; 8]; 64];
    for a in 0..4 {
        for j in 0..8 {
            for k in 0..16 {
                for bit in 0..8 {
                    let mut row = 0;
                    for b in 0..8 {
                        row |= (((bits(scaled[a][8 * j + b]) >> (8 * k + bit)) & 1) as u64) << b;
                    }
                    raw[32 * (k / 8) + 8 * a + j][k % 8] |= row << (8 * (7 - bit));
                }
            }
        }
    }
    let transform = |mask: u8| {
        let mut result = raw;
        for a in 0..4 {
            if mask & (1 << a) != 0 {
                for j in 0..8 {
                    for k in 0..16 {
                        let dst = 32 * (k / 8) + 8 * a + j;
                        result[dst][k % 8] = 0;
                        for t in 0..8 {
                            if t & j == t {
                                result[dst][k % 8] ^= raw[32 * (k / 8) + 8 * a + t][k % 8];
                            }
                        }
                    }
                }
            }
        }
        Bank(result)
    };
    PreparedMats {
        a: transform(15),
        b: (0..16).map(transform).collect(),
        masks: PREPARED_B_MASKS,
    }
}

fn c4_weights(eq_lo: &[F128], nblocks: usize) -> Vec<F128> {
    assert_eq!(eq_lo.len(), 32 * nblocks);
    let original = build_w_pair_table(eq_lo);
    let mut prepared = Vec::with_capacity(original.len());
    for octa in 0..nblocks / 8 {
        for pair in 0..16 {
            for half in 0..2 {
                for companion in [0, 4] {
                    for lane in 0..4 {
                        let q = 16 * (8 * octa + 4 * half + lane) + pair;
                        prepared.push(original[(q / 4) * 8 + q % 4 + companion]);
                    }
                }
            }
        }
    }
    assert_eq!(prepared.len(), original.len());
    prepared
}

/// Complete packed rounds-three/four pass. Outputs retain the existing
/// unweighted OUT_LM layout and are published in full, aligned NT cache lines.
pub(crate) fn round34(
    a: &[u8],
    b: &[u8],
    m: usize,
    table: &UniSkipFoldTable,
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho1: F128,
    rho2: F128,
    r_next: &[F128],
    eq_lo: &[F128],
    eq_hi: &[F128],
) -> (F128, F128, Round3Lookahead) {
    assert_eq!(a.len(), (1usize << m) / 8);
    assert_eq!(b.len(), a.len());
    assert_eq!(a_out.len(), (1usize << (m - 6)) / 4);
    assert_eq!(b_out.len(), a_out.len());
    assert_eq!(r_next.len(), m - 8);
    assert_ne!(r_next[1], F128::ZERO);
    assert!(!eq_lo.is_empty() && eq_lo.len().is_multiple_of(256));
    assert_eq!(2 * eq_lo.len() * eq_hi.len(), a_out.len());
    assert_eq!(a_out.as_ptr() as usize % 64, 0);
    assert_eq!(b_out.as_ptr() as usize % 64, 0);
    let nblocks = eq_lo.len() / 32;
    let chunk_bytes = nblocks * BLOCK_BYTES;
    let chunk_out = nblocks * 64;
    let one = F128::ONE;
    let mats = c4_banks(
        &columns(table),
        [
            (one + rho1) * (one + rho2),
            rho1 * (one + rho2),
            (one + rho1) * rho2,
            rho1 * rho2,
        ],
    );
    let weights = c4_weights(eq_lo, nblocks);
    let sums = a
        .par_chunks(chunk_bytes)
        .zip(b.par_chunks(chunk_bytes))
        .zip(a_out.par_chunks_mut(chunk_out))
        .zip(b_out.par_chunks_mut(chunk_out))
        .enumerate()
        .map(|(hi, (((aa, bb), ao), bo))| {
            let values = unsafe {
                prepared_c4(
                    aa.as_ptr(),
                    bb.as_ptr(),
                    nblocks,
                    ao.as_mut_ptr(),
                    bo.as_mut_ptr(),
                    &mats,
                    &weights,
                )
            };
            weighted_chunk(values, eq_hi[hi])
        })
        .reduce(|| [F128::ZERO; 8], sum_chunks);
    let (kappa, parity_inv) = lookahead_inv_factors(r_next[1]);
    let agg = std::array::from_fn(|i| sums[i + 2]);
    (
        r_next[0] * (kappa * sums[0] + agg[0]),
        kappa * sums[1] + agg[1],
        lookahead_from_odd_weighted(&agg, parity_inv),
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::zerocheck::prepared_octa::{
        PREPARED_R2_HITS, PREPARED_R34_HITS, PackedAbLayout, PreparedAbSide, prepare_in_place,
        round2_with_layout, round34_with_layout,
    };
    use std::sync::atomic::Ordering;

    #[repr(C, align(64))]
    #[derive(Clone, Debug)]
    struct Line([F128; 4]);

    fn random(state: &mut u64) -> u64 {
        *state ^= *state << 13;
        *state ^= *state >> 7;
        *state ^= *state << 17;
        *state
    }
    fn field(state: &mut u64) -> F128 {
        F128 {
            lo: random(state),
            hi: random(state),
        }
    }
    fn fields(lines: &mut [Line]) -> &mut [F128] {
        unsafe { core::slice::from_raw_parts_mut(lines.as_mut_ptr().cast(), lines.len() * 4) }
    }

    #[test]
    fn prepared_consumers_round2_restores_nonzero_canonical_windows() {
        let mut seed = 0x9531_cba7_u64;
        for (nblocks, n_hi) in [(8usize, 0usize), (32, 2), (64, 3)] {
            let m = 14 + nblocks.trailing_zeros() as usize;
            let table = UniSkipFoldTable::new(6, field(&mut seed));
            let r: Vec<F128> = (0..m - 6).map(|_| field(&mut seed)).collect();
            let mut a: Vec<u8> = (0..nblocks * BLOCK_BYTES)
                .map(|_| random(&mut seed) as u8)
                .collect();
            let mut b: Vec<u8> = (0..a.len()).map(|_| random(&mut seed) as u8).collect();
            for block in 0..nblocks {
                let off = block * BLOCK_BYTES;
                b[off..off + 128].fill(255);
                b[off + 1920..off + BLOCK_BYTES].fill(0);
                b[off + 1920..off + 1928].copy_from_slice(&0x0001_ffff_ffff_ffffu64.to_le_bytes());
                let word = u64::from_le_bytes(a[off + 1920..off + 1928].try_into().unwrap())
                    & 0x0001_ffff_ffff_ffff;
                a[off + 1920..off + 1928].copy_from_slice(&word.to_le_bytes());
                a[off + 1928..off + BLOCK_BYTES].fill(0);
            }
            let weights = build_eq(&r[8..]);
            let mut canon = vec![F128::ZERO; CANON_ROWS * 64];
            for (slot, row) in (0..16).chain([240usize]).enumerate() {
                for (block, weight) in weights.iter().enumerate() {
                    let off = block * BLOCK_BYTES + row * 8;
                    let word = u64::from_le_bytes(a[off..off + 8].try_into().unwrap());
                    for bit in 0..64 {
                        if (word >> bit) & 1 != 0 {
                            canon[slot * 64 + bit] += *weight;
                        }
                    }
                }
            }
            assert!(canon.iter().any(|&v| v != F128::ZERO));
            let eq = SplitEqGhash::with_n_hi(&r[1..], n_hi);
            let padding = PaddingSpec {
                k_log: 14,
                useful_bits_per_block: 15_409,
            };
            let expected = uni_skip_round_pair_lookahead_nomat_packed_padded_with_eq(
                &a,
                &b,
                m,
                6,
                &table,
                &r,
                &padding,
                Some(&eq),
                None,
            );
            prepare_in_place(PreparedAbSide::A, &mut a);
            prepare_in_place(PreparedAbSide::B, &mut b);
            let actual = round2(&a, &b, m, &table, &r, &padding, &eq, &canon);
            assert_eq!(
                actual, expected,
                "nonzero canonical windows, blocks={nblocks}"
            );
        }
    }

    #[test]
    fn prepared_consumers_messages_outputs_and_chunk_boundaries() {
        let mut seed = 0xc412_5613_71dau64;
        for trial in 0..4 {
            let nblocks: usize = if trial == 0 { 8 } else { 64 };
            let m = 14 + nblocks.trailing_zeros() as usize;
            let cols: [F128; 64] = std::array::from_fn(|_| field(&mut seed));
            let table = UniSkipFoldTable::from_weights(8, &cols);
            let mut r: Vec<F128> = (0..m - 6).map(|_| field(&mut seed)).collect();
            if trial == 2 {
                for (i, x) in r.iter_mut().enumerate().skip(2) {
                    if i != 3 && i % 3 == 0 {
                        *x = F128::ZERO;
                    } else if i % 3 == 1 {
                        *x = F128::ONE;
                    }
                }
            }
            let mut a: Vec<u8> = (0..BLOCK_BYTES * nblocks)
                .map(|_| random(&mut seed) as u8)
                .collect();
            let mut b: Vec<u8> = (0..a.len()).map(|_| random(&mut seed) as u8).collect();
            if trial == 0 {
                a.fill(0);
            }
            if trial == 1 {
                b.fill(255);
            }
            // R2 omits exactly the four canonical/dead windows. Their actual
            // contribution is zero here. Trial 3 independently exercises the
            // delta interface with nonzero synthetic canonical rows.
            for block in 0..nblocks {
                for w in [0, 1, 30, 31] {
                    a[block * BLOCK_BYTES + w * 64..block * BLOCK_BYTES + (w + 1) * 64].fill(0);
                }
                b[block * BLOCK_BYTES + 31 * 64..(block + 1) * BLOCK_BYTES].fill(0);
            }
            let mut ap = a.clone();
            let mut bp = b.clone();
            prepare_in_place(PreparedAbSide::A, &mut ap);
            prepare_in_place(PreparedAbSide::B, &mut bp);
            let untouched = (ap.clone(), bp.clone());
            let n_hi = if trial == 0 { 0 } else { 2 };
            let eq = SplitEqGhash::with_n_hi(&r[1..], n_hi);
            let canon: Vec<F128> = (0..CANON_ROWS * 64)
                .map(|_| {
                    if trial == 3 {
                        field(&mut seed)
                    } else {
                        F128::ZERO
                    }
                })
                .collect();
            let padding = PaddingSpec {
                k_log: 14,
                useful_bits_per_block: 15_409,
            };
            let expected = uni_skip_round_pair_lookahead_nomat_packed_padded_with_eq(
                &a,
                &b,
                m,
                6,
                &table,
                &r,
                &padding,
                Some(&eq),
                Some(&canon),
            );
            let before = PREPARED_R2_HITS.load(Ordering::Relaxed);
            let actual = round2_with_layout(
                PackedAbLayout::PreparedOctaV1,
                &ap,
                &bp,
                m,
                6,
                &table,
                &r,
                &padding,
                Some(&eq),
                Some(&canon),
            );
            assert!(PREPARED_R2_HITS.load(Ordering::Relaxed) > before);
            if trial != 3 {
                let before = PREPARED_R2_HITS.load(Ordering::Relaxed);
                let fallback = round2_with_layout(
                    PackedAbLayout::PreparedOctaV1,
                    &ap,
                    &bp,
                    m,
                    6,
                    &table,
                    &r,
                    &padding,
                    Some(&eq),
                    None,
                );
                assert_eq!(fallback, expected, "R2 canonical fallback trial={trial}");
                assert_eq!(PREPARED_R2_HITS.load(Ordering::Relaxed), before);
            }
            assert_eq!(actual.0, expected.0, "R2 m1 trial={trial}");
            assert_eq!(actual.1, expected.1, "R2 minf trial={trial}");
            assert_eq!(actual.2.c, expected.2.c, "R2 lookahead trial={trial}");

            let rho = if trial == 2 {
                [F128::ZERO, F128::ONE]
            } else if trial == 3 {
                [F128::ONE, F128::ZERO]
            } else {
                [field(&mut seed), field(&mut seed)]
            };
            let mut r_next = r[2..].to_vec();
            r_next[0] = F128::ONE;
            let low = marginalize_eq_low2(&eq.lo);
            let output_len = 64 * nblocks;
            let halo = F128 {
                lo: 0x3139,
                hi: 0x8441,
            };
            let mut ra = vec![Line([halo; 4]); output_len / 4 + 4];
            let mut rb = ra.clone();
            let mut pa = ra.clone();
            let mut pb = ra.clone();
            let base = if trial % 2 == 0 { 4 } else { 8 };
            let expect = fold2_from_packed_and_round_pair_lookahead_into_with_eq(
                &a,
                &b,
                m,
                6,
                &table,
                &padding,
                &mut fields(&mut ra)[base..base + output_len],
                &mut fields(&mut rb)[base..base + output_len],
                rho[0],
                rho[1],
                &r_next,
                Some((&low, &eq.hi)),
                true,
            );
            let before = PREPARED_R34_HITS.load(Ordering::Relaxed);
            let actual = round34_with_layout(
                PackedAbLayout::PreparedOctaV1,
                &ap,
                &bp,
                m,
                6,
                &table,
                &padding,
                &mut fields(&mut pa)[base..base + output_len],
                &mut fields(&mut pb)[base..base + output_len],
                rho[0],
                rho[1],
                &r_next,
                Some((&low, &eq.hi)),
                true,
            );
            assert!(PREPARED_R34_HITS.load(Ordering::Relaxed) > before);
            assert_eq!(actual.0, expect.0, "C4 m1 trial={trial}");
            assert_eq!(actual.1, expect.1, "C4 minf trial={trial}");
            assert_eq!(actual.2.c, expect.2.c, "C4 lookahead trial={trial}");
            assert_eq!(
                fields(&mut pa),
                fields(&mut ra),
                "C4 A and halo trial={trial}"
            );
            assert_eq!(
                fields(&mut pb),
                fields(&mut rb),
                "C4 B and halo trial={trial}"
            );
            // A late rejection of OUT_LM must decode the original owners
            // before invoking the conventional consumer. Check full arrays
            // and their adjacent canaries, not only the protocol messages.
            let mut fa = vec![Line([halo; 4]); output_len / 4 + 4];
            let mut fb = fa.clone();
            let mut ca = fa.clone();
            let mut cb = fa.clone();
            let fallback_expected = fold2_from_packed_and_round_pair_lookahead_into_with_eq(
                &a,
                &b,
                m,
                6,
                &table,
                &padding,
                &mut fields(&mut ca)[base..base + output_len],
                &mut fields(&mut cb)[base..base + output_len],
                rho[0],
                rho[1],
                &r_next,
                Some((&low, &eq.hi)),
                false,
            );
            let before = PREPARED_R34_HITS.load(Ordering::Relaxed);
            let fallback_actual = round34_with_layout(
                PackedAbLayout::PreparedOctaV1,
                &ap,
                &bp,
                m,
                6,
                &table,
                &padding,
                &mut fields(&mut fa)[base..base + output_len],
                &mut fields(&mut fb)[base..base + output_len],
                rho[0],
                rho[1],
                &r_next,
                Some((&low, &eq.hi)),
                false,
            );
            assert_eq!(PREPARED_R34_HITS.load(Ordering::Relaxed), before);
            assert_eq!(
                fallback_actual, fallback_expected,
                "C4 fallback messages trial={trial}"
            );
            assert_eq!(
                fields(&mut fa),
                fields(&mut ca),
                "C4 fallback A and halo trial={trial}"
            );
            assert_eq!(
                fields(&mut fb),
                fields(&mut cb),
                "C4 fallback B and halo trial={trial}"
            );
            assert_eq!((ap, bp), untouched);
        }
    }
}

/// Match the existing CPU routes before choosing a private packed layout.
pub(crate) fn route_enabled() -> bool {
    zc_gfni_enabled()
        && cfold_bake_enabled()
        && round2_canonical_elide_enabled()
        && zc_lane_major_handoff_on()
        && kernels::x86_64::zc_r2_bake_route_ok(4096)
        && kernels::x86_64::zc_r2_unroll16_enabled()
        && kernels::x86_64::zc_fold_nt_enabled()
        && kernels::x86_64::fold2_packed_c4_lm_wtab_route_ok(
            true,
            kernels::x86_64::zc_c4_lm_enabled(),
            1024,
            true,
            kernels::x86_64::zc_wtab_enabled(),
        )
}
