//! Full AVX-512 groups of contiguous, fixed-size BLAKE3 Merkle messages.
//! The assembly derives from BLAKE3 1.8.6's CC0 implementation; see the
//! adjacent license. All kernels preserve seven compression rounds, fixed
//! strides and zero counters. Canonical kernels keep ordinary transposes;
//! the first-edge interface passes CV word planes directly to parent hashes.
use super::{BLAKE3_IV, Hash};
core::arch::global_asm!(include_str!("merkle_contiguous.S"));
unsafe extern "C" {
    fn flock_blake3_contiguous_64(
        data: *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
    fn flock_blake3_contiguous_128(
        data: *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
    fn flock_blake3_contiguous_256(
        data: *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
    fn flock_blake3_contiguous_512(
        data: *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
    fn flock_blake3_contiguous_1024(
        data: *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
}
type Kernel =
    unsafe extern "C" fn(*const u8, usize, usize, *const u32, u64, bool, u8, u8, u8, *mut u8);

/// Hash only complete 16-message groups. The caller retains the ordinary
/// platform implementation for its partial group, unsupported targets and
/// non-contiguous indexed leaves.
#[inline]
pub(super) fn hash_many<const N: usize>(
    data: &[u8],
    out: &mut [Hash],
    flags: u8,
    start: u8,
    end: u8,
) {
    let kernel: Kernel = match N {
        64 => flock_blake3_contiguous_64,
        128 => flock_blake3_contiguous_128,
        256 => flock_blake3_contiguous_256,
        512 => flock_blake3_contiguous_512,
        1024 => flock_blake3_contiguous_1024,
        _ => unreachable!("unsupported contiguous BLAKE3 size"),
    };
    assert!(!out.is_empty() && out.len() % 16 == 0);
    assert_eq!(data.len(), out.len() * N);
    // SAFETY: the compile-time module gate supplies AVX-512F/VL and the Linux
    // SysV ABI. Each message has exactly N initialized readable bytes, every
    // output has 32 writable bytes, and the slices cannot alias. The kernel
    // handles one or more complete groups only. Key, flags, start and end have
    // the same meanings as upstream hash_many; zero/no-increment is fixed.
    unsafe {
        kernel(
            data.as_ptr(),
            out.len(),
            N / 64,
            BLAKE3_IV.as_ptr(),
            0,
            false,
            flags,
            start,
            end,
            out.as_mut_ptr().cast(),
        );
    }
}

unsafe extern "C" {
    fn flock_blake3_planes_leaf_64(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    fn flock_blake3_planes_leaf_128(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    fn flock_blake3_planes_leaf_256(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    fn flock_blake3_planes_leaf_512(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    fn flock_blake3_planes_leaf_1024(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    fn flock_blake3_planes_parent(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8);
    /// Two parent levels over 64-byte child pairs: `count` top nodes (a
    /// positive multiple of 16) from `4 * count` canonical children, canonical
    /// level-j nodes to `out` and canonical level-j+1 nodes to `top`.
    fn flock_blake3_two_level_64(data: *const u8, count: usize, blocks: usize, key: *const u32, counter: u64, increment: bool, flags: u8, start: u8, end: u8, out: *mut u8, top: *mut u8);
}

/// Complete groups only. Every 32 leaves become 16 canonical parent CVs.
/// Scratch order is [leaf_group_of_16][cv_word][message_lane], little endian.
#[inline]
pub(super) fn hash_leaf_pairs<const N: usize>(data: &[u8], out: &mut [Hash]) {
    assert!(!out.is_empty() && out.len() % 16 == 0);
    assert_eq!(data.len(), 2 * out.len() * N);
    let leaf: Kernel = match N {
        64 => flock_blake3_planes_leaf_64,
        128 => flock_blake3_planes_leaf_128,
        256 => flock_blake3_planes_leaf_256,
        512 => flock_blake3_planes_leaf_512,
        1024 => flock_blake3_planes_leaf_1024,
        _ => unreachable!("unsupported plane leaf size"),
    };
    // At most 128 leaves / 64 parents. No typed initialized scratch reference
    // exists before the assembly has written every byte the parent reads.
    let mut scratch = core::mem::MaybeUninit::<[u8; 128 * 32]>::uninit();
    for (parents, leaves) in out.chunks_mut(64).zip(data.chunks(128 * N)) {
        let planes = scratch.as_mut_ptr().cast::<u8>();
        // SAFETY: compile-time AVX-512/SysV module gate; disjoint exact-size
        // input/output slices; full 16-lane groups. Zero counters throughout.
        unsafe {
            leaf(leaves.as_ptr(), 2 * parents.len(), N / 64,
                BLAKE3_IV.as_ptr(), 0, false, 0,
                super::BLAKE3_CHUNK_START, super::BLAKE3_CHUNK_END, planes);
            flock_blake3_planes_parent(planes, parents.len(), 1,
                BLAKE3_IV.as_ptr(), 0, false, super::BLAKE3_PARENT, 0, 0,
                parents.as_mut_ptr().cast());
        }
    }
}

/// Two parent levels at once. `children` are canonical CVs of level j-1
/// (64 bytes per level-j node: left || right). One call of the fused kernel
/// hashes level j (one PARENT compression per 64-byte message, start = end = 0)
/// and writes it canonically into `mid` (the tree slots openings read), and
/// hashes level j+1 from level j's CV word planes (one 512-byte stack spill per
/// 16 top nodes, the other half fed from registers) into `top`, so level j is
/// never re-read from the tree and re-transposed. Complete groups only:
/// `top.len()` a positive multiple of 16, `mid.len() == 2 * top.len()`,
/// `children.len() == 4 * top.len() * 32`.
#[inline]
pub(super) fn hash_parent_two_levels(children: &[u8], mid: &mut [Hash], top: &mut [Hash]) {
    assert!(!top.is_empty() && top.len() % 16 == 0);
    assert_eq!(mid.len(), 2 * top.len());
    assert_eq!(children.len(), mid.len() * 64);
    // SAFETY: compile-time AVX-512/SysV module gate; `children` holds exactly
    // `mid.len()` 64-byte messages, `mid` exactly `mid.len() * 32` and `top`
    // exactly `top.len() * 32` writable bytes; `top.len()` is a positive
    // multiple of 16, so every group is full; the kernel's plane scratch is
    // its own stack frame; zero counters throughout.
    unsafe {
        flock_blake3_two_level_64(children.as_ptr(), top.len(), 1,
            BLAKE3_IV.as_ptr(), 0, false, super::BLAKE3_PARENT, 0, 0,
            mid.as_mut_ptr().cast(), top.as_mut_ptr().cast());
    }
}

#[cfg(test)]
mod plane_tests {
    use super::*;
    #[test]
    fn direct_leaf_planes_match_hazmat_words() {
        use blake3::hazmat::HasherExt;
        for size in [64usize, 128, 256, 512, 1024] {
            let leaf: Kernel = match size {
                64 => flock_blake3_planes_leaf_64,
                128 => flock_blake3_planes_leaf_128,
                256 => flock_blake3_planes_leaf_256,
                512 => flock_blake3_planes_leaf_512,
                1024 => flock_blake3_planes_leaf_1024,
                _ => unreachable!(),
            };
            for count in [16usize, 32, 64, 128] {
                for offset in [0usize, 1, 31, 63] {
                    let mut seed = 0x9e3779b97f4a7c15u64;
                    let mut storage = vec![0u8; offset + count * size];
                    for x in &mut storage {
                        seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17;
                        *x = seed as u8;
                    }
                    let data = &storage[offset..];
                    let mut plane_bytes = vec![0xa5u8; count * 32 + 128];
                    unsafe {
                        leaf(data.as_ptr(), count, size / 64, BLAKE3_IV.as_ptr(), 0, false,
                            0, super::super::BLAKE3_CHUNK_START, super::super::BLAKE3_CHUNK_END,
                            plane_bytes.as_mut_ptr().add(64));
                    }
                    for i in 0..count {
                        let cv = blake3::Hasher::new().update(&data[i * size..(i + 1) * size]).finalize_non_root();
                        for word in 0..8 {
                            let p = 64 + (i / 16) * 512 + word * 64 + (i % 16) * 4;
                            assert_eq!(plane_bytes[p..p + 4], cv[word * 4..word * 4 + 4],
                                "size={size} count={count} offset={offset} leaf={i} word={word}");
                        }
                    }
                    assert!(plane_bytes[..64].iter().all(|&x| x == 0xa5));
                    assert!(plane_bytes[count * 32 + 64..].iter().all(|&x| x == 0xa5));
                }
            }
        }
    }

    #[test]
    fn two_level_64_matches_two_canonical_levels() {
        let flags = super::super::BLAKE3_PARENT;
        for top_n in [16usize, 32, 48, 80] {
            let mut seed = 0x2545f4914f6cdd1du64 ^ top_n as u64;
            let children: Vec<u8> = (0..top_n * 4 * 32)
                .map(|_| { seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17; seed as u8 })
                .collect();
            let mut want_mid = vec![0u8; top_n * 2 * 32];
            let mut want_top = vec![0u8; top_n * 32];
            let mut mid = vec![0x5au8; top_n * 2 * 32 + 128];
            let mut top = vec![0xa5u8; top_n * 32 + 128];
            unsafe {
                flock_blake3_contiguous_64(children.as_ptr(), top_n * 2, 1, BLAKE3_IV.as_ptr(), 0, false,
                    flags, 0, 0, want_mid.as_mut_ptr());
                flock_blake3_contiguous_64(want_mid.as_ptr(), top_n, 1, BLAKE3_IV.as_ptr(), 0, false,
                    flags, 0, 0, want_top.as_mut_ptr());
                flock_blake3_two_level_64(children.as_ptr(), top_n, 1, BLAKE3_IV.as_ptr(), 0, false,
                    flags, 0, 0, mid.as_mut_ptr().add(64), top.as_mut_ptr().add(64));
            }
            assert_eq!(mid[64..64 + top_n * 64], want_mid[..], "top_n={top_n}");
            assert_eq!(top[64..64 + top_n * 32], want_top[..], "top_n={top_n}");
            assert!(mid[..64].iter().chain(&mid[64 + top_n * 64..]).all(|&x| x == 0x5a));
            assert!(top[..64].iter().chain(&top[64 + top_n * 32..]).all(|&x| x == 0xa5));
        }
    }
}
