//! Compact selected-root emission for post-commit generated tile readers.
//! The validated root list is cv[256], pin/message/counter[577], then
//! 56 carry groups of 186 bits. Linear fields are not roots: do not pack
//! them and then splice them out. No witness/commit producer uses this leaf.
use super::*;

struct CompactRootW16 {
    pending: V16,
    previous: V16,
    out: *mut u8,
}
impl CompactRootW16 {
    #[inline(always)]
    fn new(out: *mut u8, pending: V16) -> Self {
        Self {
            pending,
            previous: dup16(0),
            out,
        }
    }
    #[inline(always)]
    unsafe fn write_word<const WORD: usize>(&mut self, v: V16) {
        unsafe {
            if WORD % 2 == 0 {
                self.previous = v;
            } else {
                _mm512_store_si512(
                    self.out.add((WORD / 2) * 512).cast(),
                    _mm512_shuffle_i64x2::<0x44>(self.previous, v),
                );
                _mm512_store_si512(
                    self.out.add((WORD / 2) * 512 + 64).cast(),
                    _mm512_shuffle_i64x2::<0xee>(self.previous, v),
                );
            }
        }
    }
    #[inline(always)]
    unsafe fn push<const USED: i32, const WIDTH: i32, const BACK: i32, const WORD: usize>(
        &mut self,
        v: V16,
    ) {
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
}

#[inline(never)]
unsafe fn recompute_pair_compact<const SAVE: bool>(
    prepared: &Prepared16,
    out: *mut u8,
    deps: *mut V16,
    out_lo: *mut V16,
    out_hi: *mut V16,
) {
    unsafe { recompute_pair_compact_body::<SAVE>(prepared, out, deps, out_lo, out_hi); }
}

#[inline(always)]
unsafe fn recompute_pair_compact_body<const SAVE: bool>(
    prepared: &Prepared16,
    out: *mut u8,
    deps: *mut V16,
    out_lo: *mut V16,
    out_hi: *mut V16,
) {
    unsafe {
        let il_a = _mm512_setr_epi32(0, 16, 1, 17, 2, 18, 3, 19, 4, 20, 5, 21, 6, 22, 7, 23);
        let il_b = _mm512_setr_epi32(8, 24, 9, 25, 10, 26, 11, 27, 12, 28, 13, 29, 14, 30, 15, 31);
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

        let mut wa = CompactRootW16::new(out, initial16(shr16::<31>(thi)));
        wa.write_word::<0>(cv_v[0]);
        wa.write_word::<1>(cv_v[1]);
        wa.write_word::<2>(cv_v[2]);
        wa.write_word::<3>(cv_v[3]);
        wa.write_word::<4>(cv_v[4]);
        wa.write_word::<5>(cv_v[5]);
        wa.write_word::<6>(cv_v[6]);
        wa.write_word::<7>(cv_v[7]);
        let one = dup16(1);
        let chain: [V16; 20] = [
            m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13],
            m[14], m[15], tlo, thi, blen, flags,
        ];
        wa.write_word::<8>(or16(one, shl16::<1>(chain[0])));
        wa.write_word::<9>(or16(shr16::<31>(chain[0]), shl16::<1>(chain[1])));
        wa.write_word::<10>(or16(shr16::<31>(chain[1]), shl16::<1>(chain[2])));
        wa.write_word::<11>(or16(shr16::<31>(chain[2]), shl16::<1>(chain[3])));
        wa.write_word::<12>(or16(shr16::<31>(chain[3]), shl16::<1>(chain[4])));
        wa.write_word::<13>(or16(shr16::<31>(chain[4]), shl16::<1>(chain[5])));
        wa.write_word::<14>(or16(shr16::<31>(chain[5]), shl16::<1>(chain[6])));
        wa.write_word::<15>(or16(shr16::<31>(chain[6]), shl16::<1>(chain[7])));
        wa.write_word::<16>(or16(shr16::<31>(chain[7]), shl16::<1>(chain[8])));
        wa.write_word::<17>(or16(shr16::<31>(chain[8]), shl16::<1>(chain[9])));
        wa.write_word::<18>(or16(shr16::<31>(chain[9]), shl16::<1>(chain[10])));
        wa.write_word::<19>(or16(shr16::<31>(chain[10]), shl16::<1>(chain[11])));
        wa.write_word::<20>(or16(shr16::<31>(chain[11]), shl16::<1>(chain[12])));
        wa.write_word::<21>(or16(shr16::<31>(chain[12]), shl16::<1>(chain[13])));
        wa.write_word::<22>(or16(shr16::<31>(chain[13]), shl16::<1>(chain[14])));
        wa.write_word::<23>(or16(shr16::<31>(chain[14]), shl16::<1>(chain[15])));
        wa.write_word::<24>(or16(shr16::<31>(chain[15]), shl16::<1>(chain[16])));
        wa.write_word::<25>(or16(shr16::<31>(chain[16]), shl16::<1>(chain[17])));

        macro_rules! g {
            ($g:expr, $la:literal, $lb:literal, $lc:literal, $ld:literal,
             $mx:literal, $my:literal) => {{
                let (t0, p0) = add_root16(state[$la], state[$lb]);
                pushf8!(wa, 833 + 186 * $g + REC_C0, 31, p0);
                let (a1, p1) = add_root16(t0, m[$mx]);
                pushf8!(wa, 833 + 186 * $g + REC_C1, 31, p1);
                let d1 = xor_rotr16::<16, 16>(state[$ld], a1);
                let (c1s, p2) = add_root16(state[$lc], d1);
                pushf8!(wa, 833 + 186 * $g + REC_C2, 31, p2);
                let b1 = xor_rotr16::<12, 20>(state[$lb], c1s);
                let (t1, p3) = add_root16(a1, b1);
                pushf8!(wa, 833 + 186 * $g + REC_C3, 31, p3);
                let (a2, p4) = add_root16(t1, m[$my]);
                pushf8!(wa, 833 + 186 * $g + REC_C4, 31, p4);
                let d2 = xor_rotr16::<8, 24>(d1, a2);
                let (c2s, p5) = add_root16(c1s, d2);
                pushf8!(wa, 833 + 186 * $g + REC_C5, 31, p5);
                let bn = xor_rotr16::<7, 25>(b1, c2s);
                if SAVE {
                    *deps.add($g) = _mm512_permutex2var_epi32(bn, il_a, d2);
                    *deps.add(56 + $g) = _mm512_permutex2var_epi32(bn, il_b, d2);
                }
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

        wa.write_word::<351>(shr16::<15>(wa.pending));

        if SAVE {
            for k in 0..4 {
                let lo0 = xor16(state[2 * k], state[2 * k + 8]);
                let lo1 = xor16(state[2 * k + 1], state[2 * k + 9]);
                let hi0 = xor16(state[2 * k + 8], cv_v[2 * k]);
                let hi1 = xor16(state[2 * k + 9], cv_v[2 * k + 1]);
                *out_lo.add(k) = _mm512_permutex2var_epi32(lo0, il_a, lo1);
                *out_lo.add(4 + k) = _mm512_permutex2var_epi32(lo0, il_b, lo1);
                *out_hi.add(k) = _mm512_permutex2var_epi32(hi0, il_a, hi1);
                *out_hi.add(4 + k) = _mm512_permutex2var_epi32(hi0, il_b, hi1);
            }
        }
    }
}

/// Same aligned complete-tile contract as the incumbent generate_tile16.
pub(super) unsafe fn generate_tile16(init: u64, tile: usize, out: *mut u8) {
    unsafe { generate_tile16_impl::<false>(init, tile, out); }
}

/// Same bytes; allow input preparation to feed the recompute body directly.
pub(super) unsafe fn generate_tile16_inline(init: u64, tile: usize, out: *mut u8) {
    unsafe { generate_tile16_impl::<true>(init, tile, out); }
}

#[inline(always)]
unsafe fn generate_tile16_impl<const INLINE: bool>(init: u64, tile: usize, out: *mut u8) {
    assert!(tile < 4096);
    debug_assert_eq!(out as usize % 64, 0);
    unsafe {
        for pair in 0..4 {
            let physical = tile * 64 + pair * 16;
            let base = physical / 256 + ((physical % 256) / 8) * 2048;
            let input = prepare16(init, base);
            if INLINE {
                recompute_pair_compact_body::<false>(
                    &input,
                    out.add(pair * 128),
                    core::ptr::null_mut(),
                    core::ptr::null_mut(),
                    core::ptr::null_mut(),
                );
            } else {
                recompute_pair_compact::<false>(
                    &input,
                    out.add(pair * 128),
                    core::ptr::null_mut(),
                    core::ptr::null_mut(),
                    core::ptr::null_mut(),
                );
            }
        }
    }
}
