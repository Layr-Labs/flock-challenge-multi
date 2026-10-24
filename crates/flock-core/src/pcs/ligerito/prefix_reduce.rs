//! Reduce the last retained transpose layer directly into its kept prefix.
//!
//! For group g, s_g = a_g + b_g. The subsequent discarded-output layers
//! retain only sums, so their two surviving rows are sum(s_g) and
//! sum(b_g) + sum(t_g * s_g). Additive-NTT twiddles are linear in the
//! group index: t_g = sum_j bit_j(g) * t_(1<<j). Thus only `dead` field
//! products are needed, and no intermediate discarded rows are stored.
use super::{AdditiveNttF128, F128};

pub(super) fn supported(dead: usize) -> bool {
    (1..=5).contains(&dead)
}

pub(super) fn dense(ntt: &AdditiveNttF128, data: &mut [F128], dead: usize) {
    assert!(supported(dead));
    let count = 2usize << dead;
    assert_eq!(data.len() % count, 0);
    let width = data.len() / count;
    let mut rows = [core::ptr::null_mut(); 64];
    for (row, dst) in rows[..count].iter_mut().enumerate() {
        // SAFETY: the equal rows partition the exclusive data slice.
        *dst = unsafe { data.as_mut_ptr().add(row * width) };
    }
    let basis = basis(ntt, dead);
    // SAFETY: all rows have width elements, are disjoint and remain owned
    // by data throughout this synchronous call.
    unsafe { dispatch(&rows[..count], width, &basis, dead) };
}

pub(super) fn columns(ntt: &AdditiveNttF128, cols: &mut [&mut [F128]], stride: usize, dead: usize) {
    assert!(supported(dead) && stride > 0);
    let count = 2usize << dead;
    assert_eq!(cols.len(), count * stride);
    let width = cols[0].len();
    assert!(cols.iter().all(|col| col.len() == width));
    let basis = basis(ntt, dead);
    let mut rows = [core::ptr::null_mut(); 64];
    for u in 0..stride {
        for (row, dst) in rows[..count].iter_mut().enumerate() {
            *dst = cols[row * stride + u].as_mut_ptr();
        }
        // SAFETY: each pointer originates from a distinct exclusive column
        // slice. Different u values touch disjoint columns. Only the first
        // two rows are written, after their original values have been read.
        unsafe { dispatch(&rows[..count], width, &basis, dead) };
    }
}

fn basis(ntt: &AdditiveNttF128, dead: usize) -> [F128; 5] {
    core::array::from_fn(|j| {
        if j < dead {
            ntt.twiddle(dead, 1 << j)
        } else {
            F128::ZERO
        }
    })
}

unsafe fn dispatch(rows: &[*mut F128], width: usize, basis: &[F128; 5], dead: usize) {
    // SAFETY: the wrappers establish disjoint, initialized, width-long rows.
    unsafe {
        match dead {
            1 => group::<1>(rows, width, basis),
            2 => group::<2>(rows, width, basis),
            3 => group::<3>(rows, width, basis),
            4 => group::<4>(rows, width, basis),
            5 => group::<5>(rows, width, basis),
            _ => unreachable!(),
        }
    }
}

#[inline(never)]
unsafe fn group<const D: usize>(rows: &[*mut F128], width: usize, basis: &[F128; 5]) {
    assert_eq!(rows.len(), 2usize << D);
    let mut i = 0;
    #[cfg(all(target_feature = "avx512f", target_feature = "vpclmulqdq"))]
    {
        use crate::field::gf2_128::x86_64::{ghash_mul_x4_split, ghash_shift64_x4};
        use core::arch::x86_64::*;
        // SAFETY: target features are cfg-guaranteed. Every vector access is
        // within one of the caller's disjoint width-long rows. All inputs at
        // this offset are read before either retained output is written.
        unsafe {
            let weights: [__m512i; D] = core::array::from_fn(|j| {
                _mm512_broadcast_i32x4(_mm_set_epi64x(basis[j].hi as i64, basis[j].lo as i64))
            });
            let shifted: [__m512i; D] = core::array::from_fn(|j| ghash_shift64_x4(weights[j]));
            let lanes = width & !3;
            while i < lanes {
                let mut sum = _mm512_setzero_si512();
                let mut bot = _mm512_setzero_si512();
                let mut partial = [_mm512_setzero_si512(); D];
                // Static group indices let the compiler remove bit tests
                // and keep the small set of partial sums in registers.
                macro_rules! accumulate {
                    ($($g:literal),* $(,)?) => {$(
                        if $g < 1usize << D {
                            let a = _mm512_loadu_si512(rows[2 * $g].add(i).cast());
                            let b = _mm512_loadu_si512(rows[2 * $g + 1].add(i).cast());
                            let s = _mm512_xor_si512(a, b);
                            sum = _mm512_xor_si512(sum, s);
                            bot = _mm512_xor_si512(bot, b);
                            for j in 0..D {
                                if $g & (1 << j) != 0 {
                                    partial[j] = _mm512_xor_si512(partial[j], s);
                                }
                            }
                        }
                    )*};
                }
                accumulate!(
                    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                    22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
                );
                for j in 0..D {
                    bot = _mm512_xor_si512(
                        bot,
                        ghash_mul_x4_split(partial[j], weights[j], shifted[j]),
                    );
                }
                _mm512_storeu_si512(rows[0].add(i).cast(), sum);
                _mm512_storeu_si512(rows[1].add(i).cast(), bot);
                i += 4;
            }
        }
    }
    // Scalar fallback and short tails use the same group-index identity.
    while i < width {
        let mut sum = F128::ZERO;
        let mut bot = F128::ZERO;
        let mut partial = [F128::ZERO; D];
        for g in 0..1usize << D {
            // SAFETY: i < width and both rows are valid and initialized.
            let (a, b) = unsafe { (*rows[2 * g].add(i), *rows[2 * g + 1].add(i)) };
            let s = a + b;
            sum += s;
            bot += b;
            for (j, value) in partial.iter_mut().enumerate() {
                if g & (1 << j) != 0 {
                    *value += s;
                }
            }
        }
        for j in 0..D {
            bot += basis[j] * partial[j];
        }
        // SAFETY: all group inputs at i have been consumed. The two output
        // rows are disjoint and no later iteration reads offset i.
        unsafe {
            *rows[0].add(i) = sum;
            *rows[1].add(i) = bot;
        }
        i += 1;
    }
}

/// When every requested layer is discarded, only one XOR reduction remains.
/// Used on tiny serial domains; larger transforms retain their parallel path.
pub(super) fn all_dead_dense(data: &mut [F128], top: usize) {
    assert!((1..=5).contains(&top));
    let count = 1usize << top;
    assert_eq!(data.len() % count, 0);
    let width = data.len() / count;
    let mut i = 0;
    #[cfg(target_feature = "avx512f")]
    {
        use core::arch::x86_64::*;
        // SAFETY: rows partition data; only the first row is written, after
        // all original rows at the current offset have been read.
        unsafe {
            while i < width & !3 {
                let mut sum = _mm512_setzero_si512();
                for g in 0..count {
                    sum = _mm512_xor_si512(
                        sum,
                        _mm512_loadu_si512(data.as_ptr().add(g * width + i).cast()),
                    );
                }
                _mm512_storeu_si512(data.as_mut_ptr().add(i).cast(), sum);
                i += 4;
            }
        }
    }
    while i < width {
        let mut sum = F128::ZERO;
        for g in 0..count {
            sum += data[g * width + i];
        }
        data[i] = sum;
        i += 1;
    }
}
