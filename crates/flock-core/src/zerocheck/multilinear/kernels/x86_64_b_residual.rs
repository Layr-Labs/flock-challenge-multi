// SPDX-License-Identifier: Apache-2.0 OR MIT
//! Residual-B siblings of the promoted b807 packed R2/C4 fast consumers.
//!
//! They retain the dense field/message schedule and promoted register-result ABI.
//! Only the B row loader changes: each 64-row batch is expanded into a local
//! aligned 512-byte scratch before the original prefold reads it. C4 keeps
//! the promoted direct ZMM8..11 return, without folded fa/fb memory caches. Dense
//! consumers and generic fallback paths remain unchanged in the parent file.
//! B prefetches are intentionally omitted here: dense logical offsets must
//! never be applied to the compact physical allocation. A prefetches remain.

use super::*;
use crate::zerocheck::b_residual::{CacheLine, ResidualView};

/// Exact residual-B twin of `round2_lookahead_chunk_baked_elide_x86`.
///
/// # Safety
/// The dense A extent, row/bake shape and canonical-window provenance must
/// meet the original fast consumer contract. The branded residual view must
/// cover `row_base..row_base+2*lo_size`. ISA features are cfg-gated.
#[target_feature(enable = "avx512f,avx512bw,avx512vbmi,avx512vbmi2,gfni,vpclmulqdq")]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn round2_lookahead_chunk_baked_elide_residual_x86(
    a_pkt: *const u8,
    b: ResidualView<'_>,
    row_base: usize,
    lo_size: usize,
    bk: &R2EqBake,
) -> [F128; 8] {
    use crate::field::gf2_128::x86_64::ghash_mul_x4;
    use core::arch::x86_64::*;
    debug_assert!(lo_size >= 128 && lo_size.is_multiple_of(128));
    debug_assert_eq!(row_base & 255, 0);

    unsafe {
        let mut acc = [WideGhashX4::zero(); 8];
        let mut fa_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let mut fb_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let fa = (*fa_store.as_mut_ptr()).0.as_mut_ptr();
        let fb = (*fb_store.as_mut_ptr()).0.as_mut_ptr();
        let mut b_dense: [CacheLine; 8] = core::array::from_fn(|_| CacheLine([0; 64]));
        let a_mats_ptr = bk.a_mats.as_ptr().cast::<u64>();
        let b_mats_slice = bk.b_mats.as_ptr();

        macro_rules! pf_quarter {
            ($g0:expr, $q:expr) => {{
                let next = ($g0 + 64 * ZC_PKT_PF_TILES) * 8;
                let l0 = 2 * ($q as usize);
                for l in l0..l0 + 2 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
            }};
        }

        macro_rules! ld_group {
            ($g:expr) => {{
                let g_off = 4 * ($g as usize);
                (
                    _mm512_loadu_si512(fa.add(g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fa.add(16 + g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fa.add(32 + g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fa.add(48 + g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fb.add(g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fb.add(16 + g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fb.add(32 + g_off).cast::<__m512i>()),
                    _mm512_loadu_si512(fb.add(48 + g_off).cast::<__m512i>()),
                )
            }};
        }

        macro_rules! accum1 {
            ($g0:expr, $grp:expr) => {{
                pf_quarter!($g0, $grp);
                let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = ld_group!($grp);
                acc[0].mul_acc(a1w, b1);
                acc[1].mul_acc(_mm512_xor_si512(a0w, a1w), _mm512_xor_si512(b0, b1));
                acc[2].mul_acc(a3w, b3);
                acc[3].mul_acc(_mm512_xor_si512(a2w, a3w), _mm512_xor_si512(b2, b3));
                acc[4].mul_acc(a2w, b2);
                let e_aw = _mm512_xor_si512(a0w, a2w);
                let e_b = _mm512_xor_si512(b0, b2);
                let o_aw = _mm512_xor_si512(a1w, a3w);
                let o_b = _mm512_xor_si512(b1, b3);
                acc[5].mul_acc(e_aw, e_b);
                acc[6].mul_acc(o_aw, o_b);
                acc[7].mul_acc(_mm512_xor_si512(e_aw, o_aw), _mm512_xor_si512(e_b, o_b));
            }};
        }

        macro_rules! accum2 {
            ($g0:expr, $grp0:expr, $grp1:expr) => {{
                pf_quarter!($g0, $grp0);
                let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = ld_group!($grp0);
                pf_quarter!($g0, $grp1);
                let (c0w, c1w, c2w, c3w, d0, d1, d2, d3) = ld_group!($grp1);
                acc[0].mul_acc2(a1w, b1, c1w, d1);
                acc[1].mul_acc2(
                    _mm512_xor_si512(a0w, a1w),
                    _mm512_xor_si512(b0, b1),
                    _mm512_xor_si512(c0w, c1w),
                    _mm512_xor_si512(d0, d1),
                );
                acc[2].mul_acc2(a3w, b3, c3w, d3);
                acc[3].mul_acc2(
                    _mm512_xor_si512(a2w, a3w),
                    _mm512_xor_si512(b2, b3),
                    _mm512_xor_si512(c2w, c3w),
                    _mm512_xor_si512(d2, d3),
                );
                acc[4].mul_acc2(a2w, b2, c2w, d2);
                let e_aw = _mm512_xor_si512(a0w, a2w);
                let e_b = _mm512_xor_si512(b0, b2);
                let o_aw = _mm512_xor_si512(a1w, a3w);
                let o_b = _mm512_xor_si512(b1, b3);
                let e_cw = _mm512_xor_si512(c0w, c2w);
                let e_d = _mm512_xor_si512(d0, d2);
                let o_cw = _mm512_xor_si512(c1w, c3w);
                let o_d = _mm512_xor_si512(d1, d3);
                acc[5].mul_acc2(e_aw, e_b, e_cw, e_d);
                acc[6].mul_acc2(o_aw, o_b, o_cw, o_d);
                acc[7].mul_acc2(
                    _mm512_xor_si512(e_aw, o_aw),
                    _mm512_xor_si512(e_b, o_b),
                    _mm512_xor_si512(e_cw, o_cw),
                    _mm512_xor_si512(e_d, o_d),
                );
            }};
        }

        let mut x_lo = 0;
        while x_lo + 128 <= lo_size {
            let batch_base = x_lo >> 5;
            // Batch 0 (g0 & 255 == 0): elide group 0
            {
                let g0 = row_base + 2 * x_lo;
                let bm = &(*b_mats_slice.add(batch_base)).0;
                b.expand64_rows_native(g0, &mut b_dense)
                    .expect("valid residual R2 batch");
                gfni_fold64_rows_tr_bcast_skip_group::<true>(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_tr_bcast_skip_group::<false>(
                    b_dense.as_ptr().cast::<u8>(),
                    bm.as_ptr(),
                    fb,
                    0,
                );
                pf_quarter!(g0, 0);
                #[cfg(test)]
                R2_CANON_ELIDE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                accum1!(g0, 1);
                accum2!(g0, 2, 3);
            }
            // Batch 1 (g0 & 255 == 64): full 4 groups
            {
                let g0 = row_base + 2 * (x_lo + 32);
                let bm = &(*b_mats_slice.add(batch_base + 1)).0;
                b.expand64_rows_native(g0, &mut b_dense)
                    .expect("valid residual R2 batch");
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_dense.as_ptr().cast::<u8>(), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
            }
            // Batch 2 (g0 & 255 == 128): full 4 groups
            {
                let g0 = row_base + 2 * (x_lo + 64);
                let bm = &(*b_mats_slice.add(batch_base + 2)).0;
                b.expand64_rows_native(g0, &mut b_dense)
                    .expect("valid residual R2 batch");
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_dense.as_ptr().cast::<u8>(), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
            }
            // Batch 3 (g0 & 255 == 192): elide group 3
            {
                let g0 = row_base + 2 * (x_lo + 96);
                let bm = &(*b_mats_slice.add(batch_base + 3)).0;
                b.expand64_rows_native(g0, &mut b_dense)
                    .expect("valid residual R2 batch");
                gfni_fold64_rows_tr_bcast_skip_group::<true>(a_pkt.add(g0 * 8), a_mats_ptr, fa, 3);
                gfni_fold64_rows_tr_bcast_skip_group::<false>(
                    b_dense.as_ptr().cast::<u8>(),
                    bm.as_ptr(),
                    fb,
                    3,
                );
                accum2!(g0, 0, 1);
                accum1!(g0, 2);
                pf_quarter!(g0, 3);
                #[cfg(test)]
                R2_CANON_ELIDE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
            }
            x_lo += 128;
        }

        let mut out = [F128::ZERO; 8];
        let lane_w = f128x4_loadu(bk.lane.as_ptr());
        for i in 0..8 {
            let scaled = ghash_mul_x4(lane_w, acc[i].reduce_lanes());
            let l = crate::field::gf2_128::x86_64::f128x4_extract(scaled);
            out[i] = l[0] + l[1] + l[2] + l[3];
        }
        out
    }
}

/// Exact residual-B twin of the promoted b807 C4 register-result reader.
/// Both A/B folds use the original preserving register-result helper.
///
/// # Safety
/// A/output/matrix/weight extents and layout must meet the original fast
/// consumer contract. The branded residual view must cover all input rows
/// `4*out_base..4*(out_base+2*lo_size)`. ISA features are cfg-gated.
#[target_feature(enable = "avx512f,avx512bw,avx512vbmi,avx512vbmi2,gfni,vpclmulqdq")]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold2_from_packed_lookahead_c4_lm_wtab_residual_x86<
    const NT_OUT: bool,
    const OUT_LM: bool,
>(
    a_pkt: *const u8,
    b: ResidualView<'_>,
    out_base: usize,
    a_out: &mut [F128],
    b_out: &mut [F128],
    lo_size: usize,
    cfold: &CFoldMats,
    wt: &[F128],
) -> [F128; 8] {
    use core::arch::x86_64::*;
    debug_assert!(lo_size.is_multiple_of(16));
    debug_assert_eq!(a_out.len(), 2 * lo_size);
    debug_assert_eq!(b_out.len(), 2 * lo_size);

    unsafe {
        let mut acc = [WideGhashX4::zero(); 8];
        let mut b_dense: [CacheLine; 8] = core::array::from_fn(|_| CacheLine([0; 64]));
        let a_out_ptr = a_out.as_mut_ptr();
        let b_out_ptr = b_out.as_mut_ptr();
        let wt_ptr = wt.as_ptr();

        macro_rules! step8_fast {
            ($x_expr:expr) => {{
                let x = $x_expr;
                let ol = 2 * x;
                let xg = out_base + ol;
                b.expand64_rows_native(4 * xg, &mut b_dense)
                    .expect("valid residual C4 batch");
                let [a0, a1, a2, a3] =
                    gfni_fold64_rows_c4_lm_registers(a_pkt.add(4 * xg * 8), cfold);
                let [b0, b1, b2, b3] =
                    gfni_fold64_rows_c4_lm_registers(b_dense.as_ptr().cast::<u8>(), cfold);
                let next = (4 * xg + 64 * ZC_PKT_PF_TILES) * 8;
                for l in 0..2 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
                for l in 2..4 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
                let ap = a_out_ptr.add(ol);
                let bp = b_out_ptr.add(ol);
                let (s0, s1, s2, s3, t0, t1, t2, t3) = if OUT_LM {
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                } else {
                    let [s0, s1, s2, s3] = transpose4_lanes(a0, a1, a2, a3);
                    let [t0, t1, t2, t3] = transpose4_lanes(b0, b1, b2, b3);
                    (s0, s1, s2, s3, t0, t1, t2, t3)
                };
                if NT_OUT {
                    stream_tile_as_xmm16(ap, s0, s1, s2, s3);
                    stream_tile_as_xmm16(bp, t0, t1, t2, t3);
                } else {
                    _mm512_storeu_si512(ap.cast::<__m512i>(), s0);
                    _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), s1);
                    _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), s2);
                    _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), s3);
                    _mm512_storeu_si512(bp.cast::<__m512i>(), t0);
                    _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), t1);
                    _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), t2);
                    _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), t3);
                }
                for l in 4..8 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
                let wp = wt_ptr.add(x) as *const __m512i;
                let w = _mm512_loadu_si512(wp);
                let w64 = _mm512_loadu_si512(wp.add(1));
                let a0w = crate::field::gf2_128::x86_64::ghash_mul_x4_split(a0, w, w64);
                let a1w = crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64);
                let a2w = crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64);
                let a3w = crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64);
                (a0w, a1w, a2w, a3w, b0, b1, b2, b3)
            }};
        }

        let mut x_lo = 0;
        while x_lo + 16 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step8_fast!(x_lo);
            let (c0w, c1w, c2w, c3w, d0, d1, d2, d3) = step8_fast!(x_lo + 8);
            acc[0].mul_acc2(a1w, b1, c1w, d1);
            acc[1].mul_acc2(
                _mm512_xor_si512(a0w, a1w),
                _mm512_xor_si512(b0, b1),
                _mm512_xor_si512(c0w, c1w),
                _mm512_xor_si512(d0, d1),
            );
            acc[2].mul_acc2(a3w, b3, c3w, d3);
            acc[3].mul_acc2(
                _mm512_xor_si512(a2w, a3w),
                _mm512_xor_si512(b2, b3),
                _mm512_xor_si512(c2w, c3w),
                _mm512_xor_si512(d2, d3),
            );
            acc[4].mul_acc2(a2w, b2, c2w, d2);
            let e_aw = _mm512_xor_si512(a0w, a2w);
            let e_b = _mm512_xor_si512(b0, b2);
            let o_aw = _mm512_xor_si512(a1w, a3w);
            let o_b = _mm512_xor_si512(b1, b3);
            let e_cw = _mm512_xor_si512(c0w, c2w);
            let e_d = _mm512_xor_si512(d0, d2);
            let o_cw = _mm512_xor_si512(c1w, c3w);
            let o_d = _mm512_xor_si512(d1, d3);
            acc[5].mul_acc2(e_aw, e_b, e_cw, e_d);
            acc[6].mul_acc2(o_aw, o_b, o_cw, o_d);
            acc[7].mul_acc2(
                _mm512_xor_si512(e_aw, o_aw),
                _mm512_xor_si512(e_b, o_b),
                _mm512_xor_si512(e_cw, o_cw),
                _mm512_xor_si512(e_d, o_d),
            );
            x_lo += 16;
        }

        if NT_OUT {
            _mm_sfence();
        }
        let mut out = [F128::ZERO; 8];
        for i in 0..8 {
            out[i] = acc[i].fold().reduce();
        }
        out
    }
}

#[cfg(test)]
mod tests {
    use super::super as kernels;
    use crate::field::F128;
    use crate::zerocheck::b_residual::{Builder, PLAN, ResidualB as EncodedB};

    struct Rng(u64);
    impl Rng {
        fn u64(&mut self) -> u64 {
            self.0 ^= self.0 << 13;
            self.0 ^= self.0 >> 7;
            self.0 ^= self.0 << 17;
            self.0
        }
        fn f(&mut self) -> F128 {
            F128::new(self.u64(), self.u64())
        }
    }
    fn inputs(blocks: usize, rng: &mut Rng) -> (Vec<u8>, Vec<u8>, EncodedB) {
        let a = (0..blocks * 2048).map(|_| rng.u64() as u8).collect();
        let mut b = vec![0; blocks * 2048];
        let mut builder = Builder::new(blocks).unwrap();
        for block in 0..blocks {
            let mut writer = builder.block(block).unwrap();
            let mut lines = [[0u8; 64]; 32];
            for l in 0..32 {
                for j in 0..64 {
                    lines[l][j] = if PLAN[l].variable_mask & (1u64 << j) == 0 {
                        PLAN[l].constants[j]
                    } else {
                        rng.u64() as u8
                    };
                }
                b[block * 2048 + l * 64..block * 2048 + (l + 1) * 64].copy_from_slice(&lines[l]);
            }
            for l in 2..30 {
                unsafe { writer.record_line_native(l, &lines[l], false).unwrap() };
            }
            writer.finish().unwrap();
        }
        (a, b, builder.finish().unwrap())
    }
    fn table(cols: &[F128; 64]) -> Vec<F128> {
        (0..2048)
            .map(|i| {
                let chunk = i / 256;
                let byte = i % 256;
                (0..8)
                    .filter(|b| byte & (1 << b) != 0)
                    .fold(F128::ZERO, |v, b| v + cols[chunk * 8 + b])
            })
            .collect()
    }
    fn row(bytes: &[u8], r: usize, cols: &[F128; 64]) -> F128 {
        let word = u64::from_le_bytes(bytes[r * 8..r * 8 + 8].try_into().unwrap());
        (0..64)
            .filter(|b| word & (1u64 << b) != 0)
            .fold(F128::ZERO, |v, b| v + cols[b])
    }
    fn accum(a: [F128; 4], b: [F128; 4]) -> [F128; 8] {
        let [a0, a1, a2, a3] = a;
        let [b0, b1, b2, b3] = b;
        [
            a1 * b1,
            (a0 + a1) * (b0 + b1),
            a3 * b3,
            (a2 + a3) * (b2 + b3),
            a2 * b2,
            (a0 + a2) * (b0 + b2),
            (a1 + a3) * (b1 + b3),
            (a0 + a1 + a2 + a3) * (b0 + b1 + b2 + b3),
        ]
    }

    #[test]
    fn consumer_r2_residual_matches_dense_and_scalar_message() {
        let mut rng = Rng(0x9c71_f4b1_90ee_51ad);
        let (a, b, residual) = inputs(64, &mut rng);
        for seed in 0..4 {
            let cols = core::array::from_fn(|_| rng.f());
            let t = table(&cols);
            for (row_base, lo_size) in [(0, 128), (256, 128), (768, 256), (1024, 1024)] {
                let aw: [F128; 4] = core::array::from_fn(|_| rng.f());
                let bw: Vec<F128> = (0..lo_size / 32).map(|_| rng.f()).collect();
                let lane = core::array::from_fn(|_| rng.f());
                let bake = kernels::R2EqBake {
                    a_mats: core::array::from_fn(|g| {
                        kernels::R2FoldMats(kernels::build_row_fold_mats_scaled(&t, aw[g]))
                    }),
                    b_mats: bw
                        .iter()
                        .map(|w| kernels::R2FoldMats(kernels::build_row_fold_mats_scaled(&t, *w)))
                        .collect(),
                    b_scale: bw.clone(),
                    lane,
                    canonical_elide: true,
                };
                let dense = unsafe {
                    kernels::round2_lookahead_chunk_baked_elide_x86(
                        a.as_ptr(),
                        b.as_ptr(),
                        row_base,
                        lo_size,
                        &bake,
                    )
                };
                let got = unsafe {
                    kernels::round2_lookahead_chunk_baked_elide_residual_x86(
                        a.as_ptr(),
                        residual.view(),
                        row_base,
                        lo_size,
                        &bake,
                    )
                };
                assert_eq!(got, dense, "dense seed={seed} base={row_base} lo={lo_size}");
                let mut scalar = [F128::ZERO; 8];
                for x in (0..lo_size).step_by(2) {
                    let r = row_base + 2 * x;
                    if r % 256 < 16 || r % 256 >= 240 {
                        continue;
                    }
                    let aa = core::array::from_fn(|k| row(&a, r + k, &cols) * aw[(r % 64) / 16]);
                    let bb = core::array::from_fn(|k| row(&b, r + k, &cols) * bw[x / 32]);
                    for (s, p) in scalar.iter_mut().zip(accum(aa, bb)) {
                        *s += p * lane[(x / 2) % 4];
                    }
                }
                assert_eq!(
                    got, scalar,
                    "scalar seed={seed} base={row_base} lo={lo_size}"
                );
            }
        }
    }

    fn c4_case<const NT: bool, const LM: bool>(
        a: &[u8],
        b: &[u8],
        residual: &EncodedB,
        cols: &[F128; 64],
        cfold: &kernels::CFoldMats,
        coeffs: [F128; 4],
        out_base: usize,
        lo_size: usize,
        wt: &[F128],
        weights: &[F128],
        offset: usize,
    ) {
        let guard = F128::new(0xabcd_ef01_2345_6789, 0x8796_5a4b_3c2d_1e0f);
        let n = 2 * lo_size;
        let mut ad = vec![guard; n + offset + 4];
        let mut bd = ad.clone();
        let mut ar = ad.clone();
        let mut br = ad.clone();
        let dense = unsafe {
            kernels::fold2_from_packed_lookahead_c4_lm_wtab_x86::<NT, LM>(
                a.as_ptr(),
                b.as_ptr(),
                out_base,
                &mut ad[offset..offset + n],
                &mut bd[offset..offset + n],
                lo_size,
                cfold,
                wt,
            )
        };
        let got = unsafe {
            kernels::fold2_from_packed_lookahead_c4_lm_wtab_residual_x86::<NT, LM>(
                a.as_ptr(),
                residual.view(),
                out_base,
                &mut ar[offset..offset + n],
                &mut br[offset..offset + n],
                lo_size,
                cfold,
                wt,
            )
        };
        assert_eq!(
            (&ar, &br, got),
            (&ad, &bd, dense),
            "dense NT={NT} LM={LM} base={out_base} lo={lo_size} offset={offset}"
        );
        let scalar_output = |bytes: &[u8], x: usize| -> F128 {
            (0..4).fold(F128::ZERO, |v, k| {
                v + coeffs[k] * row(bytes, 4 * (out_base + x) + k, cols)
            })
        };
        for i in 0..n {
            let logical = if LM {
                (i / 16) * 16 + (i % 16) / 4 + 4 * (i % 4)
            } else {
                i
            };
            assert_eq!(
                ar[offset + i],
                scalar_output(a, logical),
                "scalar A i={i} LM={LM}"
            );
            assert_eq!(
                br[offset + i],
                scalar_output(b, logical),
                "scalar B i={i} LM={LM}"
            );
        }
        let mut scalar = [F128::ZERO; 8];
        for x in (0..lo_size).step_by(2) {
            let aa = core::array::from_fn(|k| scalar_output(a, 2 * x + k) * weights[x / 2]);
            let bb = core::array::from_fn(|k| scalar_output(b, 2 * x + k));
            for (s, p) in scalar.iter_mut().zip(accum(aa, bb)) {
                *s += p;
            }
        }
        assert_eq!(got, scalar, "scalar message NT={NT} LM={LM}");
        assert!(
            ar[..offset]
                .iter()
                .chain(ar[offset + n..].iter())
                .all(|v| *v == guard)
        );
        assert!(
            br[..offset]
                .iter()
                .chain(br[offset + n..].iter())
                .all(|v| *v == guard)
        );
    }

    #[test]
    fn consumer_c4_residual_matches_dense_scalar_outputs_and_messages() {
        let mut rng = Rng(0x604c_4f1d_2153_7c81);
        let (a, b, residual) = inputs(64, &mut rng);
        for _seed in 0..3 {
            let cols = core::array::from_fn(|_| rng.f());
            let t = table(&cols);
            let p = rng.f();
            let q = rng.f();
            let one = F128::ONE;
            let coeffs = [(one + p) * (one + q), p * (one + q), (one + p) * q, p * q];
            let cfold = kernels::build_cfold_mats(&t, coeffs);
            for (out_base, lo_size, offset) in
                [(0, 16, 0), (16, 32, 1), (128, 64, 2), (1024, 1024, 3)]
            {
                let weights: Vec<_> = (0..lo_size / 2).map(|_| rng.f()).collect();
                // One weight applies to four message lanes per eight-lo group.
                let mut wt = Vec::new();
                for g in 0..lo_size / 8 {
                    for lane in 0..4 {
                        wt.push(weights[4 * g + lane]);
                    }
                    for lane in 0..4 {
                        wt.push(weights[4 * g + lane] * F128::new(0, 1));
                    }
                }
                c4_case::<false, false>(
                    &a, &b, &residual, &cols, &cfold, coeffs, out_base, lo_size, &wt, &weights,
                    offset,
                );
                c4_case::<false, true>(
                    &a, &b, &residual, &cols, &cfold, coeffs, out_base, lo_size, &wt, &weights,
                    offset,
                );
                c4_case::<true, false>(
                    &a, &b, &residual, &cols, &cfold, coeffs, out_base, lo_size, &wt, &weights,
                    offset,
                );
                c4_case::<true, true>(
                    &a, &b, &residual, &cols, &cfold, coeffs, out_base, lo_size, &wt, &weights,
                    offset,
                );
            }
        }
    }
}
