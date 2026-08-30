use crate::field::F128;

/// Four-lane pair fold using AVX-512 lane deinterleaving and VPCLMULQDQ.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn fold_pairs(src: &[F128], base: usize, dst: &mut [F128], r: F128) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    // SAFETY: caller guarantees the target features and source bounds.
    unsafe {
        let r_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r.hi as i64, r.lo as i64));
        let r_x64 = ghash_shift64_x4(r_bcast);
        let lanes = dst.len() & !3;
        let mut t = 0;
        while t < lanes {
            let s = 2 * (base + t);
            let lo = _mm512_loadu_si512(src.as_ptr().add(s) as *const __m512i);
            let hi = _mm512_loadu_si512(src.as_ptr().add(s + 4) as *const __m512i);
            let even = _mm512_shuffle_i32x4::<0x88>(lo, hi);
            let odd = _mm512_shuffle_i32x4::<0xDD>(lo, hi);
            let diff = _mm512_xor_si512(even, odd);
            let new = _mm512_xor_si512(even, ghash_mul_x4_split(diff, r_bcast, r_x64));
            _mm512_storeu_si512(dst.as_mut_ptr().add(t) as *mut __m512i, new);
            t += 4;
        }
        portable_tail(src, base, dst, r, t);
    }
}

/// Four-lane `dst += scale * addend` for the lazy-OOD correction.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`; slices have equal length.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn add_scaled(dst: &mut [F128], addend: &[F128], scale: F128) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    debug_assert_eq!(dst.len(), addend.len());
    // SAFETY: caller supplies target features and equal slice lengths.
    unsafe {
        let scale_x4 = _mm512_broadcast_i32x4(_mm_set_epi64x(scale.hi as i64, scale.lo as i64));
        let scale_x64 = ghash_shift64_x4(scale_x4);
        let lanes = dst.len() & !3;
        let mut i = 0usize;
        while i < lanes {
            let current = _mm512_loadu_si512(dst.as_ptr().add(i) as *const __m512i);
            let extra = _mm512_loadu_si512(addend.as_ptr().add(i) as *const __m512i);
            let corrected =
                _mm512_xor_si512(current, ghash_mul_x4_split(extra, scale_x4, scale_x64));
            _mm512_storeu_si512(dst.as_mut_ptr().add(i) as *mut __m512i, corrected);
            i += 4;
        }
        while i < dst.len() {
            dst[i] += scale * addend[i];
            i += 1;
        }
    }
}

/// Four-lane `dst = fold_r(src) + scale * fold_r(addend)` with all
/// intermediates kept in zmm and one final store.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`; the caller guarantees that both input
/// slices contain every pair selected by `base` and `dst.len()`.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn fold_pairs_with_scaled_addend(
    src: &[F128],
    addend: &[F128],
    base: usize,
    dst: &mut [F128],
    r: F128,
    scale: F128,
) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    // SAFETY: caller supplies target features and source bounds.
    unsafe {
        let r_x4 = _mm512_broadcast_i32x4(_mm_set_epi64x(r.hi as i64, r.lo as i64));
        let r_x64 = ghash_shift64_x4(r_x4);
        let scale_x4 = _mm512_broadcast_i32x4(_mm_set_epi64x(scale.hi as i64, scale.lo as i64));
        let scale_x64 = ghash_shift64_x4(scale_x4);
        let lanes = dst.len() & !3;
        let mut t = 0usize;
        while t < lanes {
            let index = 2 * (base + t);
            let src_lo = _mm512_loadu_si512(src.as_ptr().add(index) as *const __m512i);
            let src_hi = _mm512_loadu_si512(src.as_ptr().add(index + 4) as *const __m512i);
            let src_even = _mm512_shuffle_i32x4::<0x88>(src_lo, src_hi);
            let src_odd = _mm512_shuffle_i32x4::<0xDD>(src_lo, src_hi);
            let src_folded = _mm512_xor_si512(
                src_even,
                ghash_mul_x4_split(_mm512_xor_si512(src_even, src_odd), r_x4, r_x64),
            );
            let addend_lo = _mm512_loadu_si512(addend.as_ptr().add(index) as *const __m512i);
            let addend_hi = _mm512_loadu_si512(addend.as_ptr().add(index + 4) as *const __m512i);
            let addend_even = _mm512_shuffle_i32x4::<0x88>(addend_lo, addend_hi);
            let addend_odd = _mm512_shuffle_i32x4::<0xDD>(addend_lo, addend_hi);
            let addend_folded = _mm512_xor_si512(
                addend_even,
                ghash_mul_x4_split(_mm512_xor_si512(addend_even, addend_odd), r_x4, r_x64),
            );
            let output = _mm512_xor_si512(
                src_folded,
                ghash_mul_x4_split(addend_folded, scale_x4, scale_x64),
            );
            _mm512_storeu_si512(dst.as_mut_ptr().add(t) as *mut __m512i, output);
            t += 4;
        }
        while t < dst.len() {
            let index = 2 * (base + t);
            let src_even = src[index];
            let addend_even = addend[index];
            let src_folded = src_even + r * (src_even + src[index + 1]);
            let addend_folded = addend_even + r * (addend_even + addend[index + 1]);
            dst[t] = src_folded + scale * addend_folded;
            t += 1;
        }
    }
}

#[inline]
fn portable_tail(src: &[F128], base: usize, dst: &mut [F128], r: F128, mut t: usize) {
    // Char-2 one-mul tail (SIMD body already uses even + r*(even+odd)).
    while t < dst.len() {
        let s = 2 * (base + t);
        let even = src[s];
        dst[t] = even + r * (even + src[s + 1]);
        t += 1;
    }
}

/// Nested pair-fold of 4-tuples into `dst`, keeping the r0 mid in zmm.
///
/// For each slot `t`:
///   low  = a0 + r0·(a0+a1)
///   high = a2 + r0·(a2+a3)
///   dst[t] = low + r1·(low+high)
///
/// Four slots (16 source F128) per iteration. Same even/odd pairing and
/// `ghash_mul_x4(r, even XOR odd)` body as [`fold_pairs`], applied twice
/// in registers. Stores `dst` only — no mid buffer.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`. `src.len() == 4 * dst.len()`.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn fold4_nested(src: &[F128], dst: &mut [F128], r0: F128, r1: F128) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    // SAFETY: caller guarantees the target features and source bounds.
    unsafe {
        let r0_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r0.hi as i64, r0.lo as i64));
        let r0_x64 = ghash_shift64_x4(r0_bcast);
        let r1_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r1.hi as i64, r1.lo as i64));
        let r1_x64 = ghash_shift64_x4(r1_bcast);
        let lanes = dst.len() & !3;
        let mut t = 0;
        while t < lanes {
            let s = 4 * t;
            let v0 = _mm512_loadu_si512(src.as_ptr().add(s) as *const __m512i);
            let v1 = _mm512_loadu_si512(src.as_ptr().add(s + 4) as *const __m512i);
            let v2 = _mm512_loadu_si512(src.as_ptr().add(s + 8) as *const __m512i);
            let v3 = _mm512_loadu_si512(src.as_ptr().add(s + 12) as *const __m512i);

            // Layer r0: adjacent pairs → [low0, high0, low1, high1] / [low2, …].
            let even01 = _mm512_shuffle_i32x4::<0x88>(v0, v1);
            let odd01 = _mm512_shuffle_i32x4::<0xDD>(v0, v1);
            let mid01 = _mm512_xor_si512(
                even01,
                ghash_mul_x4_split(_mm512_xor_si512(even01, odd01), r0_bcast, r0_x64),
            );
            let even23 = _mm512_shuffle_i32x4::<0x88>(v2, v3);
            let odd23 = _mm512_shuffle_i32x4::<0xDD>(v2, v3);
            let mid23 = _mm512_xor_si512(
                even23,
                ghash_mul_x4_split(_mm512_xor_si512(even23, odd23), r0_bcast, r0_x64),
            );

            // Layer r1: (low, high) pairs → [out0, out1, out2, out3].
            let low = _mm512_shuffle_i32x4::<0x88>(mid01, mid23);
            let high = _mm512_shuffle_i32x4::<0xDD>(mid01, mid23);
            let out = _mm512_xor_si512(
                low,
                ghash_mul_x4_split(_mm512_xor_si512(low, high), r1_bcast, r1_x64),
            );
            _mm512_storeu_si512(dst.as_mut_ptr().add(t) as *mut __m512i, out);
            t += 4;
        }
        while t < dst.len() {
            let a0 = src[4 * t];
            let a1 = src[4 * t + 1];
            let a2 = src[4 * t + 2];
            let a3 = src[4 * t + 3];
            let low = a0 + r0 * (a0 + a1);
            let high = a2 + r0 * (a2 + a3);
            dst[t] = low + r1 * (low + high);
            t += 1;
        }
    }
}

/// Lines of the sixteen-bank source asked for ahead of the quad the kernel
/// is folding, in F128 elements. `FLOCK_NO_FOLD16_PF=1` removes the hints
/// (they move no data of their own and change no value, so the fold is
/// byte-identical either way); `FLOCK_FOLD16_PF=<n>` overrides the distance.
const FOLD16_PF_AHEAD: usize = 512;

fn fold16_pf_ahead() -> usize {
    static D: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
        if std::env::var_os("FLOCK_NO_FOLD16_PF").is_some() {
            return 0;
        }
        std::env::var("FLOCK_FOLD16_PF")
            .ok()
            .and_then(|v| v.parse::<usize>().ok())
            .unwrap_or(FOLD16_PF_AHEAD)
    });
    *D
}

/// Sixteen-bank weighted fold with deferred reduction, four output slots per
/// pass: `dst[t] = Σ_{b<16} w[b] · src[16t + b]`.
///
/// The 16 slot-major loads of a 4-slot block are transposed into low/high
/// limb vectors for adjacent bank pairs, using the same 32 permutes as the
/// bank-major transpose. Each pair contributes six CLMULs to three sums:
/// low, high, and `(x.lo + x.hi) * (w.lo + w.hi)`. Forming the cross sum only
/// after all eight pairs gives 48 product CLMULs plus two for reduction,
/// instead of 64 plus two for four-part products. This is valid for arbitrary
/// weights; it does not assume that their sum is one.
///
/// # Safety
/// Caller guarantees `avx512f` + `vpclmulqdq` and `src.len() == 16 * dst.len()`.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn fold16_banked(src: &[F128], dst: &mut [F128], w: &[F128; 16]) {
    use crate::field::gf2_128::x86_64::ghash_reduce_acc_x4;
    use core::arch::x86_64::*;
    debug_assert_eq!(src.len(), 16 * dst.len());
    // SAFETY: caller guarantees the target features and source bounds.
    unsafe {
        // Still sixteen broadcast vectors: each pair stores its two low
        // limbs and two high limbs separately. Do not retain an additional
        // array of mixed weights across the hot loop.
        let wb: [[__m512i; 2]; 8] = core::array::from_fn(|pair| {
            let a = w[2 * pair];
            let b = w[2 * pair + 1];
            [
                _mm512_broadcast_i32x4(_mm_set_epi64x(b.lo as i64, a.lo as i64)),
                _mm512_broadcast_i32x4(_mm_set_epi64x(b.hi as i64, a.hi as i64)),
            ]
        });
        // Stage 1 interleaves 128-bit lanes as before. Stage 2 now puts
        // banks b/b+1 into the low/high qwords of each output-slot lane,
        // selecting their low limbs and high limbs in separate vectors.
        // Low-to-high qword indices are [0,4,2,6,8,12,10,14] and
        // [1,5,3,7,9,13,11,15]; set_epi64 takes them in reverse order.
        let s1_lo = _mm512_set_epi64(11, 10, 3, 2, 9, 8, 1, 0);
        let s1_hi = _mm512_set_epi64(15, 14, 7, 6, 13, 12, 5, 4);
        let s2_lo = _mm512_set_epi64(14, 10, 12, 8, 6, 2, 4, 0);
        let s2_hi = _mm512_set_epi64(15, 11, 13, 9, 7, 3, 5, 1);
        let quads = dst.len() & !3;
        let pf_ahead = fold16_pf_ahead();
        let pf_limit = src.len().saturating_sub(64);
        let mut t = 0usize;
        while t < quads {
            if pf_ahead != 0 {
                let ahead = 16 * t + pf_ahead;
                if ahead <= pf_limit {
                    let p = src.as_ptr().add(ahead).cast::<i8>();
                    let mut l = 0usize;
                    while l < 1024 {
                        _mm_prefetch::<_MM_HINT_T0>(p.add(l));
                        l += 64;
                    }
                }
            }
            let mut acc_lo = _mm512_setzero_si512();
            let mut acc_hi = _mm512_setzero_si512();
            let mut acc_diag = _mm512_setzero_si512();
            for g in 0..4 {
                // v_s = banks 4g..4g+3 of slot t+s.
                let base = 16 * t + 4 * g;
                let a0 = _mm512_loadu_si512(src.as_ptr().add(base) as *const __m512i);
                let a1 = _mm512_loadu_si512(src.as_ptr().add(base + 16) as *const __m512i);
                let a2 = _mm512_loadu_si512(src.as_ptr().add(base + 32) as *const __m512i);
                let a3 = _mm512_loadu_si512(src.as_ptr().add(base + 48) as *const __m512i);
                let t0 = _mm512_permutex2var_epi64(a0, s1_lo, a1); // [a0.L0 a1.L0 a0.L1 a1.L1]
                let t1 = _mm512_permutex2var_epi64(a0, s1_hi, a1); // [a0.L2 a1.L2 a0.L3 a1.L3]
                let t2 = _mm512_permutex2var_epi64(a2, s1_lo, a3);
                let t3 = _mm512_permutex2var_epi64(a2, s1_hi, a3);
                // Finish the first pair before forming the second pair's
                // limb vectors, keeping mixed operands local to one pair.
                {
                    let x_lo = _mm512_permutex2var_epi64(t0, s2_lo, t2);
                    let x_hi = _mm512_permutex2var_epi64(t0, s2_hi, t2);
                    let [w_lo, w_hi] = wb[2 * g];
                    acc_lo = _mm512_xor_si512(
                        acc_lo,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_lo, w_lo),
                            _mm512_clmulepi64_epi128::<0x11>(x_lo, w_lo),
                        ),
                    );
                    acc_hi = _mm512_xor_si512(
                        acc_hi,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_hi, w_hi),
                            _mm512_clmulepi64_epi128::<0x11>(x_hi, w_hi),
                        ),
                    );
                    let x_mix = _mm512_xor_si512(x_lo, x_hi);
                    let w_mix = _mm512_xor_si512(w_lo, w_hi);
                    acc_diag = _mm512_xor_si512(
                        acc_diag,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_mix, w_mix),
                            _mm512_clmulepi64_epi128::<0x11>(x_mix, w_mix),
                        ),
                    );
                }
                {
                    let x_lo = _mm512_permutex2var_epi64(t1, s2_lo, t3);
                    let x_hi = _mm512_permutex2var_epi64(t1, s2_hi, t3);
                    let [w_lo, w_hi] = wb[2 * g + 1];
                    acc_lo = _mm512_xor_si512(
                        acc_lo,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_lo, w_lo),
                            _mm512_clmulepi64_epi128::<0x11>(x_lo, w_lo),
                        ),
                    );
                    acc_hi = _mm512_xor_si512(
                        acc_hi,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_hi, w_hi),
                            _mm512_clmulepi64_epi128::<0x11>(x_hi, w_hi),
                        ),
                    );
                    let x_mix = _mm512_xor_si512(x_lo, x_hi);
                    let w_mix = _mm512_xor_si512(w_lo, w_hi);
                    acc_diag = _mm512_xor_si512(
                        acc_diag,
                        _mm512_xor_si512(
                            _mm512_clmulepi64_epi128::<0x00>(x_mix, w_mix),
                            _mm512_clmulepi64_epi128::<0x11>(x_mix, w_mix),
                        ),
                    );
                }
            }
            // Karatsuba's diagonal equals cross XOR low XOR high. XOR is
            // linear, so recover the cross sum once after all sixteen banks.
            let acc_mid = _mm512_xor_si512(acc_diag, _mm512_xor_si512(acc_lo, acc_hi));
            let folded = ghash_reduce_acc_x4(acc_lo, acc_mid, acc_hi);
            _mm512_storeu_si512(dst.as_mut_ptr().add(t) as *mut __m512i, folded);
            t += 4;
        }
        while t < dst.len() {
            let mut v = F128::ZERO;
            for b in 0..16 {
                v += w[b] * src[16 * t + b];
            }
            dst[t] = v;
            t += 1;
        }
    }
}

/// In-place DirectFold8 factor-state bind: adjacent-pair fold of `f` and `b`
/// with fused `(u0,u2)` accumulate. Same permute body as [`fold_pairs`] and
/// the same even/odd message layout as `msg_reduce_avx512`.
///
/// In-place is safe because output `t` depends only on source `2t..2t+2`,
/// and stores of `dst[0..t)` never overlap unread source `2t..`.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`. `f.len() == b.len()`, multiple of 4.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn fold_two_and_msg_in_place(
    f: &mut Vec<F128>,
    b: &mut Vec<F128>,
    r: F128,
) -> (F128, F128) {
    use crate::field::gf2_128::x86_64::{WideGhashX4, ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    debug_assert_eq!(f.len(), b.len());
    debug_assert!(f.len().is_multiple_of(4));
    let half = f.len() / 2;

    // SAFETY: caller guarantees features and even pair counts; loads of
    // `2t..2t+8` complete before stores to `t..t+4` overlap those addresses.
    unsafe {
        let r_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r.hi as i64, r.lo as i64));
        let r_x64 = ghash_shift64_x4(r_bcast);

        let fold4 = |ptr: *const F128, t: usize| -> __m512i {
            let s = 2 * t;
            let lo = _mm512_loadu_si512(ptr.add(s) as *const __m512i);
            let hi = _mm512_loadu_si512(ptr.add(s + 4) as *const __m512i);
            let even = _mm512_shuffle_i32x4::<0x88>(lo, hi);
            let odd = _mm512_shuffle_i32x4::<0xDD>(lo, hi);
            let diff = _mm512_xor_si512(even, odd);
            _mm512_xor_si512(even, ghash_mul_x4_split(diff, r_bcast, r_x64))
        };

        let mut u0_acc = WideGhashX4::zero();
        let mut u2_acc = WideGhashX4::zero();
        let f_ptr = f.as_mut_ptr();
        let b_ptr = b.as_mut_ptr();
        let lanes = half & !7;
        let mut t = 0usize;
        while t < lanes {
            let f0 = fold4(f_ptr, t);
            let f1 = fold4(f_ptr, t + 4);
            let b0 = fold4(b_ptr, t);
            let b1 = fold4(b_ptr, t + 4);
            _mm512_storeu_si512(f_ptr.add(t) as *mut __m512i, f0);
            _mm512_storeu_si512(f_ptr.add(t + 4) as *mut __m512i, f1);
            _mm512_storeu_si512(b_ptr.add(t) as *mut __m512i, b0);
            _mm512_storeu_si512(b_ptr.add(t + 4) as *mut __m512i, b1);

            let f_even = _mm512_shuffle_i32x4::<0x88>(f0, f1);
            let b_even = _mm512_shuffle_i32x4::<0x88>(b0, b1);
            u0_acc.mul_acc(f_even, b_even);

            let f0s = _mm512_xor_si512(f0, _mm512_shuffle_i32x4::<0xB1>(f0, f0));
            let f1s = _mm512_xor_si512(f1, _mm512_shuffle_i32x4::<0xB1>(f1, f1));
            let f_sum = _mm512_shuffle_i32x4::<0x88>(f0s, f1s);
            let b0s = _mm512_xor_si512(b0, _mm512_shuffle_i32x4::<0xB1>(b0, b0));
            let b1s = _mm512_xor_si512(b1, _mm512_shuffle_i32x4::<0xB1>(b1, b1));
            let b_sum = _mm512_shuffle_i32x4::<0x88>(b0s, b1s);
            u2_acc.mul_acc(f_sum, b_sum);

            t += 8;
        }

        let mut u0 = u0_acc.fold().reduce();
        let mut u2 = u2_acc.fold().reduce();
        while t < half {
            let source = 2 * t;
            let f0 = *f_ptr.add(source) + r * (*f_ptr.add(source) + *f_ptr.add(source + 1));
            let f1 = *f_ptr.add(source + 2) + r * (*f_ptr.add(source + 2) + *f_ptr.add(source + 3));
            let b0 = *b_ptr.add(source) + r * (*b_ptr.add(source) + *b_ptr.add(source + 1));
            let b1 = *b_ptr.add(source + 2) + r * (*b_ptr.add(source + 2) + *b_ptr.add(source + 3));
            *f_ptr.add(t) = f0;
            *f_ptr.add(t + 1) = f1;
            *b_ptr.add(t) = b0;
            *b_ptr.add(t + 1) = b1;
            u0 += f0 * b0;
            u2 += (f0 + f1) * (b0 + b1);
            t += 2;
        }
        f.truncate(half);
        b.truncate(half);
        (u0, u2)
    }
}

/// Four-lane split-half bind: `lo[i] = lo[i] + r·(hi[i] + lo[i])`.
///
/// The two operand runs are separate contiguous slices (the top-bit split of
/// one table), so lanes pair up straight out of the loads — no permute.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`; `hi.len() >= lo.len()`.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn bind_split_half(lo: &mut [F128], hi: &[F128], r: F128) {
    use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    debug_assert!(hi.len() >= lo.len());
    // SAFETY: caller supplies target features and one `hi` per `lo` slot.
    unsafe {
        let r_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r.hi as i64, r.lo as i64));
        let r_x64 = ghash_shift64_x4(r_bcast);
        let lanes = lo.len() & !3;
        let mut i = 0usize;
        while i < lanes {
            let a = _mm512_loadu_si512(lo.as_ptr().add(i) as *const __m512i);
            let b = _mm512_loadu_si512(hi.as_ptr().add(i) as *const __m512i);
            let new = _mm512_xor_si512(
                a,
                ghash_mul_x4_split(_mm512_xor_si512(a, b), r_bcast, r_x64),
            );
            _mm512_storeu_si512(lo.as_mut_ptr().add(i) as *mut __m512i, new);
            i += 4;
        }
        while i < lo.len() {
            lo[i] = lo[i] + r * (hi[i] + lo[i]);
            i += 1;
        }
    }
}

/// Four-lane split-half product-sumcheck message:
/// `(Σ chi[i]·zhi[i], Σ (chi[i]+clo[i])·(zhi[i]+zlo[i]))`.
///
/// Both sums use one deferred-reduction accumulator each (reduction is
/// F₂-linear, so one reduce per sum equals reducing every product), with an
/// unreduced scalar tail XORed in before the single reduce.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`; all four slices at least `n` long.
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(super) unsafe fn msg_split_half(
    chi: &[F128],
    clo: &[F128],
    zhi: &[F128],
    zlo: &[F128],
    n: usize,
) -> (F128, F128) {
    use crate::field::gf2_128::F256Unreduced;
    use crate::field::gf2_128::x86_64::WideGhashX4;
    use core::arch::x86_64::*;

    // SAFETY: caller guarantees features and that every slice covers `n`.
    unsafe {
        let mut e1_wide = WideGhashX4::zero();
        let mut einf_wide = WideGhashX4::zero();
        let lanes = n & !3;
        let mut i = 0usize;
        while i < lanes {
            let ch = _mm512_loadu_si512(chi.as_ptr().add(i) as *const __m512i);
            let zh = _mm512_loadu_si512(zhi.as_ptr().add(i) as *const __m512i);
            e1_wide.mul_acc(ch, zh);
            let cl = _mm512_loadu_si512(clo.as_ptr().add(i) as *const __m512i);
            let zl = _mm512_loadu_si512(zlo.as_ptr().add(i) as *const __m512i);
            einf_wide.mul_acc(_mm512_xor_si512(ch, cl), _mm512_xor_si512(zh, zl));
            i += 4;
        }
        let mut e1_acc = F256Unreduced::ZERO;
        let mut einf_acc = F256Unreduced::ZERO;
        while i < n {
            e1_acc ^= chi[i].mul_unreduced(zhi[i]);
            einf_acc ^= (chi[i] + clo[i]).mul_unreduced(zhi[i] + zlo[i]);
            i += 1;
        }
        e1_acc ^= e1_wide.fold();
        einf_acc ^= einf_wide.fold();
        (e1_acc.reduce(), einf_acc.reduce())
    }
}

/// Four-lane fused quarter bind + next-round message. Per slot `i`:
/// `lo = c0[i] + r·(c2[i]+c0[i])`, `hi = c1[i] + r·(c3[i]+c1[i])`, likewise
/// for `z`; `c0[i]/c1[i]/z0[i]/z1[i]` take the bound values, and the message
/// accumulates `hi·zhi` and `(hi+lo)·(zhi+zlo)`.
///
/// Quarters are separate contiguous runs, so no lane permute is needed; the
/// four binds share one broadcast `r`.
///
/// # Safety
/// Requires `avx512f` and `vpclmulqdq`; all eight slices at least `n` long.
#[target_feature(enable = "avx512f,vpclmulqdq")]
#[allow(clippy::too_many_arguments)]
pub(super) unsafe fn bind_both_and_msg_split(
    cq0: &mut [F128],
    cq1: &mut [F128],
    cq2: &[F128],
    cq3: &[F128],
    zq0: &mut [F128],
    zq1: &mut [F128],
    zq2: &[F128],
    zq3: &[F128],
    r: F128,
    n: usize,
) -> (F128, F128) {
    use crate::field::gf2_128::F256Unreduced;
    use crate::field::gf2_128::x86_64::{WideGhashX4, ghash_mul_x4_split, ghash_shift64_x4};
    use core::arch::x86_64::*;

    // SAFETY: caller guarantees features and that every slice covers `n`.
    unsafe {
        let r_bcast = _mm512_broadcast_i32x4(_mm_set_epi64x(r.hi as i64, r.lo as i64));
        let r_x64 = ghash_shift64_x4(r_bcast);
        let mut e1_wide = WideGhashX4::zero();
        let mut einf_wide = WideGhashX4::zero();
        let lanes = n & !3;
        let mut i = 0usize;
        while i < lanes {
            let c0 = _mm512_loadu_si512(cq0.as_ptr().add(i) as *const __m512i);
            let c1 = _mm512_loadu_si512(cq1.as_ptr().add(i) as *const __m512i);
            let c2 = _mm512_loadu_si512(cq2.as_ptr().add(i) as *const __m512i);
            let c3 = _mm512_loadu_si512(cq3.as_ptr().add(i) as *const __m512i);
            let z0 = _mm512_loadu_si512(zq0.as_ptr().add(i) as *const __m512i);
            let z1 = _mm512_loadu_si512(zq1.as_ptr().add(i) as *const __m512i);
            let z2 = _mm512_loadu_si512(zq2.as_ptr().add(i) as *const __m512i);
            let z3 = _mm512_loadu_si512(zq3.as_ptr().add(i) as *const __m512i);

            let lo = _mm512_xor_si512(
                c0,
                ghash_mul_x4_split(_mm512_xor_si512(c2, c0), r_bcast, r_x64),
            );
            let hi = _mm512_xor_si512(
                c1,
                ghash_mul_x4_split(_mm512_xor_si512(c3, c1), r_bcast, r_x64),
            );
            let zlo = _mm512_xor_si512(
                z0,
                ghash_mul_x4_split(_mm512_xor_si512(z2, z0), r_bcast, r_x64),
            );
            let zhi = _mm512_xor_si512(
                z1,
                ghash_mul_x4_split(_mm512_xor_si512(z3, z1), r_bcast, r_x64),
            );

            _mm512_storeu_si512(cq0.as_mut_ptr().add(i) as *mut __m512i, lo);
            _mm512_storeu_si512(cq1.as_mut_ptr().add(i) as *mut __m512i, hi);
            _mm512_storeu_si512(zq0.as_mut_ptr().add(i) as *mut __m512i, zlo);
            _mm512_storeu_si512(zq1.as_mut_ptr().add(i) as *mut __m512i, zhi);

            e1_wide.mul_acc(hi, zhi);
            einf_wide.mul_acc(_mm512_xor_si512(hi, lo), _mm512_xor_si512(zhi, zlo));
            i += 4;
        }
        let mut e1_acc = F256Unreduced::ZERO;
        let mut einf_acc = F256Unreduced::ZERO;
        while i < n {
            let lo = cq0[i] + r * (cq2[i] + cq0[i]);
            let hi = cq1[i] + r * (cq3[i] + cq1[i]);
            let zlo = zq0[i] + r * (zq2[i] + zq0[i]);
            let zhi = zq1[i] + r * (zq3[i] + zq1[i]);
            cq0[i] = lo;
            cq1[i] = hi;
            zq0[i] = zlo;
            zq1[i] = zhi;
            e1_acc ^= hi.mul_unreduced(zhi);
            einf_acc ^= (hi + lo).mul_unreduced(zhi + zlo);
            i += 1;
        }
        e1_acc ^= e1_wide.fold();
        einf_acc ^= einf_wide.fold();
        (e1_acc.reduce(), einf_acc.reduce())
    }
}
