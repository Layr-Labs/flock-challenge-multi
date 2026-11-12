//! Prepare sparse complement rows before crossing the outlined row seam.
//! Known bytes become zero, unknown bytes are complemented, and a fixed
//! byte permutation applies the pruning translation. The same two GFNI
//! transposes as the dense pack then produce the superset coordinates.
use super::*;
const fn row_index(mode:u8)->[u8;64]{let mut a=[0;64];let mut i=0;let tr=prune_tau(known(mode));while i<64{let lane=i/8;let j=(i%8)^tr;a[i]=(lane*4+(j%4)+(j/4)*32)as u8;i+=1;}a}
const fn unknown(mode:u8)->[u8;64]{let mut a=[0;64];let mut i=0;while i<64{let j=(i%4)+(i/32)*4;a[i]=if known(mode)&(1<<j)==0 {255}else{0};i+=1;}a}

// A's dummy block index also reaches monomorphization before its dead
// branches are eliminated. Keep those compile-time constants in range.
const fn plan_mode(blk:usize,k:usize)->u8 {
    if blk >= 2 && blk <= 29 { mode(blk,k) } else { 0 }
}
#[inline(always)]
pub(super) unsafe fn pack<const BLK:usize, const K:usize>(v:__m512i)->__m512i {
    unsafe { pack_inner(v, const { unknown(plan_mode(BLK,K)) }, const { row_index(plan_mode(BLK,K)) }) }
}
#[inline(always)]
unsafe fn pack_inner(v:__m512i, mask:[u8;64], index:[u8;64])->__m512i {
    unsafe {
        let value=_mm512_andnot_si512(v,_mm512_loadu_si512(mask.as_ptr().cast()));
        let row=_mm512_permutexvar_epi8(_mm512_loadu_si512(index.as_ptr().cast()),value);
        let transpose=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(0x0102040810204080u64 as i64),row);
        let prepared=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(0x0103050f113355ffu64 as i64),transpose);
        _mm512_permutexvar_epi8(_mm512_loadu_si512(BYTE_TR.as_ptr().cast()),prepared)
    }
}
#[cfg(test)]
#[inline(always)]
unsafe fn pack_mode<const MODE:u8>(v:__m512i)->__m512i {
    unsafe { pack_inner(v, const {unknown(MODE)}, const {row_index(MODE)}) }
}

#[cfg(test)]
mod tests { use super::*;
#[test] fn matches_scalar_all_modes(){let mut rng=0x23112c12defu64;for case in 0..1024 {let mut input=[0u8;64];for a in &mut input{rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;*a=rng as u8;}
macro_rules! check{($m:literal)=>{{let mut expected=[0u64;8];for j in 0..8{let raw=j^prune_tau(known($m));if known($m)&(1<<raw)==0{for lane in 0..8{let idx=lane*4+raw%4+(raw/4)*32;expected[j]|=((!input[idx])as u64)<<(lane*8);}}}expected[0]^=expected[1];expected[2]^=expected[3];expected[4]^=expected[5];expected[6]^=expected[7];expected[0]^=expected[2];expected[1]^=expected[3];expected[4]^=expected[6];expected[5]^=expected[7];expected[0]^=expected[4];expected[1]^=expected[5];expected[2]^=expected[6];expected[3]^=expected[7];let actual:[u64;8]=unsafe{std::mem::transmute(pack_mode::<$m>(_mm512_loadu_si512(input.as_ptr().cast())))};assert_eq!(actual,expected,"mode={} case={case}",$m);}};}
check!(1);check!(2);check!(3);check!(4);check!(5);check!(6);check!(8);check!(9);check!(10);check!(11);check!(12);check!(13);
}}

}
