// Temporary whole-row banking; canonical output is restored by the final F3.
use super::{AdditiveNttF128, F128, kernels};

#[inline(always)]
pub(super) fn physical_row(row: usize) -> usize {
    row ^ (((row >> 3) ^ (row >> 7)) & 3)
}

impl AdditiveNttF128 {
    fn xseed_tw4(&self, layer: usize, block: usize) -> [F128; 15] {
        let mut t = [F128::ZERO; 15];
        for level in 0..4 {
            for i in 0..1usize << level {
                t[(1 << level) - 1 + i] = self.twiddle(layer + level, (block << level) + i);
            }
        }
        t
    }

    pub(super) unsafe fn xseed_sweep1(
        &self, sub: usize, ptr: *mut F128, r0: usize, r1: usize,
        odd_tail: usize, hint: u8,
    ) {
        unsafe {
            kernels::xseed_four_rows(ptr, sub * 2048, 128, r0, r1,
                &self.xseed_tw4(9, sub), odd_tail, false, hint);
        }
    }

    pub(super) unsafe fn xseed_block(
        &self, sub: usize, b: usize, ptr: *mut F128,
        cb: &(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync),
        odd_tail: usize, raw7: bool, hint: u8,
    ) {
        unsafe {
            let g4 = sub * 16 + b;
            let origin = g4 * 128;
            let block = ptr.add(b * 128 * 64);
            kernels::xseed_four_rows(block, origin, 8, 0, 8,
                &self.xseed_tw4(13, g4), odd_tail, raw7, hint);
            for j in 0..16 {
                let g8 = g4 * 16 + j;
                let mut t = [F128::ZERO; 7];
                for level in 0..3 {
                    for i in 0..1usize << level {
                        t[(1 << level) - 1 + i] = self.twiddle(17 + level, (g8 << level) + i);
                    }
                }
                kernels::xseed_three_rows(block.add(j * 8 * 64), origin + j * 8, 64 - odd_tail, &t);
            }
            cb(origin..origin + 128, core::slice::from_raw_parts(block, 128 * 64));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Mutex;

    #[test]
    fn xseed_row_banks_match_crown_deep_and_callbacks() {
        let ntt = AdditiveNttF128::standard(20);
        let mut state = 0x5eed05u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let mut cases = 0;
        for sub in [0, 1, 173, 511] {
            for hint in 0..3 {
                for (odd_tail, raw7) in [(0, false), (4, false), (4, true)] {
                    let mut expected: Vec<F128> = (0..2048 * 64)
                        .map(|_| F128 {lo: next(), hi: next()}).collect();
                    for r in (1..2048).step_by(2) {
                        let active = if raw7 {57} else {64 - odd_tail};
                        expected[r*64+active..(r+1)*64].fill(F128::ZERO);
                    }
                    let guard = F128 {lo: 0x1234, hi: 0x5678};
                    let mut storage = vec![guard; 2048 * 64 + 8];
                    let actual = &mut storage[4..4 + 2048 * 64];
                    for r in 0..2048 {
                        let p = physical_row(sub*2048+r) - sub*2048;
                        actual[p*64..(p+1)*64].copy_from_slice(&expected[r*64..(r+1)*64]);
                    }
                    assert!(ntt.deep_sub_fused_blocks_fallback(
                        sub, &mut expected, &|_,_| {}, 9, 20, 64,
                        odd_tail, raw7, 2048, hint));
                    let seen = Mutex::new(Vec::new());
                    let cb = |range: core::ops::Range<usize>, block: &[F128]| {
                        let lo = range.start - sub*2048;
                        assert_eq!(range.end - range.start, 128);
                        assert_eq!(block, &expected[lo*64..(lo+128)*64]);
                        seen.lock().unwrap().push(lo);
                    };
                    unsafe {
                        // Deliberately complete first-sweep chunks in reverse order.
                        for chunk in (0..8).rev() {
                            ntt.xseed_sweep1(sub, actual.as_mut_ptr(), chunk*16, (chunk+1)*16, odd_tail, hint);
                        }
                        for b in (0..16).rev() {
                            ntt.xseed_block(sub, b, actual.as_mut_ptr(), &cb, odd_tail, raw7, hint);
                        }
                    }
                    assert_eq!(actual, expected);
                    assert_eq!(seen.into_inner().unwrap(), (0..16).rev().map(|b|b*128).collect::<Vec<_>>());
                    assert!(storage[..4].iter().chain(&storage[4+2048*64..]).all(|&v|v==guard));
                    cases += 1;
                }
            }
        }
        println!("banked deep cases={cases}, reversed sweep/block claims, canonical callbacks and guards PASS");
    }

    #[test]
    fn xseed_row_banks_publication_and_involution() {
        for block in 0..8 {
            for k in 0..64 {
                for r in 0..2048 {
                    let logical = block*131072+k*2048+r;
                    let physical = block*131072+k*2048+physical_row(r);
                    assert_eq!(physical, physical_row(logical));
                    assert_eq!(physical_row(physical), logical);
                    assert_eq!(physical/4, logical/4);
                }
            }
        }
    }
}
