//! Cross-instance B folds. Drop proven public-one bytes and bake rho3 into
//! the linear map. All omitted bytes are checked in the already-loaded input;
//! arbitrary B values take an exact scalar fallback, not an assumed brand.
use crate::field::F128;

#[repr(C, align(64))]
pub(super) struct Matrix(pub(super) [u64; 8]);

pub(super) struct Line {
    pub(super) order: [u8; 64],
    pub(super) known: [u8; 64],
    pub(super) count: usize,
    pub(super) bias: F128,
}

pub(crate) struct Plan {
    pub(super) columns: [F128; 512],
    pub(super) matrices: Vec<Matrix>,
    pub(super) lines: Vec<Line>,
}

pub(crate) fn enabled() -> bool {
    static ON: std::sync::LazyLock<bool> =
        std::sync::LazyLock::new(|| std::env::var_os("FLOCK_XSEED_B_BATCH").is_some());
    *ON
}

fn variable(bit: usize) -> bool {
    (1153..15153).contains(&bit) && (bit - 1153) % 250 < 186
}

impl Plan {
    pub(crate) fn new(data: &[F128], rho: [F128; 3]) -> Self {
        assert_eq!(data.len(), 2048);
        let weights: [F128; 8] = std::array::from_fn(|row| {
            (0..3).fold(F128::ONE, |v, k| {
                v * (rho[k]
                    + if row & (1 << k) == 0 {
                        F128::ONE
                    } else {
                        F128::ZERO
                    })
            })
        });
        let columns: [F128; 512] = std::array::from_fn(|bit| {
            weights[bit / 64] * data[((bit % 64) / 8) * 256 + (1 << (bit % 8))]
        });
        // Every line uses the same linear map. Keep only one 8 KiB matrix
        // bank, rather than duplicating it for each public-byte mask.
        let matrices = (0..128)
            .map(|index| {
                let byte = index / 2;
                let half = index % 2;
                Matrix(std::array::from_fn(|k| {
                    let mut matrix = 0u64;
                    for out_bit in 0..8 {
                        let mut row = 0u8;
                        for in_bit in 0..8 {
                            let c = columns[byte * 8 + in_bit];
                            let word = if half == 0 { c.lo } else { c.hi };
                            row |= (((word >> (8 * k + out_bit)) & 1) as u8) << in_bit;
                        }
                        matrix |= (row as u64) << (8 * (7 - out_bit));
                    }
                    matrix
                }))
            })
            .collect();
        let lines = (2..30)
            .map(|line| {
                let known: [u8; 64] = std::array::from_fn(|byte| {
                    if (0..8).all(|b| !variable(line * 512 + byte * 8 + b)) {
                        255
                    } else {
                        0
                    }
                });
                let mut order = [0u8; 64];
                let mut count = 0;
                let mut bias = F128::ZERO;
                for byte in 0..64 {
                    if known[byte] == 255 {
                        for bit in 0..8 {
                            bias += columns[byte * 8 + bit];
                        }
                    } else {
                        order[count] = byte as u8;
                        count += 1;
                    }
                }
                Line {
                    order,
                    known,
                    count,
                    bias,
                }
            })
            .collect();
        Self {
            columns,
            matrices,
            lines,
        }
    }

    pub(super) fn fallback(&self, bytes: &[u8; 64]) -> F128 {
        let mut result = F128::ZERO;
        for (j, byte) in bytes.iter().enumerate() {
            let mut bits = *byte;
            while bits != 0 {
                result += self.columns[j * 8 + bits.trailing_zeros() as usize];
                bits &= bits - 1;
            }
        }
        result
    }
}

#[cfg(target_arch = "x86_64")]
mod simd {
    use super::*;
    use core::arch::x86_64::*;

    // Transpose the eight qwords of eight instance lines. A subsequent
    // byte transpose turns each output into eight byte-column octets.
    #[inline(always)]
    unsafe fn transpose(input: [__m512i; 8]) -> [__m512i; 8] {
        unsafe {
            let a = std::array::from_fn::<_, 8, _>(|i| {
                if i % 2 == 0 {
                    _mm512_unpacklo_epi64(input[i], input[i + 1])
                } else {
                    _mm512_unpackhi_epi64(input[i - 1], input[i])
                }
            });
            let b = [
                _mm512_shuffle_i64x2::<0x88>(a[0], a[2]),
                _mm512_shuffle_i64x2::<0x88>(a[1], a[3]),
                _mm512_shuffle_i64x2::<0xdd>(a[0], a[2]),
                _mm512_shuffle_i64x2::<0xdd>(a[1], a[3]),
                _mm512_shuffle_i64x2::<0x88>(a[4], a[6]),
                _mm512_shuffle_i64x2::<0x88>(a[5], a[7]),
                _mm512_shuffle_i64x2::<0xdd>(a[4], a[6]),
                _mm512_shuffle_i64x2::<0xdd>(a[5], a[7]),
            ];
            [
                _mm512_shuffle_i64x2::<0x88>(b[0], b[4]),
                _mm512_shuffle_i64x2::<0x88>(b[1], b[5]),
                _mm512_shuffle_i64x2::<0x88>(b[2], b[6]),
                _mm512_shuffle_i64x2::<0x88>(b[3], b[7]),
                _mm512_shuffle_i64x2::<0xdd>(b[0], b[4]),
                _mm512_shuffle_i64x2::<0xdd>(b[1], b[5]),
                _mm512_shuffle_i64x2::<0xdd>(b[2], b[6]),
                _mm512_shuffle_i64x2::<0xdd>(b[3], b[7]),
            ]
        }
    }

    #[repr(C, align(64))]
    struct Octets([[u64; 64]; 2]);

    /// Read sixteen complete 2048-byte B blocks. Output remains canonical by
    /// block; caller transposes only its four ordinary output lanes.
    #[inline(never)]
    pub(crate) unsafe fn fold16(
        input: *const u8,
        plan: &Plan,
        canon: &[F128; 4],
        output: &mut [[F128; 32]; 16],
    ) {
        unsafe {
            for block in output.iter_mut() {
                block[0] = canon[0];
                block[1] = canon[1];
                block[30] = canon[2];
                block[31] = canon[3];
            }
            let out0: [u8; 64] = std::array::from_fn(|i| {
                let block = i / 16;
                let byte = i % 16;
                (8 * byte + block) as u8
            });
            let out1 = out0.map(|x| x + 4);
            let ix0 = _mm512_loadu_si512(out0.as_ptr().cast());
            let ix1 = _mm512_loadu_si512(out1.as_ptr().cast());
            let byte_transpose: [u8; 64] = std::array::from_fn(|i| ((i % 8) * 8 + i / 8) as u8);
            let bt = _mm512_loadu_si512(byte_transpose.as_ptr().cast());
            for (l, line) in plan.lines.iter().enumerate() {
                let line_no = l + 2;
                let perm = _mm512_loadu_si512(line.order.as_ptr().cast());
                let known = _mm512_loadu_si512(line.known.as_ptr().cast());
                let mut all = _mm512_set1_epi64(-1);
                let mut scratch = Octets([[0; 64]; 2]);
                for pass in 0..2 {
                    let inputs = std::array::from_fn::<_, 8, _>(|b| {
                        let v = _mm512_loadu_si512(
                            input.add((pass * 8 + b) * 2048 + line_no * 64).cast(),
                        );
                        all = _mm512_and_si512(all, v);
                        _mm512_permutexvar_epi8(perm, v)
                    });
                    for (i, v) in transpose(inputs).into_iter().enumerate() {
                        _mm512_store_si512(
                            scratch.0[pass].as_mut_ptr().add(i * 8).cast(),
                            _mm512_permutexvar_epi8(bt, v),
                        );
                    }
                }
                if _mm512_cmpeq_epi64_mask(_mm512_and_si512(all, known), known) != 255 {
                    for (b, block) in output.iter_mut().enumerate() {
                        let bytes = &*input.add(b * 2048 + line_no * 64).cast::<[u8; 64]>();
                        block[line_no] = plan.fallback(bytes);
                    }
                    continue;
                }
                // Plan::new alone constructs these matrices; check the shape
                // once, not at every matrix/octet load in the GFNI loop.
                assert!(line.count <= 64 && plan.matrices.len() == 128);
                let mats = plan.matrices.as_ptr();
                let mut acc = [_mm512_setzero_si512(); 4];
                let mut j = 0;
                while j + 1 < line.count {
                    let index = 2 * (line.order.as_ptr().add(j).read() as usize & 63);
                    let next = 2 * (line.order.as_ptr().add(j + 1).read() as usize & 63);
                    let m0 = _mm512_load_si512(mats.add(index).cast());
                    let m1 = _mm512_load_si512(mats.add(index + 1).cast());
                    let n0 = _mm512_load_si512(mats.add(next).cast());
                    let n1 = _mm512_load_si512(mats.add(next + 1).cast());
                    for pass in 0..2 {
                        let x = _mm512_set1_epi64(scratch.0[pass].as_ptr().add(j).read() as i64);
                        let y =
                            _mm512_set1_epi64(scratch.0[pass].as_ptr().add(j + 1).read() as i64);
                        acc[2 * pass] = _mm512_ternarylogic_epi64::<0x96>(
                            acc[2 * pass],
                            _mm512_gf2p8affine_epi64_epi8::<0>(x, m0),
                            _mm512_gf2p8affine_epi64_epi8::<0>(y, n0),
                        );
                        acc[2 * pass + 1] = _mm512_ternarylogic_epi64::<0x96>(
                            acc[2 * pass + 1],
                            _mm512_gf2p8affine_epi64_epi8::<0>(x, m1),
                            _mm512_gf2p8affine_epi64_epi8::<0>(y, n1),
                        );
                    }
                    j += 2;
                }
                if j < line.count {
                    let index = 2 * (line.order.as_ptr().add(j).read() as usize & 63);
                    let m0 = _mm512_load_si512(mats.add(index).cast());
                    let m1 = _mm512_load_si512(mats.add(index + 1).cast());
                    for pass in 0..2 {
                        let x = _mm512_set1_epi64(scratch.0[pass].as_ptr().add(j).read() as i64);
                        acc[2 * pass] = _mm512_xor_si512(
                            acc[2 * pass],
                            _mm512_gf2p8affine_epi64_epi8::<0>(x, m0),
                        );
                        acc[2 * pass + 1] = _mm512_xor_si512(
                            acc[2 * pass + 1],
                            _mm512_gf2p8affine_epi64_epi8::<0>(x, m1),
                        );
                    }
                }
                let bias = _mm512_broadcast_i32x4(_mm_set_epi64x(
                    line.bias.hi as i64,
                    line.bias.lo as i64,
                ));
                for pass in 0..2 {
                    let a = _mm512_xor_si512(
                        _mm512_permutex2var_epi8(acc[2 * pass], ix0, acc[2 * pass + 1]),
                        bias,
                    );
                    let b = _mm512_xor_si512(
                        _mm512_permutex2var_epi8(acc[2 * pass], ix1, acc[2 * pass + 1]),
                        bias,
                    );
                    macro_rules! store {
                        ($v:expr, $base:expr) => {{
                            _mm_storeu_si128(
                                (&mut output[$base][line_no] as *mut F128).cast(),
                                _mm512_castsi512_si128($v),
                            );
                            _mm_storeu_si128(
                                (&mut output[$base + 1][line_no] as *mut F128).cast(),
                                _mm512_extracti32x4_epi32::<1>($v),
                            );
                            _mm_storeu_si128(
                                (&mut output[$base + 2][line_no] as *mut F128).cast(),
                                _mm512_extracti32x4_epi32::<2>($v),
                            );
                            _mm_storeu_si128(
                                (&mut output[$base + 3][line_no] as *mut F128).cast(),
                                _mm512_extracti32x4_epi32::<3>($v),
                            );
                        }};
                    }
                    store!(a, pass * 8);
                    store!(b, pass * 8 + 4);
                }
            }
        }
    }
}

#[cfg(target_arch = "x86_64")]
pub(crate) use simd::fold16;

// Native integration tests (portable gate covers Plan/fold16 separately).
#[cfg(test)]
mod tests {
    use super::super::{
        build_cfold_mats, fold3_from_packed_lookahead_c4_lm_wtab_b_canon_casc_x86 as kernel,
    };
    use super::*;
    use crate::zerocheck::multilinear::{UniSkipFoldTable, build_w_pair_table_casc};

    fn random(s: &mut u64) -> u64 {
        *s ^= *s << 13;
        *s ^= *s >> 7;
        *s ^= *s << 17;
        *s
    }
    fn field(s: &mut u64) -> F128 {
        F128::new(random(s), random(s))
    }

    #[test]
    fn xseed_bbatch_matches_crown_cascade() {
        let mut s = 0x8123_747a_96ef_153d;
        for lo in [256usize, 512, 1024] {
            for base in [0usize, 32, 96] {
                for fixture in 0..4 {
                    let rho = std::array::from_fn(|_| match fixture {
                        0 => F128::ZERO,
                        1 => F128::ONE,
                        _ => field(&mut s),
                    });
                    let weights: [F128; 64] = std::array::from_fn(|_| field(&mut s));
                    let table = UniSkipFoldTable::from_weights(8, &weights);
                    let plan = Plan::new(&table.data, rho);
                    let one = F128::ONE;
                    let c = build_cfold_mats(
                        &table.data,
                        [
                            (one + rho[0]) * (one + rho[1]),
                            rho[0] * (one + rho[1]),
                            (one + rho[0]) * rho[1],
                            rho[0] * rho[1],
                        ],
                    );
                    let eq: Vec<F128> = (0..lo).map(|_| field(&mut s)).collect();
                    let wt = build_w_pair_table_casc(&eq);
                    let kappa = field(&mut s);
                    let size = (base + 2 * lo) * 64;
                    let a: Vec<u8> = (0..size).map(|_| random(&mut s) as u8).collect();
                    let mut b = vec![0u8; size];
                    for (block, bytes) in b.chunks_exact_mut(2048).enumerate() {
                        for bit in 0..15409 {
                            let value = !variable(bit) || random(&mut s) & 1 != 0;
                            bytes[bit / 8] |= (value as u8) << (bit % 8);
                        }
                        if fixture == 3 && block % 16 == 7 {
                            // One bad block invalidates that line in its whole batch.
                            for byte in &mut bytes[128..1920] {
                                *byte = random(&mut s) as u8;
                            }
                        }
                    }
                    let canon = [0usize, 1, 30, 31]
                        .map(|l| plan.fallback(b[l * 64..l * 64 + 64].try_into().unwrap()));
                    #[repr(C, align(64))]
                    struct Aligned([F128; 2056]);
                    let guard = F128::new(0x12345678, 0xdeadbeef);
                    for nt in [false, true] {
                        let mut want_a = Box::new(Aligned([guard; 2056]));
                        let mut want_b = Box::new(Aligned([guard; 2056]));
                        let mut got_a = Box::new(Aligned([guard; 2056]));
                        let mut got_b = Box::new(Aligned([guard; 2056]));
                        let mut want7 = [F128::ZERO; 18];
                        let mut got7 = want7;
                        macro_rules! run {
                            ($nt:literal, $batch:literal, $a:expr, $b:expr, $l:expr, $plan:expr) => {
                                kernel::<$nt, true, true, $batch>(
                                    a.as_ptr(),
                                    b.as_ptr(),
                                    base,
                                    &mut $a.0[4..4 + 2 * lo],
                                    &mut $b.0[4..4 + 2 * lo],
                                    lo,
                                    &c,
                                    rho[2],
                                    &wt,
                                    &canon,
                                    $l,
                                    kappa,
                                    $plan,
                                )
                            };
                        }
                        let (want, got) = unsafe {
                            if nt {
                                (
                                    run!(true, false, want_a, want_b, &mut want7, None),
                                    run!(true, true, got_a, got_b, &mut got7, Some(&plan)),
                                )
                            } else {
                                (
                                    run!(false, false, want_a, want_b, &mut want7, None),
                                    run!(false, true, got_a, got_b, &mut got7, Some(&plan)),
                                )
                            }
                        };
                        assert_eq!(
                            got, want,
                            "message lo={lo} base={base} fixture={fixture} nt={nt}"
                        );
                        assert_eq!(got7, want7, "lookahead");
                        assert_eq!(got_a.0, want_a.0, "A output and guards");
                        assert_eq!(got_b.0, want_b.0, "B output and guards");
                        for output in [&got_a, &got_b] {
                            assert!(
                                output.0[..4]
                                    .iter()
                                    .chain(output.0[4 + 2 * lo..].iter())
                                    .all(|&x| x == guard)
                            );
                        }
                    }
                }
            }
        }
    }
}
