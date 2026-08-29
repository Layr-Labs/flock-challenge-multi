//! GENERATED static-B plan for the x86 AVX-512/GFNI round-1 shift-reduce
//! kernel — the same census data as the mac track's `aarch64_bstatic_gen.rs`
//! (blocks 0..=30 are byte-identical to that file's `BSTATIC_MASKS`), plus
//! block 31 (window 1, `b_med = 15`: the all-zero padding window that the
//! streaming witness seam still computes) and one all-generic control plan
//! (index 32) for same-binary A/B.
//!
//! Produced by `flock_prover::r1cs_hashes::blake3::tests::bstatic_census`
//! (2^12 ranked-distribution BLAKE3 blocks: `block_len = 64`, `flags = 11`,
//! u32 counter — the harness generator's exact shape) at the ranked layout
//! `k_log = 14`, `useful_bits = 15409`. The `(mask, expected)` pairs describe
//! bytes of the round-1 **b operand** that the BLAKE3 circuit fixes
//! independently of the block inputs (const-one wires and structural zeros).
//!
//! They are ONLY a performance hint: every planned K-row checks
//! `(b_word & mask) == expected` and falls back to the generic row when the
//! witness disagrees, so the kernel is bit-exact for any witness and any
//! layout. `kind` / `vary` are derived from `mask` at generation time:
//!   * `ROW_ZERO`    — mask covers all 64 bits and expected == 0 ⇒ the b row is
//!                     structurally zero ⇒ the whole K-row contributes nothing.
//!   * `ROW_STATIC`  — ≤ 6 varying bytes: `T(b) = T(expected) ⊕ Σ_{j∈vary} π_j(T₀[b_j])`.
//!                     `vary` is the bitmask of varying byte positions.
//!   * `ROW_GENERIC` — no useful static structure (or > 6 varying bytes).

/// One planned K-row.
#[derive(Clone, Copy)]
pub(crate) struct BstaticRow {
    pub(crate) mask: u64,
    pub(crate) expected: u64,
    pub(crate) kind: u8,
    /// Bit `j` set ⇒ byte `j` of the b word varies (only meaningful for `ROW_STATIC`).
    pub(crate) vary: u8,
}

pub(crate) const ROW_GENERIC: u8 = 0;
pub(crate) const ROW_STATIC: u8 = 1;
pub(crate) const ROW_ZERO: u8 = 2;

/// Number of BLAKE3 `(w, b_med)` blocks with a plan (`blk = w * 16 + b_med`).
pub(crate) const BSTATIC_BLOCKS: usize = 32;
/// Index of the all-generic control plan (tests / microbenchmarks only).
#[cfg(test)]
pub(crate) const BSTATIC_GENERIC_PLAN: usize = 32;

const fn row(mask: u64, expected: u64) -> BstaticRow {
    if mask == 0 {
        return BstaticRow {
            mask,
            expected,
            kind: ROW_GENERIC,
            vary: 0,
        };
    }
    if mask == u64::MAX && expected == 0 {
        return BstaticRow {
            mask,
            expected,
            kind: ROW_ZERO,
            vary: 0,
        };
    }
    let mut vary = 0u8;
    let mut j = 0;
    while j < 8 {
        if (mask >> (8 * j)) & 0xff == 0 {
            vary |= 1 << j;
        }
        j += 1;
    }
    if vary.count_ones() <= 6 {
        BstaticRow {
            mask,
            expected,
            kind: ROW_STATIC,
            vary,
        }
    } else {
        BstaticRow {
            mask,
            expected,
            kind: ROW_GENERIC,
            vary: 0,
        }
    }
}

const G: BstaticRow = BstaticRow {
    mask: 0,
    expected: 0,
    kind: ROW_GENERIC,
    vary: 0,
};

#[rustfmt::skip]
pub(crate) const BSTATIC_PLAN: [[BstaticRow; 8]; 33] = [
    [ // blk 0: w = 0, b_med = 0
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
    ],
    [ // blk 1: w = 0, b_med = 1
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
    ],
    [ // blk 2: w = 0, b_med = 2
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 3: w = 0, b_med = 3
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 4: w = 0, b_med = 4
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 5: w = 0, b_med = 5
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 6: w = 0, b_med = 6
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 7: w = 0, b_med = 7
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 8: w = 0, b_med = 8
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
    ],
    [ // blk 9: w = 0, b_med = 9
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
    ],
    [ // blk 10: w = 0, b_med = 10
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
    ],
    [ // blk 11: w = 0, b_med = 11
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
    ],
    [ // blk 12: w = 0, b_med = 12
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
    ],
    [ // blk 13: w = 0, b_med = 13
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
    ],
    [ // blk 14: w = 0, b_med = 14
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
    ],
    [ // blk 15: w = 0, b_med = 15
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
    ],
    [ // blk 16: w = 1, b_med = 0
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
    ],
    [ // blk 17: w = 1, b_med = 1
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 18: w = 1, b_med = 2
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 19: w = 1, b_med = 3
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 20: w = 1, b_med = 4
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 21: w = 1, b_med = 5
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 22: w = 1, b_med = 6
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 23: w = 1, b_med = 7
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 24: w = 1, b_med = 8
        row(0xff00000000000000, 0xff00000000000000),
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffff000000000000, 0xffff000000000000),
        row(0x000000ffffffffff, 0x000000ffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 25: w = 1, b_med = 9
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffff0000000000, 0xffffff0000000000),
        row(0x00000000ffffffff, 0x00000000ffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 26: w = 1, b_med = 10
        row(0xffffffff00000000, 0xffffffff00000000),
        row(0x0000000000ffffff, 0x0000000000ffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffff000000, 0xffffffffff000000),
        row(0x000000000000ffff, 0x000000000000ffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 27: w = 1, b_med = 11
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xffffffffffff0000, 0xffffffffffff0000),
        row(0x00000000000000ff, 0x00000000000000ff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
    ],
    [ // blk 28: w = 1, b_med = 12
        row(0xffffffffffffff00, 0xffffffffffffff00),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x00ffffffffffffff, 0x00ffffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
    ],
    [ // blk 29: w = 1, b_med = 13
        row(0x0000ffffffffffff, 0x0000ffffffffffff),
        row(0x0000000000000000, 0x0000000000000000),
        row(0x0000000000000000, 0x0000000000000000),
        row(0xff00000000000000, 0xff00000000000000),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
        row(0xffffffffffffffff, 0xffffffffffffffff),
    ],
    [ // blk 30: w = 1, b_med = 14
        row(0xffffffffffffffff, 0x0001ffffffffffff),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
    ],
    [ // blk 31: w = 1, b_med = 15
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
        row(0xffffffffffffffff, 0x0000000000000000),
    ],
    [G, G, G, G, G, G, G, G], // all-generic control plan
];

/// Dense B bytes belonging to one ranked BLAKE3 circuit block.
pub const RANKED_B_DENSE_BYTES_PER_BLOCK: usize = 2048;
/// One census line is eight packed rows, hence one cache line.
pub const RANKED_B_PLAN_LINES: usize = 32;

/// How one dense 64-byte B line is represented in the compact stream.
///
/// Bytes whose `load_mask` bit is set appear consecutively in the stream;
/// all other bytes come from `base`. Lines 0..29 use an all-one base, line 30
/// uses its exact fixed census line (including its lone `0x01` byte), and line
/// 31 uses zero. Line 30 deliberately reloads six already-fixed bytes as
/// alignment padding: the resulting 1,364-byte block makes every 16-block
/// witness group an integer 341 cache lines without changing reconstruction.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RankedBCompactLine {
    pub load_mask: u64,
    pub offset: u16,
    pub base: u8,
}

impl RankedBCompactLine {
    pub const fn len(self) -> usize {
        self.load_mask.count_ones() as usize
    }
}

const EMPTY_COMPACT_LINE: RankedBCompactLine = RankedBCompactLine {
    load_mask: 0,
    offset: 0,
    base: 0,
};

pub const RANKED_B_BASE_ZERO: u8 = 0;
pub const RANKED_B_BASE_ONES: u8 = 1;
pub const RANKED_B_BASE_EXPECTED: u8 = 2;

pub const RANKED_B_LINE30_EXPECTED_U64: [u64; 8] = [
    BSTATIC_PLAN[30][0].expected,
    BSTATIC_PLAN[30][1].expected,
    BSTATIC_PLAN[30][2].expected,
    BSTATIC_PLAN[30][3].expected,
    BSTATIC_PLAN[30][4].expected,
    BSTATIC_PLAN[30][5].expected,
    BSTATIC_PLAN[30][6].expected,
    BSTATIC_PLAN[30][7].expected,
];

const fn build_ranked_b_compact_plan() -> ([RankedBCompactLine; 32], usize) {
    let mut out = [EMPTY_COMPACT_LINE; RANKED_B_PLAN_LINES];
    let mut offset = 0usize;
    let mut line = 0usize;
    while line < RANKED_B_PLAN_LINES {
        let base = if line < 30 {
            RANKED_B_BASE_ONES
        } else if line == 30 {
            RANKED_B_BASE_EXPECTED
        } else {
            RANKED_B_BASE_ZERO
        };
        let mut load_mask = 0u64;
        let mut row = 0usize;
        while row < 8 {
            let p = BSTATIC_PLAN[line][row];
            let mut byte = 0usize;
            while byte < 8 {
                let fixed = ((p.mask >> (8 * byte)) & 0xff) as u8;
                let expected = ((p.expected >> (8 * byte)) & 0xff) as u8;
                // The generated census is byte-granular. A variable byte is
                // loaded; every fixed byte must match the selected base.
                assert!(fixed == 0 || fixed == 0xff);
                let bit = 1u64 << (8 * row + byte);
                if fixed == 0 {
                    load_mask |= bit;
                } else if base == RANKED_B_BASE_ONES {
                    assert!(expected == 0xff);
                } else if base == RANKED_B_BASE_ZERO {
                    assert!(expected == 0);
                }
                byte += 1;
            }
            row += 1;
        }
        // Line 30 is already completely described by its expected base.
        // Re-loading its first six bytes is harmless alignment payload that
        // makes 16 consecutive compact blocks end on a cache-line boundary.
        if line == 30 {
            assert!(load_mask == 0);
            load_mask = 0x3f;
        }
        assert!(offset <= u16::MAX as usize);
        out[line] = RankedBCompactLine {
            load_mask,
            offset: offset as u16,
            base,
        };
        offset += load_mask.count_ones() as usize;
        line += 1;
    }
    (out, offset)
}

const RANKED_B_COMPACT_BUILD: ([RankedBCompactLine; 32], usize) =
    build_ranked_b_compact_plan();

pub const RANKED_B_COMPACT_PLAN: [RankedBCompactLine; 32] = RANKED_B_COMPACT_BUILD.0;
pub const RANKED_B_COMPACT_BYTES_PER_BLOCK: usize = RANKED_B_COMPACT_BUILD.1;

const _: () = {
    assert!(RANKED_B_COMPACT_BYTES_PER_BLOCK == 1364);
    assert!((16 * RANKED_B_COMPACT_BYTES_PER_BLOCK).is_multiple_of(64));
};

#[inline]
fn compact_base_byte(line_idx: usize, plan: RankedBCompactLine, byte: usize) -> u8 {
    match plan.base {
        RANKED_B_BASE_ZERO => 0,
        RANKED_B_BASE_ONES => 0xff,
        RANKED_B_BASE_EXPECTED => {
            let row = byte / 8;
            let within = byte % 8;
            (BSTATIC_PLAN[line_idx][row].expected >> (8 * within)) as u8
        }
        _ => unreachable!("invalid ranked B compact base"),
    }
}

/// Portable oracle/producer for one block. The caller must supply dense bytes
/// that obey the census; arbitrary bytes in fixed positions would be replaced
/// by the protocol constants during expansion and are therefore rejected.
pub fn pack_ranked_b_block(dense: &[u8], compact: &mut [u8]) {
    assert_eq!(dense.len(), RANKED_B_DENSE_BYTES_PER_BLOCK);
    assert_eq!(compact.len(), RANKED_B_COMPACT_BYTES_PER_BLOCK);
    for (line_idx, plan) in RANKED_B_COMPACT_PLAN.iter().copied().enumerate() {
        let src = &dense[64 * line_idx..64 * (line_idx + 1)];
        let mut dst = plan.offset as usize;
        for (byte, value) in src.iter().copied().enumerate() {
            if plan.load_mask >> byte & 1 != 0 {
                compact[dst] = value;
                dst += 1;
            } else {
                assert_eq!(
                    value,
                    compact_base_byte(line_idx, plan, byte),
                    "ranked B census mismatch"
                );
            }
        }
        assert_eq!(dst, plan.offset as usize + plan.len());
    }
}

/// Portable expansion oracle for one compact block.
pub fn unpack_ranked_b_block(compact: &[u8], dense: &mut [u8]) {
    assert_eq!(compact.len(), RANKED_B_COMPACT_BYTES_PER_BLOCK);
    assert_eq!(dense.len(), RANKED_B_DENSE_BYTES_PER_BLOCK);
    for (line_idx, plan) in RANKED_B_COMPACT_PLAN.iter().copied().enumerate() {
        let dst = &mut dense[64 * line_idx..64 * (line_idx + 1)];
        for (byte, value) in dst.iter_mut().enumerate() {
            *value = compact_base_byte(line_idx, plan, byte);
        }
        let mut src = plan.offset as usize;
        for (byte, value) in dst.iter_mut().enumerate() {
            if plan.load_mask >> byte & 1 != 0 {
                *value = compact[src];
                src += 1;
            }
        }
        assert_eq!(src, plan.offset as usize + plan.len());
    }
}

#[cfg(test)]
mod compact_tests {
    use super::*;

    #[test]
    fn ranked_b_compact_plan_round_trips_census() {
        let mut dense = [0u8; RANKED_B_DENSE_BYTES_PER_BLOCK];
        for (line_idx, rows) in BSTATIC_PLAN[..RANKED_B_PLAN_LINES].iter().enumerate() {
            for (row_idx, row) in rows.iter().enumerate() {
                for byte in 0..8 {
                    let fixed = ((row.mask >> (8 * byte)) & 0xff) as u8;
                    let expected = ((row.expected >> (8 * byte)) & 0xff) as u8;
                    dense[64 * line_idx + 8 * row_idx + byte] = if fixed == 0 {
                        (17 * line_idx + 11 * row_idx + 29 * byte + 3) as u8
                    } else {
                        expected
                    };
                }
            }
        }
        let mut compact = [0u8; RANKED_B_COMPACT_BYTES_PER_BLOCK];
        pack_ranked_b_block(&dense, &mut compact);
        let mut expanded = [0u8; RANKED_B_DENSE_BYTES_PER_BLOCK];
        unpack_ranked_b_block(&compact, &mut expanded);
        assert_eq!(expanded, dense);
        assert_eq!(RANKED_B_COMPACT_PLAN[0].len(), 0);
        assert_eq!(RANKED_B_COMPACT_PLAN[1].len(), 0);
        assert_eq!(RANKED_B_COMPACT_PLAN[30].len(), 6);
        assert_eq!(RANKED_B_COMPACT_PLAN[31].len(), 0);
    }
}
