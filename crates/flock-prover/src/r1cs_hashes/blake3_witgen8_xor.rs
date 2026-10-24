//! Eight-row XOR convolution of the inverse-NTT column map.
//! Over characteristic two, the substitution epsilon=x+1 has epsilon^2=0.
//! Superset XOR transforms turn eight-term XOR convolution into 27 bilinear
//! GFNI products. Eight matrix banks absorb the Horner weights into A,
//! eliminating accumulator field multiplies. Setup is once per shared invocation.
use super::*;
use flock_core::zerocheck::univariate_skip_optimized::round1_ranked_bcomplement_mode as mode;
#[repr(align(64))]
pub(super) struct Tables([u64; 8 * 128]);
impl Tables {
    pub(super) fn new(table: &InvNttTableByteSingleGf8) -> Self {
        assert_eq!(table.ell, 64);
        // Bank k absorbs the Horner weight 2^k into the linear A map.
        // GF(256) multiplication distributes over both the byte map and XOR
        // convolution. B keeps bank zero; products then accumulate by XOR.
        let mut m = [0u64; 8 * 128];
        for k in 0..8 {
            let bank = &mut m[k * 128..(k + 1) * 128];
            for i in 0..64 {
                for outbit in 0..8 {
                    let mut row = 0u8;
                    for bit in 0..8 {
                        let c = unsafe { *table.data_ptr().add((1 << bit) * 64 + i) };
                        let scaled = flock_core::field::F8(c) * flock_core::field::F8(1u8 << k);
                        row |= ((scaled.0 >> outbit) & 1) << bit;
                    }
                    bank[i] |= (row as u64) << (8 * (7 - outbit));
                }
            }
            for subset in 0..8 {
                for c in 0..8 {
                    let mut v = 0;
                    for t in 0..8 {
                        if t & subset == subset {
                            v ^= bank[t * 8 + c];
                        }
                    }
                    bank[64 + subset * 8 + c] = v;
                }
            }
        }
        Self(m)
    }
}

#[inline(always)]
const fn known(mode: u8) -> u8 {
    if mode == 15 {
        255
    } else if mode == 0 {
        0
    } else if mode <= 7 {
        (1u16 << mode) as u8 - 1
    } else {
        (255u16 << (15 - mode)) as u8
    }
}

#[inline(always)]
unsafe fn affine(p: *const u64, m: *const u64, mode_value: u8) -> [__m512i; 8] {
    unsafe {
        let z = _mm512_setzero_si512();
        let mut v = [z; 8];
        macro_rules! add {
            ($j:expr) => {
                if known(mode_value) & (1 << $j) == 0 {
                    let w = *p.add($j);
                    let w = if mode_value == 0 { w } else { !w };
                    let x = _mm512_set1_epi64(w as i64);
                    v[0] = _mm512_xor_si512(
                        v[0],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 0) * 8).cast()),
                        ),
                    );
                    v[1] = _mm512_xor_si512(
                        v[1],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 1) * 8).cast()),
                        ),
                    );
                    v[2] = _mm512_xor_si512(
                        v[2],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 2) * 8).cast()),
                        ),
                    );
                    v[3] = _mm512_xor_si512(
                        v[3],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 3) * 8).cast()),
                        ),
                    );
                    v[4] = _mm512_xor_si512(
                        v[4],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 4) * 8).cast()),
                        ),
                    );
                    v[5] = _mm512_xor_si512(
                        v[5],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 5) * 8).cast()),
                        ),
                    );
                    v[6] = _mm512_xor_si512(
                        v[6],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 6) * 8).cast()),
                        ),
                    );
                    v[7] = _mm512_xor_si512(
                        v[7],
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            x,
                            _mm512_loadu_si512(m.add(($j ^ 7) * 8).cast()),
                        ),
                    );
                }
            };
        }
        add!(0);
        add!(1);
        add!(2);
        add!(3);
        add!(4);
        add!(5);
        add!(6);
        add!(7);
        v
    }
}

#[inline(always)]
unsafe fn affine_conv(p: *const u64, m: *const u64, mode_value: u8) -> [__m512i; 8] {
    unsafe {
        // For sparse complement inputs keep the direct projection: <=3*8 products.
        if known(mode_value).count_ones() >= 5 {
            return affine(p, m, mode_value);
        }
        let mut x: [u64; 8] = [
            if known(mode_value) & (1 << 0) != 0 { 0 } else if mode_value == 0 { *p.add(0) } else { !*p.add(0) },
            if known(mode_value) & (1 << 1) != 0 { 0 } else if mode_value == 0 { *p.add(1) } else { !*p.add(1) },
            if known(mode_value) & (1 << 2) != 0 { 0 } else if mode_value == 0 { *p.add(2) } else { !*p.add(2) },
            if known(mode_value) & (1 << 3) != 0 { 0 } else if mode_value == 0 { *p.add(3) } else { !*p.add(3) },
            if known(mode_value) & (1 << 4) != 0 { 0 } else if mode_value == 0 { *p.add(4) } else { !*p.add(4) },
            if known(mode_value) & (1 << 5) != 0 { 0 } else if mode_value == 0 { *p.add(5) } else { !*p.add(5) },
            if known(mode_value) & (1 << 6) != 0 { 0 } else if mode_value == 0 { *p.add(6) } else { !*p.add(6) },
            if known(mode_value) & (1 << 7) != 0 { 0 } else if mode_value == 0 { *p.add(7) } else { !*p.add(7) }
        ];
        x[0] ^= x[1];
        x[2] ^= x[3];
        x[4] ^= x[5];
        x[6] ^= x[7];
        x[0] ^= x[2];
        x[1] ^= x[3];
        x[4] ^= x[6];
        x[5] ^= x[7];
        x[0] ^= x[4];
        x[1] ^= x[5];
        x[2] ^= x[6];
        x[3] ^= x[7];
        let mut c = [_mm512_setzero_si512(); 8];
        c[0] = _mm512_gf2p8affine_epi64_epi8::<0>(
            _mm512_set1_epi64(x[0] as i64),
            _mm512_loadu_si512(m.add(64).cast()),
        );
        c[1] = _mm512_xor_si512(
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[0] as i64),
                _mm512_loadu_si512(m.add(72).cast()),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[1] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[2] = _mm512_xor_si512(
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[0] as i64),
                _mm512_loadu_si512(m.add(80).cast()),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[2] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[3] = _mm512_xor_si512(
            _mm512_ternarylogic_epi64::<0x96>(
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[0] as i64),
                    _mm512_loadu_si512(m.add(88).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[1] as i64),
                    _mm512_loadu_si512(m.add(80).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[2] as i64),
                    _mm512_loadu_si512(m.add(72).cast()),
                ),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[3] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[4] = _mm512_xor_si512(
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[0] as i64),
                _mm512_loadu_si512(m.add(96).cast()),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[4] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[5] = _mm512_xor_si512(
            _mm512_ternarylogic_epi64::<0x96>(
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[0] as i64),
                    _mm512_loadu_si512(m.add(104).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[1] as i64),
                    _mm512_loadu_si512(m.add(96).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[4] as i64),
                    _mm512_loadu_si512(m.add(72).cast()),
                ),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[5] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[6] = _mm512_xor_si512(
            _mm512_ternarylogic_epi64::<0x96>(
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[0] as i64),
                    _mm512_loadu_si512(m.add(112).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[2] as i64),
                    _mm512_loadu_si512(m.add(96).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[4] as i64),
                    _mm512_loadu_si512(m.add(80).cast()),
                ),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[6] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[7] = _mm512_xor_si512(
            _mm512_ternarylogic_epi64::<0x96>(
                _mm512_ternarylogic_epi64::<0x96>(
                    _mm512_ternarylogic_epi64::<0x96>(
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            _mm512_set1_epi64(x[0] as i64),
                            _mm512_loadu_si512(m.add(120).cast()),
                        ),
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            _mm512_set1_epi64(x[1] as i64),
                            _mm512_loadu_si512(m.add(112).cast()),
                        ),
                        _mm512_gf2p8affine_epi64_epi8::<0>(
                            _mm512_set1_epi64(x[2] as i64),
                            _mm512_loadu_si512(m.add(104).cast()),
                        ),
                    ),
                    _mm512_gf2p8affine_epi64_epi8::<0>(
                        _mm512_set1_epi64(x[3] as i64),
                        _mm512_loadu_si512(m.add(96).cast()),
                    ),
                    _mm512_gf2p8affine_epi64_epi8::<0>(
                        _mm512_set1_epi64(x[4] as i64),
                        _mm512_loadu_si512(m.add(88).cast()),
                    ),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[5] as i64),
                    _mm512_loadu_si512(m.add(80).cast()),
                ),
                _mm512_gf2p8affine_epi64_epi8::<0>(
                    _mm512_set1_epi64(x[6] as i64),
                    _mm512_loadu_si512(m.add(72).cast()),
                ),
            ),
            _mm512_gf2p8affine_epi64_epi8::<0>(
                _mm512_set1_epi64(x[7] as i64),
                _mm512_loadu_si512(m.add(64).cast()),
            ),
        );
        c[0] = _mm512_xor_si512(c[0], c[1]);
        c[2] = _mm512_xor_si512(c[2], c[3]);
        c[4] = _mm512_xor_si512(c[4], c[5]);
        c[6] = _mm512_xor_si512(c[6], c[7]);
        c[0] = _mm512_xor_si512(c[0], c[2]);
        c[1] = _mm512_xor_si512(c[1], c[3]);
        c[4] = _mm512_xor_si512(c[4], c[6]);
        c[5] = _mm512_xor_si512(c[5], c[7]);
        c[0] = _mm512_xor_si512(c[0], c[4]);
        c[1] = _mm512_xor_si512(c[1], c[5]);
        c[2] = _mm512_xor_si512(c[2], c[6]);
        c[3] = _mm512_xor_si512(c[3], c[7]);
        c
    }
}

#[inline(always)]
unsafe fn trq(x: [__m512i; 8]) -> [__m512i; 8] {
    unsafe {
        let lo1 = _mm512_set_epi64(11, 3, 10, 2, 9, 1, 8, 0);
        let hi1 = _mm512_set_epi64(15, 7, 14, 6, 13, 5, 12, 4);
        let lo2 = _mm512_set_epi64(11, 10, 3, 2, 9, 8, 1, 0);
        let hi2 = _mm512_set_epi64(15, 14, 7, 6, 13, 12, 5, 4);
        let lo4 = _mm512_set_epi64(11, 10, 9, 8, 3, 2, 1, 0);
        let hi4 = _mm512_set_epi64(15, 14, 13, 12, 7, 6, 5, 4);
        let t0 = _mm512_permutex2var_epi64(x[0], lo1, x[1]);
        let t1 = _mm512_permutex2var_epi64(x[0], hi1, x[1]);
        let t2 = _mm512_permutex2var_epi64(x[2], lo1, x[3]);
        let t3 = _mm512_permutex2var_epi64(x[2], hi1, x[3]);
        let t4 = _mm512_permutex2var_epi64(x[4], lo1, x[5]);
        let t5 = _mm512_permutex2var_epi64(x[4], hi1, x[5]);
        let t6 = _mm512_permutex2var_epi64(x[6], lo1, x[7]);
        let t7 = _mm512_permutex2var_epi64(x[6], hi1, x[7]);
        let u0 = _mm512_permutex2var_epi64(t0, lo2, t2);
        let u1 = _mm512_permutex2var_epi64(t0, hi2, t2);
        let u2 = _mm512_permutex2var_epi64(t1, lo2, t3);
        let u3 = _mm512_permutex2var_epi64(t1, hi2, t3);
        let u4 = _mm512_permutex2var_epi64(t4, lo2, t6);
        let u5 = _mm512_permutex2var_epi64(t4, hi2, t6);
        let u6 = _mm512_permutex2var_epi64(t5, lo2, t7);
        let u7 = _mm512_permutex2var_epi64(t5, hi2, t7);
        [
            _mm512_permutex2var_epi64(u0, lo4, u4),
            _mm512_permutex2var_epi64(u0, hi4, u4),
            _mm512_permutex2var_epi64(u1, lo4, u5),
            _mm512_permutex2var_epi64(u1, hi4, u5),
            _mm512_permutex2var_epi64(u2, lo4, u6),
            _mm512_permutex2var_epi64(u2, hi4, u6),
            _mm512_permutex2var_epi64(u3, lo4, u7),
            _mm512_permutex2var_epi64(u3, hi4, u7),
        ]
    }
}
const BYTE_TR: [u8; 64] = [
    0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3,
    11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6,
    14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63,
];
#[inline(always)]
unsafe fn pretranspose_ring(ring: *const V8, rw: usize) -> [u64; 64] {
    unsafe {
        // Two adjacent ring vectors hold the two 32-bit words for all eight rows.
        // One fixed byte permutation packs each of their eight byte positions across
        // rows directly, avoiding canonical-row -> qword -> byte retransposition.
        const INDEX: [u8; 64] = [
            0, 4, 8, 12, 16, 20, 24, 28, 1, 5, 9, 13, 17, 21, 25, 29, 2, 6, 10, 14, 18, 22, 26, 30,
            3, 7, 11, 15, 19, 23, 27, 31, 32, 36, 40, 44, 48, 52, 56, 60, 33, 37, 41, 45, 49, 53,
            57, 61, 34, 38, 42, 46, 50, 54, 58, 62, 35, 39, 43, 47, 51, 55, 59, 63,
        ];
        let ix = _mm512_loadu_si512(INDEX.as_ptr().cast());
        let mut out = core::mem::MaybeUninit::<[u64; 64]>::uninit();
        let p = out.as_mut_ptr().cast::<u64>();
        let v = _mm512_loadu_si512(ring.add(rw + 0).cast());
        _mm512_storeu_si512(p.add(0).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 2).cast());
        _mm512_storeu_si512(p.add(8).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 4).cast());
        _mm512_storeu_si512(p.add(16).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 6).cast());
        _mm512_storeu_si512(p.add(24).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 8).cast());
        _mm512_storeu_si512(p.add(32).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 10).cast());
        _mm512_storeu_si512(p.add(40).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 12).cast());
        _mm512_storeu_si512(p.add(48).cast(), _mm512_permutexvar_epi8(ix, v));
        let v = _mm512_loadu_si512(ring.add(rw + 14).cast());
        _mm512_storeu_si512(p.add(56).cast(), _mm512_permutexvar_epi8(ix, v));
        out.assume_init()
    }
}

// Canonical 27-product tensor over F2[e0,e1,e2]/(e0^2,e1^2,e2^2).
// Compose the input/output superset transforms and factor their shared XORs.
// Coefficient matrices are the existing transformed bank, in the same order.
// Declared-register XOR helpers keep shared input expressions in registers.
#[inline(always)] unsafe fn vxor(a:__m512i,b:__m512i)->__m512i{unsafe{let o;core::arch::asm!("vpxorq {o}, {a}, {b}",o=out(zmm_reg)o,a=in(zmm_reg)a,b=in(zmm_reg)b,options(pure,nomem,nostack,preserves_flags));o}}
#[inline(always)] unsafe fn vxor3(mut a:__m512i,b:__m512i,c:__m512i)->__m512i{unsafe{core::arch::asm!("vpternlogq {a}, {b}, {c}, 0x96",a=inout(zmm_reg)a,b=in(zmm_reg)b,c=in(zmm_reg)c,options(pure,nomem,nostack,preserves_flags));a}}
#[inline(always)] unsafe fn affine_factored27(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=vxor(v6,v7);
let v9=vxor3(v4,v5,v8);
let v10=vxor(v5,v7);
let v11=vxor(v2,v3);
let x1=vxor3(vxor(v0,v1),v9,v11);
let x2=vxor3(v1,v3,v10);
let x4=vxor(v8,v11);
let x8=vxor(v3,v7);
let x16=v9;
let x32=v10;
let x64=v8;
let x128=v7;
let m1=_mm512_loadu_si512(m.add(0).cast());
let m2=_mm512_loadu_si512(m.add(8).cast());
let m4=_mm512_loadu_si512(m.add(16).cast());
let m8=_mm512_loadu_si512(m.add(24).cast());
let m16=_mm512_loadu_si512(m.add(32).cast());
let m32=_mm512_loadu_si512(m.add(40).cast());
let m64=_mm512_loadu_si512(m.add(48).cast());
let m128=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m1);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m2);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m8);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m16);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m32);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m64);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x1,m128);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x2,m1);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x2,m4);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x2,m16);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x2,m64);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x4,m1);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x4,m2);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x4,m16);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x4,m32);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x8,m1);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x8,m16);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x16,m1);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x16,m2);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x16,m4);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x16,m8);
let t22=_mm512_gf2p8affine_epi64_epi8::<0>(x32,m1);
let t23=_mm512_gf2p8affine_epi64_epi8::<0>(x32,m4);
let t24=_mm512_gf2p8affine_epi64_epi8::<0>(x64,m1);
let t25=_mm512_gf2p8affine_epi64_epi8::<0>(x64,m2);
let t26=_mm512_gf2p8affine_epi64_epi8::<0>(x128,m1);
let t27=_mm512_ternarylogic_epi64::<0x96>(t23,t25,t26);
let t28=_mm512_ternarylogic_epi64::<0x96>(t17,t21,t27);
let t29=_mm512_ternarylogic_epi64::<0x96>(t11,t15,t28);
let t30=_mm512_xor_si512(t7,t29);
let t31=_mm512_ternarylogic_epi64::<0x96>(t20,t24,t30);
let t32=_mm512_ternarylogic_epi64::<0x96>(t10,t19,t22);
let t33=_mm512_ternarylogic_epi64::<0x96>(t9,t13,t16);
let t34=_mm512_ternarylogic_epi64::<0x96>(t6,t14,t31);
let t35=_mm512_xor_si512(t5,t32);
let t36=_mm512_xor_si512(t3,t33);
let t37=_mm512_ternarylogic_epi64::<0x96>(t18,t34,t35);
let t38=_mm512_ternarylogic_epi64::<0x96>(t2,t12,t36);
let t39=_mm512_xor_si512(t30,t36);
let t40=_mm512_xor_si512(t4,t37);
let t41=_mm512_xor_si512(t1,t8);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t0,t38),t40,t41),_mm512_ternarylogic_epi64::<0x96>(t35,t39,t41),_mm512_xor_si512(t34,t38),t39,t40,_mm512_xor_si512(t30,t35),t34,t30]
}}

// Exact constrained B networks: known zero words and repeated products are removed.
// Preserve the direct single-input map for MODE7 and MODE14.
#[inline(always)] unsafe fn factored_b_1(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v4,v8);
let v10=vxor3(v2,v6,v9);
let v11=vxor(v2,v8);
let v12=vxor(v1,v5);
let x258=vxor(v1,v8);
let x260=v11;
let x270=vxor3(v1,v3,v11);
let x272=v9;
let x306=vxor(v9,v12);
let x340=v10;
let x510=vxor3(vxor(v3,v7),v10,v12);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m0);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m2);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x270,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x270,m1);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x270,m2);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x270,m3);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m4);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x306,m0);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x306,m1);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x306,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x306,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x340,m0);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x340,m2);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x340,m4);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x340,m6);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m0);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m1);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m2);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m3);
let t22=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m4);
let t23=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m5);
let t24=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m6);
let t25=_mm512_gf2p8affine_epi64_epi8::<0>(x510,m7);
let t26=_mm512_ternarylogic_epi64::<0x96>(t13,t17,t25);
let t27=_mm512_ternarylogic_epi64::<0x96>(t7,t9,t26);
let t28=_mm512_ternarylogic_epi64::<0x96>(t1,t3,t27);
let t29=_mm512_ternarylogic_epi64::<0x96>(t16,t23,t28);
let t30=_mm512_ternarylogic_epi64::<0x96>(t11,t15,t21);
let t31=_mm512_ternarylogic_epi64::<0x96>(t6,t12,t24);
let t32=_mm512_ternarylogic_epi64::<0x96>(t2,t5,t29);
let t33=_mm512_xor_si512(t8,t30);
let t34=_mm512_xor_si512(t0,t31);
let t35=_mm512_ternarylogic_epi64::<0x96>(t22,t32,t34);
let t36=_mm512_ternarylogic_epi64::<0x96>(t14,t19,t33);
let t37=_mm512_xor_si512(t28,t34);
let t38=_mm512_xor_si512(t10,t20);
let t39=_mm512_xor_si512(t4,t35);
[t28,t37,t32,t39,_mm512_xor_si512(t28,t33),_mm512_ternarylogic_epi64::<0x96>(t33,t37,t38),_mm512_xor_si512(t32,t36),_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t18,t36),t38,t39)]
}}
#[inline(always)] unsafe fn factored_b_2(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v3,v7);
let v10=vxor3(v2,v6,v9);
let x12=vxor(v2,v3);
let x136=v9;
let x204=v10;
let x252=vxor3(v4,v5,v10);
let x264=vxor(v3,v8);
let x424=vxor3(v5,v8,v9);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m2);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m3);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x136,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x136,m4);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x204,m0);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x204,m1);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x204,m4);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x204,m5);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m0);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m1);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m2);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m3);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m4);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m5);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m6);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x252,m7);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m0);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m2);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x424,m0);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x424,m2);
let t22=_mm512_gf2p8affine_epi64_epi8::<0>(x424,m4);
let t23=_mm512_gf2p8affine_epi64_epi8::<0>(x424,m6);
let t24=_mm512_ternarylogic_epi64::<0x96>(t17,t19,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t5,t9,t24);
let t26=_mm512_xor_si512(t3,t25);
let t27=_mm512_ternarylogic_epi64::<0x96>(t15,t22,t26);
let t28=_mm512_ternarylogic_epi64::<0x96>(t7,t13,t21);
let t29=_mm512_ternarylogic_epi64::<0x96>(t2,t8,t16);
let t30=_mm512_ternarylogic_epi64::<0x96>(t1,t18,t26);
let t31=_mm512_xor_si512(t4,t28);
let t32=_mm512_ternarylogic_epi64::<0x96>(t20,t27,t31);
let t33=_mm512_ternarylogic_epi64::<0x96>(t6,t12,t29);
let t34=_mm512_xor_si512(t30,t31);
let t35=_mm512_xor_si512(t11,t32);
[_mm512_ternarylogic_epi64::<0x96>(t14,t27,t29),t27,_mm512_ternarylogic_epi64::<0x96>(t0,t29,t30),t30,_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t10,t14),t33,t35),t35,_mm512_ternarylogic_epi64::<0x96>(t0,t33,t34),t34]
}}
#[inline(always)] unsafe fn factored_b_3(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v4,v8);
let x48=vxor(v4,v5);
let x80=vxor(v4,v6);
let x264=vxor(v3,v8);
let x272=v9;
let x504=vxor3(vxor3(v3,v5,v6),v7,v9);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m5);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x80,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x80,m2);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x80,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x80,m6);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m2);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m3);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m0);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m4);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m0);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m1);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m2);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m3);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m4);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m5);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m6);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x504,m7);
let t22=_mm512_ternarylogic_epi64::<0x96>(t11,t13,t21);
let t23=_mm512_ternarylogic_epi64::<0x96>(t3,t7,t22);
let t24=_mm512_ternarylogic_epi64::<0x96>(t12,t17,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t6,t9,t19);
let t26=_mm512_ternarylogic_epi64::<0x96>(t2,t10,t20);
let t27=_mm512_ternarylogic_epi64::<0x96>(t1,t5,t24);
let t28=_mm512_ternarylogic_epi64::<0x96>(t18,t25,t26);
let t29=_mm512_ternarylogic_epi64::<0x96>(t4,t15,t27);
let t30=_mm512_xor_si512(t8,t28);
let t31=_mm512_xor_si512(t0,t16);
[t23,_mm512_xor_si512(t23,t26),_mm512_xor_si512(t23,t25),_mm512_xor_si512(t23,t30),t27,_mm512_ternarylogic_epi64::<0x96>(t26,t27,t31),_mm512_xor_si512(t25,t29),_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t14,t29),t30,t31)]
}}
#[inline(always)] unsafe fn factored_b_4(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v6,v7);
let x160=vxor(v5,v7);
let x192=v9;
let x240=vxor3(v4,v5,v9);
let x384=vxor(v7,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x160,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x160,m2);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x160,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x160,m6);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m1);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m5);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m2);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m3);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m6);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x240,m7);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m0);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m4);
let t18=_mm512_ternarylogic_epi64::<0x96>(t7,t15,t17);
let t19=_mm512_xor_si512(t3,t18);
let t20=_mm512_ternarylogic_epi64::<0x96>(t11,t16,t19);
let t21=_mm512_ternarylogic_epi64::<0x96>(t1,t5,t20);
let t22=_mm512_xor_si512(t6,t14);
let t23=_mm512_xor_si512(t2,t13);
let t24=_mm512_ternarylogic_epi64::<0x96>(t12,t22,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t4,t10,t21);
let t26=_mm512_xor_si512(t0,t9);
[_mm512_xor_si512(t19,t24),_mm512_xor_si512(t19,t23),_mm512_xor_si512(t19,t22),t19,_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t8,t24),t25,t26),_mm512_ternarylogic_epi64::<0x96>(t21,t23,t26),_mm512_xor_si512(t22,t25),t21]
}}
#[inline(always)] unsafe fn factored_b_5(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v6,v8);
let x288=vxor(v5,v8);
let x320=v9;
let x480=vxor3(v5,v7,v9);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m5);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m2);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m6);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m2);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m3);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m6);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x480,m7);
let t16=_mm512_ternarylogic_epi64::<0x96>(t3,t7,t15);
let t17=_mm512_ternarylogic_epi64::<0x96>(t6,t13,t16);
let t18=_mm512_ternarylogic_epi64::<0x96>(t1,t5,t11);
let t19=_mm512_xor_si512(t2,t14);
let t20=_mm512_ternarylogic_epi64::<0x96>(t12,t17,t19);
let t21=_mm512_ternarylogic_epi64::<0x96>(t4,t9,t18);
let t22=_mm512_xor_si512(t16,t19);
let t23=_mm512_xor_si512(t0,t10);
[t16,t22,t17,t20,_mm512_xor_si512(t16,t18),_mm512_ternarylogic_epi64::<0x96>(t18,t22,t23),_mm512_xor_si512(t17,t21),_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t8,t20),t21,t23)]
}}
#[inline(always)] unsafe fn factored_b_6(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let x192=vxor(v6,v7);
let x384=vxor(v7,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m2);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m3);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m4);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m5);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m6);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x192,m7);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m2);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m4);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m6);
let t12=_mm512_xor_si512(t7,t11);
let t13=_mm512_ternarylogic_epi64::<0x96>(t5,t10,t12);
let t14=_mm512_xor_si512(t3,t9);
let t15=_mm512_ternarylogic_epi64::<0x96>(t8,t13,t14);
let t16=_mm512_xor_si512(t12,t14);
let t17=_mm512_xor_si512(t4,t6);
let t18=_mm512_xor_si512(t1,t15);
[_mm512_xor_si512(t6,t12),t12,_mm512_xor_si512(t13,t17),t13,_mm512_ternarylogic_epi64::<0x96>(t2,t6,t16),t16,_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t0,t2),t17,t18),t18]
}}
#[inline(always)] unsafe fn factored_b_7(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v7=_mm512_set1_epi64(*p.add(7) as i64);
let v8=_mm512_set1_epi64(-1);
let x384=vxor(v7,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m2);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m3);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m4);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m5);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m6);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x384,m7);
let t8=_mm512_xor_si512(t6,t7);
let t9=_mm512_ternarylogic_epi64::<0x96>(t4,t5,t8);
let t10=_mm512_xor_si512(t5,t7);
let t11=_mm512_xor_si512(t2,t3);
[t7,t8,t10,t9,_mm512_xor_si512(t3,t7),_mm512_xor_si512(t8,t11),_mm512_ternarylogic_epi64::<0x96>(t1,t3,t10),_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t0,t1),t9,t11)]
}}
#[inline(always)] unsafe fn factored_b_8(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v6=_mm512_set1_epi64(*p.add(6) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v6,v8);
let v10=vxor3(v4,v5,v9);
let v11=vxor(v5,v8);
let v12=vxor(v2,v3);
let x264=vxor(v3,v8);
let x288=v11;
let x298=vxor3(v1,v3,v11);
let x320=v9;
let x332=vxor(v9,v12);
let x368=v10;
let x383=vxor3(vxor(v0,v1),v10,v12);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m4);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m0);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m2);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m2);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m6);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x320,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x332,m0);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x332,m1);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x332,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x332,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x368,m0);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x368,m1);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x368,m2);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x368,m3);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m0);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m1);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m2);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m3);
let t22=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m4);
let t23=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m5);
let t24=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m6);
let t25=_mm512_gf2p8affine_epi64_epi8::<0>(x383,m7);
let t26=_mm512_ternarylogic_epi64::<0x96>(t13,t17,t25);
let t27=_mm512_ternarylogic_epi64::<0x96>(t7,t9,t26);
let t28=_mm512_ternarylogic_epi64::<0x96>(t1,t3,t27);
let t29=_mm512_ternarylogic_epi64::<0x96>(t16,t24,t28);
let t30=_mm512_ternarylogic_epi64::<0x96>(t8,t12,t29);
let t31=_mm512_ternarylogic_epi64::<0x96>(t6,t15,t23);
let t32=_mm512_ternarylogic_epi64::<0x96>(t5,t11,t21);
let t33=_mm512_xor_si512(t2,t31);
let t34=_mm512_xor_si512(t0,t32);
let t35=_mm512_ternarylogic_epi64::<0x96>(t22,t30,t33);
let t36=_mm512_ternarylogic_epi64::<0x96>(t10,t20,t34);
let t37=_mm512_xor_si512(t28,t34);
let t38=_mm512_xor_si512(t14,t35);
let t39=_mm512_xor_si512(t4,t19);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t18,t36),t38,t39),_mm512_ternarylogic_epi64::<0x96>(t33,t37,t39),_mm512_xor_si512(t30,t36),t37,t38,_mm512_xor_si512(t28,t33),t30,t28]
}}
#[inline(always)] unsafe fn factored_b_9(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v5=_mm512_set1_epi64(*p.add(5) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v1,v5);
let v10=vxor3(v0,v4,v9);
let x34=v9;
let x48=vxor(v4,v5);
let x51=v10;
let x63=vxor3(v2,v3,v10);
let x288=vxor(v5,v8);
let x298=vxor3(v3,v8,v9);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x34,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x34,m4);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m0);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m1);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m2);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x48,m3);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x51,m0);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x51,m1);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x51,m4);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x51,m5);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m0);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m1);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m2);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m3);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m4);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m5);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m6);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x63,m7);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m0);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x288,m2);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m0);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m2);
let t22=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m4);
let t23=_mm512_gf2p8affine_epi64_epi8::<0>(x298,m6);
let t24=_mm512_ternarylogic_epi64::<0x96>(t17,t19,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t5,t9,t24);
let t26=_mm512_xor_si512(t1,t25);
let t27=_mm512_ternarylogic_epi64::<0x96>(t15,t22,t26);
let t28=_mm512_ternarylogic_epi64::<0x96>(t7,t13,t21);
let t29=_mm512_ternarylogic_epi64::<0x96>(t4,t8,t16);
let t30=_mm512_ternarylogic_epi64::<0x96>(t3,t18,t26);
let t31=_mm512_xor_si512(t0,t28);
let t32=_mm512_ternarylogic_epi64::<0x96>(t20,t27,t31);
let t33=_mm512_ternarylogic_epi64::<0x96>(t6,t12,t29);
let t34=_mm512_xor_si512(t30,t31);
let t35=_mm512_xor_si512(t11,t32);
[_mm512_ternarylogic_epi64::<0x96>(t2,t33,t34),t34,_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t10,t14),t33,t35),t35,_mm512_ternarylogic_epi64::<0x96>(t2,t29,t30),t30,_mm512_ternarylogic_epi64::<0x96>(t14,t27,t29),t27]
}}
#[inline(always)] unsafe fn factored_b_10(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v4=_mm512_set1_epi64(*p.add(4) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v4,v8);
let v10=vxor(v2,v3);
let x10=vxor(v1,v3);
let x12=v10;
let x264=vxor(v3,v8);
let x272=v9;
let x287=vxor3(vxor(v0,v1),v9,v10);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m2);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m6);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m1);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m5);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m4);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m0);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m1);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m2);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x272,m3);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m0);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m1);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m2);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m3);
let t18=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m4);
let t19=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m5);
let t20=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m6);
let t21=_mm512_gf2p8affine_epi64_epi8::<0>(x287,m7);
let t22=_mm512_ternarylogic_epi64::<0x96>(t9,t13,t21);
let t23=_mm512_ternarylogic_epi64::<0x96>(t3,t7,t22);
let t24=_mm512_ternarylogic_epi64::<0x96>(t12,t20,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t5,t8,t17);
let t26=_mm512_ternarylogic_epi64::<0x96>(t2,t11,t19);
let t27=_mm512_xor_si512(t6,t24);
let t28=_mm512_xor_si512(t1,t25);
let t29=_mm512_ternarylogic_epi64::<0x96>(t18,t26,t27);
let t30=_mm512_ternarylogic_epi64::<0x96>(t4,t16,t28);
let t31=_mm512_xor_si512(t23,t28);
let t32=_mm512_xor_si512(t10,t29);
let t33=_mm512_xor_si512(t0,t15);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t14,t30),t32,t33),_mm512_ternarylogic_epi64::<0x96>(t26,t31,t33),_mm512_xor_si512(t27,t30),t31,t32,_mm512_xor_si512(t23,t26),t27,t23]
}}
#[inline(always)] unsafe fn factored_b_11(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v3=_mm512_set1_epi64(*p.add(3) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v2,v3);
let x10=vxor(v1,v3);
let x12=v9;
let x15=vxor3(v0,v1,v9);
let x264=vxor(v3,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m2);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x10,m6);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m1);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x12,m5);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m2);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m3);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m6);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x15,m7);
let t16=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m0);
let t17=_mm512_gf2p8affine_epi64_epi8::<0>(x264,m4);
let t18=_mm512_ternarylogic_epi64::<0x96>(t7,t15,t17);
let t19=_mm512_xor_si512(t3,t18);
let t20=_mm512_ternarylogic_epi64::<0x96>(t11,t16,t19);
let t21=_mm512_ternarylogic_epi64::<0x96>(t1,t5,t20);
let t22=_mm512_xor_si512(t6,t14);
let t23=_mm512_xor_si512(t2,t13);
let t24=_mm512_ternarylogic_epi64::<0x96>(t12,t22,t23);
let t25=_mm512_ternarylogic_epi64::<0x96>(t4,t10,t21);
let t26=_mm512_xor_si512(t0,t9);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t8,t24),t25,t26),_mm512_ternarylogic_epi64::<0x96>(t21,t23,t26),_mm512_xor_si512(t22,t25),t21,_mm512_xor_si512(t19,t24),_mm512_xor_si512(t19,t23),_mm512_xor_si512(t19,t22),t19]
}}
#[inline(always)] unsafe fn factored_b_12(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v2=_mm512_set1_epi64(*p.add(2) as i64);
let v8=_mm512_set1_epi64(-1);
let v9=vxor(v2,v8);
let x258=vxor(v1,v8);
let x260=v9;
let x263=vxor3(v0,v1,v9);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m2);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m4);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m6);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m0);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m1);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m4);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x260,m5);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m1);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m2);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m3);
let t12=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m4);
let t13=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m5);
let t14=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m6);
let t15=_mm512_gf2p8affine_epi64_epi8::<0>(x263,m7);
let t16=_mm512_ternarylogic_epi64::<0x96>(t3,t7,t15);
let t17=_mm512_ternarylogic_epi64::<0x96>(t6,t14,t16);
let t18=_mm512_ternarylogic_epi64::<0x96>(t1,t5,t11);
let t19=_mm512_xor_si512(t2,t13);
let t20=_mm512_ternarylogic_epi64::<0x96>(t12,t17,t19);
let t21=_mm512_ternarylogic_epi64::<0x96>(t4,t10,t18);
let t22=_mm512_xor_si512(t16,t19);
let t23=_mm512_xor_si512(t0,t9);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t8,t20),t21,t23),_mm512_ternarylogic_epi64::<0x96>(t18,t22,t23),_mm512_xor_si512(t17,t21),_mm512_xor_si512(t16,t18),t20,t22,t17,t16]
}}
#[inline(always)] unsafe fn factored_b_13(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v1=_mm512_set1_epi64(*p.add(1) as i64);
let v8=_mm512_set1_epi64(-1);
let x3=vxor(v0,v1);
let x258=vxor(v1,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m2);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m3);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m4);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m5);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m6);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x3,m7);
let t8=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m0);
let t9=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m2);
let t10=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m4);
let t11=_mm512_gf2p8affine_epi64_epi8::<0>(x258,m6);
let t12=_mm512_xor_si512(t7,t11);
let t13=_mm512_ternarylogic_epi64::<0x96>(t5,t10,t12);
let t14=_mm512_xor_si512(t3,t9);
let t15=_mm512_ternarylogic_epi64::<0x96>(t8,t13,t14);
let t16=_mm512_xor_si512(t12,t14);
let t17=_mm512_xor_si512(t4,t6);
let t18=_mm512_xor_si512(t1,t15);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t0,t2),t17,t18),t18,_mm512_ternarylogic_epi64::<0x96>(t2,t6,t16),t16,_mm512_xor_si512(t13,t17),t13,_mm512_xor_si512(t6,t12),t12]
}}
#[inline(always)] unsafe fn factored_b_14(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{
let v0=_mm512_set1_epi64(*p.add(0) as i64);
let v8=_mm512_set1_epi64(-1);
let x257=vxor(v0,v8);
let m0=_mm512_loadu_si512(m.add(0).cast());
let m1=_mm512_loadu_si512(m.add(8).cast());
let m2=_mm512_loadu_si512(m.add(16).cast());
let m3=_mm512_loadu_si512(m.add(24).cast());
let m4=_mm512_loadu_si512(m.add(32).cast());
let m5=_mm512_loadu_si512(m.add(40).cast());
let m6=_mm512_loadu_si512(m.add(48).cast());
let m7=_mm512_loadu_si512(m.add(56).cast());
let t0=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m0);
let t1=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m1);
let t2=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m2);
let t3=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m3);
let t4=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m4);
let t5=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m5);
let t6=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m6);
let t7=_mm512_gf2p8affine_epi64_epi8::<0>(x257,m7);
let t8=_mm512_xor_si512(t6,t7);
let t9=_mm512_ternarylogic_epi64::<0x96>(t4,t5,t8);
let t10=_mm512_xor_si512(t5,t7);
let t11=_mm512_xor_si512(t2,t3);
[_mm512_ternarylogic_epi64::<0x96>(_mm512_xor_si512(t0,t1),t9,t11),_mm512_ternarylogic_epi64::<0x96>(t1,t3,t10),_mm512_xor_si512(t8,t11),_mm512_xor_si512(t3,t7),t9,t10,t8,t7]
}}
#[inline(always)] unsafe fn affine_factored_b<const MODE:u8>(p:*const u64,m:*const u64)->[__m512i;8]{unsafe{match MODE{0=>affine_factored27(p,m),1=>factored_b_1(p,m),2=>factored_b_2(p,m),3=>factored_b_3(p,m),4=>factored_b_4(p,m),5=>factored_b_5(p,m),6=>factored_b_6(p,m),7=>factored_b_7(p,m),8=>factored_b_8(p,m),9=>factored_b_9(p,m),10=>factored_b_10(p,m),11=>factored_b_11(p,m),12=>factored_b_12(p,m),13=>factored_b_13(p,m),14=>factored_b_14(p,m),15=>[_mm512_setzero_si512();8],_=>unreachable!()}}}

// Share the expensive arithmetic by structural row mode. The eight Horner
// weights remain selected by the caller's matrix-bank pointer.
#[inline(never)]
unsafe fn row_product<const MODE: u8, const FIRST: bool>(
    ap: *const u64, bp: *const u64, ma: *const u64, mb: *const u64,
    acc: &mut [__m512i; 8],
) {
    unsafe {
        let av = affine_factored27(ap, ma.add(64));
        let bv = if MODE == 7 || MODE == 14 { affine_conv(bp, mb, MODE) } else { affine_factored_b::<MODE>(bp, mb.add(64)) };
        for i in 0..8 {
            let value = if MODE == 15 { av[i] } else {
                let value = _mm512_gf2p8mul_epi8(av[i], bv[i]);
                if MODE == 0 { value } else { _mm512_xor_si512(value, av[i]) }
            };
            acc[i] = if FIRST { value } else { _mm512_xor_si512(acc[i], value) };
        }
    }
}
#[inline(always)]
unsafe fn project_const<const BLK: usize>(
    proj: &StreamProj<'_>,
    rows: RankedRows,
    a: [__m512i; 8],
    b: [__m512i; 8],
    ap: &[u64; 64],
    bp: &[u64; 64],
    m: *const u64,
) {
    unsafe {
        let mut acc = [_mm512_setzero_si512(); 8];
        rows.publish_dense_values(0, a[0], b[0]);
        match mode(BLK, 7) {
0 => row_product::<0, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
1 => row_product::<1, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
2 => row_product::<2, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
3 => row_product::<3, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
4 => row_product::<4, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
5 => row_product::<5, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
6 => row_product::<6, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
7 => row_product::<7, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
8 => row_product::<8, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
9 => row_product::<9, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
10 => row_product::<10, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
11 => row_product::<11, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
12 => row_product::<12, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
13 => row_product::<13, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
14 => row_product::<14, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
15 => row_product::<15, true>(ap.as_ptr().add(7 * 8), bp.as_ptr().add(7 * 8), m.add(7 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(1, a[1], b[1]);
        match mode(BLK, 6) {
0 => row_product::<0, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(6 * 8), bp.as_ptr().add(6 * 8), m.add(6 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(2, a[2], b[2]);
        match mode(BLK, 5) {
0 => row_product::<0, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(5 * 8), bp.as_ptr().add(5 * 8), m.add(5 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(3, a[3], b[3]);
        match mode(BLK, 4) {
0 => row_product::<0, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(4 * 8), bp.as_ptr().add(4 * 8), m.add(4 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(4, a[4], b[4]);
        match mode(BLK, 3) {
0 => row_product::<0, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(3 * 8), bp.as_ptr().add(3 * 8), m.add(3 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(5, a[5], b[5]);
        match mode(BLK, 2) {
0 => row_product::<0, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(2 * 8), bp.as_ptr().add(2 * 8), m.add(2 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(6, a[6], b[6]);
        match mode(BLK, 1) {
0 => row_product::<0, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(1 * 8), bp.as_ptr().add(1 * 8), m.add(1 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        rows.publish_dense_values(7, a[7], b[7]);
        match mode(BLK, 0) {
0 => row_product::<0, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
1 => row_product::<1, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
2 => row_product::<2, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
3 => row_product::<3, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
4 => row_product::<4, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
5 => row_product::<5, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
6 => row_product::<6, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
7 => row_product::<7, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
8 => row_product::<8, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
9 => row_product::<9, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
10 => row_product::<10, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
11 => row_product::<11, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
12 => row_product::<12, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
13 => row_product::<13, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
14 => row_product::<14, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
15 => row_product::<15, false>(ap.as_ptr().add(0 * 8), bp.as_ptr().add(0 * 8), m.add(0 * 128), m, &mut acc),
_ => unreachable!(),
}
        // Keep the completed Horner state and this row's NT stores before the
        // next row's publication. The compiler barrier has no machine instruction;
        // its memory clobber prevents combining all 24 witness stores into a burst.
        core::arch::asm!("/* Horner NT publication boundary: {s0} {s1} {s2} {s3} {s4} {s5} {s6} {s7} */",
s0=inout(zmm_reg)acc[0],s1=inout(zmm_reg)acc[1],s2=inout(zmm_reg)acc[2],s3=inout(zmm_reg)acc[3],s4=inout(zmm_reg)acc[4],s5=inout(zmm_reg)acc[5],s6=inout(zmm_reg)acc[6],s7=inout(zmm_reg)acc[7],options(nostack,preserves_flags));

        let ix = _mm512_loadu_si512(BYTE_TR.as_ptr().cast());
        let out = trq([
            _mm512_permutexvar_epi8(ix, acc[0]),
            _mm512_permutexvar_epi8(ix, acc[1]),
            _mm512_permutexvar_epi8(ix, acc[2]),
            _mm512_permutexvar_epi8(ix, acc[3]),
            _mm512_permutexvar_epi8(ix, acc[4]),
            _mm512_permutexvar_epi8(ix, acc[5]),
            _mm512_permutexvar_epi8(ix, acc[6]),
            _mm512_permutexvar_epi8(ix, acc[7]),
        ]);
        _mm512_stream_si512(
            proj.out
                .add(0 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[0],
        );
        _mm512_stream_si512(
            proj.out
                .add(1 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[1],
        );
        _mm512_stream_si512(
            proj.out
                .add(2 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[2],
        );
        _mm512_stream_si512(
            proj.out
                .add(3 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[3],
        );
        _mm512_stream_si512(
            proj.out
                .add(4 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[4],
        );
        _mm512_stream_si512(
            proj.out
                .add(5 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[5],
        );
        _mm512_stream_si512(
            proj.out
                .add(6 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[6],
        );
        _mm512_stream_si512(
            proj.out
                .add(7 * proj.out_stride + BLK * 64 - proj.out_bias)
                .cast(),
            out[7],
        );
    }
}
/// Same ring, ranked-static and non-temporal publication contract as the
/// direct-inline path. The caller issues the task's existing final sfence.
#[inline(never)]
pub(super) unsafe fn project(
    proj: &StreamProj<'_>,
    blk: usize,
    rows: RankedRows,
    ar: *const V8,
    br: *const V8,
    rw: usize,
    t: &Tables,
) {
    unsafe {
        let ap = pretranspose_ring(ar, rw);
        let bp = pretranspose_ring(br, rw);
        let a = tr8x16_zmm(ar, rw);
        let b = tr8x16_zmm(br, rw);
        match blk {
            3 => project_const::<3>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            4 => project_const::<4>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            5 => project_const::<5>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            6 => project_const::<6>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            7 => project_const::<7>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            8 => project_const::<8>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            9 => project_const::<9>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            10 => project_const::<10>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            11 => project_const::<11>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            12 => project_const::<12>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            13 => project_const::<13>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            14 => project_const::<14>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            15 => project_const::<15>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            16 => project_const::<16>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            17 => project_const::<17>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            18 => project_const::<18>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            19 => project_const::<19>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            20 => project_const::<20>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            21 => project_const::<21>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            22 => project_const::<22>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            23 => project_const::<23>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            24 => project_const::<24>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            25 => project_const::<25>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            26 => project_const::<26>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            27 => project_const::<27>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            28 => project_const::<28>(proj, rows, a, b, &ap, &bp, t.0.as_ptr()),
            _ => unreachable!("only fully-live ranked mixed windows reach XOR projection"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use flock_core::{field::F8, ntt::AdditiveNttGf8};
    #[repr(align(64))]
    struct Buf([u8; 8 * BYTES_PER_BLOCK]);
    #[repr(align(32))]
    struct Ring([[u32; 8]; 32]);
    #[test]
    fn ranked_inverse_table_is_dense_not_two_sparse() {
        let ns = AdditiveNttGf8::new(6, F8::ZERO);
        let nl = AdditiveNttGf8::new(6, F8(64));
        let table = InvNttTableByteSingleGf8::new(&ns, &nl);
        for t in 0..64 {
            let mut unit = [F8::ZERO; 64];
            unit[t] = F8::ONE;
            ns.inverse(&mut unit);
            nl.forward(&mut unit);
            assert_eq!(unit.iter().filter(|v| **v != F8::ZERO).count(), 64);
            let mut input = [0u8; 8];
            input[t / 8] = 1 << (t % 8);
            let mut actual = [F8::ZERO; 64];
            table.apply_scalar(&input, &mut actual);
            assert_eq!(actual, unit);
            if t == 0 {
                assert_eq!(actual[0], F8(0x76));
            }
        }
        println!("PASS 64 actual NTT unit columns are dense; sparse/involution claim refuted");
    }
    #[test]
    fn xor_projection_publishes_and_matches_scalar() {
        unsafe {
            let ns = AdditiveNttGf8::new(6, F8::ZERO);
            let nl = AdditiveNttGf8::new(6, F8(64));
            let table = InvNttTableByteSingleGf8::new(&ns, &nl);
            let t = Tables::new(&table);
            let mut seed = 1357u64;
            let mut next = || {
                seed ^= seed << 13;
                seed ^= seed >> 7;
                seed ^= seed << 17;
                seed as u8
            };
            for rw in [0, 16] {
                for case in 0..5 {
                    for blk in 3..29 {
                        let mut aa = [[0u8; 64]; 8];
                        let mut bb = [[0u8; 64]; 8];
                        let mut ar = Ring([[0xdeadbeef; 8]; 32]);
                        let mut br = Ring([[0xdeadbeef; 8]; 32]);
                        for row in 0..8 {
                            for i in 0..64 {
                                aa[row][i] = if case == 0 {
                                    0
                                } else if case == 1 {
                                    255
                                } else {
                                    next()
                                };
                                bb[row][i] = if known(mode(blk, i / 8)) & (1 << (i % 8)) != 0 {
                                    255
                                } else if case == 0 {
                                    0
                                } else if case == 1 {
                                    255
                                } else {
                                    next()
                                };
                            }
                            for w in 0..16 {
                                ar.0[rw + w][row] = u32::from_le_bytes(
                                    aa[row][w * 4..w * 4 + 4].try_into().unwrap(),
                                );
                                br.0[rw + w][row] = u32::from_le_bytes(
                                    bb[row][w * 4..w * 4 + 4].try_into().unwrap(),
                                );
                            }
                        }
                        let mut a = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut b = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut z = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut output = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let stride = 29 * 64;
                        let bias = 128;
                        let plan=flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(&table,&output.0,true);
                        assert!(plan.bcomplement_static_eligible());
                        let proj = StreamProj {
                            stage: core::ptr::null_mut(),
                            out: output.0.as_mut_ptr(),
                            out_stride: stride,
                            out_bias: bias,
                            inv_table: &table,
                            plan,
                            one_rows_elided: true,
                            w30_elided: true,
                        };
                        let offset = blk * 64;
                        let rows = RankedRows::new(
                            z.0.as_mut_ptr().add(offset).cast(),
                            a.0.as_mut_ptr().add(offset).cast(),
                            b.0.as_mut_ptr().add(offset).cast(),
                        );
                        project(
                            &proj,
                            blk,
                            rows,
                            ar.0.as_ptr().cast(),
                            br.0.as_ptr().cast(),
                            rw,
                            &t,
                        );
                        _mm_sfence();
                        let mut want = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut wa = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut wb = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        let mut wz = Buf([0xa5; 8 * BYTES_PER_BLOCK]);
                        for row in 0..8 {
                            let start = row * BYTES_PER_BLOCK + offset;
                            wa.0[start..start + 64].copy_from_slice(&aa[row]);
                            wb.0[start..start + 64].copy_from_slice(&bb[row]);
                            for i in 0..64 {
                                wz.0[start + i] = aa[row][i] & bb[row][i];
                            }
                            let mut acc = [F8::ZERO; 64];
                            for k in (0..8).rev() {
                                let mut av = [F8::ZERO; 64];
                                let mut bv = [F8::ZERO; 64];
                                table.apply_scalar(&aa[row][k * 8..k * 8 + 8], &mut av);
                                table.apply_scalar(&bb[row][k * 8..k * 8 + 8], &mut bv);
                                for i in 0..64 {
                                    acc[i] = acc[i] * F8(2) + av[i] * bv[i];
                                }
                            }
                            for i in 0..64 {
                                want.0[row * stride + offset - bias + i] = acc[i].0;
                            }
                        }
                        assert_eq!(output.0, want.0, "projection rw={rw} case={case} blk={blk}");
                        assert_eq!(a.0, wa.0);
                        assert_eq!(b.0, wb.0);
                        assert_eq!(z.0, wz.0);
                    }
                }
            }
            println!(
                "260 complete ring-to-published-window cases, including A/B/Z, compact output stride, both ring halves and untouched bytes"
            );
        }
    }
}
