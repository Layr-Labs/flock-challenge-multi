//! Own exact GF(2) rank21 identity found by algebra-preserving local flips.
use super::*;
#[inline(always)]
pub(super) unsafe fn prepare_network(m:*const u64)->[[u64;8];19] {unsafe {
let masks=[67, 4, 81, 17, 20, 191, 3, 23, 13, 22, 6, 97, 2, 1, 128, 75, 111, 7, 16];
core::array::from_fn(|k| core::array::from_fn(|c| {let mut v=0;for i in 0..8 {if masks[k]&(1<<i)!=0 {v^=*m.add(64+i*8+c);}} v}))
}}
#[inline(always)]
pub(super) unsafe fn affine21_network(p:*const u64,m:*const u64)->[__m512i;8] {unsafe {
let x=core::ptr::read_unaligned(p.cast::<[u64;8]>());
let x0=_mm512_set1_epi64(x[0] as i64);
let x1=_mm512_set1_epi64(x[1] as i64);
let x2=_mm512_set1_epi64(x[2] as i64);
let x3=_mm512_set1_epi64(x[3] as i64);
let x4=_mm512_set1_epi64(x[4] as i64);
let x5=_mm512_set1_epi64(x[5] as i64);
let x6=_mm512_set1_epi64(x[6] as i64);
let x7=_mm512_set1_epi64(x[7] as i64);
let v19=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_ternarylogic_epi64::<0x96>(x1,x4,x6),_mm512_loadu_si512(m.add(136).cast()));
let v6=_mm512_gf2p8affine_epi64_epi8::<0>(x4,_mm512_loadu_si512(m.add(48).cast()));
let v15=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_ternarylogic_epi64::<0x96>(x1,x2,x4),_mm512_loadu_si512(m.add(104).cast()));
let v14=_mm512_gf2p8affine_epi64_epi8::<0>(x0,_mm512_loadu_si512(m.add(112).cast()));
let v17=_mm512_gf2p8affine_epi64_epi8::<0>(x7,_mm512_loadu_si512(m.add(104).cast()));
let v1=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_ternarylogic_epi64::<0x96>(x3,x5,x6),_mm512_loadu_si512(m.add(8).cast()));
let v8=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_ternarylogic_epi64::<0x96>(x1,x2,x4),_mm512_loadu_si512(m.add(64).cast()));
let v18=_mm512_gf2p8affine_epi64_epi8::<0>(x1,_mm512_loadu_si512(m.add(128).cast()));
let v21=_mm512_ternarylogic_epi64::<0x96>(v1,v8,v18);
let v22=_mm512_ternarylogic_epi64::<0x96>(v14,v17,v21);
let v23=_mm512_ternarylogic_epi64::<0x96>(v6,v15,v22);
let v0=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_xor_si512(x0,x2),_mm512_loadu_si512(m.add(0).cast()));
let v7=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_ternarylogic_epi64::<0x96>(x1,x2,x3),_mm512_loadu_si512(m.add(56).cast()));
let v13=_mm512_gf2p8affine_epi64_epi8::<0>(x5,_mm512_loadu_si512(m.add(104).cast()));
let v27=_mm512_ternarylogic_epi64::<0x96>(v0,v7,v13);
let v10=_mm512_gf2p8affine_epi64_epi8::<0>(x6,_mm512_loadu_si512(m.add(80).cast()));
let v12=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_xor_si512(x0,x4),_mm512_loadu_si512(m.add(96).cast()));
let v24=_mm512_ternarylogic_epi64::<0x96>(v10,v12,v22);
let v2=_mm512_gf2p8affine_epi64_epi8::<0>(x2,_mm512_loadu_si512(m.add(16).cast()));
let v9=_mm512_gf2p8affine_epi64_epi8::<0>(x3,_mm512_loadu_si512(m.add(72).cast()));
let v28=_mm512_ternarylogic_epi64::<0x96>(v2,v9,v13);
let v11=_mm512_gf2p8affine_epi64_epi8::<0>(x0,_mm512_loadu_si512(m.add(88).cast()));
let v26=_mm512_ternarylogic_epi64::<0x96>(v2,v7,v11);
let v20=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_xor_si512(x0,x1),_mm512_loadu_si512(m.add(144).cast()));
let v29=_mm512_ternarylogic_epi64::<0x96>(v19,v20,v23);
let v3=_mm512_gf2p8affine_epi64_epi8::<0>(x1,_mm512_loadu_si512(m.add(24).cast()));
let v25=_mm512_xor_si512(v0,v9);
let tmp0=_mm512_ternarylogic_epi64::<0x96>(v3,v10,v11);
let v4=_mm512_gf2p8affine_epi64_epi8::<0>(x0,_mm512_loadu_si512(m.add(32).cast()));
let v16=_mm512_gf2p8affine_epi64_epi8::<0>(x0,_mm512_loadu_si512(m.add(120).cast()));
let tmp1=_mm512_ternarylogic_epi64::<0x96>(v4,v16,v28);
let tmp2=_mm512_ternarylogic_epi64::<0x96>(v3,v6,v16);
let v5=_mm512_gf2p8affine_epi64_epi8::<0>(x0,_mm512_loadu_si512(m.add(40).cast()));
let tmp3=_mm512_ternarylogic_epi64::<0x96>(v5,v17,v19);
[_mm512_ternarylogic_epi64::<0x96>(v19,v23,v27),_mm512_ternarylogic_epi64::<0x96>(v6,v24,v28),_mm512_ternarylogic_epi64::<0x96>(v12,v26,v29),_mm512_ternarylogic_epi64::<0x96>(tmp0,v23,v25),_mm512_xor_si512(tmp1,v29),_mm512_ternarylogic_epi64::<0x96>(tmp2,v24,v27),_mm512_ternarylogic_epi64::<0x96>(tmp3,v21,v25),_mm512_ternarylogic_epi64::<0x96>(v16,v24,v26)]
}}
