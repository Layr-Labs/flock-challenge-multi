//! Compact producer staging; expand only one sixteen-lane top tile at a time.
use super::{F128, kernels, seed_top_stage_row};

pub(super) fn seed_plan(right: F128, dense: [F128; 3]) -> [F128; 8] {
    let tw = [right, dense[0], dense[1], dense[2]];
    core::array::from_fn(|i| if i & 1 == 0 { tw[i / 2] }
        else { tw[i / 2] * F128::new(0, 1) })
}

pub(super) fn publish_plan(tw: &[[[F128; 3]; 16]]) -> Vec<[[F128; 6]; 16]> {
    tw.iter().map(|block| core::array::from_fn(|m| core::array::from_fn(|i|
        if i & 1 == 0 { block[m][i / 2] }
        else { block[m][i / 2] * F128::new(0, 1) }))).collect()
}

thread_local! {
    // No pointer escapes publication. Each worker reuses its own fully
    // initialized demanded prefix; unused odd-tail cells are never read.
    static TILE: std::cell::RefCell<Vec<F128>> = const { std::cell::RefCell::new(Vec::new()) };
}

/// # Safety
/// `input` owns 256 compact rows with 64 fields per row, initialized through
/// `lanes` (60 or 64). `r` exclusively owns rows block*131072+k*2048+r of
/// the ranked codeword. All producers joined before this read, and this call
/// returns only after its NT stores have drained. The stage permutation is
/// the same one used by capture_compact.
pub(super) unsafe fn publish(input: *const F128, output: *mut F128, r: usize,
    lanes: usize, perm: bool, seed: &[F128; 8], tw4: &[kernels::FourBlock],
    tw2: &[[[F128; 6]; 16]]) {
    assert!(r < 2048 && matches!(lanes, 60 | 64));
    assert_eq!(tw4.len(), 8);
    assert_eq!(tw2.len(), 8);
    TILE.with_borrow_mut(|tile| unsafe {
        if tile.len() != 512 * 16 { tile.resize(512 * 16, F128::ZERO); }
        let p = tile.as_mut_ptr();
        for col in (0..64).step_by(16) {
            let active = (lanes - col).min(16);
            for k in 0..64 {
                let kp = seed_top_stage_row(k, perm);
                kernels::xseed_compact_seed(input.add(col), kp, p.add(kp * 16), active, seed);
            }
            for block in 0..8 {
                let region = p.add(block * 64 * 16);
                for j in 0..4 {
                    kernels::butterfly_fused_4layer_cached(
                        region.add(j * if perm { 16 * 16 } else { 16 }),
                        if perm { 1 } else { 4 }, 16, active, 0, &tw4[block]);
                }
                for m in 0..16 {
                    let src = region.add(seed_top_stage_row(4 * m, perm) * 16);
                    let dst: [*mut F128; 4] = core::array::from_fn(|i|
                        output.add((block * 131072 + (4 * m + i) * 2048 + r) * 64 + col));
                    kernels::xseed_compact_publish(src, if perm { 16 * 16 } else { 16 },
                        dst, active, &tw2[block][m]);
                }
            }
        }
        core::arch::x86_64::_mm_sfence();
    });
}
