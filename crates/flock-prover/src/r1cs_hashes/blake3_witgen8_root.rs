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


#[derive(Clone, Copy, Default)]
struct FullOp { source: u32, out: u32 }
#[derive(Clone, Copy, Default)]
struct PairOp { source: u32, out: u32 }
#[derive(Clone, Copy, Default)]
#[repr(C, align(64))]
struct SelectBits([u32; 16]);
impl SelectBits {
    fn new(mask: u64) -> Self {
        let mut lanes = [mask as u32; 16];
        lanes[8..].fill((mask >> 32) as u32);
        Self(lanes)
    }
}
#[derive(Clone, Copy)]
struct Batch {
    full_start: u16, full_end: u16, pair_start: u16, pair_end: u16,
    leading_out: u16, trailing_source: u16, tail_source: u16, tail_out: u16,
    tail_mask: u64,
}
impl Default for Batch {
    fn default() -> Self { Self { full_start: 0, full_end: 0, pair_start: 0, pair_end: 0,
        leading_out: u16::MAX, trailing_source: u16::MAX, tail_source: u16::MAX,
        tail_out: 0, tail_mask: 0 } }
}

pub(crate) struct RootEmitPlan {
    pair_selects: [SelectBits; 55],
    leading_selects: [SelectBits; 17],
    actions: [Action; 256],
    full: [FullOp; 121],
    pairs: [PairOp; 55],
    batches: [Batch; 17],
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
        let mut full = [FullOp::default(); 121];
        let mut joined = [PairOp::default(); 55];
        let mut pair_selects = [SelectBits::default(); 55];
        let mut batches = [Batch::default(); 17];
        let mut leading_selects = [SelectBits::default(); 17];
        let (mut nf, mut np) = (0usize, 0usize);
        for (index, (batch, leading_select)) in batches.iter_mut().zip(leading_selects.iter_mut()).enumerate() {
            let (first, count) = if index < 2 { (index * 8, 8) } else { ((index - 1) * 16, 16) };
            batch.full_start = nf as u16;
            batch.pair_start = np as u16;
            for source in first..first + count {
                let offset = ((source - first) * 64) as u32;
                match actions[source] {
                    Action::Skip => {},
                    Action::Full(out) => { full[nf] = FullOp { source: offset, out: (out * 512) as u32 }; nf += 1; },
                    Action::Start if source + 1 < first + count => {
                        let Action::End(out, mask) = actions[source + 1] else { return None; };
                        joined[np] = PairOp { source: offset, out: (out * 512) as u32 };
                        pair_selects[np] = SelectBits::new(mask); np += 1;
                    },
                    Action::Start => batch.trailing_source = offset as u16,
                    Action::End(out, mask) if source == first => { batch.leading_out = out as u16; *leading_select = SelectBits::new(mask); },
                    Action::End(_, _) => {},
                    Action::Tail(out, mask) => { batch.tail_source = offset as u16; batch.tail_out = out as u16; batch.tail_mask = mask; },
                }
            }
            batch.full_end = nf as u16;
            batch.pair_end = np as u16;
        }
        debug_assert_eq!(nf, 121);
        Some(Self { actions, full, pairs: joined, pair_selects, batches, leading_selects })
    }
}

pub(crate) struct RootOctaWriter<'a> {
    plan: &'a RootEmitPlan,
    out: *mut u8,
    carry: __m512i,
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
        Self { plan, out, carry: unsafe { _mm512_setzero_si512() }, pending: false }
    }

    #[inline(never)]
    unsafe fn emit_generic(
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
                let mut value = _mm512_loadu_si512(a.add(rw).cast());
                if base_word + offset >= 32 {
                    value = _mm512_and_si512(value, _mm512_loadu_si512(b.add(rw).cast()));
                }
                let (out, mask) = match action {
                    Action::Skip => unreachable!(),
                    Action::Start => {
                        debug_assert!(!self.pending);
                        self.carry = value;
                        self.pending = true;
                        continue;
                    }
                    Action::End(out, mask) => {
                        debug_assert!(self.pending);
                        value = Self::select_pair(&SelectBits::new(mask), self.carry, value);
                        self.pending = false;
                        (out, u64::MAX)
                    }
                    Action::Full(out) => (out, u64::MAX),
                    Action::Tail(out, mask) => (out, mask),
                };
                let words = value;
                let matrices = _mm512_permutexvar_epi8(indices, words);
                let bits = _mm512_gf2p8affine_epi64_epi8::<0>(identity, matrices);
                _mm512_stream_si512(self.out.add(out * 512).cast(),
                    _mm512_maskz_mov_epi8(mask, bits));
            }
        }
    }
    #[inline(always)]
    unsafe fn load_pair<const STATIC_B: bool>(a: *const u8, b: *const u8, offset: usize) -> __m512i {
        unsafe {
            let x = _mm512_loadu_si512(a.add(offset).cast());
            if STATIC_B { x } else { _mm512_and_si512(x, _mm512_loadu_si512(b.add(offset).cast())) }
        }
    }

    #[inline(always)]
    unsafe fn select_pair(select: &SelectBits, first: __m512i, second: __m512i) -> __m512i {
        unsafe {
            debug_assert_eq!(select.0.as_ptr() as usize % 64, 0);
            let select = _mm512_load_si512(select.0.as_ptr().cast());
            _mm512_ternarylogic_epi64::<0xca>(select, first, second)
        }
    }

    #[inline(always)]
    unsafe fn emit_batch<const STATIC_B: bool>(&mut self, index: usize, a: *const V8, b: *const V8) {
        const INDEX: [u8; 64] = {
            let mut indices = [0; 64]; let mut i = 0;
            while i < 64 {
                let byte = i / 8; let lane = 7 - i % 8;
                indices[i] = (if byte < 4 { lane * 4 + byte } else { 32 + lane * 4 + byte - 4 }) as u8;
                i += 1;
            }
            indices
        };
        unsafe {
            let batch = &self.plan.batches[index];
            let indices = _mm512_loadu_si512(INDEX.as_ptr().cast());
            let identity = _mm512_set1_epi64(0x8040201008040201u64 as i64);
            let out_ptr = self.out;
            let emit = |out: usize, value| {
                let matrices = _mm512_permutexvar_epi8(indices, value);
                _mm512_stream_si512(out_ptr.add(out).cast(), _mm512_gf2p8affine_epi64_epi8::<0>(identity, matrices));
            };
            let (a, b) = (a.cast::<u8>(), b.cast::<u8>());
            if batch.leading_out != u16::MAX {
                debug_assert!(self.pending);
                let next = Self::load_pair::<STATIC_B>(a, b, 0);
                emit(batch.leading_out as usize * 512, Self::select_pair(&self.plan.leading_selects[index], self.carry, next));
                self.pending = false;
            }
            for op in &self.plan.full[batch.full_start as usize..batch.full_end as usize] {
                emit(op.out as usize, Self::load_pair::<STATIC_B>(a, b, op.source as usize));
            }
            let pairs = batch.pair_start as usize..batch.pair_end as usize;
            for (op, select) in self.plan.pairs[pairs.clone()].iter().zip(&self.plan.pair_selects[pairs]) {
                debug_assert!(!self.pending);
                let first = Self::load_pair::<STATIC_B>(a, b, op.source as usize);
                let second = Self::load_pair::<STATIC_B>(a, b, op.source as usize + 64);
                emit(op.out as usize, Self::select_pair(select, first, second));
            }
            if batch.tail_source != u16::MAX {
                let value = Self::load_pair::<STATIC_B>(a, b, batch.tail_source as usize);
                let matrices = _mm512_permutexvar_epi8(indices, value);
                let bits = _mm512_gf2p8affine_epi64_epi8::<0>(identity, matrices);
                _mm512_stream_si512(self.out.add(batch.tail_out as usize * 512).cast(), _mm512_maskz_mov_epi8(batch.tail_mask, bits));
            }
            if batch.trailing_source != u16::MAX {
                debug_assert!(!self.pending);
                self.carry = Self::load_pair::<STATIC_B>(a, b, batch.trailing_source as usize);
                self.pending = true;
            }
        }
    }

    #[inline(never)]
    pub(crate) unsafe fn emit_range(&mut self, base_word: usize, ring_word: usize, words: usize, a: *const V8, b: *const V8) {
        unsafe {
            if base_word >= 32 && base_word <= 480 && base_word % 32 == 0 && ring_word == 0 && words == 32 {
                self.emit_batch::<false>(base_word / 32 + 1, a, b);
            } else if base_word == 0 && ring_word == 0 && words == 16 {
                self.emit_batch::<true>(0, a, b);
            } else if base_word == 16 && ring_word == 16 && words == 16 {
                self.emit_batch::<true>(1, a.add(16), b.add(16));
            } else {
                self.emit_generic(base_word, ring_word, words, a, b);
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
        let mut batched = Box::new(Tile([0xa5; 177 * 512]));
        unsafe {
            let mut writer = RootOctaWriter::new(&plan, batched.0.as_mut_ptr().add(3 * 64));
            writer.emit_range(16, 16, 16, a.as_ptr().cast(), b.as_ptr().cast());
            let mut base = 32usize;
            while base <= 480 {
                writer.emit_range(base, 0, 32, a.as_ptr().add(base).cast(), b.as_ptr().add(base).cast());
                base += 32;
            }
            writer.emit_range(0, 0, 16, a.as_ptr().cast(), b.as_ptr().cast());
            _mm_sfence();
        }
        for tile in [&out.0, &batched.0] {
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
                        assert_eq!(tile[group * 512 + stripe * 64 + column], expected,
                            "group={group}, stripe={stripe}, column={column}");
                    }
                }
            }
        }
    }
}
