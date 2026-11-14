// In-place half rows. No allocation, no final copy, same F4 arithmetic.
pub(crate) unsafe fn xseed_inplace_first(ptr:*mut F128,p:&PreparedFour,stripe:usize) {
    assert!(stripe<2);
    unsafe {for row in 0..128 {
        let lanes=if stripe==1 && row&1!=0 {28}else{32};
        let q=ptr.add(row*64+stripe*32);
        butterfly_four_private_into::<128,64,64,0,1>(q,q,p,lanes*16,ptr);
    }}
}
pub(crate) unsafe fn xseed_inplace_second(ptr:*mut F128,p:&PreparedFour,stripe:usize) {
    assert!(stripe<2);
    unsafe {for row in 0..8 {
        let lanes=if stripe==1 && row&1!=0 {28}else{32};
        let q=ptr.add(row*64);
        butterfly_four_private_into::<8,64,64,0,1>(q,q,p,lanes*16,ptr);
    }}
}

pub(crate) unsafe fn xseed_inplace_second_packed(ptr:*mut F128,p:&PreparedFour) {
    const W:usize=32;
    #[repr(align(64))]
    struct Tail([F128;64]);
    let mut scratch=core::mem::MaybeUninit::<Tail>::uninit();
    let tail=scratch.as_mut_ptr().cast::<F128>();
    unsafe {
        for row in 0..8 {
            let lanes=if row&1!=0 {W-8}else{W};
            butterfly_four_private_into::<8,64,64,0,1>(ptr.add(row*64),ptr.add(row*64),p,lanes*16,ptr);
            if row&1!=0 {for i in 0..16 {
                tail.add(i*4+(row>>1)).write(*ptr.add((i*8+row)*64+W-8));
            }}
        }
        // All64 scratch fields are initialized before the packed transform.
        butterfly_four_private_into::<1,4,4,0,0>(tail,tail,p,64,tail);
        for i in 0..16 {for j in 0..4 {
            ptr.add((i*8+2*j+1)*64+W-8).write(*tail.add(i*4+j));
        }}
    }
}

#[inline(never)]
#[target_feature(enable = "avx512f,vpclmulqdq")]
pub(crate) unsafe fn xseed_inplace_last(
    ptr: *mut F128,
    dense_lanes: usize,
    twiddles: &[F128; 7],
) {
    assert!(matches!(dense_lanes,28|32));
    let short_twiddles = !low_twiddle_fused3_disabled();
    let low_inner = short_twiddles && twiddles[1..].iter().all(|t| t.hi == 0);
    // Select each outer short form from its exact high-limb value, without
    // assuming a particular basis or a fixed fraction of eligible blocks.
    let low_outer = short_twiddles && !low_outer_fused3_disabled() && twiddles[0].hi == 0;
    let high_one_outer = short_twiddles && twiddles[0].hi == 1 && !high_one_fused3_disabled();
    // SAFETY: forwarded caller contract; `low_inner` proves the LOW
    // precondition for `twiddles[1..]`; low_outer/high_one_outer establish
    // their respective outer preconditions. 64 equals the runtime stride.
    unsafe {
        // Inspect the value, rather than assuming a particular standard
        // basis or domain size. Every other high limb keeps its prior path.
        if high_one_outer {
            match (mul_diet_disabled(), low_inner) {
                (true, false) => xseed_inplace_last_impl::<false, false, 64, false, true>(
                    ptr,
                    64,
                    dense_lanes,
                    twiddles,
                ),
                (true, true) => xseed_inplace_last_impl::<false, true, 64, false, true>(
                    ptr,
                    64,
                    dense_lanes,
                    twiddles,
                ),
                (false, false) => xseed_inplace_last_impl::<true, false, 64, false, true>(
                    ptr,
                    64,
                    dense_lanes,
                    twiddles,
                ),
                (false, true) => xseed_inplace_last_impl::<true, true, 64, false, true>(
                    ptr,
                    64,
                    dense_lanes,
                    twiddles,
                ),
            }
            return;
        }
        match (mul_diet_disabled(), low_inner) {
            (true, false) => {
                if low_outer {
                    xseed_inplace_last_impl::<false, false, 64, true, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                } else {
                    xseed_inplace_last_impl::<false, false, 64, false, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                }
            }
            (true, true) => {
                if low_outer {
                    xseed_inplace_last_impl::<false, true, 64, true, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                } else {
                    xseed_inplace_last_impl::<false, true, 64, false, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                }
            }
            (false, false) => {
                if low_outer {
                    xseed_inplace_last_impl::<true, false, 64, true, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                } else {
                    xseed_inplace_last_impl::<true, false, 64, false, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                }
            }
            (false, true) => {
                if low_outer {
                    xseed_inplace_last_impl::<true, true, 64, true, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                } else {
                    xseed_inplace_last_impl::<true, true, 64, false, false>(
                        ptr,
                        64,
                        dense_lanes,
                        twiddles,
                    )
                }
            }
        }
    }
}

#[inline(never)]
#[target_feature(enable = "avx512f,vpclmulqdq")]
unsafe fn xseed_inplace_last_impl<
    const DIET: bool,
    const LOW_INNER: bool,
    const NNC: usize,
    const LOW_OUTER: bool,
    const HIGH_ONE_OUTER: bool,
>(
    ptr: *mut F128,
    num_ntts: usize,
    dense_lanes: usize,
    twiddles: &[F128; 7],
) {
    use core::arch::x86_64::*;

    // Shape substitution (identity: the wrapper only pins the runtime value).
    let num_ntts = if NNC != 0 { NNC } else { num_ntts };
    debug_assert!(!HIGH_ONE_OUTER || twiddles[0].hi == 1);

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
        let row = |i: usize| ptr.add(i * num_ntts);
        let num_ntts = 32; // Logical stripe width; row closure retains64 pitch.
        let mut lane = 0;

        macro_rules! butterfly {
            ($values:ident, $u:expr, $v:expr, $twiddle:expr, $low:expr) => {{
                butterfly!($values, $u, $v, $twiddle, $low, false);
            }};
            ($values:ident, $u:expr, $v:expr, $twiddle:expr, $low:expr, $high_one:expr) => {{
                let product = if $high_one {
                    mul_x4_high_one($twiddle, $values[$v])
                } else {
                    mul_x4::<$low, DIET>($twiddle, $values[$v])
                };
                let new_u = _mm512_xor_si512($values[$u], product);
                $values[$v] = _mm512_xor_si512($values[$v], new_u);
                $values[$u] = new_u;
            }};
        }
        // Two lane chunks per iteration: 16 live row registers + 14 twiddle
        // registers still fit the 32 zmm file, and doubling the independent
        // butterflies per layer (4 -> 8) covers the CLMUL latency and doubles
        // the outstanding row misses.
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

        while lane + 8 <= dense_lanes {
            let mut values = [[zero; 8]; 2];
            for (c, chunk) in values.iter_mut().enumerate() {
                for (i, value) in chunk.iter_mut().enumerate() {
                    *value = _mm512_loadu_si512(row(i).add(lane + 4 * c) as *const __m512i);
                }
            }

            let outer = tw[0];
            let mut pending = [[zero; 8]; 2];
            for i in 0..4 {
                for c in 0..2 {
                    lazy_butterfly!(
                        values[c],
                        pending[c],
                        i,
                        i + 4,
                        outer,
                        LOW_OUTER,
                        HIGH_ONE_OUTER,
                        i & 2 != 0
                    );
                }
            }
            for s in 0..2 {
                let twiddle = tw[1 + s];
                for i in 0..2 {
                    for c in 0..2 {
                        lazy_butterfly!(
                            values[c],
                            pending[c],
                            4 * s + i,
                            4 * s + i + 2,
                            twiddle,
                            LOW_INNER,
                            false,
                            i & 1 != 0
                        );
                    }
                }
            }
            for s in 0..4 {
                for c in 0..2 {
                    lazy_butterfly!(
                        values[c],
                        pending[c],
                        2 * s,
                        2 * s + 1,
                        tw[3 + s],
                        LOW_INNER,
                        false,
                        true
                    );
                }
            }

            for (c, chunk) in values.iter().enumerate() {
                for (i, value) in chunk.iter().enumerate() {
                    _mm512_storeu_si512(row(i).add(lane + 4 * c) as *mut __m512i, *value);
                }
            }
            lane += 8;
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
                _mm512_storeu_si512(row(i).add(lane) as *mut __m512i, *value);
            }
            lane += 4;
        }
        // Mixed group straddling `dense_lanes` (ranked: lanes 56..59 with
        // dense_lanes = 57): one vector group instead of eight portable
        // scalar lanes. Same butterflies, same twiddles, same values.
        if NNC != 0 && lane < dense_lanes && lane + 4 <= num_ntts && !masked_tail_disabled() {
            // Rows 1, 3, 5, 7 are zero on lanes `dense_lanes..`: load them
            // masked, so the dense network sees exactly the true inputs.
            let odd_mask: __mmask8 = ((1u32 << (2 * (dense_lanes - lane))) - 1) as __mmask8;
            let mut values = [zero; 8];
            for (i, value) in values.iter_mut().enumerate() {
                *value = if i & 1 == 0 {
                    _mm512_loadu_si512(row(i).add(lane) as *const __m512i)
                } else {
                    _mm512_maskz_loadu_epi64(odd_mask, row(i).add(lane) as *const i64)
                };
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
                _mm512_storeu_si512(row(i).add(lane) as *mut __m512i, *value);
            }
            lane += 4;
        }
        if (NNC == 0 || dense_lanes & 3 != 0) && lane < dense_lanes {
            // Recompute or fall through to the cold scalar tail only when
            // `dense_lanes` is not a multiple of 4 (never on shaped `NNC = 64`).
            if NNC != 0 {
                butterfly_fused_3layer_dense_and_zero_odd_scalar_tail(
                    ptr,
                    num_ntts,
                    lane,
                    dense_lanes,
                    twiddles,
                );
                return;
            }
            lane = butterfly_fused_3layer_dense_scalar_tail(
                ptr,
                num_ntts,
                lane,
                dense_lanes,
                twiddles,
            );
        }

        // Published zero tail: rows 1, 3, 5, 7 are zero here, so only the
        // four even rows are read and the deepest layer is a copy.
        while lane + 4 <= num_ntts {
            let mut values = [zero; 8];
            for i in 0..4 {
                values[2 * i] = _mm512_loadu_si512(row(2 * i).add(lane) as *const __m512i);
            }
            let outer = tw[0];
            butterfly!(values, 0, 4, outer, LOW_OUTER, HIGH_ONE_OUTER);
            butterfly!(values, 2, 6, outer, LOW_OUTER, HIGH_ONE_OUTER);
            butterfly!(values, 0, 2, tw[1], LOW_INNER);
            butterfly!(values, 4, 6, tw[2], LOW_INNER);
            for i in 0..4 {
                let v = values[2 * i];
                _mm512_storeu_si512(row(2 * i).add(lane) as *mut __m512i, v);
                _mm512_storeu_si512(row(2 * i + 1).add(lane) as *mut __m512i, v);
            }
            lane += 4;
        }
        if NNC == 0 && lane < num_ntts {
            butterfly_fused_3layer_zero_odd_scalar_tail(ptr, num_ntts, lane, twiddles);
        }
    }
}
