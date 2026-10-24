//! Eight-row XOR convolution of the inverse-NTT column map.
//! Over characteristic two, the substitution epsilon=x+1 has epsilon^2=0.
//! Superset XOR transforms turn eight-term XOR convolution into 27 bilinear
//! GFNI products. Eight matrix banks absorb the Horner weights into A,
//! eliminating accumulator field multiplies. Setup is once per shared invocation.
use super::*;
use flock_core::zerocheck::univariate_skip_optimized::round1_ranked_bcomplement_mode as mode;
#[repr(align(64))]
pub(super) struct Tables([u64; 8 * 128 + 10 * 8]);
impl Tables {
    pub(super) fn new(table: &InvNttTableByteSingleGf8) -> Self {
        assert_eq!(table.ell, 64);
        // Bank k absorbs the Horner weight 2^k into the linear A map.
        // GF(256) multiplication distributes over both the byte map and XOR
        // convolution. B keeps bank zero; products then accumulate by XOR.
        let mut m = [0u64; 8 * 128 + 10 * 8];
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
        // B-only coefficient sums used by the sparse half-width kernels.
        // Only bank zero is needed: all Horner scaling remains in the A banks.
        for lane in 0..8 { m[8 * 128 + 0 * 8 + lane] = m[4 * 8 + lane] ^ m[5 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 1 * 8 + lane] = m[6 * 8 + lane] ^ m[7 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 2 * 8 + lane] = m[4 * 8 + lane] ^ m[6 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 3 * 8 + lane] = m[5 * 8 + lane] ^ m[7 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 4 * 8 + lane] = m[4 * 8 + lane] ^ m[5 * 8 + lane] ^ m[6 * 8 + lane] ^ m[7 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 5 * 8 + lane] = m[0 * 8 + lane] ^ m[1 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 6 * 8 + lane] = m[2 * 8 + lane] ^ m[3 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 7 * 8 + lane] = m[0 * 8 + lane] ^ m[2 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 8 * 8 + lane] = m[1 * 8 + lane] ^ m[3 * 8 + lane]; }
        for lane in 0..8 { m[8 * 128 + 9 * 8 + lane] = m[0 * 8 + lane] ^ m[1 * 8 + lane] ^ m[2 * 8 + lane] ^ m[3 * 8 + lane]; }
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

// Sparse XOR convolution: mode 4, 18 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_4(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x0 = !*p.add(4);
        let x1 = !*p.add(5);
        let x2 = !*p.add(6);
        let x3 = !*p.add(7);
        let x4 = x0 ^ x2;
        let x5 = x1 ^ x3;
        let x6 = x0 ^ x1;
        let v7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x0 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let v8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x1 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x6 as i64), _mm512_loadu_si512(m.add(1024).cast()));
        let v10 = _mm512_xor_si512(v7, v8);
        let v11 = _mm512_xor_si512(v9, v10);
        let x12 = x2 ^ x3;
        let v13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x2 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x3 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let v15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x12 as i64), _mm512_loadu_si512(m.add(1032).cast()));
        let v16 = _mm512_xor_si512(v13, v14);
        let v17 = _mm512_xor_si512(v15, v16);
        let x18 = x4 ^ x5;
        let v19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x4 as i64), _mm512_loadu_si512(m.add(1040).cast()));
        let v20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x5 as i64), _mm512_loadu_si512(m.add(1048).cast()));
        let v21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x18 as i64), _mm512_loadu_si512(m.add(1056).cast()));
        let v22 = _mm512_xor_si512(v19, v20);
        let v23 = _mm512_xor_si512(v21, v22);
        let v24 = _mm512_xor_si512(v10, v16);
        let v25 = _mm512_xor_si512(v11, v17);
        let v26 = _mm512_xor_si512(v22, v24);
        let v27 = _mm512_xor_si512(v23, v25);
        let x28 = x0 ^ x2;
        let x29 = x1 ^ x3;
        let x30 = x0 ^ x1;
        let v31 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x0 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let v32 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x1 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v33 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x30 as i64), _mm512_loadu_si512(m.add(1064).cast()));
        let v34 = _mm512_xor_si512(v31, v32);
        let v35 = _mm512_xor_si512(v33, v34);
        let x36 = x2 ^ x3;
        let v37 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x2 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v38 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x3 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let v39 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x36 as i64), _mm512_loadu_si512(m.add(1072).cast()));
        let v40 = _mm512_xor_si512(v37, v38);
        let v41 = _mm512_xor_si512(v39, v40);
        let x42 = x28 ^ x29;
        let v43 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x28 as i64), _mm512_loadu_si512(m.add(1080).cast()));
        let v44 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x29 as i64), _mm512_loadu_si512(m.add(1088).cast()));
        let v45 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x42 as i64), _mm512_loadu_si512(m.add(1096).cast()));
        let v46 = _mm512_xor_si512(v43, v44);
        let v47 = _mm512_xor_si512(v45, v46);
        let v48 = _mm512_xor_si512(v34, v40);
        let v49 = _mm512_xor_si512(v35, v41);
        let v50 = _mm512_xor_si512(v46, v48);
        let v51 = _mm512_xor_si512(v47, v49);
        [v24, v25, v26, v27, v48, v49, v50, v51]
    }
}

// Sparse XOR convolution: mode 5, 16 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_5(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x52 = !*p.add(5);
        let x53 = !*p.add(6);
        let x54 = !*p.add(7);
        let x55 = x52 ^ x54;
        let v56 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x52 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v57 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x52 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let x58 = x53 ^ x54;
        let v59 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x53 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v60 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x54 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let v61 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x58 as i64), _mm512_loadu_si512(m.add(1032).cast()));
        let v62 = _mm512_xor_si512(v59, v60);
        let v63 = _mm512_xor_si512(v61, v62);
        let x64 = x53 ^ x55;
        let v65 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x53 as i64), _mm512_loadu_si512(m.add(1040).cast()));
        let v66 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x55 as i64), _mm512_loadu_si512(m.add(1048).cast()));
        let v67 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x64 as i64), _mm512_loadu_si512(m.add(1056).cast()));
        let v68 = _mm512_xor_si512(v65, v66);
        let v69 = _mm512_xor_si512(v67, v68);
        let v70 = _mm512_xor_si512(v56, v62);
        let v71 = _mm512_xor_si512(v57, v63);
        let v72 = _mm512_xor_si512(v68, v70);
        let v73 = _mm512_xor_si512(v69, v71);
        let x74 = x52 ^ x54;
        let v75 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x52 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v76 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x52 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let x77 = x53 ^ x54;
        let v78 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x53 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v79 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x54 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let v80 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x77 as i64), _mm512_loadu_si512(m.add(1072).cast()));
        let v81 = _mm512_xor_si512(v78, v79);
        let v82 = _mm512_xor_si512(v80, v81);
        let x83 = x53 ^ x74;
        let v84 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x53 as i64), _mm512_loadu_si512(m.add(1080).cast()));
        let v85 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x74 as i64), _mm512_loadu_si512(m.add(1088).cast()));
        let v86 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x83 as i64), _mm512_loadu_si512(m.add(1096).cast()));
        let v87 = _mm512_xor_si512(v84, v85);
        let v88 = _mm512_xor_si512(v86, v87);
        let v89 = _mm512_xor_si512(v75, v81);
        let v90 = _mm512_xor_si512(v76, v82);
        let v91 = _mm512_xor_si512(v87, v89);
        let v92 = _mm512_xor_si512(v88, v90);
        [v70, v71, v72, v73, v89, v90, v91, v92]
    }
}

// Sparse XOR convolution: mode 6, 12 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_6(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x93 = !*p.add(6);
        let x94 = !*p.add(7);
        let x95 = x93 ^ x94;
        let v96 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x93 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v97 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x94 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let v98 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x95 as i64), _mm512_loadu_si512(m.add(1032).cast()));
        let v99 = _mm512_xor_si512(v96, v97);
        let v100 = _mm512_xor_si512(v98, v99);
        let x101 = x93 ^ x94;
        let v102 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x93 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let v103 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x94 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v104 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x101 as i64), _mm512_loadu_si512(m.add(1024).cast()));
        let v105 = _mm512_xor_si512(v102, v103);
        let v106 = _mm512_xor_si512(v104, v105);
        let x107 = x93 ^ x94;
        let v108 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x93 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v109 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x94 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let v110 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x107 as i64), _mm512_loadu_si512(m.add(1072).cast()));
        let v111 = _mm512_xor_si512(v108, v109);
        let v112 = _mm512_xor_si512(v110, v111);
        let x113 = x93 ^ x94;
        let v114 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x93 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let v115 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x94 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v116 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x113 as i64), _mm512_loadu_si512(m.add(1064).cast()));
        let v117 = _mm512_xor_si512(v114, v115);
        let v118 = _mm512_xor_si512(v116, v117);
        [v99, v100, v105, v106, v111, v112, v117, v118]
    }
}

// Sparse XOR convolution: mode 11, 18 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_11(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x119 = !*p.add(0);
        let x120 = !*p.add(1);
        let x121 = !*p.add(2);
        let x122 = !*p.add(3);
        let x123 = x119 ^ x121;
        let x124 = x120 ^ x122;
        let x125 = x119 ^ x120;
        let v126 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x119 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let v127 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x120 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v128 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x125 as i64), _mm512_loadu_si512(m.add(1064).cast()));
        let v129 = _mm512_xor_si512(v126, v127);
        let v130 = _mm512_xor_si512(v128, v129);
        let x131 = x121 ^ x122;
        let v132 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x121 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v133 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x122 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let v134 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x131 as i64), _mm512_loadu_si512(m.add(1072).cast()));
        let v135 = _mm512_xor_si512(v132, v133);
        let v136 = _mm512_xor_si512(v134, v135);
        let x137 = x123 ^ x124;
        let v138 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x123 as i64), _mm512_loadu_si512(m.add(1080).cast()));
        let v139 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x124 as i64), _mm512_loadu_si512(m.add(1088).cast()));
        let v140 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x137 as i64), _mm512_loadu_si512(m.add(1096).cast()));
        let v141 = _mm512_xor_si512(v138, v139);
        let v142 = _mm512_xor_si512(v140, v141);
        let v143 = _mm512_xor_si512(v129, v135);
        let v144 = _mm512_xor_si512(v130, v136);
        let v145 = _mm512_xor_si512(v141, v143);
        let v146 = _mm512_xor_si512(v142, v144);
        let x147 = x119 ^ x121;
        let x148 = x120 ^ x122;
        let x149 = x119 ^ x120;
        let v150 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x119 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let v151 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x120 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v152 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x149 as i64), _mm512_loadu_si512(m.add(1024).cast()));
        let v153 = _mm512_xor_si512(v150, v151);
        let v154 = _mm512_xor_si512(v152, v153);
        let x155 = x121 ^ x122;
        let v156 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x121 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v157 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x122 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let v158 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x155 as i64), _mm512_loadu_si512(m.add(1032).cast()));
        let v159 = _mm512_xor_si512(v156, v157);
        let v160 = _mm512_xor_si512(v158, v159);
        let x161 = x147 ^ x148;
        let v162 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x147 as i64), _mm512_loadu_si512(m.add(1040).cast()));
        let v163 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x148 as i64), _mm512_loadu_si512(m.add(1048).cast()));
        let v164 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x161 as i64), _mm512_loadu_si512(m.add(1056).cast()));
        let v165 = _mm512_xor_si512(v162, v163);
        let v166 = _mm512_xor_si512(v164, v165);
        let v167 = _mm512_xor_si512(v153, v159);
        let v168 = _mm512_xor_si512(v154, v160);
        let v169 = _mm512_xor_si512(v165, v167);
        let v170 = _mm512_xor_si512(v166, v168);
        [v143, v144, v145, v146, v167, v168, v169, v170]
    }
}

// Sparse XOR convolution: mode 12, 16 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_12(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x171 = !*p.add(0);
        let x172 = !*p.add(1);
        let x173 = !*p.add(2);
        let x174 = x171 ^ x173;
        let x175 = x171 ^ x172;
        let v176 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x171 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let v177 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x172 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v178 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x175 as i64), _mm512_loadu_si512(m.add(1064).cast()));
        let v179 = _mm512_xor_si512(v176, v177);
        let v180 = _mm512_xor_si512(v178, v179);
        let v181 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x173 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v182 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x173 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let x183 = x174 ^ x172;
        let v184 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x174 as i64), _mm512_loadu_si512(m.add(1080).cast()));
        let v185 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x172 as i64), _mm512_loadu_si512(m.add(1088).cast()));
        let v186 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x183 as i64), _mm512_loadu_si512(m.add(1096).cast()));
        let v187 = _mm512_xor_si512(v184, v185);
        let v188 = _mm512_xor_si512(v186, v187);
        let v189 = _mm512_xor_si512(v179, v181);
        let v190 = _mm512_xor_si512(v180, v182);
        let v191 = _mm512_xor_si512(v187, v189);
        let v192 = _mm512_xor_si512(v188, v190);
        let x193 = x171 ^ x173;
        let x194 = x171 ^ x172;
        let v195 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x171 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let v196 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x172 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v197 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x194 as i64), _mm512_loadu_si512(m.add(1024).cast()));
        let v198 = _mm512_xor_si512(v195, v196);
        let v199 = _mm512_xor_si512(v197, v198);
        let v200 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x173 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v201 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x173 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let x202 = x193 ^ x172;
        let v203 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x193 as i64), _mm512_loadu_si512(m.add(1040).cast()));
        let v204 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x172 as i64), _mm512_loadu_si512(m.add(1048).cast()));
        let v205 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x202 as i64), _mm512_loadu_si512(m.add(1056).cast()));
        let v206 = _mm512_xor_si512(v203, v204);
        let v207 = _mm512_xor_si512(v205, v206);
        let v208 = _mm512_xor_si512(v198, v200);
        let v209 = _mm512_xor_si512(v199, v201);
        let v210 = _mm512_xor_si512(v206, v208);
        let v211 = _mm512_xor_si512(v207, v209);
        [v189, v190, v191, v192, v208, v209, v210, v211]
    }
}

// Sparse XOR convolution: mode 13, 12 GFNI maps.
// Coefficient sums are shared once per witness invocation, not rebuilt per row.
#[inline(always)]
unsafe fn affine_sparse_13(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let x212 = !*p.add(0);
        let x213 = !*p.add(1);
        let x214 = x212 ^ x213;
        let v215 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x212 as i64), _mm512_loadu_si512(m.add(0).cast()));
        let v216 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x213 as i64), _mm512_loadu_si512(m.add(8).cast()));
        let v217 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x214 as i64), _mm512_loadu_si512(m.add(1064).cast()));
        let v218 = _mm512_xor_si512(v215, v216);
        let v219 = _mm512_xor_si512(v217, v218);
        let x220 = x212 ^ x213;
        let v221 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x212 as i64), _mm512_loadu_si512(m.add(16).cast()));
        let v222 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x213 as i64), _mm512_loadu_si512(m.add(24).cast()));
        let v223 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x220 as i64), _mm512_loadu_si512(m.add(1072).cast()));
        let v224 = _mm512_xor_si512(v221, v222);
        let v225 = _mm512_xor_si512(v223, v224);
        let x226 = x212 ^ x213;
        let v227 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x212 as i64), _mm512_loadu_si512(m.add(32).cast()));
        let v228 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x213 as i64), _mm512_loadu_si512(m.add(40).cast()));
        let v229 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x226 as i64), _mm512_loadu_si512(m.add(1024).cast()));
        let v230 = _mm512_xor_si512(v227, v228);
        let v231 = _mm512_xor_si512(v229, v230);
        let x232 = x212 ^ x213;
        let v233 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x212 as i64), _mm512_loadu_si512(m.add(48).cast()));
        let v234 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x213 as i64), _mm512_loadu_si512(m.add(56).cast()));
        let v235 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(x232 as i64), _mm512_loadu_si512(m.add(1032).cast()));
        let v236 = _mm512_xor_si512(v233, v234);
        let v237 = _mm512_xor_si512(v235, v236);
        [v218, v219, v224, v225, v230, v231, v236, v237]
    }
}

#[inline(always)]
unsafe fn affine_conv(p: *const u64, m: *const u64, mode_value: u8) -> [__m512i; 8] {
    unsafe {
        // A contiguous half-width complement can use a smaller XOR convolution.
        // Keep dense and one-live-byte maps on their retained implementations.
        match mode_value {
            4 => return affine_sparse_4(p, m),
            5 => return affine_sparse_5(p, m),
            6 => return affine_sparse_6(p, m),
            11 => return affine_sparse_11(p, m),
            12 => return affine_sparse_12(p, m),
            13 => return affine_sparse_13(p, m),
            _ => {}
        }
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

// Share the expensive arithmetic by structural row mode. The eight Horner
// weights remain selected by the caller's matrix-bank pointer.
#[inline(never)]
unsafe fn row_product<const MODE: u8, const FIRST: bool>(
    ap: *const u64, bp: *const u64, ma: *const u64, mb: *const u64,
    acc: &mut [__m512i; 8],
) {
    unsafe {
        let av = affine_conv(ap, ma, 0);
        let bv = affine_conv(bp, mb, MODE);
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
    fn sparse140_all_basis_maps_match_retained_direct() {
        unsafe {
            let mut cases = 0;
            for beta in [64, 128, 192] {
                let ns = AdditiveNttGf8::new(6, F8::ZERO);
                let nl = AdditiveNttGf8::new(6, F8(beta));
                let table = InvNttTableByteSingleGf8::new(&ns, &nl);
                let tables = Tables::new(&table);
                for mode in [4, 5, 6, 11, 12, 13] {
                    // Every input bit, with all other residual bits zero.
                    // Include all-zero residual and dense deterministic controls.
                    for bit in 0..514 {
                        let mut input = [u64::MAX; 8];
                        if bit < 512 { input[bit / 64] ^= 1u64 << (bit % 64); }
                        if bit == 513 { input = [0x1379_bdf0_2468_ace5; 8]; }
                        for i in 0..8 { if known(mode) & (1 << i) != 0 { input[i] = u64::MAX; } }
                        let actual = affine_conv(input.as_ptr(), tables.0.as_ptr(), mode);
                        let expected = affine(input.as_ptr(), tables.0.as_ptr(), mode);
                        let actual: [[u8; 64]; 8] = core::mem::transmute(actual);
                        let expected: [[u8; 64]; 8] = core::mem::transmute(expected);
                        assert_eq!(actual, expected, "beta={beta} mode={mode} bit={bit}");
                        cases += 1;
                    }
                }
            }
            assert_eq!(cases, 9252);
            println!("PASS 9252 sparse-mode basis and control maps match retained direct GFNI reference across three domain offsets");
        }
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
