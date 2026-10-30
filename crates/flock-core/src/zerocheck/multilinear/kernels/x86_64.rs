use crate::field::gf2_128::x86_64::{WideGhashX4, f128x4_loadu};
use crate::field::{F128, F256Unreduced};

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline(always)]
pub(crate) unsafe fn fold_round2_pair_x86_unchecked_8(
    table_data: *const F128,
    a0_bytes: *const u8,
    a1_bytes: *const u8,
    b0_bytes: *const u8,
    b1_bytes: *const u8,
) -> [F128; 4] {
    use core::arch::x86_64::*;

    unsafe {
        let rows = [a0_bytes, a1_bytes, b0_bytes, b1_bytes];
        let mut acc = [_mm_setzero_si128(); 4];
        for chunk in 0..8 {
            let table_chunk = table_data.add(chunk * 256);
            for lane in 0..4 {
                let entry = table_chunk.add(*rows[lane].add(chunk) as usize);
                acc[lane] = _mm_xor_si128(acc[lane], _mm_load_si128(entry.cast::<__m128i>()));
            }
        }
        acc.map(|value| core::mem::transmute::<__m128i, F128>(value))
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(crate) unsafe fn fold_and_message_x86_avx512(
    a_in: &[F128],
    b_in: &[F128],
    a_out: &mut [F128],
    b_out: &mut [F128],
    r_fold: F128,
    eq_lo: &[F128],
) -> (F128, F128) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4, ghash_shift64_x4};
    use core::arch::x86_64::*;

    debug_assert_eq!(a_in.len(), 2 * a_out.len());
    debug_assert_eq!(b_in.len(), 2 * b_out.len());
    debug_assert_eq!(a_out.len(), 2 * eq_lo.len());

    #[inline(always)]
    unsafe fn fold_x4(
        src: *const F128,
        r: __m512i,
        r64: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
        split: bool,
    ) -> __m512i {
        use crate::field::gf2_128::x86_64::{ghash_mul_x4, ghash_mul_x4_split};
        use core::arch::x86_64::*;

        unsafe {
            let lo = _mm512_loadu_si512(src.cast::<__m512i>());
            let hi = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
            let even = _mm512_permutex2var_epi64(lo, even_idx, hi);
            let odd = _mm512_permutex2var_epi64(lo, odd_idx, hi);
            let diff = _mm512_xor_si512(even, odd);
            let prod = if split {
                ghash_mul_x4_split(diff, r, r64)
            } else {
                ghash_mul_x4(r, diff)
            };
            _mm512_xor_si512(even, prod)
        }
    }

    unsafe {
        let r = _mm512_broadcast_i32x4(_mm_set_epi64x(r_fold.hi as i64, r_fold.lo as i64));
        let split = zc_fold_split_enabled();
        let r64 = if split { ghash_shift64_x4(r) } else { r };
        let even_idx = _mm512_set_epi64(13, 12, 9, 8, 5, 4, 1, 0);
        let odd_idx = _mm512_set_epi64(15, 14, 11, 10, 7, 6, 3, 2);
        let mut p1_wide = WideGhashX4::zero();
        let mut pinf_wide = WideGhashX4::zero();
        let mut p1_tail = F256Unreduced::ZERO;
        let mut pinf_tail = F256Unreduced::ZERO;
        let mut x_lo = 0;

        if luna_foldmsg_reorder_enabled() {
            while x_lo + 4 <= eq_lo.len() {
                let output = 2 * x_lo;
                let a_lo =
                    fold_x4(a_in.as_ptr().add(2 * output), r, r64, even_idx, odd_idx, split);
                let a_hi = fold_x4(
                    a_in.as_ptr().add(2 * (output + 4)),
                    r,
                    r64,
                    even_idx,
                    odd_idx,
                    split,
                );
                let b_lo =
                    fold_x4(b_in.as_ptr().add(2 * output), r, r64, even_idx, odd_idx, split);
                let b_hi = fold_x4(
                    b_in.as_ptr().add(2 * (output + 4)),
                    r,
                    r64,
                    even_idx,
                    odd_idx,
                    split,
                );

                let a0 = _mm512_permutex2var_epi64(a_lo, even_idx, a_hi);
                let a1 = _mm512_permutex2var_epi64(a_lo, odd_idx, a_hi);
                let b0 = _mm512_permutex2var_epi64(b_lo, even_idx, b_hi);
                let b1 = _mm512_permutex2var_epi64(b_lo, odd_idx, b_hi);
                let g1 = ghash_mul_x4(a1, b1);
                let g_inf = ghash_mul_x4(_mm512_xor_si512(a0, a1), _mm512_xor_si512(b0, b1));
                let eq = f128x4_loadu(eq_lo.as_ptr().add(x_lo));
                p1_wide.mul_acc(eq, g1);
                pinf_wide.mul_acc(eq, g_inf);

                _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_lo);
                _mm512_storeu_si512(a_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), a_hi);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_lo);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), b_hi);

                x_lo += 4;
            }
        } else {
            while x_lo + 4 <= eq_lo.len() {
                let output = 2 * x_lo;
                let a_lo =
                    fold_x4(a_in.as_ptr().add(2 * output), r, r64, even_idx, odd_idx, split);
                let a_hi = fold_x4(
                    a_in.as_ptr().add(2 * (output + 4)),
                    r,
                    r64,
                    even_idx,
                    odd_idx,
                    split,
                );
                let b_lo =
                    fold_x4(b_in.as_ptr().add(2 * output), r, r64, even_idx, odd_idx, split);
                let b_hi = fold_x4(
                    b_in.as_ptr().add(2 * (output + 4)),
                    r,
                    r64,
                    even_idx,
                    odd_idx,
                    split,
                );

                _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_lo);
                _mm512_storeu_si512(a_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), a_hi);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_lo);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), b_hi);

                let a0 = _mm512_permutex2var_epi64(a_lo, even_idx, a_hi);
                let a1 = _mm512_permutex2var_epi64(a_lo, odd_idx, a_hi);
                let b0 = _mm512_permutex2var_epi64(b_lo, even_idx, b_hi);
                let b1 = _mm512_permutex2var_epi64(b_lo, odd_idx, b_hi);
                let g1 = ghash_mul_x4(a1, b1);
                let g_inf = ghash_mul_x4(_mm512_xor_si512(a0, a1), _mm512_xor_si512(b0, b1));
                let eq = f128x4_loadu(eq_lo.as_ptr().add(x_lo));
                p1_wide.mul_acc(eq, g1);
                pinf_wide.mul_acc(eq, g_inf);
                x_lo += 4;
            }
        }

        if x_lo < eq_lo.len() {
            debug_assert_eq!(eq_lo.len() - x_lo, 2);
            let output = 2 * x_lo;
            let a_folded = fold_x4(
                a_in.as_ptr().add(2 * output),
                r,
                r64,
                even_idx,
                odd_idx,
                split,
            );
            let b_folded = fold_x4(
                b_in.as_ptr().add(2 * output),
                r,
                r64,
                even_idx,
                odd_idx,
                split,
            );

            if luna_foldmsg_reorder_enabled() {
                let a0_0 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<0>(a_folded),
                );
                let a1_0 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<1>(a_folded),
                );
                let b0_0 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<0>(b_folded),
                );
                let b1_0 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<1>(b_folded),
                );
                let eq_0 = eq_lo[x_lo];
                p1_tail ^= eq_0.mul_unreduced(a1_0 * b1_0);
                pinf_tail ^= eq_0.mul_unreduced((a0_0 + a1_0) * (b0_0 + b1_0));

                let a0_1 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<2>(a_folded),
                );
                let a1_1 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<3>(a_folded),
                );
                let b0_1 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<2>(b_folded),
                );
                let b1_1 = core::mem::transmute::<__m128i, F128>(
                    _mm512_extracti32x4_epi32::<3>(b_folded),
                );
                let eq_1 = eq_lo[x_lo + 1];
                p1_tail ^= eq_1.mul_unreduced(a1_1 * b1_1);
                pinf_tail ^= eq_1.mul_unreduced((a0_1 + a1_1) * (b0_1 + b1_1));

                _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_folded);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_folded);
            } else {
                _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_folded);
                _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_folded);

                for lane in 0..2 {
                    let o = output + 2 * lane;
                    let a0 = a_out[o];
                    let a1 = a_out[o + 1];
                    let b0 = b_out[o];
                    let b1 = b_out[o + 1];
                    let eq = eq_lo[x_lo + lane];
                    p1_tail ^= eq.mul_unreduced(a1 * b1);
                    pinf_tail ^= eq.mul_unreduced((a0 + a1) * (b0 + b1));
                }
            }
        }

        p1_tail ^= p1_wide.fold();
        pinf_tail ^= pinf_wide.fold();
        (p1_tail.reduce(), pinf_tail.reduce())
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[inline]
pub(crate) fn round2_baked_elide_route_ok(
    has_mats: bool,
    lo_size: usize,
    bake: Option<&R2EqBake>,
) -> bool {
    has_mats
        && lo_size >= 128
        && lo_size.is_multiple_of(128)
        && zc_r2_unroll16_enabled()
        && zc_pkt_pf_enabled()
        && zc_pkt_pf_far_enabled()
        && zc_pkt_pf_spread_enabled()
        && bake.is_some_and(|bk| bk.canonical_elide)
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
pub(crate) unsafe fn round2_lookahead_chunk_baked_elide_x86(
    a_pkt: *const u8,
    b_pkt: *const u8,
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
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
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
            {
                let g0 = row_base + 2 * x_lo;
                let bm = &(*b_mats_slice.add(batch_base)).0;
                gfni_fold64_rows_tr_bcast_skip_group::<true>(
                    a_pkt.add(g0 * 8),
                    a_mats_ptr,
                    fa,
                    0,
                );
                gfni_fold64_rows_tr_bcast_skip_group::<false>(
                    b_pkt.add(g0 * 8),
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
            {
                let g0 = row_base + 2 * (x_lo + 32);
                let bm = &(*b_mats_slice.add(batch_base + 1)).0;
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_pkt.add(g0 * 8), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
            }
            {
                let g0 = row_base + 2 * (x_lo + 64);
                let bm = &(*b_mats_slice.add(batch_base + 2)).0;
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_pkt.add(g0 * 8), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
            }
            {
                let g0 = row_base + 2 * (x_lo + 96);
                let bm = &(*b_mats_slice.add(batch_base + 3)).0;
                gfni_fold64_rows_tr_bcast_skip_group::<true>(
                    a_pkt.add(g0 * 8),
                    a_mats_ptr,
                    fa,
                    3,
                );
                gfni_fold64_rows_tr_bcast_skip_group::<false>(
                    b_pkt.add(g0 * 8),
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
        let lane_w64 = crate::field::gf2_128::x86_64::ghash_shift64_x4(lane_w);
        for i in 0..8 {
            let scaled = crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                acc[i].reduce_lanes(),
                lane_w,
                lane_w64,
            );
            let l = crate::field::gf2_128::x86_64::f128x4_extract(scaled);
            out[i] = l[0] + l[1] + l[2] + l[3];
        }
        out
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn round2_lookahead_chunk_x86_avx512<const WRITE: bool, const BAKE: bool>(
    table_data: *const F128,
    mats: Option<&[u64; 128]>,
    a_pkt: *const u8,
    b_pkt: *const u8,
    row_base: usize,
    a_chunk: &mut [F128],
    b_chunk: &mut [F128],
    eq_lo: &[F128],
    pair_idx_base: usize,
    pair_in_block_mask: usize,
    useful_pairs_inclusive: usize,
    wtab: Option<&[F128]>,
    bake: Option<&R2EqBake>,
) -> [F128; 8] {
    #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
    if !WRITE
        && BAKE
        && (pair_idx_base & 127) == 0
        && (row_base & 255) == 0
        && round2_baked_elide_route_ok(mats.is_some(), eq_lo.len(), bake)
        && let Some(bk) = bake
    {
        return unsafe {
            round2_lookahead_chunk_baked_elide_x86(
                a_pkt,
                b_pkt,
                row_base,
                eq_lo.len(),
                bk,
            )
        };
    }
    unsafe {
        round2_lookahead_chunk_general_x86_avx512::<WRITE, BAKE>(
            table_data,
            mats,
            a_pkt,
            b_pkt,
            row_base,
            a_chunk,
            b_chunk,
            eq_lo,
            pair_idx_base,
            pair_in_block_mask,
            useful_pairs_inclusive,
            wtab,
            bake,
        )
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
unsafe fn round2_lookahead_chunk_general_x86_avx512<const WRITE: bool, const BAKE: bool>(
    table_data: *const F128,
    mats: Option<&[u64; 128]>,
    a_pkt: *const u8,
    b_pkt: *const u8,
    row_base: usize,
    a_chunk: &mut [F128],
    b_chunk: &mut [F128],
    eq_lo: &[F128],
    pair_idx_base: usize,
    pair_in_block_mask: usize,
    useful_pairs_inclusive: usize,
    wtab: Option<&[F128]>,
    bake: Option<&R2EqBake>,
) -> [F128; 8] {
    use crate::field::gf2_128::x86_64::ghash_mul_x4;
    use core::arch::x86_64::*;

    let lo_size = eq_lo.len();
    debug_assert!(!BAKE || (!WRITE && bake.is_some() && lo_size.is_multiple_of(32)));
    debug_assert!(!WRITE || a_chunk.len() == 2 * lo_size);
    debug_assert!(!WRITE || b_chunk.len() == 2 * lo_size);
    debug_assert!(lo_size.is_multiple_of(2));

    unsafe {
        let odd_idx = _mm512_set_epi64(15, 14, 11, 10, 7, 6, 3, 2);
        let mut acc = [WideGhashX4::zero(); 8];
        let wsplit = zc_wsplit_enabled();
        let mut tail = [F256Unreduced::ZERO; 8];
        let mut x_lo = 0;
        const B_ONES_BLOCK_PAIRS: usize = 128;
        const B_SPARSE_PAIR: usize = 120;
        const B_SPECIAL_ONES: u8 = 0;
        const B_SPECIAL_SPARSE: u8 = 1;
        const B_SPECIAL_NONE: u8 = 2;
        let canon_elide = BAKE && bake.is_some_and(|bk| bk.canonical_elide);
        let b_ones_on = zc_b_ones_enabled() || canon_elide;
        let b_sparse_on = zc_b_sparse_enabled() || canon_elide;
        let pair_in_b_block = pair_idx_base & (B_ONES_BLOCK_PAIRS - 1);
        let (mut b_special_head, mut b_special_kind) = match (b_ones_on, b_sparse_on) {
            (true, true) if pair_in_b_block == 0 => (0, B_SPECIAL_ONES),
            (true, true) if pair_in_b_block <= B_SPARSE_PAIR => {
                (B_SPARSE_PAIR - pair_in_b_block, B_SPECIAL_SPARSE)
            }
            (true, true) => (B_ONES_BLOCK_PAIRS - pair_in_b_block, B_SPECIAL_ONES),
            (true, false) => (
                (B_ONES_BLOCK_PAIRS - pair_in_b_block) & (B_ONES_BLOCK_PAIRS - 1),
                B_SPECIAL_ONES,
            ),
            (false, true) => (
                (B_SPARSE_PAIR + B_ONES_BLOCK_PAIRS - pair_in_b_block)
                    & (B_ONES_BLOCK_PAIRS - 1),
                B_SPECIAL_SPARSE,
            ),
            (false, false) => (usize::MAX, B_SPECIAL_NONE),
        };
        let use_batch = cfg!(all(target_feature = "avx512vbmi", target_feature = "gfni"))
            && mats.is_some()
            && lo_size >= 32
            && lo_size.is_multiple_of(32);
        let regfold_on = zc_regfold_enabled();
        let mut fa_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let mut fb_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let fa = &mut (*fa_store.as_mut_ptr()).0;
        let fb = &mut (*fb_store.as_mut_ptr()).0;
        let pf_tiles = if zc_pkt_pf_far_enabled() {
            ZC_PKT_PF_TILES
        } else {
            1
        };
        let pf_on = zc_pkt_pf_enabled();
        let pf_spread = zc_pkt_pf_spread_enabled();

        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let tr_emit = !WRITE
            && use_batch
            && lo_size.is_multiple_of(8)
            && zc_regfold_enabled()
            && zc_r2_tr_enabled();
        #[cfg(not(all(target_feature = "avx512vbmi", target_feature = "gfni")))]
        let tr_emit = false;
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let tr_bcast = tr_emit && zc_r2_bcast_enabled();
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let b_canonical_values = if tr_bcast && !canon_elide && zc_b_canonical_prefold_enabled() {
            let mut values = [F128::ZERO; 2];
            for bit in 0..64 {
                let basis = *table_data.add((bit / 8) * 256 + (1 << (bit % 8)));
                values[0] += basis;
                if bit < 49 {
                    values[1] += basis;
                }
            }
            Some(values)
        } else {
            None
        };
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let b_canonical_direct = tr_bcast && zc_b_canonical_direct_enabled();
        let mut b_direct_pending = false;
        #[allow(unused_mut)]
        let mut b_direct_folded = F128::ZERO;
        #[allow(unused_mut)]
        let mut b_batch_scale = F128::ONE;
        macro_rules! spread_pf {
            ($x:expr) => {{
            #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
            if use_batch && pf_on && pf_spread {
                let tile_base = row_base + 2 * ($x & !31);
                let next = (tile_base + 64 * pf_tiles) * 8;
                let l0 = ($x & 31) >> 2;
                for l in l0..l0 + 2 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
            }
            }};
        }
        macro_rules! load_window {
            ($x:expr, $special_now:expr) => {{
            if use_batch && regfold_on {
                let r0 = 2 * ($x % 32);
                if tr_emit {
                    let g = r0 / 4;
                    let ld = |base: *const F128, k: usize| {
                        _mm512_loadu_si512(base.add(16 * k + g).cast::<__m512i>())
                    };
                    let (a0, a1, a2, a3) = (
                        ld(fa.as_ptr(), 0),
                        ld(fa.as_ptr(), 1),
                        ld(fa.as_ptr(), 2),
                        ld(fa.as_ptr(), 3),
                    );
                    let (b0, b1, b2, b3) = if $special_now && b_direct_pending {
                        let value = _mm512_broadcast_i32x4(_mm_set_epi64x(
                            b_direct_folded.hi as i64,
                            b_direct_folded.lo as i64,
                        ));
                        if b_special_kind == B_SPECIAL_ONES {
                            (value, value, value, value)
                        } else {
                            let zero = _mm512_setzero_si512();
                            (_mm512_maskz_mov_epi64(0x03, value), zero, zero, zero)
                        }
                    } else {
                        (
                            ld(fb.as_ptr(), 0),
                            ld(fb.as_ptr(), 1),
                            ld(fb.as_ptr(), 2),
                            ld(fb.as_ptr(), 3),
                        )
                    };
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                } else {
                    let fap = fa.as_ptr().add(r0).cast::<__m512i>();
                    let fbp = fb.as_ptr().add(r0).cast::<__m512i>();
                    let za = [
                        _mm512_loadu_si512(fap),
                        _mm512_loadu_si512(fap.add(1)),
                        _mm512_loadu_si512(fap.add(2)),
                        _mm512_loadu_si512(fap.add(3)),
                    ];
                    let zb = [
                        _mm512_loadu_si512(fbp),
                        _mm512_loadu_si512(fbp.add(1)),
                        _mm512_loadu_si512(fbp.add(2)),
                        _mm512_loadu_si512(fbp.add(3)),
                    ];
                    if WRITE {
                        let ac = a_chunk.as_mut_ptr().add(2 * $x).cast::<__m512i>();
                        let bc = b_chunk.as_mut_ptr().add(2 * $x).cast::<__m512i>();
                        for i in 0..4 {
                            _mm512_storeu_si512(ac.add(i), za[i]);
                            _mm512_storeu_si512(bc.add(i), zb[i]);
                        }
                    }
                    let [a0, a1, a2, a3] = transpose4_lanes(za[0], za[1], za[2], za[3]);
                    let [b0, b1, b2, b3] = transpose4_lanes(zb[0], zb[1], zb[2], zb[3]);
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                }
            } else {
                let mut a = [[F128::ZERO; 4]; 4];
                let mut b = [[F128::ZERO; 4]; 4];
                for lane in 0..4 {
                    for half in 0..2 {
                        let pair = $x + 2 * lane + half;
                        let x0l = 2 * pair;
                        let x1l = x0l + 1;
                        if ((pair_idx_base + pair) & pair_in_block_mask) >= useful_pairs_inclusive {
                            if WRITE {
                                a_chunk[x0l] = F128::ZERO;
                                a_chunk[x1l] = F128::ZERO;
                                b_chunk[x0l] = F128::ZERO;
                                b_chunk[x1l] = F128::ZERO;
                            }
                            continue;
                        }
                        let x0g = row_base + x0l;
                        let x1g = x0g + 1;
                        let folded = if use_batch {
                            let r = 2 * (pair % 32);
                            [fa[r], fa[r + 1], fb[r], fb[r + 1]]
                        } else {
                            fold_round2_pair_x86_unchecked_8(
                                table_data,
                                a_pkt.add(x0g * 8),
                                a_pkt.add(x1g * 8),
                                b_pkt.add(x0g * 8),
                                b_pkt.add(x1g * 8),
                            )
                        };
                        a[2 * half][lane] = folded[0];
                        a[2 * half + 1][lane] = folded[1];
                        b[2 * half][lane] = folded[2];
                        b[2 * half + 1][lane] = folded[3];
                        if WRITE {
                            a_chunk[x0l] = folded[0];
                            a_chunk[x1l] = folded[1];
                            b_chunk[x0l] = folded[2];
                            b_chunk[x1l] = folded[3];
                        }
                    }
                }
                (
                    f128x4_loadu(a[0].as_ptr()),
                    f128x4_loadu(a[1].as_ptr()),
                    f128x4_loadu(a[2].as_ptr()),
                    f128x4_loadu(a[3].as_ptr()),
                    f128x4_loadu(b[0].as_ptr()),
                    f128x4_loadu(b[1].as_ptr()),
                    f128x4_loadu(b[2].as_ptr()),
                    f128x4_loadu(b[3].as_ptr()),
                )
            }
            }};
        }
        macro_rules! eq_weights {
            ($x:expr, $a0:expr, $a1:expr, $a2:expr, $a3:expr) => {{
            if BAKE {
                ($a0, $a1, $a2, $a3)
            } else if let Some(wt) = wtab {
                let wp = wt.as_ptr().add($x) as *const __m512i;
                let w = _mm512_loadu_si512(wp);
                let w64 = _mm512_loadu_si512(wp.add(1));
                (
                    crate::field::gf2_128::x86_64::ghash_mul_x4_split($a0, w, w64),
                    crate::field::gf2_128::x86_64::ghash_mul_x4_split($a1, w, w64),
                    crate::field::gf2_128::x86_64::ghash_mul_x4_split($a2, w, w64),
                    crate::field::gf2_128::x86_64::ghash_mul_x4_split($a3, w, w64),
                )
            } else {
                let e_lo = f128x4_loadu(eq_lo.as_ptr().add($x));
                let e_hi = f128x4_loadu(eq_lo.as_ptr().add($x + 4));
                let w = _mm512_permutex2var_epi64(e_lo, odd_idx, e_hi);
                if wsplit {
                    let w64 = crate::field::gf2_128::x86_64::ghash_shift64_x4(w);
                    (
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split($a0, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split($a1, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split($a2, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split($a3, w, w64),
                    )
                } else {
                    (
                        ghash_mul_x4(w, $a0),
                        ghash_mul_x4(w, $a1),
                        ghash_mul_x4(w, $a2),
                        ghash_mul_x4(w, $a3),
                    )
                }
            }
            }};
        }
        let unroll16 = zc_r2_unroll16_enabled();
        while x_lo + 8 <= lo_size {
            #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
            if use_batch && x_lo.is_multiple_of(32) {
                b_direct_pending = false;
                let m = mats.unwrap();
                let g0 = row_base + 2 * x_lo;
                let dead = 0u8;
                let _ = (pair_in_block_mask, useful_pairs_inclusive);
                if tr_bcast {
                    let bm: &[u64; 128] = match (BAKE, bake) {
                        (true, Some(bk)) => {
                            match (canon_elide, g0 & 255) {
                                (true, 0) => gfni_fold64_rows_tr_bcast_skip_group::<true>(
                                    a_pkt.add(g0 * 8),
                                    bk.a_mats.as_ptr().cast::<u64>(),
                                    fa.as_mut_ptr(),
                                    0,
                                ),
                                (true, 192) => gfni_fold64_rows_tr_bcast_skip_group::<true>(
                                    a_pkt.add(g0 * 8),
                                    bk.a_mats.as_ptr().cast::<u64>(),
                                    fa.as_mut_ptr(),
                                    3,
                                ),
                                _ => gfni_fold64_rows_masked_tr_bcast4(
                                    a_pkt.add(g0 * 8),
                                    bk.a_mats.as_ptr().cast::<u64>(),
                                    fa.as_mut_ptr(),
                                    dead,
                                ),
                            }
                            b_batch_scale = bk.b_scale[x_lo >> 5];
                            &bk.b_mats[x_lo >> 5].0
                        }
                        _ => {
                            gfni_fold64_rows_masked_tr_bcast(
                                a_pkt.add(g0 * 8),
                                m,
                                fa.as_mut_ptr(),
                                dead,
                            );
                            m
                        }
                    };
                    match (b_canonical_values.as_ref(), g0 & 255) {
                        (_, 0) if canon_elide => gfni_fold64_rows_tr_bcast_skip_group::<false>(
                            b_pkt.add(g0 * 8),
                            bm.as_ptr(),
                            fb.as_mut_ptr(),
                            0,
                        ),
                        (_, 192) if canon_elide => gfni_fold64_rows_tr_bcast_skip_group::<false>(
                            b_pkt.add(g0 * 8),
                            bm.as_ptr(),
                            fb.as_mut_ptr(),
                            3,
                        ),
                        (Some(values), 0) if b_ones_on => {
                            let folded = if BAKE {
                                b_batch_scale * values[0]
                            } else {
                                values[0]
                            };
                            if b_canonical_direct
                                && b_special_head == x_lo
                                && b_special_kind == B_SPECIAL_ONES
                            {
                                b_direct_pending = gfni_fold64_rows_tr_bcast_b_canonical_impl::<false>(
                                    b_pkt.add(g0 * 8),
                                    bm,
                                    fb.as_mut_ptr(),
                                    0,
                                    folded,
                                );
                                b_direct_folded = folded;
                            } else {
                                gfni_fold64_rows_tr_bcast_b_canonical(
                                    b_pkt.add(g0 * 8),
                                    bm,
                                    fb.as_mut_ptr(),
                                    0,
                                    folded,
                                );
                            }
                        }
                        (Some(values), 192) if b_sparse_on => {
                            let folded = if BAKE {
                                b_batch_scale * values[1]
                            } else {
                                values[1]
                            };
                            if b_canonical_direct
                                && b_special_head == x_lo + 24
                                && b_special_kind == B_SPECIAL_SPARSE
                            {
                                b_direct_pending = gfni_fold64_rows_tr_bcast_b_canonical_impl::<false>(
                                    b_pkt.add(g0 * 8),
                                    bm,
                                    fb.as_mut_ptr(),
                                    3,
                                    folded,
                                );
                                b_direct_folded = folded;
                            } else {
                                gfni_fold64_rows_tr_bcast_b_canonical(
                                    b_pkt.add(g0 * 8),
                                    bm,
                                    fb.as_mut_ptr(),
                                    3,
                                    folded,
                                );
                            }
                        }
                        _ => gfni_fold64_rows_masked_tr_bcast(
                            b_pkt.add(g0 * 8),
                            bm,
                            fb.as_mut_ptr(),
                            dead,
                        ),
                    }
                } else if tr_emit {
                    gfni_fold64_rows_masked_tr(a_pkt.add(g0 * 8), m, fa.as_mut_ptr(), dead);
                    gfni_fold64_rows_masked_tr(b_pkt.add(g0 * 8), m, fb.as_mut_ptr(), dead);
                } else {
                    gfni_fold64_rows_masked(a_pkt.add(g0 * 8), m, fa.as_mut_ptr(), dead);
                    gfni_fold64_rows_masked(b_pkt.add(g0 * 8), m, fb.as_mut_ptr(), dead);
                }
                if pf_on && !pf_spread {
                    let next = (g0 + 64 * pf_tiles) * 8;
                    for l in 0..8 {
                        _mm_prefetch(
                            a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                        _mm_prefetch(
                            b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                    }
                }
            }
            spread_pf!(x_lo);
            let b_special_now = x_lo == b_special_head;
            if canon_elide && b_special_now {
                #[cfg(test)]
                R2_CANON_ELIDE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                b_direct_pending = false;
                if b_special_kind == B_SPECIAL_ONES {
                    b_special_head = b_special_head.wrapping_add(B_SPARSE_PAIR);
                    b_special_kind = B_SPECIAL_SPARSE;
                } else {
                    b_special_head =
                        b_special_head.wrapping_add(B_ONES_BLOCK_PAIRS - B_SPARSE_PAIR);
                    b_special_kind = B_SPECIAL_ONES;
                }
                x_lo += 8;
                continue;
            }
            let (a0, a1, a2, a3, b0, b1, b2, b3) = load_window!(x_lo, b_special_now);
            if b_special_now {
                let b_direct = b_direct_pending;
                b_direct_pending = false;
                let special_kind = b_special_kind;
                if b_ones_on && b_sparse_on {
                    if special_kind == B_SPECIAL_ONES {
                        b_special_head = b_special_head.wrapping_add(B_SPARSE_PAIR);
                        b_special_kind = B_SPECIAL_SPARSE;
                    } else {
                        b_special_head =
                            b_special_head.wrapping_add(B_ONES_BLOCK_PAIRS - B_SPARSE_PAIR);
                        b_special_kind = B_SPECIAL_ONES;
                    }
                } else {
                    b_special_head = b_special_head.wrapping_add(B_ONES_BLOCK_PAIRS);
                }
                if special_kind == B_SPECIAL_ONES {
                    let probe = if BAKE { b_batch_scale } else { F128::ONE };
                    let probe_z =
                        _mm512_broadcast_i32x4(_mm_set_epi64x(probe.hi as i64, probe.lo as i64));
                    let is_one = if b_direct {
                        b_direct_folded == probe
                    } else {
                        let one = probe_z;
                        let all = _mm512_cmpeq_epi64_mask(b0, one)
                            & _mm512_cmpeq_epi64_mask(b1, one)
                            & _mm512_cmpeq_epi64_mask(b2, one)
                            & _mm512_cmpeq_epi64_mask(b3, one);
                        all == 0xff
                    };
                    if is_one && BAKE {
                        #[cfg(test)]
                        B_ONES_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                        acc[0].mul_acc(a1, probe_z);
                        acc[2].mul_acc(a3, probe_z);
                        acc[4].mul_acc(a2, probe_z);
                        x_lo += 8;
                        continue;
                    }
                    if is_one {
                        let (a1w, a2w, a3w) = if let Some(wt) = wtab {
                            let wp = wt.as_ptr().add(x_lo) as *const __m512i;
                            let w = _mm512_loadu_si512(wp);
                            let w64 = _mm512_loadu_si512(wp.add(1));
                            (
                                crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64),
                                crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64),
                                crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64),
                            )
                        } else {
                            let e_lo = f128x4_loadu(eq_lo.as_ptr().add(x_lo));
                            let e_hi = f128x4_loadu(eq_lo.as_ptr().add(x_lo + 4));
                            let w = _mm512_permutex2var_epi64(e_lo, odd_idx, e_hi);
                            if wsplit {
                                let w64 =
                                    crate::field::gf2_128::x86_64::ghash_shift64_x4(w);
                                (
                                    crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                                        a1, w, w64,
                                    ),
                                    crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                                        a2, w, w64,
                                    ),
                                    crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                                        a3, w, w64,
                                    ),
                                )
                            } else {
                                (ghash_mul_x4(w, a1), ghash_mul_x4(w, a2), ghash_mul_x4(w, a3))
                            }
                        };
                        #[cfg(test)]
                        B_ONES_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                        acc[0].mul_acc_one(a1w);
                        acc[2].mul_acc_one(a3w);
                        acc[4].mul_acc_one(a2w);
                        x_lo += 8;
                        continue;
                    }
                } else {
                    let (b0_lane0, is_sparse) = if b_direct {
                        (b0, true)
                    } else {
                        let zero = _mm512_setzero_si512();
                        let b0_lane0 = _mm512_maskz_mov_epi64(0x03, b0);
                        let all = _mm512_cmpeq_epi64_mask(b0, b0_lane0)
                            & _mm512_cmpeq_epi64_mask(b1, zero)
                            & _mm512_cmpeq_epi64_mask(b2, zero)
                            & _mm512_cmpeq_epi64_mask(b3, zero);
                        (b0_lane0, all == 0xff)
                    };
                    if is_sparse {
                        #[cfg(test)]
                        B_SPARSE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                        let a1_msg = _mm512_xor_si512(a0, a1);
                        let a5_msg = _mm512_xor_si512(a0, a2);
                        let a7_msg = _mm512_xor_si512(a1_msg, _mm512_xor_si512(a2, a3));
                        if BAKE {
                            acc[1].mul_acc(a1_msg, b0_lane0);
                            acc[5].mul_acc(a5_msg, b0_lane0);
                            acc[7].mul_acc(a7_msg, b0_lane0);
                            x_lo += 8;
                            continue;
                        }
                        let wb = if let Some(wt) = wtab {
                            let wp = wt.as_ptr().add(x_lo) as *const __m512i;
                            let w = _mm512_loadu_si512(wp);
                            let w64 = _mm512_loadu_si512(wp.add(1));
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                                b0_lane0, w, w64,
                            )
                        } else {
                            let e_lo = f128x4_loadu(eq_lo.as_ptr().add(x_lo));
                            let e_hi = f128x4_loadu(eq_lo.as_ptr().add(x_lo + 4));
                            let w = _mm512_permutex2var_epi64(e_lo, odd_idx, e_hi);
                            if wsplit {
                                let w64 =
                                    crate::field::gf2_128::x86_64::ghash_shift64_x4(w);
                                crate::field::gf2_128::x86_64::ghash_mul_x4_split(
                                    b0_lane0, w, w64,
                                )
                            } else {
                                ghash_mul_x4(w, b0_lane0)
                            }
                        };
                        acc[1].mul_acc(a1_msg, wb);
                        acc[5].mul_acc(a5_msg, wb);
                        acc[7].mul_acc(a7_msg, wb);
                        x_lo += 8;
                        continue;
                    }
                }
            }
            let (a0w, a1w, a2w, a3w) = eq_weights!(x_lo, a0, a1, a2, a3);
            if unroll16
                && x_lo + 16 <= lo_size
                && (x_lo & 31) != 24
                && b_special_head != x_lo + 8
            {
                let x_hi = x_lo + 8;
                spread_pf!(x_hi);
                let (c0, c1, c2, c3, d0, d1, d2, d3) = load_window!(x_hi, false);
                let (c0w, c1w, c2w, c3w) = eq_weights!(x_hi, c0, c1, c2, c3);
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
                continue;
            }
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
            x_lo += 8;
        }

        while x_lo + 2 <= lo_size {
            let mut rows = [[F128::ZERO; 4]; 2];
            let mut any = false;
            for half in 0..2 {
                let pair = x_lo + half;
                let x0l = 2 * pair;
                let x1l = x0l + 1;
                if ((pair_idx_base + pair) & pair_in_block_mask) >= useful_pairs_inclusive {
                    if WRITE {
                        a_chunk[x0l] = F128::ZERO;
                        a_chunk[x1l] = F128::ZERO;
                        b_chunk[x0l] = F128::ZERO;
                        b_chunk[x1l] = F128::ZERO;
                    }
                    continue;
                }
                any = true;
                let x0g = row_base + x0l;
                let x1g = x0g + 1;
                rows[half] = fold_round2_pair_x86_unchecked_8(
                    table_data,
                    a_pkt.add(x0g * 8),
                    a_pkt.add(x1g * 8),
                    b_pkt.add(x0g * 8),
                    b_pkt.add(x1g * 8),
                );
                if WRITE {
                    a_chunk[x0l] = rows[half][0];
                    a_chunk[x1l] = rows[half][1];
                    b_chunk[x0l] = rows[half][2];
                    b_chunk[x1l] = rows[half][3];
                }
            }
            if any {
                let [a0, a1, b0, b1] = rows[0];
                let [a2, a3, b2, b3] = rows[1];
                let wt = eq_lo[x_lo + 1];
                let (a0w, a1w, a2w, a3w) = (wt * a0, wt * a1, wt * a2, wt * a3);
                tail[0] ^= a1w.mul_unreduced(b1);
                tail[1] ^= (a0w + a1w).mul_unreduced(b0 + b1);
                tail[2] ^= a3w.mul_unreduced(b3);
                tail[3] ^= (a2w + a3w).mul_unreduced(b2 + b3);
                tail[4] ^= a2w.mul_unreduced(b2);
                let (e_aw, e_b) = (a0w + a2w, b0 + b2);
                let (o_aw, o_b) = (a1w + a3w, b1 + b3);
                tail[5] ^= e_aw.mul_unreduced(e_b);
                tail[6] ^= o_aw.mul_unreduced(o_b);
                tail[7] ^= (e_aw + o_aw).mul_unreduced(e_b + o_b);
            }
            x_lo += 2;
        }

        let mut out = [F128::ZERO; 8];
        if BAKE {
            let lane_w = f128x4_loadu(bake.unwrap().lane.as_ptr());
            for i in 0..8 {
                let scaled = ghash_mul_x4(lane_w, acc[i].reduce_lanes());
                let l = crate::field::gf2_128::x86_64::f128x4_extract(scaled);
                out[i] = tail[i].reduce() + (l[0] + l[1] + l[2] + l[3]);
            }
        } else {
            for i in 0..8 {
                tail[i] ^= acc[i].fold();
                out[i] = tail[i].reduce();
            }
        }
        out
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(crate) unsafe fn fold2_and_message_x86_avx512(
    a_in: &[F128],
    b_in: &[F128],
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho1: F128,
    rho2: F128,
    eq_lo: &[F128],
) -> (F128, F128) {
    use crate::field::gf2_128::x86_64::ghash_mul_x4;
    use core::arch::x86_64::*;

    debug_assert_eq!(a_in.len(), 4 * a_out.len());
    debug_assert_eq!(b_in.len(), 4 * b_out.len());
    debug_assert_eq!(a_out.len(), 2 * eq_lo.len());

    #[inline(always)]
    unsafe fn fold_x4(
        src: *const F128,
        r: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use core::arch::x86_64::*;
        unsafe {
            let lo = _mm512_loadu_si512(src.cast::<__m512i>());
            let hi = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
            fold_regs(lo, hi, r, even_idx, odd_idx)
        }
    }

    #[inline(always)]
    unsafe fn fold_regs(
        lo: __m512i,
        hi: __m512i,
        r: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use crate::field::gf2_128::x86_64::ghash_mul_x4;
        use core::arch::x86_64::*;
        unsafe {
            let even = _mm512_permutex2var_epi64(lo, even_idx, hi);
            let odd = _mm512_permutex2var_epi64(lo, odd_idx, hi);
            _mm512_xor_si512(even, ghash_mul_x4(r, _mm512_xor_si512(even, odd)))
        }
    }

    unsafe {
        let r1 = _mm512_broadcast_i32x4(_mm_set_epi64x(rho1.hi as i64, rho1.lo as i64));
        let r2 = _mm512_broadcast_i32x4(_mm_set_epi64x(rho2.hi as i64, rho2.lo as i64));
        let even_idx = _mm512_set_epi64(13, 12, 9, 8, 5, 4, 1, 0);
        let odd_idx = _mm512_set_epi64(15, 14, 11, 10, 7, 6, 3, 2);
        let mut p1_wide = WideGhashX4::zero();
        let mut pinf_wide = WideGhashX4::zero();
        let mut p1_tail = F256Unreduced::ZERO;
        let mut pinf_tail = F256Unreduced::ZERO;
        let mut x_lo = 0;

        while x_lo + 4 <= eq_lo.len() {
            let output = 2 * x_lo;
            let input = 4 * output;
            let a_src = a_in.as_ptr().add(input);
            let b_src = b_in.as_ptr().add(input);
            let ta0 = fold_x4(a_src, r1, even_idx, odd_idx);
            let ta1 = fold_x4(a_src.add(8), r1, even_idx, odd_idx);
            let ta2 = fold_x4(a_src.add(16), r1, even_idx, odd_idx);
            let ta3 = fold_x4(a_src.add(24), r1, even_idx, odd_idx);
            let tb0 = fold_x4(b_src, r1, even_idx, odd_idx);
            let tb1 = fold_x4(b_src.add(8), r1, even_idx, odd_idx);
            let tb2 = fold_x4(b_src.add(16), r1, even_idx, odd_idx);
            let tb3 = fold_x4(b_src.add(24), r1, even_idx, odd_idx);
            let a_lo = fold_regs(ta0, ta1, r2, even_idx, odd_idx);
            let a_hi = fold_regs(ta2, ta3, r2, even_idx, odd_idx);
            let b_lo = fold_regs(tb0, tb1, r2, even_idx, odd_idx);
            let b_hi = fold_regs(tb2, tb3, r2, even_idx, odd_idx);

            _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_lo);
            _mm512_storeu_si512(a_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), a_hi);
            _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_lo);
            _mm512_storeu_si512(b_out.as_mut_ptr().add(output + 4).cast::<__m512i>(), b_hi);

            let a0 = _mm512_permutex2var_epi64(a_lo, even_idx, a_hi);
            let a1 = _mm512_permutex2var_epi64(a_lo, odd_idx, a_hi);
            let b0 = _mm512_permutex2var_epi64(b_lo, even_idx, b_hi);
            let b1 = _mm512_permutex2var_epi64(b_lo, odd_idx, b_hi);
            let g1 = ghash_mul_x4(a1, b1);
            let g_inf = ghash_mul_x4(_mm512_xor_si512(a0, a1), _mm512_xor_si512(b0, b1));
            let eq = f128x4_loadu(eq_lo.as_ptr().add(x_lo));
            p1_wide.mul_acc(eq, g1);
            pinf_wide.mul_acc(eq, g_inf);
            x_lo += 4;
        }

        if x_lo < eq_lo.len() {
            debug_assert_eq!(eq_lo.len() - x_lo, 2);
            let output = 2 * x_lo;
            let input = 4 * output;
            let a_src = a_in.as_ptr().add(input);
            let b_src = b_in.as_ptr().add(input);
            let ta0 = fold_x4(a_src, r1, even_idx, odd_idx);
            let ta1 = fold_x4(a_src.add(8), r1, even_idx, odd_idx);
            let tb0 = fold_x4(b_src, r1, even_idx, odd_idx);
            let tb1 = fold_x4(b_src.add(8), r1, even_idx, odd_idx);
            let a_folded = fold_regs(ta0, ta1, r2, even_idx, odd_idx);
            let b_folded = fold_regs(tb0, tb1, r2, even_idx, odd_idx);
            _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), a_folded);
            _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), b_folded);

            for lane in 0..2 {
                let o = output + 2 * lane;
                let a0 = a_out[o];
                let a1 = a_out[o + 1];
                let b0 = b_out[o];
                let b1 = b_out[o + 1];
                let eq = eq_lo[x_lo + lane];
                p1_tail ^= eq.mul_unreduced(a1 * b1);
                pinf_tail ^= eq.mul_unreduced((a0 + a1) * (b0 + b1));
            }
        }

        p1_tail ^= p1_wide.fold();
        pinf_tail ^= pinf_wide.fold();
        (p1_tail.reduce(), pinf_tail.reduce())
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline]
pub(crate) fn fold2_plain_defer_wtab_route_ok(
    split: bool,
    lo_size: usize,
    has_wtab: bool,
) -> bool {
    !split
        && has_wtab
        && lo_size >= 16
        && lo_size.is_multiple_of(16)
        && zc_fold_defer_enabled()
        && zc_tail_pf_enabled()
        && zc_tail_pf_spread_enabled()
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    )),
    target_feature(enable = "avx512f,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold2_and_message_lookahead_defer_wtab_x86<
    const NT_OUT: bool,
    const IN_LM: bool,
    const OUT_LM: bool,
>(
    a_in: *const F128,
    b_in: *const F128,
    a_out: *mut F128,
    b_out: *mut F128,
    rho_a: F128,
    rho_b: F128,
    lo_size: usize,
    wt: &[F128],
) -> [F128; 8] {
    use core::arch::x86_64::*;
    debug_assert!(lo_size.is_multiple_of(16));

    unsafe {
        let ra = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_a.hi as i64, rho_a.lo as i64));
        let rb = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_b.hi as i64, rho_b.lo as i64));
        let rho_ab = rho_a * rho_b;
        let rarb = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_ab.hi as i64, rho_ab.lo as i64));
        let mut acc = [WideGhashX4::zero(); 8];
        let wt_ptr = wt.as_ptr();
        const PF_OFF: usize = ZC_TAIL_PF_TILES * 64 * core::mem::size_of::<F128>();

        macro_rules! step8_fast {
            ($x_lo:expr) => {{
                let x = $x_lo;
                let output = 2 * x;
                let input = 4 * output;
                let a_src = a_in.add(input);
                let b_src = b_in.add(input);
                let pa = a_src.cast::<i8>().wrapping_add(PF_OFF);
                let pb = b_src.cast::<i8>().wrapping_add(PF_OFF);
                for l in 0..4 {
                    _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                    _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                }
                let oa0 = fold16_to_4_deferred_gen::<IN_LM, false>(a_src, ra, rb, rarb, ra, rb, rarb);
                let oa1 = fold16_to_4_deferred_gen::<IN_LM, false>(a_src.add(16), ra, rb, rarb, ra, rb, rarb);
                let oa2 = fold16_to_4_deferred_gen::<IN_LM, false>(a_src.add(32), ra, rb, rarb, ra, rb, rarb);
                let oa3 = fold16_to_4_deferred_gen::<IN_LM, false>(a_src.add(48), ra, rb, rarb, ra, rb, rarb);
                let ob0 = fold16_to_4_deferred_gen::<IN_LM, false>(b_src, ra, rb, rarb, ra, rb, rarb);
                let ob1 = fold16_to_4_deferred_gen::<IN_LM, false>(b_src.add(16), ra, rb, rarb, ra, rb, rarb);
                let ob2 = fold16_to_4_deferred_gen::<IN_LM, false>(b_src.add(32), ra, rb, rarb, ra, rb, rarb);
                let ob3 = fold16_to_4_deferred_gen::<IN_LM, false>(b_src.add(48), ra, rb, rarb, ra, rb, rarb);
                for l in 4..8 {
                    _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                    _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                }
                let ap = a_out.add(output);
                let bp = b_out.add(output);
                let (a0, a1, a2, a3, b0, b1, b2, b3) = if OUT_LM {
                    let [a0, a1, a2, a3] = transpose4_lanes(oa0, oa1, oa2, oa3);
                    let [b0, b1, b2, b3] = transpose4_lanes(ob0, ob1, ob2, ob3);
                    if NT_OUT {
                        stream_tile_as_xmm16(ap, a0, a1, a2, a3);
                        stream_tile_as_xmm16(bp, b0, b1, b2, b3);
                    } else {
                        _mm512_storeu_si512(ap.cast::<__m512i>(), a0);
                        _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), a1);
                        _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), a2);
                        _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), a3);
                        _mm512_storeu_si512(bp.cast::<__m512i>(), b0);
                        _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), b1);
                        _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), b2);
                        _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), b3);
                    }
                    for l in 8..16 {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                } else {
                    if NT_OUT {
                        stream_tile_as_xmm16(ap, oa0, oa1, oa2, oa3);
                        stream_tile_as_xmm16(bp, ob0, ob1, ob2, ob3);
                    } else {
                        _mm512_storeu_si512(ap.cast::<__m512i>(), oa0);
                        _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), oa1);
                        _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), oa2);
                        _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), oa3);
                        _mm512_storeu_si512(bp.cast::<__m512i>(), ob0);
                        _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), ob1);
                        _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), ob2);
                        _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), ob3);
                    }
                    for l in 8..12 {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                    let [a0, a1, a2, a3] = transpose4_lanes(oa0, oa1, oa2, oa3);
                    let [b0, b1, b2, b3] = transpose4_lanes(ob0, ob1, ob2, ob3);
                    for l in 12..16 {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                };
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
        let lo4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[0], acc[1], acc[2], acc[3]),
        );
        let hi4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[4], acc[5], acc[6], acc[7]),
        );
        [
            lo4[0], lo4[1], lo4[2], lo4[3], hi4[0], hi4[1], hi4[2], hi4[3],
        ]
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    )),
    target_feature(enable = "avx512f,vpclmulqdq")
)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold2_and_message_lookahead_x86_avx512(
    a_in: &[F128],
    b_in: &[F128],
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho_a: F128,
    rho_b: F128,
    eq_lo: &[F128],
    wtab: Option<&[F128]>,
    nt_out: bool,
    in_lm: bool,
    out_lm: bool,
    split: bool,
) -> [F128; 8] {
    if fold2_plain_defer_wtab_route_ok(split, eq_lo.len(), wtab.is_some())
        && let Some(wt) = wtab
    {
        return unsafe {
            let ap = a_in.as_ptr();
            let bp = b_in.as_ptr();
            let aop = a_out.as_mut_ptr();
            let bop = b_out.as_mut_ptr();
            let lo = eq_lo.len();
            match (nt_out, in_lm, out_lm) {
                (false, true, true) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<false, true, true>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (false, false, true) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<false, false, true>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (false, true, false) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<false, true, false>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (false, false, false) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<false, false, false>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (true, true, true) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<true, true, true>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (true, false, true) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<true, false, true>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (true, true, false) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<true, true, false>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
                (true, false, false) => {
                    fold2_and_message_lookahead_defer_wtab_x86::<true, false, false>(
                        ap, bp, aop, bop, rho_a, rho_b, lo, wt,
                    )
                }
            }
        };
    }
    unsafe {
        fold2_and_message_lookahead_general_x86_avx512(
            a_in, b_in, a_out, b_out, rho_a, rho_b, eq_lo, wtab, nt_out, in_lm, out_lm, split,
        )
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    )),
    target_feature(enable = "avx512f,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
unsafe fn fold2_and_message_lookahead_general_x86_avx512(
    a_in: &[F128],
    b_in: &[F128],
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho_a: F128,
    rho_b: F128,
    eq_lo: &[F128],
    wtab: Option<&[F128]>,
    nt_out: bool,
    in_lm: bool,
    out_lm: bool,
    split: bool,
) -> [F128; 8] {
    use crate::field::gf2_128::x86_64::ghash_mul_x4;
    use core::arch::x86_64::*;

    let lo_size = eq_lo.len();
    debug_assert!(!(in_lm || out_lm) || lo_size.is_multiple_of(8));
    debug_assert_eq!(a_in.len(), 4 * a_out.len());
    debug_assert_eq!(b_in.len(), 4 * b_out.len());
    debug_assert_eq!(a_out.len(), 2 * lo_size);
    debug_assert!(lo_size.is_multiple_of(2));

    #[inline(always)]
    unsafe fn fold_regs(
        lo: __m512i,
        hi: __m512i,
        r: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use crate::field::gf2_128::x86_64::ghash_mul_x4;
        use core::arch::x86_64::*;
        unsafe {
            let even = _mm512_permutex2var_epi64(lo, even_idx, hi);
            let odd = _mm512_permutex2var_epi64(lo, odd_idx, hi);
            _mm512_xor_si512(even, ghash_mul_x4(r, _mm512_xor_si512(even, odd)))
        }
    }

    #[inline(always)]
    unsafe fn fold16_to_4(
        src: *const F128,
        ra: __m512i,
        rb: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use core::arch::x86_64::*;
        unsafe {
            let i0 = _mm512_loadu_si512(src.cast::<__m512i>());
            let i1 = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
            let i2 = _mm512_loadu_si512(src.add(8).cast::<__m512i>());
            let i3 = _mm512_loadu_si512(src.add(12).cast::<__m512i>());
            let t0 = fold_regs(i0, i1, ra, even_idx, odd_idx);
            let t1 = fold_regs(i2, i3, ra, even_idx, odd_idx);
            fold_regs(t0, t1, rb, even_idx, odd_idx)
        }
    }

    #[inline(always)]
    unsafe fn transpose4(o0: __m512i, o1: __m512i, o2: __m512i, o3: __m512i) -> [__m512i; 4] {
        use core::arch::x86_64::*;
        unsafe {
            let q0 = _mm512_shuffle_i64x2::<0x44>(o0, o1); // o0.0 o0.1 o1.0 o1.1
            let q1 = _mm512_shuffle_i64x2::<0xEE>(o0, o1); // o0.2 o0.3 o1.2 o1.3
            let q2 = _mm512_shuffle_i64x2::<0x44>(o2, o3);
            let q3 = _mm512_shuffle_i64x2::<0xEE>(o2, o3);
            [
                _mm512_shuffle_i64x2::<0x88>(q0, q2), // o0.0 o1.0 o2.0 o3.0
                _mm512_shuffle_i64x2::<0xDD>(q0, q2), // o0.1 o1.1 o2.1 o3.1
                _mm512_shuffle_i64x2::<0x88>(q1, q3), // o0.2 o1.2 o2.2 o3.2
                _mm512_shuffle_i64x2::<0xDD>(q1, q3), // o0.3 o1.3 o2.3 o3.3
            ]
        }
    }

    unsafe {
        let ra = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_a.hi as i64, rho_a.lo as i64));
        let rb = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_b.hi as i64, rho_b.lo as i64));
        let rho_ab = rho_a * rho_b;
        let rarb = _mm512_broadcast_i32x4(_mm_set_epi64x(rho_ab.hi as i64, rho_ab.lo as i64));
        let defer = zc_fold_defer_enabled();
        debug_assert!(!in_lm || defer, "lane-major input is read by the deferred fold");
        let (ra64, rb64, rarb64) = if defer && split {
            (
                crate::field::gf2_128::x86_64::ghash_shift64_x4(ra),
                crate::field::gf2_128::x86_64::ghash_shift64_x4(rb),
                crate::field::gf2_128::x86_64::ghash_shift64_x4(rarb),
            )
        } else {
            (ra, rb, rarb)
        };
        let even_idx = _mm512_set_epi64(13, 12, 9, 8, 5, 4, 1, 0);
        let odd_idx = _mm512_set_epi64(15, 14, 11, 10, 7, 6, 3, 2);
        let mut acc = [WideGhashX4::zero(); 8];
        let wsplit = zc_wsplit_enabled();
        let mut tail = [F256Unreduced::ZERO; 8];
        let mut x_lo = 0;
        let pf_on = zc_tail_pf_enabled();
        let pf_spread = zc_tail_pf_spread_enabled();
        const PF_OFF: usize = ZC_TAIL_PF_TILES * 64 * core::mem::size_of::<F128>();

        macro_rules! step8 {
            ($x_lo:expr) => {{
                let x = $x_lo;
                let output = 2 * x;
                let input = 4 * output;
                let a_src = a_in.as_ptr().add(input);
                let b_src = b_in.as_ptr().add(input);
                let pa = a_src.cast::<i8>().wrapping_add(PF_OFF);
                let pb = b_src.cast::<i8>().wrapping_add(PF_OFF);
                if pf_on {
                    let hi = if pf_spread { 4 } else { 16 };
                    for l in 0..hi {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                }
                let (oa0, oa1, oa2, oa3, ob0, ob1, ob2, ob3) = if defer && (in_lm || split) {
                    macro_rules! fold_gen {
                        ($lm:literal, $sp:literal) => {
                            (
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    a_src, ra, rb, rarb, ra64, rb64, rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    a_src.add(16),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    a_src.add(32),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    a_src.add(48),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    b_src, ra, rb, rarb, ra64, rb64, rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    b_src.add(16),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    b_src.add(32),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                                fold16_to_4_deferred_gen::<$lm, $sp>(
                                    b_src.add(48),
                                    ra,
                                    rb,
                                    rarb,
                                    ra64,
                                    rb64,
                                    rarb64,
                                ),
                            )
                        };
                    }
                    match (in_lm, split) {
                        (true, true) => fold_gen!(true, true),
                        (true, false) => fold_gen!(true, false),
                        _ => fold_gen!(false, true),
                    }
                } else if defer {
                    (
                        fold16_to_4_deferred(a_src, ra, rb, rarb),
                        fold16_to_4_deferred(a_src.add(16), ra, rb, rarb),
                        fold16_to_4_deferred(a_src.add(32), ra, rb, rarb),
                        fold16_to_4_deferred(a_src.add(48), ra, rb, rarb),
                        fold16_to_4_deferred(b_src, ra, rb, rarb),
                        fold16_to_4_deferred(b_src.add(16), ra, rb, rarb),
                        fold16_to_4_deferred(b_src.add(32), ra, rb, rarb),
                        fold16_to_4_deferred(b_src.add(48), ra, rb, rarb),
                    )
                } else {
                    (
                        fold16_to_4(a_src, ra, rb, even_idx, odd_idx),
                        fold16_to_4(a_src.add(16), ra, rb, even_idx, odd_idx),
                        fold16_to_4(a_src.add(32), ra, rb, even_idx, odd_idx),
                        fold16_to_4(a_src.add(48), ra, rb, even_idx, odd_idx),
                        fold16_to_4(b_src, ra, rb, even_idx, odd_idx),
                        fold16_to_4(b_src.add(16), ra, rb, even_idx, odd_idx),
                        fold16_to_4(b_src.add(32), ra, rb, even_idx, odd_idx),
                        fold16_to_4(b_src.add(48), ra, rb, even_idx, odd_idx),
                    )
                };
                if pf_on && pf_spread {
                    for l in 4..8 {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                }
                let ap = a_out.as_mut_ptr().add(output);
                let bp = b_out.as_mut_ptr().add(output);
                let (a0, a1, a2, a3, b0, b1, b2, b3) = if out_lm {
                    let [a0, a1, a2, a3] = transpose4(oa0, oa1, oa2, oa3);
                    let [b0, b1, b2, b3] = transpose4(ob0, ob1, ob2, ob3);
                    if nt_out {
                        stream_tile_as_xmm16(ap, a0, a1, a2, a3);
                        stream_tile_as_xmm16(bp, b0, b1, b2, b3);
                    } else {
                        _mm512_storeu_si512(ap.cast::<__m512i>(), a0);
                        _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), a1);
                        _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), a2);
                        _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), a3);
                        _mm512_storeu_si512(bp.cast::<__m512i>(), b0);
                        _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), b1);
                        _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), b2);
                        _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), b3);
                    }
                    if pf_on && pf_spread {
                        for l in 8..12 {
                            _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                            _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                        }
                    }
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                } else {
                    if nt_out {
                        stream_tile_as_xmm16(ap, oa0, oa1, oa2, oa3);
                        stream_tile_as_xmm16(bp, ob0, ob1, ob2, ob3);
                    } else {
                        _mm512_storeu_si512(ap.cast::<__m512i>(), oa0);
                        _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), oa1);
                        _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), oa2);
                        _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), oa3);
                        _mm512_storeu_si512(bp.cast::<__m512i>(), ob0);
                        _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), ob1);
                        _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), ob2);
                        _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), ob3);
                    }
                    if pf_on && pf_spread {
                        for l in 8..12 {
                            _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                            _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                        }
                    }
                    let [a0, a1, a2, a3] = transpose4(oa0, oa1, oa2, oa3);
                    let [b0, b1, b2, b3] = transpose4(ob0, ob1, ob2, ob3);
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                };
                if pf_on && pf_spread {
                    for l in 12..16 {
                        _mm_prefetch(pa.wrapping_add(64 * l), _MM_HINT_T0);
                        _mm_prefetch(pb.wrapping_add(64 * l), _MM_HINT_T0);
                    }
                }
                let (a0w, a1w, a2w, a3w) = if let Some(wt) = wtab {
                    let wp = wt.as_ptr().add(x) as *const __m512i;
                    let w = _mm512_loadu_si512(wp);
                    let w64 = _mm512_loadu_si512(wp.add(1));
                    (
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a0, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64),
                    )
                } else {
                    let e_lo = f128x4_loadu(eq_lo.as_ptr().add(x));
                    let e_hi = f128x4_loadu(eq_lo.as_ptr().add(x + 4));
                    let w = _mm512_permutex2var_epi64(e_lo, odd_idx, e_hi);
                    if wsplit {
                        let w64 = crate::field::gf2_128::x86_64::ghash_shift64_x4(w);
                        (
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a0, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64),
                        )
                    } else {
                        (
                            ghash_mul_x4(w, a0),
                            ghash_mul_x4(w, a1),
                            ghash_mul_x4(w, a2),
                            ghash_mul_x4(w, a3),
                        )
                    }
                };
                (a0w, a1w, a2w, a3w, b0, b1, b2, b3)
            }};
        }

        while x_lo + 16 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step8!(x_lo);
            let (c0w, c1w, c2w, c3w, d0, d1, d2, d3) = step8!(x_lo + 8);
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

        while x_lo + 8 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step8!(x_lo);
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
            x_lo += 8;
        }

        while x_lo + 2 <= lo_size {
            let output = 2 * x_lo;
            let input = 4 * output;
            let oa = fold16_to_4(a_in.as_ptr().add(input), ra, rb, even_idx, odd_idx);
            let ob = fold16_to_4(b_in.as_ptr().add(input), ra, rb, even_idx, odd_idx);
            _mm512_storeu_si512(a_out.as_mut_ptr().add(output).cast::<__m512i>(), oa);
            _mm512_storeu_si512(b_out.as_mut_ptr().add(output).cast::<__m512i>(), ob);
            let (a0, a1, a2, a3) = (
                a_out[output],
                a_out[output + 1],
                a_out[output + 2],
                a_out[output + 3],
            );
            let (b0, b1, b2, b3) = (
                b_out[output],
                b_out[output + 1],
                b_out[output + 2],
                b_out[output + 3],
            );
            let wt = eq_lo[x_lo + 1];
            let (a0w, a1w, a2w, a3w) = (wt * a0, wt * a1, wt * a2, wt * a3);
            tail[0] ^= a1w.mul_unreduced(b1);
            tail[1] ^= (a0w + a1w).mul_unreduced(b0 + b1);
            tail[2] ^= a3w.mul_unreduced(b3);
            tail[3] ^= (a2w + a3w).mul_unreduced(b2 + b3);
            tail[4] ^= a2w.mul_unreduced(b2);
            let (e_aw, e_b) = (a0w + a2w, b0 + b2);
            let (o_aw, o_b) = (a1w + a3w, b1 + b3);
            tail[5] ^= e_aw.mul_unreduced(e_b);
            tail[6] ^= o_aw.mul_unreduced(o_b);
            tail[7] ^= (e_aw + o_aw).mul_unreduced(e_b + o_b);
            x_lo += 2;
        }

        if nt_out {
            _mm_sfence();
        }
        let mut out = [F128::ZERO; 8];
        for i in 0..8 {
            tail[i] ^= acc[i].fold();
            out[i] = tail[i].reduce();
        }
        out
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) fn zc_fold_nt_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_FOLD_NT").is_none());
    *ON
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) fn zc_regfold_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_REGFOLD").is_none());
    *ON
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) fn zc_fold_defer_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_FOLD_DEFER").is_none());
    *ON
}

pub(crate) fn zc_r2_tr_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_R2_TR_EMIT").is_none());
    *ON
}

pub(crate) fn zc_r2_bcast_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_R2_BCAST").is_none());
    *ON
}

pub(crate) fn zc_r34_bcast_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_R34_BCAST").is_none());
    *ON
}

pub(crate) fn zc_c4_lm_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_C4_LM").is_none());
    *ON
}

pub(crate) fn zc_lm_handoff_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_LM_HANDOFF").is_none());
    *ON
}

pub(crate) fn zc_defer_split_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_ZC_DEFER_SPLIT").is_some());
    *ON
}

pub(crate) fn zc_pkt_pf_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_PKT_PF").is_none());
    *ON
}

const ZC_PKT_PF_TILES: usize = 3;

pub(crate) fn zc_pkt_pf_far_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_PKT_PF_FAR").is_none());
    *ON
}

pub(crate) fn zc_pkt_pf_spread_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_PKT_PF_SPREAD").is_none());
    *ON
}

pub(crate) fn zc_tail_pf_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_TAIL_PF").is_none());
    *ON
}

const ZC_TAIL_PF_TILES: usize = 2;

pub(crate) fn zc_tail_pf_spread_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_TAIL_PF_SPREAD").is_none());
    *ON
}

pub(crate) fn zc_tail_nt_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_TAIL_NT").is_none());
    *ON
}

pub(crate) const ZC_TAIL_NT_LOG: u32 = 20;

pub(crate) fn zc_wtab_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_WTAB").is_none());
    *ON
}

pub(crate) fn zc_wsplit_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_WSPLIT").is_none());
    *ON
}

pub(crate) fn zc_r2_eq_bake_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_R2_EQ_BAKE").is_none());
    *ON
}

pub(crate) fn zc_r2_unroll16_enabled() -> bool {
    #[cfg(test)]
    if let Some(on) = R2_UNROLL16_OVERRIDE.with(|c| c.get()) {
        return on;
    }
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_R2_UNROLL16").is_none());
    *ON
}

#[cfg(test)]
thread_local! {
    static R2_UNROLL16_OVERRIDE: std::cell::Cell<Option<bool>> =
        const { std::cell::Cell::new(None) };
}

#[cfg(test)]
pub(crate) struct R2Unroll16Override(Option<bool>);

#[cfg(test)]
impl R2Unroll16Override {
    pub(crate) fn set(on: bool) -> Self {
        Self(R2_UNROLL16_OVERRIDE.with(|c| c.replace(Some(on))))
    }
}

#[cfg(test)]
impl Drop for R2Unroll16Override {
    fn drop(&mut self) {
        let prev = self.0;
        R2_UNROLL16_OVERRIDE.with(|c| c.set(prev));
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) fn zc_r2_bake_route_ok(lo_size: usize) -> bool {
    cfg!(all(target_feature = "avx512vbmi", target_feature = "gfni"))
        && zc_r2_eq_bake_enabled()
        && lo_size >= 32
        && lo_size.is_multiple_of(32)
        && zc_regfold_enabled()
        && zc_r2_tr_enabled()
        && zc_r2_bcast_enabled()
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[repr(C, align(64))]
#[derive(Clone, Copy)]
pub(crate) struct R2FoldMats(pub(crate) [u64; 128]);

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) struct R2EqBake {
    pub(crate) a_mats: [R2FoldMats; 4],
    pub(crate) b_mats: Vec<R2FoldMats>,
    pub(crate) b_scale: Vec<F128>,
    pub(crate) lane: [F128; 4],
    pub(crate) canonical_elide: bool,
}

fn zc_fold_split_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_FOLD_SPLIT").is_none());
    *ON
}

fn luna_foldmsg_reorder_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_LUNA_FOLDMSG_REORDER").is_none());
    *ON
}

#[cfg(test)]
pub(crate) static B_ONES_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

#[cfg(test)]
pub(crate) static B_SPARSE_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

#[cfg(test)]
pub(crate) static R2_CANON_ELIDE_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

pub(crate) fn zc_b_ones_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_B_ONES").is_none());
    *ON
}

#[inline]
fn zc_b_sparse_enabled() -> bool {
    static ENABLED: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_ZC_B_SPARSE").is_none());
    *ENABLED
}

#[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
#[inline]
fn zc_b_canonical_prefold_enabled() -> bool {
    static ENABLED: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
        std::env::var_os("FLOCK_NO_ZC_B_CANONICAL_PREFOLD").is_none()
    });
    *ENABLED
}

#[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
#[inline]
fn zc_b_canonical_direct_enabled() -> bool {
    static ENABLED: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
        std::env::var_os("FLOCK_NO_ZC_B_CANONICAL_DIRECT").is_none()
    });
    *ENABLED
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline(always)]
unsafe fn fold16_to_4_deferred(
    src: *const F128,
    ra: core::arch::x86_64::__m512i,
    rb: core::arch::x86_64::__m512i,
    rarb: core::arch::x86_64::__m512i,
) -> core::arch::x86_64::__m512i {
    use crate::field::gf2_128::x86_64::WideGhashX4;
    use core::arch::x86_64::*;
    unsafe {
        let i0 = _mm512_loadu_si512(src.cast::<__m512i>());
        let i1 = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
        let i2 = _mm512_loadu_si512(src.add(8).cast::<__m512i>());
        let i3 = _mm512_loadu_si512(src.add(12).cast::<__m512i>());
        let [x0, x1, x2, x3] = transpose4_lanes(i0, i1, i2, i3);
        let x01 = _mm512_xor_si512(x0, x1);
        let x02 = _mm512_xor_si512(x0, x2);
        let x0123 = _mm512_ternarylogic_epi64::<0x96>(x01, x2, x3);
        let mut acc = WideGhashX4::from_mul(ra, x01);
        acc.mul_acc2(rb, x02, rarb, x0123);
        _mm512_xor_si512(x0, acc.reduce_lanes())
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[inline(always)]
#[allow(clippy::too_many_arguments)]
unsafe fn fold16_to_4_deferred_gen<const LM_IN: bool, const SPLIT: bool>(
    src: *const F128,
    ra: core::arch::x86_64::__m512i,
    rb: core::arch::x86_64::__m512i,
    rarb: core::arch::x86_64::__m512i,
    ra64: core::arch::x86_64::__m512i,
    rb64: core::arch::x86_64::__m512i,
    rarb64: core::arch::x86_64::__m512i,
) -> core::arch::x86_64::__m512i {
    use crate::field::gf2_128::x86_64::WideGhashX4;
    use core::arch::x86_64::*;
    unsafe {
        let i0 = _mm512_loadu_si512(src.cast::<__m512i>());
        let i1 = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
        let i2 = _mm512_loadu_si512(src.add(8).cast::<__m512i>());
        let i3 = _mm512_loadu_si512(src.add(12).cast::<__m512i>());
        let [x0, x1, x2, x3] = if LM_IN {
            [i0, i1, i2, i3]
        } else {
            transpose4_lanes(i0, i1, i2, i3)
        };
        let x01 = _mm512_xor_si512(x0, x1);
        let x02 = _mm512_xor_si512(x0, x2);
        let x0123 = _mm512_ternarylogic_epi64::<0x96>(x01, x2, x3);
        if SPLIT {
            let lo = _mm512_xor_si512(
                _mm512_ternarylogic_epi64::<0x96>(
                    _mm512_ternarylogic_epi64::<0x96>(
                        _mm512_clmulepi64_epi128::<0x00>(x01, ra),
                        _mm512_clmulepi64_epi128::<0x01>(x01, ra64),
                        _mm512_clmulepi64_epi128::<0x00>(x02, rb),
                    ),
                    _mm512_clmulepi64_epi128::<0x01>(x02, rb64),
                    _mm512_clmulepi64_epi128::<0x00>(x0123, rarb),
                ),
                _mm512_clmulepi64_epi128::<0x01>(x0123, rarb64),
            );
            let hi = _mm512_xor_si512(
                _mm512_ternarylogic_epi64::<0x96>(
                    _mm512_ternarylogic_epi64::<0x96>(
                        _mm512_clmulepi64_epi128::<0x10>(x01, ra),
                        _mm512_clmulepi64_epi128::<0x11>(x01, ra64),
                        _mm512_clmulepi64_epi128::<0x10>(x02, rb),
                    ),
                    _mm512_clmulepi64_epi128::<0x11>(x02, rb64),
                    _mm512_clmulepi64_epi128::<0x10>(x0123, rarb),
                ),
                _mm512_clmulepi64_epi128::<0x11>(x0123, rarb64),
            );
            let poly = _mm512_set_epi64(0, 0x87, 0, 0x87, 0, 0x87, 0, 0x87);
            _mm512_ternarylogic_epi64::<0x96>(
                _mm512_xor_si512(x0, lo),
                _mm512_bslli_epi128::<8>(hi),
                _mm512_clmulepi64_epi128::<0x01>(hi, poly),
            )
        } else {
            let mut acc = WideGhashX4::from_mul(ra, x01);
            acc.mul_acc2(rb, x02, rarb, x0123);
            _mm512_xor_si512(x0, acc.reduce_lanes())
        }
    }
}

#[cfg(all(target_arch = "x86_64", target_feature = "avx512f"))]
#[inline(always)]
unsafe fn stream_tile_as_xmm16(
    p: *mut F128,
    v0: core::arch::x86_64::__m512i,
    v1: core::arch::x86_64::__m512i,
    v2: core::arch::x86_64::__m512i,
    v3: core::arch::x86_64::__m512i,
) {
    use core::arch::x86_64::*;

    #[inline(always)]
    unsafe fn stream_xmm4(p: *mut F128, v: __m512i) {
        unsafe {
            let d = p.cast::<__m128i>();
            _mm_stream_si128(d, _mm512_extracti32x4_epi32::<0>(v));
            _mm_stream_si128(d.add(1), _mm512_extracti32x4_epi32::<1>(v));
            _mm_stream_si128(d.add(2), _mm512_extracti32x4_epi32::<2>(v));
            _mm_stream_si128(d.add(3), _mm512_extracti32x4_epi32::<3>(v));
        }
    }

    unsafe {
        if p as usize % 64 == 0 {
            _mm512_stream_si512(p.cast::<__m512i>(), v0);
            _mm512_stream_si512(p.add(4).cast::<__m512i>(), v1);
            _mm512_stream_si512(p.add(8).cast::<__m512i>(), v2);
            _mm512_stream_si512(p.add(12).cast::<__m512i>(), v3);
        } else {
            stream_xmm4(p, v0);
            stream_xmm4(p.add(4), v1);
            stream_xmm4(p.add(8), v2);
            stream_xmm4(p.add(12), v3);
        }
    }
}

#[cfg(all(test, target_arch = "x86_64", target_feature = "avx512f"))]
#[test]
fn nt_tile_store_matches_all_alignment_classes() {
    use core::arch::x86_64::*;

    #[repr(align(64))]
    struct Aligned([F128; 24]);

    let guard = F128 {
        lo: 0x1234_5678_9ABC_DEF0,
        hi: 0xFEDC_BA98_7654_3210,
    };
    let values: [F128; 16] = std::array::from_fn(|i| F128 {
        lo: (i as u64 + 1).wrapping_mul(0x9E37_79B9_7F4A_7C15),
        hi: (i as u64 + 17).wrapping_mul(0xD6E8_FEB8_6659_FD93),
    });
    for offset in 0..4 {
        let mut dst = Aligned([guard; 24]);
        let start = 4 + offset;
        let ptr = dst.0.as_mut_ptr();
        assert_eq!(ptr as usize % 64, 0);
        unsafe {
            let p = values.as_ptr().cast::<__m512i>();
            stream_tile_as_xmm16(
                ptr.add(start),
                _mm512_loadu_si512(p),
                _mm512_loadu_si512(p.add(1)),
                _mm512_loadu_si512(p.add(2)),
                _mm512_loadu_si512(p.add(3)),
            );
            _mm_sfence();
        }
        assert_eq!(&dst.0[start..start + 16], &values);
        assert!(dst.0[..start].iter().all(|&v| v == guard));
        assert!(dst.0[start + 16..].iter().all(|&v| v == guard));
    }
}

#[cfg(all(target_arch = "x86_64", target_feature = "avx512f"))]
#[inline(always)]
unsafe fn transpose4_lanes(
    o0: core::arch::x86_64::__m512i,
    o1: core::arch::x86_64::__m512i,
    o2: core::arch::x86_64::__m512i,
    o3: core::arch::x86_64::__m512i,
) -> [core::arch::x86_64::__m512i; 4] {
    use core::arch::x86_64::*;
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

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[inline]
pub(crate) fn fold2_packed_c4_lm_wtab_route_ok(
    has_mats: bool,
    c4_lm: bool,
    lo_size: usize,
    has_cfold: bool,
    has_wtab: bool,
) -> bool {
    has_mats
        && c4_lm
        && has_cfold
        && has_wtab
        && lo_size >= 16
        && lo_size.is_multiple_of(16)
        && zc_regfold_enabled()
        && zc_r34_bcast_enabled()
        && zc_pkt_pf_enabled()
        && zc_pkt_pf_far_enabled()
        && zc_pkt_pf_spread_enabled()
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold2_from_packed_lookahead_c4_lm_wtab_x86<
    const NT_OUT: bool,
    const OUT_LM: bool,
>(
    a_pkt: *const u8,
    b_pkt: *const u8,
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
        let a_out_ptr = a_out.as_mut_ptr();
        let b_out_ptr = b_out.as_mut_ptr();
        let wt_ptr = wt.as_ptr();

        macro_rules! step8_fast {
            ($x_expr:expr) => {{
                let x = $x_expr;
                let ol = 2 * x;
                let xg = out_base + ol;
                let [a0, a1, a2, a3] =
                    gfni_fold64_rows_c4_lm_registers(a_pkt.add(4 * xg * 8), cfold);
                let [b0, b1, b2, b3] =
                    gfni_fold64_rows_c4_lm_registers(b_pkt.add(4 * xg * 8), cfold);
                let next = (4 * xg + 64 * ZC_PKT_PF_TILES) * 8;
                for l in 0..2 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                }
                for l in 2..4 {
                    _mm_prefetch(
                        a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                        core::arch::x86_64::_MM_HINT_T0,
                    );
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
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
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
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
        let lo4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[0], acc[1], acc[2], acc[3]),
        );
        let hi4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[4], acc[5], acc[6], acc[7]),
        );
        [
            lo4[0], lo4[1], lo4[2], lo4[3], hi4[0], hi4[1], hi4[2], hi4[3],
        ]
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold2_from_packed_lookahead_x86_avx512(
    table_data: *const F128,
    mats: Option<&[u64; 128]>,
    a_pkt: *const u8,
    b_pkt: *const u8,
    out_base: usize,
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho1: F128,
    rho2: F128,
    eq_lo: &[F128],
    pair_in_block_mask: usize,
    useful_pairs_inclusive: usize,
    nt_out: bool,
    cfold: Option<&CFoldMats>,
    wtab: Option<&[F128]>,
    c4_lm: bool,
    out_lm: bool,
) -> [F128; 8] {
    #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
    if fold2_packed_c4_lm_wtab_route_ok(
        mats.is_some(),
        c4_lm,
        eq_lo.len(),
        cfold.is_some(),
        wtab.is_some(),
    ) && let (Some(c), Some(wt)) = (cfold, wtab)
    {
        return unsafe {
            match (nt_out, out_lm) {
                (true, false) => fold2_from_packed_lookahead_c4_lm_wtab_x86::<true, false>(
                    a_pkt,
                    b_pkt,
                    out_base,
                    a_out,
                    b_out,
                    eq_lo.len(),
                    c,
                    wt,
                ),
                (false, false) => fold2_from_packed_lookahead_c4_lm_wtab_x86::<false, false>(
                    a_pkt,
                    b_pkt,
                    out_base,
                    a_out,
                    b_out,
                    eq_lo.len(),
                    c,
                    wt,
                ),
                (true, true) => fold2_from_packed_lookahead_c4_lm_wtab_x86::<true, true>(
                    a_pkt,
                    b_pkt,
                    out_base,
                    a_out,
                    b_out,
                    eq_lo.len(),
                    c,
                    wt,
                ),
                (false, true) => fold2_from_packed_lookahead_c4_lm_wtab_x86::<false, true>(
                    a_pkt,
                    b_pkt,
                    out_base,
                    a_out,
                    b_out,
                    eq_lo.len(),
                    c,
                    wt,
                ),
            }
        };
    }
    unsafe {
        fold2_from_packed_lookahead_general_x86_avx512(
            table_data,
            mats,
            a_pkt,
            b_pkt,
            out_base,
            a_out,
            b_out,
            rho1,
            rho2,
            eq_lo,
            pair_in_block_mask,
            useful_pairs_inclusive,
            nt_out,
            cfold,
            wtab,
            c4_lm,
            out_lm,
        )
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ),
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
unsafe fn fold2_from_packed_lookahead_general_x86_avx512(
    table_data: *const F128,
    mats: Option<&[u64; 128]>,
    a_pkt: *const u8,
    b_pkt: *const u8,
    out_base: usize,
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho1: F128,
    rho2: F128,
    eq_lo: &[F128],
    pair_in_block_mask: usize,
    useful_pairs_inclusive: usize,
    nt_out: bool,
    cfold: Option<&CFoldMats>,
    wtab: Option<&[F128]>,
    c4_lm: bool,
    out_lm: bool,
) -> [F128; 8] {
    use crate::field::gf2_128::x86_64::ghash_mul_x4;
    use core::arch::x86_64::*;

    let lo_size = eq_lo.len();
    debug_assert!(!out_lm || lo_size.is_multiple_of(8));
    debug_assert_eq!(a_out.len(), 2 * lo_size);
    debug_assert_eq!(b_out.len(), 2 * lo_size);
    debug_assert!(lo_size.is_multiple_of(2));

    #[inline(always)]
    unsafe fn fold_regs(
        lo: __m512i,
        hi: __m512i,
        r: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use crate::field::gf2_128::x86_64::ghash_mul_x4;
        use core::arch::x86_64::*;
        unsafe {
            let even = _mm512_permutex2var_epi64(lo, even_idx, hi);
            let odd = _mm512_permutex2var_epi64(lo, odd_idx, hi);
            _mm512_xor_si512(even, ghash_mul_x4(r, _mm512_xor_si512(even, odd)))
        }
    }

    #[inline(always)]
    unsafe fn fold16_to_4(
        src: *const F128,
        ra: __m512i,
        rb: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
    ) -> __m512i {
        use core::arch::x86_64::*;
        unsafe {
            let i0 = _mm512_loadu_si512(src.cast::<__m512i>());
            let i1 = _mm512_loadu_si512(src.add(4).cast::<__m512i>());
            let i2 = _mm512_loadu_si512(src.add(8).cast::<__m512i>());
            let i3 = _mm512_loadu_si512(src.add(12).cast::<__m512i>());
            let t0 = fold_regs(i0, i1, ra, even_idx, odd_idx);
            let t1 = fold_regs(i2, i3, ra, even_idx, odd_idx);
            fold_regs(t0, t1, rb, even_idx, odd_idx)
        }
    }

    #[inline(always)]
    unsafe fn transpose4(o0: __m512i, o1: __m512i, o2: __m512i, o3: __m512i) -> [__m512i; 4] {
        use core::arch::x86_64::*;
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
    #[allow(clippy::too_many_arguments)]
    unsafe fn group_from_packed(
        table_data: *const F128,
        a_pkt: *const u8,
        b_pkt: *const u8,
        x0: usize,
        r1: __m512i,
        r2: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
        pair_in_block_mask: usize,
        useful_pairs_inclusive: usize,
        cache: Option<(&[F128; 64], &[F128; 64], usize)>,
    ) -> (__m512i, __m512i) {
        use core::arch::x86_64::*;
        unsafe {
            let mut ae = [F128::ZERO; 8];
            let mut ao = [F128::ZERO; 8];
            let mut be = [F128::ZERO; 8];
            let mut bo = [F128::ZERO; 8];
            for p in 0..8 {
                let pair = 2 * x0 + p;
                if (pair & pair_in_block_mask) >= useful_pairs_inclusive {
                    continue;
                }
                let r0 = 2 * pair;
                let folded = if let Some((fa, fb, cache_base)) = cache {
                    let i = r0 - cache_base;
                    [fa[i], fa[i + 1], fb[i], fb[i + 1]]
                } else {
                    fold_round2_pair_x86_unchecked_8(
                        table_data,
                        a_pkt.add(r0 * 8),
                        a_pkt.add((r0 + 1) * 8),
                        b_pkt.add(r0 * 8),
                        b_pkt.add((r0 + 1) * 8),
                    )
                };
                ae[p] = folded[0];
                ao[p] = folded[1];
                be[p] = folded[2];
                bo[p] = folded[3];
            }
            let ae_lo = f128x4_loadu(ae.as_ptr());
            let ao_lo = f128x4_loadu(ao.as_ptr());
            let ae_hi = f128x4_loadu(ae.as_ptr().add(4));
            let ao_hi = f128x4_loadu(ao.as_ptr().add(4));
            let ta_lo = _mm512_xor_si512(ae_lo, ghash_mul_x4(r1, _mm512_xor_si512(ae_lo, ao_lo)));
            let ta_hi = _mm512_xor_si512(ae_hi, ghash_mul_x4(r1, _mm512_xor_si512(ae_hi, ao_hi)));
            let be_lo = f128x4_loadu(be.as_ptr());
            let bo_lo = f128x4_loadu(bo.as_ptr());
            let be_hi = f128x4_loadu(be.as_ptr().add(4));
            let bo_hi = f128x4_loadu(bo.as_ptr().add(4));
            let tb_lo = _mm512_xor_si512(be_lo, ghash_mul_x4(r1, _mm512_xor_si512(be_lo, bo_lo)));
            let tb_hi = _mm512_xor_si512(be_hi, ghash_mul_x4(r1, _mm512_xor_si512(be_hi, bo_hi)));
            (
                fold_regs(ta_lo, ta_hi, r2, even_idx, odd_idx),
                fold_regs(tb_lo, tb_hi, r2, even_idx, odd_idx),
            )
        }
    }

    #[inline(never)]
    #[allow(clippy::too_many_arguments)]
    unsafe fn groups_general(
        table_data: *const F128,
        a_pkt: *const u8,
        b_pkt: *const u8,
        xg: usize,
        r1: __m512i,
        r2: __m512i,
        even_idx: __m512i,
        odd_idx: __m512i,
        pair_in_block_mask: usize,
        useful_pairs_inclusive: usize,
        cache: Option<(&[F128; 64], &[F128; 64], usize)>,
    ) -> [__m512i; 8] {
        unsafe {
            let (oa0, ob0) = group_from_packed(
                table_data,
                a_pkt,
                b_pkt,
                xg,
                r1,
                r2,
                even_idx,
                odd_idx,
                pair_in_block_mask,
                useful_pairs_inclusive,
                cache,
            );
            let (oa1, ob1) = group_from_packed(
                table_data,
                a_pkt,
                b_pkt,
                xg + 4,
                r1,
                r2,
                even_idx,
                odd_idx,
                pair_in_block_mask,
                useful_pairs_inclusive,
                cache,
            );
            let (oa2, ob2) = group_from_packed(
                table_data,
                a_pkt,
                b_pkt,
                xg + 8,
                r1,
                r2,
                even_idx,
                odd_idx,
                pair_in_block_mask,
                useful_pairs_inclusive,
                cache,
            );
            let (oa3, ob3) = group_from_packed(
                table_data,
                a_pkt,
                b_pkt,
                xg + 12,
                r1,
                r2,
                even_idx,
                odd_idx,
                pair_in_block_mask,
                useful_pairs_inclusive,
                cache,
            );
            [oa0, ob0, oa1, ob1, oa2, ob2, oa3, ob3]
        }
    }

    unsafe {
        let r1 = _mm512_broadcast_i32x4(_mm_set_epi64x(rho1.hi as i64, rho1.lo as i64));
        let r2 = _mm512_broadcast_i32x4(_mm_set_epi64x(rho2.hi as i64, rho2.lo as i64));
        let rho12 = rho1 * rho2;
        let r12 = _mm512_broadcast_i32x4(_mm_set_epi64x(rho12.hi as i64, rho12.lo as i64));
        let defer = zc_fold_defer_enabled();
        let even_idx = _mm512_set_epi64(13, 12, 9, 8, 5, 4, 1, 0);
        let odd_idx = _mm512_set_epi64(15, 14, 11, 10, 7, 6, 3, 2);
        let mut acc = [WideGhashX4::zero(); 8];
        let wsplit = zc_wsplit_enabled();
        let mut tail = [F256Unreduced::ZERO; 8];
        let mut x_lo = 0;

        let use_batch = cfg!(all(target_feature = "avx512vbmi", target_feature = "gfni"))
            && (mats.is_some() || (cfold.is_some() && zc_regfold_enabled()));
        let use_c4 = use_batch && cfold.is_some() && zc_regfold_enabled();
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let c4_bcast = use_c4 && zc_r34_bcast_enabled();
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let c4_lm_on = c4_bcast && c4_lm;
        #[cfg(not(all(target_feature = "avx512vbmi", target_feature = "gfni")))]
        let c4_lm_on = {
            let _ = c4_lm;
            false
        };
        let pf_tiles = if zc_pkt_pf_far_enabled() {
            ZC_PKT_PF_TILES
        } else {
            1
        };
        let pf_on = zc_pkt_pf_enabled();
        let pf_spread = zc_pkt_pf_spread_enabled();
        let mut fa_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let mut fb_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let fa = &mut (*fa_store.as_mut_ptr()).0;
        let fb = &mut (*fb_store.as_mut_ptr()).0;

        macro_rules! step8_packed {
            ($x_expr:expr) => {{
                let x = $x_expr;
                let ol = 2 * x; // local output index of group 0
                let xg = out_base + ol;
                let cache = if use_batch {
                    #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
                    {
                        let dead = 0u8;
                        let _ = (pair_in_block_mask, useful_pairs_inclusive);
                        if use_c4 {
                            let c = cfold.unwrap();
                            if c4_lm_on {
                                gfni_fold64_rows_masked_c4_bcast_lm(
                                    a_pkt.add(4 * xg * 8),
                                    c,
                                    fa.as_mut_ptr(),
                                    dead,
                                );
                                gfni_fold64_rows_masked_c4_bcast_lm(
                                    b_pkt.add(4 * xg * 8),
                                    c,
                                    fb.as_mut_ptr(),
                                    dead,
                                );
                            } else if c4_bcast {
                                gfni_fold64_rows_masked_c4_bcast(
                                    a_pkt.add(4 * xg * 8),
                                    c,
                                    fa.as_mut_ptr(),
                                    dead,
                                );
                                gfni_fold64_rows_masked_c4_bcast(
                                    b_pkt.add(4 * xg * 8),
                                    c,
                                    fb.as_mut_ptr(),
                                    dead,
                                );
                            } else {
                                gfni_fold64_rows_masked_c4(
                                    a_pkt.add(4 * xg * 8),
                                    c,
                                    fa.as_mut_ptr(),
                                    dead,
                                );
                                gfni_fold64_rows_masked_c4(
                                    b_pkt.add(4 * xg * 8),
                                    c,
                                    fb.as_mut_ptr(),
                                    dead,
                                );
                            }
                        } else {
                            let m = mats.unwrap();
                            gfni_fold64_rows_masked(
                                a_pkt.add(4 * xg * 8),
                                m,
                                fa.as_mut_ptr(),
                                dead,
                            );
                            gfni_fold64_rows_masked(
                                b_pkt.add(4 * xg * 8),
                                m,
                                fb.as_mut_ptr(),
                                dead,
                            );
                        }
                        if pf_on {
                            let next = (4 * xg + 64 * pf_tiles) * 8;
                            let hi = if pf_spread { 2 } else { 8 };
                            for l in 0..hi {
                                _mm_prefetch(
                                    a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                    core::arch::x86_64::_MM_HINT_T0,
                                );
                                _mm_prefetch(
                                    b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                    core::arch::x86_64::_MM_HINT_T0,
                                );
                            }
                        }
                    }
                    Some((&*fa, &*fb, 4 * xg))
                } else {
                    None
                };
                let cache = cache.map(|(a, b, base)| (&*a, &*b, base));
                let (oa0, ob0, oa1, ob1, oa2, ob2, oa3, ob3) = if use_c4 {
                    let ap = fa.as_ptr();
                    let bp2 = fb.as_ptr();
                    (
                        _mm512_loadu_si512(ap.cast::<__m512i>()),
                        _mm512_loadu_si512(bp2.cast::<__m512i>()),
                        _mm512_loadu_si512(ap.add(4).cast::<__m512i>()),
                        _mm512_loadu_si512(bp2.add(4).cast::<__m512i>()),
                        _mm512_loadu_si512(ap.add(8).cast::<__m512i>()),
                        _mm512_loadu_si512(bp2.add(8).cast::<__m512i>()),
                        _mm512_loadu_si512(ap.add(12).cast::<__m512i>()),
                        _mm512_loadu_si512(bp2.add(12).cast::<__m512i>()),
                    )
                } else if let Some((fa, fb, cache_base)) = cache.filter(|_| zc_regfold_enabled()) {
                    debug_assert_eq!(cache_base, 4 * xg);
                    let _ = cache_base;
                    let ap = fa.as_ptr();
                    let bp2 = fb.as_ptr();
                    if defer {
                        (
                            fold16_to_4_deferred(ap, r1, r2, r12),
                            fold16_to_4_deferred(bp2, r1, r2, r12),
                            fold16_to_4_deferred(ap.add(16), r1, r2, r12),
                            fold16_to_4_deferred(bp2.add(16), r1, r2, r12),
                            fold16_to_4_deferred(ap.add(32), r1, r2, r12),
                            fold16_to_4_deferred(bp2.add(32), r1, r2, r12),
                            fold16_to_4_deferred(ap.add(48), r1, r2, r12),
                            fold16_to_4_deferred(bp2.add(48), r1, r2, r12),
                        )
                    } else {
                        (
                            fold16_to_4(ap, r1, r2, even_idx, odd_idx),
                            fold16_to_4(bp2, r1, r2, even_idx, odd_idx),
                            fold16_to_4(ap.add(16), r1, r2, even_idx, odd_idx),
                            fold16_to_4(bp2.add(16), r1, r2, even_idx, odd_idx),
                            fold16_to_4(ap.add(32), r1, r2, even_idx, odd_idx),
                            fold16_to_4(bp2.add(32), r1, r2, even_idx, odd_idx),
                            fold16_to_4(ap.add(48), r1, r2, even_idx, odd_idx),
                            fold16_to_4(bp2.add(48), r1, r2, even_idx, odd_idx),
                        )
                    }
                } else {
                    let g = groups_general(
                        table_data,
                        a_pkt,
                        b_pkt,
                        xg,
                        r1,
                        r2,
                        even_idx,
                        odd_idx,
                        pair_in_block_mask,
                        useful_pairs_inclusive,
                        cache,
                    );
                    (g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7])
                };
                if use_batch && pf_on && pf_spread {
                    let next = (4 * xg + 64 * pf_tiles) * 8;
                    for l in 2..4 {
                        _mm_prefetch(
                            a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                        _mm_prefetch(
                            b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                    }
                }
                let ap = a_out.as_mut_ptr().add(ol);
                let bp = b_out.as_mut_ptr().add(ol);
                let (a0, a1, a2, a3, b0, b1, b2, b3) = if c4_lm_on || out_lm {
                    let (a0, a1, a2, a3, b0, b1, b2, b3) = if c4_lm_on {
                        (oa0, oa1, oa2, oa3, ob0, ob1, ob2, ob3)
                    } else {
                        let [a0, a1, a2, a3] = transpose4(oa0, oa1, oa2, oa3);
                        let [b0, b1, b2, b3] = transpose4(ob0, ob1, ob2, ob3);
                        (a0, a1, a2, a3, b0, b1, b2, b3)
                    };
                    let (s0, s1, s2, s3, t0, t1, t2, t3) = if out_lm {
                        (a0, a1, a2, a3, b0, b1, b2, b3)
                    } else {
                        let [s0, s1, s2, s3] = transpose4(a0, a1, a2, a3);
                        let [t0, t1, t2, t3] = transpose4(b0, b1, b2, b3);
                        (s0, s1, s2, s3, t0, t1, t2, t3)
                    };
                    if nt_out {
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
                    if use_batch && pf_on && pf_spread {
                        let next = (4 * xg + 64 * pf_tiles) * 8;
                        for l in 4..6 {
                            _mm_prefetch(
                                a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                core::arch::x86_64::_MM_HINT_T0,
                            );
                            _mm_prefetch(
                                b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                core::arch::x86_64::_MM_HINT_T0,
                            );
                        }
                    }
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                } else {
                    if nt_out {
                        stream_tile_as_xmm16(ap, oa0, oa1, oa2, oa3);
                        stream_tile_as_xmm16(bp, ob0, ob1, ob2, ob3);
                    } else {
                        _mm512_storeu_si512(ap.cast::<__m512i>(), oa0);
                        _mm512_storeu_si512(ap.add(4).cast::<__m512i>(), oa1);
                        _mm512_storeu_si512(ap.add(8).cast::<__m512i>(), oa2);
                        _mm512_storeu_si512(ap.add(12).cast::<__m512i>(), oa3);
                        _mm512_storeu_si512(bp.cast::<__m512i>(), ob0);
                        _mm512_storeu_si512(bp.add(4).cast::<__m512i>(), ob1);
                        _mm512_storeu_si512(bp.add(8).cast::<__m512i>(), ob2);
                        _mm512_storeu_si512(bp.add(12).cast::<__m512i>(), ob3);
                    }
                    if use_batch && pf_on && pf_spread {
                        let next = (4 * xg + 64 * pf_tiles) * 8;
                        for l in 4..6 {
                            _mm_prefetch(
                                a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                core::arch::x86_64::_MM_HINT_T0,
                            );
                            _mm_prefetch(
                                b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                                core::arch::x86_64::_MM_HINT_T0,
                            );
                        }
                    }
                    let [a0, a1, a2, a3] = transpose4(oa0, oa1, oa2, oa3);
                    let [b0, b1, b2, b3] = transpose4(ob0, ob1, ob2, ob3);
                    (a0, a1, a2, a3, b0, b1, b2, b3)
                };
                if use_batch && pf_on && pf_spread {
                    let next = (4 * xg + 64 * pf_tiles) * 8;
                    for l in 6..8 {
                        _mm_prefetch(
                            a_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                        _mm_prefetch(
                            b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
                            core::arch::x86_64::_MM_HINT_T0,
                        );
                    }
                }
                let (a0w, a1w, a2w, a3w) = if let Some(wt) = wtab {
                    let wp = wt.as_ptr().add(x) as *const __m512i;
                    let w = _mm512_loadu_si512(wp);
                    let w64 = _mm512_loadu_si512(wp.add(1));
                    (
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a0, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64),
                        crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64),
                    )
                } else {
                    let e_lo = f128x4_loadu(eq_lo.as_ptr().add(x));
                    let e_hi = f128x4_loadu(eq_lo.as_ptr().add(x + 4));
                    let w = _mm512_permutex2var_epi64(e_lo, odd_idx, e_hi);
                    if wsplit {
                        let w64 = crate::field::gf2_128::x86_64::ghash_shift64_x4(w);
                        (
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a0, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a1, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a2, w, w64),
                            crate::field::gf2_128::x86_64::ghash_mul_x4_split(a3, w, w64),
                        )
                    } else {
                        (
                            ghash_mul_x4(w, a0),
                            ghash_mul_x4(w, a1),
                            ghash_mul_x4(w, a2),
                            ghash_mul_x4(w, a3),
                        )
                    }
                };
                (a0w, a1w, a2w, a3w, b0, b1, b2, b3)
            }};
        }

        while x_lo + 16 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step8_packed!(x_lo);
            let (c0w, c1w, c2w, c3w, d0, d1, d2, d3) = step8_packed!(x_lo + 8);
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

        while x_lo + 8 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step8_packed!(x_lo);
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
            x_lo += 8;
        }

        while x_lo + 2 <= lo_size {
            let ol = 2 * x_lo;
            let (oa, ob) = group_from_packed(
                table_data,
                a_pkt,
                b_pkt,
                out_base + ol,
                r1,
                r2,
                even_idx,
                odd_idx,
                pair_in_block_mask,
                useful_pairs_inclusive,
                None,
            );
            _mm512_storeu_si512(a_out.as_mut_ptr().add(ol).cast::<__m512i>(), oa);
            _mm512_storeu_si512(b_out.as_mut_ptr().add(ol).cast::<__m512i>(), ob);
            let (a0, a1, a2, a3) = (a_out[ol], a_out[ol + 1], a_out[ol + 2], a_out[ol + 3]);
            let (b0, b1, b2, b3) = (b_out[ol], b_out[ol + 1], b_out[ol + 2], b_out[ol + 3]);
            let wt = eq_lo[x_lo + 1];
            let (a0w, a1w, a2w, a3w) = (wt * a0, wt * a1, wt * a2, wt * a3);
            tail[0] ^= a1w.mul_unreduced(b1);
            tail[1] ^= (a0w + a1w).mul_unreduced(b0 + b1);
            tail[2] ^= a3w.mul_unreduced(b3);
            tail[3] ^= (a2w + a3w).mul_unreduced(b2 + b3);
            tail[4] ^= a2w.mul_unreduced(b2);
            let (e_aw, e_b) = (a0w + a2w, b0 + b2);
            let (o_aw, o_b) = (a1w + a3w, b1 + b3);
            tail[5] ^= e_aw.mul_unreduced(e_b);
            tail[6] ^= o_aw.mul_unreduced(o_b);
            tail[7] ^= (e_aw + o_aw).mul_unreduced(e_b + o_b);
            x_lo += 2;
        }

        if nt_out {
            _mm_sfence();
        }
        let mut out = [F128::ZERO; 8];
        for i in 0..8 {
            tail[i] ^= acc[i].fold();
            out[i] = tail[i].reduce();
        }
        out
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
pub(crate) fn build_row_fold_mats(data: &[F128]) -> [u64; 128] {
    debug_assert_eq!(data.len(), 8 * 256);
    let cols: [F128; 64] = std::array::from_fn(|i| {
        let byte = i / 8;
        let bit = i % 8;
        data[byte * 256 + (1 << bit)]
    });
    build_row_fold_mats_from_cols(&cols)
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
pub(crate) fn build_row_fold_mats_from_cols(cols: &[F128]) -> [u64; 128] {
    #[cfg(target_feature = "avx512bw")]
    {
        #[inline]
        #[target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")]
        unsafe fn inner(cols: &[F128]) -> [u64; 128] {
            debug_assert_eq!(cols.len(), 64);
            let mut mats = [0u64; 128];
            for j in 0..8 {
                let basis = &cols[j * 8..j * 8 + 8];
                unsafe {
                    crate::bits::transpose_8_f128_to_16_mats_swapped_gfni(
                        basis,
                        &mut mats[j * 16..j * 16 + 16],
                    );
                }
            }
            mats
        }
        return unsafe { inner(cols) };
    }
    #[cfg(not(target_feature = "avx512bw"))]
    {
        debug_assert_eq!(cols.len(), 64);
        let mut mats = [0u64; 128];
        for j in 0..8 {
            let basis = &cols[j * 8..j * 8 + 8];
            let lo_lanes: [u64; 8] = std::array::from_fn(|b| basis[b].lo);
            let hi_lanes: [u64; 8] = std::array::from_fn(|b| basis[b].hi);
            let mut lo_bytes = [0u8; 64];
            let mut hi_bytes = [0u8; 64];
            crate::bits::transpose_8_u64s_to_64_bytes(&lo_lanes, &mut lo_bytes);
            crate::bits::transpose_8_u64s_to_64_bytes(&hi_lanes, &mut hi_bytes);
            for c in 0..8 {
                let lo: [u8; 8] = lo_bytes[c * 8..c * 8 + 8].try_into().unwrap();
                let hi: [u8; 8] = hi_bytes[c * 8..c * 8 + 8].try_into().unwrap();
                mats[j * 16 + c] = u64::from_le_bytes(lo).swap_bytes();
                mats[j * 16 + c + 8] = u64::from_le_bytes(hi).swap_bytes();
            }
        }
        mats
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(not(test), allow(dead_code))]
pub(crate) unsafe fn gfni_fold64_rows(rows: *const u8, mats: &[u64; 128], out: *mut F128) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        for (i, slot) in z.iter_mut().enumerate() {
            *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
        }
        gfni_fold64_regs(z, mats, out);
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(never)]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_two_maps<const ADD: bool>(
    rows0: *const u8,
    mats0: &[u64; 128],
    rows1: *const u8,
    mats1: &[u64; 128],
    out: *mut F128,
    add: *const F128,
) {
    use core::arch::x86_64::*;
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr() as *const __m512i);
        let s2_lo = _mm512_setr_epi64(0, 1, 8, 9, 2, 3, 10, 11);
        let s2_hi = _mm512_setr_epi64(4, 5, 12, 13, 6, 7, 14, 15);
        let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
        let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);
        let qword_transpose = |t: [__m512i; 8]| -> [__m512i; 8] {
            let e01 = _mm512_unpacklo_epi64(t[0], t[1]);
            let o01 = _mm512_unpackhi_epi64(t[0], t[1]);
            let e23 = _mm512_unpacklo_epi64(t[2], t[3]);
            let o23 = _mm512_unpackhi_epi64(t[2], t[3]);
            let e45 = _mm512_unpacklo_epi64(t[4], t[5]);
            let o45 = _mm512_unpackhi_epi64(t[4], t[5]);
            let e67 = _mm512_unpacklo_epi64(t[6], t[7]);
            let o67 = _mm512_unpackhi_epi64(t[6], t[7]);
            let h02_a = _mm512_permutex2var_epi64(e01, s2_lo, e23);
            let h46_a = _mm512_permutex2var_epi64(e01, s2_hi, e23);
            let h13_a = _mm512_permutex2var_epi64(o01, s2_lo, o23);
            let h57_a = _mm512_permutex2var_epi64(o01, s2_hi, o23);
            let h02_b = _mm512_permutex2var_epi64(e45, s2_lo, e67);
            let h46_b = _mm512_permutex2var_epi64(e45, s2_hi, e67);
            let h13_b = _mm512_permutex2var_epi64(o45, s2_lo, o67);
            let h57_b = _mm512_permutex2var_epi64(o45, s2_hi, o67);
            [
                _mm512_permutex2var_epi64(h02_a, s3_lo, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_lo, h13_b),
                _mm512_permutex2var_epi64(h02_a, s3_hi, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_hi, h13_b),
                _mm512_permutex2var_epi64(h46_a, s3_lo, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_lo, h57_b),
                _mm512_permutex2var_epi64(h46_a, s3_hi, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_hi, h57_b),
            ]
        };
        let input_planes = |rows: *const u8| -> [__m512i; 8] {
            let z: [__m512i; 8] =
                core::array::from_fn(|i| _mm512_loadu_si512(rows.add(64 * i) as *const __m512i));
            let t = z.map(|v| _mm512_permutexvar_epi8(bt, v));
            qword_transpose(t)
        };
        let map_plane = |p: &[__m512i; 8], mats: &[u64; 128], k: usize| {
            let g = |j: usize| {
                _mm512_gf2p8affine_epi64_epi8::<0>(p[j], _mm512_set1_epi64(mats[j * 16 + k] as i64))
            };
            let v1 = _mm512_ternarylogic_epi64::<0x96>(g(0), g(1), g(2));
            let v2 = _mm512_ternarylogic_epi64::<0x96>(g(3), g(4), g(5));
            let v3 = _mm512_ternarylogic_epi64::<0x96>(g(6), g(7), v1);
            _mm512_xor_si512(v2, v3)
        };
        let p0 = input_planes(rows0);
        let p1 = input_planes(rows1);
        let map_pair = |k: usize| {
            _mm512_xor_si512(map_plane(&p0, mats0, k), map_plane(&p1, mats1, k))
        };
        let lo_half = qword_transpose([
            map_pair(0),
            map_pair(1),
            map_pair(2),
            map_pair(3),
            map_pair(4),
            map_pair(5),
            map_pair(6),
            map_pair(7),
        ])
        .map(|v| _mm512_permutexvar_epi8(bt, v));
        let hi_half = qword_transpose([
            map_pair(8),
            map_pair(9),
            map_pair(10),
            map_pair(11),
            map_pair(12),
            map_pair(13),
            map_pair(14),
            map_pair(15),
        ]);
        let il_lo = _mm512_setr_epi64(0, 8, 1, 9, 2, 10, 3, 11);
        let il_hi = _mm512_setr_epi64(4, 12, 5, 13, 6, 14, 7, 15);
        for i in 0..8 {
            let lo = lo_half[i];
            let hi = _mm512_permutexvar_epi8(bt, hi_half[i]);
            let mut v0 = _mm512_permutex2var_epi64(lo, il_lo, hi);
            let mut v1 = _mm512_permutex2var_epi64(lo, il_hi, hi);
            if ADD {
                v0 = _mm512_xor_si512(v0, _mm512_loadu_si512(add.add(8 * i) as *const __m512i));
                v1 = _mm512_xor_si512(v1, _mm512_loadu_si512(add.add(8 * i + 4) as *const __m512i));
            }
            let out_ptr = out.add(8 * i) as *mut __m512i;
            _mm512_storeu_si512(out_ptr, v0);
            _mm512_storeu_si512(out_ptr.add(1), v1);
        }
    }
}


#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_two_maps_to_mats(
    rows0: *const u8,
    mats0: &[u64; 128],
    rows1: *const u8,
    mats1: &[u64; 128],
    out: &mut [u64; 128],
) {
    use core::arch::x86_64::*;

    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast::<__m512i>());
        let s2_lo = _mm512_setr_epi64(0, 1, 8, 9, 2, 3, 10, 11);
        let s2_hi = _mm512_setr_epi64(4, 5, 12, 13, 6, 7, 14, 15);
        let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
        let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);
        let qword_transpose = |t: [__m512i; 8]| -> [__m512i; 8] {
            let e01 = _mm512_unpacklo_epi64(t[0], t[1]);
            let o01 = _mm512_unpackhi_epi64(t[0], t[1]);
            let e23 = _mm512_unpacklo_epi64(t[2], t[3]);
            let o23 = _mm512_unpackhi_epi64(t[2], t[3]);
            let e45 = _mm512_unpacklo_epi64(t[4], t[5]);
            let o45 = _mm512_unpackhi_epi64(t[4], t[5]);
            let e67 = _mm512_unpacklo_epi64(t[6], t[7]);
            let o67 = _mm512_unpackhi_epi64(t[6], t[7]);
            let h02_a = _mm512_permutex2var_epi64(e01, s2_lo, e23);
            let h46_a = _mm512_permutex2var_epi64(e01, s2_hi, e23);
            let h13_a = _mm512_permutex2var_epi64(o01, s2_lo, o23);
            let h57_a = _mm512_permutex2var_epi64(o01, s2_hi, o23);
            let h02_b = _mm512_permutex2var_epi64(e45, s2_lo, e67);
            let h46_b = _mm512_permutex2var_epi64(e45, s2_hi, e67);
            let h13_b = _mm512_permutex2var_epi64(o45, s2_lo, o67);
            let h57_b = _mm512_permutex2var_epi64(o45, s2_hi, o67);
            [
                _mm512_permutex2var_epi64(h02_a, s3_lo, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_lo, h13_b),
                _mm512_permutex2var_epi64(h02_a, s3_hi, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_hi, h13_b),
                _mm512_permutex2var_epi64(h46_a, s3_lo, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_lo, h57_b),
                _mm512_permutex2var_epi64(h46_a, s3_hi, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_hi, h57_b),
            ]
        };
        let input_planes = |rows: *const u8| -> [__m512i; 8] {
            let z: [__m512i; 8] =
                core::array::from_fn(|i| _mm512_loadu_si512(rows.add(64 * i).cast()));
            let t = z.map(|v| _mm512_permutexvar_epi8(bt, v));
            qword_transpose(t)
        };
        let map_plane = |p: &[__m512i; 8], mats: &[u64; 128], k: usize| {
            let g = |j: usize| {
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    p[j],
                    _mm512_set1_epi64(mats[j * 16 + k] as i64),
                )
            };
            let v1 = _mm512_ternarylogic_epi64::<0x96>(g(0), g(1), g(2));
            let v2 = _mm512_ternarylogic_epi64::<0x96>(g(3), g(4), g(5));
            let v3 = _mm512_ternarylogic_epi64::<0x96>(g(6), g(7), v1);
            _mm512_xor_si512(v2, v3)
        };

        #[rustfmt::skip]
        const I: [u8; 64] = [
            56, 48, 40, 32, 24, 16, 8, 0, 57, 49, 41, 33, 25, 17, 9, 1,
            58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3,
            60, 52, 44, 36, 28, 20, 12, 4, 61, 53, 45, 37, 29, 21, 13, 5,
            62, 54, 46, 38, 30, 22, 14, 6, 63, 55, 47, 39, 31, 23, 15, 7,
        ];
        #[rustfmt::skip]
        const BSWAP: [u8; 64] = [
            7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8,
            23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24,
            39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40,
            55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56,
        ];

        let p0 = input_planes(rows0);
        let p1 = input_planes(rows1);
        let perm_i = _mm512_loadu_si512(I.as_ptr().cast::<__m512i>());
        let bswap = _mm512_loadu_si512(BSWAP.as_ptr().cast::<__m512i>());
        let id = _mm512_set1_epi64(0x8040201008040201u64 as i64);
        let dst = out.as_mut_ptr().cast::<__m512i>();

        let acc_lo: [__m512i; 8] =
            core::array::from_fn(|k| _mm512_xor_si512(map_plane(&p0, mats0, k), map_plane(&p1, mats1, k)));
        let lo_half = qword_transpose(acc_lo);
        for group in 0..8 {
            let t_lo = _mm512_gf2p8affine_epi64_epi8::<0>(
                id,
                _mm512_permutexvar_epi8(perm_i, _mm512_permutexvar_epi8(bt, lo_half[group])),
            );
            _mm512_storeu_si512(dst.add(2 * group), _mm512_shuffle_epi8(t_lo, bswap));
        }

        let acc_hi: [__m512i; 8] =
            core::array::from_fn(|k| _mm512_xor_si512(map_plane(&p0, mats0, k + 8), map_plane(&p1, mats1, k + 8)));
        let hi_half = qword_transpose(acc_hi);
        for group in 0..8 {
            let t_hi = _mm512_gf2p8affine_epi64_epi8::<0>(
                id,
                _mm512_permutexvar_epi8(perm_i, _mm512_permutexvar_epi8(bt, hi_half[group])),
            );
            _mm512_storeu_si512(dst.add(2 * group + 1), _mm512_shuffle_epi8(t_hi, bswap));
        }
    }
}


#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_four_maps_staged(
    rows0: *const u8,
    mats0: &[u64; 128],
    rows1: *const u8,
    mats1: &[u64; 128],
    rows2: *const u8,
    mats2: &[u64; 128],
    rows3: *const u8,
    mats3: &[u64; 128],
    out: *mut F128,
    planes: *mut core::arch::x86_64::__m512i,
) {
    use core::arch::x86_64::*;
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast());
        let s2_lo = _mm512_setr_epi64(0, 1, 8, 9, 2, 3, 10, 11);
        let s2_hi = _mm512_setr_epi64(4, 5, 12, 13, 6, 7, 14, 15);
        let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
        let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);
        let qword_transpose = |t: [__m512i; 8]| -> [__m512i; 8] {
            let e01 = _mm512_unpacklo_epi64(t[0], t[1]);
            let o01 = _mm512_unpackhi_epi64(t[0], t[1]);
            let e23 = _mm512_unpacklo_epi64(t[2], t[3]);
            let o23 = _mm512_unpackhi_epi64(t[2], t[3]);
            let e45 = _mm512_unpacklo_epi64(t[4], t[5]);
            let o45 = _mm512_unpackhi_epi64(t[4], t[5]);
            let e67 = _mm512_unpacklo_epi64(t[6], t[7]);
            let o67 = _mm512_unpackhi_epi64(t[6], t[7]);
            let h02_a = _mm512_permutex2var_epi64(e01, s2_lo, e23);
            let h46_a = _mm512_permutex2var_epi64(e01, s2_hi, e23);
            let h13_a = _mm512_permutex2var_epi64(o01, s2_lo, o23);
            let h57_a = _mm512_permutex2var_epi64(o01, s2_hi, o23);
            let h02_b = _mm512_permutex2var_epi64(e45, s2_lo, e67);
            let h46_b = _mm512_permutex2var_epi64(e45, s2_hi, e67);
            let h13_b = _mm512_permutex2var_epi64(o45, s2_lo, o67);
            let h57_b = _mm512_permutex2var_epi64(o45, s2_hi, o67);
            [
                _mm512_permutex2var_epi64(h02_a, s3_lo, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_lo, h13_b),
                _mm512_permutex2var_epi64(h02_a, s3_hi, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_hi, h13_b),
                _mm512_permutex2var_epi64(h46_a, s3_lo, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_lo, h57_b),
                _mm512_permutex2var_epi64(h46_a, s3_hi, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_hi, h57_b),
            ]
        };
        let input_planes = |rows: *const u8| -> [__m512i; 8] {
            let z: [__m512i; 8] =
                core::array::from_fn(|i| _mm512_loadu_si512(rows.add(64 * i).cast()));
            qword_transpose(z.map(|v| _mm512_permutexvar_epi8(bt, v)))
        };
        let map_plane = |p: &[__m512i; 8], mats: &[u64; 128], k: usize| {
            let g = |j: usize| {
                _mm512_gf2p8affine_epi64_epi8::<0>(p[j], _mm512_set1_epi64(mats[j * 16 + k] as i64))
            };
            let v1 = _mm512_ternarylogic_epi64::<0x96>(g(0), g(1), g(2));
            let v2 = _mm512_ternarylogic_epi64::<0x96>(g(3), g(4), g(5));
            let v3 = _mm512_ternarylogic_epi64::<0x96>(g(6), g(7), v1);
            _mm512_xor_si512(v2, v3)
        };

        {
            let p0 = input_planes(rows0);
            let p1 = input_planes(rows1);
            for k in 0..16 {
                let value = _mm512_xor_si512(map_plane(&p0, mats0, k), map_plane(&p1, mats1, k));
                _mm512_storeu_si512(planes.add(k), value);
            }
        }
        {
            let p2 = input_planes(rows2);
            let p3 = input_planes(rows3);
            for k in 0..16 {
                let value = _mm512_xor_si512(map_plane(&p2, mats2, k), map_plane(&p3, mats3, k));
                let value = _mm512_xor_si512(value, _mm512_loadu_si512(planes.add(k)));
                _mm512_storeu_si512(planes.add(k), value);
            }
        }

        let acc: [__m512i; 16] = core::array::from_fn(|k| _mm512_loadu_si512(planes.add(k)));
        let lo_half = qword_transpose(acc[..8].try_into().unwrap());
        let hi_half = qword_transpose(acc[8..].try_into().unwrap());
        let il_lo = _mm512_setr_epi64(0, 8, 1, 9, 2, 10, 3, 11);
        let il_hi = _mm512_setr_epi64(4, 12, 5, 13, 6, 14, 7, 15);
        for i in 0..8 {
            let lo = _mm512_permutexvar_epi8(bt, lo_half[i]);
            let hi = _mm512_permutexvar_epi8(bt, hi_half[i]);
            let v0 = _mm512_permutex2var_epi64(lo, il_lo, hi);
            let v1 = _mm512_permutex2var_epi64(lo, il_hi, hi);
            let out_ptr = out.add(8 * i).cast::<__m512i>();
            _mm512_storeu_si512(out_ptr, v0);
            _mm512_storeu_si512(out_ptr.add(1), v1);
        }
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }
        gfni_fold64_regs(z, mats, out);
    }
}

#[cfg(all(target_feature = "avx512vbmi", target_feature = "vpclmulqdq"))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_tr(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }
        gfni_fold64_regs_sigma(z, mats, out);
    }
}

#[cfg(all(target_feature = "avx512vbmi", target_feature = "vpclmulqdq"))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_tr_bcast(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }
        gfni_fold64_regs_sigma_bcast(z, mats, out);
    }
}

#[cfg(all(target_feature = "avx512vbmi", target_feature = "vpclmulqdq"))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_tr_bcast4(
    rows: *const u8,
    mats4: *const u64,
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }
        gfni_fold64_regs_sigma_bcast_gen::<true>(z, mats4, out);
    }
}

#[repr(C, align(64))]
struct FoldCache([F128; 64]);

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[repr(C, align(64))]
pub(crate) struct CFoldMats(pub(crate) [[u64; 8]; 128], pub(crate) [[u64; 8]; 64]);

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[allow(dead_code)]
pub(crate) fn build_row_fold_mats_scaled(data: &[F128], c: F128) -> [u64; 128] {
    debug_assert_eq!(data.len(), 8 * 256);
    let mut mats = [0u64; 128];
    for j in 0..8 {
        let basis: [F128; 8] = std::array::from_fn(|bit| c * data[j * 256 + (1 << bit)]);
        for k in 0..16 {
            let mut qword = 0u64;
            for i in 0..8 {
                let bit_index = 8 * k + i;
                let mut row = 0u8;
                for (b, basis_val) in basis.iter().enumerate() {
                    let bit = if bit_index < 64 {
                        (basis_val.lo >> bit_index) & 1
                    } else {
                        (basis_val.hi >> (bit_index - 64)) & 1
                    };
                    row |= (bit as u8) << b;
                }
                qword |= (row as u64) << (8 * (7 - i));
            }
            mats[j * 16 + k] = qword;
        }
    }
    mats
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[allow(dead_code)]
pub(crate) fn build_cfold_mats(data: &[F128], coeffs: [F128; 4]) -> CFoldMats {
    build_cfold_mats_ext(data, coeffs, !zc_r34_bcast_enabled())
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
#[allow(dead_code)]
pub(crate) fn build_cfold_mats_ext(
    data: &[F128],
    coeffs: [F128; 4],
    include_plane: bool,
) -> CFoldMats {
    #[cfg(all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    ))]
    {
        #[inline]
        #[target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")]
        unsafe fn inner(data: &[F128], coeffs: [F128; 4], include_plane: bool) -> CFoldMats {
            fn cfold_mats_fast_enabled() -> bool {
                static ON: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
                    std::env::var_os("FLOCK_NO_ZC_CFOLD_MATS_FAST").is_none()
                });
                *ON
            }
            let per: [[u64; 128]; 4] = if cfold_mats_fast_enabled() {
                let base_cols: [F128; 64] =
                    std::array::from_fn(|i| data[(i / 8) * 256 + (1usize << (i % 8))]);
                std::array::from_fn(|c| {
                    let cols: [F128; 64] = std::array::from_fn(|i| coeffs[c] * base_cols[i]);
                    build_row_fold_mats_from_cols(&cols)
                })
            } else {
                std::array::from_fn(|c| build_row_fold_mats_scaled(data, coeffs[c]))
            };
            let mut out = CFoldMats([[0u64; 8]; 128], [[0u64; 8]; 64]);
            if include_plane {
                for idx in 0..128 {
                    for i in 0..8 {
                        out.0[idx][i] = per[i / 2][idx];
                    }
                }
            }
            for a in 0..4 {
                for j in 0..8 {
                    out.1[8 * a + j].copy_from_slice(&per[a][16 * j..16 * j + 8]);
                    out.1[32 + 8 * a + j].copy_from_slice(&per[a][16 * j + 8..16 * j + 16]);
                }
            }
            out
        }
        return unsafe { inner(data, coeffs, include_plane) };
    }
    #[cfg(not(all(
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni"
    )))]
    {
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        fn cfold_mats_fast_enabled() -> bool {
            static ON: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
                std::env::var_os("FLOCK_NO_ZC_CFOLD_MATS_FAST").is_none()
            });
            *ON
        }
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "gfni"))]
        let per: [[u64; 128]; 4] = if cfold_mats_fast_enabled() {
            let base_cols: [F128; 64] =
                std::array::from_fn(|i| data[(i / 8) * 256 + (1usize << (i % 8))]);
            std::array::from_fn(|c| {
                let cols: [F128; 64] = std::array::from_fn(|i| coeffs[c] * base_cols[i]);
                build_row_fold_mats_from_cols(&cols)
            })
        } else {
            std::array::from_fn(|c| build_row_fold_mats_scaled(data, coeffs[c]))
        };
        #[cfg(not(all(target_feature = "avx512vbmi", target_feature = "gfni")))]
        let per: [[u64; 128]; 4] =
            std::array::from_fn(|c| build_row_fold_mats_scaled(data, coeffs[c]));
        let mut out = CFoldMats([[0u64; 8]; 128], [[0u64; 8]; 64]);
        if include_plane {
            for idx in 0..128 {
                for i in 0..8 {
                    out.0[idx][i] = per[i / 2][idx];
                }
            }
        }
        for a in 0..4 {
            for j in 0..8 {
                out.1[8 * a + j].copy_from_slice(&per[a][16 * j..16 * j + 8]);
                out.1[32 + 8 * a + j].copy_from_slice(&per[a][16 * j + 8..16 * j + 16]);
            }
        }
        out
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[rustfmt::skip]
const SIGMA_C4: [i8; 64] = [
     0,  4,  8, 12, 16, 20, 24, 28,
    32, 36, 40, 44, 48, 52, 56, 60,
     1,  5,  9, 13, 17, 21, 25, 29,
    33, 37, 41, 45, 49, 53, 57, 61,
     2,  6, 10, 14, 18, 22, 26, 30,
    34, 38, 42, 46, 50, 54, 58, 62,
     3,  7, 11, 15, 19, 23, 27, 31,
    35, 39, 43, 47, 51, 55, 59, 63,
];

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_c4(
    rows: *const u8,
    m: &CFoldMats,
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }

        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr() as *const __m512i);
        let sigma = _mm512_loadu_si512(SIGMA_C4.as_ptr() as *const __m512i);
        let s2_lo = _mm512_setr_epi64(0, 1, 8, 9, 2, 3, 10, 11);
        let s2_hi = _mm512_setr_epi64(4, 5, 12, 13, 6, 7, 14, 15);
        let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
        let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);

        let qword_transpose = |t: [__m512i; 8]| -> [__m512i; 8] {
            let e01 = _mm512_unpacklo_epi64(t[0], t[1]);
            let o01 = _mm512_unpackhi_epi64(t[0], t[1]);
            let e23 = _mm512_unpacklo_epi64(t[2], t[3]);
            let o23 = _mm512_unpackhi_epi64(t[2], t[3]);
            let e45 = _mm512_unpacklo_epi64(t[4], t[5]);
            let o45 = _mm512_unpackhi_epi64(t[4], t[5]);
            let e67 = _mm512_unpacklo_epi64(t[6], t[7]);
            let o67 = _mm512_unpackhi_epi64(t[6], t[7]);
            let h02_a = _mm512_permutex2var_epi64(e01, s2_lo, e23);
            let h46_a = _mm512_permutex2var_epi64(e01, s2_hi, e23);
            let h13_a = _mm512_permutex2var_epi64(o01, s2_lo, o23);
            let h57_a = _mm512_permutex2var_epi64(o01, s2_hi, o23);
            let h02_b = _mm512_permutex2var_epi64(e45, s2_lo, e67);
            let h46_b = _mm512_permutex2var_epi64(e45, s2_hi, e67);
            let h13_b = _mm512_permutex2var_epi64(o45, s2_lo, o67);
            let h57_b = _mm512_permutex2var_epi64(o45, s2_hi, o67);
            [
                _mm512_permutex2var_epi64(h02_a, s3_lo, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_lo, h13_b),
                _mm512_permutex2var_epi64(h02_a, s3_hi, h02_b),
                _mm512_permutex2var_epi64(h13_a, s3_hi, h13_b),
                _mm512_permutex2var_epi64(h46_a, s3_lo, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_lo, h57_b),
                _mm512_permutex2var_epi64(h46_a, s3_hi, h46_b),
                _mm512_permutex2var_epi64(h57_a, s3_hi, h57_b),
            ]
        };

        let mut t = [_mm512_setzero_si512(); 8];
        for (i, slot) in t.iter_mut().enumerate() {
            *slot = _mm512_permutexvar_epi8(bt, z[i]);
        }
        let p = qword_transpose(t);
        let mut pc = [_mm512_setzero_si512(); 8];
        for (j, slot) in pc.iter_mut().enumerate() {
            *slot = _mm512_permutexvar_epi8(sigma, p[j]);
        }

        let plane = |k: usize| {
            let g = |j: usize| {
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    pc[j],
                    _mm512_loadu_si512(m.0[j * 16 + k].as_ptr() as *const __m512i),
                )
            };
            let v1 = _mm512_ternarylogic_epi64::<0x96>(g(0), g(1), g(2));
            let v2 = _mm512_ternarylogic_epi64::<0x96>(g(3), g(4), g(5));
            let v3 = _mm512_ternarylogic_epi64::<0x96>(g(6), g(7), v1);
            _mm512_xor_si512(v2, v3)
        };

        let pair = |a: __m512i, b: __m512i| -> __m512i {
            _mm512_xor_si512(
                _mm512_permutex2var_epi64(a, s2_lo, b),
                _mm512_permutex2var_epi64(a, s2_hi, b),
            )
        };
        let q_lo = _mm512_setr_epi64(0, 2, 8, 10, 1, 3, 9, 11);
        let q_hi = _mm512_setr_epi64(4, 6, 12, 14, 5, 7, 13, 15);
        let quad = |a: __m512i, b: __m512i, c: __m512i, d: __m512i| -> __m512i {
            let z0 = pair(a, b);
            let z1 = pair(c, d);
            _mm512_xor_si512(
                _mm512_permutex2var_epi64(z0, q_lo, z1),
                _mm512_permutex2var_epi64(z0, q_hi, z1),
            )
        };
        let w0 = quad(plane(0), plane(1), plane(2), plane(3));
        let w1 = quad(plane(4), plane(5), plane(6), plane(7));
        let w2 = quad(plane(8), plane(9), plane(10), plane(11));
        let w3 = quad(plane(12), plane(13), plane(14), plane(15));
        let il_lo = _mm512_setr_epi64(0, 8, 1, 9, 2, 10, 3, 11);
        let il_hi = _mm512_setr_epi64(4, 12, 5, 13, 6, 14, 7, 15);
        let lo_even = _mm512_permutexvar_epi8(bt, _mm512_permutex2var_epi64(w0, s3_lo, w1));
        let lo_odd = _mm512_permutexvar_epi8(bt, _mm512_permutex2var_epi64(w0, s3_hi, w1));
        let hi_even = _mm512_permutexvar_epi8(bt, _mm512_permutex2var_epi64(w2, s3_lo, w3));
        let hi_odd = _mm512_permutexvar_epi8(bt, _mm512_permutex2var_epi64(w2, s3_hi, w3));
        let out_ptr = out as *mut __m512i;
        _mm512_storeu_si512(out_ptr, _mm512_permutex2var_epi64(lo_even, il_lo, hi_even));
        _mm512_storeu_si512(
            out_ptr.add(1),
            _mm512_permutex2var_epi64(lo_even, il_hi, hi_even),
        );
        _mm512_storeu_si512(
            out_ptr.add(2),
            _mm512_permutex2var_epi64(lo_odd, il_lo, hi_odd),
        );
        _mm512_storeu_si512(
            out_ptr.add(3),
            _mm512_permutex2var_epi64(lo_odd, il_hi, hi_odd),
        );
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(never)]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_c4_bcast(
    rows: *const u8,
    m: &CFoldMats,
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }

        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr() as *const __m512i);
        #[repr(C, align(64))]
        struct Octs([u64; 64]);
        let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
        let op = octs.as_mut_ptr().cast::<u64>();

        let gather = |h: usize, s0: __m512i, s1: __m512i, s2: __m512i, s3: __m512i| {
            let g1_lo = _mm512_setr_epi64(0, 4, 8, 12, 1, 5, 9, 13);
            let g1_hi = _mm512_setr_epi64(2, 6, 10, 14, 3, 7, 11, 15);
            let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
            let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);
            let p01 = _mm512_permutex2var_epi64(s0, g1_lo, s1);
            let p23 = _mm512_permutex2var_epi64(s0, g1_hi, s1);
            let p45 = _mm512_permutex2var_epi64(s2, g1_lo, s3);
            let p67 = _mm512_permutex2var_epi64(s2, g1_hi, s3);
            let base = op.add(32 * h);
            let oct = |a: usize, v: __m512i| {
                _mm512_storeu_si512(
                    base.add(8 * a) as *mut __m512i,
                    _mm512_permutexvar_epi8(bt, v),
                )
            };
            oct(0, _mm512_permutex2var_epi64(p01, s3_lo, p45));
            oct(1, _mm512_permutex2var_epi64(p01, s3_hi, p45));
            oct(2, _mm512_permutex2var_epi64(p23, s3_lo, p67));
            oct(3, _mm512_permutex2var_epi64(p23, s3_hi, p67));
        };
        gather(0, z[0], z[1], z[2], z[3]);
        gather(1, z[4], z[5], z[6], z[7]);

        let rp: *const u64 = core::hint::black_box(op as *const u64);
        let mp = m.1.as_ptr() as *const u64;
        let dst = out as *mut __m512i;

        macro_rules! pass {
            ($h:expr) => {{
                const H: usize = $h;
                let mp = core::hint::black_box(mp);
                let mut accp = [_mm512_setzero_si512(); 2];
                let mut accq = [_mm512_setzero_si512(); 2];
                for a in 0..4usize {
                    let b: [__m512i; 8] = core::array::from_fn(|j| {
                        _mm512_set1_epi64(*rp.add(32 * H + 8 * a + j) as i64)
                    });
                    let f: [[__m512i; 8]; 2] = core::array::from_fn(|hh| {
                        core::array::from_fn(|j| {
                            _mm512_gf2p8affine_epi64_epi8::<0>(
                                b[j],
                                _mm512_loadu_si512(
                                    mp.add(8 * (32 * hh + 8 * a + j)) as *const __m512i
                                ),
                            )
                        })
                    });
                    for hh in 0..2usize {
                        let g = f[hh];
                        let v1 = _mm512_ternarylogic_epi64::<0x96>(g[0], g[1], g[2]);
                        let v2 = _mm512_ternarylogic_epi64::<0x96>(g[3], g[4], g[5]);
                        let v3 = _mm512_ternarylogic_epi64::<0x96>(g[6], g[7], v1);
                        if a == 0 {
                            accp[hh] = v2;
                            accq[hh] = v3;
                        } else {
                            accp[hh] = _mm512_ternarylogic_epi64::<0x96>(accp[hh], accq[hh], v2);
                            accq[hh] = v3;
                        }
                    }
                }
                let il_lo = _mm512_setr_epi64(0, 8, 1, 9, 2, 10, 3, 11);
                let il_hi = _mm512_setr_epi64(4, 12, 5, 13, 6, 14, 7, 15);
                let a0 = _mm512_permutexvar_epi8(bt, _mm512_xor_si512(accp[0], accq[0]));
                let a1 = _mm512_permutexvar_epi8(bt, _mm512_xor_si512(accp[1], accq[1]));
                _mm512_storeu_si512(dst.add(2 * H), _mm512_permutex2var_epi64(a0, il_lo, a1));
                _mm512_storeu_si512(dst.add(2 * H + 1), _mm512_permutex2var_epi64(a0, il_hi, a1));
            }};
        }
        pass!(0);
        pass!(1);
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const fn c4_lm_octet_index(base: usize) -> [i8; 64] {
    let mut idx = [0i8; 64];
    let mut j = 0;
    while j < 8 {
        let mut s = 0;
        while s < 8 {
            let src = if s < 4 {
                8 * (base + s) + j
            } else {
                64 + 8 * (base + s - 4) + j
            };
            idx[8 * j + s] = src as i8;
            s += 1;
        }
        j += 1;
    }
    idx
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const fn c4_lm_output_index(parity: usize) -> [i8; 64] {
    let mut idx = [0i8; 64];
    let mut u = 0;
    while u < 4 {
        let slot = 2 * u + parity;
        let mut k = 0;
        while k < 8 {
            idx[16 * u + k] = (8 * k + slot) as i8;
            idx[16 * u + 8 + k] = (64 + 8 * k + slot) as i8;
            k += 1;
        }
        u += 1;
    }
    idx
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const C4_LM_OCT_EVEN: [i8; 64] = c4_lm_octet_index(0);
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const C4_LM_OCT_ODD: [i8; 64] = c4_lm_octet_index(4);
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const C4_LM_OUT_EVEN: [i8; 64] = c4_lm_output_index(0);
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
const C4_LM_OUT_ODD: [i8; 64] = c4_lm_output_index(1);

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
core::arch::global_asm!(
    include_str!("gfni_c4_lm.S"),
    include_str!("gfni_c4_register_result.S"),
);

#[cfg(all(
    target_os = "linux",
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
unsafe extern "C" {
    fn flock_gfni_c4_lm_preserving();
    fn flock_gfni_c4_lm_register_result();
}


#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(always)]
unsafe fn gfni_fold64_rows_c4_lm_registers(
    rows: *const u8,
    m: &CFoldMats,
) -> [core::arch::x86_64::__m512i; 4] {
    use core::arch::x86_64::*;
    #[cfg(target_os = "linux")]
    unsafe {
        let a: __m512i;
        let b: __m512i;
        let c: __m512i;
        let d: __m512i;
        core::arch::asm!(
            "call {kernel}",
            kernel = sym flock_gfni_c4_lm_register_result,
            in("rdi") rows,
            in("rsi") m.1.as_ptr(),
            lateout("rax") _,
            out("zmm0") _, out("zmm1") _, out("zmm2") _, out("zmm3") _,
            out("zmm4") _, out("zmm5") _, out("zmm6") _, out("zmm7") _,
            out("zmm8") a, out("zmm9") b, out("zmm10") c, out("zmm11") d,
        );
        [a, b, c, d]
    }
    #[cfg(not(target_os = "linux"))]
    unsafe {
        let mut result = [_mm512_setzero_si512(); 4];
        gfni_fold64_rows_masked_c4_bcast_lm_rust(rows, m, result.as_mut_ptr().cast(), 0);
        result
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_masked_c4_bcast_lm(
    rows: *const u8,
    m: &CFoldMats,
    out: *mut F128,
    dead_lines: u8,
) {
    #[cfg(target_os = "linux")]
    if dead_lines == 0 {
        unsafe {
            core::arch::asm!(
                "call {kernel}",
                kernel = sym flock_gfni_c4_lm_preserving,
                in("rdi") rows,
                in("rsi") m.1.as_ptr(),
                in("rdx") out,
                lateout("rax") _,
                out("zmm0") _,
                out("zmm1") _,
                out("zmm2") _,
                out("zmm3") _,
                out("zmm4") _,
                out("zmm5") _,
                out("zmm6") _,
                out("zmm7") _,
                out("zmm8") _,
                out("zmm9") _,
                out("zmm10") _,
                out("zmm11") _,
            );
        }
        return;
    }
    unsafe { gfni_fold64_rows_masked_c4_bcast_lm_rust(rows, m, out, dead_lines) }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(never)]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_rows_masked_c4_bcast_lm_rust(
    rows: *const u8,
    m: &CFoldMats,
    out: *mut F128,
    dead_lines: u8,
) {
    use core::arch::x86_64::*;
    unsafe {
        let mut z = [_mm512_setzero_si512(); 8];
        if dead_lines == 0 {
            for (i, slot) in z.iter_mut().enumerate() {
                *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
            }
        } else {
            for (i, slot) in z.iter_mut().enumerate() {
                if dead_lines & (1u8 << i) == 0 {
                    *slot = _mm512_loadu_si512(rows.add(64 * i) as *const __m512i);
                }
            }
        }

        #[repr(C, align(64))]
        struct Octs([u64; 64]);
        let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
        let op = octs.as_mut_ptr().cast::<u64>();
        let oct_even = _mm512_loadu_si512(C4_LM_OCT_EVEN.as_ptr() as *const __m512i);
        let oct_odd = _mm512_loadu_si512(C4_LM_OCT_ODD.as_ptr() as *const __m512i);

        let gather = |p: usize, s0: __m512i, s1: __m512i, s2: __m512i, s3: __m512i| {
            let g1_lo = _mm512_setr_epi64(0, 4, 8, 12, 1, 5, 9, 13);
            let g1_hi = _mm512_setr_epi64(2, 6, 10, 14, 3, 7, 11, 15);
            let p01 = _mm512_permutex2var_epi64(s0, g1_lo, s1);
            let p23 = _mm512_permutex2var_epi64(s0, g1_hi, s1);
            let p45 = _mm512_permutex2var_epi64(s2, g1_lo, s3);
            let p67 = _mm512_permutex2var_epi64(s2, g1_hi, s3);
            let base = op.add(32 * p);
            let oct = |a: usize, v: __m512i| {
                _mm512_storeu_si512(base.add(8 * a) as *mut __m512i, v)
            };
            oct(0, _mm512_permutex2var_epi8(p01, oct_even, p45));
            oct(1, _mm512_permutex2var_epi8(p01, oct_odd, p45));
            oct(2, _mm512_permutex2var_epi8(p23, oct_even, p67));
            oct(3, _mm512_permutex2var_epi8(p23, oct_odd, p67));
        };
        gather(0, z[0], z[2], z[4], z[6]);
        gather(1, z[1], z[3], z[5], z[7]);

        let rp: *const u64 = core::hint::black_box(op as *const u64);
        let mp = m.1.as_ptr() as *const u64;
        let dst = out as *mut __m512i;
        let out_even = _mm512_loadu_si512(C4_LM_OUT_EVEN.as_ptr() as *const __m512i);
        let out_odd = _mm512_loadu_si512(C4_LM_OUT_ODD.as_ptr() as *const __m512i);

        macro_rules! pass {
            ($p:expr) => {{
                const P: usize = $p;
                let mp = core::hint::black_box(mp);
                let mut accp = [_mm512_setzero_si512(); 2];
                let mut accq = [_mm512_setzero_si512(); 2];
                for a in 0..4usize {
                    let b: [__m512i; 8] = core::array::from_fn(|j| {
                        _mm512_set1_epi64(*rp.add(32 * P + 8 * a + j) as i64)
                    });
                    let f: [[__m512i; 8]; 2] = core::array::from_fn(|hh| {
                        core::array::from_fn(|j| {
                            _mm512_gf2p8affine_epi64_epi8::<0>(
                                b[j],
                                _mm512_loadu_si512(
                                    mp.add(8 * (32 * hh + 8 * a + j)) as *const __m512i
                                ),
                            )
                        })
                    });
                    for hh in 0..2usize {
                        let g = f[hh];
                        let v1 = _mm512_ternarylogic_epi64::<0x96>(g[0], g[1], g[2]);
                        let v2 = _mm512_ternarylogic_epi64::<0x96>(g[3], g[4], g[5]);
                        let v3 = _mm512_ternarylogic_epi64::<0x96>(g[6], g[7], v1);
                        if a == 0 {
                            accp[hh] = v2;
                            accq[hh] = v3;
                        } else {
                            accp[hh] = _mm512_ternarylogic_epi64::<0x96>(accp[hh], accq[hh], v2);
                            accq[hh] = v3;
                        }
                    }
                }
                let r0 = _mm512_xor_si512(accp[0], accq[0]);
                let r1 = _mm512_xor_si512(accp[1], accq[1]);
                _mm512_storeu_si512(dst.add(2 * P), _mm512_permutex2var_epi8(r0, out_even, r1));
                _mm512_storeu_si512(dst.add(2 * P + 1), _mm512_permutex2var_epi8(r0, out_odd, r1));
            }};
        }
        pass!(0);
        pass!(1);
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_regs(
    z: [core::arch::x86_64::__m512i; 8],
    mats: &[u64; 128],
    out: *mut F128,
) {
    unsafe { gfni_fold64_regs_impl::<false>(z, mats, out) }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_regs_sigma(
    z: [core::arch::x86_64::__m512i; 8],
    mats: &[u64; 128],
    out: *mut F128,
) {
    unsafe { gfni_fold64_regs_impl::<true>(z, mats, out) }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "gfni"
))]
#[target_feature(enable = "avx512f,gfni")]
#[inline]
unsafe fn gfni_fold64_regs_impl<const SIGMA: bool>(
    z: [core::arch::x86_64::__m512i; 8],
    mats: &[u64; 128],
    out: *mut F128,
) {
    use core::arch::x86_64::*;
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr() as *const __m512i);
        let s2_lo = _mm512_setr_epi64(0, 1, 8, 9, 2, 3, 10, 11);
        let s2_hi = _mm512_setr_epi64(4, 5, 12, 13, 6, 7, 14, 15);
        let s3_lo = _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11);
        let s3_hi = _mm512_setr_epi64(4, 5, 6, 7, 12, 13, 14, 15);

        let qword_transpose = |t: [__m512i; 8]| -> [__m512i; 8] {
            let e01 = _mm512_unpacklo_epi64(t[0], t[1]);
            let o01 = _mm512_unpackhi_epi64(t[0], t[1]);
            let e23 = _mm512_unpacklo_epi64(t[2], t[3]);
            let o23 = _mm512_unpackhi_epi64(t[2], t[3]);
            let e45 = _mm512_unpacklo_epi64(t[4], t[5]);
            let o45 = _mm512_unpackhi_epi64(t[4], t[5]);
            let e67 = _mm512_unpacklo_epi64(t[6], t[7]);
            let o67 = _mm512_unpackhi_epi64(t[6], t[7]);
            let h02_a = _mm512_permutex2var_epi64(e01, s2_lo, e23);
            let h46_a = _mm512_permutex2var_epi64(e01, s2_hi, e23);
            let h13_a = _mm512_permutex2var_epi64(o01, s2_lo, o23);
            let h57_a = _mm512_permutex2var_epi64(o01, s2_hi, o23);
            let h02_b = _mm512_permutex2var_epi64(e45, s2_lo, e67);
            let h46_b = _mm512_permutex2var_epi64(e45, s2_hi, e67);
            let h13_b = _mm512_permutex2var_epi64(o45, s2_lo, o67);
            let h57_b = _mm512_permutex2var_epi64(o45, s2_hi, o67);
            [
                _mm512_permutex2var_epi64(h02_a, s3_lo, h02_b), // plane 0
                _mm512_permutex2var_epi64(h13_a, s3_lo, h13_b), // plane 1
                _mm512_permutex2var_epi64(h02_a, s3_hi, h02_b), // plane 2
                _mm512_permutex2var_epi64(h13_a, s3_hi, h13_b), // plane 3
                _mm512_permutex2var_epi64(h46_a, s3_lo, h46_b), // plane 4
                _mm512_permutex2var_epi64(h57_a, s3_lo, h57_b), // plane 5
                _mm512_permutex2var_epi64(h46_a, s3_hi, h46_b), // plane 6
                _mm512_permutex2var_epi64(h57_a, s3_hi, h57_b), // plane 7
            ]
        };

        let mut t = [_mm512_setzero_si512(); 8];
        for (i, slot) in t.iter_mut().enumerate() {
            *slot = _mm512_permutexvar_epi8(bt, z[i]);
        }
        let mut p = qword_transpose(t);
        #[cfg(all(target_feature = "avx512vbmi", target_feature = "vpclmulqdq"))]
        if SIGMA {
            let sigma = _mm512_loadu_si512(SIGMA_C4.as_ptr() as *const __m512i);
            for slot in p.iter_mut() {
                *slot = _mm512_permutexvar_epi8(sigma, *slot);
            }
        }

        let plane = |k: usize| {
            let g = |j: usize| {
                _mm512_gf2p8affine_epi64_epi8::<0>(p[j], _mm512_set1_epi64(mats[j * 16 + k] as i64))
            };
            let v1 = _mm512_ternarylogic_epi64::<0x96>(g(0), g(1), g(2));
            let v2 = _mm512_ternarylogic_epi64::<0x96>(g(3), g(4), g(5));
            let v3 = _mm512_ternarylogic_epi64::<0x96>(g(6), g(7), v1);
            _mm512_xor_si512(v2, v3)
        };

        let lo_half = qword_transpose([
            plane(0),
            plane(1),
            plane(2),
            plane(3),
            plane(4),
            plane(5),
            plane(6),
            plane(7),
        ]);
        let hi_half = qword_transpose([
            plane(8),
            plane(9),
            plane(10),
            plane(11),
            plane(12),
            plane(13),
            plane(14),
            plane(15),
        ]);
        let il_lo = _mm512_setr_epi64(0, 8, 1, 9, 2, 10, 3, 11);
        let il_hi = _mm512_setr_epi64(4, 12, 5, 13, 6, 14, 7, 15);
        for i in 0..8 {
            let lo = _mm512_permutexvar_epi8(bt, lo_half[i]);
            let hi = _mm512_permutexvar_epi8(bt, hi_half[i]);
            let out_ptr = (out as *mut u8).add(128 * i) as *mut __m512i;
            _mm512_storeu_si512(out_ptr, _mm512_permutex2var_epi64(lo, il_lo, hi));
            _mm512_storeu_si512(out_ptr.add(1), _mm512_permutex2var_epi64(lo, il_hi, hi));
        }
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_regs_sigma_bcast(
    z: [core::arch::x86_64::__m512i; 8],
    mats: &[u64; 128],
    out: *mut F128,
) {
    unsafe { gfni_fold64_regs_sigma_bcast_gen::<false>(z, mats.as_ptr(), out) }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_regs_sigma_bcast_gen<const MULTI: bool>(
    z: [core::arch::x86_64::__m512i; 8],
    mats: *const u64,
    out: *mut F128,
) {
    use core::arch::x86_64::*;
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr() as *const __m512i);
        #[repr(C, align(64))]
        struct Octs([u64; 64]);
        let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
        let op = octs.as_mut_ptr().cast::<u64>();
        for (i, zi) in z.iter().enumerate() {
            _mm512_storeu_si512(
                op.add(8 * i) as *mut __m512i,
                _mm512_permutexvar_epi8(bt, *zi),
            );
        }
        let mp = mats;
        let p01 = _mm512_setr_epi64(0, 8, 4, 12, 1, 9, 5, 13);
        let p23 = _mm512_setr_epi64(2, 10, 6, 14, 3, 11, 7, 15);
        for g in 0..4 {
            let mut a01 = [_mm512_setzero_si512(); 2];
            let mut a23 = [_mm512_setzero_si512(); 2];
            for half in 0..2 {
                let i = 2 * g + half;
                let b: [__m512i; 8] =
                    core::array::from_fn(|j| _mm512_set1_epi64(*op.add(8 * i + j) as i64));
                let mi = if MULTI { mp.add(128 * (i >> 1)) } else { mp };
                let plane = |h: usize| {
                    let aff = |j: usize| {
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            b[j],
                            _mm512_loadu_si512(mi.add(16 * j + 8 * h) as *const __m512i),
                        )
                    };
                    let v1 = _mm512_ternarylogic_epi64::<0x96>(aff(0), aff(1), aff(2));
                    let v2 = _mm512_ternarylogic_epi64::<0x96>(aff(3), aff(4), aff(5));
                    let v3 = _mm512_ternarylogic_epi64::<0x96>(aff(6), aff(7), v1);
                    _mm512_xor_si512(v2, v3)
                };
                let l = _mm512_permutexvar_epi8(bt, plane(0));
                let hh = _mm512_permutexvar_epi8(bt, plane(1));
                a01[half] = _mm512_permutex2var_epi64(l, p01, hh);
                a23[half] = _mm512_permutex2var_epi64(l, p23, hh);
            }
            let dst = (out as *mut __m512i).add(g);
            _mm512_storeu_si512(dst, _mm512_shuffle_i64x2::<0x44>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(4), _mm512_shuffle_i64x2::<0xEE>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(8), _mm512_shuffle_i64x2::<0x44>(a23[0], a23[1]));
            _mm512_storeu_si512(dst.add(12), _mm512_shuffle_i64x2::<0xEE>(a23[0], a23[1]));
        }
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_tr_bcast_b_canonical(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    group: u8,
    folded: F128,
) -> bool {
    unsafe { gfni_fold64_rows_tr_bcast_b_canonical_impl::<true>(rows, mats, out, group, folded) }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_rows_tr_bcast_b_canonical_impl<const WRITE_CANONICAL: bool>(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    group: u8,
    folded: F128,
) -> bool {
    use core::arch::x86_64::*;
    unsafe {
        let matches = match group {
            0 => {
                let z0 = _mm512_loadu_si512(rows.cast::<__m512i>());
                let z1 = _mm512_loadu_si512(rows.add(64).cast::<__m512i>());
                let ones = _mm512_set1_epi64(-1);
                _mm512_cmpeq_epi64_mask(_mm512_and_si512(z0, z1), ones) == 0xff
            }
            3 => {
                let z0 = _mm512_loadu_si512(rows.add(384).cast::<__m512i>());
                let z1 = _mm512_loadu_si512(rows.add(448).cast::<__m512i>());
                let expected = _mm512_setr_epi64(0x0001_ffff_ffff_ffff, 0, 0, 0, 0, 0, 0, 0);
                let different = _mm512_or_si512(_mm512_xor_si512(z0, expected), z1);
                _mm512_cmpeq_epi64_mask(different, _mm512_setzero_si512()) == 0xff
            }
            _ => false,
        };
        if !matches {
            gfni_fold64_rows_masked_tr_bcast(rows, mats, out, 0);
            return false;
        }
        gfni_fold64_rows_tr_bcast_b_canonical_readonly_leaf::<WRITE_CANONICAL>(
            rows,
            mats,
            out,
            group,
            folded,
        );
        true
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(never)]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_rows_tr_bcast_b_canonical_readonly_leaf<const WRITE_CANONICAL: bool>(
    rows: *const u8,
    mats: &[u64; 128],
    out: *mut F128,
    group: u8,
    folded: F128,
) {
    use core::arch::x86_64::*;
    debug_assert!(group == 0 || group == 3);
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast::<__m512i>());
        #[repr(C, align(64))]
        struct Octs([u64; 64]);
        let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
        let op = octs.as_mut_ptr().cast::<u64>();
        let skipped = usize::from(group);
        let first_g = if group == 0 { 1 } else { 0 };
        for relative in 0..6 {
            let i = 2 * first_g + relative;
            let z = _mm512_loadu_si512(rows.add(64 * i).cast::<__m512i>());
            _mm512_storeu_si512(
                op.add(8 * i).cast::<__m512i>(),
                _mm512_permutexvar_epi8(bt, z),
            );
        }

        let mp = mats.as_ptr();
        let p01 = _mm512_setr_epi64(0, 8, 4, 12, 1, 9, 5, 13);
        let p23 = _mm512_setr_epi64(2, 10, 6, 14, 3, 11, 7, 15);
        for relative in 0..3 {
            let g = first_g + relative;
            let mi = mp;
            let mut a01 = [_mm512_setzero_si512(); 2];
            let mut a23 = [_mm512_setzero_si512(); 2];
            for half in 0..2 {
                let i = 2 * g + half;
                let b: [__m512i; 8] =
                    core::array::from_fn(|j| _mm512_set1_epi64(*op.add(8 * i + j) as i64));
                let plane = |h: usize| {
                    let aff = |j: usize| {
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            b[j],
                            _mm512_loadu_si512(mi.add(16 * j + 8 * h).cast::<__m512i>()),
                        )
                    };
                    let v1 = _mm512_ternarylogic_epi64::<0x96>(aff(0), aff(1), aff(2));
                    let v2 = _mm512_ternarylogic_epi64::<0x96>(aff(3), aff(4), aff(5));
                    let v3 = _mm512_ternarylogic_epi64::<0x96>(aff(6), aff(7), v1);
                    _mm512_xor_si512(v2, v3)
                };
                let l = _mm512_permutexvar_epi8(bt, plane(0));
                let hh = _mm512_permutexvar_epi8(bt, plane(1));
                a01[half] = _mm512_permutex2var_epi64(l, p01, hh);
                a23[half] = _mm512_permutex2var_epi64(l, p23, hh);
            }
            let dst = out.cast::<__m512i>().add(g);
            _mm512_storeu_si512(dst, _mm512_shuffle_i64x2::<0x44>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(4), _mm512_shuffle_i64x2::<0xEE>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(8), _mm512_shuffle_i64x2::<0x44>(a23[0], a23[1]));
            _mm512_storeu_si512(dst.add(12), _mm512_shuffle_i64x2::<0xEE>(a23[0], a23[1]));
        }

        if WRITE_CANONICAL {
            let dst = out.cast::<__m512i>().add(skipped);
            let value = _mm512_broadcast_i32x4(_mm_set_epi64x(folded.hi as i64, folded.lo as i64));
            if group == 0 {
                _mm512_storeu_si512(dst, value);
                _mm512_storeu_si512(dst.add(4), value);
                _mm512_storeu_si512(dst.add(8), value);
                _mm512_storeu_si512(dst.add(12), value);
            } else {
                let zero = _mm512_setzero_si512();
                _mm512_storeu_si512(dst, _mm512_maskz_mov_epi64(0x03, value));
                _mm512_storeu_si512(dst.add(4), zero);
                _mm512_storeu_si512(dst.add(8), zero);
                _mm512_storeu_si512(dst.add(12), zero);
            }
        }
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline(never)]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
unsafe fn gfni_fold64_rows_tr_bcast_b_canonical_leaf<
    const WRITE_CANONICAL: bool,
    const MULTI: bool,
>(
    rows: *const u8,
    mats: *const u64,
    out: *mut F128,
    group: u8,
    folded: F128,
) {
    use core::arch::x86_64::*;
    debug_assert!(group == 0 || group == 3);
    unsafe {
        #[rustfmt::skip]
        const BT: [i8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56,  1, 9, 17, 25, 33, 41, 49, 57,
            2, 10, 18, 26, 34, 42, 50, 58,  3, 11, 19, 27, 35, 43, 51, 59,
            4, 12, 20, 28, 36, 44, 52, 60,  5, 13, 21, 29, 37, 45, 53, 61,
            6, 14, 22, 30, 38, 46, 54, 62,  7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast::<__m512i>());
        #[repr(C, align(64))]
        struct Octs([u64; 64]);
        let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
        let op = octs.as_mut_ptr().cast::<u64>();
        let skipped = usize::from(group);
        let first_g = if group == 0 { 1 } else { 0 };
        for relative in 0..6 {
            let i = 2 * first_g + relative;
            let z = _mm512_loadu_si512(rows.add(64 * i).cast::<__m512i>());
            _mm512_storeu_si512(
                op.add(8 * i).cast::<__m512i>(),
                _mm512_permutexvar_epi8(bt, z),
            );
        }

        let mp = mats;
        let p01 = _mm512_setr_epi64(0, 8, 4, 12, 1, 9, 5, 13);
        let p23 = _mm512_setr_epi64(2, 10, 6, 14, 3, 11, 7, 15);
        for relative in 0..3 {
            let g = first_g + relative;
            let mi = if MULTI { mp.add(128 * g) } else { mp };
            let mut a01 = [_mm512_setzero_si512(); 2];
            let mut a23 = [_mm512_setzero_si512(); 2];
            for half in 0..2 {
                let i = 2 * g + half;
                let b: [__m512i; 8] =
                    core::array::from_fn(|j| _mm512_set1_epi64(*op.add(8 * i + j) as i64));
                let plane = |h: usize| {
                    let aff = |j: usize| {
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            b[j],
                            _mm512_loadu_si512(mi.add(16 * j + 8 * h).cast::<__m512i>()),
                        )
                    };
                    let v1 = _mm512_ternarylogic_epi64::<0x96>(aff(0), aff(1), aff(2));
                    let v2 = _mm512_ternarylogic_epi64::<0x96>(aff(3), aff(4), aff(5));
                    let v3 = _mm512_ternarylogic_epi64::<0x96>(aff(6), aff(7), v1);
                    _mm512_xor_si512(v2, v3)
                };
                let l = _mm512_permutexvar_epi8(bt, plane(0));
                let hh = _mm512_permutexvar_epi8(bt, plane(1));
                a01[half] = _mm512_permutex2var_epi64(l, p01, hh);
                a23[half] = _mm512_permutex2var_epi64(l, p23, hh);
            }
            let dst = out.cast::<__m512i>().add(g);
            _mm512_storeu_si512(dst, _mm512_shuffle_i64x2::<0x44>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(4), _mm512_shuffle_i64x2::<0xEE>(a01[0], a01[1]));
            _mm512_storeu_si512(dst.add(8), _mm512_shuffle_i64x2::<0x44>(a23[0], a23[1]));
            _mm512_storeu_si512(dst.add(12), _mm512_shuffle_i64x2::<0xEE>(a23[0], a23[1]));
        }

        if WRITE_CANONICAL {
            let dst = out.cast::<__m512i>().add(skipped);
            let value = _mm512_broadcast_i32x4(_mm_set_epi64x(folded.hi as i64, folded.lo as i64));
            if group == 0 {
                _mm512_storeu_si512(dst, value);
                _mm512_storeu_si512(dst.add(4), value);
                _mm512_storeu_si512(dst.add(8), value);
                _mm512_storeu_si512(dst.add(12), value);
            } else {
                let zero = _mm512_setzero_si512();
                _mm512_storeu_si512(dst, _mm512_maskz_mov_epi64(0x03, value));
                _mm512_storeu_si512(dst.add(4), zero);
                _mm512_storeu_si512(dst.add(8), zero);
                _mm512_storeu_si512(dst.add(12), zero);
            }
        }
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "vpclmulqdq",
    target_feature = "gfni"
))]
#[inline]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
pub(crate) unsafe fn gfni_fold64_rows_tr_bcast_skip_group<const MULTI: bool>(
    rows: *const u8,
    mats: *const u64,
    out: *mut F128,
    group: u8,
) {
    debug_assert!(group == 0 || group == 3);
    unsafe {
        if MULTI {
            gfni_fold64_rows_tr_bcast_b_canonical_leaf::<false, true>(
                rows,
                mats,
                out,
                group,
                F128::ZERO,
            );
        } else {
            let b_mats = &*mats.cast::<[u64; 128]>();
            gfni_fold64_rows_tr_bcast_b_canonical_readonly_leaf::<false>(
                rows,
                b_mats,
                out,
                group,
                F128::ZERO,
            );
        }
    }
}

#[cfg(all(test, target_feature = "avx512f", target_feature = "vpclmulqdq"))]
mod cfold_initialized_checks {
    use super::*;

    fn bitwise_mul(a: F128, b: F128) -> F128 {
        let mut x = (a.lo as u128) | ((a.hi as u128) << 64);
        let mut y = (b.lo as u128) | ((b.hi as u128) << 64);
        let mut z = 0u128;
        for _ in 0..128 {
            if y & 1 != 0 { z ^= x; }
            let carry = x >> 127;
            x <<= 1;
            if carry != 0 { x ^= 0x87; }
            y >>= 1;
        }
        F128 { lo: z as u64, hi: (z >> 64) as u64 }
    }

    fn next(seed: &mut u64) -> u64 {
        *seed ^= *seed << 13;
        *seed ^= *seed >> 7;
        *seed ^= *seed << 17;
        *seed
    }

    #[test]
    fn cfold_initialized_matrices_match_bitwise() {
        let mut rng = 0x6b5c_92ae_830d_712fu64;
        let mut checks = 0;
        for case in 0..16 {
            let data: Vec<F128> = (0..2048).map(|_| F128 {
                lo: next(&mut rng), hi: next(&mut rng),
            }).collect();
            let saved = data.clone();
            let coeffs: [F128; 4] = std::array::from_fn(|i| {
                match (case + i) % 8 {
                    0 => F128::ZERO,
                    1 => F128::ONE,
                    2 => F128 { lo: u64::MAX, hi: u64::MAX },
                    3 => F128 { lo: 0, hi: 1 << 63 },
                    4 => F128 { lo: 1 << ((case + i) % 64), hi: 0 },
                    _ => F128 { lo: next(&mut rng), hi: next(&mut rng) },
                }
            });
            let mut expected = [[0u64; 128]; 4];
            for a in 0..4 {
                for chunk in 0..8 {
                    for input_bit in 0..8 {
                        let scaled = bitwise_mul(coeffs[a], data[256 * chunk + (1 << input_bit)]);
                        let bits = scaled.lo as u128 | ((scaled.hi as u128) << 64);
                        for byte in 0..16 {
                            for output_bit in 0..8 {
                                let value = ((bits >> (8 * byte + output_bit)) & 1) as u64;
                                expected[a][16 * chunk + byte] |= value << (8 * (7 - output_bit) + input_bit);
                            }
                        }
                    }
                }
            }
            for include_plane in [false, true] {
                let got = build_cfold_mats_ext(std::hint::black_box(&data), coeffs, include_plane);
                for idx in 0..128 {
                    for lane in 0..8 {
                        assert_eq!(got.0[idx][lane],
                            if include_plane { expected[lane / 2][idx] } else { 0 },
                            "plane case={case} include={include_plane} index={idx} lane={lane}");
                    }
                }
                for half in 0..2 {
                    for a in 0..4 {
                        for chunk in 0..8 {
                            for byte in 0..8 {
                                assert_eq!(got.1[32 * half + 8 * a + chunk][byte],
                                    expected[a][16 * chunk + 8 * half + byte],
                                    "broadcast case={case} include={include_plane}");
                            }
                        }
                    }
                }
                assert_eq!(data, saved);
                checks += 1;
            }
        }
        assert_eq!(checks, 32);
        println!("32 actual CFoldMats constructors match independent bitwise matrices, initialized optional planes and immutable inputs");
    }
}

// ---------------------------------------------------------------------------
// ZC-3VAR kernels (see `multilinear::three_var`).
// ---------------------------------------------------------------------------

/// Post-loop lane weights for the round-four lookahead in the baked sweep:
/// `lv4` for the cross-lane (`shuffle_i64x2` 0x88/0xDD) accumulators, lane `L`
/// ↔ `f_{r3}(L & 1)`; `lv4_odd` re-weights the incumbent per-lane accumulators
/// (odd `u` only) by `f_{r3}(l >> 1)`.
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
pub(crate) struct R4LaneWeights {
    pub(crate) lv4: [F128; 4],
    pub(crate) lv4_odd: [F128; 4],
}

/// Round-four products of one 64-row batch (four groups in the transposed
/// fold cache): for group pairs (0,1), (2,3), 0x88 gathers the X3 = 0 member of
/// each w-pair and 0xDD the X3 = 1 member. `skip` names an elided canonical
/// group (treated as zero), or 255. Kept out of line so the incumbent
/// accumulate loop keeps its register allocation.
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
unsafe fn r4_round4_batch<const SKIP: u8>(fa: *const F128, fb: *const F128, acc4: &mut [WideGhashX4; 10]) {
    let skip = SKIP;
    use core::arch::x86_64::*;
    unsafe {
        let ld = |p: *const F128, g: usize, k: usize| -> __m512i {
            if g as u8 == skip {
                _mm512_setzero_si512()
            } else {
                _mm512_loadu_si512(p.add(16 * k + 4 * g).cast::<__m512i>())
            }
        };
        let mut ops = [[_mm512_setzero_si512(); 20]; 2];
        for set in 0..2 {
            let (g0, g1) = (2 * set, 2 * set + 1);
            let st = &mut ops[set];
            let mut ca = [_mm512_setzero_si512(); 4];
            let mut cb = [_mm512_setzero_si512(); 4];
            for k in 0..4 {
                let (xa, ya) = (ld(fa, g0, k), ld(fa, g1, k));
                let (xb, yb) = (ld(fb, g0, k), ld(fb, g1, k));
                let ao = _mm512_shuffle_i64x2::<0xDD>(xa, ya);
                let bo = _mm512_shuffle_i64x2::<0xDD>(xb, yb);
                if k == 0 {
                    st[0] = ao;
                    st[1] = bo;
                }
                ca[k] = _mm512_xor_si512(_mm512_shuffle_i64x2::<0x88>(xa, ya), ao);
                cb[k] = _mm512_xor_si512(_mm512_shuffle_i64x2::<0x88>(xb, yb), bo);
            }
            let a01 = _mm512_xor_si512(ca[0], ca[1]);
            let b01 = _mm512_xor_si512(cb[0], cb[1]);
            let a23 = _mm512_xor_si512(ca[2], ca[3]);
            let b23 = _mm512_xor_si512(cb[2], cb[3]);
            st[2] = ca[0];
            st[3] = cb[0];
            st[4] = ca[1];
            st[5] = cb[1];
            st[6] = a01;
            st[7] = b01;
            st[8] = ca[2];
            st[9] = cb[2];
            st[10] = ca[3];
            st[11] = cb[3];
            st[12] = a23;
            st[13] = b23;
            st[14] = _mm512_xor_si512(ca[0], ca[2]);
            st[15] = _mm512_xor_si512(cb[0], cb[2]);
            st[16] = _mm512_xor_si512(ca[1], ca[3]);
            st[17] = _mm512_xor_si512(cb[1], cb[3]);
            st[18] = _mm512_xor_si512(a01, a23);
            st[19] = _mm512_xor_si512(b01, b23);
        }
        let (s0, s1) = (&ops[0], &ops[1]);
        for k in 0..10 {
            acc4[k].mul_acc2(s0[2 * k], s0[2 * k + 1], s1[2 * k], s1[2 * k + 1]);
        }
    }
}

/// [`round2_lookahead_chunk_baked_elide_x86`] plus the deferred round-four
/// biquadratic: returns the incumbent eight sums and the 18 round-four sums
/// `[v1; 9] ++ [vinf; 9]` (on `S·Etop·f_{r3}` weights; the driver applies
/// `eq_hi`). Elided canonical groups contribute nothing here; the driver adds
/// `round4_canonical_window_deltas`.
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
pub(crate) unsafe fn round2_lookahead_chunk_baked_elide_r4_x86(
    a_pkt: *const u8,
    b_pkt: *const u8,
    row_base: usize,
    lo_size: usize,
    bk: &R2EqBake,
    lw: &R4LaneWeights,
) -> ([F128; 8], [F128; 18]) {
    use core::arch::x86_64::*;
    debug_assert!(lo_size >= 128 && lo_size.is_multiple_of(128));
    debug_assert_eq!(row_base & 255, 0);

    unsafe {
        let mut acc = [WideGhashX4::zero(); 8];
        let mut acc4 = [WideGhashX4::zero(); 10];
        let mut fa_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let mut fb_store = core::mem::MaybeUninit::<FoldCache>::uninit();
        let fa = (*fa_store.as_mut_ptr()).0.as_mut_ptr();
        let fb = (*fb_store.as_mut_ptr()).0.as_mut_ptr();
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
                    _mm_prefetch(
                        b_pkt.wrapping_add(next + 64 * l).cast::<i8>(),
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
            {
                let g0 = row_base + 2 * x_lo;
                let bm = &(*b_mats_slice.add(batch_base)).0;
                gfni_fold64_rows_tr_bcast_skip_group::<true>(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_tr_bcast_skip_group::<false>(b_pkt.add(g0 * 8), bm.as_ptr(), fb, 0);
                pf_quarter!(g0, 0);
                #[cfg(test)]
                R2_CANON_ELIDE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                accum1!(g0, 1);
                accum2!(g0, 2, 3);
                r4_round4_batch::<0>(fa, fb, &mut acc4);
            }
            {
                let g0 = row_base + 2 * (x_lo + 32);
                let bm = &(*b_mats_slice.add(batch_base + 1)).0;
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_pkt.add(g0 * 8), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
                r4_round4_batch::<255>(fa, fb, &mut acc4);
            }
            {
                let g0 = row_base + 2 * (x_lo + 64);
                let bm = &(*b_mats_slice.add(batch_base + 2)).0;
                gfni_fold64_rows_masked_tr_bcast4(a_pkt.add(g0 * 8), a_mats_ptr, fa, 0);
                gfni_fold64_rows_masked_tr_bcast(b_pkt.add(g0 * 8), bm, fb, 0);
                accum2!(g0, 0, 1);
                accum2!(g0, 2, 3);
                r4_round4_batch::<255>(fa, fb, &mut acc4);
            }
            {
                let g0 = row_base + 2 * (x_lo + 96);
                let bm = &(*b_mats_slice.add(batch_base + 3)).0;
                gfni_fold64_rows_tr_bcast_skip_group::<true>(a_pkt.add(g0 * 8), a_mats_ptr, fa, 3);
                gfni_fold64_rows_tr_bcast_skip_group::<false>(b_pkt.add(g0 * 8), bm.as_ptr(), fb, 3);
                accum2!(g0, 0, 1);
                accum1!(g0, 2);
                r4_round4_batch::<3>(fa, fb, &mut acc4);
                pf_quarter!(g0, 3);
                #[cfg(test)]
                R2_CANON_ELIDE_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
            }
            x_lo += 128;
        }

        use crate::field::gf2_128::x86_64::{f128x4_extract, ghash_mul_x4_split, ghash_shift64_x4};
        let lane_sum = |v: __m512i, w: __m512i, w64: __m512i| -> F128 {
            let l = f128x4_extract(ghash_mul_x4_split(v, w, w64));
            l[0] + l[1] + l[2] + l[3]
        };
        let mut out = [F128::ZERO; 8];
        let lane_w = f128x4_loadu(bk.lane.as_ptr());
        let lane_w64 = ghash_shift64_x4(lane_w);
        let mut red = [_mm512_setzero_si512(); 8];
        for i in 0..8 {
            red[i] = acc[i].reduce_lanes();
            out[i] = lane_sum(red[i], lane_w, lane_w64);
        }
        let lv4 = f128x4_loadu(lw.lv4.as_ptr());
        let lv4_64 = ghash_shift64_x4(lv4);
        let lvo = f128x4_loadu(lw.lv4_odd.as_ptr());
        let lvo_64 = ghash_shift64_x4(lvo);
        let mut r4 = [F128::ZERO; 18];
        // v1[i+3j] for the odd-u (X3 = 1) corners from the incumbent accumulators.
        const MAP: [usize; 9] = [usize::MAX, 0, 1, 4, 2, 3, 5, 6, 7];
        r4[0] = lane_sum(acc4[0].reduce_lanes(), lv4, lv4_64);
        for k in 1..9 {
            r4[k] = lane_sum(red[MAP[k]], lvo, lvo_64);
        }
        for k in 0..9 {
            r4[9 + k] = lane_sum(acc4[1 + k].reduce_lanes(), lv4, lv4_64);
        }
        (out, r4)
    }
}

/// Three-variable composed pass leaf: [`fold2_from_packed_lookahead_c4_lm_wtab_x86`]
/// with each step consuming 128 packed rows (two c4 register folds at
/// `ρ₁, ρ₂`) and applying the `ρ₃` level in registers, so a step yields one
/// 16-output lane-major tile of the eighth-size table.
#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512vbmi",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
#[cfg_attr(
    target_feature = "avx512bw",
    target_feature(enable = "avx512f,avx512bw,avx512vbmi,gfni,vpclmulqdq")
)]
#[cfg_attr(
    not(target_feature = "avx512bw"),
    target_feature(enable = "avx512f,avx512vbmi,gfni,vpclmulqdq")
)]
#[inline(never)]
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn fold3_from_packed_lookahead_c4_lm_wtab_x86<
    const NT_OUT: bool,
    const OUT_LM: bool,
>(
    a_pkt: *const u8,
    b_pkt: *const u8,
    out_base: usize,
    a_out: &mut [F128],
    b_out: &mut [F128],
    lo_size: usize,
    cfold: &CFoldMats,
    rho3: F128,
    wt: &[F128],
) -> [F128; 8] {
    use crate::field::gf2_128::x86_64::{ghash_broadcast_split, ghash_mul_x4_split};
    use core::arch::x86_64::*;
    debug_assert!(lo_size.is_multiple_of(16));
    debug_assert_eq!(a_out.len(), 2 * lo_size);
    debug_assert_eq!(b_out.len(), 2 * lo_size);

    unsafe {
        let mut acc = [WideGhashX4::zero(); 8];
        let a_out_ptr = a_out.as_mut_ptr();
        let b_out_ptr = b_out.as_mut_ptr();
        let wt_ptr = wt.as_ptr();
        let (r3, r3_64) = ghash_broadcast_split(rho3);

        macro_rules! fold_side {
            ($pkt:expr, $row0:expr) => {{
                let [q0, q1, q2, q3] = gfni_fold64_rows_c4_lm_registers($pkt.add($row0 * 8), cfold);
                let [p0, p1, p2, p3] =
                    gfni_fold64_rows_c4_lm_registers($pkt.add($row0 * 8 + 512), cfold);
                let oe1 = _mm512_xor_si512(q0, ghash_mul_x4_split(_mm512_xor_si512(q0, q1), r3, r3_64));
                let oo1 = _mm512_xor_si512(q2, ghash_mul_x4_split(_mm512_xor_si512(q2, q3), r3, r3_64));
                let oe2 = _mm512_xor_si512(p0, ghash_mul_x4_split(_mm512_xor_si512(p0, p1), r3, r3_64));
                let oo2 = _mm512_xor_si512(p2, ghash_mul_x4_split(_mm512_xor_si512(p2, p3), r3, r3_64));
                [
                    _mm512_shuffle_i64x2::<0x88>(oe1, oe2),
                    _mm512_shuffle_i64x2::<0x88>(oo1, oo2),
                    _mm512_shuffle_i64x2::<0xDD>(oe1, oe2),
                    _mm512_shuffle_i64x2::<0xDD>(oo1, oo2),
                ]
            }};
        }

        macro_rules! step16 {
            ($x_expr:expr) => {{
                let x = $x_expr;
                let ol = 2 * x;
                let xg = out_base + ol;
                let row0 = 8 * xg;
                let next = (row0 + 128 * ZC_PKT_PF_TILES) * 8;
                for l in 0..8 {
                    _mm_prefetch(a_pkt.wrapping_add(next + 64 * l).cast::<i8>(), _MM_HINT_T0);
                    _mm_prefetch(b_pkt.wrapping_add(next + 64 * l).cast::<i8>(), _MM_HINT_T0);
                }
                let [a0, a1, a2, a3] = fold_side!(a_pkt, row0);
                for l in 8..16 {
                    _mm_prefetch(a_pkt.wrapping_add(next + 64 * l).cast::<i8>(), _MM_HINT_T0);
                    _mm_prefetch(b_pkt.wrapping_add(next + 64 * l).cast::<i8>(), _MM_HINT_T0);
                }
                let [b0, b1, b2, b3] = fold_side!(b_pkt, row0);
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
                let wp = wt_ptr.add(x) as *const __m512i;
                let w = _mm512_loadu_si512(wp);
                let w64 = _mm512_loadu_si512(wp.add(1));
                let a0w = ghash_mul_x4_split(a0, w, w64);
                let a1w = ghash_mul_x4_split(a1, w, w64);
                let a2w = ghash_mul_x4_split(a2, w, w64);
                let a3w = ghash_mul_x4_split(a3, w, w64);
                (a0w, a1w, a2w, a3w, b0, b1, b2, b3)
            }};
        }

        let mut x_lo = 0;
        while x_lo + 16 <= lo_size {
            let (a0w, a1w, a2w, a3w, b0, b1, b2, b3) = step16!(x_lo);
            let (c0w, c1w, c2w, c3w, d0, d1, d2, d3) = step16!(x_lo + 8);
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
        let lo4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[0], acc[1], acc[2], acc[3]),
        );
        let hi4 = crate::field::gf2_128::x86_64::f128x4_extract(
            WideGhashX4::fold4_and_reduce(acc[4], acc[5], acc[6], acc[7]),
        );
        [
            lo4[0], lo4[1], lo4[2], lo4[3], hi4[0], hi4[1], hi4[2], hi4[3],
        ]
    }
}
