//! Direct, challenge-independent root stripes from the live octa word ring.
use super::*;

#[derive(Clone, Copy)]
enum Action {
    Skip,
    Full(usize),
    Start,
    End(usize, u64),
    Tail(usize, u64),
}

pub(crate) struct RootEmitPlan {
    actions: [Action; 256],
}

impl RootEmitPlan {
    pub(crate) fn new(roots: &[usize]) -> Option<Self> {
        if roots.len() != 11313 || roots.last() != Some(&15088)
            || !roots.windows(2).all(|pair| pair[0] < pair[1]) { return None; }
        let mut actions = [Action::Skip; 256];
        let mut pairs = 0;
        for (out, group) in roots.chunks(64).enumerate() {
            let first = group[0];
            let source = first / 64;
            if first % 64 != 0 || !matches!(actions[source], Action::Skip) { return None; }
            if group.len() < 64 {
                if group.len() != 49 || !group.iter().enumerate().all(|(i, &wire)| wire == first + i) { return None; }
                actions[source] = Action::Tail(out, (1u64 << 49) - 1);
            } else if group[63] / 64 == source {
                if !group.iter().enumerate().all(|(i, &wire)| wire == first + i) { return None; }
                actions[source] = Action::Full(out);
            } else {
                if group[63] / 64 != source + 1 || !matches!(actions[source + 1], Action::Skip) { return None; }
                let split = group.iter().position(|&wire| wire >= first + 64)?;
                if split == 0 || !group.iter().enumerate().all(|(i, &wire)|
                    wire == first + i + if i >= split { 64 } else { 0 }) { return None; }
                actions[source] = Action::Start;
                actions[source + 1] = Action::End(out, (1u64 << split) - 1);
                pairs += 1;
            }
        }
        if pairs != 55 { return None; }
        Some(Self { actions })
    }
}

pub(crate) struct RootOctaWriter<'a> {
    plan: &'a RootEmitPlan,
    out: *mut u8,
    carry: [V8; 2],
    pending: bool,
}

impl<'a> RootOctaWriter<'a> {
    /// # Safety
    /// Caller exclusively owns this octa's aligned 64-byte stripe in each
    /// of the 177 consecutive 512-byte cache blocks. All producers must join
    /// and SFENCE before any cache read. No stripe may be read before every
    /// live source word has been emitted, including deferred window zero.
    pub(crate) unsafe fn new(plan: &'a RootEmitPlan, out: *mut u8) -> Self {
        debug_assert_eq!(out as usize % 64, 0);
        Self { plan, out, carry: unsafe { [_mm256_setzero_si256(); 2] }, pending: false }
    }

    #[inline(never)]
    pub(crate) unsafe fn emit_range(
        &mut self,
        base_word: usize,
        ring_word: usize,
        words: usize,
        a: *const V8,
        b: *const V8,
    ) {
        // Input holds eight low u32 words followed by eight high u32 words.
        // Reverse the row order inside each byte-column matrix for GFNI.
        const INDEX: [u8; 64] = {
            let mut indices = [0; 64];
            let mut i = 0;
            while i < 64 {
                let byte = i / 8;
                let lane = 7 - i % 8;
                indices[i] = (if byte < 4 { lane * 4 + byte }
                    else { 32 + lane * 4 + byte - 4 }) as u8;
                i += 1;
            }
            indices
        };
        debug_assert_eq!(base_word % 2, 0);
        debug_assert_eq!(words % 2, 0);
        unsafe {
            let indices = _mm512_loadu_si512(INDEX.as_ptr().cast());
            let identity = _mm512_set1_epi64(0x8040201008040201u64 as i64);
            for offset in (0..words).step_by(2) {
                let source = (base_word + offset) / 2;
                let action = self.plan.actions[source];
                if matches!(action, Action::Skip) { continue; }
                let rw = ring_word + offset;
                let mut low = _mm256_loadu_si256(a.add(rw));
                let mut high = _mm256_loadu_si256(a.add(rw + 1));
                // Static-B prefix words are intentionally absent from B's
                // ranked ring. All remaining source words are fully live.
                if base_word + offset >= 32 {
                    low = _mm256_and_si256(low, _mm256_loadu_si256(b.add(rw)));
                    high = _mm256_and_si256(high, _mm256_loadu_si256(b.add(rw + 1)));
                }
                let (out, mask) = match action {
                    Action::Skip => unreachable!(),
                    Action::Start => {
                        debug_assert!(!self.pending);
                        self.carry = [low, high];
                        self.pending = true;
                        continue;
                    }
                    Action::End(out, mask) => {
                        debug_assert!(self.pending);
                        let lo_mask = _mm256_set1_epi32(mask as u32 as i32);
                        let hi_mask = _mm256_set1_epi32((mask >> 32) as u32 as i32);
                        low = _mm256_xor_si256(low, _mm256_and_si256(lo_mask,
                            _mm256_xor_si256(low, self.carry[0])));
                        high = _mm256_xor_si256(high, _mm256_and_si256(hi_mask,
                            _mm256_xor_si256(high, self.carry[1])));
                        self.pending = false;
                        (out, u64::MAX)
                    }
                    Action::Full(out) => (out, u64::MAX),
                    Action::Tail(out, mask) => (out, mask),
                };
                let words = _mm512_inserti64x4::<1>(_mm512_castsi256_si512(low), high);
                let matrices = _mm512_permutexvar_epi8(indices, words);
                let bits = _mm512_gf2p8affine_epi64_epi8::<0>(identity, matrices);
                _mm512_stream_si512(self.out.add(out * 512).cast(),
                    _mm512_maskz_mov_epi8(mask, bits));
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn unsupported_root_selectors_fall_back() {
        assert!(RootEmitPlan::new(&[0, 1, 2]).is_none());
        let mut roots = super::super::super::Blake3AdjointPlan::build().linear_fold_plan().roots;
        roots[1024] = roots[1023];
        assert!(RootEmitPlan::new(&roots).is_none());
    }

    #[test]
    fn live_root_stripe_matches_canonical_bits_and_preserves_neighbors() {
        let fold = super::super::super::Blake3AdjointPlan::build().linear_fold_plan();
        assert_eq!(fold.roots.len(), 11313);
        let plan = RootEmitPlan::new(&fold.roots).unwrap();
        let mut seed = 0x4a2e_8193_c17d_b805u64;
        let mut rng = || {
            seed ^= seed << 13;
            seed ^= seed >> 7;
            seed ^= seed << 17;
            seed as u32
        };
        let a: [[u32; 8]; 512] = core::array::from_fn(|_| core::array::from_fn(|_| rng()));
        let b: [[u32; 8]; 512] = core::array::from_fn(|word| {
            core::array::from_fn(|_| if word < 32 { u32::MAX } else { rng() })
        });
        #[repr(align(64))]
        struct Tile([u8; 177 * 512]);
        let mut out = Box::new(Tile([0xa5; 177 * 512]));
        unsafe {
            let mut writer = RootOctaWriter::new(&plan, out.0.as_mut_ptr().add(3 * 64));
            // Match the real producer: window zero is deferred until last.
            for base in (16..512).step_by(16) {
                writer.emit_range(base, base, 16, a.as_ptr().cast(), b.as_ptr().cast());
            }
            writer.emit_range(0, 0, 16, a.as_ptr().cast(), b.as_ptr().cast());
            _mm_sfence();
        }
        for group in 0..177 {
            for stripe in 0..8 {
                for column in 0..64 {
                    let expected = if stripe != 3 {
                        0xa5
                    } else if let Some(&root) = fold.roots.get(group * 64 + column) {
                        let word = root / 32;
                        let bit = root % 32;
                        (0..8).fold(0u8, |byte, lane| {
                            byte | ((((a[word][lane] & b[word][lane]) >> bit) & 1) as u8) << lane
                        })
                    } else {
                        0
                    };
                    assert_eq!(out.0[group * 512 + stripe * 64 + column], expected,
                        "group={group}, stripe={stripe}, column={column}");
                }
            }
        }
    }
}