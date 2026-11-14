// X6: one more fused top layer, followed by cache-resident 4+3+3 deep groups.
use super::{AdditiveNttF128, F128, kernels, seed_top_stage_row};

impl AdditiveNttF128 {
    fn xseed_half_tw3(&self, layer: usize, block: usize) -> [F128; 7] {
        let mut t = [F128::ZERO; 7];
        for level in 0..3 {
            for i in 0..1usize << level {
                t[(1 << level) - 1 + i] = self.twiddle(layer + level, (block << level) + i);
            }
        }
        t
    }

    pub(super) fn xseed_half_top_twiddles(&self) -> Vec<[F128; 7]> {
        (0..128).map(|b| self.xseed_half_tw3(7, b)).collect()
    }

    pub(super) unsafe fn xseed_half_publish_top(
        &self, staging: *mut F128, output: *mut F128, r: usize,
        lanes: usize, perm: bool, tw: &[[F128; 7]],
    ) {
        unsafe {
            for block in 0..8 {
                for m in 0..16 {
                    // A/B task pair is interleaved in the F3 inputs. Their
                    // distance in the canonical codeword is exactly 1024 rows.
                    let src = staging.add((block * 64 + seed_top_stage_row(4 * m, perm)) * 64);
                    let dst = output.add((block * 131072 + m * 8192 + r) * 64);
                    kernels::xseed_half_publish(src, dst, lanes, &tw[block * 16 + m], perm);
                }
            }
            core::arch::x86_64::_mm_sfence();
        }
    }

    pub(super) unsafe fn xseed_half_block(
        &self, sub: usize, b: usize, ptr: *mut F128,
        cb: &(dyn Fn(core::ops::Range<usize>, &[F128]) + Sync),
        odd_tail: usize, raw7: bool,
    ) {
        // Tail stealing retains the incumbent sixteen-token claim word.
        // Eight tokens own 128 rows each; the other eight have no work.
        if b >= 8 { return; }
        unsafe {
            let block = ptr.add(b * 128 * 64);
            for half in 0..2 {
                let g = sub * 16 + 2 * b + half;
                let p = block.add(half * 64 * 64);
                kernels::xseed_half_middle(p, &self.xseed_half_tw3(14, g), odd_tail, raw7);
                for j in 0..8 {
                    kernels::butterfly_fused_3layer_rows(
                        p.add(j * 8 * 64), 64, 64 - odd_tail, &self.xseed_half_tw3(17, g * 8 + j),
                    );
                }
            }
            let origin = sub * 1024 + b * 128;
            cb(origin..origin + 128, core::slice::from_raw_parts(block, 128 * 64));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Mutex;

    fn next(state: &mut u64) -> F128 {
        let mut word = || { *state ^= *state << 13; *state ^= *state >> 7; *state ^= *state << 17; *state };
        F128 { lo: word(), hi: word() }
    }

    #[test]
    fn xseed_half_deep_matches_scalar_and_callbacks() {
        let ntt = AdditiveNttF128::standard(20);
        let mut state = 0x5eed06u64;
        let mut cases = 0;
        for sub in [0, 1, 347, 1023] {
            for hint in 0..3 {
                for (odd_tail, raw7) in [(0, false), (4, false), (4, true)] {
                    let mut expected: Vec<F128> = (0..1024 * 64).map(|_| next(&mut state)).collect();
                    for r in (1..1024).step_by(2) {
                        let active = if raw7 {57} else {64 - odd_tail};
                        expected[r*64+active..(r+1)*64].fill(F128::ZERO);
                    }
                    let guard = F128 {lo: 0x1234, hi: 0x5678};
                    let mut storage = vec![guard; 1024 * 64 + 8];
                    let actual = &mut storage[4..4 + 1024 * 64];
                    actual.copy_from_slice(&expected);
                    for layer in 10..20 {
                        let blocks = 1 << (layer - 10);
                        let size = 1024 / blocks;
                        for b in 0..blocks {
                            let tw = ntt.twiddle(layer, sub * blocks + b);
                            for r in 0..size / 2 { for lane in 0..64 {
                                let a = (b * size + r) * 64 + lane;
                                let z = a + (size / 2) * 64;
                                let v = expected[z];
                                let u = expected[a] + tw * v;
                                expected[a] = u; expected[z] = v + u;
                            }}
                        }
                    }
                    let seen = Mutex::new(Vec::new());
                    let cb = |range: core::ops::Range<usize>, block: &[F128]| {
                        let lo = range.start - sub * 1024;
                        assert_eq!(range.end - range.start, 128);
                        assert_eq!(block, &expected[lo*64..(lo+128)*64]);
                        seen.lock().unwrap().push(lo);
                    };
                    unsafe {
                        for chunk in (0..8).rev() {
                            ntt.v2_sweep1_rows_x86(sub, actual.as_mut_ptr(), chunk*8, (chunk+1)*8,
                                10, 20, 64, odd_tail, hint);
                        }
                        for b in (0..16).rev() {
                            ntt.v2_deep_block_x86(sub, b, actual.as_mut_ptr(), &cb,
                                10, 20, 64, odd_tail, raw7, 1024, hint);
                        }
                    }
                    assert_eq!(actual, expected);
                    assert_eq!(seen.into_inner().unwrap(), (0..8).rev().map(|b|b*128).collect::<Vec<_>>());
                    assert!(storage[..4].iter().chain(&storage[4+1024*64..]).all(|&v|v==guard));
                    cases += 1;
                }
            }
        }
        println!("half-deep cases={cases}, scalar oracle, reversed claims, callbacks/guards PASS");
    }

    #[test]
    fn xseed_half_publisher_matches_eight_row_scalar() {
        let ntt = AdditiveNttF128::standard(20);
        let mut state = 0x5eed0601u64;
        let guard = F128 {lo: 0x1234, hi: 0x5678};
        let mut cases = 0;
        for perm in [false, true] {
            for group in [0, 1, 91, 127] {
                for lanes in [60, 64] {
                    let mut input = vec![guard; 1024*64 + 8];
                    let mut expected: Vec<F128> = (0..8*64).map(|_| next(&mut state)).collect();
                    for i in 0..8 {
                        expected[i*64+lanes..(i+1)*64].fill(F128::ZERO);
                        let offset = ((i&1)*512 + (i>>1)*if perm {16} else {1})*64;
                        input[4+offset..4+offset+64].copy_from_slice(&expected[i*64..(i+1)*64]);
                        // The publisher must not read the uninitialized odd suffix.
                        input[4+offset+lanes..4+offset+64].fill(guard);
                    }
                    let before = input.clone();
                    let t = ntt.xseed_half_tw3(7, group);
                    for level in 0..3 {
                        let size = 8 >> level;
                        for b in 0..1usize<<level {
                            for r in 0..size/2 { for lane in 0..64 {
                                let a = (b*size+r)*64+lane;
                                let z = a+(size/2)*64;
                                let v = expected[z];
                                let u = expected[a] + t[(1<<level)-1+b] * v;
                                expected[a] = u; expected[z] = v + u;
                            }}
                        }
                    }
                    let mut output = vec![guard; 8*1024*64+8];
                    unsafe {
                        kernels::xseed_half_publish(input.as_mut_ptr().add(4), output.as_mut_ptr().add(4), lanes, &t, perm);
                        core::arch::x86_64::_mm_sfence();
                    }
                    for i in 0..8 {
                        let offset = 4+i*1024*64;
                        assert_eq!(&output[offset..offset+64], &expected[i*64..(i+1)*64]);
                        assert!(output[offset+64..offset+1024*64].iter().all(|&v|v==guard));
                    }
                    assert!(output[..4].iter().chain(&output[4+8*1024*64..]).all(|&v|v==guard));
                    assert_eq!(input,before);
                    cases += 1;
                }
            }
        }
        println!("half-top F3 publisher cases={cases}, both stage permutations, zero tails and NT guards PASS");
    }
}
