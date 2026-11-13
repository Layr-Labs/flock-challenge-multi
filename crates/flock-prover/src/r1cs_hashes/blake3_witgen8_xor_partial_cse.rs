//! Shared output recombination for selected structural complement modes.
//! Every GFNI product and coefficient index matches the pruned subset convolution.
//! Input XOR forms omit only statically known all-one bytes after complement.
use super::*;
#[inline(always)]
unsafe fn original_cse_2<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s2 = !*p.add(2);
        let s3 = !*p.add(3);
        let s4 = !*p.add(4);
        let s5 = !*p.add(5);
        let s6 = !*p.add(6);
        let s7 = !*p.add(7);
        let s8 = s3 ^ s7;
        let s9 = s4 ^ s5;
        let s10 = s2 ^ s3;
        let s11 = s5 ^ s8;
        let s12 = s2 ^ s6;
        let s13 = s12 ^ s8;
        let s14 = s13 ^ s9;
        let a8 = s3;
        let a12 = s10;
        let a32 = s5;
        let a48 = s9;
        let a168 = s11;
        let a252 = s14;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x12 = if VECTOR {
            _mm512_set1_epi64(a12 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x32 = if VECTOR {
            _mm512_set1_epi64(a32 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x48 = if VECTOR {
            _mm512_set1_epi64(a48 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x168 = if VECTOR {
            _mm512_set1_epi64(a168 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x252 = if VECTOR {
            _mm512_set1_epi64(a252 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x168
            } else {
                _mm512_set1_epi64(a168 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v23 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v17, v21, v23);
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v11, v15, v24);
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v26 = _mm512_xor_si512(v7, v25);
        let v18 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v30 = _mm512_ternarylogic_epi64::<0x96>(v6, v14, v20);
        let v34 = _mm512_ternarylogic_epi64::<0x96>(v4, v18, v30);
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x168
            } else {
                _mm512_set1_epi64(a168 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v16);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v31 = _mm512_ternarylogic_epi64::<0x96>(v2, v12, v27);
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x168
            } else {
                _mm512_set1_epi64(a168 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v38 = _mm512_ternarylogic_epi64::<0x96>(v0, v8, v31);
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v22 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x168
            } else {
                _mm512_set1_epi64(a168 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v10, v19, v22);
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v5, v26, v28);
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x252
            } else {
                _mm512_set1_epi64(a252 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v32 = _mm512_ternarylogic_epi64::<0x96>(v1, v13, v29);
        let v39 = _mm512_ternarylogic_epi64::<0x96>(v38, v32, v34);
        let v35 = _mm512_xor_si512(v29, v34);
        let v33 = _mm512_xor_si512(v26, v30);
        let v36 = _mm512_ternarylogic_epi64::<0x96>(v13, v31, v33);
        let v40 = _mm512_ternarylogic_epi64::<0x96>(v8, v27, v32);
        let v37 = _mm512_ternarylogic_epi64::<0x96>(v13, v26, v27);
        [v33, v26, v35, v29, v36, v37, v39, v40]
    }
}
#[inline(always)]
unsafe fn original_cse_3<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s3 = !*p.add(3);
        let s4 = !*p.add(4);
        let s5 = !*p.add(5);
        let s6 = !*p.add(6);
        let s7 = !*p.add(7);
        let s8 = s4 ^ s5;
        let s9 = s4 ^ s6;
        let s10 = s3 ^ s6;
        let s11 = s10 ^ s7;
        let s12 = s11 ^ s8;
        let a8 = s3;
        let a16 = s4;
        let a48 = s8;
        let a80 = s9;
        let a248 = s12;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x16 = if VECTOR {
            _mm512_set1_epi64(a16 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x48 = if VECTOR {
            _mm512_set1_epi64(a48 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x80 = if VECTOR {
            _mm512_set1_epi64(a80 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x248 = if VECTOR {
            _mm512_set1_epi64(a248 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x80
            } else {
                _mm512_set1_epi64(a80 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v26 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v19);
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v6, v14, v20);
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v4, v26, v27);
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v30 = _mm512_xor_si512(v2, v12);
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v3, v13, v16);
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x80
            } else {
                _mm512_set1_epi64(a80 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v22 = _mm512_ternarylogic_epi64::<0x96>(v7, v11, v15);
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v23 = _mm512_ternarylogic_epi64::<0x96>(v17, v21, v22);
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x80
            } else {
                _mm512_set1_epi64(a80 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v9, v23, v24);
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x80
            } else {
                _mm512_set1_epi64(a80 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x248
            } else {
                _mm512_set1_epi64(a248 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v1, v8, v25);
        let v18 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v36 = _mm512_ternarylogic_epi64::<0x96>(v0, v18, v28);
        let v37 = _mm512_ternarylogic_epi64::<0x96>(v36, v29, v30);
        let v35 = _mm512_xor_si512(v26, v28);
        let v33 = _mm512_ternarylogic_epi64::<0x96>(v18, v23, v29);
        let v32 = _mm512_xor_si512(v23, v26);
        let v31 = _mm512_xor_si512(v23, v27);
        let v34 = _mm512_ternarylogic_epi64::<0x96>(v25, v27, v30);
        [v23, v31, v32, v33, v25, v34, v35, v37]
    }
}
#[inline(always)]
unsafe fn original_cse_4<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s4 = !*p.add(4);
        let s5 = !*p.add(5);
        let s6 = !*p.add(6);
        let s7 = !*p.add(7);
        let s8 = s6 ^ s7;
        let s9 = s5 ^ s7;
        let s10 = s4 ^ s5;
        let s11 = s10 ^ s8;
        let a128 = s7;
        let a160 = s9;
        let a192 = s8;
        let a240 = s11;
        let x128 = if VECTOR {
            _mm512_set1_epi64(a128 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x160 = if VECTOR {
            _mm512_set1_epi64(a160 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x192 = if VECTOR {
            _mm512_set1_epi64(a192 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x240 = if VECTOR {
            _mm512_set1_epi64(a240 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x160
            } else {
                _mm512_set1_epi64(a160 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v18 = _mm512_ternarylogic_epi64::<0x96>(v7, v11, v17);
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v19 = _mm512_xor_si512(v15, v18);
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x160
            } else {
                _mm512_set1_epi64(a160 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v22 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v19);
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x160
            } else {
                _mm512_set1_epi64(a160 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v20 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v13);
        let v21 = _mm512_ternarylogic_epi64::<0x96>(v16, v19, v20);
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x160
            } else {
                _mm512_set1_epi64(a160 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v23 = _mm512_ternarylogic_epi64::<0x96>(v1, v8, v10);
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v5, v21, v23);
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v2, v6, v14);
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x240
            } else {
                _mm512_set1_epi64(a240 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v0, v4, v12);
        let v30 = _mm512_ternarylogic_epi64::<0x96>(v29, v24, v25);
        let v26 = _mm512_xor_si512(v6, v14);
        let v28 = _mm512_xor_si512(v19, v26);
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v4, v22, v26);
        let v31 = _mm512_ternarylogic_epi64::<0x96>(v12, v21, v24);
        [v27, v22, v28, v19, v30, v25, v31, v21]
    }
}
#[inline(always)]
unsafe fn original_cse_6<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s6 = !*p.add(6);
        let s7 = !*p.add(7);
        let s8 = s6 ^ s7;
        let a128 = s7;
        let a192 = s8;
        let x128 = if VECTOR {
            _mm512_set1_epi64(a128 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x192 = if VECTOR {
            _mm512_set1_epi64(a192 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v19 = _mm512_ternarylogic_epi64::<0x96>(v0, v4, v5);
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v15 = _mm512_ternarylogic_epi64::<0x96>(v1, v8, v10);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v12 = _mm512_xor_si512(v7, v11);
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x128
            } else {
                _mm512_set1_epi64(a128 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v13 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v12);
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x192
            } else {
                _mm512_set1_epi64(a192 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v14 = _mm512_ternarylogic_epi64::<0x96>(v2, v6, v13);
        let v20 = _mm512_ternarylogic_epi64::<0x96>(v19, v14, v15);
        let v16 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v12);
        let v18 = _mm512_ternarylogic_epi64::<0x96>(v4, v6, v16);
        let v17 = _mm512_xor_si512(v6, v12);
        let v21 = _mm512_ternarylogic_epi64::<0x96>(v5, v13, v15);
        [v17, v12, v18, v16, v14, v13, v20, v21]
    }
}
#[inline(always)]
unsafe fn original_cse_8<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s0 = !*p.add(0);
        let s1 = !*p.add(1);
        let s2 = !*p.add(2);
        let s3 = !*p.add(3);
        let s4 = !*p.add(4);
        let s5 = !*p.add(5);
        let s6 = !*p.add(6);
        let s8 = s4 ^ s5;
        let s9 = s2 ^ s3;
        let s10 = s6 ^ s9;
        let s11 = s1 ^ s3;
        let s12 = s11 ^ s5;
        let s13 = s6 ^ s8;
        let s14 = s0 ^ s1;
        let s15 = s14 ^ s8;
        let s16 = s15 ^ s10;
        let a8 = s3;
        let a32 = s5;
        let a42 = s12;
        let a64 = s6;
        let a76 = s10;
        let a112 = s13;
        let a127 = s16;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x32 = if VECTOR {
            _mm512_set1_epi64(a32 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x42 = if VECTOR {
            _mm512_set1_epi64(a42 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x64 = if VECTOR {
            _mm512_set1_epi64(a64 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x76 = if VECTOR {
            _mm512_set1_epi64(a76 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x112 = if VECTOR {
            _mm512_set1_epi64(a112 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x127 = if VECTOR {
            _mm512_set1_epi64(a127 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x76
            } else {
                _mm512_set1_epi64(a76 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v23 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v25 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x64
            } else {
                _mm512_set1_epi64(a64 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v7, v23, v25);
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x112
            } else {
                _mm512_set1_epi64(a112 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v26 = _mm512_ternarylogic_epi64::<0x96>(v11, v17, v21);
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v15, v26, v27);
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x76
            } else {
                _mm512_set1_epi64(a76 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x112
            } else {
                _mm512_set1_epi64(a112 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v31 = _mm512_ternarylogic_epi64::<0x96>(v6, v14, v20);
        let v24 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x64
            } else {
                _mm512_set1_epi64(a64 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v37 = _mm512_ternarylogic_epi64::<0x96>(v24, v28, v31);
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v28);
        let v22 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x112
            } else {
                _mm512_set1_epi64(a112 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v32 = _mm512_ternarylogic_epi64::<0x96>(v19, v22, v29);
        let v34 = _mm512_ternarylogic_epi64::<0x96>(v4, v31, v32);
        let v18 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x112
            } else {
                _mm512_set1_epi64(a112 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v36 = _mm512_ternarylogic_epi64::<0x96>(v18, v24, v34);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x76
            } else {
                _mm512_set1_epi64(a76 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v30 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v16);
        let v33 = _mm512_ternarylogic_epi64::<0x96>(v2, v12, v30);
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x76
            } else {
                _mm512_set1_epi64(a76 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v35 = _mm512_ternarylogic_epi64::<0x96>(v1, v8, v13);
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x127
            } else {
                _mm512_set1_epi64(a127 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v38 = _mm512_ternarylogic_epi64::<0x96>(v0, v33, v35);
        let v39 = _mm512_xor_si512(v38, v36);
        let v41 = _mm512_ternarylogic_epi64::<0x96>(v13, v33, v37);
        let v42 = _mm512_ternarylogic_epi64::<0x96>(v13, v28, v30);
        let v40 = _mm512_ternarylogic_epi64::<0x96>(v30, v32, v35);
        [v39, v40, v41, v42, v36, v32, v37, v28]
    }
}
#[inline(always)]
unsafe fn original_cse_9<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s0 = !*p.add(0);
        let s1 = !*p.add(1);
        let s2 = !*p.add(2);
        let s3 = !*p.add(3);
        let s4 = !*p.add(4);
        let s5 = !*p.add(5);
        let s8 = s1 ^ s3;
        let s9 = s4 ^ s5;
        let s10 = s2 ^ s3;
        let s11 = s5 ^ s8;
        let s12 = s0 ^ s2;
        let s13 = s12 ^ s8;
        let s14 = s13 ^ s9;
        let a8 = s3;
        let a12 = s10;
        let a32 = s5;
        let a42 = s11;
        let a48 = s9;
        let a63 = s14;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x12 = if VECTOR {
            _mm512_set1_epi64(a12 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x32 = if VECTOR {
            _mm512_set1_epi64(a32 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x42 = if VECTOR {
            _mm512_set1_epi64(a42 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x48 = if VECTOR {
            _mm512_set1_epi64(a48 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x63 = if VECTOR {
            _mm512_set1_epi64(a63 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v23 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v17, v21, v23);
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v7, v11, v15);
        let v26 = _mm512_xor_si512(v24, v25);
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v9, v16, v26);
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v30 = _mm512_ternarylogic_epi64::<0x96>(v3, v13, v27);
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v22 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x32
            } else {
                _mm512_set1_epi64(a32 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x42
            } else {
                _mm512_set1_epi64(a42 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v22);
        let v31 = _mm512_ternarylogic_epi64::<0x96>(v8, v19, v29);
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v34 = _mm512_ternarylogic_epi64::<0x96>(v1, v30, v31);
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v6, v14, v20);
        let v33 = _mm512_ternarylogic_epi64::<0x96>(v2, v12, v28);
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x63
            } else {
                _mm512_set1_epi64(a63 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v18 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x48
            } else {
                _mm512_set1_epi64(a48 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v35 = _mm512_ternarylogic_epi64::<0x96>(v0, v4, v18);
        let v36 = _mm512_ternarylogic_epi64::<0x96>(v35, v33, v34);
        let v37 = _mm512_xor_si512(v30, v33);
        let v32 = _mm512_xor_si512(v26, v28);
        let v38 = _mm512_ternarylogic_epi64::<0x96>(v4, v18, v19);
        let v39 = _mm512_ternarylogic_epi64::<0x96>(v38, v29, v32);
        let v40 = _mm512_ternarylogic_epi64::<0x96>(v19, v26, v29);
        [v36, v34, v37, v30, v39, v40, v32, v26]
    }
}
#[inline(always)]
unsafe fn original_cse_10<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s0 = !*p.add(0);
        let s1 = !*p.add(1);
        let s2 = !*p.add(2);
        let s3 = !*p.add(3);
        let s4 = !*p.add(4);
        let s8 = s2 ^ s3;
        let s9 = s1 ^ s3;
        let s10 = s0 ^ s1;
        let s11 = s10 ^ s4;
        let s12 = s11 ^ s8;
        let a8 = s3;
        let a10 = s9;
        let a12 = s8;
        let a16 = s4;
        let a31 = s12;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x10 = if VECTOR {
            _mm512_set1_epi64(a10 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x12 = if VECTOR {
            _mm512_set1_epi64(a12 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x16 = if VECTOR {
            _mm512_set1_epi64(a16 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x31 = if VECTOR {
            _mm512_set1_epi64(a31 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v18 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v26 = _mm512_ternarylogic_epi64::<0x96>(v6, v14, v20);
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v4, v18, v26);
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v22 = _mm512_ternarylogic_epi64::<0x96>(v7, v11, v17);
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v23 = _mm512_ternarylogic_epi64::<0x96>(v15, v21, v22);
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x16
            } else {
                _mm512_set1_epi64(a16 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v10, v19, v23);
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v27 = _mm512_xor_si512(v5, v25);
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v31 = _mm512_ternarylogic_epi64::<0x96>(v1, v8, v27);
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v16);
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v12, v13, v24);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x31
            } else {
                _mm512_set1_epi64(a31 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v32 = _mm512_ternarylogic_epi64::<0x96>(v0, v2, v28);
        let v33 = _mm512_ternarylogic_epi64::<0x96>(v32, v29, v31);
        let v30 = _mm512_xor_si512(v23, v26);
        let v34 = _mm512_ternarylogic_epi64::<0x96>(v13, v24, v31);
        let v35 = _mm512_ternarylogic_epi64::<0x96>(v2, v28, v30);
        let v37 = _mm512_xor_si512(v27, v29);
        let v36 = _mm512_ternarylogic_epi64::<0x96>(v13, v23, v24);
        [v33, v34, v35, v36, v37, v27, v30, v23]
    }
}
#[inline(always)]
unsafe fn original_cse_11<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s0 = !*p.add(0);
        let s1 = !*p.add(1);
        let s2 = !*p.add(2);
        let s3 = !*p.add(3);
        let s8 = s2 ^ s3;
        let s9 = s1 ^ s3;
        let s10 = s0 ^ s1;
        let s11 = s10 ^ s8;
        let a8 = s3;
        let a10 = s9;
        let a12 = s8;
        let a15 = s11;
        let x8 = if VECTOR {
            _mm512_set1_epi64(a8 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x10 = if VECTOR {
            _mm512_set1_epi64(a10 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x12 = if VECTOR {
            _mm512_set1_epi64(a12 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x15 = if VECTOR {
            _mm512_set1_epi64(a15 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v18 = _mm512_ternarylogic_epi64::<0x96>(v7, v11, v15);
        let v17 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v19 = _mm512_xor_si512(v17, v18);
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v24 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v19);
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v23 = _mm512_ternarylogic_epi64::<0x96>(v1, v5, v10);
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v16 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x8
            } else {
                _mm512_set1_epi64(a8 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v20 = _mm512_ternarylogic_epi64::<0x96>(v9, v13, v16);
        let v21 = _mm512_ternarylogic_epi64::<0x96>(v3, v19, v20);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v22 = _mm512_ternarylogic_epi64::<0x96>(v2, v6, v14);
        let v12 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x12
            } else {
                _mm512_set1_epi64(a12 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v25 = _mm512_ternarylogic_epi64::<0x96>(v12, v21, v22);
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x15
            } else {
                _mm512_set1_epi64(a15 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x10
            } else {
                _mm512_set1_epi64(a10 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v27 = _mm512_ternarylogic_epi64::<0x96>(v0, v4, v8);
        let v28 = _mm512_ternarylogic_epi64::<0x96>(v27, v23, v25);
        let v26 = _mm512_xor_si512(v6, v14);
        let v31 = _mm512_xor_si512(v19, v26);
        let v30 = _mm512_ternarylogic_epi64::<0x96>(v4, v24, v26);
        let v29 = _mm512_ternarylogic_epi64::<0x96>(v8, v21, v23);
        [v28, v29, v25, v21, v30, v24, v31, v19]
    }
}
#[inline(always)]
unsafe fn original_cse_13<const VECTOR: bool>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let s0 = !*p.add(0);
        let s1 = !*p.add(1);
        let s8 = s0 ^ s1;
        let a2 = s1;
        let a3 = s8;
        let x2 = if VECTOR {
            _mm512_set1_epi64(a2 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let x3 = if VECTOR {
            _mm512_set1_epi64(a3 as i64)
        } else {
            _mm512_setzero_si512()
        };
        let v7 = _mm512_gf2p8affine_epi64_epi8::<1>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(120).cast()),
        );
        let v11 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x2
            } else {
                _mm512_set1_epi64(a2 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v12 = _mm512_xor_si512(v7, v11);
        let v10 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x2
            } else {
                _mm512_set1_epi64(a2 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v5 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(104).cast()),
        );
        let v14 = _mm512_ternarylogic_epi64::<0x96>(v5, v10, v12);
        let v3 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(88).cast()),
        );
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x2
            } else {
                _mm512_set1_epi64(a2 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v13 = _mm512_ternarylogic_epi64::<0x96>(v3, v9, v12);
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x2
            } else {
                _mm512_set1_epi64(a2 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v1 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(72).cast()),
        );
        let v16 = _mm512_ternarylogic_epi64::<0x96>(v1, v5, v10);
        let v19 = _mm512_ternarylogic_epi64::<0x96>(v8, v13, v16);
        let v0 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(64).cast()),
        );
        let v4 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(96).cast()),
        );
        let v17 = _mm512_ternarylogic_epi64::<0x96>(v0, v4, v8);
        let v2 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(80).cast()),
        );
        let v6 = _mm512_gf2p8affine_epi64_epi8::<0>(
            if VECTOR {
                x3
            } else {
                _mm512_set1_epi64(a3 as i64)
            },
            _mm512_loadu_si512(m.add(112).cast()),
        );
        let v15 = _mm512_ternarylogic_epi64::<0x96>(v2, v6, v13);
        let v18 = _mm512_ternarylogic_epi64::<0x96>(v17, v15, v16);
        let v20 = _mm512_ternarylogic_epi64::<0x96>(v4, v6, v14);
        let v21 = _mm512_xor_si512(v6, v12);
        [v18, v19, v15, v13, v20, v14, v21, v12]
    }
}
#[inline(always)]
pub(super) const fn enabled(mode: u8) -> bool {
    matches!(mode, 2 | 3 | 4 | 6 | 8 | 9 | 10 | 11 | 13)
}
#[inline(always)]
pub(super) unsafe fn apply<const MODE: u8>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        match MODE {
            2 => original_cse_2::<true>(p, m),
            3 => original_cse_3::<false>(p, m),
            4 => original_cse_4::<false>(p, m),
            6 => original_cse_6::<false>(p, m),
            8 => original_cse_8::<false>(p, m),
            9 => original_cse_9::<false>(p, m),
            10 => original_cse_10::<true>(p, m),
            11 => original_cse_11::<true>(p, m),
            13 => original_cse_13::<false>(p, m),
            _ => unreachable!("only selected static complement modes use shared XORs"),
        }
    }
}
