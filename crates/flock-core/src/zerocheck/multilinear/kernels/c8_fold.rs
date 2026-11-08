//! Three-challenge GFNI row fold. Matrices include all three linear weights.
use super::{F128, build_row_fold_mats_from_cols};
use core::arch::x86_64::*;

#[repr(C, align(64))]
pub(crate) struct Mats([[u64; 8]; 128]);
impl Mats {
    pub(crate) fn new(data: &[F128], rho: [F128; 3]) -> Self {
        let base: [F128; 64] = core::array::from_fn(|i| data[(i / 8) * 256 + (1usize << (i % 8))]);
        let per: [[u64; 128]; 8] = core::array::from_fn(|c| {
            let weight = (0..3).fold(F128::ONE, |a, k| {
                a * if c & (1 << k) == 0 {
                    F128::ONE + rho[k]
                } else {
                    rho[k]
                }
            });
            let cols: [F128; 64] = core::array::from_fn(|i| weight * base[i]);
            build_row_fold_mats_from_cols(&cols)
        });
        Self(core::array::from_fn(|i| {
            let (half, j) = (i / 64, i % 64);
            core::array::from_fn(|byte| per[j / 8][(j % 8) * 16 + half * 8 + byte])
        }))
    }
}
#[inline(always)]
unsafe fn trq(x: [__m512i; 8]) -> [__m512i; 8] {
    unsafe {
        let t0 = _mm512_unpacklo_epi64(x[0], x[1]);
        let t1 = _mm512_unpackhi_epi64(x[0], x[1]);
        let t2 = _mm512_unpacklo_epi64(x[2], x[3]);
        let t3 = _mm512_unpackhi_epi64(x[2], x[3]);
        let t4 = _mm512_unpacklo_epi64(x[4], x[5]);
        let t5 = _mm512_unpackhi_epi64(x[4], x[5]);
        let t6 = _mm512_unpacklo_epi64(x[6], x[7]);
        let t7 = _mm512_unpackhi_epi64(x[6], x[7]);
        let u0 = _mm512_shuffle_i64x2::<0x88>(t0, t2);
        let u1 = _mm512_shuffle_i64x2::<0xdd>(t0, t2);
        let u2 = _mm512_shuffle_i64x2::<0x88>(t1, t3);
        let u3 = _mm512_shuffle_i64x2::<0xdd>(t1, t3);
        let u4 = _mm512_shuffle_i64x2::<0x88>(t4, t6);
        let u5 = _mm512_shuffle_i64x2::<0xdd>(t4, t6);
        let u6 = _mm512_shuffle_i64x2::<0x88>(t5, t7);
        let u7 = _mm512_shuffle_i64x2::<0xdd>(t5, t7);
        [
            _mm512_shuffle_i64x2::<0x88>(u0, u4),
            _mm512_shuffle_i64x2::<0x88>(u2, u6),
            _mm512_shuffle_i64x2::<0x88>(u1, u5),
            _mm512_shuffle_i64x2::<0x88>(u3, u7),
            _mm512_shuffle_i64x2::<0xdd>(u0, u4),
            _mm512_shuffle_i64x2::<0xdd>(u2, u6),
            _mm512_shuffle_i64x2::<0xdd>(u1, u5),
            _mm512_shuffle_i64x2::<0xdd>(u3, u7),
        ]
    }
}
/// Read exactly 64 packed rows (512 bytes), returning even and odd groups.
/// All eight rows of each group are folded with the current proof challenges.
#[inline(never)]
pub(crate) unsafe fn fold64(rows: *const u8, m: &Mats) -> [__m512i; 2] {
    unsafe {
        let columns = trq(core::array::from_fn(|i| {
            _mm512_loadu_si512(rows.add(64 * i).cast())
        }));
        const BT: [u8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50,
            58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37,
            45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast());
        let mut lo = _mm512_setzero_si512();
        let mut hi = _mm512_setzero_si512();
        macro_rules! column { ($c:literal) => {{
            let bytes=_mm512_permutexvar_epi8(bt,columns[$c]);
            let mut words=[0u64;8];
            _mm512_storeu_si512(words.as_mut_ptr().cast(),bytes);
            // Publish packed qwords before broadcasting. This prevents LLVM
            // replacing memory broadcasts with general lane permutations.
            core::arch::asm!("/* {ptr} */",ptr=in(reg) words.as_ptr(),options(nostack,preserves_flags));
            macro_rules! term { ($j:literal) => {{
                let x=_mm512_set1_epi64(words[$j] as i64);
                lo=_mm512_xor_si512(lo,_mm512_gf2p8affine_epi64_epi8::<0>(x,_mm512_load_si512(m.0[$c*8+$j].as_ptr().cast())));
                hi=_mm512_xor_si512(hi,_mm512_gf2p8affine_epi64_epi8::<0>(x,_mm512_load_si512(m.0[64+$c*8+$j].as_ptr().cast())));
            }}; }
            term!(0);term!(1);term!(2);term!(3);term!(4);term!(5);term!(6);term!(7);
        }}; }
        column!(0);
        column!(1);
        column!(2);
        column!(3);
        column!(4);
        column!(5);
        column!(6);
        column!(7);
        let lo = _mm512_permutexvar_epi8(bt, lo);
        let hi = _mm512_permutexvar_epi8(bt, hi);
        [_mm512_unpacklo_epi64(lo, hi), _mm512_unpackhi_epi64(lo, hi)]
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn fused_three_challenges_match_scalar_rows() {
        let mut state = 0x123456789abcdef0u64;
        let mut next = || {
            state = state
                .wrapping_mul(6364136223846793005)
                .wrapping_add(1442695040888963407);
            state
        };
        for case in 0..12 {
            let basis: [F128; 64] = core::array::from_fn(|_| F128 {
                lo: next(),
                hi: next(),
            });
            let mut data = vec![F128::ZERO; 2048];
            for byte in 0..8 {
                for value in 0..256 {
                    for bit in 0..8 {
                        if value & (1 << bit) != 0 {
                            data[byte * 256 + value] += basis[byte * 8 + bit];
                        }
                    }
                }
            }
            let rho = match case {
                0 => [F128::ZERO; 3],
                1 => [F128::ONE; 3],
                _ => core::array::from_fn(|_| F128 {
                    lo: next(),
                    hi: next(),
                }),
            };
            let mats = Mats::new(&data, rho);
            let rows: [u8; 1024] = core::array::from_fn(|_| next() as u8);
            let mut want = [F128::ZERO; 8];
            for group in 0..8 {
                for c in 0..8 {
                    let weight = (0..3).fold(F128::ONE, |a, k| {
                        a * if c & (1 << k) == 0 {
                            F128::ONE + rho[k]
                        } else {
                            rho[k]
                        }
                    });
                    for j in 0..8 {
                        want[group] +=
                            weight * data[j * 256 + rows[(group * 8 + c) * 8 + j] as usize];
                    }
                }
            }
            let got = unsafe { fold64(rows.as_ptr(), &mats) };
            unsafe {
                let [e0, o0] = got;
                let [e1, o1] = fold64(rows.as_ptr().add(512), &mats);
                let expected = [
                    _mm512_shuffle_i64x2::<0x88>(e0, e1),
                    _mm512_shuffle_i64x2::<0x88>(o0, o1),
                    _mm512_shuffle_i64x2::<0xdd>(e0, e1),
                    _mm512_shuffle_i64x2::<0xdd>(o0, o1),
                ];
                let expected: [[u64; 8]; 4] = core::mem::transmute(expected);
                let paired: [[u64; 8]; 4] = core::mem::transmute(fold128(rows.as_ptr(), &mats));
                assert_eq!(paired, expected, "paired fold case={case}");
            }

            let one = F128::ONE;
            let old_mats = super::super::build_cfold_mats(
                &data,
                [
                    (one + rho[0]) * (one + rho[1]),
                    rho[0] * (one + rho[1]),
                    (one + rho[0]) * rho[1],
                    rho[0] * rho[1],
                ],
            );
            unsafe {
                use crate::field::gf2_128::x86_64::{ghash_broadcast_split, ghash_mul_x4_split};
                let [q0, q1, q2, q3] =
                    super::super::gfni_fold64_rows_c4_lm_registers(rows.as_ptr(), &old_mats);
                let (r, r64) = ghash_broadcast_split(rho[2]);
                let oe = _mm512_xor_si512(q0, ghash_mul_x4_split(_mm512_xor_si512(q0, q1), r, r64));
                let oo = _mm512_xor_si512(q2, ghash_mul_x4_split(_mm512_xor_si512(q2, q3), r, r64));
                let old: [[u64; 8]; 2] = core::mem::transmute([oe, oo]);
                let new: [[u64; 8]; 2] = core::mem::transmute(got);
                assert_eq!(old, new, "original C4/rho3 route case={case}");
            }
            let even: [F128; 4] = unsafe { core::mem::transmute(got[0]) };
            let odd: [F128; 4] = unsafe { core::mem::transmute(got[1]) };
            for i in 0..4 {
                assert_eq!(even[i], want[2 * i], "case={case} even={i}");
                assert_eq!(odd[i], want[2 * i + 1], "case={case} odd={i}");
            }
        }
    }
    #[test]
    #[ignore]
    fn c8_fold_kernel_timing() {
        let data: Vec<F128> = (0..2048)
            .map(|i| F128 {
                lo: (i as u64).wrapping_mul(0x123456789abcdef),
                hi: (i as u64).wrapping_mul(0xfedcba987654321),
            })
            .collect();
        let rho = [
            F128 { lo: 17, hi: 89 },
            F128 { lo: 234, hi: 122 },
            F128 { lo: 314, hi: 159 },
        ];
        let mats = Mats::new(&data, rho);
        let one = F128::ONE;
        let old = super::super::build_cfold_mats(
            &data,
            [
                (one + rho[0]) * (one + rho[1]),
                rho[0] * (one + rho[1]),
                (one + rho[0]) * rho[1],
                rho[0] * rho[1],
            ],
        );
        let rows: [u8; 512] = core::array::from_fn(|i| i.wrapping_mul(197) as u8);
        for pass in 0..8 {
            for new in [pass % 2 == 0, pass % 2 != 0] {
                let start = std::time::Instant::now();
                for _ in 0..20000 {
                    unsafe {
                        let input = std::hint::black_box(rows.as_ptr());
                        let out = if new {
                            fold64(input, &mats)
                        } else {
                            use crate::field::gf2_128::x86_64::{
                                ghash_broadcast_split, ghash_mul_x4_split,
                            };
                            let [q0, q1, q2, q3] =
                                super::super::gfni_fold64_rows_c4_lm_registers(input, &old);
                            let (r, r64) = ghash_broadcast_split(rho[2]);
                            [
                                _mm512_xor_si512(
                                    q0,
                                    ghash_mul_x4_split(_mm512_xor_si512(q0, q1), r, r64),
                                ),
                                _mm512_xor_si512(
                                    q2,
                                    ghash_mul_x4_split(_mm512_xor_si512(q2, q3), r, r64),
                                ),
                            ]
                        };
                        std::hint::black_box(out);
                    }
                }
                eprintln!(
                    "c8_timing pass={pass} new={new} ns_per_tile={}",
                    start.elapsed().as_nanos() / 20000
                );
            }
        }
    }
}

/// Fold two adjacent 64-row inputs while reusing each matrix load.
#[inline(never)]
pub(crate) unsafe fn fold128(rows: *const u8, m: &Mats) -> [__m512i; 4] {
    unsafe {
        let mut packed = [[0u64; 64]; 2];
        const BT: [u8; 64] = [
            0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50,
            58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37,
            45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
        ];
        let bt = _mm512_loadu_si512(BT.as_ptr().cast());
        for half in 0..2 {
            let cols = trq(core::array::from_fn(|i| {
                _mm512_loadu_si512(rows.add(half * 512 + i * 64).cast())
            }));
            for c in 0..8 {
                _mm512_storeu_si512(
                    packed[half].as_mut_ptr().add(c * 8).cast(),
                    _mm512_permutexvar_epi8(bt, cols[c]),
                );
            }
        }
        core::arch::asm!("/* {ptr} */",ptr=in(reg) packed.as_ptr(),options(nostack,preserves_flags));
        let z = _mm512_setzero_si512();
        let (mut l0, mut h0, mut l1, mut h1) = (z, z, z, z);
        macro_rules! term {
            ($j:literal) => {{
                let x0 = _mm512_set1_epi64(packed[0][$j] as i64);
                let x1 = _mm512_set1_epi64(packed[1][$j] as i64);
                let ml = _mm512_load_si512(m.0[$j].as_ptr().cast());
                let mh = _mm512_load_si512(m.0[64 + $j].as_ptr().cast());
                l0 = _mm512_xor_si512(l0, _mm512_gf2p8affine_epi64_epi8::<0>(x0, ml));
                h0 = _mm512_xor_si512(h0, _mm512_gf2p8affine_epi64_epi8::<0>(x0, mh));
                l1 = _mm512_xor_si512(l1, _mm512_gf2p8affine_epi64_epi8::<0>(x1, ml));
                h1 = _mm512_xor_si512(h1, _mm512_gf2p8affine_epi64_epi8::<0>(x1, mh));
            }};
        }
        term!(0);
        term!(1);
        term!(2);
        term!(3);
        term!(4);
        term!(5);
        term!(6);
        term!(7);
        term!(8);
        term!(9);
        term!(10);
        term!(11);
        term!(12);
        term!(13);
        term!(14);
        term!(15);
        term!(16);
        term!(17);
        term!(18);
        term!(19);
        term!(20);
        term!(21);
        term!(22);
        term!(23);
        term!(24);
        term!(25);
        term!(26);
        term!(27);
        term!(28);
        term!(29);
        term!(30);
        term!(31);
        term!(32);
        term!(33);
        term!(34);
        term!(35);
        term!(36);
        term!(37);
        term!(38);
        term!(39);
        term!(40);
        term!(41);
        term!(42);
        term!(43);
        term!(44);
        term!(45);
        term!(46);
        term!(47);
        term!(48);
        term!(49);
        term!(50);
        term!(51);
        term!(52);
        term!(53);
        term!(54);
        term!(55);
        term!(56);
        term!(57);
        term!(58);
        term!(59);
        term!(60);
        term!(61);
        term!(62);
        term!(63);
        let l0 = _mm512_permutexvar_epi8(bt, l0);
        let h0 = _mm512_permutexvar_epi8(bt, h0);
        let l1 = _mm512_permutexvar_epi8(bt, l1);
        let h1 = _mm512_permutexvar_epi8(bt, h1);
        let e0 = _mm512_unpacklo_epi64(l0, h0);
        let o0 = _mm512_unpackhi_epi64(l0, h0);
        let e1 = _mm512_unpacklo_epi64(l1, h1);
        let o1 = _mm512_unpackhi_epi64(l1, h1);
        [
            _mm512_shuffle_i64x2::<0x88>(e0, e1),
            _mm512_shuffle_i64x2::<0x88>(o0, o1),
            _mm512_shuffle_i64x2::<0xdd>(e0, e1),
            _mm512_shuffle_i64x2::<0xdd>(o0, o1),
        ]
    }
}
