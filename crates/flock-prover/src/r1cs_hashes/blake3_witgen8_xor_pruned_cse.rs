//! Shared-XOR recombination for the pruned complement convolutions.
//!
//! `affine_conv_pruned::<MODE>` keeps the same GFNI products for every mode
//! that `prune_wins` selects, but adds each product into its own subset
//! accumulator and then applies the 12-XOR superset transform. Output `j`
//! (before the `tau` translation) is the XOR of every product `(i, d)` with
//! `(i | d) ⊇ j`, so outputs share many partial sums. The bodies below form
//! exactly those sums with shared two- and three-input XORs (generated per
//! mode and checked symbolically against the incumbent accumulation). The
//! input loading, superset transform of the scalars, matrix operands, GFNI
//! products and output translation are the incumbent's.
use super::*;

#[inline(always)]
pub(super) unsafe fn affine_pruned_cse<const MODE: u8>(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        match MODE {
            1 => mode1(p, m),
            2 => mode2(p, m),
            3 => mode3(p, m),
            4 => mode4(p, m),
            5 => mode5(p, m),
            6 => mode6(p, m),
            8 => mode8(p, m),
            9 => mode9(p, m),
            10 => mode10(p, m),
            11 => mode11(p, m),
            12 => mode12(p, m),
            13 => mode13(p, m),
            _ => super::affine_conv_pruned::<MODE>(p, m),
        }
    }
}

// MODE 1: known bytes 0b00000001, tau 7, 26 products, 19 XOR ops.
#[inline(always)]
unsafe fn mode1(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(7);
        y[1] = !*p.add(6);
        y[2] = !*p.add(5);
        y[3] = !*p.add(4);
        y[4] = !*p.add(3);
        y[5] = !*p.add(2);
        y[6] = !*p.add(1);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[6] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p22 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p23 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p24 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p25 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[6] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p19, p20, p21);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p22, p23, p24);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p25, t0, t1);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p8, t2, t3);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t6 = _mm512_xor_si512(p14, t5);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p15, p16, p17);
        let t8 = _mm512_xor_si512(p18, t7);
        let t9 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t4);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t8);
        let t11 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t6);
        let t12 = _mm512_xor_si512(t2, t8);
        let t13 = _mm512_ternarylogic_epi64::<0x96>(p0, t9, t10);
        let t14 = _mm512_xor_si512(t11, t13);
        let t15 = _mm512_xor_si512(t6, t9);
        let t16 = _mm512_xor_si512(t4, t10);
        let t17 = _mm512_xor_si512(t11, t12);
        let t18 = _mm512_xor_si512(t2, t6);
        [t2, t12, t18, t17, t4, t16, t15, t14]
    }
}

// MODE 2: known bytes 0b00000011, tau 6, 24 products, 18 XOR ops.
#[inline(always)]
unsafe fn mode2(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(6);
        y[1] = !*p.add(7);
        y[2] = !*p.add(4);
        y[3] = !*p.add(5);
        y[4] = !*p.add(2);
        y[5] = !*p.add(3);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p22 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p23 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p18, p19, p20);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p21, p22, p23);
        let t2 = _mm512_xor_si512(t0, t1);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p8, t2, t3);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t6 = _mm512_xor_si512(p14, t5);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p15, p16, p17);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t4);
        let t9 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t7);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t6);
        let t11 = _mm512_xor_si512(t2, t7);
        let t12 = _mm512_ternarylogic_epi64::<0x96>(p0, t8, t9);
        let t13 = _mm512_xor_si512(t10, t12);
        let t14 = _mm512_xor_si512(t6, t8);
        let t15 = _mm512_xor_si512(t4, t9);
        let t16 = _mm512_xor_si512(t10, t11);
        let t17 = _mm512_xor_si512(t2, t6);
        [t11, t2, t16, t17, t15, t4, t13, t14]
    }
}

// MODE 3: known bytes 0b00000111, tau 7, 22 products, 16 XOR ops.
#[inline(always)]
unsafe fn mode3(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(7);
        y[1] = !*p.add(6);
        y[2] = !*p.add(5);
        y[3] = !*p.add(4);
        y[4] = !*p.add(3);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p17, p18, p19);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p20, p21, t0);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p8, t1, t2);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p14, p15, p16);
        let t6 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t3);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t5);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t4);
        let t9 = _mm512_xor_si512(t1, t5);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p0, t6, t7);
        let t11 = _mm512_xor_si512(t8, t10);
        let t12 = _mm512_xor_si512(t4, t6);
        let t13 = _mm512_xor_si512(t3, t7);
        let t14 = _mm512_xor_si512(t8, t9);
        let t15 = _mm512_xor_si512(t1, t4);
        [t1, t9, t15, t14, t3, t13, t12, t11]
    }
}

// MODE 4: known bytes 0b00001111, tau 4, 18 products, 16 XOR ops.
#[inline(always)]
unsafe fn mode4(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(4);
        y[1] = !*p.add(5);
        y[2] = !*p.add(6);
        y[3] = !*p.add(7);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p14, p15, p16);
        let t1 = _mm512_xor_si512(p17, t0);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p8, t1, t2);
        let t4 = _mm512_xor_si512(p10, p11);
        let t5 = _mm512_xor_si512(p12, p13);
        let t6 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t3);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t5);
        let t8 = _mm512_xor_si512(p9, t4);
        let t9 = _mm512_xor_si512(t1, t5);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p0, t6, t7);
        let t11 = _mm512_xor_si512(t8, t10);
        let t12 = _mm512_xor_si512(t4, t6);
        let t13 = _mm512_xor_si512(t3, t7);
        let t14 = _mm512_xor_si512(t8, t9);
        let t15 = _mm512_xor_si512(t1, t4);
        [t14, t15, t9, t1, t11, t12, t13, t3]
    }
}

// MODE 5: known bytes 0b00011111, tau 7, 16 products, 14 XOR ops.
#[inline(always)]
unsafe fn mode5(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(7);
        y[1] = !*p.add(6);
        y[2] = !*p.add(5);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p13, p14, p15);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t0);
        let t3 = _mm512_xor_si512(p11, p12);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t1);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t3);
        let t6 = _mm512_xor_si512(p8, t2);
        let t7 = _mm512_xor_si512(t0, t1);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p0, t4, t5);
        let t9 = _mm512_xor_si512(t6, t8);
        let t10 = _mm512_xor_si512(t2, t4);
        let t11 = _mm512_xor_si512(t5, t7);
        let t12 = _mm512_xor_si512(t3, t6);
        let t13 = _mm512_xor_si512(t0, t3);
        [t0, t13, t2, t12, t7, t11, t10, t9]
    }
}

// MODE 6: known bytes 0b00111111, tau 6, 12 products, 13 XOR ops.
#[inline(always)]
unsafe fn mode6(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(6);
        y[1] = !*p.add(7);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let t0 = _mm512_xor_si512(p10, p11);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p4, p5, t0);
        let t2 = _mm512_xor_si512(p7, p8);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t1);
        let t4 = _mm512_xor_si512(p3, p9);
        let t5 = _mm512_xor_si512(p6, t2);
        let t6 = _mm512_xor_si512(p9, t0);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p0, t3, t4);
        let t8 = _mm512_xor_si512(t5, t7);
        let t9 = _mm512_xor_si512(t2, t3);
        let t10 = _mm512_xor_si512(t1, t4);
        let t11 = _mm512_xor_si512(t5, t6);
        let t12 = _mm512_xor_si512(t0, t2);
        [t6, t0, t11, t12, t10, t1, t8, t9]
    }
}

// MODE 8: known bytes 0b10000000, tau 0, 26 products, 19 XOR ops.
#[inline(always)]
unsafe fn mode8(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[2] = !*p.add(2);
        y[3] = !*p.add(3);
        y[4] = !*p.add(4);
        y[5] = !*p.add(5);
        y[6] = !*p.add(6);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[6] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p22 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p23 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p24 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p25 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[6] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p19, p20, p21);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p22, p23, p24);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p25, t0, t1);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p8, t2, t3);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t6 = _mm512_xor_si512(p14, t5);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p15, p16, p17);
        let t8 = _mm512_xor_si512(p18, t7);
        let t9 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t4);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t8);
        let t11 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t6);
        let t12 = _mm512_xor_si512(t2, t8);
        let t13 = _mm512_ternarylogic_epi64::<0x96>(p0, t9, t10);
        let t14 = _mm512_xor_si512(t11, t13);
        let t15 = _mm512_xor_si512(t6, t9);
        let t16 = _mm512_xor_si512(t4, t10);
        let t17 = _mm512_xor_si512(t11, t12);
        let t18 = _mm512_xor_si512(t2, t6);
        [t14, t15, t16, t4, t17, t18, t12, t2]
    }
}

// MODE 9: known bytes 0b11000000, tau 0, 24 products, 18 XOR ops.
#[inline(always)]
unsafe fn mode9(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[2] = !*p.add(2);
        y[3] = !*p.add(3);
        y[4] = !*p.add(4);
        y[5] = !*p.add(5);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p22 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p23 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[5] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p18, p19, p20);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p21, p22, p23);
        let t2 = _mm512_xor_si512(t0, t1);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p8, t2, t3);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t6 = _mm512_xor_si512(p14, t5);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p15, p16, p17);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t4);
        let t9 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t7);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t6);
        let t11 = _mm512_xor_si512(t2, t7);
        let t12 = _mm512_ternarylogic_epi64::<0x96>(p0, t8, t9);
        let t13 = _mm512_xor_si512(t10, t12);
        let t14 = _mm512_xor_si512(t6, t8);
        let t15 = _mm512_xor_si512(t4, t9);
        let t16 = _mm512_xor_si512(t10, t11);
        let t17 = _mm512_xor_si512(t2, t6);
        [t13, t14, t15, t4, t16, t17, t11, t2]
    }
}

// MODE 10: known bytes 0b11100000, tau 0, 22 products, 16 XOR ops.
#[inline(always)]
unsafe fn mode10(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[2] = !*p.add(2);
        y[3] = !*p.add(3);
        y[4] = !*p.add(4);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p18 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p19 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p20 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p21 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[4] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p17, p18, p19);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p20, p21, t0);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p8, t1, t2);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p11, p12, p13);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p14, p15, p16);
        let t6 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t3);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t5);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t4);
        let t9 = _mm512_xor_si512(t1, t5);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p0, t6, t7);
        let t11 = _mm512_xor_si512(t8, t10);
        let t12 = _mm512_xor_si512(t4, t6);
        let t13 = _mm512_xor_si512(t3, t7);
        let t14 = _mm512_xor_si512(t8, t9);
        let t15 = _mm512_xor_si512(t1, t4);
        [t11, t12, t13, t3, t14, t15, t9, t1]
    }
}

// MODE 11: known bytes 0b11110000, tau 0, 18 products, 16 XOR ops.
#[inline(always)]
unsafe fn mode11(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[2] = !*p.add(2);
        y[3] = !*p.add(3);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p16 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p17 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[3] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p14, p15, p16);
        let t1 = _mm512_xor_si512(p17, t0);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p8, t1, t2);
        let t4 = _mm512_xor_si512(p10, p11);
        let t5 = _mm512_xor_si512(p12, p13);
        let t6 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t3);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t5);
        let t8 = _mm512_xor_si512(p9, t4);
        let t9 = _mm512_xor_si512(t1, t5);
        let t10 = _mm512_ternarylogic_epi64::<0x96>(p0, t6, t7);
        let t11 = _mm512_xor_si512(t8, t10);
        let t12 = _mm512_xor_si512(t4, t6);
        let t13 = _mm512_xor_si512(t3, t7);
        let t14 = _mm512_xor_si512(t8, t9);
        let t15 = _mm512_xor_si512(t1, t4);
        [t11, t12, t13, t3, t14, t15, t9, t1]
    }
}

// MODE 12: known bytes 0b11111000, tau 0, 16 products, 14 XOR ops.
#[inline(always)]
unsafe fn mode12(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[2] = !*p.add(2);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p12 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p13 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p14 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p15 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[2] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let t0 = _mm512_ternarylogic_epi64::<0x96>(p13, p14, p15);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p5, p6, p7);
        let t2 = _mm512_ternarylogic_epi64::<0x96>(p9, p10, t0);
        let t3 = _mm512_xor_si512(p11, p12);
        let t4 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t1);
        let t5 = _mm512_ternarylogic_epi64::<0x96>(p3, p4, t3);
        let t6 = _mm512_xor_si512(p8, t2);
        let t7 = _mm512_xor_si512(t0, t1);
        let t8 = _mm512_ternarylogic_epi64::<0x96>(p0, t4, t5);
        let t9 = _mm512_xor_si512(t6, t8);
        let t10 = _mm512_xor_si512(t2, t4);
        let t11 = _mm512_xor_si512(t5, t7);
        let t12 = _mm512_xor_si512(t3, t6);
        let t13 = _mm512_xor_si512(t0, t3);
        [t9, t10, t11, t7, t12, t2, t13, t0]
    }
}

// MODE 13: known bytes 0b11111100, tau 0, 12 products, 13 XOR ops.
#[inline(always)]
unsafe fn mode13(p: *const u64, m: *const u64) -> [__m512i; 8] {
    unsafe {
        let mut y = [0u64; 8];
        y[0] = !*p.add(0);
        y[1] = !*p.add(1);
        y[0] ^= y[1]; y[2] ^= y[3]; y[4] ^= y[5]; y[6] ^= y[7];
        y[0] ^= y[2]; y[1] ^= y[3]; y[4] ^= y[6]; y[5] ^= y[7];
        y[0] ^= y[4]; y[1] ^= y[5]; y[2] ^= y[6]; y[3] ^= y[7];
        let p0 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p1 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(72).cast()));
        let p2 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(64).cast()));
        let p3 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p4 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(88).cast()));
        let p5 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(80).cast()));
        let p6 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p7 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(104).cast()));
        let p8 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(96).cast()));
        let p9 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let p10 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[0] as i64), _mm512_loadu_si512(m.add(120).cast()));
        let p11 = _mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(y[1] as i64), _mm512_loadu_si512(m.add(112).cast()));
        let t0 = _mm512_xor_si512(p10, p11);
        let t1 = _mm512_ternarylogic_epi64::<0x96>(p4, p5, t0);
        let t2 = _mm512_xor_si512(p7, p8);
        let t3 = _mm512_ternarylogic_epi64::<0x96>(p1, p2, t1);
        let t4 = _mm512_xor_si512(p3, p9);
        let t5 = _mm512_xor_si512(p6, t2);
        let t6 = _mm512_xor_si512(p9, t0);
        let t7 = _mm512_ternarylogic_epi64::<0x96>(p0, t3, t4);
        let t8 = _mm512_xor_si512(t5, t7);
        let t9 = _mm512_xor_si512(t2, t3);
        let t10 = _mm512_xor_si512(t1, t4);
        let t11 = _mm512_xor_si512(t5, t6);
        let t12 = _mm512_xor_si512(t0, t2);
        [t8, t9, t10, t1, t11, t12, t6, t0]
    }
}
