//! Checked B-complement projection for the two-image/offw round-1 path.
//!
//! For the caller-checked linear map T with T([0xff; 8]) = [ONE; 64],
//! T(B) = T(!B) + ONE. A known-one byte therefore needs no table load in
//! the complement. Only contiguous known-one prefixes/suffixes are specialized;
//! ordinary rows retain the incumbent two-image apply and original offsets.

use core::arch::x86_64::*;

use super::x86_64_bstatic_plan::{BSTATIC_PLAN, BstaticRow};
use crate::ntt::inv_table::apply_x86_avx512_register_2img_offw_at;

#[derive(Clone, Copy)]
struct WindowPlan {
    /// Bit 8*k+j requires raw B byte j of K-row k to equal 0xff.
    required: u64,
    /// Modes 0..15, or GG2 at the higher K of two generic tail rows.
    /// The K7 mode is in the least-significant byte and is never paired.
    modes: u64,
}

const MODE_GG2: u8 = 16;

/// Do not use BstaticRow::vary: the old plan clears it for seven varying bytes.
const fn known_one_bytes(row: BstaticRow) -> u8 {
    let mut known = 0u8;
    let mut j = 0;
    while j < 8 {
        if (row.mask >> (8 * j)) & 0xff == 0xff && (row.expected >> (8 * j)) & 0xff == 0xff {
            known |= 1 << j;
        }
        j += 1;
    }
    known
}

/// 0: dense; 1..7: low n bytes known; 8..14: high n bytes known; 15: all known.
const fn mode_for_known_bytes(known: u8) -> u8 {
    if known == 0xff {
        return 15;
    }
    let mut n = 1;
    while n < 8 {
        if known == ((1u16 << n) - 1) as u8 {
            return n;
        }
        if known == (0xffu16 << (8 - n)) as u8 {
            return 7 + n;
        }
        n += 1;
    }
    // Any future non-prefix/suffix shape keeps the full original-B apply.
    0
}

/// Greedily pair generic rows while walking K6..K0. The opcode replaces only
/// the first zero byte of a pair; its second byte remains zero. No extra plan
/// storage is needed, and the separately initialized K7 is left unchanged.
const fn pair_generic_tail(mut modes: u64) -> u64 {
    let mut position = 1usize;
    while position < 7 {
        let shift = 8 * position;
        if (modes >> shift) as u16 == 0 {
            modes |= (MODE_GG2 as u64) << shift;
            position += 2;
        } else {
            position += 1;
        }
    }
    modes
}

const fn build_window_plans() -> [WindowPlan; 28] {
    let mut plans = [WindowPlan {
        required: 0,
        modes: 0,
    }; 28];
    let mut blk = 2;
    while blk <= 29 {
        let mut k = 0;
        while k < 8 {
            let known = known_one_bytes(BSTATIC_PLAN[blk][k]);
            let mode = mode_for_known_bytes(known);
            if mode != 0 {
                plans[blk - 2].required |= (known as u64) << (8 * k);
            }
            plans[blk - 2].modes |= (mode as u64) << (8 * (7 - k));
            k += 1;
        }
        // Only full interior windows get pair opcodes. Both legal residual
        // KEEP masks belong to 2/29, whose mode words remain unmodified even
        // when those boundary windows are requested with KEEP=ff.
        if blk > 2 && blk < 29 {
            plans[blk - 2].modes = pair_generic_tail(plans[blk - 2].modes);
        }
        blk += 1;
    }
    plans
}

const WINDOW_PLANS: [WindowPlan; 28] = build_window_plans();

/// Try one complete window without changing the offset arena. A guard miss or
/// unsupported (blk, keep) returns false without writing anything to out.
///
/// # Safety
/// - The CPU supports GFNI, AVX-512F and AVX-512BW.
/// - imgs are the base and sigma-8 images of the same eight-byte, 64-output,
///   zero-based F2-linear inverse-NTT table. The caller has checked once that
///   applying this map to eight 0xff bytes gives 64 bytes of F8::ONE (0x01).
/// - op addresses the original 128-u16 arena (A then B). Every retained K-row
///   has eight readable offsets per operand, each equal to its raw byte << 6.
///   b_raw addresses the corresponding B bytes; its retained K-rows are readable
///   and agree with the B offsets. Omitted rows need not be initialized.
/// - out is 64-byte aligned and does not alias any input. The caller fences the
///   non-temporal store before publishing or reading a successful result.
// The existing outlined streaming consumer owns the call boundary. Inlining
// here keeps its spread publication loop without adding a call per window.
#[inline(always)]
pub(crate) unsafe fn try_shift_reduce_bcomplement_offw_nt2(
    op: *const u16,
    b_raw: *const u8,
    out: &mut [u8; 64],
    imgs: (*const u8, *const u8),
    blk: usize,
    keep: u8,
) -> bool {
    if !(2..=29).contains(&blk) {
        return false;
    }
    let (first_k, last_k, live_bytes) = match keep {
        0xff => (7usize, 0usize, u64::MAX),
        0xfc if blk == 2 => (7, 2, u64::MAX << 16),
        0x0f if blk == 29 => (3, 0, 0xffff_ffff),
        _ => return false,
    };
    let plan = WINDOW_PLANS[blk - 2];
    let required = plan.required & live_bytes;
    // SAFETY: only KEEP-selected qwords are loaded. In particular, the guard
    // does not inspect omitted residual rows, even if they were never emitted.
    unsafe {
        let raw = _mm512_maskz_loadu_epi64(keep, b_raw.cast::<i64>());
        if _mm512_mask_cmpeq_epi8_mask(required, raw, _mm512_set1_epi8(-1)) != required {
            return false;
        }

        let mut modes = plan.modes >> ((7 - first_k) * 8);
        let apply = |p| apply_x86_avx512_register_2img_offw_at(imgs.0, imgs.1, p);
        let av = apply(op.add(first_k * 8));
        let bv = apply_b_mode(imgs, op.add(64 + first_k * 8), modes as u8);
        let mut acc = _mm512_gf2p8mul_epi8(av, bv);
        let x = _mm512_set1_epi8(2);
        modes >>= 8;
        // k is one past the next retained K. A single dispatch consumes one
        // row, or two generic rows through GG2; all shifts remain constants.
        let mut k = first_k;
        while k > last_k {
            let av = apply(op.add((k - 1) * 8));
            let bp = op.add(64 + (k - 1) * 8);
            let bv = match modes as u8 {
                MODE_GG2 => {
                    // The private const plan emits GG2 only for two original
                    // mode-0 rows in K6..K0 of a full interior window.
                    debug_assert!(keep == 0xff && k >= 2 && last_k == 0);
                    let product = _mm512_gf2p8mul_epi8(av, apply(bp));
                    // Two old steps x*(x*acc+p_hi)+p_lo are exactly
                    // x^2*acc+x*p_hi+p_lo. Keep two products, two scales and
                    // two XORs, without a second mode dispatch or loop test.
                    let carried = _mm512_xor_si512(
                        _mm512_gf2p8mul_epi8(acc, _mm512_set1_epi8(4)),
                        _mm512_gf2p8mul_epi8(product, x),
                    );
                    let next_a = apply(op.add((k - 2) * 8));
                    let next_b = apply(op.add(64 + (k - 2) * 8));
                    acc = _mm512_xor_si512(carried, _mm512_gf2p8mul_epi8(next_a, next_b));
                    k -= 2;
                    modes >>= 16;
                    continue;
                }
                1 => apply_b_complement::<1, 8>(imgs, bp),
                2 => apply_b_complement::<2, 8>(imgs, bp),
                3 => apply_b_complement::<3, 8>(imgs, bp),
                4 => apply_b_complement::<4, 8>(imgs, bp),
                5 => apply_b_complement::<5, 8>(imgs, bp),
                6 => apply_b_complement::<6, 8>(imgs, bp),
                7 => apply_b_complement::<7, 8>(imgs, bp),
                8 => apply_b_complement::<0, 7>(imgs, bp),
                9 => apply_b_complement::<0, 6>(imgs, bp),
                10 => apply_b_complement::<0, 5>(imgs, bp),
                11 => apply_b_complement::<0, 4>(imgs, bp),
                12 => apply_b_complement::<0, 3>(imgs, bp),
                13 => apply_b_complement::<0, 2>(imgs, bp),
                14 => apply_b_complement::<0, 1>(imgs, bp),
                15 => _mm512_set1_epi8(1),
                _ => apply(bp),
            };
            let product = _mm512_gf2p8mul_epi8(av, bv);
            acc = _mm512_xor_si512(_mm512_gf2p8mul_epi8(acc, x), product);
            k -= 1;
            modes >>= 8;
        }
        // KEEP=fc retains the original x^2..x^7 weights, not a compressed
        // degree-0..5 polynomial. KEEP=0f already ends at the true constant term.
        if last_k == 2 {
            acc = _mm512_gf2p8mul_epi8(acc, _mm512_set1_epi8(4));
        }
        _mm512_stream_si512(out.as_mut_ptr().cast::<__m512i>(), acc);
    }
    true
}

/// Shared dispatch inside the existing consumer, not one call per K-row.
#[inline(always)]
unsafe fn apply_b_mode(imgs: (*const u8, *const u8), op: *const u16, mode: u8) -> __m512i {
    unsafe {
        match mode {
            1 => apply_b_complement::<1, 8>(imgs, op),
            2 => apply_b_complement::<2, 8>(imgs, op),
            3 => apply_b_complement::<3, 8>(imgs, op),
            4 => apply_b_complement::<4, 8>(imgs, op),
            5 => apply_b_complement::<5, 8>(imgs, op),
            6 => apply_b_complement::<6, 8>(imgs, op),
            7 => apply_b_complement::<7, 8>(imgs, op),
            8 => apply_b_complement::<0, 7>(imgs, op),
            9 => apply_b_complement::<0, 6>(imgs, op),
            10 => apply_b_complement::<0, 5>(imgs, op),
            11 => apply_b_complement::<0, 4>(imgs, op),
            12 => apply_b_complement::<0, 3>(imgs, op),
            13 => apply_b_complement::<0, 2>(imgs, op),
            14 => apply_b_complement::<0, 1>(imgs, op),
            15 => _mm512_set1_epi8(1),
            _ => apply_x86_avx512_register_2img_offw_at(imgs.0, imgs.1, op),
        }
    }
}

/// Only bytes FIRST..END of !B vary. Retain the incumbent two-image butterfly
/// but remove every absent row and its XOR at compile time. FIRST/END are
/// literals in the fourteen prefix/suffix instantiations above.
#[inline(always)]
unsafe fn apply_b_complement<const FIRST: usize, const END: usize>(
    imgs: (*const u8, *const u8),
    op: *const u16,
) -> __m512i {
    const COMPLEMENT_OFFSETS: u64 = 0x3fc0_3fc0_3fc0_3fc0;
    unsafe {
        // An offset is byte << 6, so complementing a byte XORs exactly these
        // eight bits. Do not complement the u16 itself or touch the arena.
        let w0 = if FIRST < 4 {
            op.cast::<u64>().read_unaligned() ^ COMPLEMENT_OFFSETS
        } else {
            0
        };
        let w1 = if END > 4 {
            op.add(4).cast::<u64>().read_unaligned() ^ COMPLEMENT_OFFSETS
        } else {
            0
        };
        let row = |img: *const u8, o: usize| _mm512_loadu_si512(img.add(o).cast::<__m512i>());
        // The conditions use only const parameters. Each surviving component
        // is evaluated once, and a one-sided join has no XOR with zero.
        macro_rules! join {
            ($left:expr, $has_left:expr, $right:expr, $has_right:expr) => {
                if $has_left {
                    if $has_right {
                        _mm512_xor_si512($left, $right)
                    } else {
                        $left
                    }
                } else if $has_right {
                    $right
                } else {
                    _mm512_setzero_si512()
                }
            };
        }
        let u0 = join!(
            row(imgs.0, w0 as u16 as usize),
            FIRST == 0,
            row(imgs.1, (w0 >> 16) as u16 as usize),
            FIRST <= 1 && END > 1
        );
        let u1 = join!(
            row(imgs.0, (w0 >> 32) as u16 as usize),
            FIRST <= 2 && END > 2,
            row(imgs.1, (w0 >> 48) as usize),
            FIRST <= 3 && END > 3
        );
        let u2 = join!(
            row(imgs.0, w1 as u16 as usize),
            FIRST <= 4 && END > 4,
            row(imgs.1, (w1 >> 16) as u16 as usize),
            FIRST <= 5 && END > 5
        );
        let u3 = join!(
            row(imgs.0, (w1 >> 32) as u16 as usize),
            FIRST <= 6 && END > 6,
            row(imgs.1, (w1 >> 48) as usize),
            END == 8
        );
        let even = join!(
            u0,
            FIRST < 2,
            _mm512_shuffle_i64x2::<0x4E>(u2, u2),
            FIRST < 6 && END > 4
        );
        let odd = join!(
            u1,
            FIRST < 4 && END > 2,
            _mm512_shuffle_i64x2::<0x4E>(u3, u3),
            END > 6
        );
        let complement = join!(
            even,
            FIRST < 2 || (FIRST < 6 && END > 4),
            _mm512_shuffle_i64x2::<0xB1>(odd, odd),
            (FIRST < 4 && END > 2) || END > 6
        );
        // Return the actual projection, keeping Horner free of an additional
        // per-K correction branch. This is one extra vector XOR per partial row.
        _mm512_xor_si512(complement, _mm512_set1_epi8(1))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::F8;
    use crate::ntt::AdditiveNttGf8;
    use crate::ntt::inv_table::InvNttTableByteSingleGf8;

    #[repr(align(64))]
    struct Output([u8; 64]);

    fn table(shift: u8) -> InvNttTableByteSingleGf8 {
        InvNttTableByteSingleGf8::new(
            &AdditiveNttGf8::new(6, F8::ZERO),
            &AdditiveNttGf8::new(6, F8(shift)),
        )
    }

    /// Independent producer geometry, not the pre-generated static-B plan.
    fn one_bit(bit: usize) -> bool {
        bit < 1153
            || (15153..15409).contains(&bit)
            || (0..56).any(|g| {
                let start = 1153 + g * 250;
                (start + 186..start + 250).contains(&bit)
            })
    }

    fn geometry_known_bytes(blk: usize, k: usize) -> u8 {
        let mut known = 0;
        for j in 0..8 {
            let start = blk * 512 + k * 64 + j * 8;
            if (start..start + 8).all(one_bit) {
                known |= 1 << j;
            }
        }
        known
    }

    fn fixed_bytes_for_mode(mode: u8) -> u8 {
        match mode {
            1..=7 => ((1u16 << mode) - 1) as u8,
            8..=14 => (0xffu16 << (15 - mode)) as u8,
            15 => 0xff,
            _ => 0,
        }
    }

    fn check_projection(table: &InvNttTableByteSingleGf8, mode: u8, b: &[u8; 8]) {
        let off = b.map(|byte| u16::from(byte) << 6);
        let saved = off;
        let mut want = [F8::ZERO; 64];
        table.apply_scalar(b, &mut want);
        let mut got = [0u8; 64];
        // SAFETY: the module's cfg requires all used CPU features. This table
        // has both images, its all-one image is checked in the calling test,
        // and these offsets encode the guarded original B bytes.
        unsafe {
            let value = apply_b_mode(table.image_ptrs(), off.as_ptr(), mode);
            _mm512_storeu_si512(got.as_mut_ptr().cast::<__m512i>(), value);
        }
        assert_eq!(got, want.map(|value| value.0), "mode={mode} B={b:?}");
        assert_eq!(off, saved);
    }

    #[test]
    fn complement_plans_match_wire_geometry_and_all_fourteen_masks() {
        let mut seen = 0u16;
        let mut rows = 0;
        let mut partial_rows = 0;
        let mut removed_loads = 0;
        let mut middle_removed_loads = 0;
        for blk in 2..=29 {
            let plan = WINDOW_PLANS[blk - 2];
            let keep = match blk {
                2 => 0xfc,
                29 => 0x0f,
                _ => 0xff,
            };
            for k in 0..8 {
                let known = geometry_known_bytes(blk, k);
                let opcode = (plan.modes >> (8 * (7 - k))) as u8;
                let mode = if opcode == MODE_GG2 { 0 } else { opcode };
                assert_eq!(known_one_bytes(BSTATIC_PLAN[blk][k]), known);
                assert_eq!(fixed_bytes_for_mode(mode), known, "blk={blk} k={k}");
                assert_eq!((plan.required >> (8 * k)) as u8, known);
                if keep & (1 << k) == 0 {
                    continue;
                }
                rows += 1;
                if mode != 0 {
                    assert_ne!(mode, 15, "complete-one rows are residual-elided");
                    seen |= 1 << mode;
                    partial_rows += 1;
                    removed_loads += known.count_ones();
                    if (3..=28).contains(&blk) {
                        middle_removed_loads += known.count_ones();
                    }
                }
            }
        }
        assert_eq!(seen, 0x7ffe);
        assert_eq!((rows, partial_rows, removed_loads), (218, 97, 386));
        assert_eq!(middle_removed_loads, 372);
        for known in 0..=u8::MAX {
            let mode = mode_for_known_bytes(known);
            assert!(mode <= 15);
            if mode != 0 {
                assert_eq!(fixed_bytes_for_mode(mode), known);
            }
        }
    }

    #[test]
    fn gg2_tags_match_all_generic_patterns_and_ranked_pair_positions() {
        // Pairing depends only on zero versus nonzero modes. Exhaust every
        // eight-row pattern, including both choices for the unpaired K7.
        for generic in 0..=u8::MAX {
            let original: [u8; 8] = core::array::from_fn(|k| {
                if generic & (1 << k) != 0 {
                    0
                } else {
                    1 + k as u8
                }
            });
            let mut packed = 0u64;
            for (k, &mode) in original.iter().enumerate() {
                packed |= u64::from(mode) << (8 * (7 - k));
            }
            let tagged = pair_generic_tail(packed);
            assert_eq!(tagged as u8, original[7]);
            let mut remaining = 7usize;
            while remaining != 0 {
                let k = remaining - 1;
                let mode = (tagged >> (8 * (7 - k))) as u8;
                if k > 0 && original[k] == 0 && original[k - 1] == 0 {
                    assert_eq!(mode, MODE_GG2);
                    assert_eq!((tagged >> (8 * (8 - k))) as u8, 0);
                    remaining -= 2;
                } else {
                    assert_eq!(mode, original[k]);
                    remaining -= 1;
                }
            }
        }

        // Bit k is the higher row of a pair. These 26 entries record the
        // circuit-derived K6..K0 greedy census, not a count of G/P templates.
        const EXPECTED_HIGH_K: [u8; 26] = [
            0x08, 0x08, 0x08, 0x08, 0x48, 0x44, 0x44, 0x44, 0x44, 0x44, 0x22, 0x22, 0x22,
            0x22, 0x22, 0x12, 0x10, 0x10, 0x10, 0x10, 0x10, 0x08, 0x08, 0x08, 0x08, 0x48,
        ];
        let mut pairs = 0;
        for blk in 2..=29 {
            let plan = WINDOW_PLANS[blk - 2];
            let mut high_k = 0u8;
            for k in 0..8 {
                let mode = (plan.modes >> (8 * (7 - k))) as u8;
                if mode == MODE_GG2 {
                    assert!((1..=6).contains(&k));
                    assert_eq!(geometry_known_bytes(blk, k), 0);
                    assert_eq!(geometry_known_bytes(blk, k - 1), 0);
                    high_k |= 1 << k;
                } else {
                    assert_eq!(mode, mode_for_known_bytes(geometry_known_bytes(blk, k)));
                }
            }
            let expected = if (3..29).contains(&blk) {
                EXPECTED_HIGH_K[blk - 3]
            } else {
                0
            };
            assert_eq!(high_k, expected, "blk={blk}");
            pairs += high_k.count_ones();
        }
        assert_eq!(pairs, 39);
        assert_eq!(core::mem::size_of::<WindowPlan>(), 16);
    }

    #[test]
    fn gg2_and_residual_schedules_visit_each_k_once_at_its_original_weight() {
        for blk in 2..=29 {
            for keep in [0xffu8, 0xfc, 0x0f] {
                let (first, last) = match keep {
                    0xff => (7usize, 0usize),
                    0xfc if blk == 2 => (7, 2),
                    0x0f if blk == 29 => (3, 0),
                    _ => continue,
                };
                let mut modes = WINDOW_PLANS[blk - 2].modes >> (8 * (7 - first));
                assert_ne!(modes as u8, MODE_GG2, "the initial K is always one row");
                let mut visits = [0u8; 8];
                let mut weights = [0u16; 8];
                visits[first] = 1;
                weights[first] = 1;
                modes >>= 8;
                let mut remaining = first;
                while remaining > last {
                    let paired = modes as u8 == MODE_GG2;
                    let width = if paired { 2 } else { 1 };
                    if paired {
                        assert_eq!(keep, 0xff);
                        assert!((3..29).contains(&blk));
                        assert!(remaining >= 2);
                        assert_eq!(geometry_known_bytes(blk, remaining - 1), 0);
                        assert_eq!(geometry_known_bytes(blk, remaining - 2), 0);
                    }
                    for weight in &mut weights {
                        *weight <<= width;
                    }
                    visits[remaining - 1] += 1;
                    weights[remaining - 1] ^= if paired { 2 } else { 1 };
                    if paired {
                        visits[remaining - 2] += 1;
                        weights[remaining - 2] ^= 1;
                    }
                    remaining -= width;
                    modes >>= 8 * width;
                }
                for k in 0..8 {
                    if last == 2 {
                        weights[k] <<= 2;
                    }
                    let retained = keep & (1 << k) != 0;
                    assert_eq!(visits[k], u8::from(retained), "blk={blk} keep={keep:#x} K={k}");
                    assert_eq!(weights[k], if retained { 1 << k } else { 0 });
                }
            }
        }
    }

    #[test]
    fn pruned_two_image_projection_matches_all_variable_basis_bits() {
        for shift in [64, 128, 192] {
            let table = table(shift);
            let mut ones = [F8::ZERO; 64];
            table.apply_scalar(&[0xff; 8], &mut ones);
            assert_eq!(ones, [F8::ONE; 64]);
            for mode in 1..=14 {
                let known = fixed_bytes_for_mode(mode);
                check_projection(&table, mode, &[0xff; 8]);
                for bit in 0..64 {
                    if known & (1 << (bit / 8)) == 0 {
                        let mut b = [0xff; 8];
                        b[bit / 8] ^= 1 << (bit % 8);
                        check_projection(&table, mode, &b);
                    }
                }
                // Basis tests catch position/permutation errors; mixed bytes
                // also exercise all packed-u16 extraction positions together.
                for pattern in [0, 0x55, 0xaa, 0xff] {
                    let mut b = [0xff; 8];
                    for (j, byte) in b.iter_mut().enumerate() {
                        if known & (1 << j) == 0 {
                            *byte = pattern ^ (j as u8).wrapping_mul(29);
                        }
                    }
                    check_projection(&table, mode, &b);
                }
            }
            check_projection(&table, 15, &[0xff; 8]);
            for mode in [0, 16, 255] {
                check_projection(&table, mode, &[0, 1, 2, 4, 8, 16, 128, 255]);
            }
        }
    }

    fn window_input(blk: usize) -> ([u8; 64], [u8; 64], [u16; 128]) {
        let a = core::array::from_fn(|j| (j as u8).wrapping_mul(37).wrapping_add(19));
        let mut b = core::array::from_fn(|j| (j as u8).wrapping_mul(73).wrapping_add(41));
        for k in 0..8 {
            let known = geometry_known_bytes(blk, k);
            for j in 0..8 {
                if known & (1 << j) != 0 {
                    b[k * 8 + j] = 0xff;
                }
            }
        }
        let off = core::array::from_fn(|j| u16::from(if j < 64 { a[j] } else { b[j - 64] }) << 6);
        (a, b, off)
    }

    fn scalar_window(
        table: &InvNttTableByteSingleGf8,
        a: &[u8; 64],
        b: &[u8; 64],
        keep: u8,
    ) -> [u8; 64] {
        let mut out = [F8::ZERO; 64];
        for k in 0..8 {
            if keep & (1 << k) == 0 {
                continue;
            }
            let mut av = [F8::ZERO; 64];
            let mut bv = [F8::ZERO; 64];
            table.apply_scalar(&a[k * 8..k * 8 + 8], &mut av);
            table.apply_scalar(&b[k * 8..k * 8 + 8], &mut bv);
            for lane in 0..64 {
                out[lane] += av[lane] * bv[lane] * F8(1 << k);
            }
        }
        out.map(|value| value.0)
    }

    /// The incumbent one-K-at-a-time Horner, with modes independently derived
    /// from wire geometry rather than read from the new tagged mode words.
    fn unpaired_horner(
        table: &InvNttTableByteSingleGf8,
        blk: usize,
        off: &[u16; 128],
        keep: u8,
    ) -> [u8; 64] {
        let (first, last) = match keep {
            0xff => (7usize, 0usize),
            0xfc if blk == 2 => (7, 2),
            0x0f if blk == 29 => (3, 0),
            _ => unreachable!("oracle receives only legal KEEP shapes"),
        };
        let imgs = table.image_ptrs();
        let mut out = [0u8; 64];
        unsafe {
            let apply = |p| apply_x86_avx512_register_2img_offw_at(imgs.0, imgs.1, p);
            let product = |k| {
                let av = apply(off.as_ptr().add(k * 8));
                let mode = mode_for_known_bytes(geometry_known_bytes(blk, k));
                let bv = apply_b_mode(imgs, off.as_ptr().add(64 + k * 8), mode);
                _mm512_gf2p8mul_epi8(av, bv)
            };
            let mut acc = product(first);
            for k in (last..first).rev() {
                acc = _mm512_xor_si512(
                    _mm512_gf2p8mul_epi8(acc, _mm512_set1_epi8(2)),
                    product(k),
                );
            }
            if last == 2 {
                acc = _mm512_gf2p8mul_epi8(acc, _mm512_set1_epi8(4));
            }
            _mm512_storeu_si512(out.as_mut_ptr().cast::<__m512i>(), acc);
        }
        out
    }

    #[test]
    fn gg2_full_and_residual_windows_match_scalar_and_unpaired_horner() {
        for shift in [64, 128, 192] {
            let table = table(shift);
            for blk in 2..=29 {
                for keep in [0xffu8, 0xfc, 0x0f] {
                    if keep != 0xff
                        && !((blk == 2 && keep == 0xfc) || (blk == 29 && keep == 0x0f))
                    {
                        continue;
                    }
                    for pattern in 0..4 {
                        let (mut a, mut b, _) = window_input(blk);
                        for byte in 0..64 {
                            a[byte] = match pattern {
                                0 => 0,
                                1 => 0xff,
                                2 => a[byte] ^ 0x55,
                                _ => a[byte],
                            };
                            if geometry_known_bytes(blk, byte / 8) & (1 << (byte % 8)) == 0 {
                                b[byte] = match pattern {
                                    0 => 0,
                                    1 => 0xff,
                                    2 => b[byte] ^ 0xaa,
                                    _ => b[byte],
                                };
                            }
                        }
                        let off = core::array::from_fn(|j| {
                            u16::from(if j < 64 { a[j] } else { b[j - 64] }) << 6
                        });
                        let saved = off;
                        let mut out = Output([0xa5; 64]);
                        let hit = unsafe {
                            try_shift_reduce_bcomplement_offw_nt2(
                                off.as_ptr(),
                                b.as_ptr(),
                                &mut out.0,
                                table.image_ptrs(),
                                blk,
                                keep,
                            )
                        };
                        unsafe { _mm_sfence() };
                        assert!(hit, "blk={blk} keep={keep:#x} shift={shift}");
                        assert_eq!(out.0, unpaired_horner(&table, blk, &off, keep));
                        assert_eq!(out.0, scalar_window(&table, &a, &b, keep));
                        assert_eq!(off, saved);
                    }
                }
            }
        }
    }

    #[test]
    fn residual_horner_preserves_true_k_weights_and_ignores_poisoned_offsets() {
        let table = table(64);
        for (blk, keep) in [(2, 0xfc), (29, 0x0f)] {
            let (mut a, mut b, mut off) = window_input(blk);
            for j in 0..64 {
                if keep & (1 << (j / 8)) == 0 {
                    a[j] = 0;
                    b[j] = 0;
                    // Fully initialized poison, not an invalid reference to
                    // uninitialized storage. Only retained offsets are valid.
                    off[j] = 0xffff;
                    off[64 + j] = 0xffff;
                }
            }
            let saved = off;
            let mut out = Output([0xa5; 64]);
            let hit = unsafe {
                try_shift_reduce_bcomplement_offw_nt2(
                    off.as_ptr(),
                    b.as_ptr(),
                    &mut out.0,
                    table.image_ptrs(),
                    blk,
                    keep,
                )
            };
            unsafe { _mm_sfence() };
            assert!(hit);
            assert_eq!(out.0, scalar_window(&table, &a, &b, keep));
            assert_eq!(off, saved);
        }
    }

    #[test]
    fn rejected_window_shapes_never_write_output() {
        let table = table(64);
        let (_, b, off) = window_input(3);
        for blk in [0, 1, 2, 3, 28, 29, 30, 31, 32, usize::MAX] {
            for keep in 0..=u8::MAX {
                let valid = (2..=29).contains(&blk)
                    && (keep == 0xff || (blk == 2 && keep == 0xfc) || (blk == 29 && keep == 0x0f));
                if valid {
                    continue;
                }
                let mut out = Output([0xa5; 64]);
                let hit = unsafe {
                    try_shift_reduce_bcomplement_offw_nt2(
                        off.as_ptr(),
                        b.as_ptr(),
                        &mut out.0,
                        table.image_ptrs(),
                        blk,
                        keep,
                    )
                };
                assert!(!hit, "blk={blk} keep={keep:#x}");
                assert_eq!(out.0, [0xa5; 64]);
            }
        }
    }
}
