//! Sixteen-compression arithmetic with two existing eight-block publishers.
//!
//! Keep additions, rotates and 31/32-bit field packing in ZMM registers.
//! Split only the completed packed words, preserving the established ring
//! geometry, static-B handling, root-cache format and non-temporal drains.

use super::super::blake3_witgen16_core::{self as stream, Inputs, Sink, Word};
use super::*;

#[derive(Clone, Copy)]
struct Zmm(__m512i);

impl Word for Zmm {
    #[inline(always)]
    fn splat(x: u32) -> Self {
        Self(unsafe { _mm512_set1_epi32(x as i32) })
    }
    #[inline(always)]
    fn add(self, y: Self) -> Self {
        Self(unsafe { _mm512_add_epi32(self.0, y.0) })
    }
    #[inline(always)]
    fn xor(self, y: Self) -> Self {
        Self(unsafe { _mm512_xor_si512(self.0, y.0) })
    }
    #[inline(always)]
    fn or(self, y: Self) -> Self {
        Self(unsafe { _mm512_or_si512(self.0, y.0) })
    }
    #[inline(always)]
    fn shl<const N: u32>(self) -> Self {
        Self(unsafe { _mm512_slli_epi32::<N>(self.0) })
    }
    #[inline(always)]
    fn shr<const N: u32>(self) -> Self {
        Self(unsafe { _mm512_srli_epi32::<N>(self.0) })
    }
    #[inline(always)]
    fn ror<const N: i32>(self) -> Self {
        Self(unsafe { _mm512_ror_epi32::<N>(self.0) })
    }
    #[inline(always)]
    fn funnel<const N: i32>(self, pending: Self) -> Self {
        Self(unsafe { _mm512_shldi_epi32::<N>(self.0, pending.0) })
    }
}

struct Packed16<'t, const B: bool> {
    halves: [W8<'t, B, true>; 2],
}

impl<const B: bool> Sink<Zmm> for Packed16<'_, B> {
    #[inline(always)]
    fn seed(&mut self, word: usize, value: Zmm) {
        // The same static-B provenance as W8::write_word. These bytes are
        // supplied by the publisher, never read from an unwritten ring.
        if B && !(RANKED_STATIC_B_PREFIX_END..RANKED_STATIC_B_TAIL_START).contains(&word) {
            return;
        }
        unsafe {
            let i = word & (RING_WORDS - 1);
            store_v8(
                self.halves[0].stage.add(i).cast(),
                _mm512_castsi512_si256(value.0),
            );
            store_v8(
                self.halves[1].stage.add(i).cast(),
                _mm512_extracti64x4_epi64::<1>(value.0),
            );
        }
    }
    #[inline(always)]
    fn write<const WORD: usize>(&mut self, value: Zmm) {
        unsafe {
            self.halves[0].write_word::<WORD>(_mm512_castsi512_si256(value.0));
            self.halves[1].write_word::<WORD>(_mm512_extracti64x4_epi64::<1>(value.0));
        }
    }
    #[inline(always)]
    fn prologue_done(&mut self) {
        if B {
            unsafe {
                for half in &mut self.halves {
                    (*half.drain).drain_range_gen::<true>(16, 16, RING_WORDS - 16);
                }
            }
        }
    }
    #[inline(always)]
    fn tail_done(&mut self) {
        if B {
            unsafe {
                for half in &mut self.halves {
                    (*half.drain).drain_range_gen::<true>(
                        U32_PER_BLOCK - RING_WORDS,
                        0,
                        RING_WORDS,
                    );
                }
            }
        }
    }
    #[inline(always)]
    fn prefix_done(&mut self) {
        if B {
            unsafe {
                for half in &mut self.halves {
                    (*half.drain).drain_range_gen::<true>(0, 0, 16);
                }
            }
        }
    }
}

/// # Safety
/// The caller owns sixteen contiguous z/a/b blocks whose elided constant
/// regions have been correctly pre-seeded.
/// The two projections and root writers own their disjoint eight-block
/// output regions. The enclosing cfg supplies every AVX-512 feature used.
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn build16_witness_ab_stream_ranked_closed<'t>(
    init: u64,
    base: usize,
    z: *mut u32,
    a: *mut u32,
    b: *mut u32,
    projs: [StreamProj<'t>; 2],
    preps: &'t RankedClosedWindowPreps,
    roots: [Option<root_emit::RootOctaWriter<'t>>; 2],
) {
    const { assert!(RING_WORDS == 32) };
    unsafe {
        debug_assert!(projs.iter().all(|p| p.one_rows_elided
            && p.w30_elided
            && p.out_bias == 2 * 64
            && p.plan.offsets_eligible(2)));
        let prepared = [
            prepare_closed_inputs(init, base),
            prepare_closed_inputs(init, base + 8),
        ];
        let join = |lo, hi| Zmm(_mm512_inserti64x4::<1>(_mm512_castsi256_si512(lo), hi));
        let input = Inputs {
            cv: std::array::from_fn(|i| join(prepared[0].cv[i], prepared[1].cv[i])),
            message: std::array::from_fn(|i| join(prepared[0].message[i], prepared[1].message[i])),
            counter_lo: join(prepared[0].counter_lo, prepared[1].counter_lo),
            counter_hi: join(prepared[0].counter_hi, prepared[1].counter_hi),
            block_len: join(prepared[0].block_len, prepared[1].block_len),
            flags: join(prepared[0].flags, prepared[1].flags),
        };
        let mut ast = core::mem::MaybeUninit::<[[V8; RING_WORDS]; 2]>::uninit();
        let mut bs = core::mem::MaybeUninit::<[[V8; RING_WORDS]; 2]>::uninit();
        let ap = ast.as_mut_ptr().cast::<V8>();
        let bp = bs.as_mut_ptr().cast::<V8>();
        let make_drain = |i: usize, proj, roots| Drain8 {
            ast: ap.add(i * RING_WORDS),
            bs: bp.add(i * RING_WORDS),
            z: z.add(i * 8 * U32_PER_BLOCK),
            a: a.add(i * 8 * U32_PER_BLOCK),
            b: b.add(i * 8 * U32_PER_BLOCK),
            proj,
            elide: [true; 3],
            ranked_static: true,
            ranked_fast: ranked_b_constwin_enabled(),
            ranked_preps: Some(preps),
            roots,
        };
        let [p0, p1] = projs;
        let [r0, r1] = roots;
        let mut drains = [make_drain(0, p0, r0), make_drain(1, p1, r1)];
        let dp = drains.as_mut_ptr();
        let a = Packed16::<false> {
            halves: std::array::from_fn(|i| {
                W8::at(ap.add(i * RING_WORDS), dup_u32(0), dp.add(i), true)
            }),
        };
        let b = Packed16::<true> {
            halves: std::array::from_fn(|i| {
                W8::at(bp.add(i * RING_WORDS), dup_u32(0), dp.add(i), true)
            }),
        };
        stream::build(&input, a, b);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::r1cs_hashes::blake3::{
        BLAKE3_ADJOINT_PLAN, K_SKIP, build_block_witness_ab_packed_into,
    };
    #[derive(Clone)]
    #[repr(C, align(64))]
    struct Line([u8; 64]);

    #[test]
    fn witness16_native_matches_two_octas_and_root_cache() {
        let ntt_s = flock_core::ntt::AdditiveNttGf8::new(K_SKIP, flock_core::field::F8::ZERO);
        let ntt_l =
            flock_core::ntt::AdditiveNttGf8::new(K_SKIP, flock_core::field::F8(1 << K_SKIP));
        let table = InvNttTableByteSingleGf8::new(&ntt_s, &ntt_l);
        let plan = BLAKE3_ADJOINT_PLAN.linear_fold_plan();
        let root_plan = root_emit::RootEmitPlan::new(&plan.roots).expect("ranked root geometry");
        for (init, base) in [(0, 0), (u64::MAX, 48), (0x1234_5678_9abc_def0, 4096)] {
            // Seed with a different witness: constant regions remain valid,
            // but every live region must be overwritten for the new input.
            let mut old = [
                vec![Line([0x5a; 64]); 16 * BYTES_PER_BLOCK / 64],
                vec![Line([0xa5; 64]); 16 * BYTES_PER_BLOCK / 64],
                vec![Line([0xc3; 64]); 16 * BYTES_PER_BLOCK / 64],
            ];
            for i in 0..16 {
                let (cv, m, t, len, flags) =
                    crate::seed_pipe::gen_block(init ^ 0xdead_beef_0123_4567, base + i);
                unsafe {
                    let z = std::slice::from_raw_parts_mut(
                        old[0].as_mut_ptr().cast::<u64>().add(i * K / 64),
                        K / 64,
                    );
                    let a = std::slice::from_raw_parts_mut(
                        old[1].as_mut_ptr().cast::<u64>().add(i * K / 64),
                        K / 64,
                    );
                    let b = std::slice::from_raw_parts_mut(
                        old[2].as_mut_ptr().cast::<u64>().add(i * K / 64),
                        K / 64,
                    );
                    build_block_witness_ab_packed_into(&cv, &m, t, len, flags, z, a, b);
                }
            }
            let mut new = old.clone();
            let mut old_ab = vec![Line([0x69; 64]); 16 * 29];
            let mut new_ab = old_ab.clone();
            let mut old_roots = vec![Line([0xb7; 64]); 176 * 8];
            let mut new_roots = old_roots.clone();
            let ab_bytes = unsafe {
                std::slice::from_raw_parts_mut(old_ab.as_mut_ptr().cast::<u8>(), old_ab.len() * 64)
            };
            let wp =
                flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(
                    &table, ab_bytes, true,
                );
            assert!(wp.offsets_eligible(2));
            let preps = prepare_ranked_closed_window_preps(&table, wp);
            let proj = |ptr: *mut u8, i: usize| StreamProj {
                stage: core::ptr::null_mut(),
                out: unsafe { ptr.add(i * 8 * 29 * 64) },
                out_stride: 29 * 64,
                out_bias: 2 * 64,
                inv_table: &table,
                plan: wp,
                one_rows_elided: true,
                w30_elided: true,
            };
            unsafe {
                for i in 0..2 {
                    build_octa_witness_ab_stream_ranked_closed(
                        init,
                        base + 8 * i,
                        old[0].as_mut_ptr().cast::<u32>().add(i * 8 * U32_PER_BLOCK),
                        old[1].as_mut_ptr().cast::<u32>().add(i * 8 * U32_PER_BLOCK),
                        old[2].as_mut_ptr().cast::<u32>().add(i * 8 * U32_PER_BLOCK),
                        proj(old_ab.as_mut_ptr().cast(), i),
                        &preps,
                        [true; 3],
                        Some(root_emit::RootOctaWriter::new(
                            &root_plan,
                            old_roots.as_mut_ptr().cast::<u8>().add(i * 64),
                        )),
                    );
                }
                build16_witness_ab_stream_ranked_closed(
                    init,
                    base,
                    new[0].as_mut_ptr().cast(),
                    new[1].as_mut_ptr().cast(),
                    new[2].as_mut_ptr().cast(),
                    std::array::from_fn(|i| proj(new_ab.as_mut_ptr().cast(), i)),
                    &preps,
                    std::array::from_fn(|i| {
                        Some(root_emit::RootOctaWriter::new(
                            &root_plan,
                            new_roots.as_mut_ptr().cast::<u8>().add(i * 64),
                        ))
                    }),
                );
                flock_core::zerocheck::univariate_skip_optimized::abinner_publish_fence();
            }
            for i in 0..3 {
                assert!(
                    old[i].iter().zip(&new[i]).all(|(a, b)| a.0 == b.0),
                    "witness side={i}"
                );
            }
            assert!(
                old_ab.iter().zip(&new_ab).all(|(a, b)| a.0 == b.0),
                "round-one projection"
            );
            assert!(
                old_roots.iter().zip(&new_roots).all(|(a, b)| a.0 == b.0),
                "root-cache layout"
            );
        }
    }
}
