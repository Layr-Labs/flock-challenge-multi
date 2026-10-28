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
    fn flock_blake3_planes_leaf_64(
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
    fn flock_blake3_planes_leaf_128(
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
    fn flock_blake3_planes_leaf_256(
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
    fn flock_blake3_planes_leaf_512(
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
    fn flock_blake3_planes_leaf_1024(
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
    fn flock_blake3_planes_parent(
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
            leaf(
                leaves.as_ptr(),
                2 * parents.len(),
                N / 64,
                BLAKE3_IV.as_ptr(),
                0,
                false,
                0,
                super::BLAKE3_CHUNK_START,
                super::BLAKE3_CHUNK_END,
                planes,
            );
            flock_blake3_planes_parent(
                planes,
                parents.len(),
                1,
                BLAKE3_IV.as_ptr(),
                0,
                false,
                super::BLAKE3_PARENT,
                0,
                0,
                parents.as_mut_ptr().cast(),
            );
        }
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
                        seed ^= seed << 13;
                        seed ^= seed >> 7;
                        seed ^= seed << 17;
                        *x = seed as u8;
                    }
                    let data = &storage[offset..];
                    let mut plane_bytes = vec![0xa5u8; count * 32 + 128];
                    unsafe {
                        leaf(
                            data.as_ptr(),
                            count,
                            size / 64,
                            BLAKE3_IV.as_ptr(),
                            0,
                            false,
                            0,
                            super::super::BLAKE3_CHUNK_START,
                            super::super::BLAKE3_CHUNK_END,
                            plane_bytes.as_mut_ptr().add(64),
                        );
                    }
                    for i in 0..count {
                        let cv = blake3::Hasher::new()
                            .update(&data[i * size..(i + 1) * size])
                            .finalize_non_root();
                        for word in 0..8 {
                            let p = 64 + (i / 16) * 512 + word * 64 + (i % 16) * 4;
                            assert_eq!(
                                plane_bytes[p..p + 4],
                                cv[word * 4..word * 4 + 4],
                                "size={size} count={count} offset={offset} leaf={i} word={word}"
                            );
                        }
                    }
                    assert!(plane_bytes[..64].iter().all(|&x| x == 0xa5));
                    assert!(plane_bytes[count * 32 + 64..].iter().all(|&x| x == 0xa5));
                }
            }
        }
    }
}

unsafe extern "C" {
    fn flock_blake3_dual_canonical(
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
        planes: *mut u8,
    );
    fn flock_blake3_dual_planes(
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
        planes: *mut u8,
    );
}
unsafe extern "C" {
    fn flock_blake3_dual_canonical_nt(
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
        planes: *mut u8,
    );
    fn flock_blake3_dual_planes_nt(
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
        planes: *mut u8,
    );
}
type DualKernel = unsafe extern "C" fn(
    *const u8,
    usize,
    usize,
    *const u32,
    u64,
    bool,
    u8,
    u8,
    u8,
    *mut u8,
    *mut u8,
);

/// Fold one exclusively owned subtree, retaining every node in ordinary Hash
/// order. Only the temporary input to the next SIMD level uses word planes.
/// The caller checks the geometry and supplies the disjoint tree ranges.
#[inline(never)]
pub(super) unsafe fn hash_subtree_parents_dual(
    tree: *mut Hash,
    stored_leaves: usize,
    start: usize,
    len: usize,
) {
    // The first level contains at most 1024 hashes. No initialized reference
    // to this storage is formed before the corresponding assembly writes.
    let mut scratch = core::mem::MaybeUninit::<[u8; 1024 * 32]>::uninit();
    let planes = scratch.as_mut_ptr().cast::<u8>();
    // Only complete canonical cache lines use streaming stores. The plane
    // scratch remains temporal because the following level consumes it.
    // Unsupported alignment preserves the verified ordinary-store kernels.
    let stream = (tree as usize).is_multiple_of(64);
    let canonical_kernel: DualKernel = if stream {
        flock_blake3_dual_canonical_nt
    } else {
        flock_blake3_dual_canonical
    };
    let plane_kernel: DualKernel = if stream {
        flock_blake3_dual_planes_nt
    } else {
        flock_blake3_dual_planes
    };
    let mut plane_input = false;
    let mut read_off = start;
    let mut read_len = len;
    for j in 1..=len.trailing_zeros() as usize {
        let width = stored_leaves >> j;
        let write_off = 2 * stored_leaves - 2 * width + (start >> j);
        let count = read_len / 2;
        // SAFETY: the checked geometry and caller's ownership contract make
        // each canonical read/write range disjoint and within the flat tree.
        // A complete 32-child plane group is loaded before its 16-parent
        // output overwrites the scratch prefix. Forward shrinking never
        // overwrites a future unread group, so scratch may alias itself.
        unsafe {
            let input = if plane_input {
                planes.cast_const()
            } else {
                tree.add(read_off).cast::<u8>().cast_const()
            };
            let output = tree.add(write_off);
            if count >= 16 {
                #[cfg(feature = "hash-count")]
                super::hash_count::PAIR_CALLS
                    .fetch_add(count as u64, std::sync::atomic::Ordering::Relaxed);
                if count >= 32 {
                    let kernel: DualKernel = if plane_input {
                        plane_kernel
                    } else {
                        canonical_kernel
                    };
                    kernel(
                        input,
                        count,
                        1,
                        BLAKE3_IV.as_ptr(),
                        0,
                        false,
                        super::BLAKE3_PARENT,
                        0,
                        0,
                        output.cast(),
                        planes,
                    );
                    plane_input = true;
                } else {
                    // The next level cannot fill a SIMD group. Retain only
                    // its canonical input; no unused plane copy is produced.
                    let kernel: Kernel = if plane_input {
                        flock_blake3_planes_parent
                    } else {
                        flock_blake3_contiguous_64
                    };
                    kernel(
                        input,
                        count,
                        1,
                        BLAKE3_IV.as_ptr(),
                        0,
                        false,
                        super::BLAKE3_PARENT,
                        0,
                        0,
                        output.cast(),
                    );
                    plane_input = false;
                }
            } else {
                debug_assert!(!plane_input);
                super::hash_pairs_level_serial(
                    core::slice::from_raw_parts(tree.add(read_off), read_len),
                    core::slice::from_raw_parts_mut(output, count),
                    super::HashKind::Blake3,
                );
            }
        }
        read_off = write_off;
        read_len = count;
    }
    if stream {
        // SAFETY: this x86 module is compiled only for the checked SIMD
        // target. Complete every canonical non-temporal store before this
        // callback returns and the Rayon join can release other readers.
        unsafe {
            core::arch::x86_64::_mm_sfence();
        }
    }
}
