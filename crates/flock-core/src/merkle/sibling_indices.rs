/// Flat-tree indices of the sibling hashes [`super::merkle_multi_proof`] emits, in
/// the exact emission order. Pure index arithmetic — no tree reads — so the
/// prover can walk the paths first and gather the (DRAM-cold, random-access)
/// sibling hashes in one order-preserving parallel pass:
/// `indices.map(|i| tree[i])` reproduces `merkle_multi_proof` byte-for-byte.
pub fn merkle_multi_proof_sibling_indices(num_leaves: usize, positions: &[usize]) -> Vec<usize> {
    assert!(num_leaves.is_power_of_two());
    if positions.is_empty() || num_leaves == 1 {
        return Vec::new();
    }
    let mut active = positions.to_vec();
    active.sort_unstable();
    active.dedup();
    sibling_indices(num_leaves, active)
}

/// The PCS samplers already return positions in strictly increasing order.
pub(crate) fn sorted_sibling_indices(num_leaves: usize, positions: &[usize]) -> Vec<usize> {
    assert!(num_leaves.is_power_of_two());
    if positions.is_empty() || num_leaves == 1 {
        return Vec::new();
    }
    debug_assert!(positions.windows(2).all(|pair| pair[0] < pair[1]));
    sibling_indices(num_leaves, positions.to_vec())
}

fn sibling_indices(num_leaves: usize, mut active: Vec<usize>) -> Vec<usize> {
    debug_assert!(active.iter().all(|&p| p < num_leaves));

    let mut indices = Vec::new();
    let mut level_start = 0usize;
    let mut level_len = num_leaves;

    while level_len > 1 {
        let mut written = 0;
        let mut i = 0;
        while i < active.len() {
            let p = active[i];
            let sib_active = i + 1 < active.len() && active[i + 1] == (p ^ 1);
            if sib_active {
                i += 2;
            } else {
                indices.push(level_start + (p ^ 1));
                i += 1;
            }
            // Each parent consumes at least one child. The write index is
            // therefore strictly behind the next unread child, so one buffer
            // can hold both the current frontier and its compacted parents.
            active[written] = p >> 1;
            written += 1;
        }
        active.truncate(written);
        level_start += level_len;
        level_len >>= 1;
    }

    indices
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::BTreeSet;

    // Each queried leaf contributes an ancestor at each level. A sibling
    // belongs in the proof exactly when no query has that sibling as ancestor.
    fn oracle(leaves: usize, positions: &[usize]) -> Vec<usize> {
        let mut expected = Vec::new();
        let mut offset = 0;
        for level in 0..leaves.trailing_zeros() {
            let queried: BTreeSet<_> = positions.iter().map(|p| p >> level).collect();
            for &node in &queried {
                let sibling = node ^ 1;
                if !queried.contains(&sibling) {
                    expected.push(offset + sibling);
                }
            }
            offset += leaves >> level;
        }
        expected
    }

    #[test]
    fn every_query_subset_through_sixteen_leaves() {
        for leaves in [1, 2, 4, 8, 16] {
            for mask in 0..(1u32 << leaves) {
                let ordered: Vec<_> = (0..leaves).filter(|p| (mask >> p) & 1 == 1).collect();
                assert_eq!(
                    sorted_sibling_indices(leaves, &ordered),
                    oracle(leaves, &ordered)
                );
            }
        }
    }

    #[test]
    fn ranked_l0_and_unordered_public_input() {
        let leaves = 1 << 20;
        let mut positions: Vec<usize> = (0..218).map(|i| (i * 48271 + 7) % leaves).collect();
        positions.sort_unstable();
        let expected = oracle(leaves, &positions);
        assert_eq!(sorted_sibling_indices(leaves, &positions), expected);

        positions.reverse();
        positions.extend_from_within(0..32);
        assert_eq!(
            merkle_multi_proof_sibling_indices(leaves, &positions),
            expected
        );
    }
}
