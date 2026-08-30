//! Wrapper-level oracles, including the exact residual fallback contract.
//! Kept separate from the kernel's mask and butterfly tests.

use super::*;
use crate::ntt::AdditiveNttGf8;

#[repr(C, align(64))]
struct Offsets([u16; ROUND1_AB_OFF_WORDS]);

#[repr(C, align(64))]
struct Output([u8; 64]);

fn table(k: usize, shift: u8) -> InvNttTableByteSingleGf8 {
    InvNttTableByteSingleGf8::new(
        &AdditiveNttGf8::new(k, F8::ZERO),
        &AdditiveNttGf8::new(k, F8(shift)),
    )
}

// Independent of the optimization's mask table: the real producer's wire
// geometry. Only bytes entirely within constant-one regions are fixed here.
fn one_bit(bit: usize) -> bool {
    if bit < 1153 || (15153..15409).contains(&bit) {
        return true;
    }
    (0..56).any(|g| {
        let start = 1153 + 250 * g;
        (start + 186..start + 250).contains(&bit)
    })
}

fn fixed_byte(blk: usize, byte: usize) -> bool {
    let first = blk * 512 + byte * 8;
    (first..first + 8).all(one_bit)
}

fn input(blk: usize, seed: u64) -> ([u8; 64], [u8; 64]) {
    let mut state = seed;
    let mut next = || {
        state ^= state << 13;
        state ^= state >> 7;
        state ^= state << 17;
        state as u8
    };
    let mut a = [0u8; 64];
    let mut b = [0u8; 64];
    for byte in 0..64 {
        a[byte] = next();
        b[byte] = if fixed_byte(blk, byte) { 255 } else { next() };
    }
    (a, b)
}

fn offsets(a: &[u8; 64], b: &[u8; 64]) -> Offsets {
    let mut out = Offsets([0; ROUND1_AB_OFF_WORDS]);
    for byte in 0..64 {
        out.0[byte] = u16::from(a[byte]) << 6;
        out.0[64 + byte] = u16::from(b[byte]) << 6;
    }
    out
}

fn oracle(
    table: &InvNttTableByteSingleGf8,
    a: &[u8; 64],
    b: &[u8; 64],
    keep: u8,
) -> [u8; 64] {
    let mut acc = [F8::ZERO; 64];
    for k in 0..8 {
        if keep & (1 << k) == 0 {
            continue;
        }
        let mut av = [F8::ZERO; 64];
        let mut bv = [F8::ZERO; 64];
        table.apply_scalar(&a[k * 8..k * 8 + 8], &mut av);
        table.apply_scalar(&b[k * 8..k * 8 + 8], &mut bv);
        for lane in 0..64 {
            acc[lane] += av[lane] * bv[lane] * F8(1 << k);
        }
    }
    acc.map(|value| value.0)
}

fn enabled_plan(table: &InvNttTableByteSingleGf8) -> Option<Round1AbWindowPlan> {
    let out = Output([0; 64]);
    let plan = prepare_round1_ab_window_plan(table, &out.0, true);
    if !plan.offsets_eligible(2)
        || std::env::var_os("FLOCK_NO_R1_B_COMPLEMENT").is_some()
    {
        return None;
    }
    assert!(plan.bcomplement, "this table's all-one image must be ONE");
    Some(plan)
}

fn check_with_fallback(
    table: &InvNttTableByteSingleGf8,
    plan: Round1AbWindowPlan,
    blk: usize,
    keep: u8,
    a: &[u8; 64],
    b: &[u8; 64],
    expect_hit: bool,
) {
    let off = offsets(a, b);
    let saved_offsets = off.0;
    let imgs = round1_ab_table_images(table, plan);
    let mut out = Output([0xa5; 64]);
    let hit = unsafe {
        round1_ab_inner_window_from_offsets_nt2_bcomplement(
            &off.0,
            b.as_ptr(),
            &mut out.0,
            plan,
            imgs,
            blk,
            keep,
        )
    };
    assert_eq!(hit, expect_hit, "blk={blk} keep={keep:#x}");
    if !hit {
        assert_eq!(out.0, [0xa5; 64], "a miss must not partially write");
        unsafe {
            if keep == 0xff {
                round1_ab_inner_window_from_offsets_nt2(&off.0, &mut out.0, plan, imgs);
            } else {
                round1_ab_inner_window_from_offsets_nt2_residual(
                    &off.0, &mut out.0, plan, imgs, keep,
                );
            }
        }
    }
    abinner_publish_fence();
    assert_eq!(off.0, saved_offsets, "offset arena must stay original");
    assert_eq!(out.0, oracle(table, a, b, keep), "blk={blk} keep={keep:#x}");

    let mut old = Output([0x5a; 64]);
    unsafe {
        if keep == 0xff {
            round1_ab_inner_window_from_offsets_nt2(&off.0, &mut old.0, plan, imgs);
        } else {
            round1_ab_inner_window_from_offsets_nt2_residual(
                &off.0, &mut old.0, plan, imgs, keep,
            );
        }
    }
    abinner_publish_fence();
    assert_eq!(out.0, old.0, "new and incumbent same-KEEP paths differ");
}

fn masks(blk: usize) -> &'static [u8] {
    match blk {
        2 => &[0xff, 0xfc],
        29 => &[0xff, 0x0f],
        _ => &[0xff],
    }
}

#[test]
fn complement_wrappers_match_scalar_for_each_window_and_table() {
    for shift in [64, 128, 192] {
        let table = table(6, shift);
        let Some(plan) = enabled_plan(&table) else { return };
        for blk in 2..30 {
            for seed in [0, 1, 0x842d_3ac6_0b41, u64::MAX] {
                let (a, b) = input(blk, seed);
                for &keep in masks(blk) {
                    check_with_fallback(&table, plan.for_window(blk), blk, keep, &a, &b, true);
                }
            }
        }
    }
}

#[test]
fn every_guarded_byte_miss_preserves_output_and_original_fallback() {
    let table = table(6, 64);
    let Some(plan) = enabled_plan(&table) else { return };
    for blk in 2..30 {
        let (a, b) = input(blk, 0x011f_47aa_842d);
        for &keep in masks(blk) {
            for byte in 0..64 {
                if keep & (1 << (byte / 8)) != 0 && fixed_byte(blk, byte) {
                    let mut broken = b;
                    broken[byte] ^= 1 << (byte % 8);
                    check_with_fallback(
                        &table, plan.for_window(blk), blk, keep, &a, &broken, false,
                    );
                }
            }
        }
    }
}

#[test]
fn residual_omitted_rows_do_not_affect_complement_guard_or_result() {
    let table = table(6, 64);
    let Some(plan) = enabled_plan(&table) else { return };
    for (blk, keep) in [(2, 0xfc), (29, 0x0f)] {
        for poison in [0, 0x5a, 0xa5, 255] {
            let (mut a, mut b) = input(blk, 0x9197_875f_9cfd);
            for byte in 0..64 {
                if keep & (1 << (byte / 8)) == 0 {
                    a[byte] = poison;
                    b[byte] = !poison;
                }
            }
            // Poison is initialized data. This checks output independence;
            // non-access of uninitialized rows is additionally a source audit.
            check_with_fallback(&table, plan.for_window(blk), blk, keep, &a, &b, true);
        }
    }
}

#[test]
fn disabled_plan_and_unsupported_shapes_decline_without_writing() {
    let table = table(6, 64);
    let Some(mut plan) = enabled_plan(&table) else { return };
    plan.bcomplement = false;
    let (a, b) = input(3, 0x568f_42d4);
    check_with_fallback(&table, plan, 3, 0xff, &a, &b, false);

    for (k, shift) in [(5, 32), (7, 128)] {
        let other = self::table(k, shift);
        let out = Output([0; 64]);
        let plan = prepare_round1_ab_window_plan(&other, &out.0, true);
        assert!(!plan.bcomplement, "unsupported k={k}");
    }
}
