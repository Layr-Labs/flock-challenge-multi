//! Exact regeneration of the ranked BLAKE3 witness `z` from the witness-born
//! root tiles (`flock_core::lincheck::WitnessRootTiles`).
//!
//! The ranked producer may skip z's global DRAM stores for octas it seeds
//! from their compact copy (`StreamProj::elide_z`). Every z bit is then
//! still determined by the tiles:
//!
//! * root wires (11,249 of the 11,313 plan roots) are stored verbatim, one
//!   64-wire group per z qword (or per qword pair around a lin interval);
//! * the 64 omitted roots (wires 1089..1153) are the constant `block_len = 64`
//!   and `flags = 11` words every ranked compression carries;
//! * the 4,096 dependent wires (each G's `b_new`/`d_new`, `out_lo`, `out_hi`)
//!   are BLAKE3 state words, recomputed here from the stored `cv`, `m`,
//!   counter inputs.
//!
//! The expander works on one octa pair (16 compressions) at a time: BLAKE3 in
//! sixteen u32 lanes, then each octa's 242 live z qwords in qword-lane order
//! (one ZMM per qword, lane = compression) in an L1-resident stage. The fold
//! consumes that stage directly with carry-less multiplies, so z is never
//! transposed to block order and never written to DRAM.

use std::sync::atomic::{AtomicBool, Ordering};

/// Test-only override: force z elision off without touching the process env.
pub(crate) static FORCE_OFF: AtomicBool = AtomicBool::new(false);
/// Diagnostics: regenerator folds / full materializations performed.
pub(crate) static REGEN_FOLDS: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);
pub(crate) static REGEN_MATERIALIZES: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

/// Production gate for skipping z's DRAM stores (`FLOCK_NO_Z_ELIDE=1`
/// restores the dense witness). Requires the exact regeneration plan.
pub(crate) fn z_elide_enabled() -> bool {
    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "avx512vbmi2",
        target_feature = "gfni",
        target_feature = "vpclmulqdq"
    ))]
    {
        static ON: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
            std::env::var_os("FLOCK_NO_Z_ELIDE").is_none() && imp::plan().is_some()
        });
        *ON && !FORCE_OFF.load(Ordering::Relaxed)
    }
    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "avx512vbmi2",
        target_feature = "gfni",
        target_feature = "vpclmulqdq"
    )))]
    {
        let _ = &FORCE_OFF;
        false
    }
}

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512bw",
    target_feature = "avx512vbmi",
    target_feature = "avx512vbmi2",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
pub(crate) use imp::TileRegen;

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512bw",
    target_feature = "avx512vbmi",
    target_feature = "avx512vbmi2",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
pub(crate) mod imp {
    use super::super::{
        BLEN_BASE, FLAGS_BASE, G_LANES, G_MSG_IDX, G_STRIDE, GS_BASE, K, MSG_PERMUTATION,
        N_G, N_G_PER_ROUND, N_ROUNDS, OUT_HI_BASE, OUT_LO_BASE, T_HI_BASE, USEFUL_BITS,
        WORD_BITS, ADDS_PER_G, CARRY_BITS_PER_ADD,
    };
    use core::arch::x86_64::*;
    use flock_core::field::F128;
    use flock_core::lincheck::{RootFoldSource, WitnessRootTiles, WitnessTileView};
    use rayon::prelude::*;
    use std::sync::Arc;

    /// Staged z qwords per compression: 0..=240 are live, 241 is the zero
    /// high half of element 120. Qwords 242..256 are zero padding.
    pub(super) const NQ: usize = 242;
    const GROUPS: usize = 176;
    const GROUP_BYTES: usize = 512;
    const TILE_BYTES: usize = GROUPS * GROUP_BYTES;
    const BLOCK_LEN: u32 = 64;
    const FLAGS: u32 = 11;
    /// Fixed-cache group 13 carries wire 1088 in bit 0 and wires 1153..1216
    /// in bits 1..63 (see `RootTileCache::from_witness_storage`).
    const SPLICED_GROUP: usize = 13;
    const TAIL_GROUP: usize = 175;
    const TAIL_Q: usize = 235;
    const TAIL_BITS: u32 = 49;
    /// Constant bits of z qword 17 (wires 1088..1152): block_len and flags.
    const Q17_CONST: u64 = ((BLOCK_LEN as u64) << (BLEN_BASE - 1088))
        | ((FLAGS as u64) << (FLAGS_BASE - 1088));
    const LIN_OFFSET: usize = ADDS_PER_G * CARRY_BITS_PER_ADD;

    const fn sched() -> [[[usize; 2]; N_G_PER_ROUND]; N_ROUNDS] {
        let mut perm = [0usize; 16];
        let mut i = 0;
        while i < 16 {
            perm[i] = i;
            i += 1;
        }
        let mut out = [[[0usize; 2]; N_G_PER_ROUND]; N_ROUNDS];
        let mut r = 0;
        while r < N_ROUNDS {
            let mut g = 0;
            while g < N_G_PER_ROUND {
                out[r][g][0] = perm[G_MSG_IDX[g][0]];
                out[r][g][1] = perm[G_MSG_IDX[g][1]];
                g += 1;
            }
            let mut next = [0usize; 16];
            let mut i = 0;
            while i < 16 {
                next[i] = perm[MSG_PERMUTATION[i]];
                i += 1;
            }
            perm = next;
            r += 1;
        }
        out
    }
    const SCHED: [[[usize; 2]; N_G_PER_ROUND]; N_ROUNDS] = sched();

    /// z qword `q` = cache group `cg`.
    #[derive(Clone, Copy, Debug)]
    struct FullOp {
        q: u16,
        cg: u16,
    }

    /// z qwords `q`, `q+1` = cache group `cg` split around G `g`'s 64 lin
    /// wires; rotation and low mask live at the same index in `rot`/`mask`.
    #[derive(Clone, Copy, Debug)]
    struct PairOp {
        q: u16,
        cg: u16,
        g: u16,
    }

    #[repr(C, align(64))]
    #[derive(Clone, Copy)]
    struct Lanes([u64; 8]);

    pub(crate) struct Plan {
        full: Vec<FullOp>,
        pairs: Vec<PairOp>,
        rot: Vec<Lanes>,
        mask: Vec<Lanes>,
        // True only for the complete geometry checked against the fused expansion.
        fused_layout: bool,
    }

    /// Derive (and fully check) the tile -> z qword map from the linear fold
    /// plan's root list. `None` on any geometry surprise: elision then stays
    /// off and z is stored as before.
    fn build_plan(roots: &[usize]) -> Option<Plan> {
        let lanes_ok = G_LANES
            == [
                [0, 4, 8, 12],
                [1, 5, 9, 13],
                [2, 6, 10, 14],
                [3, 7, 11, 15],
                [0, 5, 10, 15],
                [1, 6, 11, 12],
                [2, 7, 8, 13],
                [3, 4, 9, 14],
            ];
        if !lanes_ok
            || K != 16384
            || USEFUL_BITS != 15409
            || OUT_LO_BASE != 256
            || T_HI_BASE + WORD_BITS != 1089
            || BLEN_BASE != 1089
            || FLAGS_BASE + WORD_BITS != 1153
            || GS_BASE != 1153
            || N_G != 56
            || GS_BASE + G_STRIDE * (N_G - 1) + LIN_OFFSET != TAIL_Q * 64 + TAIL_BITS as usize
            || OUT_HI_BASE != (TAIL_Q + 1) * 64 + TAIL_BITS as usize
            || OUT_HI_BASE + 8 * WORD_BITS != USEFUL_BITS
            || roots.len() != 11313
            || roots.windows(2).any(|w| w[0] >= w[1])
        {
            return None;
        }
        let groups: Vec<&[usize]> = roots.chunks(64).collect();
        if groups.len() != GROUPS + 1 {
            return None;
        }
        let contiguous = |g: &[usize], first: usize| g.iter().enumerate().all(|(i, &c)| c == first + i);
        if groups[13].len() != 64 || !contiguous(groups[13], 1088) {
            return None;
        }
        if groups[14].len() != 64 || !contiguous(groups[14], 1152) {
            return None;
        }
        let mut covered = [0u8; NQ];
        for q in 4..8 {
            covered[q] += 1; // out_lo
        }
        covered[17] += 1;
        covered[18] += 1;
        for q in TAIL_Q..NQ {
            covered[q] += 1; // tail roots + G55 lin + out_hi + zero
        }
        let mut full = Vec::new();
        let mut pairs = Vec::new();
        let mut rot = Vec::new();
        let mut mask = Vec::new();
        let mut g_seen = [false; 55];
        for (r, grp) in groups.iter().enumerate() {
            if r == 13 || r == 14 {
                continue;
            }
            let cg = if r < 13 { r } else { r - 1 };
            let first = grp[0];
            if first % 64 != 0 {
                return None;
            }
            let q = first / 64;
            if grp.len() == TAIL_BITS as usize {
                if r != GROUPS || cg != TAIL_GROUP || q != TAIL_Q || !contiguous(grp, first) {
                    return None;
                }
                continue;
            }
            if grp.len() != 64 || q + 1 >= NQ {
                return None;
            }
            if contiguous(grp, first) {
                covered[q] += 1;
                full.push(FullOp { q: q as u16, cg: cg as u16 });
                continue;
            }
            let split = grp.iter().position(|&c| c >= first + 64)?;
            if split == 0
                || grp
                    .iter()
                    .enumerate()
                    .any(|(i, &c)| c != first + i + if i >= split { 64 } else { 0 })
            {
                return None;
            }
            let lin = first + split;
            let off = lin.checked_sub(GS_BASE + LIN_OFFSET)?;
            if off % G_STRIDE != 0 || off / G_STRIDE >= 55 {
                return None;
            }
            let g = off / G_STRIDE;
            if std::mem::replace(&mut g_seen[g], true) {
                return None;
            }
            covered[q] += 1;
            covered[q + 1] += 1;
            pairs.push(PairOp { q: q as u16, cg: cg as u16, g: g as u16 });
            rot.push(Lanes([split as u64; 8]));
            mask.push(Lanes([(1u64 << split) - 1; 8]));
        }
        if covered.iter().any(|&c| c != 1) || g_seen.iter().any(|&s| !s) {
            return None;
        }
        let mut plan = Plan { full, pairs, rot, mask, fused_layout: false };
        plan.fused_layout = fused_layout_matches(&plan);
        Some(plan)
    }

    pub(crate) fn plan() -> Option<&'static Plan> {
        static PLAN: std::sync::LazyLock<Option<Plan>> = std::sync::LazyLock::new(|| {
            let lf = super::super::BLAKE3_ADJOINT_PLAN
                .linear_fold
                .get_or_init(|| super::super::BLAKE3_ADJOINT_PLAN.linear_fold_plan());
            build_plan(&lf.roots)
        });
        PLAN.as_ref()
    }

    #[repr(C, align(64))]
    pub(super) struct Stage(pub(super) [__m512i; NQ]);

    /// Per-worker scratch (~23 KiB, L1-resident): one octa's z stage plus
    /// the current octa pair's BLAKE3 dependent qwords (`b_new | d_new << 32`
    /// per G) and output qwords.
    #[repr(C, align(64))]
    pub(super) struct Scratch {
        pub(super) stage: Stage,
        deps: [[__m512i; N_G]; 2],
        out_lo: [[__m512i; 4]; 2],
        out_hi: [[__m512i; 4]; 2],
    }

    impl Scratch {
        pub(super) fn new() -> Box<Self> {
            // SAFETY: all-zero bytes are a valid value of every field. Built
            // in place on the heap (it is too large for a worker's stack).
            unsafe { Box::<Self>::new_zeroed().assume_init() }
        }
    }

    /// BLAKE3 over octas `o0`, `o0 + 1` (sixteen u32 lanes) from their input
    /// words in the tile; stores every dependent qword in `scratch` (slots
    /// 0 and 1). Issues one `pf` step per odd G (28 lines).
    ///
    /// # Safety
    /// `tile` points at one complete, initialized, 64-byte-aligned witness
    /// tile (176 groups x 512 bytes) and `o0 + 1 < 8`.
    #[inline(never)]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi,avx512vbmi2,gfni,vpclmulqdq")]
    pub(super) unsafe fn blake3_pair(tile: *const u8, o0: usize, scratch: &mut Scratch, pf: &mut PfCur) {
        unsafe {
            macro_rules! stripe {
                ($cg:expr, $o:expr) => {
                    _mm512_load_si512(tile.add($cg * GROUP_BYTES + $o * 64).cast::<__m512i>())
                };
            }
            let idx_lo = _mm512_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7, 16, 17, 18, 19, 20, 21, 22, 23);
            let idx_hi = _mm512_setr_epi32(8, 9, 10, 11, 12, 13, 14, 15, 24, 25, 26, 27, 28, 29, 30, 31);
            // Word w (16 lanes: octa o0 then o0+1) from its cache group.
            macro_rules! word16 {
                ($cg:expr, $hi:expr) => {
                    _mm512_permutex2var_epi32(
                        stripe!($cg, o0),
                        if $hi { idx_hi } else { idx_lo },
                        stripe!($cg, o0 + 1),
                    )
                };
            }
            let cv: [__m512i; 8] = core::array::from_fn(|j| word16!(j / 2, j & 1 == 1));
            // z words 16..=34 (wires 512..1120); word 34 keeps wire 1088 in
            // bit 0, the only bit read from it.
            let zw: [__m512i; 19] = core::array::from_fn(|i| {
                let w = 16 + i;
                let q = w / 2;
                let cg = if q == 17 { SPLICED_GROUP } else { q - 4 };
                word16!(cg, w & 1 == 1)
            });
            let m: [__m512i; 16] = core::array::from_fn(|i| _mm512_shrdi_epi32::<1>(zw[i], zw[i + 1]));
            let t_lo = _mm512_shrdi_epi32::<1>(zw[16], zw[17]);
            let t_hi = _mm512_shrdi_epi32::<1>(zw[17], zw[18]);
            let iv = super::super::BLAKE3_IV;
            let mut v: [__m512i; 16] = [
                cv[0],
                cv[1],
                cv[2],
                cv[3],
                cv[4],
                cv[5],
                cv[6],
                cv[7],
                _mm512_set1_epi32(iv[0] as i32),
                _mm512_set1_epi32(iv[1] as i32),
                _mm512_set1_epi32(iv[2] as i32),
                _mm512_set1_epi32(iv[3] as i32),
                t_lo,
                t_hi,
                _mm512_set1_epi32(BLOCK_LEN as i32),
                _mm512_set1_epi32(FLAGS as i32),
            ];
            // Lane j of octa A/B as qword (b_new | d_new << 32).
            let il_a = _mm512_setr_epi32(0, 16, 1, 17, 2, 18, 3, 19, 4, 20, 5, 21, 6, 22, 7, 23);
            let il_b = _mm512_setr_epi32(8, 24, 9, 25, 10, 26, 11, 27, 12, 28, 13, 29, 14, 30, 15, 31);
            let deps = &mut scratch.deps;
            macro_rules! g {
                ($r:literal, $gi:literal, $a:literal, $b:literal, $c:literal, $d:literal) => {{
                    let mx = m[SCHED[$r][$gi][0]];
                    let my = m[SCHED[$r][$gi][1]];
                    v[$a] = _mm512_add_epi32(_mm512_add_epi32(v[$a], v[$b]), mx);
                    v[$d] = _mm512_ror_epi32::<16>(_mm512_xor_si512(v[$d], v[$a]));
                    v[$c] = _mm512_add_epi32(v[$c], v[$d]);
                    v[$b] = _mm512_ror_epi32::<12>(_mm512_xor_si512(v[$b], v[$c]));
                    v[$a] = _mm512_add_epi32(_mm512_add_epi32(v[$a], v[$b]), my);
                    v[$d] = _mm512_ror_epi32::<8>(_mm512_xor_si512(v[$d], v[$a]));
                    v[$c] = _mm512_add_epi32(v[$c], v[$d]);
                    v[$b] = _mm512_ror_epi32::<7>(_mm512_xor_si512(v[$b], v[$c]));
                    deps[0][8 * $r + $gi] = _mm512_permutex2var_epi32(v[$b], il_a, v[$d]);
                    deps[1][8 * $r + $gi] = _mm512_permutex2var_epi32(v[$b], il_b, v[$d]);
                    if $gi & 1 == 1 {
                        pf.step();
                    }
                }};
            }
            macro_rules! round {
                ($r:literal) => {
                    g!($r, 0, 0, 4, 8, 12);
                    g!($r, 1, 1, 5, 9, 13);
                    g!($r, 2, 2, 6, 10, 14);
                    g!($r, 3, 3, 7, 11, 15);
                    g!($r, 4, 0, 5, 10, 15);
                    g!($r, 5, 1, 6, 11, 12);
                    g!($r, 6, 2, 7, 8, 13);
                    g!($r, 7, 3, 4, 9, 14);
                };
            }
            round!(0);
            round!(1);
            round!(2);
            round!(3);
            round!(4);
            round!(5);
            round!(6);
            for k in 0..4 {
                let lo0 = _mm512_xor_si512(v[2 * k], v[2 * k + 8]);
                let lo1 = _mm512_xor_si512(v[2 * k + 1], v[2 * k + 9]);
                let hi0 = _mm512_xor_si512(v[2 * k + 8], cv[2 * k]);
                let hi1 = _mm512_xor_si512(v[2 * k + 9], cv[2 * k + 1]);
                scratch.out_lo[0][k] = _mm512_permutex2var_epi32(lo0, il_a, lo1);
                scratch.out_lo[1][k] = _mm512_permutex2var_epi32(lo0, il_b, lo1);
                scratch.out_hi[0][k] = _mm512_permutex2var_epi32(hi0, il_a, hi1);
                scratch.out_hi[1][k] = _mm512_permutex2var_epi32(hi0, il_b, hi1);
            }
        }
    }

    /// Fill `scratch.stage` with octa `o0 + x` (qword-lane z: one ZMM per z
    /// qword, lane = compression) from the tile (L2-resident by then) and
    /// dependent slot `x`. Spreads the current `pf` phase over its 174
    /// group ops.
    ///
    /// # Safety
    /// As for [`blake3_pair`]; `x < 2`; `prefetch` points into the tile span.
    #[inline(never)]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi,avx512vbmi2,gfni,vpclmulqdq")]
    pub(super) unsafe fn fill_stage(
        plan: &Plan,
        tile: *const u8,
        o: usize,
        x: usize,
        scratch: &mut Scratch,
        pf: &mut PfCur,
    ) {
        unsafe {
            let src = tile.add(o * 64);
            let idxq = _mm512_setr_epi32(0, 8, 1, 9, 2, 10, 3, 11, 4, 12, 5, 13, 6, 14, 7, 15);
            macro_rules! q64 {
                ($cg:expr) => {
                    _mm512_permutexvar_epi32(
                        idxq,
                        _mm512_load_si512(src.add($cg * GROUP_BYTES).cast::<__m512i>()),
                    )
                };
            }
            let stp = scratch.stage.0.as_mut_ptr();
            let dep = scratch.deps[x].as_ptr();
            for op in plan.full.iter() {
                pf.tick();
                *stp.add(op.q as usize) = q64!(op.cg as usize);
            }
            let rot = plan.rot.as_ptr();
            let mask = plan.mask.as_ptr();
            for (i, op) in plan.pairs.iter().enumerate() {
                pf.tick();
                let gq = q64!(op.cg as usize);
                let r = _mm512_rolv_epi64(
                    *dep.add(op.g as usize),
                    _mm512_load_si512((*rot.add(i)).0.as_ptr().cast()),
                );
                let mk = _mm512_load_si512((*mask.add(i)).0.as_ptr().cast());
                *stp.add(op.q as usize) = _mm512_ternarylogic_epi64::<0xCA>(mk, gq, r);
                *stp.add(op.q as usize + 1) = _mm512_ternarylogic_epi64::<0xCA>(mk, r, gq);
            }
            let ol = &scratch.out_lo[x];
            for k in 0..4 {
                *stp.add(4 + k) = ol[k];
            }
            let one = _mm512_set1_epi64(1);
            let c13 = q64!(SPLICED_GROUP);
            *stp.add(17) = _mm512_ternarylogic_epi64::<0xEA>(c13, one, _mm512_set1_epi64(Q17_CONST as i64));
            *stp.add(18) = _mm512_andnot_si512(one, c13);
            let oh = &scratch.out_hi[x];
            let d55 = *dep.add(N_G - 1);
            *stp.add(TAIL_Q) = _mm512_ternarylogic_epi64::<0xEA>(
                q64!(TAIL_GROUP),
                _mm512_set1_epi64(((1u64 << TAIL_BITS) - 1) as i64),
                _mm512_slli_epi64::<49>(d55),
            );
            *stp.add(TAIL_Q + 1) = _mm512_shrdi_epi64::<15>(d55, oh[0]);
            *stp.add(TAIL_Q + 2) = _mm512_shrdi_epi64::<15>(oh[0], oh[1]);
            *stp.add(TAIL_Q + 3) = _mm512_shrdi_epi64::<15>(oh[1], oh[2]);
            *stp.add(TAIL_Q + 4) = _mm512_shrdi_epi64::<15>(oh[2], oh[3]);
            *stp.add(TAIL_Q + 5) = _mm512_srli_epi64::<15>(oh[3]);
            *stp.add(TAIL_Q + 6) = _mm512_setzero_si512();
        }
    }

    /// Next-tile prefetch cursor. Each octa pair of a tile streams in the
    /// matching quarter (352 contiguous lines) of the next tile, paced evenly
    /// through the pair's BLAKE3 (`PF_BLAKE`), both staging passes
    /// (`PF_FILL` each) and both folds (one per unrolled iteration, 60
    /// each). Bursts would occupy the core's fill buffers while compute
    /// idles; paced, the stream overlaps the compute.
    pub(super) struct PfCur {
        cur: usize,
        lim: usize,
        end: usize,
        num: usize,
        den: usize,
        acc: usize,
    }

    const PF_BLAKE: usize = 28;
    const PF_FOLD: usize = 60;
    const PF_FILL: usize = (2 * GROUPS - PF_BLAKE - 2 * PF_FOLD) / 2;
    /// Ops of one staging pass (119 full groups + 55 split pairs).
    const FILL_OPS: usize = 174;

    impl PfCur {
        fn new(next: Option<usize>) -> Self {
            let (cur, end) = next.map_or((0, 0), |n| (n, n + 2 * (TILE_BYTES / 8)));
            Self { cur, lim: cur, end, num: 0, den: 1, acc: 0 }
        }

        /// Next phase: `lines` prefetches, spread over `ticks` ticks.
        #[inline(always)]
        fn phase(&mut self, lines: usize, ticks: usize) {
            self.lim = (self.cur + lines * 64).min(self.end);
            self.num = lines;
            self.den = ticks;
            self.acc = 0;
        }

        /// Prefetch the next line of the phase.
        #[inline(always)]
        fn step(&mut self) {
            if self.cur < self.lim {
                // SAFETY: a prefetch hint inside the tile span.
                unsafe { _mm_prefetch::<_MM_HINT_T1>(self.cur as *const i8) };
                self.cur += 64;
            }
        }

        /// One of the phase's `ticks`: issue its share of the lines.
        #[inline(always)]
        fn tick(&mut self) {
            self.acc += self.num;
            while self.acc >= self.den && self.cur < self.lim {
                // SAFETY: as in `step`.
                unsafe { _mm_prefetch::<_MM_HINT_T1>(self.cur as *const i8) };
                self.cur += 64;
                self.acc -= self.den;
            }
        }

        /// Issue whatever the phase has left.
        #[inline(always)]
        fn flush(&mut self) {
            while self.cur < self.lim {
                self.step();
            }
        }
    }

    /// Per-element fold weights: `[W.lo, W.hi]` and `[W.lo ^ W.hi, 0]` in
    /// every 128-bit lane.
    #[repr(C, align(64))]
    pub(super) struct Weights {
        lohi: [__m512i; 64],
        sum: [__m512i; 64],
    }

    impl Weights {
        pub(super) fn new(w: &[F128; 64]) -> Box<Self> {
            // SAFETY: AVX-512 is a cfg precondition of this module.
            unsafe {
                let mut out: Box<Self> = Box::new(core::mem::zeroed());
                for (i, wi) in w.iter().enumerate() {
                    out.lohi[i] = _mm512_broadcast_i32x4(_mm_set_epi64x(wi.hi as i64, wi.lo as i64));
                    out.sum[i] = _mm512_broadcast_i32x4(_mm_set_epi64x(0, (wi.lo ^ wi.hi) as i64));
                }
                out
            }
        }
    }

    /// Fold one staged octa: `[half][parity]`, each reduced ZMM holding the
    /// four F128 results of lanes `2l + parity`.
    #[inline(never)]
    #[target_feature(enable = "avx512f,avx512bw,vpclmulqdq")]
    unsafe fn fold_stage(st: &Stage, w: &Weights, pf: &mut PfCur) -> [[__m512i; 2]; 2] {
        unsafe {
            let mut out = [[_mm512_setzero_si512(); 2]; 2];
            let st = st.0.as_ptr();
            let wl = w.lohi.as_ptr();
            let ws = w.sum.as_ptr();
            for (h, slot) in out.iter_mut().enumerate() {
                // Element pairs per half: 64 and 57 (qword 241 is zero).
                let ne = if h == 0 { 64 } else { (NQ - 128) / 2 };
                let base = st.add(128 * h);
                let z = _mm512_setzero_si512();
                let (mut le, mut lo, mut he, mut ho, mut me, mut mo) = (z, z, z, z, z, z);
                let mut e = 0;
                while e + 2 <= ne {
                    pf.step();
                    let a0 = *base.add(2 * e);
                    let b0 = *base.add(2 * e + 1);
                    let a1 = *base.add(2 * e + 2);
                    let b1 = *base.add(2 * e + 3);
                    let w0 = *wl.add(e);
                    let w1 = *wl.add(e + 1);
                    let s0 = *ws.add(e);
                    let s1 = *ws.add(e + 1);
                    let x0 = _mm512_xor_si512(a0, b0);
                    let x1 = _mm512_xor_si512(a1, b1);
                    le = _mm512_ternarylogic_epi64::<0x96>(
                        le,
                        _mm512_clmulepi64_epi128::<0x00>(a0, w0),
                        _mm512_clmulepi64_epi128::<0x00>(a1, w1),
                    );
                    lo = _mm512_ternarylogic_epi64::<0x96>(
                        lo,
                        _mm512_clmulepi64_epi128::<0x01>(a0, w0),
                        _mm512_clmulepi64_epi128::<0x01>(a1, w1),
                    );
                    he = _mm512_ternarylogic_epi64::<0x96>(
                        he,
                        _mm512_clmulepi64_epi128::<0x10>(b0, w0),
                        _mm512_clmulepi64_epi128::<0x10>(b1, w1),
                    );
                    ho = _mm512_ternarylogic_epi64::<0x96>(
                        ho,
                        _mm512_clmulepi64_epi128::<0x11>(b0, w0),
                        _mm512_clmulepi64_epi128::<0x11>(b1, w1),
                    );
                    me = _mm512_ternarylogic_epi64::<0x96>(
                        me,
                        _mm512_clmulepi64_epi128::<0x00>(x0, s0),
                        _mm512_clmulepi64_epi128::<0x00>(x1, s1),
                    );
                    mo = _mm512_ternarylogic_epi64::<0x96>(
                        mo,
                        _mm512_clmulepi64_epi128::<0x01>(x0, s0),
                        _mm512_clmulepi64_epi128::<0x01>(x1, s1),
                    );
                    e += 2;
                }
                if e < ne {
                    let a = *base.add(2 * e);
                    let b = *base.add(2 * e + 1);
                    let x = _mm512_xor_si512(a, b);
                    let w0 = *wl.add(e);
                    let s0 = *ws.add(e);
                    le = _mm512_xor_si512(le, _mm512_clmulepi64_epi128::<0x00>(a, w0));
                    lo = _mm512_xor_si512(lo, _mm512_clmulepi64_epi128::<0x01>(a, w0));
                    he = _mm512_xor_si512(he, _mm512_clmulepi64_epi128::<0x10>(b, w0));
                    ho = _mm512_xor_si512(ho, _mm512_clmulepi64_epi128::<0x11>(b, w0));
                    me = _mm512_xor_si512(me, _mm512_clmulepi64_epi128::<0x00>(x, s0));
                    mo = _mm512_xor_si512(mo, _mm512_clmulepi64_epi128::<0x01>(x, s0));
                }
                // Karatsuba middle term: (a_lo + a_hi)(w_lo + w_hi) + lo + hi.
                let me = _mm512_ternarylogic_epi64::<0x96>(me, le, he);
                let mo = _mm512_ternarylogic_epi64::<0x96>(mo, lo, ho);
                slot[0] = flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(le, me, he);
                slot[1] = flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(lo, mo, ho);
            }
            out
        }
    }


    // The unrolled expansion is used only when every descriptor and all lane
    // constants match. The ordinary staged path remains the geometry fallback.
    fn fused_layout_matches(plan: &Plan) -> bool {
        const FULL: [(u16,u16);119] = [(0, 0), (1, 1), (2, 2), (3, 3), (8, 4), (9, 5), (10, 6), (11, 7), (12, 8), (13, 9), (14, 10), (15, 11), (16, 12), (19, 14), (22, 16), (23, 17), (26, 19), (27, 20), (30, 22), (31, 23), (34, 25), (35, 26), (38, 28), (39, 29), (42, 31), (43, 32), (46, 34), (47, 35), (50, 37), (51, 38), (54, 40), (55, 41), (58, 43), (61, 45), (62, 46), (65, 48), (66, 49), (69, 51), (70, 52), (73, 54), (74, 55), (77, 57), (78, 58), (81, 60), (82, 61), (85, 63), (86, 64), (89, 66), (90, 67), (93, 69), (94, 70), (97, 72), (98, 73), (101, 75), (104, 77), (105, 78), (108, 80), (109, 81), (112, 83), (113, 84), (116, 86), (117, 87), (120, 89), (121, 90), (124, 92), (125, 93), (128, 95), (129, 96), (132, 98), (133, 99), (136, 101), (137, 102), (140, 104), (141, 105), (144, 107), (147, 109), (148, 110), (151, 112), (152, 113), (155, 115), (156, 116), (159, 118), (160, 119), (163, 121), (164, 122), (167, 124), (168, 125), (171, 127), (172, 128), (175, 130), (176, 131), (179, 133), (180, 134), (183, 136), (186, 138), (187, 139), (190, 141), (191, 142), (194, 144), (195, 145), (198, 147), (199, 148), (202, 150), (203, 151), (206, 153), (207, 154), (210, 156), (211, 157), (214, 159), (215, 160), (218, 162), (219, 163), (222, 165), (223, 166), (226, 168), (229, 170), (230, 171), (233, 173), (234, 174)];
        const PAIRS: [(u16,u16,u16);55] = [(20, 15, 0), (24, 18, 1), (28, 21, 2), (32, 24, 3), (36, 27, 4), (40, 30, 5), (44, 33, 6), (48, 36, 7), (52, 39, 8), (56, 42, 9), (59, 44, 10), (63, 47, 11), (67, 50, 12), (71, 53, 13), (75, 56, 14), (79, 59, 15), (83, 62, 16), (87, 65, 17), (91, 68, 18), (95, 71, 19), (99, 74, 20), (102, 76, 21), (106, 79, 22), (110, 82, 23), (114, 85, 24), (118, 88, 25), (122, 91, 26), (126, 94, 27), (130, 97, 28), (134, 100, 29), (138, 103, 30), (142, 106, 31), (145, 108, 32), (149, 111, 33), (153, 114, 34), (157, 117, 35), (161, 120, 36), (165, 123, 37), (169, 126, 38), (173, 129, 39), (177, 132, 40), (181, 135, 41), (184, 137, 42), (188, 140, 43), (192, 143, 44), (196, 146, 45), (200, 149, 46), (204, 152, 47), (208, 155, 48), (212, 158, 49), (216, 161, 50), (220, 164, 51), (224, 167, 52), (227, 169, 53), (231, 172, 54)];
        const ROT: [u64;55] = [59, 53, 47, 41, 35, 29, 23, 17, 11, 5, 63, 57, 51, 45, 39, 33, 27, 21, 15, 9, 3, 61, 55, 49, 43, 37, 31, 25, 19, 13, 7, 1, 59, 53, 47, 41, 35, 29, 23, 17, 11, 5, 63, 57, 51, 45, 39, 33, 27, 21, 15, 9, 3, 61, 55];
        const MASK: [u64;55] = [576460752303423487, 9007199254740991, 140737488355327, 2199023255551, 34359738367, 536870911, 8388607, 131071, 2047, 31, 9223372036854775807, 144115188075855871, 2251799813685247, 35184372088831, 549755813887, 8589934591, 134217727, 2097151, 32767, 511, 7, 2305843009213693951, 36028797018963967, 562949953421311, 8796093022207, 137438953471, 2147483647, 33554431, 524287, 8191, 127, 1, 576460752303423487, 9007199254740991, 140737488355327, 2199023255551, 34359738367, 536870911, 8388607, 131071, 2047, 31, 9223372036854775807, 144115188075855871, 2251799813685247, 35184372088831, 549755813887, 8589934591, 134217727, 2097151, 32767, 511, 7, 2305843009213693951, 36028797018963967];
        plan.full.len() == FULL.len() && plan.pairs.len() == PAIRS.len()
            && plan.rot.len() == ROT.len() && plan.mask.len() == MASK.len()
            && plan.full.iter().zip(FULL).all(|(p,(q,cg))| (p.q,p.cg)==(q,cg))
            && plan.pairs.iter().zip(PAIRS).all(|(p,(q,cg,g))| (p.q,p.cg,p.g)==(q,cg,g))
            && plan.rot.iter().zip(ROT).all(|(p,v)| p.0 == [v;8])
            && plan.mask.iter().zip(MASK).all(|(p,v)| p.0 == [v;8])
    }

#[inline(never)]
unsafe fn fused_stage_fold_prefetched(tile:*const u8,o:usize,x:usize,scratch:&Scratch,w:&Weights,pf:&mut PfCur)->[[__m512i;2];2]{unsafe{
const PREFETCH:bool=true;
let src=tile.add(o*64);let idxq=_mm512_setr_epi32(0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15);
macro_rules! q64{($cg:expr)=>{_mm512_permutexvar_epi32(idxq,_mm512_load_si512(src.add($cg*GROUP_BYTES).cast::<__m512i>()))};}
let dep=scratch.deps[x].as_ptr();let ol=&scratch.out_lo[x];let oh=&scratch.out_hi[x];
let next=pf.cur;pf.phase(PF_FILL+PF_FOLD,121);if PREFETCH{assert!(pf.lim-next==162*64);}else{assert_eq!(pf.cur,pf.end);}let mut out=[[_mm512_setzero_si512();2];2];
let z=_mm512_setzero_si512();let(mut le,mut lo,mut he,mut ho,mut me,mut mo)=(z,z,z,z,z,z);
let q0=q64!(0);
let q1=q64!(1);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+0) as *const i8);}
let w0=w.lohi[0];let s0=w.sum[0];let x0=_mm512_xor_si512(q0,q1);
let q2=q64!(2);
let q3=q64!(3);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+64) as *const i8);}
let w2=w.lohi[1];let s2=w.sum[1];let x2=_mm512_xor_si512(q2,q3);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q0,w0),_mm512_clmulepi64_epi128::<0x00>(q2,w2));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q0,w0),_mm512_clmulepi64_epi128::<0x01>(q2,w2));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q1,w0),_mm512_clmulepi64_epi128::<0x10>(q3,w2));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q1,w0),_mm512_clmulepi64_epi128::<0x11>(q3,w2));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x0,s0),_mm512_clmulepi64_epi128::<0x00>(x2,s2));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x0,s0),_mm512_clmulepi64_epi128::<0x01>(x2,s2));
let q4=ol[0];
let q5=ol[1];
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+128) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+192) as *const i8);}
let w4=w.lohi[2];let s4=w.sum[2];let x4=_mm512_xor_si512(q4,q5);
let q6=ol[2];
let q7=ol[3];
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+256) as *const i8);}
let w6=w.lohi[3];let s6=w.sum[3];let x6=_mm512_xor_si512(q6,q7);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q4,w4),_mm512_clmulepi64_epi128::<0x00>(q6,w6));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q4,w4),_mm512_clmulepi64_epi128::<0x01>(q6,w6));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q5,w4),_mm512_clmulepi64_epi128::<0x10>(q7,w6));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q5,w4),_mm512_clmulepi64_epi128::<0x11>(q7,w6));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x4,s4),_mm512_clmulepi64_epi128::<0x00>(x6,s6));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x4,s4),_mm512_clmulepi64_epi128::<0x01>(x6,s6));
let q8=q64!(4);
let q9=q64!(5);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+320) as *const i8);}
let w8=w.lohi[4];let s8=w.sum[4];let x8=_mm512_xor_si512(q8,q9);
let q10=q64!(6);
let q11=q64!(7);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+384) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+448) as *const i8);}
let w10=w.lohi[5];let s10=w.sum[5];let x10=_mm512_xor_si512(q10,q11);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q8,w8),_mm512_clmulepi64_epi128::<0x00>(q10,w10));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q8,w8),_mm512_clmulepi64_epi128::<0x01>(q10,w10));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q9,w8),_mm512_clmulepi64_epi128::<0x10>(q11,w10));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q9,w8),_mm512_clmulepi64_epi128::<0x11>(q11,w10));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x8,s8),_mm512_clmulepi64_epi128::<0x00>(x10,s10));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x8,s8),_mm512_clmulepi64_epi128::<0x01>(x10,s10));
let q12=q64!(8);
let q13=q64!(9);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+512) as *const i8);}
let w12=w.lohi[6];let s12=w.sum[6];let x12=_mm512_xor_si512(q12,q13);
let q14=q64!(10);
let q15=q64!(11);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+576) as *const i8);}
let w14=w.lohi[7];let s14=w.sum[7];let x14=_mm512_xor_si512(q14,q15);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q12,w12),_mm512_clmulepi64_epi128::<0x00>(q14,w14));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q12,w12),_mm512_clmulepi64_epi128::<0x01>(q14,w14));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q13,w12),_mm512_clmulepi64_epi128::<0x10>(q15,w14));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q13,w12),_mm512_clmulepi64_epi128::<0x11>(q15,w14));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x12,s12),_mm512_clmulepi64_epi128::<0x00>(x14,s14));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x12,s12),_mm512_clmulepi64_epi128::<0x01>(x14,s14));
let q16=q64!(12);
let q17=_mm512_ternarylogic_epi64::<0xEA>(q64!(13),_mm512_set1_epi64(1),_mm512_set1_epi64(Q17_CONST as i64));
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+640) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+704) as *const i8);}
let w16=w.lohi[8];let s16=w.sum[8];let x16=_mm512_xor_si512(q16,q17);
let q18=_mm512_andnot_si512(_mm512_set1_epi64(1),q64!(13));
let q19=q64!(14);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+768) as *const i8);}
let w18=w.lohi[9];let s18=w.sum[9];let x18=_mm512_xor_si512(q18,q19);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q16,w16),_mm512_clmulepi64_epi128::<0x00>(q18,w18));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q16,w16),_mm512_clmulepi64_epi128::<0x01>(q18,w18));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q17,w16),_mm512_clmulepi64_epi128::<0x10>(q19,w18));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q17,w16),_mm512_clmulepi64_epi128::<0x11>(q19,w18));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x16,s16),_mm512_clmulepi64_epi128::<0x00>(x18,s18));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x16,s16),_mm512_clmulepi64_epi128::<0x01>(x18,s18));
let g0=q64!(15);let r0=_mm512_rol_epi64::<59>(*dep.add(0));let m0=_mm512_set1_epi64(576460752303423487u64 as i64);
let q20=_mm512_ternarylogic_epi64::<0xCA>(m0,g0,r0);let q21=_mm512_ternarylogic_epi64::<0xCA>(m0,r0,g0);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+832) as *const i8);}
let w20=w.lohi[10];let s20=w.sum[10];let x20=_mm512_xor_si512(q20,q21);
let q22=q64!(16);
let q23=q64!(17);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+896) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+960) as *const i8);}
let w22=w.lohi[11];let s22=w.sum[11];let x22=_mm512_xor_si512(q22,q23);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q20,w20),_mm512_clmulepi64_epi128::<0x00>(q22,w22));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q20,w20),_mm512_clmulepi64_epi128::<0x01>(q22,w22));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q21,w20),_mm512_clmulepi64_epi128::<0x10>(q23,w22));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q21,w20),_mm512_clmulepi64_epi128::<0x11>(q23,w22));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x20,s20),_mm512_clmulepi64_epi128::<0x00>(x22,s22));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x20,s20),_mm512_clmulepi64_epi128::<0x01>(x22,s22));
let g1=q64!(18);let r1=_mm512_rol_epi64::<53>(*dep.add(1));let m1=_mm512_set1_epi64(9007199254740991u64 as i64);
let q24=_mm512_ternarylogic_epi64::<0xCA>(m1,g1,r1);let q25=_mm512_ternarylogic_epi64::<0xCA>(m1,r1,g1);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1024) as *const i8);}
let w24=w.lohi[12];let s24=w.sum[12];let x24=_mm512_xor_si512(q24,q25);
let q26=q64!(19);
let q27=q64!(20);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1088) as *const i8);}
let w26=w.lohi[13];let s26=w.sum[13];let x26=_mm512_xor_si512(q26,q27);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q24,w24),_mm512_clmulepi64_epi128::<0x00>(q26,w26));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q24,w24),_mm512_clmulepi64_epi128::<0x01>(q26,w26));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q25,w24),_mm512_clmulepi64_epi128::<0x10>(q27,w26));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q25,w24),_mm512_clmulepi64_epi128::<0x11>(q27,w26));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x24,s24),_mm512_clmulepi64_epi128::<0x00>(x26,s26));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x24,s24),_mm512_clmulepi64_epi128::<0x01>(x26,s26));
let g2=q64!(21);let r2=_mm512_rol_epi64::<47>(*dep.add(2));let m2=_mm512_set1_epi64(140737488355327u64 as i64);
let q28=_mm512_ternarylogic_epi64::<0xCA>(m2,g2,r2);let q29=_mm512_ternarylogic_epi64::<0xCA>(m2,r2,g2);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1152) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1216) as *const i8);}
let w28=w.lohi[14];let s28=w.sum[14];let x28=_mm512_xor_si512(q28,q29);
let q30=q64!(22);
let q31=q64!(23);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1280) as *const i8);}
let w30=w.lohi[15];let s30=w.sum[15];let x30=_mm512_xor_si512(q30,q31);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q28,w28),_mm512_clmulepi64_epi128::<0x00>(q30,w30));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q28,w28),_mm512_clmulepi64_epi128::<0x01>(q30,w30));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q29,w28),_mm512_clmulepi64_epi128::<0x10>(q31,w30));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q29,w28),_mm512_clmulepi64_epi128::<0x11>(q31,w30));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x28,s28),_mm512_clmulepi64_epi128::<0x00>(x30,s30));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x28,s28),_mm512_clmulepi64_epi128::<0x01>(x30,s30));
let g3=q64!(24);let r3=_mm512_rol_epi64::<41>(*dep.add(3));let m3=_mm512_set1_epi64(2199023255551u64 as i64);
let q32=_mm512_ternarylogic_epi64::<0xCA>(m3,g3,r3);let q33=_mm512_ternarylogic_epi64::<0xCA>(m3,r3,g3);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1344) as *const i8);}
let w32=w.lohi[16];let s32=w.sum[16];let x32=_mm512_xor_si512(q32,q33);
let q34=q64!(25);
let q35=q64!(26);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1408) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1472) as *const i8);}
let w34=w.lohi[17];let s34=w.sum[17];let x34=_mm512_xor_si512(q34,q35);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q32,w32),_mm512_clmulepi64_epi128::<0x00>(q34,w34));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q32,w32),_mm512_clmulepi64_epi128::<0x01>(q34,w34));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q33,w32),_mm512_clmulepi64_epi128::<0x10>(q35,w34));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q33,w32),_mm512_clmulepi64_epi128::<0x11>(q35,w34));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x32,s32),_mm512_clmulepi64_epi128::<0x00>(x34,s34));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x32,s32),_mm512_clmulepi64_epi128::<0x01>(x34,s34));
let g4=q64!(27);let r4=_mm512_rol_epi64::<35>(*dep.add(4));let m4=_mm512_set1_epi64(34359738367u64 as i64);
let q36=_mm512_ternarylogic_epi64::<0xCA>(m4,g4,r4);let q37=_mm512_ternarylogic_epi64::<0xCA>(m4,r4,g4);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1536) as *const i8);}
let w36=w.lohi[18];let s36=w.sum[18];let x36=_mm512_xor_si512(q36,q37);
let q38=q64!(28);
let q39=q64!(29);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1600) as *const i8);}
let w38=w.lohi[19];let s38=w.sum[19];let x38=_mm512_xor_si512(q38,q39);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q36,w36),_mm512_clmulepi64_epi128::<0x00>(q38,w38));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q36,w36),_mm512_clmulepi64_epi128::<0x01>(q38,w38));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q37,w36),_mm512_clmulepi64_epi128::<0x10>(q39,w38));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q37,w36),_mm512_clmulepi64_epi128::<0x11>(q39,w38));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x36,s36),_mm512_clmulepi64_epi128::<0x00>(x38,s38));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x36,s36),_mm512_clmulepi64_epi128::<0x01>(x38,s38));
let g5=q64!(30);let r5=_mm512_rol_epi64::<29>(*dep.add(5));let m5=_mm512_set1_epi64(536870911u64 as i64);
let q40=_mm512_ternarylogic_epi64::<0xCA>(m5,g5,r5);let q41=_mm512_ternarylogic_epi64::<0xCA>(m5,r5,g5);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1664) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1728) as *const i8);}
let w40=w.lohi[20];let s40=w.sum[20];let x40=_mm512_xor_si512(q40,q41);
let q42=q64!(31);
let q43=q64!(32);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1792) as *const i8);}
let w42=w.lohi[21];let s42=w.sum[21];let x42=_mm512_xor_si512(q42,q43);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q40,w40),_mm512_clmulepi64_epi128::<0x00>(q42,w42));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q40,w40),_mm512_clmulepi64_epi128::<0x01>(q42,w42));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q41,w40),_mm512_clmulepi64_epi128::<0x10>(q43,w42));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q41,w40),_mm512_clmulepi64_epi128::<0x11>(q43,w42));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x40,s40),_mm512_clmulepi64_epi128::<0x00>(x42,s42));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x40,s40),_mm512_clmulepi64_epi128::<0x01>(x42,s42));
let g6=q64!(33);let r6=_mm512_rol_epi64::<23>(*dep.add(6));let m6=_mm512_set1_epi64(8388607u64 as i64);
let q44=_mm512_ternarylogic_epi64::<0xCA>(m6,g6,r6);let q45=_mm512_ternarylogic_epi64::<0xCA>(m6,r6,g6);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1856) as *const i8);}
let w44=w.lohi[22];let s44=w.sum[22];let x44=_mm512_xor_si512(q44,q45);
let q46=q64!(34);
let q47=q64!(35);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1920) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+1984) as *const i8);}
let w46=w.lohi[23];let s46=w.sum[23];let x46=_mm512_xor_si512(q46,q47);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q44,w44),_mm512_clmulepi64_epi128::<0x00>(q46,w46));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q44,w44),_mm512_clmulepi64_epi128::<0x01>(q46,w46));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q45,w44),_mm512_clmulepi64_epi128::<0x10>(q47,w46));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q45,w44),_mm512_clmulepi64_epi128::<0x11>(q47,w46));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x44,s44),_mm512_clmulepi64_epi128::<0x00>(x46,s46));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x44,s44),_mm512_clmulepi64_epi128::<0x01>(x46,s46));
let g7=q64!(36);let r7=_mm512_rol_epi64::<17>(*dep.add(7));let m7=_mm512_set1_epi64(131071u64 as i64);
let q48=_mm512_ternarylogic_epi64::<0xCA>(m7,g7,r7);let q49=_mm512_ternarylogic_epi64::<0xCA>(m7,r7,g7);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2048) as *const i8);}
let w48=w.lohi[24];let s48=w.sum[24];let x48=_mm512_xor_si512(q48,q49);
let q50=q64!(37);
let q51=q64!(38);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2112) as *const i8);}
let w50=w.lohi[25];let s50=w.sum[25];let x50=_mm512_xor_si512(q50,q51);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q48,w48),_mm512_clmulepi64_epi128::<0x00>(q50,w50));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q48,w48),_mm512_clmulepi64_epi128::<0x01>(q50,w50));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q49,w48),_mm512_clmulepi64_epi128::<0x10>(q51,w50));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q49,w48),_mm512_clmulepi64_epi128::<0x11>(q51,w50));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x48,s48),_mm512_clmulepi64_epi128::<0x00>(x50,s50));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x48,s48),_mm512_clmulepi64_epi128::<0x01>(x50,s50));
let g8=q64!(39);let r8=_mm512_rol_epi64::<11>(*dep.add(8));let m8=_mm512_set1_epi64(2047u64 as i64);
let q52=_mm512_ternarylogic_epi64::<0xCA>(m8,g8,r8);let q53=_mm512_ternarylogic_epi64::<0xCA>(m8,r8,g8);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2176) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2240) as *const i8);}
let w52=w.lohi[26];let s52=w.sum[26];let x52=_mm512_xor_si512(q52,q53);
let q54=q64!(40);
let q55=q64!(41);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2304) as *const i8);}
let w54=w.lohi[27];let s54=w.sum[27];let x54=_mm512_xor_si512(q54,q55);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q52,w52),_mm512_clmulepi64_epi128::<0x00>(q54,w54));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q52,w52),_mm512_clmulepi64_epi128::<0x01>(q54,w54));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q53,w52),_mm512_clmulepi64_epi128::<0x10>(q55,w54));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q53,w52),_mm512_clmulepi64_epi128::<0x11>(q55,w54));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x52,s52),_mm512_clmulepi64_epi128::<0x00>(x54,s54));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x52,s52),_mm512_clmulepi64_epi128::<0x01>(x54,s54));
let g9=q64!(42);let r9=_mm512_rol_epi64::<5>(*dep.add(9));let m9=_mm512_set1_epi64(31u64 as i64);
let q56=_mm512_ternarylogic_epi64::<0xCA>(m9,g9,r9);let q57=_mm512_ternarylogic_epi64::<0xCA>(m9,r9,g9);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2368) as *const i8);}
let w56=w.lohi[28];let s56=w.sum[28];let x56=_mm512_xor_si512(q56,q57);
let q58=q64!(43);
let g10=q64!(44);let r10=_mm512_rol_epi64::<63>(*dep.add(10));let m10=_mm512_set1_epi64(9223372036854775807u64 as i64);
let q59=_mm512_ternarylogic_epi64::<0xCA>(m10,g10,r10);let q60=_mm512_ternarylogic_epi64::<0xCA>(m10,r10,g10);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2432) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2496) as *const i8);}
let w58=w.lohi[29];let s58=w.sum[29];let x58=_mm512_xor_si512(q58,q59);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q56,w56),_mm512_clmulepi64_epi128::<0x00>(q58,w58));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q56,w56),_mm512_clmulepi64_epi128::<0x01>(q58,w58));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q57,w56),_mm512_clmulepi64_epi128::<0x10>(q59,w58));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q57,w56),_mm512_clmulepi64_epi128::<0x11>(q59,w58));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x56,s56),_mm512_clmulepi64_epi128::<0x00>(x58,s58));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x56,s56),_mm512_clmulepi64_epi128::<0x01>(x58,s58));
let q61=q64!(45);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2560) as *const i8);}
let w60=w.lohi[30];let s60=w.sum[30];let x60=_mm512_xor_si512(q60,q61);
let q62=q64!(46);
let g11=q64!(47);let r11=_mm512_rol_epi64::<57>(*dep.add(11));let m11=_mm512_set1_epi64(144115188075855871u64 as i64);
let q63=_mm512_ternarylogic_epi64::<0xCA>(m11,g11,r11);let q64=_mm512_ternarylogic_epi64::<0xCA>(m11,r11,g11);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2624) as *const i8);}
let w62=w.lohi[31];let s62=w.sum[31];let x62=_mm512_xor_si512(q62,q63);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q60,w60),_mm512_clmulepi64_epi128::<0x00>(q62,w62));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q60,w60),_mm512_clmulepi64_epi128::<0x01>(q62,w62));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q61,w60),_mm512_clmulepi64_epi128::<0x10>(q63,w62));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q61,w60),_mm512_clmulepi64_epi128::<0x11>(q63,w62));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x60,s60),_mm512_clmulepi64_epi128::<0x00>(x62,s62));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x60,s60),_mm512_clmulepi64_epi128::<0x01>(x62,s62));
let q65=q64!(48);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2688) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2752) as *const i8);}
let w64=w.lohi[32];let s64=w.sum[32];let x64=_mm512_xor_si512(q64,q65);
let q66=q64!(49);
let g12=q64!(50);let r12=_mm512_rol_epi64::<51>(*dep.add(12));let m12=_mm512_set1_epi64(2251799813685247u64 as i64);
let q67=_mm512_ternarylogic_epi64::<0xCA>(m12,g12,r12);let q68=_mm512_ternarylogic_epi64::<0xCA>(m12,r12,g12);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2816) as *const i8);}
let w66=w.lohi[33];let s66=w.sum[33];let x66=_mm512_xor_si512(q66,q67);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q64,w64),_mm512_clmulepi64_epi128::<0x00>(q66,w66));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q64,w64),_mm512_clmulepi64_epi128::<0x01>(q66,w66));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q65,w64),_mm512_clmulepi64_epi128::<0x10>(q67,w66));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q65,w64),_mm512_clmulepi64_epi128::<0x11>(q67,w66));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x64,s64),_mm512_clmulepi64_epi128::<0x00>(x66,s66));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x64,s64),_mm512_clmulepi64_epi128::<0x01>(x66,s66));
let q69=q64!(51);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2880) as *const i8);}
let w68=w.lohi[34];let s68=w.sum[34];let x68=_mm512_xor_si512(q68,q69);
let q70=q64!(52);
let g13=q64!(53);let r13=_mm512_rol_epi64::<45>(*dep.add(13));let m13=_mm512_set1_epi64(35184372088831u64 as i64);
let q71=_mm512_ternarylogic_epi64::<0xCA>(m13,g13,r13);let q72=_mm512_ternarylogic_epi64::<0xCA>(m13,r13,g13);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+2944) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3008) as *const i8);}
let w70=w.lohi[35];let s70=w.sum[35];let x70=_mm512_xor_si512(q70,q71);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q68,w68),_mm512_clmulepi64_epi128::<0x00>(q70,w70));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q68,w68),_mm512_clmulepi64_epi128::<0x01>(q70,w70));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q69,w68),_mm512_clmulepi64_epi128::<0x10>(q71,w70));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q69,w68),_mm512_clmulepi64_epi128::<0x11>(q71,w70));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x68,s68),_mm512_clmulepi64_epi128::<0x00>(x70,s70));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x68,s68),_mm512_clmulepi64_epi128::<0x01>(x70,s70));
let q73=q64!(54);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3072) as *const i8);}
let w72=w.lohi[36];let s72=w.sum[36];let x72=_mm512_xor_si512(q72,q73);
let q74=q64!(55);
let g14=q64!(56);let r14=_mm512_rol_epi64::<39>(*dep.add(14));let m14=_mm512_set1_epi64(549755813887u64 as i64);
let q75=_mm512_ternarylogic_epi64::<0xCA>(m14,g14,r14);let q76=_mm512_ternarylogic_epi64::<0xCA>(m14,r14,g14);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3136) as *const i8);}
let w74=w.lohi[37];let s74=w.sum[37];let x74=_mm512_xor_si512(q74,q75);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q72,w72),_mm512_clmulepi64_epi128::<0x00>(q74,w74));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q72,w72),_mm512_clmulepi64_epi128::<0x01>(q74,w74));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q73,w72),_mm512_clmulepi64_epi128::<0x10>(q75,w74));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q73,w72),_mm512_clmulepi64_epi128::<0x11>(q75,w74));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x72,s72),_mm512_clmulepi64_epi128::<0x00>(x74,s74));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x72,s72),_mm512_clmulepi64_epi128::<0x01>(x74,s74));
let q77=q64!(57);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3200) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3264) as *const i8);}
let w76=w.lohi[38];let s76=w.sum[38];let x76=_mm512_xor_si512(q76,q77);
let q78=q64!(58);
let g15=q64!(59);let r15=_mm512_rol_epi64::<33>(*dep.add(15));let m15=_mm512_set1_epi64(8589934591u64 as i64);
let q79=_mm512_ternarylogic_epi64::<0xCA>(m15,g15,r15);let q80=_mm512_ternarylogic_epi64::<0xCA>(m15,r15,g15);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3328) as *const i8);}
let w78=w.lohi[39];let s78=w.sum[39];let x78=_mm512_xor_si512(q78,q79);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q76,w76),_mm512_clmulepi64_epi128::<0x00>(q78,w78));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q76,w76),_mm512_clmulepi64_epi128::<0x01>(q78,w78));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q77,w76),_mm512_clmulepi64_epi128::<0x10>(q79,w78));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q77,w76),_mm512_clmulepi64_epi128::<0x11>(q79,w78));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x76,s76),_mm512_clmulepi64_epi128::<0x00>(x78,s78));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x76,s76),_mm512_clmulepi64_epi128::<0x01>(x78,s78));
let q81=q64!(60);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3392) as *const i8);}
let w80=w.lohi[40];let s80=w.sum[40];let x80=_mm512_xor_si512(q80,q81);
let q82=q64!(61);
let g16=q64!(62);let r16=_mm512_rol_epi64::<27>(*dep.add(16));let m16=_mm512_set1_epi64(134217727u64 as i64);
let q83=_mm512_ternarylogic_epi64::<0xCA>(m16,g16,r16);let q84=_mm512_ternarylogic_epi64::<0xCA>(m16,r16,g16);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3456) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3520) as *const i8);}
let w82=w.lohi[41];let s82=w.sum[41];let x82=_mm512_xor_si512(q82,q83);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q80,w80),_mm512_clmulepi64_epi128::<0x00>(q82,w82));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q80,w80),_mm512_clmulepi64_epi128::<0x01>(q82,w82));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q81,w80),_mm512_clmulepi64_epi128::<0x10>(q83,w82));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q81,w80),_mm512_clmulepi64_epi128::<0x11>(q83,w82));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x80,s80),_mm512_clmulepi64_epi128::<0x00>(x82,s82));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x80,s80),_mm512_clmulepi64_epi128::<0x01>(x82,s82));
let q85=q64!(63);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3584) as *const i8);}
let w84=w.lohi[42];let s84=w.sum[42];let x84=_mm512_xor_si512(q84,q85);
let q86=q64!(64);
let g17=q64!(65);let r17=_mm512_rol_epi64::<21>(*dep.add(17));let m17=_mm512_set1_epi64(2097151u64 as i64);
let q87=_mm512_ternarylogic_epi64::<0xCA>(m17,g17,r17);let q88=_mm512_ternarylogic_epi64::<0xCA>(m17,r17,g17);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3648) as *const i8);}
let w86=w.lohi[43];let s86=w.sum[43];let x86=_mm512_xor_si512(q86,q87);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q84,w84),_mm512_clmulepi64_epi128::<0x00>(q86,w86));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q84,w84),_mm512_clmulepi64_epi128::<0x01>(q86,w86));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q85,w84),_mm512_clmulepi64_epi128::<0x10>(q87,w86));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q85,w84),_mm512_clmulepi64_epi128::<0x11>(q87,w86));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x84,s84),_mm512_clmulepi64_epi128::<0x00>(x86,s86));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x84,s84),_mm512_clmulepi64_epi128::<0x01>(x86,s86));
let q89=q64!(66);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3712) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3776) as *const i8);}
let w88=w.lohi[44];let s88=w.sum[44];let x88=_mm512_xor_si512(q88,q89);
let q90=q64!(67);
let g18=q64!(68);let r18=_mm512_rol_epi64::<15>(*dep.add(18));let m18=_mm512_set1_epi64(32767u64 as i64);
let q91=_mm512_ternarylogic_epi64::<0xCA>(m18,g18,r18);let q92=_mm512_ternarylogic_epi64::<0xCA>(m18,r18,g18);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3840) as *const i8);}
let w90=w.lohi[45];let s90=w.sum[45];let x90=_mm512_xor_si512(q90,q91);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q88,w88),_mm512_clmulepi64_epi128::<0x00>(q90,w90));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q88,w88),_mm512_clmulepi64_epi128::<0x01>(q90,w90));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q89,w88),_mm512_clmulepi64_epi128::<0x10>(q91,w90));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q89,w88),_mm512_clmulepi64_epi128::<0x11>(q91,w90));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x88,s88),_mm512_clmulepi64_epi128::<0x00>(x90,s90));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x88,s88),_mm512_clmulepi64_epi128::<0x01>(x90,s90));
let q93=q64!(69);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3904) as *const i8);}
let w92=w.lohi[46];let s92=w.sum[46];let x92=_mm512_xor_si512(q92,q93);
let q94=q64!(70);
let g19=q64!(71);let r19=_mm512_rol_epi64::<9>(*dep.add(19));let m19=_mm512_set1_epi64(511u64 as i64);
let q95=_mm512_ternarylogic_epi64::<0xCA>(m19,g19,r19);let q96=_mm512_ternarylogic_epi64::<0xCA>(m19,r19,g19);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+3968) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4032) as *const i8);}
let w94=w.lohi[47];let s94=w.sum[47];let x94=_mm512_xor_si512(q94,q95);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q92,w92),_mm512_clmulepi64_epi128::<0x00>(q94,w94));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q92,w92),_mm512_clmulepi64_epi128::<0x01>(q94,w94));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q93,w92),_mm512_clmulepi64_epi128::<0x10>(q95,w94));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q93,w92),_mm512_clmulepi64_epi128::<0x11>(q95,w94));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x92,s92),_mm512_clmulepi64_epi128::<0x00>(x94,s94));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x92,s92),_mm512_clmulepi64_epi128::<0x01>(x94,s94));
let q97=q64!(72);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4096) as *const i8);}
let w96=w.lohi[48];let s96=w.sum[48];let x96=_mm512_xor_si512(q96,q97);
let q98=q64!(73);
let g20=q64!(74);let r20=_mm512_rol_epi64::<3>(*dep.add(20));let m20=_mm512_set1_epi64(7u64 as i64);
let q99=_mm512_ternarylogic_epi64::<0xCA>(m20,g20,r20);let q100=_mm512_ternarylogic_epi64::<0xCA>(m20,r20,g20);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4160) as *const i8);}
let w98=w.lohi[49];let s98=w.sum[49];let x98=_mm512_xor_si512(q98,q99);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q96,w96),_mm512_clmulepi64_epi128::<0x00>(q98,w98));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q96,w96),_mm512_clmulepi64_epi128::<0x01>(q98,w98));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q97,w96),_mm512_clmulepi64_epi128::<0x10>(q99,w98));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q97,w96),_mm512_clmulepi64_epi128::<0x11>(q99,w98));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x96,s96),_mm512_clmulepi64_epi128::<0x00>(x98,s98));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x96,s96),_mm512_clmulepi64_epi128::<0x01>(x98,s98));
let q101=q64!(75);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4224) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4288) as *const i8);}
let w100=w.lohi[50];let s100=w.sum[50];let x100=_mm512_xor_si512(q100,q101);
let g21=q64!(76);let r21=_mm512_rol_epi64::<61>(*dep.add(21));let m21=_mm512_set1_epi64(2305843009213693951u64 as i64);
let q102=_mm512_ternarylogic_epi64::<0xCA>(m21,g21,r21);let q103=_mm512_ternarylogic_epi64::<0xCA>(m21,r21,g21);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4352) as *const i8);}
let w102=w.lohi[51];let s102=w.sum[51];let x102=_mm512_xor_si512(q102,q103);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q100,w100),_mm512_clmulepi64_epi128::<0x00>(q102,w102));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q100,w100),_mm512_clmulepi64_epi128::<0x01>(q102,w102));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q101,w100),_mm512_clmulepi64_epi128::<0x10>(q103,w102));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q101,w100),_mm512_clmulepi64_epi128::<0x11>(q103,w102));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x100,s100),_mm512_clmulepi64_epi128::<0x00>(x102,s102));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x100,s100),_mm512_clmulepi64_epi128::<0x01>(x102,s102));
let q104=q64!(77);
let q105=q64!(78);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4416) as *const i8);}
let w104=w.lohi[52];let s104=w.sum[52];let x104=_mm512_xor_si512(q104,q105);
let g22=q64!(79);let r22=_mm512_rol_epi64::<55>(*dep.add(22));let m22=_mm512_set1_epi64(36028797018963967u64 as i64);
let q106=_mm512_ternarylogic_epi64::<0xCA>(m22,g22,r22);let q107=_mm512_ternarylogic_epi64::<0xCA>(m22,r22,g22);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4480) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4544) as *const i8);}
let w106=w.lohi[53];let s106=w.sum[53];let x106=_mm512_xor_si512(q106,q107);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q104,w104),_mm512_clmulepi64_epi128::<0x00>(q106,w106));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q104,w104),_mm512_clmulepi64_epi128::<0x01>(q106,w106));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q105,w104),_mm512_clmulepi64_epi128::<0x10>(q107,w106));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q105,w104),_mm512_clmulepi64_epi128::<0x11>(q107,w106));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x104,s104),_mm512_clmulepi64_epi128::<0x00>(x106,s106));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x104,s104),_mm512_clmulepi64_epi128::<0x01>(x106,s106));
let q108=q64!(80);
let q109=q64!(81);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4608) as *const i8);}
let w108=w.lohi[54];let s108=w.sum[54];let x108=_mm512_xor_si512(q108,q109);
let g23=q64!(82);let r23=_mm512_rol_epi64::<49>(*dep.add(23));let m23=_mm512_set1_epi64(562949953421311u64 as i64);
let q110=_mm512_ternarylogic_epi64::<0xCA>(m23,g23,r23);let q111=_mm512_ternarylogic_epi64::<0xCA>(m23,r23,g23);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4672) as *const i8);}
let w110=w.lohi[55];let s110=w.sum[55];let x110=_mm512_xor_si512(q110,q111);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q108,w108),_mm512_clmulepi64_epi128::<0x00>(q110,w110));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q108,w108),_mm512_clmulepi64_epi128::<0x01>(q110,w110));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q109,w108),_mm512_clmulepi64_epi128::<0x10>(q111,w110));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q109,w108),_mm512_clmulepi64_epi128::<0x11>(q111,w110));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x108,s108),_mm512_clmulepi64_epi128::<0x00>(x110,s110));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x108,s108),_mm512_clmulepi64_epi128::<0x01>(x110,s110));
let q112=q64!(83);
let q113=q64!(84);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4736) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4800) as *const i8);}
let w112=w.lohi[56];let s112=w.sum[56];let x112=_mm512_xor_si512(q112,q113);
let g24=q64!(85);let r24=_mm512_rol_epi64::<43>(*dep.add(24));let m24=_mm512_set1_epi64(8796093022207u64 as i64);
let q114=_mm512_ternarylogic_epi64::<0xCA>(m24,g24,r24);let q115=_mm512_ternarylogic_epi64::<0xCA>(m24,r24,g24);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4864) as *const i8);}
let w114=w.lohi[57];let s114=w.sum[57];let x114=_mm512_xor_si512(q114,q115);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q112,w112),_mm512_clmulepi64_epi128::<0x00>(q114,w114));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q112,w112),_mm512_clmulepi64_epi128::<0x01>(q114,w114));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q113,w112),_mm512_clmulepi64_epi128::<0x10>(q115,w114));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q113,w112),_mm512_clmulepi64_epi128::<0x11>(q115,w114));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x112,s112),_mm512_clmulepi64_epi128::<0x00>(x114,s114));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x112,s112),_mm512_clmulepi64_epi128::<0x01>(x114,s114));
let q116=q64!(86);
let q117=q64!(87);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4928) as *const i8);}
let w116=w.lohi[58];let s116=w.sum[58];let x116=_mm512_xor_si512(q116,q117);
let g25=q64!(88);let r25=_mm512_rol_epi64::<37>(*dep.add(25));let m25=_mm512_set1_epi64(137438953471u64 as i64);
let q118=_mm512_ternarylogic_epi64::<0xCA>(m25,g25,r25);let q119=_mm512_ternarylogic_epi64::<0xCA>(m25,r25,g25);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+4992) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5056) as *const i8);}
let w118=w.lohi[59];let s118=w.sum[59];let x118=_mm512_xor_si512(q118,q119);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q116,w116),_mm512_clmulepi64_epi128::<0x00>(q118,w118));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q116,w116),_mm512_clmulepi64_epi128::<0x01>(q118,w118));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q117,w116),_mm512_clmulepi64_epi128::<0x10>(q119,w118));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q117,w116),_mm512_clmulepi64_epi128::<0x11>(q119,w118));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x116,s116),_mm512_clmulepi64_epi128::<0x00>(x118,s118));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x116,s116),_mm512_clmulepi64_epi128::<0x01>(x118,s118));
let q120=q64!(89);
let q121=q64!(90);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5120) as *const i8);}
let w120=w.lohi[60];let s120=w.sum[60];let x120=_mm512_xor_si512(q120,q121);
let g26=q64!(91);let r26=_mm512_rol_epi64::<31>(*dep.add(26));let m26=_mm512_set1_epi64(2147483647u64 as i64);
let q122=_mm512_ternarylogic_epi64::<0xCA>(m26,g26,r26);let q123=_mm512_ternarylogic_epi64::<0xCA>(m26,r26,g26);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5184) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5248) as *const i8);}
let w122=w.lohi[61];let s122=w.sum[61];let x122=_mm512_xor_si512(q122,q123);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q120,w120),_mm512_clmulepi64_epi128::<0x00>(q122,w122));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q120,w120),_mm512_clmulepi64_epi128::<0x01>(q122,w122));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q121,w120),_mm512_clmulepi64_epi128::<0x10>(q123,w122));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q121,w120),_mm512_clmulepi64_epi128::<0x11>(q123,w122));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x120,s120),_mm512_clmulepi64_epi128::<0x00>(x122,s122));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x120,s120),_mm512_clmulepi64_epi128::<0x01>(x122,s122));
let q124=q64!(92);
let q125=q64!(93);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5312) as *const i8);}
let w124=w.lohi[62];let s124=w.sum[62];let x124=_mm512_xor_si512(q124,q125);
let g27=q64!(94);let r27=_mm512_rol_epi64::<25>(*dep.add(27));let m27=_mm512_set1_epi64(33554431u64 as i64);
let q126=_mm512_ternarylogic_epi64::<0xCA>(m27,g27,r27);let q127=_mm512_ternarylogic_epi64::<0xCA>(m27,r27,g27);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5376) as *const i8);}
let w126=w.lohi[63];let s126=w.sum[63];let x126=_mm512_xor_si512(q126,q127);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q124,w124),_mm512_clmulepi64_epi128::<0x00>(q126,w126));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q124,w124),_mm512_clmulepi64_epi128::<0x01>(q126,w126));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q125,w124),_mm512_clmulepi64_epi128::<0x10>(q127,w126));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q125,w124),_mm512_clmulepi64_epi128::<0x11>(q127,w126));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x124,s124),_mm512_clmulepi64_epi128::<0x00>(x126,s126));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x124,s124),_mm512_clmulepi64_epi128::<0x01>(x126,s126));
let me=_mm512_ternarylogic_epi64::<0x96>(me,le,he);let mo=_mm512_ternarylogic_epi64::<0x96>(mo,lo,ho);out[0][0]=flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(le,me,he);out[0][1]=flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(lo,mo,ho);
let z=_mm512_setzero_si512();let(mut le,mut lo,mut he,mut ho,mut me,mut mo)=(z,z,z,z,z,z);
let q128=q64!(95);
let q129=q64!(96);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5440) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5504) as *const i8);}
let w128=w.lohi[0];let s128=w.sum[0];let x128=_mm512_xor_si512(q128,q129);
let g28=q64!(97);let r28=_mm512_rol_epi64::<19>(*dep.add(28));let m28=_mm512_set1_epi64(524287u64 as i64);
let q130=_mm512_ternarylogic_epi64::<0xCA>(m28,g28,r28);let q131=_mm512_ternarylogic_epi64::<0xCA>(m28,r28,g28);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5568) as *const i8);}
let w130=w.lohi[1];let s130=w.sum[1];let x130=_mm512_xor_si512(q130,q131);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q128,w128),_mm512_clmulepi64_epi128::<0x00>(q130,w130));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q128,w128),_mm512_clmulepi64_epi128::<0x01>(q130,w130));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q129,w128),_mm512_clmulepi64_epi128::<0x10>(q131,w130));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q129,w128),_mm512_clmulepi64_epi128::<0x11>(q131,w130));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x128,s128),_mm512_clmulepi64_epi128::<0x00>(x130,s130));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x128,s128),_mm512_clmulepi64_epi128::<0x01>(x130,s130));
let q132=q64!(98);
let q133=q64!(99);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5632) as *const i8);}
let w132=w.lohi[2];let s132=w.sum[2];let x132=_mm512_xor_si512(q132,q133);
let g29=q64!(100);let r29=_mm512_rol_epi64::<13>(*dep.add(29));let m29=_mm512_set1_epi64(8191u64 as i64);
let q134=_mm512_ternarylogic_epi64::<0xCA>(m29,g29,r29);let q135=_mm512_ternarylogic_epi64::<0xCA>(m29,r29,g29);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5696) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5760) as *const i8);}
let w134=w.lohi[3];let s134=w.sum[3];let x134=_mm512_xor_si512(q134,q135);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q132,w132),_mm512_clmulepi64_epi128::<0x00>(q134,w134));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q132,w132),_mm512_clmulepi64_epi128::<0x01>(q134,w134));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q133,w132),_mm512_clmulepi64_epi128::<0x10>(q135,w134));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q133,w132),_mm512_clmulepi64_epi128::<0x11>(q135,w134));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x132,s132),_mm512_clmulepi64_epi128::<0x00>(x134,s134));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x132,s132),_mm512_clmulepi64_epi128::<0x01>(x134,s134));
let q136=q64!(101);
let q137=q64!(102);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5824) as *const i8);}
let w136=w.lohi[4];let s136=w.sum[4];let x136=_mm512_xor_si512(q136,q137);
let g30=q64!(103);let r30=_mm512_rol_epi64::<7>(*dep.add(30));let m30=_mm512_set1_epi64(127u64 as i64);
let q138=_mm512_ternarylogic_epi64::<0xCA>(m30,g30,r30);let q139=_mm512_ternarylogic_epi64::<0xCA>(m30,r30,g30);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5888) as *const i8);}
let w138=w.lohi[5];let s138=w.sum[5];let x138=_mm512_xor_si512(q138,q139);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q136,w136),_mm512_clmulepi64_epi128::<0x00>(q138,w138));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q136,w136),_mm512_clmulepi64_epi128::<0x01>(q138,w138));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q137,w136),_mm512_clmulepi64_epi128::<0x10>(q139,w138));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q137,w136),_mm512_clmulepi64_epi128::<0x11>(q139,w138));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x136,s136),_mm512_clmulepi64_epi128::<0x00>(x138,s138));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x136,s136),_mm512_clmulepi64_epi128::<0x01>(x138,s138));
let q140=q64!(104);
let q141=q64!(105);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+5952) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6016) as *const i8);}
let w140=w.lohi[6];let s140=w.sum[6];let x140=_mm512_xor_si512(q140,q141);
let g31=q64!(106);let r31=_mm512_rol_epi64::<1>(*dep.add(31));let m31=_mm512_set1_epi64(1u64 as i64);
let q142=_mm512_ternarylogic_epi64::<0xCA>(m31,g31,r31);let q143=_mm512_ternarylogic_epi64::<0xCA>(m31,r31,g31);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6080) as *const i8);}
let w142=w.lohi[7];let s142=w.sum[7];let x142=_mm512_xor_si512(q142,q143);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q140,w140),_mm512_clmulepi64_epi128::<0x00>(q142,w142));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q140,w140),_mm512_clmulepi64_epi128::<0x01>(q142,w142));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q141,w140),_mm512_clmulepi64_epi128::<0x10>(q143,w142));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q141,w140),_mm512_clmulepi64_epi128::<0x11>(q143,w142));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x140,s140),_mm512_clmulepi64_epi128::<0x00>(x142,s142));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x140,s140),_mm512_clmulepi64_epi128::<0x01>(x142,s142));
let q144=q64!(107);
let g32=q64!(108);let r32=_mm512_rol_epi64::<59>(*dep.add(32));let m32=_mm512_set1_epi64(576460752303423487u64 as i64);
let q145=_mm512_ternarylogic_epi64::<0xCA>(m32,g32,r32);let q146=_mm512_ternarylogic_epi64::<0xCA>(m32,r32,g32);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6144) as *const i8);}
let w144=w.lohi[8];let s144=w.sum[8];let x144=_mm512_xor_si512(q144,q145);
let q147=q64!(109);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6208) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6272) as *const i8);}
let w146=w.lohi[9];let s146=w.sum[9];let x146=_mm512_xor_si512(q146,q147);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q144,w144),_mm512_clmulepi64_epi128::<0x00>(q146,w146));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q144,w144),_mm512_clmulepi64_epi128::<0x01>(q146,w146));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q145,w144),_mm512_clmulepi64_epi128::<0x10>(q147,w146));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q145,w144),_mm512_clmulepi64_epi128::<0x11>(q147,w146));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x144,s144),_mm512_clmulepi64_epi128::<0x00>(x146,s146));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x144,s144),_mm512_clmulepi64_epi128::<0x01>(x146,s146));
let q148=q64!(110);
let g33=q64!(111);let r33=_mm512_rol_epi64::<53>(*dep.add(33));let m33=_mm512_set1_epi64(9007199254740991u64 as i64);
let q149=_mm512_ternarylogic_epi64::<0xCA>(m33,g33,r33);let q150=_mm512_ternarylogic_epi64::<0xCA>(m33,r33,g33);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6336) as *const i8);}
let w148=w.lohi[10];let s148=w.sum[10];let x148=_mm512_xor_si512(q148,q149);
let q151=q64!(112);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6400) as *const i8);}
let w150=w.lohi[11];let s150=w.sum[11];let x150=_mm512_xor_si512(q150,q151);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q148,w148),_mm512_clmulepi64_epi128::<0x00>(q150,w150));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q148,w148),_mm512_clmulepi64_epi128::<0x01>(q150,w150));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q149,w148),_mm512_clmulepi64_epi128::<0x10>(q151,w150));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q149,w148),_mm512_clmulepi64_epi128::<0x11>(q151,w150));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x148,s148),_mm512_clmulepi64_epi128::<0x00>(x150,s150));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x148,s148),_mm512_clmulepi64_epi128::<0x01>(x150,s150));
let q152=q64!(113);
let g34=q64!(114);let r34=_mm512_rol_epi64::<47>(*dep.add(34));let m34=_mm512_set1_epi64(140737488355327u64 as i64);
let q153=_mm512_ternarylogic_epi64::<0xCA>(m34,g34,r34);let q154=_mm512_ternarylogic_epi64::<0xCA>(m34,r34,g34);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6464) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6528) as *const i8);}
let w152=w.lohi[12];let s152=w.sum[12];let x152=_mm512_xor_si512(q152,q153);
let q155=q64!(115);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6592) as *const i8);}
let w154=w.lohi[13];let s154=w.sum[13];let x154=_mm512_xor_si512(q154,q155);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q152,w152),_mm512_clmulepi64_epi128::<0x00>(q154,w154));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q152,w152),_mm512_clmulepi64_epi128::<0x01>(q154,w154));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q153,w152),_mm512_clmulepi64_epi128::<0x10>(q155,w154));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q153,w152),_mm512_clmulepi64_epi128::<0x11>(q155,w154));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x152,s152),_mm512_clmulepi64_epi128::<0x00>(x154,s154));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x152,s152),_mm512_clmulepi64_epi128::<0x01>(x154,s154));
let q156=q64!(116);
let g35=q64!(117);let r35=_mm512_rol_epi64::<41>(*dep.add(35));let m35=_mm512_set1_epi64(2199023255551u64 as i64);
let q157=_mm512_ternarylogic_epi64::<0xCA>(m35,g35,r35);let q158=_mm512_ternarylogic_epi64::<0xCA>(m35,r35,g35);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6656) as *const i8);}
let w156=w.lohi[14];let s156=w.sum[14];let x156=_mm512_xor_si512(q156,q157);
let q159=q64!(118);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6720) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6784) as *const i8);}
let w158=w.lohi[15];let s158=w.sum[15];let x158=_mm512_xor_si512(q158,q159);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q156,w156),_mm512_clmulepi64_epi128::<0x00>(q158,w158));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q156,w156),_mm512_clmulepi64_epi128::<0x01>(q158,w158));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q157,w156),_mm512_clmulepi64_epi128::<0x10>(q159,w158));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q157,w156),_mm512_clmulepi64_epi128::<0x11>(q159,w158));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x156,s156),_mm512_clmulepi64_epi128::<0x00>(x158,s158));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x156,s156),_mm512_clmulepi64_epi128::<0x01>(x158,s158));
let q160=q64!(119);
let g36=q64!(120);let r36=_mm512_rol_epi64::<35>(*dep.add(36));let m36=_mm512_set1_epi64(34359738367u64 as i64);
let q161=_mm512_ternarylogic_epi64::<0xCA>(m36,g36,r36);let q162=_mm512_ternarylogic_epi64::<0xCA>(m36,r36,g36);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6848) as *const i8);}
let w160=w.lohi[16];let s160=w.sum[16];let x160=_mm512_xor_si512(q160,q161);
let q163=q64!(121);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6912) as *const i8);}
let w162=w.lohi[17];let s162=w.sum[17];let x162=_mm512_xor_si512(q162,q163);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q160,w160),_mm512_clmulepi64_epi128::<0x00>(q162,w162));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q160,w160),_mm512_clmulepi64_epi128::<0x01>(q162,w162));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q161,w160),_mm512_clmulepi64_epi128::<0x10>(q163,w162));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q161,w160),_mm512_clmulepi64_epi128::<0x11>(q163,w162));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x160,s160),_mm512_clmulepi64_epi128::<0x00>(x162,s162));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x160,s160),_mm512_clmulepi64_epi128::<0x01>(x162,s162));
let q164=q64!(122);
let g37=q64!(123);let r37=_mm512_rol_epi64::<29>(*dep.add(37));let m37=_mm512_set1_epi64(536870911u64 as i64);
let q165=_mm512_ternarylogic_epi64::<0xCA>(m37,g37,r37);let q166=_mm512_ternarylogic_epi64::<0xCA>(m37,r37,g37);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+6976) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7040) as *const i8);}
let w164=w.lohi[18];let s164=w.sum[18];let x164=_mm512_xor_si512(q164,q165);
let q167=q64!(124);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7104) as *const i8);}
let w166=w.lohi[19];let s166=w.sum[19];let x166=_mm512_xor_si512(q166,q167);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q164,w164),_mm512_clmulepi64_epi128::<0x00>(q166,w166));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q164,w164),_mm512_clmulepi64_epi128::<0x01>(q166,w166));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q165,w164),_mm512_clmulepi64_epi128::<0x10>(q167,w166));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q165,w164),_mm512_clmulepi64_epi128::<0x11>(q167,w166));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x164,s164),_mm512_clmulepi64_epi128::<0x00>(x166,s166));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x164,s164),_mm512_clmulepi64_epi128::<0x01>(x166,s166));
let q168=q64!(125);
let g38=q64!(126);let r38=_mm512_rol_epi64::<23>(*dep.add(38));let m38=_mm512_set1_epi64(8388607u64 as i64);
let q169=_mm512_ternarylogic_epi64::<0xCA>(m38,g38,r38);let q170=_mm512_ternarylogic_epi64::<0xCA>(m38,r38,g38);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7168) as *const i8);}
let w168=w.lohi[20];let s168=w.sum[20];let x168=_mm512_xor_si512(q168,q169);
let q171=q64!(127);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7232) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7296) as *const i8);}
let w170=w.lohi[21];let s170=w.sum[21];let x170=_mm512_xor_si512(q170,q171);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q168,w168),_mm512_clmulepi64_epi128::<0x00>(q170,w170));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q168,w168),_mm512_clmulepi64_epi128::<0x01>(q170,w170));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q169,w168),_mm512_clmulepi64_epi128::<0x10>(q171,w170));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q169,w168),_mm512_clmulepi64_epi128::<0x11>(q171,w170));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x168,s168),_mm512_clmulepi64_epi128::<0x00>(x170,s170));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x168,s168),_mm512_clmulepi64_epi128::<0x01>(x170,s170));
let q172=q64!(128);
let g39=q64!(129);let r39=_mm512_rol_epi64::<17>(*dep.add(39));let m39=_mm512_set1_epi64(131071u64 as i64);
let q173=_mm512_ternarylogic_epi64::<0xCA>(m39,g39,r39);let q174=_mm512_ternarylogic_epi64::<0xCA>(m39,r39,g39);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7360) as *const i8);}
let w172=w.lohi[22];let s172=w.sum[22];let x172=_mm512_xor_si512(q172,q173);
let q175=q64!(130);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7424) as *const i8);}
let w174=w.lohi[23];let s174=w.sum[23];let x174=_mm512_xor_si512(q174,q175);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q172,w172),_mm512_clmulepi64_epi128::<0x00>(q174,w174));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q172,w172),_mm512_clmulepi64_epi128::<0x01>(q174,w174));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q173,w172),_mm512_clmulepi64_epi128::<0x10>(q175,w174));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q173,w172),_mm512_clmulepi64_epi128::<0x11>(q175,w174));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x172,s172),_mm512_clmulepi64_epi128::<0x00>(x174,s174));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x172,s172),_mm512_clmulepi64_epi128::<0x01>(x174,s174));
let q176=q64!(131);
let g40=q64!(132);let r40=_mm512_rol_epi64::<11>(*dep.add(40));let m40=_mm512_set1_epi64(2047u64 as i64);
let q177=_mm512_ternarylogic_epi64::<0xCA>(m40,g40,r40);let q178=_mm512_ternarylogic_epi64::<0xCA>(m40,r40,g40);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7488) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7552) as *const i8);}
let w176=w.lohi[24];let s176=w.sum[24];let x176=_mm512_xor_si512(q176,q177);
let q179=q64!(133);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7616) as *const i8);}
let w178=w.lohi[25];let s178=w.sum[25];let x178=_mm512_xor_si512(q178,q179);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q176,w176),_mm512_clmulepi64_epi128::<0x00>(q178,w178));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q176,w176),_mm512_clmulepi64_epi128::<0x01>(q178,w178));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q177,w176),_mm512_clmulepi64_epi128::<0x10>(q179,w178));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q177,w176),_mm512_clmulepi64_epi128::<0x11>(q179,w178));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x176,s176),_mm512_clmulepi64_epi128::<0x00>(x178,s178));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x176,s176),_mm512_clmulepi64_epi128::<0x01>(x178,s178));
let q180=q64!(134);
let g41=q64!(135);let r41=_mm512_rol_epi64::<5>(*dep.add(41));let m41=_mm512_set1_epi64(31u64 as i64);
let q181=_mm512_ternarylogic_epi64::<0xCA>(m41,g41,r41);let q182=_mm512_ternarylogic_epi64::<0xCA>(m41,r41,g41);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7680) as *const i8);}
let w180=w.lohi[26];let s180=w.sum[26];let x180=_mm512_xor_si512(q180,q181);
let q183=q64!(136);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7744) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7808) as *const i8);}
let w182=w.lohi[27];let s182=w.sum[27];let x182=_mm512_xor_si512(q182,q183);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q180,w180),_mm512_clmulepi64_epi128::<0x00>(q182,w182));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q180,w180),_mm512_clmulepi64_epi128::<0x01>(q182,w182));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q181,w180),_mm512_clmulepi64_epi128::<0x10>(q183,w182));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q181,w180),_mm512_clmulepi64_epi128::<0x11>(q183,w182));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x180,s180),_mm512_clmulepi64_epi128::<0x00>(x182,s182));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x180,s180),_mm512_clmulepi64_epi128::<0x01>(x182,s182));
let g42=q64!(137);let r42=_mm512_rol_epi64::<63>(*dep.add(42));let m42=_mm512_set1_epi64(9223372036854775807u64 as i64);
let q184=_mm512_ternarylogic_epi64::<0xCA>(m42,g42,r42);let q185=_mm512_ternarylogic_epi64::<0xCA>(m42,r42,g42);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7872) as *const i8);}
let w184=w.lohi[28];let s184=w.sum[28];let x184=_mm512_xor_si512(q184,q185);
let q186=q64!(138);
let q187=q64!(139);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+7936) as *const i8);}
let w186=w.lohi[29];let s186=w.sum[29];let x186=_mm512_xor_si512(q186,q187);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q184,w184),_mm512_clmulepi64_epi128::<0x00>(q186,w186));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q184,w184),_mm512_clmulepi64_epi128::<0x01>(q186,w186));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q185,w184),_mm512_clmulepi64_epi128::<0x10>(q187,w186));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q185,w184),_mm512_clmulepi64_epi128::<0x11>(q187,w186));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x184,s184),_mm512_clmulepi64_epi128::<0x00>(x186,s186));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x184,s184),_mm512_clmulepi64_epi128::<0x01>(x186,s186));
let g43=q64!(140);let r43=_mm512_rol_epi64::<57>(*dep.add(43));let m43=_mm512_set1_epi64(144115188075855871u64 as i64);
let q188=_mm512_ternarylogic_epi64::<0xCA>(m43,g43,r43);let q189=_mm512_ternarylogic_epi64::<0xCA>(m43,r43,g43);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8000) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8064) as *const i8);}
let w188=w.lohi[30];let s188=w.sum[30];let x188=_mm512_xor_si512(q188,q189);
let q190=q64!(141);
let q191=q64!(142);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8128) as *const i8);}
let w190=w.lohi[31];let s190=w.sum[31];let x190=_mm512_xor_si512(q190,q191);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q188,w188),_mm512_clmulepi64_epi128::<0x00>(q190,w190));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q188,w188),_mm512_clmulepi64_epi128::<0x01>(q190,w190));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q189,w188),_mm512_clmulepi64_epi128::<0x10>(q191,w190));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q189,w188),_mm512_clmulepi64_epi128::<0x11>(q191,w190));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x188,s188),_mm512_clmulepi64_epi128::<0x00>(x190,s190));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x188,s188),_mm512_clmulepi64_epi128::<0x01>(x190,s190));
let g44=q64!(143);let r44=_mm512_rol_epi64::<51>(*dep.add(44));let m44=_mm512_set1_epi64(2251799813685247u64 as i64);
let q192=_mm512_ternarylogic_epi64::<0xCA>(m44,g44,r44);let q193=_mm512_ternarylogic_epi64::<0xCA>(m44,r44,g44);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8192) as *const i8);}
let w192=w.lohi[32];let s192=w.sum[32];let x192=_mm512_xor_si512(q192,q193);
let q194=q64!(144);
let q195=q64!(145);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8256) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8320) as *const i8);}
let w194=w.lohi[33];let s194=w.sum[33];let x194=_mm512_xor_si512(q194,q195);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q192,w192),_mm512_clmulepi64_epi128::<0x00>(q194,w194));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q192,w192),_mm512_clmulepi64_epi128::<0x01>(q194,w194));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q193,w192),_mm512_clmulepi64_epi128::<0x10>(q195,w194));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q193,w192),_mm512_clmulepi64_epi128::<0x11>(q195,w194));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x192,s192),_mm512_clmulepi64_epi128::<0x00>(x194,s194));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x192,s192),_mm512_clmulepi64_epi128::<0x01>(x194,s194));
let g45=q64!(146);let r45=_mm512_rol_epi64::<45>(*dep.add(45));let m45=_mm512_set1_epi64(35184372088831u64 as i64);
let q196=_mm512_ternarylogic_epi64::<0xCA>(m45,g45,r45);let q197=_mm512_ternarylogic_epi64::<0xCA>(m45,r45,g45);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8384) as *const i8);}
let w196=w.lohi[34];let s196=w.sum[34];let x196=_mm512_xor_si512(q196,q197);
let q198=q64!(147);
let q199=q64!(148);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8448) as *const i8);}
let w198=w.lohi[35];let s198=w.sum[35];let x198=_mm512_xor_si512(q198,q199);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q196,w196),_mm512_clmulepi64_epi128::<0x00>(q198,w198));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q196,w196),_mm512_clmulepi64_epi128::<0x01>(q198,w198));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q197,w196),_mm512_clmulepi64_epi128::<0x10>(q199,w198));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q197,w196),_mm512_clmulepi64_epi128::<0x11>(q199,w198));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x196,s196),_mm512_clmulepi64_epi128::<0x00>(x198,s198));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x196,s196),_mm512_clmulepi64_epi128::<0x01>(x198,s198));
let g46=q64!(149);let r46=_mm512_rol_epi64::<39>(*dep.add(46));let m46=_mm512_set1_epi64(549755813887u64 as i64);
let q200=_mm512_ternarylogic_epi64::<0xCA>(m46,g46,r46);let q201=_mm512_ternarylogic_epi64::<0xCA>(m46,r46,g46);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8512) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8576) as *const i8);}
let w200=w.lohi[36];let s200=w.sum[36];let x200=_mm512_xor_si512(q200,q201);
let q202=q64!(150);
let q203=q64!(151);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8640) as *const i8);}
let w202=w.lohi[37];let s202=w.sum[37];let x202=_mm512_xor_si512(q202,q203);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q200,w200),_mm512_clmulepi64_epi128::<0x00>(q202,w202));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q200,w200),_mm512_clmulepi64_epi128::<0x01>(q202,w202));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q201,w200),_mm512_clmulepi64_epi128::<0x10>(q203,w202));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q201,w200),_mm512_clmulepi64_epi128::<0x11>(q203,w202));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x200,s200),_mm512_clmulepi64_epi128::<0x00>(x202,s202));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x200,s200),_mm512_clmulepi64_epi128::<0x01>(x202,s202));
let g47=q64!(152);let r47=_mm512_rol_epi64::<33>(*dep.add(47));let m47=_mm512_set1_epi64(8589934591u64 as i64);
let q204=_mm512_ternarylogic_epi64::<0xCA>(m47,g47,r47);let q205=_mm512_ternarylogic_epi64::<0xCA>(m47,r47,g47);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8704) as *const i8);}
let w204=w.lohi[38];let s204=w.sum[38];let x204=_mm512_xor_si512(q204,q205);
let q206=q64!(153);
let q207=q64!(154);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8768) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8832) as *const i8);}
let w206=w.lohi[39];let s206=w.sum[39];let x206=_mm512_xor_si512(q206,q207);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q204,w204),_mm512_clmulepi64_epi128::<0x00>(q206,w206));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q204,w204),_mm512_clmulepi64_epi128::<0x01>(q206,w206));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q205,w204),_mm512_clmulepi64_epi128::<0x10>(q207,w206));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q205,w204),_mm512_clmulepi64_epi128::<0x11>(q207,w206));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x204,s204),_mm512_clmulepi64_epi128::<0x00>(x206,s206));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x204,s204),_mm512_clmulepi64_epi128::<0x01>(x206,s206));
let g48=q64!(155);let r48=_mm512_rol_epi64::<27>(*dep.add(48));let m48=_mm512_set1_epi64(134217727u64 as i64);
let q208=_mm512_ternarylogic_epi64::<0xCA>(m48,g48,r48);let q209=_mm512_ternarylogic_epi64::<0xCA>(m48,r48,g48);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8896) as *const i8);}
let w208=w.lohi[40];let s208=w.sum[40];let x208=_mm512_xor_si512(q208,q209);
let q210=q64!(156);
let q211=q64!(157);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+8960) as *const i8);}
let w210=w.lohi[41];let s210=w.sum[41];let x210=_mm512_xor_si512(q210,q211);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q208,w208),_mm512_clmulepi64_epi128::<0x00>(q210,w210));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q208,w208),_mm512_clmulepi64_epi128::<0x01>(q210,w210));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q209,w208),_mm512_clmulepi64_epi128::<0x10>(q211,w210));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q209,w208),_mm512_clmulepi64_epi128::<0x11>(q211,w210));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x208,s208),_mm512_clmulepi64_epi128::<0x00>(x210,s210));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x208,s208),_mm512_clmulepi64_epi128::<0x01>(x210,s210));
let g49=q64!(158);let r49=_mm512_rol_epi64::<21>(*dep.add(49));let m49=_mm512_set1_epi64(2097151u64 as i64);
let q212=_mm512_ternarylogic_epi64::<0xCA>(m49,g49,r49);let q213=_mm512_ternarylogic_epi64::<0xCA>(m49,r49,g49);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9024) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9088) as *const i8);}
let w212=w.lohi[42];let s212=w.sum[42];let x212=_mm512_xor_si512(q212,q213);
let q214=q64!(159);
let q215=q64!(160);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9152) as *const i8);}
let w214=w.lohi[43];let s214=w.sum[43];let x214=_mm512_xor_si512(q214,q215);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q212,w212),_mm512_clmulepi64_epi128::<0x00>(q214,w214));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q212,w212),_mm512_clmulepi64_epi128::<0x01>(q214,w214));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q213,w212),_mm512_clmulepi64_epi128::<0x10>(q215,w214));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q213,w212),_mm512_clmulepi64_epi128::<0x11>(q215,w214));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x212,s212),_mm512_clmulepi64_epi128::<0x00>(x214,s214));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x212,s212),_mm512_clmulepi64_epi128::<0x01>(x214,s214));
let g50=q64!(161);let r50=_mm512_rol_epi64::<15>(*dep.add(50));let m50=_mm512_set1_epi64(32767u64 as i64);
let q216=_mm512_ternarylogic_epi64::<0xCA>(m50,g50,r50);let q217=_mm512_ternarylogic_epi64::<0xCA>(m50,r50,g50);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9216) as *const i8);}
let w216=w.lohi[44];let s216=w.sum[44];let x216=_mm512_xor_si512(q216,q217);
let q218=q64!(162);
let q219=q64!(163);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9280) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9344) as *const i8);}
let w218=w.lohi[45];let s218=w.sum[45];let x218=_mm512_xor_si512(q218,q219);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q216,w216),_mm512_clmulepi64_epi128::<0x00>(q218,w218));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q216,w216),_mm512_clmulepi64_epi128::<0x01>(q218,w218));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q217,w216),_mm512_clmulepi64_epi128::<0x10>(q219,w218));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q217,w216),_mm512_clmulepi64_epi128::<0x11>(q219,w218));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x216,s216),_mm512_clmulepi64_epi128::<0x00>(x218,s218));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x216,s216),_mm512_clmulepi64_epi128::<0x01>(x218,s218));
let g51=q64!(164);let r51=_mm512_rol_epi64::<9>(*dep.add(51));let m51=_mm512_set1_epi64(511u64 as i64);
let q220=_mm512_ternarylogic_epi64::<0xCA>(m51,g51,r51);let q221=_mm512_ternarylogic_epi64::<0xCA>(m51,r51,g51);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9408) as *const i8);}
let w220=w.lohi[46];let s220=w.sum[46];let x220=_mm512_xor_si512(q220,q221);
let q222=q64!(165);
let q223=q64!(166);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9472) as *const i8);}
let w222=w.lohi[47];let s222=w.sum[47];let x222=_mm512_xor_si512(q222,q223);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q220,w220),_mm512_clmulepi64_epi128::<0x00>(q222,w222));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q220,w220),_mm512_clmulepi64_epi128::<0x01>(q222,w222));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q221,w220),_mm512_clmulepi64_epi128::<0x10>(q223,w222));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q221,w220),_mm512_clmulepi64_epi128::<0x11>(q223,w222));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x220,s220),_mm512_clmulepi64_epi128::<0x00>(x222,s222));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x220,s220),_mm512_clmulepi64_epi128::<0x01>(x222,s222));
let g52=q64!(167);let r52=_mm512_rol_epi64::<3>(*dep.add(52));let m52=_mm512_set1_epi64(7u64 as i64);
let q224=_mm512_ternarylogic_epi64::<0xCA>(m52,g52,r52);let q225=_mm512_ternarylogic_epi64::<0xCA>(m52,r52,g52);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9536) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9600) as *const i8);}
let w224=w.lohi[48];let s224=w.sum[48];let x224=_mm512_xor_si512(q224,q225);
let q226=q64!(168);
let g53=q64!(169);let r53=_mm512_rol_epi64::<61>(*dep.add(53));let m53=_mm512_set1_epi64(2305843009213693951u64 as i64);
let q227=_mm512_ternarylogic_epi64::<0xCA>(m53,g53,r53);let q228=_mm512_ternarylogic_epi64::<0xCA>(m53,r53,g53);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9664) as *const i8);}
let w226=w.lohi[49];let s226=w.sum[49];let x226=_mm512_xor_si512(q226,q227);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q224,w224),_mm512_clmulepi64_epi128::<0x00>(q226,w226));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q224,w224),_mm512_clmulepi64_epi128::<0x01>(q226,w226));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q225,w224),_mm512_clmulepi64_epi128::<0x10>(q227,w226));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q225,w224),_mm512_clmulepi64_epi128::<0x11>(q227,w226));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x224,s224),_mm512_clmulepi64_epi128::<0x00>(x226,s226));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x224,s224),_mm512_clmulepi64_epi128::<0x01>(x226,s226));
let q229=q64!(170);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9728) as *const i8);}
let w228=w.lohi[50];let s228=w.sum[50];let x228=_mm512_xor_si512(q228,q229);
let q230=q64!(171);
let g54=q64!(172);let r54=_mm512_rol_epi64::<55>(*dep.add(54));let m54=_mm512_set1_epi64(36028797018963967u64 as i64);
let q231=_mm512_ternarylogic_epi64::<0xCA>(m54,g54,r54);let q232=_mm512_ternarylogic_epi64::<0xCA>(m54,r54,g54);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9792) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9856) as *const i8);}
let w230=w.lohi[51];let s230=w.sum[51];let x230=_mm512_xor_si512(q230,q231);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q228,w228),_mm512_clmulepi64_epi128::<0x00>(q230,w230));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q228,w228),_mm512_clmulepi64_epi128::<0x01>(q230,w230));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q229,w228),_mm512_clmulepi64_epi128::<0x10>(q231,w230));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q229,w228),_mm512_clmulepi64_epi128::<0x11>(q231,w230));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x228,s228),_mm512_clmulepi64_epi128::<0x00>(x230,s230));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x228,s228),_mm512_clmulepi64_epi128::<0x01>(x230,s230));
let q233=q64!(173);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9920) as *const i8);}
let w232=w.lohi[52];let s232=w.sum[52];let x232=_mm512_xor_si512(q232,q233);
let q234=q64!(174);
let q235=_mm512_ternarylogic_epi64::<0xEA>(q64!(175),_mm512_set1_epi64(((1u64<<49)-1) as i64),_mm512_slli_epi64::<49>(*dep.add(55)));
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+9984) as *const i8);}
let w234=w.lohi[53];let s234=w.sum[53];let x234=_mm512_xor_si512(q234,q235);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q232,w232),_mm512_clmulepi64_epi128::<0x00>(q234,w234));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q232,w232),_mm512_clmulepi64_epi128::<0x01>(q234,w234));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q233,w232),_mm512_clmulepi64_epi128::<0x10>(q235,w234));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q233,w232),_mm512_clmulepi64_epi128::<0x11>(q235,w234));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x232,s232),_mm512_clmulepi64_epi128::<0x00>(x234,s234));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x232,s232),_mm512_clmulepi64_epi128::<0x01>(x234,s234));
let q236=_mm512_shrdi_epi64::<15>(*dep.add(55),oh[0]);
let q237=_mm512_shrdi_epi64::<15>(oh[0],oh[1]);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+10048) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+10112) as *const i8);}
let w236=w.lohi[54];let s236=w.sum[54];let x236=_mm512_xor_si512(q236,q237);
let q238=_mm512_shrdi_epi64::<15>(oh[1],oh[2]);
let q239=_mm512_shrdi_epi64::<15>(oh[2],oh[3]);
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+10176) as *const i8);}
let w238=w.lohi[55];let s238=w.sum[55];let x238=_mm512_xor_si512(q238,q239);
le=_mm512_ternarylogic_epi64::<0x96>(le,_mm512_clmulepi64_epi128::<0x00>(q236,w236),_mm512_clmulepi64_epi128::<0x00>(q238,w238));
lo=_mm512_ternarylogic_epi64::<0x96>(lo,_mm512_clmulepi64_epi128::<0x01>(q236,w236),_mm512_clmulepi64_epi128::<0x01>(q238,w238));
he=_mm512_ternarylogic_epi64::<0x96>(he,_mm512_clmulepi64_epi128::<0x10>(q237,w236),_mm512_clmulepi64_epi128::<0x10>(q239,w238));
ho=_mm512_ternarylogic_epi64::<0x96>(ho,_mm512_clmulepi64_epi128::<0x11>(q237,w236),_mm512_clmulepi64_epi128::<0x11>(q239,w238));
me=_mm512_ternarylogic_epi64::<0x96>(me,_mm512_clmulepi64_epi128::<0x00>(x236,s236),_mm512_clmulepi64_epi128::<0x00>(x238,s238));
mo=_mm512_ternarylogic_epi64::<0x96>(mo,_mm512_clmulepi64_epi128::<0x01>(x236,s236),_mm512_clmulepi64_epi128::<0x01>(x238,s238));
let q240=_mm512_srli_epi64::<15>(oh[3]);
let q241=_mm512_setzero_si512();
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+10240) as *const i8);}
if PREFETCH{_mm_prefetch::<_MM_HINT_T1>((next+10304) as *const i8);}
let w240=w.lohi[56];let s240=w.sum[56];let x240=_mm512_xor_si512(q240,q241);
le=_mm512_xor_si512(le,_mm512_clmulepi64_epi128::<0x00>(q240,w240));
lo=_mm512_xor_si512(lo,_mm512_clmulepi64_epi128::<0x01>(q240,w240));
he=_mm512_xor_si512(he,_mm512_clmulepi64_epi128::<0x10>(q241,w240));
ho=_mm512_xor_si512(ho,_mm512_clmulepi64_epi128::<0x11>(q241,w240));
me=_mm512_xor_si512(me,_mm512_clmulepi64_epi128::<0x00>(x240,s240));
mo=_mm512_xor_si512(mo,_mm512_clmulepi64_epi128::<0x01>(x240,s240));
let me=_mm512_ternarylogic_epi64::<0x96>(me,le,he);let mo=_mm512_ternarylogic_epi64::<0x96>(mo,lo,ho);out[1][0]=flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(le,me,he);out[1][1]=flock_core::field::gf2_128::x86_64::ghash_reduce_acc_x4(lo,mo,ho);
pf.cur=pf.lim;pf.acc=0;out
}}

    // A real next tile supplies a complete 162-line span per octa. The final
    // tile and any unexpected span use the existing fill/fold implementation;
    // this avoids duplicating the large unrolled kernel for the cold tail.
    #[inline(always)]
    unsafe fn fold_octa_with_plan(plan: &Plan, tile: *const u8, o: usize, x: usize,
        scratch: &mut Scratch, weights: &Weights, pf: &mut PfCur) -> [[__m512i;2];2] {
        unsafe {
            if plan.fused_layout && pf.end.saturating_sub(pf.cur) >= (PF_FILL+PF_FOLD)*64 {
                fused_stage_fold_prefetched(tile,o,x,scratch,weights,pf)
            } else {
                pf.phase(PF_FILL,FILL_OPS);
                fill_stage(plan,tile,o,x,scratch,pf);
                pf.flush();
                pf.phase(PF_FOLD,1);
                let result=fold_stage(&scratch.stage,weights,pf);
                pf.flush();
                result
            }
        }
    }

fn for_each_folded_octa(view: &WitnessTileView, weights: &Weights, f: impl Fn([[__m512i;2];2], usize, usize) + Sync) {
        let plan = plan().expect("z regeneration plan");
        assert!(view.tiles > 0);
        if view.cross_quarter {
            assert_eq!(view.tiles * 64, 1 << 18);
        }
        let unit = if view.tiles % 8 == 0 { 8 } else { 1 };
        let base = view.base;
        let tiles = view.tiles;
        #[cfg(test)]
        let mode = TEST_MODE.load(std::sync::atomic::Ordering::Relaxed);
        #[cfg(not(test))]
        let mode = 0u8;
        // Existing timing-only test hooks retain their old semantics.
        #[cfg(test)]
        if mode != 0 {
            for_each_octa(view, |stage,t,o,pf| unsafe { f(fold_stage(stage,weights,pf),t,o) });
            return;
        }
        thread_local! {
            // Reused across proofs: no per-task allocation/zeroing.
            static SCRATCH: core::cell::RefCell<Option<Box<Scratch>>> =
                const { core::cell::RefCell::new(None) };
        }
        assert_eq!(GROUPS * 8, TILE_BYTES / 64);
        (0..view.tiles / unit).into_par_iter().for_each(|u| {
            SCRATCH.with(|cell| {
                let mut guard = cell.borrow_mut();
                let scratch = guard.get_or_insert_with(Scratch::new);
                for t in u * unit..(u + 1) * unit {
                    let tile = (base + t * TILE_BYTES) as *const u8;
                    let next = (t + 1 < tiles).then(|| base + (t + 1) * TILE_BYTES);
                    for pair in 0..4 {
                        // While octa pair `pair` of this tile is processed,
                        // the same quarter of the next tile streams into L2.
                        let mut pf = PfCur::new(next.map(|n| n + 2 * pair * (TILE_BYTES / 8)));
                        // SAFETY: tiles are complete, initialized, 64-byte
                        // aligned; prefetch hints stay within the tile span.
                        // Mode bits (tests only) skip phases.
                        unsafe {
                            pf.phase(PF_BLAKE, 1);
                            if mode & 1 == 0 {
                                blake3_pair(tile, 2 * pair, scratch, &mut pf);
                            }
                            for x in 0..2 {
                                let o = 2 * pair + x;
                                pf.flush();
                                let result=fold_octa_with_plan(plan,tile,o,x,scratch,weights,&mut pf);
                                f(result,t,o);
                            }
                            pf.flush();
                        }
                    }
                }
            })
        });
    }
#[cfg(test)]
mod fused_tests {
use super::*;
#[inline(never)]
unsafe fn baseline(plan:&Plan,tile:*const u8,o:usize,x:usize,scratch:&mut Scratch,w:&Weights,pf:&mut PfCur)->[[__m512i;2];2]{unsafe{
 pf.phase(PF_FILL,FILL_OPS);fill_stage(plan,tile,o,x,scratch,pf);pf.flush();pf.phase(PF_FOLD,1);let out=fold_stage(&scratch.stage,w,pf);pf.flush();out
}}
fn rng(s:&mut u64)->u64{*s=s.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);*s}
#[inline(never)]fn scalar_mul(mut a:u128,mut b:u128)->u128{let mut c=0;for _ in 0..128{c^=a.wrapping_mul(b&1);let bit=a>>127;a=(a<<1)^0x87u128.wrapping_mul(bit);b>>=1;}c}
#[repr(C,align(64))]struct Tile([u64;11264]);
fn bits(out:[[__m512i;2];2])->[[[u64;8];2];2]{unsafe{core::mem::transmute(out)}}
#[test]
fn fused_stage_fold_matches_control_and_scalar(){unsafe{
 let roots:Vec<usize>=(0..15409).filter(|&i|!(256..512).contains(&i)&&!(15153..15409).contains(&i)&&!(0..56).any(|g|(1153+250*g+186..1153+250*g+250).contains(&i))).collect();
 let mut plan=build_plan(&roots).expect("actual public plan");assert!(plan.fused_layout);
 assert_eq!(plan.full.iter().map(|p|(p.q as usize,p.cg as usize)).collect::<Vec<_>>(),vec![(0, 0), (1, 1), (2, 2), (3, 3), (8, 4), (9, 5), (10, 6), (11, 7), (12, 8), (13, 9), (14, 10), (15, 11), (16, 12), (19, 14), (22, 16), (23, 17), (26, 19), (27, 20), (30, 22), (31, 23), (34, 25), (35, 26), (38, 28), (39, 29), (42, 31), (43, 32), (46, 34), (47, 35), (50, 37), (51, 38), (54, 40), (55, 41), (58, 43), (61, 45), (62, 46), (65, 48), (66, 49), (69, 51), (70, 52), (73, 54), (74, 55), (77, 57), (78, 58), (81, 60), (82, 61), (85, 63), (86, 64), (89, 66), (90, 67), (93, 69), (94, 70), (97, 72), (98, 73), (101, 75), (104, 77), (105, 78), (108, 80), (109, 81), (112, 83), (113, 84), (116, 86), (117, 87), (120, 89), (121, 90), (124, 92), (125, 93), (128, 95), (129, 96), (132, 98), (133, 99), (136, 101), (137, 102), (140, 104), (141, 105), (144, 107), (147, 109), (148, 110), (151, 112), (152, 113), (155, 115), (156, 116), (159, 118), (160, 119), (163, 121), (164, 122), (167, 124), (168, 125), (171, 127), (172, 128), (175, 130), (176, 131), (179, 133), (180, 134), (183, 136), (186, 138), (187, 139), (190, 141), (191, 142), (194, 144), (195, 145), (198, 147), (199, 148), (202, 150), (203, 151), (206, 153), (207, 154), (210, 156), (211, 157), (214, 159), (215, 160), (218, 162), (219, 163), (222, 165), (223, 166), (226, 168), (229, 170), (230, 171), (233, 173), (234, 174)]);
assert_eq!(plan.pairs.iter().map(|p|(p.q as usize,p.cg as usize,p.g as usize)).collect::<Vec<_>>(),vec![(20, 15, 0), (24, 18, 1), (28, 21, 2), (32, 24, 3), (36, 27, 4), (40, 30, 5), (44, 33, 6), (48, 36, 7), (52, 39, 8), (56, 42, 9), (59, 44, 10), (63, 47, 11), (67, 50, 12), (71, 53, 13), (75, 56, 14), (79, 59, 15), (83, 62, 16), (87, 65, 17), (91, 68, 18), (95, 71, 19), (99, 74, 20), (102, 76, 21), (106, 79, 22), (110, 82, 23), (114, 85, 24), (118, 88, 25), (122, 91, 26), (126, 94, 27), (130, 97, 28), (134, 100, 29), (138, 103, 30), (142, 106, 31), (145, 108, 32), (149, 111, 33), (153, 114, 34), (157, 117, 35), (161, 120, 36), (165, 123, 37), (169, 126, 38), (173, 129, 39), (177, 132, 40), (181, 135, 41), (184, 137, 42), (188, 140, 43), (192, 143, 44), (196, 146, 45), (200, 149, 46), (204, 152, 47), (208, 155, 48), (212, 158, 49), (216, 161, 50), (220, 164, 51), (224, 167, 52), (227, 169, 53), (231, 172, 54)]);
assert_eq!(plan.rot.iter().map(|p|p.0[0]).collect::<Vec<_>>(),vec![59, 53, 47, 41, 35, 29, 23, 17, 11, 5, 63, 57, 51, 45, 39, 33, 27, 21, 15, 9, 3, 61, 55, 49, 43, 37, 31, 25, 19, 13, 7, 1, 59, 53, 47, 41, 35, 29, 23, 17, 11, 5, 63, 57, 51, 45, 39, 33, 27, 21, 15, 9, 3, 61, 55]);
assert_eq!(plan.mask.iter().map(|p|p.0[0]).collect::<Vec<_>>(),vec![576460752303423487, 9007199254740991, 140737488355327, 2199023255551, 34359738367, 536870911, 8388607, 131071, 2047, 31, 9223372036854775807, 144115188075855871, 2251799813685247, 35184372088831, 549755813887, 8589934591, 134217727, 2097151, 32767, 511, 7, 2305843009213693951, 36028797018963967, 562949953421311, 8796093022207, 137438953471, 2147483647, 33554431, 524287, 8191, 127, 1, 576460752303423487, 9007199254740991, 140737488355327, 2199023255551, 34359738367, 536870911, 8388607, 131071, 2047, 31, 9223372036854775807, 144115188075855871, 2251799813685247, 35184372088831, 549755813887, 8589934591, 134217727, 2097151, 32767, 511, 7, 2305843009213693951, 36028797018963967]);

 for field in 0..4 {
  let mut bad=build_plan(&roots).unwrap();
  match field {0=>bad.full[0].cg^=1,1=>bad.pairs[0].q^=1,2=>bad.rot[0].0[3]^=1,_=>bad.mask[0].0[7]^=1}
  assert!(!fused_layout_matches(&bad));
 }
 let mut tile=Box::<Tile>::new_zeroed().assume_init();let prefetch=Box::<Tile>::new_zeroed().assume_init();
 let mut scratch=Box::<Scratch>::new_zeroed().assume_init();let mut random=0x6d9b999u64;let mut cases=0;
 for fixture in 0..8 {
  for v in &mut tile.0{*v=if fixture==0{0}else if fixture==1{u64::MAX}else{rng(&mut random)};}
  let raw=core::slice::from_raw_parts_mut((&mut *scratch as *mut Scratch).cast::<u64>(),core::mem::size_of::<Scratch>()/8);
  for v in raw{*v=rng(&mut random);}
  let original_tile=tile.0;let original_deps:Vec<u8>=core::slice::from_raw_parts(scratch.deps.as_ptr().cast::<u8>(),core::mem::size_of::<Scratch>()-core::mem::size_of::<Stage>()).to_vec();
  let w:[F128;64]=core::array::from_fn(|i|match fixture{0=>F128{lo:0,hi:0},1=>F128{lo:1,hi:0},2=>F128{lo:0,hi:1},3=>F128{lo:1u64<<(i%64),hi:1u64<<((i*7)%64)},_=>F128{lo:rng(&mut random),hi:rng(&mut random)}});
  let weights=Weights::new(&w);
  for o in 0..8 {
   let x=o%2;let mut pa=PfCur::new(((fixture+o)&1==0).then_some(prefetch.0.as_ptr() as usize));pa.cur+=if (fixture+o)&1==0{PF_BLAKE*64}else{0};pa.lim=pa.cur;
   let mut pb=PfCur::new(((fixture+o)&1==0).then_some(prefetch.0.as_ptr() as usize));pb.cur+=if (fixture+o)&1==0{PF_BLAKE*64}else{0};pb.lim=pb.cur;
   let expected=bits(baseline(&plan,tile.0.as_ptr().cast(),o,x,&mut scratch,&weights,&mut pa));
   let mut pc=PfCur{cur:pb.cur,lim:pb.lim,end:pb.end,num:pb.num,den:pb.den,acc:pb.acc};
   let got=bits(fold_octa_with_plan(&plan,tile.0.as_ptr().cast(),o,x,&mut scratch,&weights,&mut pb));
   plan.fused_layout=false;
   let fallback=bits(fold_octa_with_plan(&plan,tile.0.as_ptr().cast(),o,x,&mut scratch,&weights,&mut pc));
   plan.fused_layout=true;assert_eq!(fallback,expected);assert_eq!(pc.cur,pa.cur);
   assert_eq!(got,expected,"fused mismatch fixture={fixture} octa={o}");
   assert_eq!(pa.cur,pb.cur);assert_eq!(pa.cur,if (fixture+o)&1==0{prefetch.0.as_ptr() as usize+(PF_BLAKE+PF_FILL+PF_FOLD)*64}else{0});
   let stage=&*scratch.stage.0.as_ptr().cast::<[[u64;8];NQ]>();
   for h in 0..2 {for lane in 0..8 {
    let mut total=0u128;for e in 0..64{let q=128*h+2*e;let a=if q<NQ{stage[q][lane]as u128}else{0};let b=if q+1<NQ{stage[q+1][lane]as u128}else{0};total^=scalar_mul(a|(b<<64),(w[e].lo as u128)|((w[e].hi as u128)<<64));}
    let parity=lane%2;let vectorlane=lane/2;assert_eq!(got[h][parity][2*vectorlane]as u128|((got[h][parity][2*vectorlane+1]as u128)<<64),total);
   }}
   assert_eq!(tile.0,original_tile);assert_eq!(core::slice::from_raw_parts(scratch.deps.as_ptr().cast::<u8>(),original_deps.len()),original_deps.as_slice());
   cases+=1;
  }
 }
 assert_eq!(cases,64);println!("FUSED_ZREGEN_PASS cases={cases} field_outputs={} all_octa_offsets=true raw_tiles_deps_and_weights_arbitrary=true scalar_bitserial=true production_fill_and_fold_control=true input_immutable=true prefetch_span_exact=true full_and_no_next_tile=true forced_geometry_fallback=true four_guard_mutants_rejected=true",cases*16);
}}

}

    /// Original compression index of physical slot `p` in a tile view.
    #[inline(always)]
    fn compression(cross_quarter: bool, p: usize) -> usize {
        if cross_quarter {
            let g = p / 256;
            let kpair = (p % 256) / 8;
            let lane = p % 8;
            (lane / 2) * 65536 + (2 * kpair + lane % 2) * 1024 + g
        } else {
            p
        }
    }

    #[derive(Clone, Copy)]
    struct SendPtr<T>(*mut T);
    // SAFETY: each worker writes a disjoint set of destination slots.
    unsafe impl<T> Send for SendPtr<T> {}
    unsafe impl<T> Sync for SendPtr<T> {}

    /// Visit every octa of every tile with its z staged in qword-lane order,
    /// eight tiles per task (the cross-quarter outputs of compressions 2i and
    /// 2i+1 then stay within one task). Each task streams its 704 KiB of
    /// tiles sequentially, prefetching one tile ahead (also across task
    /// boundaries: rayon runs adjacent tasks on the same worker).
    fn for_each_octa(view: &WitnessTileView, f: impl Fn(&Stage, usize, usize, &mut PfCur) + Sync) {
        let plan = plan().expect("z regeneration plan");
        assert!(view.tiles > 0);
        if view.cross_quarter {
            assert_eq!(view.tiles * 64, 1 << 18);
        }
        let unit = if view.tiles % 8 == 0 { 8 } else { 1 };
        let base = view.base;
        let tiles = view.tiles;
        #[cfg(test)]
        let mode = TEST_MODE.load(std::sync::atomic::Ordering::Relaxed);
        #[cfg(not(test))]
        let mode = 0u8;
        thread_local! {
            // Reused across proofs: no per-task allocation/zeroing.
            static SCRATCH: core::cell::RefCell<Option<Box<Scratch>>> =
                const { core::cell::RefCell::new(None) };
        }
        assert_eq!(GROUPS * 8, TILE_BYTES / 64);
        (0..view.tiles / unit).into_par_iter().for_each(|u| {
            SCRATCH.with(|cell| {
                let mut guard = cell.borrow_mut();
                let scratch = guard.get_or_insert_with(Scratch::new);
                for t in u * unit..(u + 1) * unit {
                    let tile = (base + t * TILE_BYTES) as *const u8;
                    let next = (t + 1 < tiles).then(|| base + (t + 1) * TILE_BYTES);
                    for pair in 0..4 {
                        // While octa pair `pair` of this tile is processed,
                        // the same quarter of the next tile streams into L2.
                        let mut pf = PfCur::new(next.map(|n| n + 2 * pair * (TILE_BYTES / 8)));
                        // SAFETY: tiles are complete, initialized, 64-byte
                        // aligned; prefetch hints stay within the tile span.
                        // Mode bits (tests only) skip phases.
                        unsafe {
                            pf.phase(PF_BLAKE, 1);
                            if mode & 1 == 0 {
                                blake3_pair(tile, 2 * pair, scratch, &mut pf);
                            }
                            for x in 0..2 {
                                let o = 2 * pair + x;
                                pf.flush();
                                pf.phase(PF_FILL, FILL_OPS);
                                if mode & 2 == 0 {
                                    fill_stage(plan, tile, o, x, scratch, &mut pf);
                                }
                                pf.flush();
                                pf.phase(PF_FOLD, 1);
                                f(&scratch.stage, t, o, &mut pf);
                            }
                            pf.flush();
                        }
                    }
                }
            })
        });
    }

    /// Tests only: bit 0 skips BLAKE3, bit 1 skips staging.
    #[cfg(test)]
    pub(crate) static TEST_MODE: std::sync::atomic::AtomicU8 = std::sync::atomic::AtomicU8::new(0);

    /// `out[t] = Σ_{i<64} w[i] · z[64 t + i]` straight from the tiles.
    pub(crate) fn fold64(view: &WitnessTileView, out: &mut [F128], w: &[F128; 64]) {
        assert_eq!(out.len(), view.tiles * 64 * 2);
        let weights = Weights::new(w);
        let dst = SendPtr(out.as_mut_ptr());
        let cq = view.cross_quarter;
        for_each_folded_octa(view, &weights, |r, t, o| {
            let dst = dst;
            // SAFETY: AVX-512/VPCLMULQDQ are cfg preconditions; every
            // (compression, half) slot is written by exactly one octa; the
            // prefetch hints stay within the tile span.
            unsafe {
                let base = 64 * t + 8 * o;
                for (h, halves) in r.iter().enumerate() {
                    for (parity, v) in halves.iter().enumerate() {
                        let mut lanes = [F128::ZERO; 4];
                        _mm512_storeu_si512(lanes.as_mut_ptr().cast(), *v);
                        for (l, value) in lanes.into_iter().enumerate() {
                            let c = compression(cq, base + 2 * l + parity);
                            *dst.0.add(2 * c + h) = value;
                        }
                    }
                }
            }
        });
    }

    /// Write the complete canonical witness into `z` from the tiles.
    pub(crate) fn materialize(view: &WitnessTileView, z: &mut [F128]) {
        assert_eq!(z.len(), view.tiles * 64 * (K / 128));
        let dst = SendPtr(z.as_mut_ptr().cast::<u64>());
        let cq = view.cross_quarter;
        for_each_octa(view, |stage, t, o, _| {
            let dst = dst;
            // SAFETY: Stage is NQ ZMMs = NQ x 8 qwords; each compression's
            // 256 qwords are written by exactly one octa lane.
            unsafe {
                let words = &*(stage.0.as_ptr().cast::<[[u64; 8]; NQ]>());
                for j in 0..8 {
                    let c = compression(cq, 64 * t + 8 * o + j);
                    let row = dst.0.add(c * (K / 64));
                    for (q, w) in words.iter().enumerate() {
                        *row.add(q) = w[j];
                    }
                    for q in NQ..K / 64 {
                        *row.add(q) = 0;
                    }
                }
            }
        });
    }

    /// Timing decomposition hooks (tests only).
    #[cfg(test)]
    pub(crate) fn expand_only(view: &WitnessTileView) -> u64 {
        let acc = std::sync::atomic::AtomicU64::new(0);
        for_each_octa(view, |stage, t, o, _| {
            if t % 64 == 0 && o == 7 {
                // SAFETY: plain read of the initialized stage.
                let w = unsafe { *(stage.0.as_ptr().add(NQ - 2).cast::<u64>()) };
                acc.fetch_xor(w, std::sync::atomic::Ordering::Relaxed);
            }
        });
        acc.into_inner()
    }

    #[cfg(test)]
    pub(crate) fn read_only(view: &WitnessTileView) -> u64 {
        let n = view.tiles * TILE_BYTES / 64;
        let base = view.base;
        (0..n / 4096)
            .into_par_iter()
            .map(|c| {
                // SAFETY: in-bounds aligned reads of the live tile span.
                unsafe {
                    let mut x = _mm512_setzero_si512();
                    for i in c * 4096..(c + 1) * 4096 {
                        x = _mm512_xor_si512(x, _mm512_load_si512((base + i * 64) as *const __m512i));
                    }
                    _mm512_reduce_or_epi64(x) as u64
                }
            })
            .reduce(|| 0, |a, b| a ^ b)
    }

    enum Tiles {
        Installed(Arc<RootFoldSource>),
        Owned(WitnessRootTiles),
    }

    /// [`flock_core::pcs::elided_z::ZRegen`] over witness root tiles.
    pub(crate) struct TileRegen {
        tiles: Tiles,
    }

    impl TileRegen {
        /// Regenerator over tiles installed in `source` (shared with
        /// zerocheck/lincheck; kept alive until the open consumes it).
        pub(crate) fn installed(source: Arc<RootFoldSource>) -> Self {
            assert!(source.witness_root_tiles().and_then(|t| t.witness_view()).is_some());
            Self { tiles: Tiles::Installed(source) }
        }

        pub(crate) fn owned(tiles: WitnessRootTiles) -> Self {
            assert!(tiles.witness_view().is_some());
            Self { tiles: Tiles::Owned(tiles) }
        }

        pub(crate) fn view(&self) -> WitnessTileView {
            match &self.tiles {
                Tiles::Installed(s) => s.witness_root_tiles().and_then(|t| t.witness_view()),
                Tiles::Owned(t) => t.witness_view(),
            }
            .expect("witness tile view")
        }
    }

    impl flock_core::pcs::elided_z::ZRegen for TileRegen {
        fn fold64(&self, out: &mut [F128], w: &[F128; 64]) {
            fold64(&self.view(), out, w);
            super::REGEN_FOLDS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        }

        fn materialize(&self, z: &mut [F128]) {
            materialize(&self.view(), z);
            super::REGEN_MATERIALIZES.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        }
    }
}

#[cfg(all(
    test,
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "avx512bw",
    target_feature = "avx512vbmi",
    target_feature = "avx512vbmi2",
    target_feature = "gfni",
    target_feature = "vpclmulqdq"
))]
mod tests {
    use super::imp::TileRegen;
    use super::*;
    use flock_core::field::F128;
    use flock_core::pcs::elided_z::ZRegen;
    use rayon::prelude::*;

    fn weights(seed: u64) -> [F128; 64] {
        let mut s = seed;
        std::array::from_fn(|_| {
            s = s.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);
            let lo = s;
            s = s.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);
            F128::new(lo, s)
        })
    }

    fn reference_fold64(z: &[F128], w: &[F128; 64]) -> Vec<F128> {
        z.par_chunks(64)
            .map(|c| {
                let mut v = F128::ZERO;
                for (a, b) in c.iter().zip(w) {
                    v += *a * *b;
                }
                v
            })
            .collect()
    }

    fn check(z: &[F128], regen: &TileRegen, tag: &str) {
        let mut zr = vec![F128::new(0xdead, 0xbeef); z.len()];
        regen.materialize(&mut zr);
        let bad = z.iter().zip(&zr).position(|(a, b)| a != b);
        assert!(bad.is_none(), "{tag}: regenerated z differs at element {bad:?} (block {:?})", bad.map(|i| i / 128));
        for seed in [3u64, 0x5eed_0f_f01d] {
            let w = weights(seed);
            let mut got = vec![F128::ZERO; z.len() / 64];
            regen.fold64(&mut got, &w);
            assert!(got == reference_fold64(z, &w), "{tag}: fold64 mismatch (seed {seed})");
        }
    }

    /// Non-pipelined ranked witness (block-order tiles, dense z): the
    /// regenerated z and its fold64 match the witness bit for bit.
    #[test]
    #[ignore = "ranked-scale (~3 GiB); run serially on the benchmark host"]
    fn zregen_matches_ranked_witness_block_order() {
        use super::super::generate_witness_with_ab_packed_and_round1_inner_from;
        let pool = rayon::ThreadPoolBuilder::new().num_threads(16).build().unwrap();
        pool.install(|| {
            let mut checked = 0;
            for (pass, seed) in [0x953a_81c7u64, 0x953a_81c7, 0x1234_5678_9abc, 7].into_iter().enumerate() {
                let blocks = crate::seed_pipe::BlockSource::closed(18, seed);
                let (z, a, b, mut ab) = generate_witness_with_ab_packed_and_round1_inner_from(blocks, 18);
                if let Some(tiles) = ab.take_witness_root_tiles() {
                    assert!(!tiles.z_elided());
                    let regen = TileRegen::owned(tiles);
                    check(&z, &regen, &format!("block-order pass={pass} seed={seed:#x}"));
                    checked += 1;
                }
                flock_core::scratch::give_f128(z);
                flock_core::scratch::give_f128(a);
                flock_core::scratch::give_f128(b);
            }
            assert!(checked >= 3, "warm ranked witness must publish root tiles");
            println!("ZREGEN_BLOCK_ORDER_OK passes={checked}");
        });
    }

    /// Pipelined (committed) ranked witness: cross-quarter tiles. With
    /// elision forced off z is dense and must equal the regeneration; with
    /// elision on, the tiles are flagged and still regenerate the dense z.
    #[test]
    #[ignore = "ranked-scale (~5 GiB); run serially on the benchmark host"]
    fn zregen_matches_ranked_witness_cross_quarter() {
        let mut setup = super::super::Blake3Setup::new(1 << 18);
        // The ranked worker's transcript and Merkle hash.
        setup.pcs_params.merkle_hash = flock_core::hash::HashKind::Blake3;
        let params = setup.pcs_params.clone();
        let padding = setup.r1cs.padding_spec();
        let odd_tail = flock_core::ntt::additive_ntt_f128::ZeroOddTailLanes::lanes_for_padding(
            params.num_ntts(),
            padding.k_log,
            padding.useful_bits_per_block,
        );
        // Run from the test thread on the global pool: the paired seed
        // schedule (the only elidable producer) requires whole-pool custody.
        {
            let mut dense_checked = 0;
            let mut elided_checked = 0;
            for seed in [0xC0FFEEu64, 0xC0FFEE, 0x51DE_5EED] {
                let run = |elide: bool| {
                    FORCE_OFF.store(!elide, Ordering::Relaxed);
                    let codeword = vec![F128::ZERO; 1 << 26];
                    let (cw, (witness, a, b, mut ab)) = super::super::generate_witness_and_commit_from(
                        crate::seed_pipe::BlockSource::closed(18, seed),
                        18,
                        &params,
                        odd_tail,
                        Some(codeword),
                    );
                    FORCE_OFF.store(false, Ordering::Relaxed);
                    drop(cw);
                    let (z, committed) = witness.into_parts();
                    let root = committed.as_ref().map(|(c, _)| c.clone());
                    drop(committed);
                    flock_core::scratch::give_f128(a);
                    flock_core::scratch::give_f128(b);
                    (z, ab.take_witness_root_tiles(), root)
                };
                let (z, tiles, root_dense) = run(false);
                let Some(tiles) = tiles else {
                    flock_core::scratch::give_f128(z);
                    continue;
                };
                assert!(!tiles.z_elided());
                let cq = tiles.witness_view().unwrap().cross_quarter;
                check(&z, &TileRegen::owned(tiles), &format!("dense seed={seed:#x} cq={cq}"));
                dense_checked += usize::from(cq);
                let (mut z2, tiles2, root_elided) = run(true);
                if let Some(tiles2) = tiles2 {
                    if tiles2.z_elided() {
                        assert_eq!(format!("{root_dense:?}"), format!("{root_elided:?}"), "commitment changed under elision");
                        let regen = TileRegen::owned(tiles2);
                        let mut got = vec![F128::ZERO; z.len() / 64];
                        let w = weights(seed);
                        regen.fold64(&mut got, &w);
                        assert!(got == reference_fold64(&z, &w), "elided fold64 mismatch seed={seed:#x}");
                        regen.materialize(&mut z2);
                        assert!(z2 == z, "elided materialize mismatch seed={seed:#x}");
                        elided_checked += 1;
                    }
                }
                flock_core::scratch::give_f128(z);
                flock_core::scratch::give_f128(z2);
            }
            assert!(dense_checked >= 1, "no cross-quarter tiles were produced");
            assert!(elided_checked >= 1, "elision never engaged");
            println!("ZREGEN_CROSS_QUARTER_OK dense={dense_checked} elided={elided_checked}");
        }
    }

    /// End to end: the ranked prove with z elision produces the same proof
    /// bytes as the dense witness, and actually folds from the regenerator.
    #[test]
    #[ignore = "ranked-scale prove; run serially on the benchmark host"]
    fn zregen_full_proof_bytes_identical() {
        use std::sync::atomic::Ordering::Relaxed;
        let mut setup = super::super::Blake3Setup::new(1 << 18);
        // The ranked worker's transcript and Merkle hash.
        setup.pcs_params.merkle_hash = flock_core::hash::HashKind::Blake3;
        {
            let prove = |elide: bool, seed: u64| {
                FORCE_OFF.store(!elide, Relaxed);
                let mut ch = crate::challenger::FsChallenger::with_hash(
                    b"zr-proof-identity",
                    flock_core::hash::HashKind::Blake3,
                );
                let (proof, commitment, _claim) =
                    setup.prove_fast_inner(crate::seed_pipe::BlockSource::closed(18, seed), &mut ch);
                FORCE_OFF.store(false, Relaxed);
                crate::proof_io::R1csProofBundleLigerito { commitment, proof }.to_bytes()
            };
            // Warm the scratch pool so the pipelined (elidable) commit runs.
            let _ = prove(false, 1);
            let _ = prove(true, 2);
            let mut engaged = 0;
            for seed in [0x5eed_0001u64, 0x5eed_0002, 0x5eed_0003] {
                let dense = prove(false, seed);
                let folds = REGEN_FOLDS.load(Relaxed);
                let mats = REGEN_MATERIALIZES.load(Relaxed);
                let elided = prove(true, seed);
                let used_fold = REGEN_FOLDS.load(Relaxed) - folds;
                let used_mat = REGEN_MATERIALIZES.load(Relaxed) - mats;
                assert!(dense == elided, "proof bytes differ under z elision (seed {seed:#x}, folds {used_fold}, materializes {used_mat})");
                println!("ZREGEN_PROOF seed={seed:#x} bytes={} regen_folds={used_fold} fallback_materializes={used_mat}", dense.len());
                engaged += used_fold;
            }
            assert!(engaged >= 1, "z elision never reached the regenerator fold");
            println!("ZREGEN_PROOF_OK engaged={engaged}");
        }
    }

    /// Timing decomposition on the production (cross-quarter) tile layout:
    /// dense fold of z vs regenerated fold, expansion only, tile read only.
    #[test]
    #[ignore = "ranked-scale timing; run alone on the benchmark host"]
    fn zregen_timing() {
        let mut setup = super::super::Blake3Setup::new(1 << 18);
        setup.pcs_params.merkle_hash = flock_core::hash::HashKind::Blake3;
        let params = setup.pcs_params.clone();
        let padding = setup.r1cs.padding_spec();
        let odd_tail = flock_core::ntt::additive_ntt_f128::ZeroOddTailLanes::lanes_for_padding(
            params.num_ntts(),
            padding.k_log,
            padding.useful_bits_per_block,
        );
        let mut found = None;
        for seed in 11u64..19 {
            FORCE_OFF.store(true, Ordering::Relaxed);
            let (cw, (witness, a, b, mut ab)) = super::super::generate_witness_and_commit_from(
                crate::seed_pipe::BlockSource::closed(18, seed),
                18,
                &params,
                odd_tail,
                Some(vec![F128::ZERO; 1 << 26]),
            );
            FORCE_OFF.store(false, Ordering::Relaxed);
            drop(cw);
            let (z, committed) = witness.into_parts();
            drop(committed);
            flock_core::scratch::give_f128(a);
            flock_core::scratch::give_f128(b);
            if let Some(t) = ab.take_witness_root_tiles() {
                if t.witness_view().unwrap().cross_quarter {
                    found = Some((z, t));
                    break;
                }
            }
            // Return z to the tagged pool so the warm exact producer engages.
            flock_core::scratch::give_f128(z);
        }
        let (z, tiles) = found.expect("cross-quarter tiles");
        let regen = TileRegen::owned(tiles);
        let view = regen.view();
        let w16: [F128; 16] = std::array::from_fn(|i| weights(5)[i]);
        let (r4, r5) = (F128::new(0x1234, 0x5678), F128::new(0x9abc, 0xdef0));
        let e4 = [F128::ONE + r4, r4];
        let e5 = [F128::ONE + r5, r5];
        let w: [F128; 64] = std::array::from_fn(|i| w16[i & 15] * e4[(i >> 4) & 1] * e5[i >> 5]);
        let mut dense = vec![F128::ZERO; z.len() / 64];
        let mut regd = vec![F128::ZERO; z.len() / 64];
        let time = |f: &mut dyn FnMut()| {
            let mut v: Vec<f64> = (0..9)
                .map(|_| {
                    let t = std::time::Instant::now();
                    f();
                    t.elapsed().as_secs_f64() * 1e3
                })
                .collect();
            v.sort_by(|a, b| a.partial_cmp(b).unwrap());
            (v[0], v[4])
        };
        let mut sink = 0u64;
        let td = time(&mut || flock_core::pcs::ligerito::bench_direct_fold8_f_dense(&z, &mut dense, &w16, r4, r5));
        let tr = time(&mut || regen.fold64(&mut regd, &w));
        let te = time(&mut || sink ^= super::imp::expand_only(&view));
        let tt = time(&mut || sink ^= super::imp::read_only(&view));
        assert!(dense == regd, "timing fold mismatch");
        println!(
            "ZREGEN_TIMING dense_fold min={:.3} med={:.3} | regen_fold min={:.3} med={:.3} | expand_only min={:.3} med={:.3} | tile_read min={:.3} med={:.3} ms (sink {sink:x})",
            td.0, td.1, tr.0, tr.1, te.0, te.1, tt.0, tt.1
        );
        let mut parts = Vec::new();
        for (mode, name) in [(1u8, "no_blake3"), (2, "no_stage"), (3, "fold_only")] {
            super::imp::TEST_MODE.store(mode, Ordering::Relaxed);
            let tf = time(&mut || regen.fold64(&mut regd, &w));
            let tx = time(&mut || sink ^= super::imp::expand_only(&view));
            parts.push(format!("{name}: fold {:.3}/{:.3} expand {:.3}/{:.3}", tf.0, tf.1, tx.0, tx.1));
        }
        super::imp::TEST_MODE.store(0, Ordering::Relaxed);
        println!("ZREGEN_PARTS {} (min/med ms, sink {sink:x})", parts.join(" | "));
    }
}
