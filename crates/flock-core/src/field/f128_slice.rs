//! Architecture-selected kernels over contiguous [`F128`] slices.

#![allow(clippy::items_after_test_module)] // Keep the nearby kernel-oracle tests in place.

use super::F128;

#[cfg(any(
    test,
    not(any(
        all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ),
        all(target_arch = "aarch64", target_feature = "aes")
    ))
))]
#[allow(dead_code)] // Portable fallbacks remain available for rollback builds.
mod portable;

#[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
mod aarch64;

#[cfg(all(
    target_arch = "x86_64",
    target_feature = "avx512f",
    target_feature = "vpclmulqdq"
))]
mod x86_64;

/// Fold adjacent pairs from `src` into `dst`, starting at pair `base`.
///
/// Computes `dst[t] = src[2j] * (1 + r) + src[2j + 1] * r`, where
/// `j = base + t`. Portable / serial tails use the char-2 identity
/// `even + r*(even+odd)` (one mul). AVX-512 / NEON already used that form.
#[inline]
pub(crate) fn fold_pairs(src: &[F128], base: usize, dst: &mut [F128], r: F128) {
    assert!(
        base <= src.len() / 2 && dst.len() <= src.len() / 2 - base,
        "fold source must contain both elements for every destination pair"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // bounds check above guarantees both source elements for every output.
    unsafe {
        x86_64::fold_pairs(src, base, dst, r);
    }

    #[cfg(all(target_arch = "aarch64", target_feature = "aes"))]
    // SAFETY: the cfg gate guarantees PMULL support through the aes feature;
    // the bounds check above guarantees both source elements for every output.
    unsafe {
        aarch64::fold_pairs(src, base, dst, r);
    }

    #[cfg(not(any(
        all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ),
        all(target_arch = "aarch64", target_feature = "aes")
    )))]
    portable::fold_pairs(src, base, dst, r);
}

/// Ranked default routes DirectFold8 factor-state binds through the AVX-512
/// `fold_pairs` permute plus deferred `WideGhashX4` message accumulate.
/// `FLOCK_NO_OPEN_FOLD8_BIND_X4=1` restores the compact scalar scan. Read once
/// per process; default ON. The selector is outside the bind, so there is no
/// per-element dispatch — the historical "avoid dispatch" scalar comment no
/// longer applies on Sapphire Rapids.
#[allow(dead_code)] // Retained same-binary rollback selector.
fn fold8_bind_x4_enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_NO_OPEN_FOLD8_BIND_X4").is_none());
    *ON
}

/// Bind one bank coordinate in two bit-major DirectFold8 factor states and
/// return the next round's `(u0,u2)` statistics. Characteristic-two identity
/// `e + r*(e+o)` (one product per output). Ranked SPR uses four-lane VPCLMUL
/// folds fused with the existing even/odd message reduction; other builds and
/// the kill switch keep the scalar scan.
#[inline]
pub(crate) fn fold_two_and_msg_in_place(
    f: &mut Vec<F128>,
    b: &mut Vec<F128>,
    r: F128,
) -> (F128, F128) {
    assert_eq!(f.len(), b.len());
    assert!(f.len().is_multiple_of(4));

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    if fold8_bind_x4_enabled() {
        // SAFETY: cfg gate guarantees avx512f+vpclmulqdq; the length
        // assertions match the kernel contract (even pair count, in-place
        // prefix write of already-consumed sources).
        return unsafe { x86_64::fold_two_and_msg_in_place(f, b, r) };
    }

    fold_two_and_msg_in_place_scalar(f, b, r)
}

/// Scalar DirectFold8 bind. Also the kill-switch restore and the test oracle.
pub(super) fn fold_two_and_msg_in_place_scalar(
    f: &mut Vec<F128>,
    b: &mut Vec<F128>,
    r: F128,
) -> (F128, F128) {
    let half = f.len() / 2;
    let mut u0 = F128::ZERO;
    let mut u2 = F128::ZERO;
    let mut t = 0usize;
    while t < half {
        let source = 2 * t;
        let f0 = f[source] + r * (f[source] + f[source + 1]);
        let f1 = f[source + 2] + r * (f[source + 2] + f[source + 3]);
        let b0 = b[source] + r * (b[source] + b[source + 1]);
        let b1 = b[source + 2] + r * (b[source + 2] + b[source + 3]);
        f[t] = f0;
        f[t + 1] = f1;
        b[t] = b0;
        b[t + 1] = b1;
        u0 += f0 * b0;
        u2 += (f0 + f1) * (b0 + b1);
        t += 2;
    }
    f.truncate(half);
    b.truncate(half);
    (u0, u2)
}

/// Add one scaled field slice into another: `dst[i] += scale * addend[i]`.
///
/// The ranked lazy-OOD fold uses this after folding the incumbent basis and
/// before reducing the next-round message.  Keeping the operation here lets
/// the Sapphire Rapids build issue four independent VPCLMUL products at once;
/// other builds retain the exact scalar field operation.
#[inline]
pub(crate) fn add_scaled(dst: &mut [F128], addend: &[F128], scale: F128) {
    assert_eq!(dst.len(), addend.len(), "scaled addend length changed");

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // length assertion guarantees one readable addend per destination slot.
    unsafe {
        x86_64::add_scaled(dst, addend, scale);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    for (value, &extra) in dst.iter_mut().zip(addend) {
        *value += scale * extra;
    }
}

/// Fold adjacent pairs from `src` and `addend` at `r`, add the scaled folded
/// addend, and write the result without materializing either intermediate:
/// `dst[t] = fold_r(src)[j] + scale * fold_r(addend)[j]`, where
/// `j = base + t`.
///
/// The ranked Ligerito open uses this to defer an ordinary basis glue into
/// the already-fused next fold. The AVX-512 leaf keeps all three products in
/// one register pipeline and writes `dst` once; other builds use the identical
/// scalar expression.
#[inline]
pub(crate) fn fold_pairs_with_scaled_addend(
    src: &[F128],
    addend: &[F128],
    base: usize,
    dst: &mut [F128],
    r: F128,
    scale: F128,
) {
    assert!(
        base <= src.len() / 2 && dst.len() <= src.len() / 2 - base,
        "fold source must contain both elements for every destination slot"
    );
    assert!(
        base <= addend.len() / 2 && dst.len() <= addend.len() / 2 - base,
        "scaled addend must contain both elements for every destination slot"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // bounds checks above cover both inputs for every output.
    unsafe {
        x86_64::fold_pairs_with_scaled_addend(src, addend, base, dst, r, scale);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    for (t, value) in dst.iter_mut().enumerate() {
        let index = 2 * (base + t);
        let src_even = src[index];
        let addend_even = addend[index];
        let src_folded = src_even + r * (src_even + src[index + 1]);
        let addend_folded = addend_even + r * (addend_even + addend[index + 1]);
        *value = src_folded + scale * addend_folded;
    }
}

/// Nested pair-fold of adjacent 4-tuples: `r0` then `r1`, even/odd pairing.
///
/// `dst[t] = low + r1·(low+high)` where
/// `low = a0 + r0·(a0+a1)`, `high = a2 + r0·(a2+a3)` and
/// `(a0,a1,a2,a3) = src[4t .. 4t+4]`. Writes `dst` only — the r0 mid stays
/// in registers on AVX-512. Portable / non-x86 is the scalar nested form.
#[inline]
pub(crate) fn fold4_nested(src: &[F128], dst: &mut [F128], r0: F128, r1: F128) {
    assert_eq!(
        src.len(),
        4 * dst.len(),
        "fold4 source must contain four elements for every destination slot"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // bounds check above guarantees all four source elements per output.
    unsafe {
        x86_64::fold4_nested(src, dst, r0, r1);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    {
        for (t, value) in dst.iter_mut().enumerate() {
            let a0 = src[4 * t];
            let a1 = src[4 * t + 1];
            let a2 = src[4 * t + 2];
            let a3 = src[4 * t + 3];
            let low = a0 + r0 * (a0 + a1);
            let high = a2 + r0 * (a2 + a3);
            *value = low + r1 * (low + high);
        }
    }
}

#[cfg(test)]
mod tests {
    /// `fold16_banked` (deferred-reduction AVX-512 kernel on x86; scalar
    /// elsewhere) equals the straight reduced sum `Σ w[b]·src[16t+b]` at
    /// lengths that hit the four-slot vector body and the scalar tail.
    #[test]
    fn fold16_banked_matches_scalar_reduced_sum() {
        use super::*;
        let mut state = 0x5eed_f01d_16u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        for n in [1usize, 3, 4, 5, 8, 13, 64, 257] {
            let src: Vec<F128> = (0..16 * n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let w: [F128; 16] = core::array::from_fn(|_| F128 {
                lo: next(),
                hi: next(),
            });
            let mut got = vec![F128::ZERO; n];
            fold16_banked(&src, &mut got, &w);
            for t in 0..n {
                let mut want = F128::ZERO;
                for b in 0..16 {
                    want += w[b] * src[16 * t + b];
                }
                assert_eq!(got[t], want, "n={n} t={t}");
            }
        }
        // Degenerate weights: one-hot, all-zero, all-one.
        let src: Vec<F128> = (0..16 * 8)
            .map(|i| F128 {
                lo: i as u64 * 7 + 1,
                hi: (i as u64) << 40,
            })
            .collect();
        for b0 in 0..16 {
            let mut w = [F128::ZERO; 16];
            w[b0] = F128::ONE;
            let mut got = vec![F128::ZERO; 8];
            fold16_banked(&src, &mut got, &w);
            for t in 0..8 {
                assert_eq!(got[t], src[16 * t + b0]);
            }
        }
        let w = [F128::ONE; 16];
        let mut got = vec![F128::ZERO; 8];
        fold16_banked(&src, &mut got, &w);
        for t in 0..8 {
            let want = src[16 * t..16 * t + 16]
                .iter()
                .fold(F128::ZERO, |a, &b| a + b);
            assert_eq!(got[t], want);
        }
    }

    /// Isolate every bank and output slot. Distinct full-field weights make
    /// a swapped pair limb observable even when the other source bank is zero.
    #[test]
    fn fold16_banked_one_hot_bank_and_slot() {
        use super::*;

        let w: [F128; 16] = core::array::from_fn(|b| F128 {
            lo: 0x9e37_79b9_7f4a_7c15u64.wrapping_mul(2 * b as u64 + 1),
            hi: 0xd1b5_4a32_d192_ed03u64.rotate_left(3 * b as u32),
        });
        let dirty = F128 {
            lo: 0xa55a_0123_4567_89ab,
            hi: 0xfedc_ba98_7654_3210,
        };
        for n in [4usize, 5, 7, 8] {
            for bank in 0..16 {
                for slot in 0..n {
                    let value = F128 {
                        lo: 0x8000_0000_0000_0001u64.rotate_left((bank + slot) as u32),
                        hi: 0xf00d_1234_5678_9abcu64 ^ ((16 * slot + bank) as u64),
                    };
                    let mut src = vec![F128::ZERO; 16 * n];
                    src[16 * slot + bank] = value;
                    let mut got = vec![dirty; n];
                    fold16_banked(&src, &mut got, &w);
                    for (t, &actual) in got.iter().enumerate() {
                        let want = if t == slot {
                            w[bank] * value
                        } else {
                            F128::ZERO
                        };
                        assert_eq!(actual, want, "n={n} bank={bank} slot={slot} t={t}");
                    }
                }
            }
        }
    }

    /// Low-only, high-only, zero diagonal, and reduction-boundary products
    /// exercise the unreduced L/H/D representation independently in each lane.
    #[test]
    fn fold16_banked_limb_and_reduction_boundaries() {
        use super::*;

        let patterns = [
            F128::ZERO,
            F128::ONE,
            F128 { lo: 2, hi: 0 },
            F128 {
                lo: 1 << 62,
                hi: 0,
            },
            F128 {
                lo: 1 << 63,
                hi: 0,
            },
            F128 { lo: 0, hi: 1 },
            F128 {
                lo: 0,
                hi: 1 << 62,
            },
            F128 {
                lo: 0,
                hi: 1 << 63,
            },
            F128 { lo: 1, hi: 1 },
            F128 {
                lo: 1 << 63,
                hi: 1 << 63,
            },
            F128 {
                lo: u64::MAX,
                hi: 0,
            },
            F128 {
                lo: u64::MAX,
                hi: u64::MAX,
            },
            F128 {
                lo: 0x0123_4567_89ab_cdef,
                hi: 0xfedc_ba98_7654_3210,
            },
        ];
        let dirty = F128 {
            lo: 0xdead,
            hi: 0xbeef,
        };
        for bank in 0..16 {
            for (xi, &x) in patterns.iter().enumerate() {
                let lanes = [
                    x,
                    F128 { lo: x.hi, hi: x.lo },
                    F128 { lo: x.lo, hi: x.lo },
                    F128 { lo: x.hi, hi: x.hi },
                ];
                let mut src = [F128::ZERO; 64];
                for (slot, &value) in lanes.iter().enumerate() {
                    src[16 * slot + bank] = value;
                }
                for (yi, &y) in patterns.iter().enumerate() {
                    let mut w = [F128::ZERO; 16];
                    w[bank] = y;
                    let mut got = [dirty; 4];
                    fold16_banked(&src, &mut got, &w);
                    for slot in 0..4 {
                        assert_eq!(
                            got[slot],
                            lanes[slot] * y,
                            "bank={bank} x={xi} y={yi} slot={slot}"
                        );
                    }
                }
            }
        }
    }

    /// Include all scalar-tail lengths, SUB-sized calls, and four F128
    /// offsets. Guards and destinations are initialized: this tests exact
    /// output writes and stale-content independence, not uninitialized reads.
    #[test]
    fn fold16_banked_dirty_slices_and_tails() {
        use super::*;

        let src_guard = F128 {
            lo: 0x0123_4567_89ab_cdef,
            hi: 0x7654_3210_fedc_ba98,
        };
        let dst_guard = F128 {
            lo: 0x8bad_f00d_dead_beef,
            hi: 0x55aa_aa55_f0f0_0f0f,
        };
        let w: [F128; 16] = core::array::from_fn(|b| F128 {
            lo: 0xd6e8_feb8_6659_fd93u64.wrapping_mul(b as u64 + 1),
            hi: 0xa076_1d64_78bd_642fu64.rotate_left(5 * b as u32),
        });
        for n in [
            0usize, 1, 2, 3, 4, 5, 6, 7, 8, 15, 16, 17, 63, 64, 65, 255, 256, 257, 1024, 1025,
        ] {
            for offset in 0..4 {
                let mut src = vec![src_guard; offset + 16 * n + 4];
                for i in 0..16 * n {
                    let index = i as u64 + 1;
                    src[offset + i] = F128 {
                        lo: index.wrapping_mul(0x9e37_79b9_7f4a_7c15),
                        hi: index.rotate_left(37) ^ 0x8000_0000_0000_0087,
                    };
                }
                let before = src.clone();
                let want: Vec<F128> = (0..n)
                    .map(|slot| {
                        (0..16).fold(F128::ZERO, |sum, bank| {
                            sum + w[bank] * src[offset + 16 * slot + bank]
                        })
                    })
                    .collect();
                let mut got = vec![dst_guard; offset + n + 4];
                fold16_banked(
                    &src[offset..offset + 16 * n],
                    &mut got[offset..offset + n],
                    &w,
                );
                assert_eq!(
                    &got[offset..offset + n],
                    want.as_slice(),
                    "n={n} offset={offset}"
                );
                assert!(got[..offset].iter().all(|&value| value == dst_guard));
                assert!(got[offset + n..].iter().all(|&value| value == dst_guard));
                assert_eq!(src, before, "source changed: n={n} offset={offset}");
            }
        }
    }

    /// The PCS open-phase materializers hand these two folds a RECYCLED
    /// destination (`crate::scratch::LocalBuf`), so both must write every
    /// output slot before reading it — the result may not depend on what an
    /// earlier job left in the buffer. This is the identity check for the
    /// `mid4` / `mid16` buffers of `materialize_direct_fold8` against the
    /// zero-filled form the kill switch restores.
    #[test]
    fn folds_ignore_stale_destination_contents() {
        use super::*;
        let mut state = 0xD1_47_57_A1_E0u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        for n in [1usize, 4, 5, 64, 257] {
            let w: [F128; 16] = core::array::from_fn(|_| F128 {
                lo: next(),
                hi: next(),
            });
            let src16: Vec<F128> = (0..16 * n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let mut zeroed = vec![F128::ZERO; n];
            let mut dirty: Vec<F128> = (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            fold16_banked(&src16, &mut zeroed, &w);
            fold16_banked(&src16, &mut dirty, &w);
            assert_eq!(dirty, zeroed, "fold16_banked n={n}");

            let (r0, r1) = (
                F128 {
                    lo: next(),
                    hi: next(),
                },
                F128 {
                    lo: next(),
                    hi: next(),
                },
            );
            let src4: Vec<F128> = (0..4 * n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let mut zeroed = vec![F128::ZERO; n];
            let mut dirty: Vec<F128> = (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            fold4_nested(&src4, &mut zeroed, r0, r1);
            fold4_nested(&src4, &mut dirty, r0, r1);
            assert_eq!(dirty, zeroed, "fold4_nested n={n}");
        }
    }

    /// AVX-512 (or portable) bind must match the scalar oracle at every
    /// ranked factor-state length plus a 4-element tail that misses the
    /// 8-output SIMD body.
    #[test]
    fn fold_two_and_msg_in_place_matches_scalar() {
        use super::*;
        let mut state = 0xF01D_8B1D_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        for n in [4usize, 8, 12, 16, 64, 256, 8192] {
            let r = F128 {
                lo: next(),
                hi: next(),
            };
            let f: Vec<F128> = (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let b: Vec<F128> = (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let mut f_got = f.clone();
            let mut b_got = b.clone();
            let mut f_want = f;
            let mut b_want = b;
            let got = fold_two_and_msg_in_place(&mut f_got, &mut b_got, r);
            let want = fold_two_and_msg_in_place_scalar(&mut f_want, &mut b_want, r);
            assert_eq!(got, want, "message n={n}");
            assert_eq!(f_got, f_want, "folded f n={n}");
            assert_eq!(b_got, b_want, "folded b n={n}");
        }
    }

    /// The three split-half leaves match the straightforward scalar formulas
    /// at lengths that hit the four-slot body, every tail residue, and the
    /// body-free short case.
    #[test]
    fn split_half_leaves_match_scalar() {
        use super::*;
        let mut state = 0xD15E_A5E0_1234_5678_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let mut draw = |n: usize| -> Vec<F128> {
            (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect()
        };
        for n in [1usize, 2, 3, 4, 5, 7, 8, 9, 16, 64, 4096] {
            let r = draw(1)[0];
            // bind_split_half
            let lo0 = draw(n);
            let hi = draw(n);
            let mut got = lo0.clone();
            bind_split_half(&mut got, &hi, r);
            for i in 0..n {
                assert_eq!(got[i], lo0[i] + r * (hi[i] + lo0[i]), "bind n={n} i={i}");
            }
            // msg_split_half
            let (chi, clo, zhi, zlo) = (draw(n), draw(n), draw(n), draw(n));
            let (e1, einf) = msg_split_half(&chi, &clo, &zhi, &zlo, n);
            let mut we1 = F128::ZERO;
            let mut weinf = F128::ZERO;
            for i in 0..n {
                we1 += chi[i] * zhi[i];
                weinf += (chi[i] + clo[i]) * (zhi[i] + zlo[i]);
            }
            assert_eq!((e1, einf), (we1, weinf), "msg n={n}");
            // bind_both_and_msg_split
            let (c0, c1, c2, c3) = (draw(n), draw(n), draw(n), draw(n));
            let (z0, z1, z2, z3) = (draw(n), draw(n), draw(n), draw(n));
            let (mut gc0, mut gc1, mut gz0, mut gz1) =
                (c0.clone(), c1.clone(), z0.clone(), z1.clone());
            let got = bind_both_and_msg_split(
                &mut gc0, &mut gc1, &c2, &c3, &mut gz0, &mut gz1, &z2, &z3, r, n,
            );
            let (mut wc0, mut wc1, mut wz0, mut wz1) =
                (c0.clone(), c1.clone(), z0.clone(), z1.clone());
            let mut we1 = F128::ZERO;
            let mut weinf = F128::ZERO;
            for i in 0..n {
                let lo = c0[i] + r * (c2[i] + c0[i]);
                let hi = c1[i] + r * (c3[i] + c1[i]);
                let zl = z0[i] + r * (z2[i] + z0[i]);
                let zh = z1[i] + r * (z3[i] + z1[i]);
                wc0[i] = lo;
                wc1[i] = hi;
                wz0[i] = zl;
                wz1[i] = zh;
                we1 += hi * zh;
                weinf += (hi + lo) * (zh + zl);
            }
            assert_eq!(got, (we1, weinf), "fused message n={n}");
            assert_eq!(
                (gc0, gc1, gz0, gz1),
                (wc0, wc1, wz0, wz1),
                "fused tables n={n}"
            );
        }
    }

    /// Chunking the split-half message and the fused bind is exact: the
    /// per-chunk results recombine to the whole-slice result.
    #[test]
    fn split_half_chunking_is_exact() {
        use super::*;
        let mut state = 0x0BAD_C0DE_F00D_9911_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let mut draw = |n: usize| -> Vec<F128> {
            (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect()
        };
        let n = 300usize;
        let (chi, clo, zhi, zlo) = (draw(n), draw(n), draw(n), draw(n));
        let whole = msg_split_half(&chi, &clo, &zhi, &zlo, n);
        for chunk in [1usize, 3, 4, 7, 64, 256] {
            let mut acc = (F128::ZERO, F128::ZERO);
            let mut i = 0;
            while i < n {
                let len = chunk.min(n - i);
                let part = msg_split_half(&chi[i..], &clo[i..], &zhi[i..], &zlo[i..], len);
                acc = (acc.0 + part.0, acc.1 + part.1);
                i += len;
            }
            assert_eq!(acc, whole, "chunk={chunk}");
        }
    }

    use super::*;

    #[test]
    fn selected_fold_matches_portable_with_offset_and_tail() {
        let mut state = 0x243f_6a88_85a3_08d3_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let src: Vec<F128> = (0..30)
            .map(|_| F128 {
                lo: next(),
                hi: next(),
            })
            .collect();
        let r = F128 {
            lo: next(),
            hi: next(),
        };
        let mut expected = vec![F128::ZERO; 9];
        let mut actual = vec![F128::ZERO; 9];

        portable::fold_pairs(&src, 3, &mut expected, r);
        fold_pairs(&src, 3, &mut actual, r);

        assert_eq!(actual, expected);
    }

    /// Portable one-mul leaf is bit-identical to the two-mul formula.
    #[test]
    fn portable_fold_pairs_matches_two_mul() {
        let mut state = 0x9e37_79b9_7f4a_7c15_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let src: Vec<F128> = (0..40)
            .map(|_| F128 {
                lo: next(),
                hi: next(),
            })
            .collect();
        let r = F128 {
            lo: next(),
            hi: next(),
        };
        let one_plus_r = F128::ONE + r;
        for &(base, n) in &[(0usize, 20usize), (3, 9), (1, 1), (5, 7)] {
            let mut got = vec![F128::ZERO; n];
            portable::fold_pairs(&src, base, &mut got, r);
            for t in 0..n {
                let s = 2 * (base + t);
                let expect = src[s] * one_plus_r + src[s + 1] * r;
                assert_eq!(got[t], expect, "base={base} t={t}");
            }
        }
    }

    /// The fused deferred-glue leaf is exactly a pair fold followed by one
    /// scaled add, including offset inputs and every AVX-512 tail residue.
    #[test]
    fn fold_pairs_with_scaled_addend_matches_materialized_glue_then_fold() {
        let mut state = 0xDEF3_22ED_61A0_0D5Eu64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let src: Vec<F128> = (0..96)
            .map(|_| F128 {
                lo: next(),
                hi: next(),
            })
            .collect();
        let r = F128 {
            lo: next(),
            hi: next(),
        };
        let scale = F128 {
            lo: next(),
            hi: next(),
        };
        for &(base, n) in &[(0usize, 1usize), (3, 3), (5, 4), (7, 5), (2, 11), (0, 32)] {
            let initial: Vec<F128> = (0..n)
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let addend: Vec<F128> = (0..src.len())
                .map(|_| F128 {
                    lo: next(),
                    hi: next(),
                })
                .collect();
            let mut glued = src.clone();
            add_scaled(&mut glued, &addend, scale);
            let mut want = initial.clone();
            fold_pairs(&glued, base, &mut want, r);
            let mut got = initial;
            fold_pairs_with_scaled_addend(&src, &addend, base, &mut got, r, scale);
            assert_eq!(got, want, "base={base} n={n}");
        }
    }

    /// Selected fold4_nested matches the scalar nested pair-fold, including a
    /// non-multiple-of-4 tail, and matches two `fold_pairs` (r0 then r1).
    #[test]
    fn selected_fold4_nested_matches_scalar_and_two_pass_pairs() {
        let mut state = 0xA5A5_C0DE_F00D_1234_u64;
        let mut next = || {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            state
        };
        let src: Vec<F128> = (0..44)
            .map(|_| F128 {
                lo: next(),
                hi: next(),
            })
            .collect();
        let r0 = F128 {
            lo: next(),
            hi: next(),
        };
        let r1 = F128 {
            lo: next(),
            hi: next(),
        };
        for n in [1usize, 3, 4, 5, 7, 8, 11] {
            let mut got = vec![F128::ZERO; n];
            let mut portable_got = vec![F128::ZERO; n];
            fold4_nested(&src[..4 * n], &mut got, r0, r1);
            portable::fold4_nested(&src[..4 * n], &mut portable_got, r0, r1);
            assert_eq!(got, portable_got, "portable n={n}");
            for t in 0..n {
                let a0 = src[4 * t];
                let a1 = src[4 * t + 1];
                let a2 = src[4 * t + 2];
                let a3 = src[4 * t + 3];
                let low = a0 + r0 * (a0 + a1);
                let high = a2 + r0 * (a2 + a3);
                let expect = low + r1 * (low + high);
                assert_eq!(got[t], expect, "scalar n={n} t={t}");
            }
            // Two-pass fold_pairs on a tiny stack mid (test only) must agree.
            let mut mid = vec![F128::ZERO; 2 * n];
            let mut via_pairs = vec![F128::ZERO; n];
            fold_pairs(&src[..4 * n], 0, &mut mid, r0);
            fold_pairs(&mid, 0, &mut via_pairs, r1);
            assert_eq!(got, via_pairs, "two-pass pairs n={n}");
        }
    }
}

/// Sixteen-bank weighted fold: `dst[t] = Σ_{b<16} w[b] · src[16t + b]`.
///
/// AVX-512: paired-bank Karatsuba with one deferred reduction per output
/// lane. Other targets: the straightforward reduced form. Same field element
/// either way.
#[inline]
pub(crate) fn fold16_banked(src: &[F128], dst: &mut [F128], w: &[F128; 16]) {
    assert_eq!(
        src.len(),
        16 * dst.len(),
        "fold16 source must contain sixteen elements for every destination slot"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // bounds check above guarantees all sixteen source elements per output.
    unsafe {
        x86_64::fold16_banked(src, dst, w);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    {
        for (t, value) in dst.iter_mut().enumerate() {
            let mut v = F128::ZERO;
            for b in 0..16 {
                v += w[b] * src[16 * t + b];
            }
            *value = v;
        }
    }
}

/// Sixty-four-bank weighted fold: `dst[t] = Σ_{b<64} w[b] · src[64t + b]`.
///
/// Weights may be arbitrary field elements; no challenge factorization is
/// required. Every destination is overwritten without reading its old value.
/// AVX-512 uses the banked dot-product leaf; other targets keep the direct
/// reduced sum. Neither input needs alignment beyond that of `F128`.
#[inline]
#[allow(dead_code)] // F-only x86 caller; retain the scalar form on other builds.
pub(crate) fn fold64_banked(src: &[F128], dst: &mut [F128], w: &[F128; 64]) {
    assert!(
        src.len().is_multiple_of(64) && src.len() / 64 == dst.len(),
        "fold64 source must contain exactly sixty-four elements for every destination slot"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: cfg supplies the required CPU features. The division-based
    // geometry check cannot overflow and covers all 64 inputs per output;
    // the slice borrows also exclude overlap with the destination.
    unsafe {
        x86_64::fold64_banked(src, dst, w);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    for (row, value) in src.chunks_exact(64).zip(dst.iter_mut()) {
        *value = row
            .iter()
            .zip(w)
            .fold(F128::ZERO, |sum, (&x, &weight)| sum + x * weight);
    }
}

#[cfg(test)]
mod fold64_tests {
    use super::*;

    const DIRTY: F128 = F128 {
        lo: 0x8bad_f00d_dead_beef,
        hi: 0x55aa_aa55_f0f0_0f0f,
    };

    fn sample(index: usize, salt: u64) -> F128 {
        let word = (index as u64)
            .wrapping_add(1)
            .wrapping_mul(0x9e37_79b9_7f4a_7c15);
        F128 {
            lo: word ^ salt,
            hi: word.rotate_left(29) ^ salt.rotate_right(11) ^ 0x8000_0000_0000_0087,
        }
    }

    // Each product is reduced independently by scalar F128 multiplication;
    // this does not share the new leaf's bank packing or deferred accumulator.
    fn scalar_dot(src: &[F128], w: &[F128; 64]) -> Vec<F128> {
        src.chunks_exact(64)
            .map(|row| {
                row.iter()
                    .zip(w)
                    .fold(F128::ZERO, |sum, (&x, &weight)| sum + x * weight)
            })
            .collect()
    }

    #[test]
    fn fold64_banked_matches_scalar_arbitrary_weights() {
        for salt in [0x5eed_f01d_64u64, 0xd1b5_4a32_d192_ed03, u64::MAX] {
            let w = core::array::from_fn(|bank| sample(bank, salt));
            for n in [1usize, 4, 5, 8, 9, 17] {
                let src: Vec<F128> = (0..64 * n)
                    .map(|i| sample(i, salt.rotate_left(23)))
                    .collect();
                let mut got = vec![DIRTY; n];
                fold64_banked(&src, &mut got, &w);
                assert_eq!(got, scalar_dot(&src, &w), "n={n} salt={salt:#x}");
            }
        }
    }

    /// All 64 bank positions include every internal 128-bit SIMD lane and
    /// pair member. Nine distinct output positions also expose cross-output
    /// contamination and any short tail selected by the implementation.
    #[test]
    fn fold64_banked_one_hot_bank_and_output_lane() {
        let w = core::array::from_fn(|bank| sample(bank, 0xd6e8_feb8_6659_fd93));
        for bank in 0..64 {
            for slot in 0..9 {
                let value = sample(64 * slot + bank, 0xa076_1d64_78bd_642f);
                let mut src = vec![F128::ZERO; 64 * 9];
                src[64 * slot + bank] = value;
                let mut got = [DIRTY; 9];
                fold64_banked(&src, &mut got, &w);
                for (t, &actual) in got.iter().enumerate() {
                    let want = if t == slot {
                        value * w[bank]
                    } else {
                        F128::ZERO
                    };
                    assert_eq!(actual, want, "bank={bank} slot={slot} t={t}");
                }
            }
        }
    }

    #[test]
    fn fold64_banked_zero_one_and_full_field_patterns() {
        let inputs = [
            vec![F128::ZERO; 64 * 5],
            vec![F128::ONE; 64 * 5],
            (0..64 * 5)
                .map(|i| sample(i, 0x243f_6a88_85a3_08d3))
                .collect(),
        ];
        let weights = [
            [F128::ZERO; 64],
            [F128::ONE; 64],
            [F128 {
                lo: u64::MAX,
                hi: u64::MAX,
            }; 64],
            core::array::from_fn(|bank| sample(bank, 0x1319_8a2e_0370_7344)),
        ];
        for (input_case, src) in inputs.iter().enumerate() {
            for (weight_case, w) in weights.iter().enumerate() {
                let mut got = [DIRTY; 5];
                fold64_banked(src, &mut got, w);
                assert_eq!(
                    got.as_slice(),
                    scalar_dot(src, w).as_slice(),
                    "input={input_case} weights={weight_case}"
                );
            }
        }
    }

    /// Isolated low/high limbs, zero Karatsuba diagonals, and products of
    /// degree 128 or 254. The second output swaps source limbs independently.
    #[test]
    fn fold64_banked_limb_and_reduction_boundaries() {
        let x = F128 { lo: 2, hi: 0 };
        let lo_top = F128 {
            lo: 1 << 63,
            hi: 0,
        };
        let hi_low = F128 { lo: 0, hi: 1 };
        let hi_top = F128 {
            lo: 0,
            hi: 1 << 63,
        };
        let both_top = F128 {
            lo: 1 << 63,
            hi: 1 << 63,
        };
        let full = F128 {
            lo: u64::MAX,
            hi: u64::MAX,
        };
        let products = [
            (F128::ONE, F128::ONE),
            (lo_top, x),
            (hi_low, hi_low),
            (hi_top, x),
            (hi_top, hi_top),
            (full, full),
            (both_top, both_top),
            (
                F128 {
                    lo: u64::MAX,
                    hi: 0,
                },
                F128 {
                    lo: 0,
                    hi: u64::MAX,
                },
            ),
        ];
        for bank in 0..64 {
            for (case, &(value, weight)) in products.iter().enumerate() {
                let swapped = F128 {
                    lo: value.hi,
                    hi: value.lo,
                };
                let mut src = [F128::ZERO; 128];
                src[bank] = value;
                src[64 + bank] = swapped;
                let mut w = [F128::ZERO; 64];
                w[bank] = weight;
                let mut got = [DIRTY; 2];
                fold64_banked(&src, &mut got, &w);
                assert_eq!(got, [value * weight, swapped * weight], "bank={bank} case={case}");
                if case == 2 || case == 3 {
                    // x^128 = x^7 + x^2 + x + 1 in the GHASH field.
                    assert_eq!(got[0], F128 { lo: 0x87, hi: 0 });
                }
            }
        }
    }

    /// Recycled destinations, distinct input/output offsets, short lengths,
    /// and 256-slot chunk boundaries. All halos are initialized; this checks
    /// exact writes and stale-value independence, not absence of input reads.
    #[test]
    fn fold64_banked_dirty_offsets_and_tails() {
        let src_guard = F128 {
            lo: 0x0123_4567_89ab_cdef,
            hi: 0x7654_3210_fedc_ba98,
        };
        let w = core::array::from_fn(|bank| sample(bank, 0xfeed_1234_5678_9abc));
        let weights_before = w;
        for n in [0usize, 1, 2, 3, 4, 5, 7, 8, 9, 15, 16, 17, 255, 256, 257] {
            for offset in 0..4 {
                let src_start = 1 + offset;
                let dst_start = 4 - offset;
                let mut src = vec![src_guard; src_start + 64 * n + 4];
                for (i, value) in src[src_start..src_start + 64 * n].iter_mut().enumerate() {
                    *value = sample(i, 0x0bad_c0de_f00d_9911);
                }
                let source_before = src.clone();
                let want = scalar_dot(&src[src_start..src_start + 64 * n], &w);
                let mut got = vec![DIRTY; dst_start + n + 4];
                fold64_banked(
                    &src[src_start..src_start + 64 * n],
                    &mut got[dst_start..dst_start + n],
                    &w,
                );
                assert_eq!(
                    &got[dst_start..dst_start + n],
                    want.as_slice(),
                    "n={n} offset={offset}"
                );
                assert!(got[..dst_start].iter().all(|&value| value == DIRTY));
                assert!(got[dst_start + n..].iter().all(|&value| value == DIRTY));
                assert_eq!(src, source_before, "source changed: n={n} offset={offset}");
                assert_eq!(w, weights_before, "weights changed: n={n} offset={offset}");
            }
        }
    }

    #[test]
    fn fold64_banked_matches_six_lsb_pair_rounds() {
        let challenges = [
            [F128::ZERO; 6],
            [F128::ONE; 6],
            core::array::from_fn(|bit| {
                if bit % 2 == 0 {
                    F128::ZERO
                } else {
                    F128::ONE
                }
            }),
            core::array::from_fn(|bit| sample(bit, 0x6a09_e667_f3bc_c909)),
        ];
        for n in [1usize, 2, 5, 9] {
            let src: Vec<F128> = (0..64 * n)
                .map(|i| sample(i, 0xbb67_ae85_84ca_a73b))
                .collect();
            for (case, rounds) in challenges.iter().enumerate() {
                let w = core::array::from_fn(|bank| {
                    rounds.iter().enumerate().fold(F128::ONE, |weight, (bit, &r)| {
                        let factor = if bank & (1 << bit) == 0 {
                            F128::ONE + r
                        } else {
                            r
                        };
                        weight * factor
                    })
                });
                let mut want = src.clone();
                for &r in rounds {
                    let mut next = vec![DIRTY; want.len() / 2];
                    fold_pairs(&want, 0, &mut next, r);
                    want = next;
                }
                let mut got = vec![DIRTY; n];
                fold64_banked(&src, &mut got, &w);
                assert_eq!(got, want, "n={n} rounds={case}");
                assert_eq!(got, scalar_dot(&src, &w));
            }
        }
    }

    /// w16 is arbitrary, not assumed to be a four-challenge equality table.
    /// Bank bits 0..3 select w16; bits 4 and 5 select r4 and r5, respectively.
    #[test]
    fn fold64_banked_matches_arbitrary_fold16_then_fold4() {
        let pairs = [
            (F128::ZERO, F128::ZERO),
            (F128::ONE, F128::ZERO),
            (F128::ZERO, F128::ONE),
            (F128::ONE, F128::ONE),
            (
                sample(0, 0x3c6e_f372_fe94_f82b),
                sample(1, 0xa54f_f53a_5f1d_36f1),
            ),
            (
                F128 {
                    lo: 0,
                    hi: 1 << 63,
                },
                F128 {
                    lo: u64::MAX,
                    hi: u64::MAX,
                },
            ),
        ];
        for n in [1usize, 3, 4, 5, 9] {
            let src: Vec<F128> = (0..64 * n)
                .map(|i| sample(i, 0x510e_527f_ade6_82d1))
                .collect();
            for (case, &(r4, r5)) in pairs.iter().enumerate() {
                let w16: [F128; 16] =
                    core::array::from_fn(|bank| sample(bank + 16 * case, 0x9b05_688c_2b3e_6c1f));
                let q = [
                    (F128::ONE + r4) * (F128::ONE + r5),
                    r4 * (F128::ONE + r5),
                    (F128::ONE + r4) * r5,
                    r4 * r5,
                ];
                let w = core::array::from_fn(|bank| w16[bank & 15] * q[bank >> 4]);
                let mut mid = vec![DIRTY; 4 * n];
                fold16_banked(&src, &mut mid, &w16);
                let mut want = vec![DIRTY; n];
                fold4_nested(&mid, &mut want, r4, r5);
                let mut got = vec![DIRTY; n];
                fold64_banked(&src, &mut got, &w);
                assert_eq!(got, want, "n={n} pair={case}");
                assert_eq!(got, scalar_dot(&src, &w));
            }
        }
    }

    #[test]
    fn fold64_banked_rejects_inexact_geometry_before_writing() {
        let w = core::array::from_fn(|bank| sample(bank, 0x1f83_d9ab_fb41_bd6b));
        for (src_len, dst_len) in [
            (0usize, 1usize),
            (1, 0),
            (1, 1),
            (63, 1),
            (65, 1),
            (64, 0),
            (64, 2),
            (127, 2),
            (129, 2),
            (128, 1),
            (192, 2),
            (64, 3),
        ] {
            let src: Vec<F128> = (0..src_len)
                .map(|i| sample(i, 0x5be0_cd19_137e_2179))
                .collect();
            let source_before = src.clone();
            let mut dst = vec![DIRTY; dst_len + 2];
            let destination_before = dst.clone();
            let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                fold64_banked(&src, &mut dst[1..1 + dst_len], &w);
            }));
            assert!(result.is_err(), "src={src_len} dst={dst_len}");
            assert_eq!(dst, destination_before);
            assert_eq!(src, source_before);
        }
    }
}

/// Bind one top-bit split in place: `lo[i] = lo[i] + r·(hi[i] + lo[i])`.
///
/// The pair members live in two separate contiguous runs (top-bit split),
/// not adjacent slots — [`fold_pairs`] handles the adjacent layout instead.
/// Same char-2 one-mul identity either way.
#[inline]
pub(crate) fn bind_split_half(lo: &mut [F128], hi: &[F128], r: F128) {
    assert!(
        hi.len() >= lo.len(),
        "split bind needs one high slot per low"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // length assertion guarantees one readable high slot per low slot.
    unsafe {
        x86_64::bind_split_half(lo, hi, r);
    }

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    for i in 0..lo.len() {
        lo[i] = lo[i] + r * (hi[i] + lo[i]);
    }
}

/// Product-sumcheck message over a top-bit split:
/// `(Σ chi·zhi, Σ (chi+clo)·(zhi+zlo))` over the first `n` slots.
///
/// AVX-512 accumulates each sum unreduced and reduces once; reduction is
/// F₂-linear, so that is the same field element as the reduced-per-term sum,
/// and XOR regrouping across lanes is exact.
#[inline]
pub(crate) fn msg_split_half(
    chi: &[F128],
    clo: &[F128],
    zhi: &[F128],
    zlo: &[F128],
    n: usize,
) -> (F128, F128) {
    assert!(
        chi.len() >= n && clo.len() >= n && zhi.len() >= n && zlo.len() >= n,
        "split message needs all four runs"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // assertion guarantees every run covers `n`.
    return unsafe { x86_64::msg_split_half(chi, clo, zhi, zlo, n) };

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    {
        let mut e1 = F128::ZERO;
        let mut einf = F128::ZERO;
        for i in 0..n {
            e1 += chi[i] * zhi[i];
            einf += (chi[i] + clo[i]) * (zhi[i] + zlo[i]);
        }
        (e1, einf)
    }
}

/// Fused quarter bind of `(comb, z)` at `r` plus the next round's message.
/// See the x86 kernel for the per-slot definition; the quarters are four
/// separate contiguous runs.
#[inline]
#[allow(clippy::too_many_arguments)]
pub(crate) fn bind_both_and_msg_split(
    cq0: &mut [F128],
    cq1: &mut [F128],
    cq2: &[F128],
    cq3: &[F128],
    zq0: &mut [F128],
    zq1: &mut [F128],
    zq2: &[F128],
    zq3: &[F128],
    r: F128,
    n: usize,
) -> (F128, F128) {
    assert!(
        cq0.len() >= n
            && cq1.len() >= n
            && cq2.len() >= n
            && cq3.len() >= n
            && zq0.len() >= n
            && zq1.len() >= n
            && zq2.len() >= n
            && zq3.len() >= n,
        "fused split bind needs all eight quarters"
    );

    #[cfg(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    ))]
    // SAFETY: the cfg gate guarantees the required target features and the
    // assertion guarantees every quarter covers `n`.
    return unsafe {
        x86_64::bind_both_and_msg_split(cq0, cq1, cq2, cq3, zq0, zq1, zq2, zq3, r, n)
    };

    #[cfg(not(all(
        target_arch = "x86_64",
        target_feature = "avx512f",
        target_feature = "vpclmulqdq"
    )))]
    {
        let mut e1 = F128::ZERO;
        let mut einf = F128::ZERO;
        for i in 0..n {
            let lo = cq0[i] + r * (cq2[i] + cq0[i]);
            let hi = cq1[i] + r * (cq3[i] + cq1[i]);
            let zlo = zq0[i] + r * (zq2[i] + zq0[i]);
            let zhi = zq1[i] + r * (zq3[i] + zq1[i]);
            cq0[i] = lo;
            cq1[i] = hi;
            zq0[i] = zlo;
            zq1[i] = zhi;
            e1 += hi * zhi;
            einf += (hi + lo) * (zhi + zlo);
        }
        (e1, einf)
    }
}
