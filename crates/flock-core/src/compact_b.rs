//! Compact ranked BLAKE3 B inputs. Only bytes intersecting a carry-right
//! operand can vary; the other bytes of each mixed window are all 0xff.
pub const DENSE_BYTES: usize = 2048;
pub const PACKED_BYTES: usize = 1408;
const FIRST: usize = 2;
const LAST: usize = 29;

#[repr(align(64))]
struct Layout {
    pack: [[u8; 64]; 22],
    source: [usize; 22],
    read: [[u8; 64]; 28],
    offset: [usize; 28],
}

const fn live_byte(byte: usize) -> bool {
    let mut i = byte * 8;
    while i < byte * 8 + 8 {
        if i >= 1153 && i < 1153 + 56 * 250 && (i - 1153) % 250 < 186 {
            return true;
        }
        i += 1;
    }
    false
}

const fn layout() -> Layout {
    let mut dst = Layout {
        pack: [[0; 64]; 22],
        source: [0; 22],
        read: [[0; 64]; 28],
        offset: [0; 28],
    };
    let mut cursor = 0;
    let mut window = FIRST;
    while window <= LAST {
        if cursor % 64 != 0 && window > dst.source[cursor / 64] + 1 {
            cursor = cursor.div_ceil(64) * 64;
        }
        let start = cursor;
        let mut j = 0;
        let mut constant_byte = 0;
        while j <= 64 {
            if j == 64 || live_byte(window * 64 + j) {
                if cursor % 64 == 0 {
                    dst.source[cursor / 64] = window;
                }
                let pos = if j == 64 { constant_byte } else { j };
                dst.pack[cursor / 64][cursor % 64] =
                    ((window - dst.source[cursor / 64]) * 64 + pos) as u8;
                if j < 64 {
                    dst.read[window - FIRST][j] = (cursor - start) as u8;
                }
                cursor += 1;
            } else {
                constant_byte = j;
            }
            j += 1;
        }
        let base = if start <= PACKED_BYTES - 64 {
            start
        } else {
            PACKED_BYTES - 64
        };
        dst.offset[window - FIRST] = base;
        let mut i = 0;
        while i < 64 {
            let index = if live_byte(window * 64 + i) {
                start + dst.read[window - FIRST][i] as usize
            } else {
                cursor - 1
            };
            dst.read[window - FIRST][i] = (index - base) as u8;
            i += 1;
        }
        window += 1;
    }
    assert!(cursor.div_ceil(64) == 22);
    dst
}
static LAYOUT: Layout = layout();

pub fn pack(dense: &[u8; DENSE_BYTES], out: &mut [u8; PACKED_BYTES]) {
    for (tile, output) in out.chunks_exact_mut(64).enumerate() {
        let start = LAYOUT.source[tile] * 64;
        #[cfg(all(target_arch = "x86_64", target_feature = "avx512vbmi"))]
        unsafe {
            use core::arch::x86_64::*;
            let first = _mm512_loadu_si512(dense.as_ptr().add(start).cast());
            let second = _mm512_loadu_si512(dense.as_ptr().add(start + 64).cast());
            let idx = _mm512_loadu_si512(LAYOUT.pack[tile].as_ptr().cast());
            let value = _mm512_permutex2var_epi8(first, idx, second);
            _mm512_storeu_si512(output.as_mut_ptr().cast(), value);
        }
        #[cfg(not(all(target_arch = "x86_64", target_feature = "avx512vbmi")))]
        for (p, &idx) in output.iter_mut().zip(&LAYOUT.pack[tile]) {
            *p = dense[start + idx as usize];
        }
    }
}

#[cfg(all(target_arch = "x86_64", target_feature = "avx512vbmi"))]
#[inline]
unsafe fn unpack_to(src: &[u8; PACKED_BYTES], dest: *mut u8) {
    use core::arch::x86_64::*;
    unsafe {
        let ones = _mm512_set1_epi8(-1);
        _mm512_storeu_si512(dest.cast(), ones);
        _mm512_storeu_si512(dest.add(64).cast(), ones);
        for (i, &base) in LAYOUT.offset.iter().enumerate() {
            let values = _mm512_loadu_si512(src.as_ptr().add(base).cast());
            let idx = _mm512_loadu_si512(LAYOUT.read[i].as_ptr().cast());
            _mm512_storeu_si512(
                dest.add((i + FIRST) * 64).cast(),
                _mm512_permutexvar_epi8(idx, values),
            );
        }
        dest.add(1920).write_bytes(0, 128);
        dest.add(1920).write_bytes(255, 6);
        dest.add(1926).write(1);
    }
}

pub fn unpack(src: &[u8; PACKED_BYTES], out: &mut [u8; DENSE_BYTES]) {
    #[cfg(all(target_arch = "x86_64", target_feature = "avx512vbmi"))]
    unsafe {
        unpack_to(src, out.as_mut_ptr());
    }
    #[cfg(not(all(target_arch = "x86_64", target_feature = "avx512vbmi")))]
    {
        out[..128].fill(255);
        for (i, line) in out[FIRST * 64..(LAST + 1) * 64]
            .chunks_exact_mut(64)
            .enumerate()
        {
            for (b, &idx) in line.iter_mut().zip(&LAYOUT.read[i]) {
                *b = src[LAYOUT.offset[i] + idx as usize];
            }
        }
        out[1920..].fill(0);
        out[1920..1926].fill(255);
        out[1926] = 1;
    }
}

#[test]
fn ranked_dynamic_bits_roundtrip() {
    let mut rng = 173825417u64;
    for _ in 0..80 {
        let mut dense = [0u8; DENSE_BYTES];
        for i in 0..15409 {
            let v = if i >= 1153 && i < 1153 + 56 * 250 && (i - 1153) % 250 < 186 {
                rng ^= rng << 13;
                rng ^= rng >> 7;
                rng ^= rng << 17;
                (rng & 1) as u8
            } else {
                1
            };
            dense[i / 8] |= v << (i % 8);
        }
        let mut packet = [0; PACKED_BYTES];
        let mut got = [37; DENSE_BYTES];
        pack(&dense, &mut packet);
        unpack(&packet, &mut got);
        assert_eq!(dense, got);
    }
}

/// Update an aligned compact packet as the producer emits consecutive mixed
/// windows 2..29. Only the preceding 64-byte window must survive between calls.
///
/// # Safety
/// `dest` must point to an exclusive, 64-byte-aligned PACKED_BYTES region.
/// The caller fences non-temporal writes before exposing the finished packet.
#[cfg(all(target_arch = "x86_64", target_feature = "avx512vbmi"))]
#[inline]
pub unsafe fn push_window(
    dest: *mut u8,
    window: usize,
    previous: core::arch::x86_64::__m512i,
    current: core::arch::x86_64::__m512i,
) {
    use core::arch::x86_64::*;
    const fn ranges() -> [(usize, usize); 32] {
        let mut ret = [(0, 0); 32];
        let mut i = 0;
        while i < 22 {
            let w = if LAYOUT.source[i] < LAST {
                LAYOUT.source[i] + 1
            } else {
                LAST
            };
            if ret[w].1 == 0 {
                ret[w].0 = i;
            }
            ret[w].1 = i + 1;
            i += 1;
        }
        ret
    }
    const RANGES: [(usize, usize); 32] = ranges();
    let (first, end) = RANGES[window];
    unsafe {
        for i in first..end {
            let control = _mm512_loadu_si512(LAYOUT.pack[i].as_ptr().cast());
            let left = if LAYOUT.source[i] == window {
                current
            } else {
                previous
            };
            let packed = _mm512_permutex2var_epi8(left, control, current);
            _mm512_stream_si512(dest.add(64 * i).cast(), packed);
        }
    }
}

/// Expand a contiguous run of packets on rollback or for a local reader.
pub fn expand(packets: &[u8]) -> Vec<u8> {
    assert_eq!(packets.len() % PACKED_BYTES, 0);
    let mut result = vec![0; packets.len() / PACKED_BYTES * DENSE_BYTES];
    for (src, out) in packets
        .chunks_exact(PACKED_BYTES)
        .zip(result.chunks_exact_mut(DENSE_BYTES))
    {
        unpack(src.try_into().unwrap(), out.try_into().unwrap());
    }
    result
}

/// Return one localized packed input range. A dense sibling stays borrowed;
/// compact B is expanded only for the worker currently reading this range.
pub(crate) fn local_inputs<'a>(
    a: &'a [u8],
    b: &'a [u8],
    offset: usize,
    bytes: usize,
) -> (&'a [u8], std::borrow::Cow<'a, [u8]>, usize) {
    if a.len() == b.len() {
        return (a, std::borrow::Cow::Borrowed(b), offset);
    }
    let first = offset / DENSE_BYTES;
    let end = (offset + bytes).div_ceil(DENSE_BYTES);
    (
        &a[first * DENSE_BYTES..end * DENSE_BYTES],
        std::borrow::Cow::Owned(expand(&b[first * PACKED_BYTES..end * PACKED_BYTES])),
        offset % DENSE_BYTES,
    )
}

/// Borrow the next dense input block or reconstruct it into one reusable
/// cache-local block for the vector kernel. Geometry is checked by its driver.
#[cfg(all(target_arch = "x86_64", target_feature = "avx512vbmi"))]
#[inline]
pub(crate) unsafe fn block_ptr(
    data: *const u8,
    block: usize,
    packed: bool,
    scratch: &mut core::mem::MaybeUninit<[u8; DENSE_BYTES]>,
) -> *const u8 {
    unsafe {
        if !packed {
            return data.add(block * DENSE_BYTES);
        }
        let p = &*data.add(block * PACKED_BYTES).cast::<[u8; PACKED_BYTES]>();
        let out = scratch.as_mut_ptr().cast::<u8>();
        unpack_to(p, out);
        out
    }
}

#[cfg(test)]
pub(crate) static PACKED_R2: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);
#[cfg(test)]
pub(crate) static PACKED_R345: std::sync::atomic::AtomicUsize =
    std::sync::atomic::AtomicUsize::new(0);
