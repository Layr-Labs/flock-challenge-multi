//! Sixteen-lane witness arithmetic with the canonical octa publishers.
//!
//! Inspired by BLAKE3's 16-way word-major AVX-512 compression layout:
//! https://github.com/BLAKE3-team/BLAKE3/blob/master/c/blake3_avx512.c
//! This implementation retains Flock's exact carry and witness ordering.
//! Only the arithmetic and word packing widen; each word is split into the
//! two existing octa rings before the original GFNI/NT publication kernel.
use super::*;
type V16 = __m512i;
macro_rules! pushf8 {
    ($w:ident,$pos:expr,$width:literal,$v:expr) => {{
        $w.push::<{ ($pos % 32) as i32 }, $width, {
            let u = ($pos % 32) as i32;
            if u == 0 { 1 } else { 32 - u }
        }, { $pos / 32 }>($v);
    }};
}

#[inline(always)]
unsafe fn merge8(a: V8, b: V8) -> V16 {
    unsafe { _mm512_inserti64x4::<1>(_mm512_castsi256_si512(a), b) }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[repr(C, align(64))]
    #[derive(Clone, Debug, PartialEq, Eq)]
    struct Words([u32; 16 * U32_PER_BLOCK]);
    #[repr(C, align(64))]
    #[derive(Clone, Debug, PartialEq, Eq)]
    struct Ab([u8; 16 * 29 * 64]);

    #[test]
    fn witness16_matches_two_octa_streams() {
        let ns = flock_core::ntt::AdditiveNttGf8::new(
            super::super::super::K_SKIP,
            flock_core::field::F8::ZERO,
        );
        let nl = flock_core::ntt::AdditiveNttGf8::new(
            super::super::super::K_SKIP,
            flock_core::field::F8(1 << super::super::super::K_SKIP),
        );
        let table = InvNttTableByteSingleGf8::new(&ns, &nl);
        let dummy = Box::new(Ab([0; 16 * 29 * 64]));
        let plan = flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(
            &table, &dummy.0, true,
        );
        assert!(plan.offsets_eligible(2));
        let preps = prepare_ranked_closed_window_preps(&table, plan);
        for seed in [0, 0xDEAD_BEEF_1234_5678, u64::MAX] {
            let crate::seed_pipe::BlockSource::Closed { init, .. } =
                crate::seed_pipe::BlockSource::closed(18, seed)
            else {
                unreachable!()
            };
            for base in [0, 16, 131056, 262128] {
                let mut z0 = Box::new(Words([0x79797979; 16 * U32_PER_BLOCK]));
                let mut a0 = z0.clone();
                let mut b0 = z0.clone();
                let mut z1 = z0.clone();
                let mut a1 = a0.clone();
                let mut b1 = b0.clone();
                let mut o0 = Box::new(Ab([0x79; 16 * 29 * 64]));
                let mut o1 = o0.clone();
                unsafe {
                    for half in 0..2 {
                        let off = half * 8 * U32_PER_BLOCK;
                        let proj = StreamProj {
                            stage: core::ptr::null_mut(),
                            out: o0.0.as_mut_ptr().add(half * 8 * 29 * 64),
                            out_stride: 29 * 64,
                            out_bias: 2 * 64,
                            inv_table: &table,
                            plan,
                            one_rows_elided: true,
                            w30_elided: true,
                        };
                        build_octa_witness_ab_stream_ranked_closed(
                            init,
                            base + half * 8,
                            z0.0.as_mut_ptr().add(off),
                            a0.0.as_mut_ptr().add(off),
                            b0.0.as_mut_ptr().add(off),
                            proj,
                            &preps,
                            [true; 3],
                        );
                    }
                    let projs = std::array::from_fn(|half| StreamProj {
                        stage: core::ptr::null_mut(),
                        out: o1.0.as_mut_ptr().add(half * 8 * 29 * 64),
                        out_stride: 29 * 64,
                        out_bias: 2 * 64,
                        inv_table: &table,
                        plan,
                        one_rows_elided: true,
                        w30_elided: true,
                    });
                    build_hexa_witness_ab_stream_ranked_closed(
                        init,
                        base,
                        z1.0.as_mut_ptr(),
                        a1.0.as_mut_ptr(),
                        b1.0.as_mut_ptr(),
                        projs,
                        &preps,
                    );
                }
                flock_core::zerocheck::univariate_skip_optimized::abinner_publish_fence();
                assert!(z0 == z1, "z seed={seed} base={base}");
                assert!(a0 == a1, "a seed={seed} base={base}");
                assert!(b0 == b1, "b seed={seed} base={base}");
                assert!(o0 == o1, "ab_inner seed={seed} base={base}");
                if seed == 0 && base == 0 && std::env::var_os("FLOCK_WITNESS16_BENCH").is_some() {
                    for wide in [false, true, true, false, false, true, true, false] {
                        let begin = std::time::Instant::now();
                        for iteration in 0..2048 {
                            let next_base = std::hint::black_box(iteration * 16);
                            unsafe {
                                if wide {
                                    let projs = std::array::from_fn(|half| StreamProj {
                                        stage: core::ptr::null_mut(),
                                        out: o1.0.as_mut_ptr().add(half * 8 * 29 * 64),
                                        out_stride: 29 * 64,
                                        out_bias: 2 * 64,
                                        inv_table: &table,
                                        plan,
                                        one_rows_elided: true,
                                        w30_elided: true,
                                    });
                                    build_hexa_witness_ab_stream_ranked_closed(
                                        init,
                                        next_base,
                                        z1.0.as_mut_ptr(),
                                        a1.0.as_mut_ptr(),
                                        b1.0.as_mut_ptr(),
                                        projs,
                                        &preps,
                                    );
                                } else {
                                    for half in 0..2 {
                                        let off = half * 8 * U32_PER_BLOCK;
                                        let proj = StreamProj {
                                            stage: core::ptr::null_mut(),
                                            out: o0.0.as_mut_ptr().add(half * 8 * 29 * 64),
                                            out_stride: 29 * 64,
                                            out_bias: 2 * 64,
                                            inv_table: &table,
                                            plan,
                                            one_rows_elided: true,
                                            w30_elided: true,
                                        };
                                        build_octa_witness_ab_stream_ranked_closed(
                                            init,
                                            next_base + half * 8,
                                            z0.0.as_mut_ptr().add(off),
                                            a0.0.as_mut_ptr().add(off),
                                            b0.0.as_mut_ptr().add(off),
                                            proj,
                                            &preps,
                                            [true; 3],
                                        );
                                    }
                                }
                            }
                        }
                        flock_core::zerocheck::univariate_skip_optimized::abinner_publish_fence();
                        eprintln!(
                            "WITNESS16_BENCH wide={wide} seconds={:.6}",
                            begin.elapsed().as_secs_f64()
                        );
                    }
                }
            }
        }
    }
}
#[inline(always)]
fn dup16(v: u32) -> V16 {
    unsafe { _mm512_set1_epi32(v as i32) }
}
#[inline(always)]
fn xor16(a: V16, b: V16) -> V16 {
    unsafe { _mm512_xor_si512(a, b) }
}
#[inline(always)]
fn or16(a: V16, b: V16) -> V16 {
    unsafe { _mm512_or_si512(a, b) }
}
#[inline(always)]
fn shl16<const N: u32>(a: V16) -> V16 {
    unsafe { _mm512_slli_epi32::<N>(a) }
}
#[inline(always)]
fn shr16<const N: u32>(a: V16) -> V16 {
    unsafe { _mm512_srli_epi32::<N>(a) }
}
#[inline(always)]
fn initial16(a: V16) -> V16 {
    shl16::<31>(a)
}
#[inline(always)]
fn add_carry16(a: V16, b: V16) -> (V16, V16, V16) {
    let sum = unsafe { _mm512_add_epi32(a, b) };
    (sum, xor16(sum, b), xor16(sum, a))
}
#[inline(always)]
fn xor_rotr16<const N: i32, const M: i32>(a: V16, b: V16) -> V16 {
    debug_assert_eq!(N + M, 32);
    unsafe { _mm512_ror_epi32::<N>(xor16(a, b)) }
}
#[inline(always)]
unsafe fn store16_parts(stages: [*mut V8; 2], word: usize, v: V16) {
    unsafe {
        _mm256_storeu_si256(stages[0].add(word), _mm512_castsi512_si256(v));
        _mm256_storeu_si256(stages[1].add(word), _mm512_extracti64x4_epi64::<1>(v));
    }
}
struct Prepared16 {
    cv: [V16; 8],
    message: [V16; 16],
    counter_lo: V16,
    counter_hi: V16,
    block_len: V16,
    flags: V16,
}
struct Drain16<'t> {
    inner: [Drain8<'t>; 2],
}
impl Drain16<'_> {
    #[inline(always)]
    unsafe fn drain_range_gen<const E: bool>(&mut self, base: usize, ring: usize, n: usize) {
        unsafe {
            self.inner[0].drain_range_gen::<E>(base, ring, n);
            self.inner[1].drain_range_gen::<E>(base, ring, n);
        }
    }
}
struct W16<'t, const FLUSH: bool> {
    pending: V16,
    stage: [*mut V8; 2],
    drain: *mut Drain16<'t>,
    ranked_static: bool,
}
impl<'t, const FLUSH: bool> W16<'t, FLUSH> {
    #[inline(always)]
    fn at(stage: [*mut V8; 2], pending: V16, drain: *mut Drain16<'t>, ranked_static: bool) -> Self {
        Self {
            pending,
            stage,
            drain,
            ranked_static,
        }
    }
    #[inline(always)]
    unsafe fn write_word<const WORD: usize>(&mut self, v: V16) {
        unsafe {
            if !(FLUSH
                && (WORD < RANKED_STATIC_B_PREFIX_END || WORD >= RANKED_STATIC_B_TAIL_START)
                && self.ranked_static)
            {
                store16_parts(self.stage, WORD & (RING_WORDS - 1), v);
            }
            if FLUSH && WORD % RING_WORDS == RING_WORDS - 1 {
                if WORD + 1 == RING_WORDS {
                    (*self.drain).drain_range_gen::<true>(16, 16, RING_WORDS - 16);
                } else {
                    (*self.drain).drain_range_gen::<true>(WORD + 1 - RING_WORDS, 0, RING_WORDS);
                }
            }
        }
    }
    #[inline(always)]
    unsafe fn push<const USED: i32, const WIDTH: i32, const BACK: i32, const WORD: usize>(
        &mut self,
        v: V16,
    ) {
        const {
            assert!(USED >= 0 && USED < 32);
            assert!(WIDTH == 31 || WIDTH == 32);
            assert!(BACK >= 1 && BACK < 32);
        }
        unsafe {
            if USED == 0 {
                if WIDTH == 32 {
                    self.write_word::<WORD>(v);
                    self.pending = dup16(0);
                } else {
                    self.pending = shl16::<1>(v);
                }
            } else {
                self.write_word::<WORD>(_mm512_shldi_epi32::<USED>(v, self.pending));
                self.pending = if WIDTH == 31 { shl16::<1>(v) } else { v };
            }
        }
    }
    #[inline(always)]
    unsafe fn finish(&mut self) {
        unsafe {
            self.write_word::<LAST_WORD>(shr16::<15>(self.pending));
        }
    }
}

/// Build sixteen canonical witnesses; callers own two adjacent octa regions.
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn build_hexa_witness_ab_stream_ranked_closed(
    init: u64,
    base: usize,
    z: *mut u32,
    a: *mut u32,
    b: *mut u32,
    projs: [StreamProj<'_>; 2],
    preps: &RankedClosedWindowPreps,
) {
    unsafe {
        const RANKED_CLOSED: bool = true;
        let ranked_static = true;
        let p0 = prepare_closed_inputs(init, base);
        let p1 = prepare_closed_inputs(init, base + 8);
        let prepared = Prepared16 {
            cv: std::array::from_fn(|i| merge8(p0.cv[i], p1.cv[i])),
            message: std::array::from_fn(|i| merge8(p0.message[i], p1.message[i])),
            counter_lo: merge8(p0.counter_lo, p1.counter_lo),
            counter_hi: merge8(p0.counter_hi, p1.counter_hi),
            block_len: merge8(p0.block_len, p1.block_len),
            flags: merge8(p0.flags, p1.flags),
        };
        let cv_v = &prepared.cv;
        let m = &prepared.message;
        let tlo = prepared.counter_lo;
        let thi = prepared.counter_hi;
        let blen = prepared.block_len;
        let flags = prepared.flags;

        let mut state: [V16; 16] = [
            cv_v[0],
            cv_v[1],
            cv_v[2],
            cv_v[3],
            cv_v[4],
            cv_v[5],
            cv_v[6],
            cv_v[7],
            dup16(BLAKE3_IV[0]),
            dup16(BLAKE3_IV[1]),
            dup16(BLAKE3_IV[2]),
            dup16(BLAKE3_IV[3]),
            tlo,
            thi,
            blen,
            flags,
        ];

        let zero = dup16(0);
        let mut ast0 = core::mem::MaybeUninit::<[V8; RING_WORDS]>::uninit();
        let mut ast1 = core::mem::MaybeUninit::<[V8; RING_WORDS]>::uninit();
        let mut bs0 = core::mem::MaybeUninit::<[V8; RING_WORDS]>::uninit();
        let mut bs1 = core::mem::MaybeUninit::<[V8; RING_WORDS]>::uninit();
        let ast = [
            ast0.as_mut_ptr().cast::<V8>(),
            ast1.as_mut_ptr().cast::<V8>(),
        ];
        let bs = [bs0.as_mut_ptr().cast::<V8>(), bs1.as_mut_ptr().cast::<V8>()];
        let [proj0, proj1] = projs;
        let mut drain = Drain16 {
            inner: [
                Drain8 {
                    ast: ast[0],
                    bs: bs[0],
                    z,
                    a,
                    b,
                    proj: proj0,
                    elide: [true; 3],
                    ranked_static: true,
                    ranked_fast: true,
                    ranked_preps: Some(preps),
                },
                Drain8 {
                    ast: ast[1],
                    bs: bs[1],
                    z: z.add(8 * U32_PER_BLOCK),
                    a: a.add(8 * U32_PER_BLOCK),
                    b: b.add(8 * U32_PER_BLOCK),
                    proj: proj1,
                    elide: [true; 3],
                    ranked_static: true,
                    ranked_fast: true,
                    ranked_preps: Some(preps),
                },
            ],
        };
        let maxv = dup16(u32::MAX);
        let one = dup16(1);
        let chain: [V16; 20] = [
            m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13],
            m[14], m[15], tlo, thi, blen, flags,
        ];
        // Words 16..35 are available before the rounds. Retain them in the
        // rolling epochs; the writer publishes each epoch when it completes
        // that epoch's last word.
        for k in 0..20usize {
            let v = if k == 0 {
                or16(one, shl16::<1>(chain[0]))
            } else {
                or16(shr16::<31>(chain[k - 1]), shl16::<1>(chain[k]))
            };
            let w = 16 + k;
            store16_parts(ast, w & (RING_WORDS - 1), v);
        }
        // Unswitch the static-prefix decision once per octa. Ranked blocks
        // 0/1 source B from RANKED_B_MAX; block 2 still needs words 32..35.
        if !ranked_static {
            for w in 16..RANKED_STATIC_B_PREFIX_END {
                store16_parts(bs, w & (RING_WORDS - 1), maxv);
            }
        }
        for w in RANKED_STATIC_B_PREFIX_END..16 + PROLOGUE_WORDS {
            store16_parts(bs, w & (RING_WORDS - 1), maxv);
        }

        // The round stream starts at word `PROLOGUE_WORDS + 16`, so a first
        // epoch that ends inside the prologue never reaches the writers'
        // epoch boundary — publish it here instead. Constant-folded away for
        // every ring long enough to reach the round stream.
        if RING_WORDS <= PROLOGUE_WORDS + 16 {
            drain.drain_range_gen::<RANKED_CLOSED>(16, 16, RING_WORDS - 16);
        }

        let pending_bit = initial16(shr16::<31>(flags));
        let drain_ptr = &mut drain as *mut Drain16;
        let mut wa = W16::<false>::at(ast, pending_bit, drain_ptr, false);
        // B is pushed after A at every site; it alone triggers a band drain
        // once both rings contain the completed word. Z is derived there.
        let mut wb = W16::<true>::at(bs, initial16(one), drain_ptr, ranked_static);

        macro_rules! g {
            ($g:expr, $la:literal, $lb:literal, $lc:literal, $ld:literal,
             $mx:literal, $my:literal) => {{
                let (t0, l0, r0) = add_carry16(state[$la], state[$lb]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C0, 31, l0);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C0, 31, r0);
                let (a1, l1, r1) = add_carry16(t0, m[$mx]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C1, 31, l1);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C1, 31, r1);
                let d1 = xor_rotr16::<16, 16>(state[$ld], a1);
                let (c1s, l2, r2) = add_carry16(state[$lc], d1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C2, 31, l2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C2, 31, r2);
                let b1 = xor_rotr16::<12, 20>(state[$lb], c1s);
                let (t1, l3, r3) = add_carry16(a1, b1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C3, 31, l3);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C3, 31, r3);
                let (a2, l4, r4) = add_carry16(t1, m[$my]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C4, 31, l4);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C4, 31, r4);
                let d2 = xor_rotr16::<8, 24>(d1, a2);
                let (c2s, l5, r5) = add_carry16(c1s, d2);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C5, 31, l5);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C5, 31, r5);
                let bn = xor_rotr16::<7, 25>(b1, c2s);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, bn);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, maxv);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, d2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, maxv);
                state[$la] = a2;
                state[$lb] = bn;
                state[$lc] = c2s;
                state[$ld] = d2;
            }};
        }
        macro_rules! round {
            ($gb:literal, $m0:literal, $m1:literal, $m2:literal, $m3:literal,
             $m4:literal, $m5:literal, $m6:literal, $m7:literal,
             $m8:literal, $m9:literal, $m10:literal, $m11:literal,
             $m12:literal, $m13:literal, $m14:literal, $m15:literal) => {{
                g!($gb, 0, 4, 8, 12, $m0, $m1);
                g!($gb + 1, 1, 5, 9, 13, $m2, $m3);
                g!($gb + 2, 2, 6, 10, 14, $m4, $m5);
                g!($gb + 3, 3, 7, 11, 15, $m6, $m7);
                g!($gb + 4, 0, 5, 10, 15, $m8, $m9);
                g!($gb + 5, 1, 6, 11, 12, $m10, $m11);
                g!($gb + 6, 2, 7, 8, 13, $m12, $m13);
                g!($gb + 7, 3, 4, 9, 14, $m14, $m15);
            }};
        }
        round!(0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        round!(8, 2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8);
        round!(16, 3, 4, 10, 12, 13, 2, 7, 14, 6, 5, 9, 0, 11, 15, 8, 1);
        round!(24, 10, 7, 12, 9, 14, 3, 13, 15, 4, 0, 11, 2, 5, 8, 1, 6);
        round!(32, 12, 13, 9, 11, 15, 10, 14, 8, 7, 2, 5, 3, 0, 1, 6, 4);
        round!(40, 9, 14, 11, 5, 8, 12, 15, 1, 13, 3, 0, 10, 2, 6, 4, 7);
        round!(48, 11, 15, 5, 0, 1, 9, 8, 6, 14, 10, 2, 12, 3, 4, 7, 13);

        const {
            assert!(OUT_HI_BASE % 32 == 17);
        }
        macro_rules! oh {
            ($w:literal) => {{
                let hv = xor16(state[$w + 8], cv_v[$w]);
                pushf8!(wa, OUT_HI_BASE + 32 * $w, 32, hv);
                pushf8!(wb, OUT_HI_BASE + 32 * $w, 32, maxv);
            }};
        }
        oh!(0);
        oh!(1);
        oh!(2);
        oh!(3);
        oh!(4);
        oh!(5);
        oh!(6);
        oh!(7);
        wa.finish();
        wb.finish();

        const ZF: usize = USEFUL_BITS.div_ceil(32);
        const {
            assert!(U32_PER_BLOCK - ZF == 30);
        }
        // finish() completed word 481. The ranked blk30 path reads only ring
        // words 480/481 and constructs its zero tail directly; blk31 is a
        // direct zero output. Cold/rollback paths retain the complete tail.
        if !ranked_static {
            for w in ZF..U32_PER_BLOCK {
                let i = w & (RING_WORDS - 1);
                store16_parts(ast, i, zero);
                store16_parts(bs, i, zero);
            }
        }
        drain.drain_range_gen::<RANKED_CLOSED>(U32_PER_BLOCK - RING_WORDS, 0, RING_WORDS);

        // Band 0 is the one intentional deferral: words 0..7 are the input
        // CV, while words 8..15 depend on the final compression state. Build
        // the complete cache line now, then publish it through the exact same
        // elide/NT/window policy as every rolling band.
        for w in 0..8usize {
            let lo = xor16(state[w], state[w + 8]);
            store16_parts(ast, w, cv_v[w]);
            store16_parts(ast, 8 + w, lo);
        }
        if !ranked_static {
            for w in 0..8usize {
                store16_parts(bs, w, maxv);
                store16_parts(bs, 8 + w, maxv);
            }
        }
        drain.drain_range_gen::<RANKED_CLOSED>(0, 0, 16);
    }
}
