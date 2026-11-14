// X6: the crown general F3 arithmetic with top interleaved or deep S8 rows.
#[inline(always)]
unsafe fn xseed_half_store<const ZMM: bool>(dst: *mut F128, value: core::arch::x86_64::__m512i) {
    use core::arch::x86_64::*;
    unsafe {
        if ZMM {
            _mm512_stream_si512(dst.cast(), value);
        } else {
            // Same 16-byte publication contract as the incumbent F2 publisher.
            _mm_stream_si128(dst.cast(), _mm512_extracti32x4_epi32::<0>(value));
            _mm_stream_si128(dst.add(1).cast(), _mm512_extracti32x4_epi32::<1>(value));
            _mm_stream_si128(dst.add(2).cast(), _mm512_extracti32x4_epi32::<2>(value));
            _mm_stream_si128(dst.add(3).cast(), _mm512_extracti32x4_epi32::<3>(value));
        }
    }
}

#[inline(never)]
#[target_feature(enable = "avx512f,vpclmulqdq")]
unsafe fn xseed_half_three_impl<const TOP: bool, const PERM: bool, const NN: usize, const ZMM: bool>(
    ptr: *mut F128, output: *mut F128, dense_lanes: usize, twiddles: &[F128; 7],
) {
    use core::arch::x86_64::*;

    const DIET: bool = true;
    const LOW_INNER: bool = false;
    const LOW_OUTER: bool = false;
    const HIGH_ONE_OUTER: bool = false;
    debug_assert!(dense_lanes <= NN && dense_lanes.is_multiple_of(4));
    // SAFETY: caller provides target features and pointer geometry.
    unsafe {
        // Seven broadcasts (plus their x^64 companions under DIET) hoisted
        // out of the lane loop: 8 rows stay live in registers across all
        // three layers, so a row is loaded once and stored once for 12
        // butterflies instead of the fused-two + single-layer pair's two
        // loads and two stores for the same 12.
        let zero = _mm512_setzero_si512();
        let mut tw = [(zero, zero); 7];
        // The high-one product needs only the original twiddle broadcast.
        tw[0] = if HIGH_ONE_OUTER {
            tw_x4::<false, false>(twiddles[0])
        } else {
            tw_x4::<LOW_OUTER, DIET>(twiddles[0])
        };
        for (slot, value) in tw[1..].iter_mut().zip(twiddles[1..].iter()) {
            *slot = tw_x4::<LOW_INNER, DIET>(*value);
        }
        let row = |i: usize| {
            let offset = if TOP {
                (i & 1) * 512 + (i >> 1) * if PERM { 16 } else { 1 }
            } else { i * if NN == 64 { 8 } else { 1 } };
            ptr.add(offset * NN)
        };
        let out = |i: usize| if TOP { output.add(i * 1024 * NN) } else { row(i) };
        let mut lane = 0;

        // These layers use seven GENERAL twiddles (fourteen registers).
        // One four-lane chunk keeps eight data rows plus lazy accumulators
        // resident. The final-three crown's two-chunk loop relies on cheap
        // inner coefficients and spills when used for these general layers.
        // Dense-loop butterfly with lazy x^64 folds (diet forms only): the
        // product's x^64-position half accumulates in `$m[$u]`, `v ^= u`
        // shares it, and it is folded when `$fold` (the row is a multiplicand
        // in the next layer, or this is the last layer). Eight folds per four
        // lanes instead of twelve; same field elements.
        macro_rules! lazy_butterfly {
            ($p:expr, $m:expr, $u:expr, $v:expr, $twiddle:expr, $low:expr, $high_one:expr, $fold:expr) => {{
                if DIET {
                    let (lo, hi) = if $high_one {
                        mul_x4_high_one_parts($twiddle, $p[$v])
                    } else {
                        mul_x4_parts::<$low>($twiddle, $p[$v])
                    };
                    $m[$u] = _mm512_xor_si512($m[$u], hi);
                    let mut new_u = _mm512_xor_si512($p[$u], lo);
                    if $fold {
                        new_u = _mm512_xor_si512(new_u, fold_x64($m[$u]));
                        $m[$u] = zero;
                    }
                    $p[$v] = _mm512_xor_si512($p[$v], new_u);
                    $m[$v] = _mm512_xor_si512($m[$v], $m[$u]);
                    $p[$u] = new_u;
                } else {
                    let product = if $high_one {
                        mul_x4_high_one($twiddle, $p[$v])
                    } else {
                        mul_x4::<$low, DIET>($twiddle, $p[$v])
                    };
                    let new_u = _mm512_xor_si512($p[$u], product);
                    $p[$v] = _mm512_xor_si512($p[$v], new_u);
                    $p[$u] = new_u;
                }
            }};
        }

        while lane + 4 <= dense_lanes {
            let mut values = [zero; 8];
            for (i, value) in values.iter_mut().enumerate() {
                *value = _mm512_loadu_si512(row(i).add(lane) as *const __m512i);
            }

            let outer = tw[0];
            let mut pending = [zero; 8];
            for i in 0..4 {
                lazy_butterfly!(
                    values,
                    pending,
                    i,
                    i + 4,
                    outer,
                    LOW_OUTER,
                    HIGH_ONE_OUTER,
                    i & 2 != 0
                );
            }
            for s in 0..2 {
                let twiddle = tw[1 + s];
                for i in 0..2 {
                    lazy_butterfly!(
                        values,
                        pending,
                        4 * s + i,
                        4 * s + i + 2,
                        twiddle,
                        LOW_INNER,
                        false,
                        i & 1 != 0
                    );
                }
            }
            for s in 0..4 {
                lazy_butterfly!(
                    values,
                    pending,
                    2 * s,
                    2 * s + 1,
                    tw[3 + s],
                    LOW_INNER,
                    false,
                    true
                );
            }

            for (i, value) in values.iter().enumerate() {
                if TOP {
                    xseed_half_store::<ZMM>(out(i).add(lane), *value);
                } else {
                    _mm512_storeu_si512(out(i).add(lane) as *mut __m512i, *value);
                }
            }
            lane += 4;
        }
        // Top odd rows have a wholly zero suffix. It was never seeded and
        // must be synthesized here; the strided in-place path leaves it alone.
        if TOP {
            while lane < NN {
                for i in 0..8 { xseed_half_store::<ZMM>(out(i).add(lane), zero); }
                lane += 4;
            }
        }
    }
}

#[inline]
pub(crate) unsafe fn xseed_half_publish(
    ptr: *mut F128, output: *mut F128, dense: usize, t: &[F128; 7], perm: bool,
) {
    unsafe {
        if (output as usize).is_multiple_of(64) {
            if perm { xseed_half_three_impl::<true, true, 64, true>(ptr, output, dense, t); }
            else { xseed_half_three_impl::<true, false, 64, true>(ptr, output, dense, t); }
        } else {
            if perm { xseed_half_three_impl::<true, true, 64, false>(ptr, output, dense, t); }
            else { xseed_half_three_impl::<true, false, 64, false>(ptr, output, dense, t); }
        }
    }
}

pub(crate) unsafe fn xseed_half_middle(
    ptr: *mut F128, t: &[F128; 7], odd_tail: usize, raw7: bool,
) {
    unsafe {
        for r in 0..8 {
            let lanes = if r & 1 == 0 { 64 } else if raw7 { 56 } else { 64 - odd_tail };
            xseed_half_three_impl::<false, false, 64, false>(ptr.add(r * 64), ptr, lanes, t);
        }
        if raw7 {
            let mut pack = [F128::ZERO; 8 * 4];
            for i in 0..8 { for j in 0..4 {
                pack[i * 4 + j] = *ptr.add((i * 8 + 2 * j + 1) * 64 + 56);
            }}
            xseed_half_three_impl::<false, false, 4, false>(pack.as_mut_ptr(), pack.as_mut_ptr(), 4, t);
            for i in 0..8 { for j in 0..4 {
                *ptr.add((i * 8 + 2 * j + 1) * 64 + 56) = pack[i * 4 + j];
            }}
        }
    }
}
