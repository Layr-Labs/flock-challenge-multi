//! Full AVX-512 groups of contiguous, fixed-size BLAKE3 Merkle messages.
//! The assembly derives from BLAKE3 1.8.6's CC0 implementation; see the
//! adjacent license. It preserves all seven compression rounds and the
//! existing input/output transposes, but replaces the pointer-array loads
//! with fixed-stride addresses and specializes the counter to zero.
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
