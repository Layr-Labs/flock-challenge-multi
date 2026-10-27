//! Width-independent compression and packed-constraint stream.
//!
//! The production instantiation uses sixteen u32 lanes in one ZMM. Tests
//! instantiate the same round schedule and funnel-shift packer with arrays,
//! so the complete stream has a scalar oracle even on non-AVX-512 hosts.

use super::{
    ADDS_PER_G, BLAKE3_IV, CARRY_BITS_PER_ADD, G_STRIDE, GS_BASE, OUT_HI_BASE, USEFUL_BITS,
    WORD_BITS,
};

pub(crate) trait Word: Copy {
    fn splat(x: u32) -> Self;
    fn add(self, y: Self) -> Self;
    fn xor(self, y: Self) -> Self;
    fn or(self, y: Self) -> Self;
    fn shl<const N: u32>(self) -> Self;
    fn shr<const N: u32>(self) -> Self;
    fn ror<const N: i32>(self) -> Self;
    fn funnel<const N: i32>(self, pending: Self) -> Self;
}

pub(crate) struct Inputs<V> {
    pub(crate) cv: [V; 8],
    pub(crate) message: [V; 16],
    pub(crate) counter_lo: V,
    pub(crate) counter_hi: V,
    pub(crate) block_len: V,
    pub(crate) flags: V,
}

/// The native sink splits a completed ZMM word into the existing two octa
/// rings. Only completed words cross that boundary, not individual fields.
pub(crate) trait Sink<V> {
    fn seed(&mut self, word: usize, value: V);
    fn write<const WORD: usize>(&mut self, value: V);
    fn prologue_done(&mut self);
    fn tail_done(&mut self);
    fn prefix_done(&mut self);
}

struct Writer<V, S> {
    pending: V,
    sink: S,
}

impl<V: Word, S: Sink<V>> Writer<V, S> {
    #[inline(always)]
    fn push<const USED: i32, const WIDTH: i32, const WORD: usize>(&mut self, value: V) {
        const {
            assert!(USED >= 0 && USED < 32);
            assert!(WIDTH == 31 || WIDTH == 32);
        }
        if USED == 0 {
            if WIDTH == 32 {
                self.sink.write::<WORD>(value);
                self.pending = V::splat(0);
            } else {
                self.pending = value.shl::<1>();
            }
        } else {
            self.sink.write::<WORD>(value.funnel::<USED>(self.pending));
            self.pending = if WIDTH == 31 { value.shl::<1>() } else { value };
        }
    }

    #[inline(always)]
    fn finish(&mut self) {
        const { assert!(USEFUL_BITS % 32 == 17) };
        self.sink
            .write::<{ (USEFUL_BITS - 1) / 32 }>(self.pending.shr::<15>());
    }
}

#[inline(always)]
fn add_parts<V: Word>(x: V, y: V) -> (V, V, V) {
    let sum = x.add(y);
    (sum, sum.xor(y), sum.xor(x))
}

/// Execute one complete compression per lane and emit its packed A/B rows.
/// Ring publication is delegated to the sink; the arithmetic has no input-
/// dependent dispatch and does not change the R1CS or its padding.
#[inline(always)]
pub(crate) fn build<V: Word, A: Sink<V>, B: Sink<V>>(input: &Inputs<V>, a: A, b: B) -> (A, B) {
    const LIN0: usize = ADDS_PER_G * CARRY_BITS_PER_ADD;
    const LIN1: usize = LIN0 + WORD_BITS;
    let cv = &input.cv;
    let m = &input.message;
    let mut state = [
        cv[0],
        cv[1],
        cv[2],
        cv[3],
        cv[4],
        cv[5],
        cv[6],
        cv[7],
        V::splat(BLAKE3_IV[0]),
        V::splat(BLAKE3_IV[1]),
        V::splat(BLAKE3_IV[2]),
        V::splat(BLAKE3_IV[3]),
        input.counter_lo,
        input.counter_hi,
        input.block_len,
        input.flags,
    ];
    let one = V::splat(1);
    let max = V::splat(u32::MAX);
    let mut wa = Writer {
        pending: input.flags.shr::<31>().shl::<31>(),
        sink: a,
    };
    let mut wb = Writer {
        pending: one.shl::<31>(),
        sink: b,
    };
    let chain = [
        m[0],
        m[1],
        m[2],
        m[3],
        m[4],
        m[5],
        m[6],
        m[7],
        m[8],
        m[9],
        m[10],
        m[11],
        m[12],
        m[13],
        m[14],
        m[15],
        input.counter_lo,
        input.counter_hi,
        input.block_len,
        input.flags,
    ];
    for k in 0..20 {
        let value = if k == 0 {
            one.or(chain[0].shl::<1>())
        } else {
            chain[k - 1].shr::<31>().or(chain[k].shl::<1>())
        };
        wa.sink.seed(16 + k, value);
        wb.sink.seed(16 + k, max);
    }
    wa.sink.prologue_done();
    wb.sink.prologue_done();

    macro_rules! push {
        ($writer:ident, $pos:expr, $width:literal, $value:expr) => {
            $writer.push::<{ ($pos % 32) as i32 }, $width, { $pos / 32 }>($value)
        };
    }
    macro_rules! g {
        ($g:expr, $a:literal, $b:literal, $c:literal, $d:literal, $x:literal, $y:literal) => {{
            let (t0, l0, r0) = add_parts(state[$a], state[$b]);
            push!(wa, GS_BASE + G_STRIDE * $g, 31, l0);
            push!(wb, GS_BASE + G_STRIDE * $g, 31, r0);
            let (a1, l1, r1) = add_parts(t0, m[$x]);
            push!(wa, GS_BASE + G_STRIDE * $g + CARRY_BITS_PER_ADD, 31, l1);
            push!(wb, GS_BASE + G_STRIDE * $g + CARRY_BITS_PER_ADD, 31, r1);
            let d1 = state[$d].xor(a1).ror::<16>();
            let (c1, l2, r2) = add_parts(state[$c], d1);
            push!(wa, GS_BASE + G_STRIDE * $g + 2 * CARRY_BITS_PER_ADD, 31, l2);
            push!(wb, GS_BASE + G_STRIDE * $g + 2 * CARRY_BITS_PER_ADD, 31, r2);
            let b1 = state[$b].xor(c1).ror::<12>();
            let (t1, l3, r3) = add_parts(a1, b1);
            push!(wa, GS_BASE + G_STRIDE * $g + 3 * CARRY_BITS_PER_ADD, 31, l3);
            push!(wb, GS_BASE + G_STRIDE * $g + 3 * CARRY_BITS_PER_ADD, 31, r3);
            let (a2, l4, r4) = add_parts(t1, m[$y]);
            push!(wa, GS_BASE + G_STRIDE * $g + 4 * CARRY_BITS_PER_ADD, 31, l4);
            push!(wb, GS_BASE + G_STRIDE * $g + 4 * CARRY_BITS_PER_ADD, 31, r4);
            let d2 = d1.xor(a2).ror::<8>();
            let (c2, l5, r5) = add_parts(c1, d2);
            push!(wa, GS_BASE + G_STRIDE * $g + 5 * CARRY_BITS_PER_ADD, 31, l5);
            push!(wb, GS_BASE + G_STRIDE * $g + 5 * CARRY_BITS_PER_ADD, 31, r5);
            let bn = b1.xor(c2).ror::<7>();
            push!(wa, GS_BASE + G_STRIDE * $g + LIN0, 32, bn);
            push!(wb, GS_BASE + G_STRIDE * $g + LIN0, 32, max);
            push!(wa, GS_BASE + G_STRIDE * $g + LIN1, 32, d2);
            push!(wb, GS_BASE + G_STRIDE * $g + LIN1, 32, max);
            state[$a] = a2;
            state[$b] = bn;
            state[$c] = c2;
            state[$d] = d2;
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

    macro_rules! output {
        ($w:literal) => {{
            push!(wa, OUT_HI_BASE + 32 * $w, 32, state[$w + 8].xor(cv[$w]));
            push!(wb, OUT_HI_BASE + 32 * $w, 32, max);
        }};
    }
    output!(0);
    output!(1);
    output!(2);
    output!(3);
    output!(4);
    output!(5);
    output!(6);
    output!(7);
    wa.finish();
    wb.finish();
    wa.sink.tail_done();
    wb.sink.tail_done();
    for w in 0..8 {
        wa.sink.seed(w, cv[w]);
        wa.sink.seed(8 + w, state[w].xor(state[w + 8]));
        wb.sink.seed(w, max);
        wb.sink.seed(8 + w, max);
    }
    wa.sink.prefix_done();
    wb.sink.prefix_done();
    (wa.sink, wb.sink)
}

#[cfg(test)]
mod tests {
    use super::super::{Compression, K, build_block_witness_ab_packed_into};
    use super::*;

    #[derive(Clone, Copy)]
    struct Lanes([u32; 16]);
    impl Word for Lanes {
        fn splat(x: u32) -> Self {
            Self([x; 16])
        }
        fn add(self, y: Self) -> Self {
            Self(std::array::from_fn(|i| self.0[i].wrapping_add(y.0[i])))
        }
        fn xor(self, y: Self) -> Self {
            Self(std::array::from_fn(|i| self.0[i] ^ y.0[i]))
        }
        fn or(self, y: Self) -> Self {
            Self(std::array::from_fn(|i| self.0[i] | y.0[i]))
        }
        fn shl<const N: u32>(self) -> Self {
            Self(self.0.map(|x| x << N))
        }
        fn shr<const N: u32>(self) -> Self {
            Self(self.0.map(|x| x >> N))
        }
        fn ror<const N: i32>(self) -> Self {
            Self(self.0.map(|x| x.rotate_right(N as u32)))
        }
        fn funnel<const N: i32>(self, pending: Self) -> Self {
            Self(std::array::from_fn(|i| {
                (self.0[i] << N) | (pending.0[i] >> (32 - N))
            }))
        }
    }
    struct Rows {
        words: Vec<[u32; 16]>,
        written: Vec<bool>,
        ring_tags: [usize; 32],
        drains: usize,
    }
    impl Rows {
        fn new() -> Self {
            Self {
                words: vec![[0; 16]; K / 32],
                written: vec![false; K / 32],
                ring_tags: [usize::MAX; 32],
                drains: 0,
            }
        }
        fn check_drain(&mut self, base: usize, count: usize) {
            for word in base..base + count {
                assert_eq!(
                    self.ring_tags[word & 31],
                    word,
                    "unwritten or overwritten ring word"
                );
            }
            self.drains += 1;
        }
    }
    impl Sink<Lanes> for Rows {
        fn seed(&mut self, word: usize, value: Lanes) {
            self.words[word] = value.0;
            self.written[word] = true;
            self.ring_tags[word & 31] = word;
        }
        fn write<const WORD: usize>(&mut self, value: Lanes) {
            self.seed(WORD, value);
            if WORD % 32 == 31 {
                self.check_drain(WORD + 1 - 32, 32);
            }
        }
        fn prologue_done(&mut self) {
            self.check_drain(16, 16);
        }
        fn tail_done(&mut self) {
            // The ranked sparse-tail publisher reads words 480/481 only.
            self.check_drain(480, 2);
        }
        fn prefix_done(&mut self) {
            self.check_drain(0, 16);
        }
    }
    fn compare(blocks: &[Compression; 16]) {
        let inputs = Inputs {
            cv: std::array::from_fn(|w| Lanes(std::array::from_fn(|i| blocks[i].0[w]))),
            message: std::array::from_fn(|w| Lanes(std::array::from_fn(|i| blocks[i].1[w]))),
            counter_lo: Lanes(std::array::from_fn(|i| blocks[i].2 as u32)),
            counter_hi: Lanes(std::array::from_fn(|i| (blocks[i].2 >> 32) as u32)),
            block_len: Lanes(std::array::from_fn(|i| blocks[i].3)),
            flags: Lanes(std::array::from_fn(|i| blocks[i].4)),
        };
        let (a, b) = build(&inputs, Rows::new(), Rows::new());
        assert_eq!(a.drains, 17);
        assert_eq!(b.drains, 17);
        assert!(a.written[..USEFUL_BITS.div_ceil(32)].iter().all(|&x| x));
        assert!(b.written[..USEFUL_BITS.div_ceil(32)].iter().all(|&x| x));
        for (lane, (cv, msg, counter, len, flags)) in blocks.iter().enumerate() {
            let mut z_ref = vec![0u64; K / 64];
            let mut a_ref = z_ref.clone();
            let mut b_ref = z_ref.clone();
            build_block_witness_ab_packed_into(
                cv, msg, *counter, *len, *flags, &mut z_ref, &mut a_ref, &mut b_ref,
            );
            for w in 0..K / 64 {
                let av =
                    u64::from(a.words[2 * w][lane]) | (u64::from(a.words[2 * w + 1][lane]) << 32);
                let bv =
                    u64::from(b.words[2 * w][lane]) | (u64::from(b.words[2 * w + 1][lane]) << 32);
                assert_eq!(av, a_ref[w], "A lane={lane}, word={w}");
                assert_eq!(bv, b_ref[w], "B lane={lane}, word={w}");
                assert_eq!(av & bv, z_ref[w], "Z lane={lane}, word={w}");
            }
        }
    }

    #[test]
    fn witness16_stream_matches_scalar_edge_cases() {
        compare(&std::array::from_fn(|i| {
            let x = if i & 1 == 0 { 0 } else { u32::MAX };
            (
                [x; 8],
                [!x; 16],
                if i & 2 == 0 { 0 } else { u64::MAX },
                x,
                !x,
            )
        }));
    }

    #[test]
    fn witness16_stream_matches_scalar_random_lanes() {
        let mut state = 0x9e37_79b9_0123_4567u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        for _ in 0..8 {
            compare(&std::array::from_fn(|_| {
                (
                    std::array::from_fn(|_| next() as u32),
                    std::array::from_fn(|_| next() as u32),
                    next(),
                    next() as u32,
                    next() as u32,
                )
            }));
        }
    }
}
