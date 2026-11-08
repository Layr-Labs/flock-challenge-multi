//! Sixteen-lane arithmetic over two ordinary eight-lane publication streams.
//! Each completed packed word is split back into its original octa ring.
#![allow(unsafe_op_in_unsafe_fn)]
use super::*;
type V16 = __m512i;
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
fn shl16<const N: u32>(v: V16) -> V16 {
    unsafe { _mm512_slli_epi32::<N>(v) }
}
#[inline(always)]
fn shr16<const N: u32>(v: V16) -> V16 {
    unsafe { _mm512_srli_epi32::<N>(v) }
}
#[inline(always)]
fn initial16(v: V16) -> V16 {
    shl16::<31>(v)
}
#[inline(always)]
fn carry16(x: V16, y: V16) -> (V16, V16, V16) {
    unsafe {
        let sum = _mm512_add_epi32(x, y);
        (sum, xor16(sum, y), xor16(sum, x))
    }
}
#[inline(always)]
fn xor_rotr16<const N: i32, const M: i32>(x: V16, y: V16) -> V16 {
    debug_assert_eq!(N + M, 32);
    unsafe { _mm512_ror_epi32::<N>(xor16(x, y)) }
}
#[inline(always)]
unsafe fn join16(a: V8, b: V8) -> V16 {
    _mm512_inserti64x4::<1>(_mm512_castsi256_si512(a), b)
}
struct Prepared16 {
    cv: [V16; 8],
    message: [V16; 16],
    counter_lo: V16,
    counter_hi: V16,
    block_len: V16,
    flags: V16,
}
impl Prepared16 {
    unsafe fn new(p: [&PreparedInputs; 2]) -> Self {
        Self {
            cv: core::array::from_fn(|i| join16(p[0].cv[i], p[1].cv[i])),
            message: core::array::from_fn(|i| join16(p[0].message[i], p[1].message[i])),
            counter_lo: join16(p[0].counter_lo, p[1].counter_lo),
            counter_hi: join16(p[0].counter_hi, p[1].counter_hi),
            block_len: join16(p[0].block_len, p[1].block_len),
            flags: join16(p[0].flags, p[1].flags),
        }
    }
}
#[derive(Clone, Copy)]
struct PairStage([*mut V8; 2]);
impl PairStage {
    #[inline(always)]
    unsafe fn store(self, word: usize, v: V16) {
        _mm256_storeu_si256(self.0[0].add(word), _mm512_castsi512_si256(v));
        _mm256_storeu_si256(self.0[1].add(word), _mm512_extracti64x4_epi64::<1>(v));
    }
    /// Publish adjacent words as complete64-byte spans in each original ring.
    #[inline(always)]
    unsafe fn store_pair(self, word: usize, first: V16, second: V16) {
        debug_assert!(word.is_multiple_of(2) && word + 1 < RING_WORDS);
        let low = _mm512_shuffle_i64x2::<0x44>(first, second);
        let high = _mm512_shuffle_i64x2::<0xee>(first, second);
        _mm512_storeu_si512(self.0[0].add(word).cast(), low);
        _mm512_storeu_si512(self.0[1].add(word).cast(), high);
    }
}
#[inline(always)]
unsafe fn drain_all<const COLS: usize>(
    drain: *mut [Drain8<'_>; 2],
    base: usize,
    ring: usize,
    words: usize,
) {
    for d in &mut *drain {
        d.drain_range_gen::<true, COLS>(base, ring, words);
    }
}
struct W16<'t, const FLUSH: bool, const COLS: usize> {
    pending: V16,
    previous: V16,
    stage: PairStage,
    drain: *mut [Drain8<'t>; 2],
}
impl<'t, const FLUSH: bool, const COLS: usize> W16<'t, FLUSH, COLS> {
    #[inline(always)]
    fn at(
        stage: PairStage,
        pending: V16,
        drain: *mut [Drain8<'t>; 2],
        _ranked_static: bool,
    ) -> Self {
        Self {
            stage,
            pending,
            previous: dup16(0),
            drain,
        }
    }
    #[inline(always)]
    unsafe fn write_word<const WORD: usize>(&mut self, v: V16) {
        let static_b =
            FLUSH && (WORD < RANKED_STATIC_B_PREFIX_END || WORD >= RANKED_STATIC_B_TAIL_START);
        if !static_b {
            // Every epoch and the final word end on an odd index; complete
            // pairs are visible before either octa drain can consume them.
            const {
                assert!(RING_WORDS.is_multiple_of(2));
            }
            if WORD % 2 == 0 {
                self.previous = v;
            } else {
                self.stage
                    .store_pair((WORD - 1) & (RING_WORDS - 1), self.previous, v);
            }
        }
        if FLUSH && WORD % RING_WORDS == RING_WORDS - 1 {
            if WORD + 1 == RING_WORDS {
                drain_all::<COLS>(self.drain, 16, 16, RING_WORDS - 16);
            } else {
                drain_all::<COLS>(self.drain, WORD + 1 - RING_WORDS, 0, RING_WORDS);
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
            assert!(WORD < U32_PER_BLOCK);
        }
        debug_assert!(USED + WIDTH <= 32 || BACK == 32 - USED);
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
    #[inline(always)]
    unsafe fn finish(&mut self) {
        const {
            assert!(USEFUL_BITS % 32 == 17);
        }
        self.write_word::<LAST_WORD>(shr16::<15>(self.pending));
    }
}
macro_rules! pushf16 {
    ($w:ident,$pos:expr,$width:literal,$v:expr) => {{
        $w.push::<{ ($pos % 32) as i32 }, $width, {
            let u = ($pos % 32) as i32;
            if u == 0 { 1 } else { 32 - u }
        }, { $pos / 32 }>($v);
    }};
}
/// All buffers and contexts have the ordinary octa contracts, independently
/// for each side; output spans must be disjoint. Every input lane is retained.
#[inline(never)]
unsafe fn build_prepared_pair<const COLS: usize>(
    inputs: [&PreparedInputs; 2],
    z: [*mut u32; 2],
    a: [*mut u32; 2],
    b: [*mut u32; 2],
    proj: [StreamProj<'_>; 2],
    preps: &RankedClosedWindowPreps,
) {
    unsafe {
        let ranked_static = true;
        let prepared = Prepared16::new(inputs);
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
        let mut ast_mem = core::mem::MaybeUninit::<[V8; 2 * RING_WORDS]>::uninit();
        let mut bs_mem = core::mem::MaybeUninit::<[V8; 2 * RING_WORDS]>::uninit();
        let ast0 = ast_mem.as_mut_ptr().cast::<V8>();
        let bs0 = bs_mem.as_mut_ptr().cast::<V8>();
        let ast = PairStage([ast0, ast0.add(RING_WORDS)]);
        let bs = PairStage([bs0, bs0.add(RING_WORDS)]);
        let fast = proj.each_ref().map(|p| {
            p.w30_elided && ranked_static01_direct_enabled() && ranked_b_constwin_enabled()
        });
        let [p0, p1] = proj;
        let make = |side: usize, proj, ranked_fast| Drain8 {
            ast: ast.0[side],
            bs: bs.0[side],
            z: z[side],
            a: a[side],
            b: b[side],
            proj,
            elide: [true; 3],
            ranked_static: true,
            ranked_fast,
            cached_z: false,
            ranked_preps: Some(preps),
            roots: None,
        };
        let mut drain = [make(0, p0, fast[0]), make(1, p1, fast[1])];
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
            ast.store(w & (RING_WORDS - 1), v);
        }
        // Unswitch the static-prefix decision once per octa. Ranked blocks
        // 0/1 source B from RANKED_B_MAX; block 2 still needs words 32..35.
        if !ranked_static {
            for w in 16..RANKED_STATIC_B_PREFIX_END {
                bs.store(w & (RING_WORDS - 1), maxv);
            }
        }
        for w in RANKED_STATIC_B_PREFIX_END..16 + PROLOGUE_WORDS {
            bs.store(w & (RING_WORDS - 1), maxv);
        }

        // The round stream starts at word `PROLOGUE_WORDS + 16`, so a first
        // epoch that ends inside the prologue never reaches the writers'
        // epoch boundary — publish it here instead. Constant-folded away for
        // every ring long enough to reach the round stream.
        if RING_WORDS <= PROLOGUE_WORDS + 16 {
            drain_all::<COLS>(&mut drain, 16, 16, RING_WORDS - 16);
        }

        let pending_bit = initial16(shr16::<31>(flags));
        let drain_ptr = &mut drain as *mut [Drain8; 2];
        let mut wa = W16::<false, COLS>::at(ast, pending_bit, drain_ptr, false);
        // B is pushed after A at every site; it alone triggers a band drain
        // once both rings contain the completed word. Z is derived there.
        let mut wb = W16::<true, COLS>::at(bs, initial16(one), drain_ptr, ranked_static);

        macro_rules! g {
            ($g:expr, $la:literal, $lb:literal, $lc:literal, $ld:literal,
             $mx:literal, $my:literal) => {{
                let (t0, l0, r0) = carry16(state[$la], state[$lb]);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C0, 31, l0);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C0, 31, r0);
                let (a1, l1, r1) = carry16(t0, m[$mx]);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C1, 31, l1);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C1, 31, r1);
                let d1 = xor_rotr16::<16, 16>(state[$ld], a1);
                let (c1s, l2, r2) = carry16(state[$lc], d1);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C2, 31, l2);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C2, 31, r2);
                let b1 = xor_rotr16::<12, 20>(state[$lb], c1s);
                let (t1, l3, r3) = carry16(a1, b1);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C3, 31, l3);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C3, 31, r3);
                let (a2, l4, r4) = carry16(t1, m[$my]);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C4, 31, l4);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C4, 31, r4);
                let d2 = xor_rotr16::<8, 24>(d1, a2);
                let (c2s, l5, r5) = carry16(c1s, d2);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_C5, 31, l5);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_C5, 31, r5);
                let bn = xor_rotr16::<7, 25>(b1, c2s);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, bn);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, maxv);
                pushf16!(wa, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, d2);
                pushf16!(wb, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, maxv);
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
                pushf16!(wa, OUT_HI_BASE + 32 * $w, 32, hv);
                pushf16!(wb, OUT_HI_BASE + 32 * $w, 32, maxv);
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
                ast.store(i, zero);
                bs.store(i, zero);
            }
        }
        drain_all::<COLS>(&mut drain, U32_PER_BLOCK - RING_WORDS, 0, RING_WORDS);

        // Band 0 is the one intentional deferral: words 0..7 are the input
        // CV, while words 8..15 depend on the final compression state. Build
        // the complete cache line now, then publish it through the exact same
        // elide/NT/window policy as every rolling band.
        for w in 0..8usize {
            let lo = xor16(state[w], state[w + 8]);
            ast.store(w, cv_v[w]);
            ast.store(8 + w, lo);
        }
        if !ranked_static {
            for w in 0..8usize {
                bs.store(w, maxv);
                bs.store(8 + w, maxv);
            }
        }
        drain_all::<COLS>(&mut drain, 0, 0, 16);
    }
}

/// Pair independent octas without changing their seed/window mapping.
/// # Safety
/// Each side inherits the ordinary ranked producer's exclusive buffer and
/// lifetime contracts. The two side output regions must not overlap.
pub(crate) unsafe fn build_pair_window<const COLS: usize>(
    init: u64,
    bases: [usize; 2],
    z: [*mut u32; 2],
    a: [*mut u32; 2],
    b: [*mut u32; 2],
    proj: [StreamProj<'_>; 2],
    preps: &RankedClosedWindowPreps,
) {
    debug_assert!(matches!(COLS, 8 | 16 | 32 | 64));
    for p in &proj {
        debug_assert!(p.seed_window.is_some());
        debug_assert_eq!(p.compact_z_tile_words, COLS * 4);
        debug_assert!(p.elide_z);
        debug_assert!(p.plan.offsets_eligible(2));
    }
    let p0 = prepare_closed_inputs_ordered(init, bases[0], proj[0].cross_quarter);
    let p1 = prepare_closed_inputs_ordered(init, bases[1], proj[1].cross_quarter);
    build_prepared_pair::<COLS>([&p0, &p1], z, a, b, proj, preps);
}

/// Diagnostic rollback; default route still requires all caller eligibility checks.
pub(crate) fn enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_WITNESS_PAIR16").is_none());
    *ON
}

#[cfg(test)]
mod tests {
    use super::*;
    #[repr(C, align(64))]
    #[derive(Clone, Debug, PartialEq, Eq)]
    struct Words([u32; 8 * U32_PER_BLOCK + 32]);
    impl Words {
        fn ptr(&mut self) -> *mut u32 {
            unsafe { self.0.as_mut_ptr().add(16) }
        }
    }
    #[repr(C, align(64))]
    #[derive(Clone, Debug, PartialEq, Eq)]
    struct Bytes([u8; 8 * 32 * 64 + 128]);
    impl Bytes {
        fn ptr(&mut self) -> *mut u8 {
            unsafe { self.0.as_mut_ptr().add(64) }
        }
    }
    #[repr(C, align(64))]
    struct Stage([u32; STREAM_STAGE_WORDS]);
    fn proj<'a>(
        stage: *mut u32,
        out: *mut u8,
        table: &'a InvNttTableByteSingleGf8,
        plan: Round1AbWindowPlan,
        compact: bool,
    ) -> StreamProj<'a> {
        StreamProj {
            compact_z_tile_words: 0,
            seed_window: None,
            stage,
            out,
            out_stride: if compact { 29 * 64 } else { 32 * 64 },
            cross_quarter: false,
            compact_z: core::ptr::null_mut(),
            elide_z: false,
            out_bias: if compact { 2 * 64 } else { 0 },
            inv_table: table,
            plan,
            one_rows_elided: compact,
            w30_elided: compact,
        }
    }
    /// Compare both full packed witness streams and projected AB outputs,
    /// retaining constants from a different completed witness as required by
    /// the ordinary all-elide provenance contract. The two sides use distinct
    /// inputs and guarded, independently owned buffers.
    #[test]
    fn paired_word_stream_preserves_both_canonical_octas() {
        unsafe {
            let small = flock_core::ntt::AdditiveNttGf8::new(
                super::super::super::K_SKIP,
                flock_core::field::F8::ZERO,
            );
            let large = flock_core::ntt::AdditiveNttGf8::new(
                super::super::super::K_SKIP,
                flock_core::field::F8(1u8 << super::super::super::K_SKIP),
            );
            let table = InvNttTableByteSingleGf8::new(&small, &large);
            let dummy = vec![0u8; 8 * 29 * 64];
            let plan =
                flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(
                    &table, &dummy, true,
                );
            assert!(plan.offsets_eligible(2));
            let preps = prepare_ranked_closed_window_preps(&table, plan);
            for seed in [0x7812_9cab_ddef_1023u64, 0xc723_e198_5634_ab11] {
                for bases in [[0usize, 4096], [8, 8200], [63480, 61432]] {
                    let mut z_seed = [
                        Words([0x51a3_82f4; 8 * U32_PER_BLOCK + 32]),
                        Words([0x51a3_82f4; 8 * U32_PER_BLOCK + 32]),
                    ];
                    let mut a_seed = z_seed.clone();
                    let mut b_seed = z_seed.clone();
                    let mut stages = [
                        Stage([0; STREAM_STAGE_WORDS]),
                        Stage([0; STREAM_STAGE_WORDS]),
                    ];
                    // Real full writes, not guessed constant-one or constant-zero bytes.
                    for side in 0..2 {
                        let mut cold_ab = Bytes([0xa5; 8 * 32 * 64 + 128]);
                        build_octa_witness_ab_stream_elide(
                            OctaInputs::Closed {
                                init: seed ^ 0x5273_2001,
                                base: bases[side],
                            },
                            z_seed[side].ptr(),
                            a_seed[side].ptr(),
                            b_seed[side].ptr(),
                            proj(
                                stages[side].0.as_mut_ptr(),
                                cold_ab.ptr(),
                                &table,
                                plan,
                                false,
                            ),
                            [false; 3],
                        );
                    }
                    _mm_sfence();
                    let mut zr = z_seed.clone();
                    let mut ar = a_seed.clone();
                    let mut br = b_seed.clone();
                    let mut zn = z_seed;
                    let mut an = a_seed;
                    let mut bn = b_seed;
                    let mut outr = [
                        Bytes([0xa5; 8 * 32 * 64 + 128]),
                        Bytes([0xa5; 8 * 32 * 64 + 128]),
                    ];
                    let mut outn = outr.clone();
                    let p0 = prepare_closed_inputs_ordered(seed, bases[0], true);
                    let p1 = prepare_closed_inputs_ordered(seed, bases[1], true);
                    let prepared = [&p0, &p1];
                    for side in 0..2 {
                        build_octa_witness_ab_stream_prepared_elide::<true, 0>(
                            prepared[side],
                            zr[side].ptr(),
                            ar[side].ptr(),
                            br[side].ptr(),
                            proj(
                                stages[side].0.as_mut_ptr(),
                                outr[side].ptr(),
                                &table,
                                plan,
                                true,
                            ),
                            [true; 3],
                            true,
                            Some(&preps),
                            None,
                            false,
                        );
                    }
                    _mm_sfence();
                    let args = [
                        proj(stages[0].0.as_mut_ptr(), outn[0].ptr(), &table, plan, true),
                        proj(stages[1].0.as_mut_ptr(), outn[1].ptr(), &table, plan, true),
                    ];
                    build_prepared_pair::<0>(
                        prepared,
                        [zn[0].ptr(), zn[1].ptr()],
                        [an[0].ptr(), an[1].ptr()],
                        [bn[0].ptr(), bn[1].ptr()],
                        args,
                        &preps,
                    );
                    _mm_sfence();
                    assert_eq!(zr, zn, "full z seed={seed} bases={bases:?}");
                    assert_eq!(ar, an, "full a seed={seed} bases={bases:?}");
                    assert_eq!(br, bn, "full b seed={seed} bases={bases:?}");
                    assert_eq!(outr, outn, "projected AB seed={seed} bases={bases:?}");
                    for side in 0..2 {
                        for v in [&zn[side], &an[side], &bn[side]] {
                            assert!(
                                v.0[..16]
                                    .iter()
                                    .chain(v.0[16 + 8 * U32_PER_BLOCK..].iter())
                                    .all(|&x| x == 0x51a3_82f4)
                            );
                        }
                        assert!(
                            outn[side].0[..64]
                                .iter()
                                .chain(outn[side].0[64 + 8 * 29 * 64..].iter())
                                .all(|&x| x == 0xa5)
                        );
                    }
                }
            }
        }
    }
}
