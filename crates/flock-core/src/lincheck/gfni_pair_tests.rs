//! Source-only regression tests for the two-tile non-seed accumulator.
//! These tests were added without executing a compiler, test, or simulator.

use super::*;

const HALO: usize = 192;
const INPUT_POISON: u8 = 0x93;
const OUTPUT_POISON: u8 = 0xD7;

fn value(index: usize, salt: u64) -> F128 {
    let x = (index as u64)
        .wrapping_mul(0x9E37_79B9_7F4A_7C15)
        .wrapping_add(salt);
    F128 {
        lo: x.rotate_left(17) ^ 0xD6E8_FEB8_6659_FD93,
        hi: x.rotate_right(23).wrapping_mul(0xA24B_AED4_963E_E407) ^ 0x9FB2_1C65_1E98_DF25,
    }
}

/// Choose an actual address residue, not merely a Vec-relative offset.
/// The allocations below reserve two HALOs, including the extra 0..63 bytes.
fn offset_with_residue(bytes: &[u8], residue: usize) -> usize {
    assert!(residue < 64);
    let base = (bytes.as_ptr() as usize + HALO) & 63;
    HALO + (residue + 64 - base) % 64
}

fn basis(salt: u64) -> [[F128; 8]; 8] {
    std::array::from_fn(|stripe| std::array::from_fn(|bit| value(stripe * 8 + bit, salt)))
}

fn matrices(eq: &[[F128; 8]; 8]) -> [u64; 128] {
    let mut result = [0u64; 128];
    for (stripe, eq8) in eq.iter().enumerate() {
        kernels::fold_mats_from_basis(eq8, &mut result[stripe * 16..(stripe + 1) * 16]);
    }
    result
}

fn sum_tables(eq: &[[F128; 8]; 8]) -> Vec<[F128; 256]> {
    eq.iter()
        .map(|eq8| {
            let mut table = [F128::ZERO; 256];
            build_sum_table(eq8, &mut table);
            table
        })
        .collect()
}

/// Independent F128 subset sums; neither GFNI matrices nor a SIMD transpose
/// are used to obtain the expected result. Bytes are decoded and encoded
/// directly using the documented block/plane/column layout.
fn scalar_add_tile(
    tile: &[u8],
    stripe_stride: usize,
    n_blocks64: usize,
    tables: &[[F128; 256]],
    planes: &mut [u8],
) {
    assert_eq!(tables.len(), 8);
    assert_eq!(planes.len(), n_blocks64 * 1024);
    for block in 0..n_blocks64 {
        let plane_base = block * 1024;
        for column in 0..64 {
            let mut acc = F128::ZERO;
            for byte in 0..8 {
                acc.lo |= (planes[plane_base + byte * 64 + column] as u64) << (byte * 8);
                acc.hi |= (planes[plane_base + (byte + 8) * 64 + column] as u64) << (byte * 8);
            }
            for (stripe, table) in tables.iter().enumerate() {
                acc += table[tile[stripe * stripe_stride + block * 64 + column] as usize];
            }
            for (byte, v) in acc.lo.to_le_bytes().into_iter().enumerate() {
                planes[plane_base + byte * 64 + column] = v;
            }
            for (byte, v) in acc.hi.to_le_bytes().into_iter().enumerate() {
                planes[plane_base + (byte + 8) * 64 + column] = v;
            }
        }
    }
}

#[derive(Clone, Copy, Debug)]
struct LeafCase {
    blocks: usize,
    stride: usize,
    residues: [usize; 3],
    // Some(delta) places both read-only tiles in input0's allocation. Output
    // and matrices always have independent allocations/storage.
    alias_delta: Option<usize>,
}

fn check_leaf(case: LeafCase, eq0: &[[F128; 8]; 8], eq1: &[[F128; 8]; 8], repeats: usize) {
    assert!(case.stride >= case.blocks * 64);
    assert!(matches!(repeats, 1 | 2));
    let span = if case.blocks == 0 {
        0
    } else {
        7 * case.stride + case.blocks * 64
    };
    let overlap = case.alias_delta.unwrap_or(0);
    let mut input0 = vec![INPUT_POISON; 2 * HALO + span + overlap];
    let mut input1 = vec![INPUT_POISON; 2 * HALO + span];
    let start0 = offset_with_residue(&input0, case.residues[0]);
    let start1 = offset_with_residue(&input1, case.residues[1]);
    // Multiplication by an odd number visits all 256 index bytes in each
    // 256-byte row of the four-block case; the two tiles differ throughout.
    for (i, byte) in input0[start0..start0 + span + overlap].iter_mut().enumerate() {
        *byte = (i as u8).wrapping_mul(13).wrapping_add(0x35);
    }
    for (i, byte) in input1[start1..start1 + span].iter_mut().enumerate() {
        *byte = (i as u8).wrapping_mul(29).wrapping_add(0xCA);
    }
    let before0 = input0.clone();
    let before1 = input1.clone();
    let tile0 = &input0[start0..start0 + span];
    let tile1 = if let Some(delta) = case.alias_delta {
        &input0[start0 + delta..start0 + delta + span]
    } else {
        &input1[start1..start1 + span]
    };
    let mats0 = matrices(eq0);
    let mats1 = matrices(eq1);
    let mats_before0 = mats0;
    let mats_before1 = mats1;
    let tables0 = sum_tables(eq0);
    let tables1 = sum_tables(eq1);

    let live = case.blocks * 1024;
    let mut got = vec![OUTPUT_POISON; 2 * HALO + live];
    let out_start = offset_with_residue(&got, case.residues[2]);
    for (i, byte) in got[out_start..out_start + live].iter_mut().enumerate() {
        *byte = (i as u8).wrapping_mul(43).wrapping_add(0x6D);
    }
    let initial = got.clone();
    let mut want = initial.clone();
    let mut old = initial.clone();
    assert_eq!((tile0.as_ptr() as usize) & 63, case.residues[0]);
    if case.alias_delta.is_none() {
        assert_eq!((tile1.as_ptr() as usize) & 63, case.residues[1]);
    }
    assert_eq!((got.as_ptr() as usize + out_start) & 63, case.residues[2]);

    for repetition in 0..repeats {
        scalar_add_tile(
            tile0,
            case.stride,
            case.blocks,
            &tables0,
            &mut want[out_start..out_start + live],
        );
        scalar_add_tile(
            tile1,
            case.stride,
            case.blocks,
            &tables1,
            &mut want[out_start..out_start + live],
        );
        // SAFETY: both input views cover all eight strided rows, including
        // every 64-byte block. The separate output allocations have fully
        // initialized live bytes and halos. Only the read-only inputs can
        // overlap; neither can overlap output or either immutable matrix.
        unsafe {
            kernels::gfni_fold_tile_pair_nonseed(
                tile0.as_ptr(),
                tile1.as_ptr(),
                case.stride,
                case.blocks,
                &mats0,
                &mats1,
                got.as_mut_ptr().add(out_start),
            );
            kernels::gfni_fold_tile(
                tile0.as_ptr(),
                case.stride,
                case.blocks,
                &mats0,
                old.as_mut_ptr().add(out_start),
                false,
            );
            kernels::gfni_fold_tile(
                tile1.as_ptr(),
                case.stride,
                case.blocks,
                &mats1,
                old.as_mut_ptr().add(out_start),
                false,
            );
        }
        // Whole-allocation equality checks both initialized output halos.
        // Input snapshots detect writes, not speculative or redundant reads.
        assert_eq!(got, want, "pair/scalar {case:?}, repeat={repetition}");
        assert_eq!(old, want, "old/scalar {case:?}, repeat={repetition}");
        assert_eq!(input0, before0, "input0 modified: {case:?}");
        assert_eq!(input1, before1, "input1 modified: {case:?}");
        assert_eq!(mats0, mats_before0);
        assert_eq!(mats1, mats_before1);
    }
    if repeats == 2 {
        assert_eq!(got, initial, "adding the same pair twice must cancel");
    }
}

#[test]
fn pair_nonseed_matches_scalar_and_two_old_calls() {
    let eq0 = basis(0x0123_4567_89AB_CDEF);
    let eq1 = basis(0xFEDC_BA98_7654_3210);
    for (blocks, stride, residues) in [
        (0, 0, [0, 0, 0]),
        (1, 64, [0, 0, 0]),
        (1, 67, [1, 31, 63]),
        (2, 128, [63, 1, 31]),
        (2, 137, [31, 63, 1]),
        (3, 193, [7, 15, 29]),
        (4, 271, [62, 33, 2]),
        (7, 451, [61, 30, 3]),
    ] {
        check_leaf(
            LeafCase {
                blocks,
                stride,
                residues,
                alias_delta: None,
            },
            &eq0,
            &eq1,
            2,
        );
    }
}

#[test]
fn pair_nonseed_allows_overlapping_readonly_tiles() {
    let eq0 = basis(0xBC17_A402_9876_5321);
    let eq1 = basis(0x471D_26FE_1023_5689);
    for delta in [0, 1, 63] {
        check_leaf(
            LeafCase {
                blocks: 2,
                stride: 137,
                residues: [5, 19, 61],
                alias_delta: Some(delta),
            },
            &eq0,
            &eq1,
            2,
        );
    }
}

#[test]
fn pair_nonseed_isolates_each_tile_stripe_and_basis_bit() {
    let case = LeafCase {
        blocks: 1,
        stride: 73,
        residues: [3, 29, 61],
        alias_delta: None,
    };
    // First isolate the old accumulator with both contributions zero.
    check_leaf(case, &[[F128::ZERO; 8]; 8], &[[F128::ZERO; 8]; 8], 1);
    // Exactly one of 2*8*8 basis entries is nonzero. Output bits 0..127
    // occur once each, independently covering every byte plane and limb.
    for side in 0..2 {
        for stripe in 0..8 {
            for bit in 0..8 {
                let mut eq0 = [[F128::ZERO; 8]; 8];
                let mut eq1 = [[F128::ZERO; 8]; 8];
                let output_bit = stripe * 8 + bit;
                if side == 0 {
                    eq0[stripe][bit].lo = 1u64 << output_bit;
                } else {
                    eq1[stripe][bit].hi = 1u64 << output_bit;
                }
                check_leaf(case, &eq0, &eq1, 1);
            }
        }
    }
}

#[test]
fn pair_nonseed_zero_blocks_never_access_raw_pointers() {
    let mats0 = [u64::MAX; 128];
    let mats1 = [0x0123_4567_89AB_CDEF; 128];
    // SAFETY: the pair leaf explicitly guarantees no pointer access when
    // n_blocks64 is zero. Matrices remain valid references; input/output
    // pointers are null and no stride arithmetic may be performed on them.
    unsafe {
        kernels::gfni_fold_tile_pair_nonseed(
            std::ptr::null(),
            std::ptr::null(),
            usize::MAX,
            0,
            &mats0,
            &mats1,
            std::ptr::null_mut(),
        );
    }
}

#[derive(Clone, Copy, Debug)]
struct SweepCase {
    tiles: usize,
    workers: usize,
    k: usize,
    useful: usize,
}

fn keep_low_bits(word: u64, bits: usize) -> u64 {
    if bits >= 64 {
        word
    } else {
        word & ((1u64 << bits) - 1)
    }
}

/// Direct packed-bit/F128 dot products. This oracle does not gather,
/// transpose, build GFNI matrices, or use either SIMD accumulation leaf.
fn scalar_sweep(z: &[F128], eq: &[F128], k: usize, useful: usize) -> Vec<F128> {
    let chunks_per_row = k / 128;
    assert_eq!(z.len(), eq.len() * chunks_per_row);
    let mut result = vec![F128::ZERO; k];
    for (outer, &weight) in eq.iter().enumerate() {
        let row = &z[outer * chunks_per_row..(outer + 1) * chunks_per_row];
        for (column, result) in result[..useful].iter_mut().enumerate() {
            let packed = row[column / 128];
            let bit = column % 128;
            let set = if bit < 64 {
                (packed.lo >> bit) & 1
            } else {
                (packed.hi >> (bit - 64)) & 1
            };
            if set != 0 {
                *result += weight;
            }
        }
    }
    result
}

fn scalar_bound_result(
    full: &[F128],
    top_bind: Option<F128>,
    ranked_one_rows: bool,
) -> (Vec<F128>, Option<Vec<F128>>) {
    let Some(r) = top_bind else {
        assert!(!ranked_one_rows);
        return (full.to_vec(), None);
    };
    let half = full.len() / 2;
    let one = ranked_one_rows.then(|| {
        assert_eq!(full.len(), 1 << 14);
        (0..half)
            .map(|column| {
                if column < 1_152 {
                    (F128::ONE + r) * full[column]
                } else if (6_912..7_168).contains(&column) {
                    r * full[column + half]
                } else {
                    F128::ZERO
                }
            })
            .collect()
    });
    let bound = (0..half)
        .map(|column| full[column] + r * (full[column] + full[column + half]))
        .collect();
    (bound, one)
}

fn check_sweep(case: SweepCase, ranked_one_rows: bool) {
    assert!(case.tiles > 0 && case.workers > 0);
    assert!(case.k.is_power_of_two() && case.k >= 128);
    assert!(case.useful <= case.k);
    const PAD: usize = 3;
    let chunks_per_row = case.k / 128;
    let rows = case.tiles * 64;
    let source_len = rows * chunks_per_row;
    let source_sentinel = value(19, 0x4E4F_545F_534F_5552);
    let mut source = vec![source_sentinel; source_len + 2 * PAD];
    for (i, packed) in source[PAD..PAD + source_len].iter_mut().enumerate() {
        let column = (i % chunks_per_row) * 128;
        let used = case.useful.saturating_sub(column).min(128);
        let v = value(i, 0xD15C_A11E_02BF_9463);
        *packed = F128 {
            lo: keep_low_bits(v.lo, used.min(64)),
            hi: keep_low_bits(v.hi, used.saturating_sub(64)),
        };
    }
    let mut weights = vec![value(23, 0x4E4F_545F_4551_5541); rows + 2 * PAD];
    for (i, weight) in weights[PAD..PAD + rows].iter_mut().enumerate() {
        *weight = value(i, 0x31A5_C062_E794_DB8F);
    }
    let before_source = source.clone();
    let before_weights = weights.clone();
    let z = &source[PAD..PAD + source_len];
    let eq = &weights[PAD..PAD + rows];
    let full = scalar_sweep(z, eq, case.k, case.useful);
    assert!(full[case.useful..].iter().all(|&v| v == F128::ZERO));
    let eq8_at = |outer_base: usize| std::array::from_fn(|lane| eq[outer_base + lane]);
    let top_binds = [
        None,
        Some(F128::ZERO),
        Some(F128::ONE),
        Some(value(37, 0xC0FF_EE51_2D43_A687)),
    ];
    // Ranked one-row extraction requires an actual top bind; all four
    // options remain covered by the generic geometries below.
    for &top_bind in &top_binds[usize::from(ranked_one_rows)..] {
        let want = scalar_bound_result(&full, top_bind, ranked_one_rows);
        for dynamic in [false, true] {
            let fold = |pair_tiles| {
                fold_block_major_gfni_with_pairs(
                    z,
                    case.k,
                    chunks_per_row,
                    case.useful,
                    case.useful.div_ceil(128),
                    case.workers,
                    case.tiles.div_ceil(case.workers),
                    case.tiles,
                    dynamic,
                    &eq8_at,
                    top_bind,
                    ranked_one_rows,
                    pair_tiles,
                )
            };
            let old = fold(false);
            let paired = fold(true);
            assert_eq!(old, want, "old {case:?}, dynamic={dynamic}, r={top_bind:?}");
            assert_eq!(
                paired, want,
                "paired {case:?}, dynamic={dynamic}, r={top_bind:?}"
            );
            assert_eq!(source, before_source, "packed source or halo modified");
            assert_eq!(weights, before_weights, "weight source or halo modified");
        }
    }
}

#[test]
fn paired_sweep_matches_unpaired_and_scalar_at_seed_claim_and_q_boundaries() {
    // More logical worker chunks than real threads also exercises inactive
    // chunks. No process-global environment switch or Rayon pool is changed.
    let pool = rayon::ThreadPoolBuilder::new()
        .num_threads(3)
        .build()
        .expect("test pool");
    pool.install(|| {
        for (tiles, workers, k, useful) in [
            (1, 3, 128, 0),
            (1, 3, 128, 1),
            (2, 3, 256, 129),
            (3, 1, 512, 497),
            (4, 1, 1024, 1024),
            (5, 1, 1024, 577),
            (7, 3, 2048, 1603),
            (8, 4, 1024, 960),
            (9, 2, 2048, 2048),
        ] {
            check_sweep(
                SweepCase {
                    tiles,
                    workers,
                    k,
                    useful,
                },
                false,
            );
        }
    });
}

#[test]
fn paired_sweep_preserves_ranked_top_bind_and_one_row_residual() {
    let pool = rayon::ThreadPoolBuilder::new()
        .num_threads(3)
        .build()
        .expect("test pool");
    pool.install(|| {
        // Preserve all 16384 columns and the 15409-bit live boundary, but
        // shorten the outer sum to 192/320 rows. The largest packed witness
        // is 640 KiB, not the full ranked 512 MiB input. These cases retain
        // 30 full gather4 visits plus the 49-bit final chunk and exercise
        // both complete-one row ranges before the top-coordinate binding.
        for (tiles, workers) in [(3, 1), (5, 2)] {
            check_sweep(
                SweepCase {
                    tiles,
                    workers,
                    k: 1 << 14,
                    useful: 15_409,
                },
                true,
            );
        }
    });
}
