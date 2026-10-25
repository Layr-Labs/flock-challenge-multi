//! Private packed A/B representation shared by ranked witness production and
//! rounds two through four. Z and all protocol-visible arrays stay canonical.
//!
//! An octa contains eight 2048-byte witness blocks. Its address order is
//! `[window:32][row:8][byte:8][block:8]`. Every A row and the B rows selected
//! below store `p[j] = XOR(x[t] for t superset j)`; other B rows store raw
//! bytes. This transform is its own inverse over characteristic two.

use crate::field::F128;
use rayon::prelude::*;

pub const BLOCK_BYTES: usize = 2048;
pub const OCTA_BYTES: usize = 8 * BLOCK_BYTES;
pub const WINDOW_BYTES: usize = 512;

/// Layout of the original packed A/B owners, independent of round-one AB
/// projection storage. A producer may brand it only after both are complete.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub enum PackedAbLayout {
    #[default]
    Canonical,
    PreparedOctaV1,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum PreparedAbSide {
    A,
    B,
}

/// Modes of the current ranked projection producer: bit k is set exactly
/// when window_mode(window, k) == 0. Windows 0, 1, 30 and 31 retain raw B.
/// The production-kernel test checks this complete table against that builder.
pub const PREPARED_B_MASKS: [u8; 32] = [
    0, 0, 220, 204, 204, 204, 204, 238, 102, 102, 102, 102, 118, 51, 51, 51, 51, 187, 155, 153,
    153, 153, 217, 221, 204, 204, 204, 204, 110, 6, 0, 0,
];

impl PreparedAbSide {
    #[inline]
    pub const fn prepared_mask(self, window: usize) -> u8 {
        assert!(window < 32);
        match self {
            Self::A => 0xff,
            Self::B => PREPARED_B_MASKS[window],
        }
    }

    /// Version three is separate from canonical witgen's version two. The
    /// length and role remain explicit: a canonical pool hit cannot authorize
    /// omitting constant writes in this representation (or vice versa).
    pub fn scratch_tag(self, n_f128: usize) -> u64 {
        assert_eq!(n_f128 % (OCTA_BYTES / size_of::<F128>()), 0);
        assert!((n_f128 as u128) < (1u128 << 56));
        let role = match self {
            Self::A => 2,
            Self::B => 3,
        };
        (3u64 << 60) | (role << 56) | n_f128 as u64
    }
}

#[inline]
fn zeta_row(row: &mut [u8; 64]) {
    for axis in [1, 2, 4] {
        for byte in 0..8 {
            if byte & axis == 0 {
                for block in 0..8 {
                    row[8 * byte + block] ^= row[8 * (byte | axis) + block];
                }
            }
        }
    }
}

fn encode_octa(side: PreparedAbSide, canonical: &[u8], prepared: &mut [u8]) {
    for window in 0..32 {
        let mask = side.prepared_mask(window);
        for k in 0..8 {
            let mut row = [0u8; 64];
            for byte in 0..8 {
                for block in 0..8 {
                    row[8 * byte + block] =
                        canonical[block * BLOCK_BYTES + window * 64 + k * 8 + byte];
                }
            }
            if (mask >> k) & 1 != 0 {
                zeta_row(&mut row);
            }
            let off = window * WINDOW_BYTES + k * 64;
            prepared[off..off + 64].copy_from_slice(&row);
        }
    }
}

/// Cold producer adapter. Each octa has the same extent before and after the
/// permutation, so a bounded local copy suffices; no whole-table clone is
/// needed. The caller must replace its provenance tag after this mutation.
pub fn prepare_in_place(side: PreparedAbSide, bytes: &mut [u8]) {
    assert_eq!(bytes.len() % OCTA_BYTES, 0);
    bytes.par_chunks_mut(OCTA_BYTES).for_each(|out| {
        let mut canonical = [0u8; OCTA_BYTES];
        canonical.copy_from_slice(out);
        encode_octa(side, &canonical, out);
    });
}

/// Materialize a canonical view for any consumer that cannot use the private
/// layout. The original prepared owner remains unchanged, including its tag.
pub fn canonicalize_into(side: PreparedAbSide, prepared: &[u8], canonical: &mut [u8]) {
    assert_eq!(prepared.len(), canonical.len());
    assert_eq!(prepared.len() % OCTA_BYTES, 0);
    prepared
        .par_chunks(OCTA_BYTES)
        .zip(canonical.par_chunks_mut(OCTA_BYTES))
        .for_each(|(src, dst)| {
            for window in 0..32 {
                let mask = side.prepared_mask(window);
                for k in 0..8 {
                    let off = window * WINDOW_BYTES + k * 64;
                    let mut row = [0u8; 64];
                    row.copy_from_slice(&src[off..off + 64]);
                    if (mask >> k) & 1 != 0 {
                        zeta_row(&mut row);
                    }
                    for byte in 0..8 {
                        for block in 0..8 {
                            dst[block * BLOCK_BYTES + window * 64 + k * 8 + byte] =
                                row[8 * byte + block];
                        }
                    }
                }
            }
        });
}

/// A canonical pair borrowed from existing inputs, or restored into temporary
/// scratch owners. The originals are never mutated or returned to the pool.
pub struct CanonicalAb<'a> {
    borrowed: Option<(&'a [u8], &'a [u8])>,
    restored: Option<(Vec<F128>, Vec<F128>)>,
}

fn field_bytes(values: &[F128]) -> &[u8] {
    // F128 is a pair of u64s with no padding and all bit patterns are valid.
    unsafe { core::slice::from_raw_parts(values.as_ptr().cast(), size_of_val(values)) }
}

fn restore(side: PreparedAbSide, bytes: &[u8]) -> Vec<F128> {
    let mut values = crate::scratch::take_f128(bytes.len() / size_of::<F128>());
    // Every byte is filled by canonicalize_into before any F128 is read.
    let dst = unsafe { core::slice::from_raw_parts_mut(values.as_mut_ptr().cast(), bytes.len()) };
    canonicalize_into(side, bytes, dst);
    values
}

impl<'a> CanonicalAb<'a> {
    pub fn new(layout: PackedAbLayout, a: &'a [u8], b: &'a [u8]) -> Self {
        assert_eq!(a.len(), b.len());
        match layout {
            PackedAbLayout::Canonical => Self {
                borrowed: Some((a, b)),
                restored: None,
            },
            PackedAbLayout::PreparedOctaV1 => {
                assert_eq!(a.len() % OCTA_BYTES, 0);
                Self {
                    borrowed: None,
                    restored: Some((restore(PreparedAbSide::A, a), restore(PreparedAbSide::B, b))),
                }
            }
        }
    }

    pub fn a(&self) -> &[u8] {
        if let Some((a, _)) = self.borrowed {
            a
        } else {
            field_bytes(&self.restored.as_ref().unwrap().0)
        }
    }

    pub fn b(&self) -> &[u8] {
        if let Some((_, b)) = self.borrowed {
            b
        } else {
            field_bytes(&self.restored.as_ref().unwrap().1)
        }
    }
}

impl Drop for CanonicalAb<'_> {
    fn drop(&mut self) {
        if let Some((a, b)) = self.restored.take() {
            crate::scratch::give_f128(a);
            crate::scratch::give_f128(b);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn data(n: usize, mut state: u64) -> Vec<u8> {
        (0..n)
            .map(|_| {
                state ^= state << 13;
                state ^= state >> 7;
                state ^= state << 17;
                state as u8
            })
            .collect()
    }

    // Independent direct subset sum, without the production butterfly.
    fn oracle_encode(side: PreparedAbSide, src: &[u8]) -> Vec<u8> {
        let mut out = vec![0; src.len()];
        for octa in 0..src.len() / OCTA_BYTES {
            for w in 0..32 {
                for k in 0..8 {
                    for j in 0..8 {
                        for b in 0..8 {
                            let mut v = 0;
                            for t in 0..8 {
                                let selected = if (side.prepared_mask(w) >> k) & 1 != 0 {
                                    t & j == j
                                } else {
                                    t == j
                                };
                                if selected {
                                    v ^= src
                                        [octa * OCTA_BYTES + b * BLOCK_BYTES + w * 64 + k * 8 + t];
                                }
                            }
                            out[octa * OCTA_BYTES + w * WINDOW_BYTES + k * 64 + j * 8 + b] = v;
                        }
                    }
                }
            }
        }
        out
    }

    #[test]
    fn prepared_octa_basis_orientation() {
        for pos in 0..64 {
            for bit in 0..8 {
                let mut actual = [0u8; 64];
                actual[pos] = 1 << bit;
                let original = actual;
                zeta_row(&mut actual);
                for j in 0..8 {
                    for b in 0..8 {
                        let expected = if b == pos % 8 && (pos / 8) & j == j {
                            1 << bit
                        } else {
                            0
                        };
                        assert_eq!(actual[8 * j + b], expected);
                    }
                }
                zeta_row(&mut actual);
                assert_eq!(actual, original);
            }
        }
    }

    #[test]
    fn prepared_octa_matches_oracle_and_restores_with_halos() {
        for side in [PreparedAbSide::A, PreparedAbSide::B] {
            for octas in [1, 4] {
                for offset in [0, 1, 7, 63] {
                    let n = OCTA_BYTES * octas;
                    let original = data(n, 0x678b_114f + offset as u64);
                    let expected = oracle_encode(side, &original);
                    let mut encoded = vec![0x79; offset + n + 65];
                    encoded[offset..offset + n].copy_from_slice(&original);
                    prepare_in_place(side, &mut encoded[offset..offset + n]);
                    assert_eq!(&encoded[offset..offset + n], expected);
                    assert!(
                        encoded[..offset]
                            .iter()
                            .chain(&encoded[offset + n..])
                            .all(|&x| x == 0x79)
                    );
                    let mut decoded = vec![0xa6; offset + n + 65];
                    canonicalize_into(
                        side,
                        &encoded[offset..offset + n],
                        &mut decoded[offset..offset + n],
                    );
                    assert_eq!(&decoded[offset..offset + n], original);
                    assert!(
                        decoded[..offset]
                            .iter()
                            .chain(&decoded[offset + n..])
                            .all(|&x| x == 0xa6)
                    );
                }
            }
        }
    }

    #[test]
    fn prepared_octa_canonical_pair_preserves_original_owners() {
        let a = data(2 * OCTA_BYTES, 0x1974);
        let b = data(a.len(), 0x8713);
        let borrowed = CanonicalAb::new(PackedAbLayout::Canonical, &a, &b);
        assert_eq!(borrowed.a().as_ptr(), a.as_ptr());
        assert_eq!(borrowed.b().as_ptr(), b.as_ptr());
        let pa = oracle_encode(PreparedAbSide::A, &a);
        let pb = oracle_encode(PreparedAbSide::B, &b);
        let before = (pa.clone(), pb.clone());
        {
            let restored = CanonicalAb::new(PackedAbLayout::PreparedOctaV1, &pa, &pb);
            assert_eq!(restored.a(), a);
            assert_eq!(restored.b(), b);
        }
        assert_eq!((pa, pb), before);
    }

    #[test]
    fn prepared_octa_provenance_separates_role_length_and_layout() {
        let mut tags = std::collections::BTreeSet::new();
        for octas in [1, 2, 32768] {
            let n = OCTA_BYTES / size_of::<F128>() * octas;
            for side in [PreparedAbSide::A, PreparedAbSide::B] {
                assert!(tags.insert(side.scratch_tag(n)));
                let role = if side == PreparedAbSide::A { 2 } else { 3 };
                assert!(tags.insert((2u64 << 60) | (role << 56) | n as u64));
            }
        }
    }

    #[test]
    #[should_panic]
    fn prepared_octa_rejects_partial_octa() {
        prepare_in_place(PreparedAbSide::A, &mut [0u8; OCTA_BYTES - 1]);
    }

    #[test]
    #[should_panic]
    fn prepared_octa_rejects_mismatched_destination() {
        canonicalize_into(
            PreparedAbSide::B,
            &[0u8; OCTA_BYTES],
            &mut [0u8; OCTA_BYTES - 1],
        );
    }
}

/// Convert a completely initialized canonical owner after a cold generation.
/// Provenance must be registered only after both sides have been converted.
pub fn prepare_fields_in_place(side: PreparedAbSide, values: &mut [F128]) {
    let bytes =
        unsafe { core::slice::from_raw_parts_mut(values.as_mut_ptr().cast(), size_of_val(values)) };
    prepare_in_place(side, bytes);
}

#[cfg(test)]
pub(crate) static PREPARED_R2_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);
#[cfg(test)]
pub(crate) static PREPARED_R34_HITS: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);

#[allow(clippy::too_many_arguments)]
pub(crate) fn round2_with_layout(
    layout: PackedAbLayout,
    a: &[u8],
    b: &[u8],
    m: usize,
    k_skip: usize,
    table: &super::multilinear::UniSkipFoldTable,
    challenges: &[F128],
    padding: &super::PaddingSpec,
    eq: Option<&super::univariate_skip::SplitEqGhash>,
    canon: Option<&[F128]>,
) -> (F128, F128, super::multilinear::Round3Lookahead) {
    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni",
        target_feature = "vpclmulqdq"
    ))]
    if layout == PackedAbLayout::PreparedOctaV1
        && k_skip == 6
        && let (Some(eq), Some(canon)) = (eq, canon)
        && eq.n_lo >= 10
    {
        #[cfg(test)]
        PREPARED_R2_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        return super::multilinear::prepared::round2(
            a, b, m, table, challenges, padding, eq, canon,
        );
    }
    let view = CanonicalAb::new(layout, a, b);
    super::multilinear::uni_skip_round_pair_lookahead_nomat_packed_padded_with_eq(
        view.a(),
        view.b(),
        m,
        k_skip,
        table,
        challenges,
        padding,
        eq,
        canon,
    )
}

#[allow(clippy::too_many_arguments)]
pub(crate) fn round34_with_layout(
    layout: PackedAbLayout,
    a: &[u8],
    b: &[u8],
    m: usize,
    k_skip: usize,
    table: &super::multilinear::UniSkipFoldTable,
    padding: &super::PaddingSpec,
    a_out: &mut [F128],
    b_out: &mut [F128],
    rho1: F128,
    rho2: F128,
    r_next: &[F128],
    eq: Option<(&[F128], &[F128])>,
    out_lm: bool,
) -> (F128, F128, super::multilinear::Round3Lookahead) {
    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "avx512bw",
        target_feature = "avx512vbmi",
        target_feature = "gfni",
        target_feature = "vpclmulqdq"
    ))]
    if layout == PackedAbLayout::PreparedOctaV1
        && k_skip == 6
        && out_lm
        && (a_out.as_ptr() as usize).is_multiple_of(64)
        && (b_out.as_ptr() as usize).is_multiple_of(64)
        && let Some((lo, hi)) = eq
        && !lo.is_empty()
        && lo.len().is_multiple_of(256)
    {
        #[cfg(test)]
        PREPARED_R34_HITS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        return super::multilinear::prepared::round34(
            a, b, m, table, a_out, b_out, rho1, rho2, r_next, lo, hi,
        );
    }
    let view = CanonicalAb::new(layout, a, b);
    super::multilinear::fold2_from_packed_and_round_pair_lookahead_into_with_eq(
        view.a(),
        view.b(),
        m,
        k_skip,
        table,
        padding,
        a_out,
        b_out,
        rho1,
        rho2,
        r_next,
        eq,
        out_lm,
    )
}
