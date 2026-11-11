//! Scratch-only coordinate-conjugation prototype. Validate before integration.
use super::*;
use flock_core::field::F8;
const fn swap_axes(i:usize)->usize {8*(i&7)+(i>>3)}
#[repr(align(64))]
struct ConjugatedTables([[u64;128];8]);
impl ConjugatedTables {
 fn new(table:&InvNttTableByteSingleGf8)->Self {
  assert_eq!(table.ell,64);
  for i in 0..64 {for t in 0..8 {unsafe {assert_eq!(*table.data_ptr().add((1<<t)*64+i),*table.data_ptr().add(64+(i^t)),"full XOR circulant failed i={i} t={t}");}}}
  let mut banks=[[0u64;128];8];
  for k in 0..8 {for i in 0..64 {for outbit in 0..8 {let mut row=0u8;
   for bit in 0..8 {let c=unsafe{*table.data_ptr().add(64+swap_axes(i^bit^7))};let scaled=F8(c)*F8(1u8<<k);row|=((scaled.0>>outbit)&1)<<bit;}
   banks[k][i]|=(row as u64)<<(8*(7-outbit));
  }}
  for subset in 0..8 {for c in 0..8 {let mut v=0;for t in 0..8 {if t&subset==subset {v^=banks[k][t*8+c];}}banks[k][64+subset*8+c]=v;}}
  }
  Self(banks)
 }
}
#[inline(always)]
unsafe fn conjugated_ring_pack(v:__m512i)->__m512i {unsafe {
 const ROW:[u8;64]=[0,1,2,3,32,33,34,35,4,5,6,7,36,37,38,39,8,9,10,11,40,41,42,43,12,13,14,15,44,45,46,47,16,17,18,19,48,49,50,51,20,21,22,23,52,53,54,55,24,25,26,27,56,57,58,59,28,29,30,31,60,61,62,63];
 let row=_mm512_permutexvar_epi8(_mm512_loadu_si512(ROW.as_ptr().cast()),v);
 let prepared=_mm512_gf2p8affine_epi64_epi8::<0>(_mm512_set1_epi64(0x80c0a0f088ccaaffu64 as i64),row);
 _mm512_permutexvar_epi8(_mm512_loadu_si512(BYTE_TR.as_ptr().cast()),prepared)
}}
#[inline(always)]
unsafe fn direct_byte_transpose(x:[__m512i;8])->[__m512i;8] {unsafe {
 const M00:[u8;64]=[0,64,2,66,4,68,6,70,8,72,10,74,12,76,14,78,16,80,18,82,20,84,22,86,24,88,26,90,28,92,30,94,32,96,34,98,36,100,38,102,40,104,42,106,44,108,46,110,48,112,50,114,52,116,54,118,56,120,58,122,60,124,62,126];
 let m00=_mm512_loadu_si512(M00.as_ptr().cast());
 const M01:[u8;64]=[1,65,3,67,5,69,7,71,9,73,11,75,13,77,15,79,17,81,19,83,21,85,23,87,25,89,27,91,29,93,31,95,33,97,35,99,37,101,39,103,41,105,43,107,45,109,47,111,49,113,51,115,53,117,55,119,57,121,59,123,61,125,63,127];
 let m01=_mm512_loadu_si512(M01.as_ptr().cast());
 let s0_0=_mm512_permutex2var_epi8(x[0],m00,x[1]);
 let s0_1=_mm512_permutex2var_epi8(x[0],m01,x[1]);
 let s0_2=_mm512_permutex2var_epi8(x[2],m00,x[3]);
 let s0_3=_mm512_permutex2var_epi8(x[2],m01,x[3]);
 let s0_4=_mm512_permutex2var_epi8(x[4],m00,x[5]);
 let s0_5=_mm512_permutex2var_epi8(x[4],m01,x[5]);
 let s0_6=_mm512_permutex2var_epi8(x[6],m00,x[7]);
 let s0_7=_mm512_permutex2var_epi8(x[6],m01,x[7]);
 const M10:[u8;64]=[0,1,64,65,4,5,68,69,8,9,72,73,12,13,76,77,16,17,80,81,20,21,84,85,24,25,88,89,28,29,92,93,32,33,96,97,36,37,100,101,40,41,104,105,44,45,108,109,48,49,112,113,52,53,116,117,56,57,120,121,60,61,124,125];
 let m10=_mm512_loadu_si512(M10.as_ptr().cast());
 const M11:[u8;64]=[2,3,66,67,6,7,70,71,10,11,74,75,14,15,78,79,18,19,82,83,22,23,86,87,26,27,90,91,30,31,94,95,34,35,98,99,38,39,102,103,42,43,106,107,46,47,110,111,50,51,114,115,54,55,118,119,58,59,122,123,62,63,126,127];
 let m11=_mm512_loadu_si512(M11.as_ptr().cast());
 let s1_0=_mm512_permutex2var_epi8(s0_0,m10,s0_2);
 let s1_1=_mm512_permutex2var_epi8(s0_1,m10,s0_3);
 let s1_2=_mm512_permutex2var_epi8(s0_0,m11,s0_2);
 let s1_3=_mm512_permutex2var_epi8(s0_1,m11,s0_3);
 let s1_4=_mm512_permutex2var_epi8(s0_4,m10,s0_6);
 let s1_5=_mm512_permutex2var_epi8(s0_5,m10,s0_7);
 let s1_6=_mm512_permutex2var_epi8(s0_4,m11,s0_6);
 let s1_7=_mm512_permutex2var_epi8(s0_5,m11,s0_7);
 const M20:[u8;64]=[0,1,2,3,64,65,66,67,8,9,10,11,72,73,74,75,16,17,18,19,80,81,82,83,24,25,26,27,88,89,90,91,32,33,34,35,96,97,98,99,40,41,42,43,104,105,106,107,48,49,50,51,112,113,114,115,56,57,58,59,120,121,122,123];
 let m20=_mm512_loadu_si512(M20.as_ptr().cast());
 const M21:[u8;64]=[4,5,6,7,68,69,70,71,12,13,14,15,76,77,78,79,20,21,22,23,84,85,86,87,28,29,30,31,92,93,94,95,36,37,38,39,100,101,102,103,44,45,46,47,108,109,110,111,52,53,54,55,116,117,118,119,60,61,62,63,124,125,126,127];
 let m21=_mm512_loadu_si512(M21.as_ptr().cast());
 let s2_0=_mm512_permutex2var_epi8(s1_0,m20,s1_4);
 let s2_1=_mm512_permutex2var_epi8(s1_1,m20,s1_5);
 let s2_2=_mm512_permutex2var_epi8(s1_2,m20,s1_6);
 let s2_3=_mm512_permutex2var_epi8(s1_3,m20,s1_7);
 let s2_4=_mm512_permutex2var_epi8(s1_0,m21,s1_4);
 let s2_5=_mm512_permutex2var_epi8(s1_1,m21,s1_5);
 let s2_6=_mm512_permutex2var_epi8(s1_2,m21,s1_6);
 let s2_7=_mm512_permutex2var_epi8(s1_3,m21,s1_7);
 [s2_0,s2_1,s2_2,s2_3,s2_4,s2_5,s2_6,s2_7]
}}

#[inline(always)]
unsafe fn original_output(x:[__m512i;8])->[__m512i;8] {unsafe {
 let ix=_mm512_loadu_si512(BYTE_TR.as_ptr().cast());trq(x.map(|v|_mm512_permutexvar_epi8(ix,v)))
}}
fn next(seed:&mut u64)->u64 {*seed^=*seed<<13;*seed^=*seed>>7;*seed^=*seed<<17;*seed}
#[test]
fn coordinate_pack_scalar_permutation_and_output_oracles() {unsafe {
 let mut seed=0x91ca281ef00471a9u64;
 for case in 0..2048 {
  let mut input:[u8;64]=std::array::from_fn(|_|next(&mut seed) as u8);
  if case<512 {input.fill(0);input[case/8]=1<<(case%8);}
  let mut want=[0u8;64];
  for i in 0..8 {for compression in 0..8 {for bit in 0..8 {if bit&i==i {for j in 0..8 {
   want[8*i+compression]^=((input[32*(j/4)+4*compression+j%4]>>bit)&1)<<(7-j);
  }}}}}
  let mut got=[0u8;64];_mm512_storeu_si512(got.as_mut_ptr().cast(),conjugated_ring_pack(_mm512_loadu_si512(input.as_ptr().cast())));assert_eq!(got,want,"pack case={case}");
  let raw:[[u64;8];8]=std::array::from_fn(|_|std::array::from_fn(|_|next(&mut seed)));
  let original:[__m512i;8]=std::array::from_fn(|i|_mm512_loadu_si512(raw[i].as_ptr().cast()));
  let transposed=trq(original);
  let expected:[u8;512]=core::mem::transmute(original_output(original));
  let actual:[u8;512]=core::mem::transmute(direct_byte_transpose(transposed));
  assert_eq!(actual,expected,"outputcase={case}");let shifted:[u8;512]=core::mem::transmute(shift_byte_transpose::<false>(transposed));let blended:[u8;512]=core::mem::transmute(shift_byte_transpose::<true>(transposed));assert_eq!(shifted,expected);assert_eq!(blended,expected);
 }
}}
#[test]
fn conjugated_full_a_projection_matches_original_canonical_bytes() {unsafe {
 let table=flock_core::zerocheck::shared_urm_inv_table();let original=Tables::new(table);let conjugated=ConjugatedTables::new(table);
 let mut seed=0x1a29cf732e61855du64;
 for case in 0..2048 {
  let mut raw=[0u8;64];for byte in &mut raw {*byte=next(&mut seed) as u8;}
  if case<512 {raw.fill(0);raw[case/8]=1<<(case%8);}
  let v=_mm512_loadu_si512(raw.as_ptr().cast());let mut oldp=[0u64;8];let mut newp=oldp;
  _mm512_storeu_si512(oldp.as_mut_ptr().cast(),ring_prepared_pack(v));_mm512_storeu_si512(newp.as_mut_ptr().cast(),conjugated_ring_pack(v));
  for k in 0..8 {
   let old=affine_prepared(oldp.as_ptr(),original.0.as_ptr().add(k*128));
   let new=affine_prepared(newp.as_ptr(),conjugated.0[k].as_ptr());
   let expected:[u8;512]=core::mem::transmute(original_output(old));let actual:[u8;512]=core::mem::transmute(direct_byte_transpose(new));
   assert_eq!(actual,expected,"fullcase={case} bank={k}");let shifted:[u8;512]=core::mem::transmute(shift_byte_transpose::<false>(new));let blended:[u8;512]=core::mem::transmute(shift_byte_transpose::<true>(new));assert_eq!(shifted,expected);assert_eq!(blended,expected);
  }
 }
}}

#[test]
#[ignore="exclusive16worker canonical output shuffle comparison"]
fn conjugated_output_transpose_component() {
 let _=flock_core::init_perf_thread_pool();assert_eq!(rayon::current_num_threads(),16);
 let barrier=std::sync::Barrier::new(16);
 for round in 0..24 {for arm in 0..4 {
  let mode=(round+arm)%4;
  let times=rayon::broadcast(|worker|unsafe {
   let mut seed=0xa9183cd7a812ff1u64+worker.index() as u64;
   let raw:[[u64;8];8]=std::array::from_fn(|_|std::array::from_fn(|_|next(&mut seed)));
   let original:[__m512i;8]=std::array::from_fn(|i|_mm512_loadu_si512(raw[i].as_ptr().cast()));
   let conjugated=trq(original);
   let a:[u8;512]=core::mem::transmute(original_output(original));let b:[u8;512]=core::mem::transmute(direct_byte_transpose(conjugated));assert_eq!(a,b);
   barrier.wait();let start=std::time::Instant::now();
   if mode==0 {for _ in 0..100000 {std::hint::black_box(original_output(std::hint::black_box(original)));}}
   else if mode==1 {for _ in 0..100000 {std::hint::black_box(direct_byte_transpose(std::hint::black_box(conjugated)));}} else if mode==2 {for _ in 0..100000 {std::hint::black_box(shift_byte_transpose::<false>(std::hint::black_box(conjugated)));}}else {for _ in 0..100000 {std::hint::black_box(shift_byte_transpose::<true>(std::hint::black_box(conjugated)));}}
   let ms=start.elapsed().as_secs_f64()*1000.;barrier.wait();ms
  });
  println!("CONJUGATE_OUTPUT_COST round={round} mode={mode} ms={:.6}",times.into_iter().fold(0f64,f64::max));
 }}
}

#[inline(always)]
unsafe fn shift_byte_transpose<const BLEND:bool>(x:[__m512i;8])->[__m512i;8] {unsafe {
let mask0=_mm512_set1_epi64(71777214294589695u64 as i64);
let s0_0=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,_mm512_slli_epi64::<8>(x[1]),x[0])} else {_mm512_ternarylogic_epi64::<0xca>(mask0,x[0],_mm512_slli_epi64::<8>(x[1]))};
let s0_1=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,x[1],_mm512_srli_epi64::<8>(x[0]))} else {_mm512_ternarylogic_epi64::<0xca>(mask0,_mm512_srli_epi64::<8>(x[0]),x[1])};
let s0_2=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,_mm512_slli_epi64::<8>(x[3]),x[2])} else {_mm512_ternarylogic_epi64::<0xca>(mask0,x[2],_mm512_slli_epi64::<8>(x[3]))};
let s0_3=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,x[3],_mm512_srli_epi64::<8>(x[2]))} else {_mm512_ternarylogic_epi64::<0xca>(mask0,_mm512_srli_epi64::<8>(x[2]),x[3])};
let s0_4=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,_mm512_slli_epi64::<8>(x[5]),x[4])} else {_mm512_ternarylogic_epi64::<0xca>(mask0,x[4],_mm512_slli_epi64::<8>(x[5]))};
let s0_5=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,x[5],_mm512_srli_epi64::<8>(x[4]))} else {_mm512_ternarylogic_epi64::<0xca>(mask0,_mm512_srli_epi64::<8>(x[4]),x[5])};
let s0_6=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,_mm512_slli_epi64::<8>(x[7]),x[6])} else {_mm512_ternarylogic_epi64::<0xca>(mask0,x[6],_mm512_slli_epi64::<8>(x[7]))};
let s0_7=if BLEND {_mm512_mask_blend_epi8(6148914691236517205u64,x[7],_mm512_srli_epi64::<8>(x[6]))} else {_mm512_ternarylogic_epi64::<0xca>(mask0,_mm512_srli_epi64::<8>(x[6]),x[7])};
let mask1=_mm512_set1_epi64(281470681808895u64 as i64);
let s1_0=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,_mm512_slli_epi64::<16>(s0_2),s0_0)} else {_mm512_ternarylogic_epi64::<0xca>(mask1,s0_0,_mm512_slli_epi64::<16>(s0_2))};
let s1_2=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,s0_2,_mm512_srli_epi64::<16>(s0_0))} else {_mm512_ternarylogic_epi64::<0xca>(mask1,_mm512_srli_epi64::<16>(s0_0),s0_2)};
let s1_1=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,_mm512_slli_epi64::<16>(s0_3),s0_1)} else {_mm512_ternarylogic_epi64::<0xca>(mask1,s0_1,_mm512_slli_epi64::<16>(s0_3))};
let s1_3=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,s0_3,_mm512_srli_epi64::<16>(s0_1))} else {_mm512_ternarylogic_epi64::<0xca>(mask1,_mm512_srli_epi64::<16>(s0_1),s0_3)};
let s1_4=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,_mm512_slli_epi64::<16>(s0_6),s0_4)} else {_mm512_ternarylogic_epi64::<0xca>(mask1,s0_4,_mm512_slli_epi64::<16>(s0_6))};
let s1_6=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,s0_6,_mm512_srli_epi64::<16>(s0_4))} else {_mm512_ternarylogic_epi64::<0xca>(mask1,_mm512_srli_epi64::<16>(s0_4),s0_6)};
let s1_5=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,_mm512_slli_epi64::<16>(s0_7),s0_5)} else {_mm512_ternarylogic_epi64::<0xca>(mask1,s0_5,_mm512_slli_epi64::<16>(s0_7))};
let s1_7=if BLEND {_mm512_mask_blend_epi8(3689348814741910323u64,s0_7,_mm512_srli_epi64::<16>(s0_5))} else {_mm512_ternarylogic_epi64::<0xca>(mask1,_mm512_srli_epi64::<16>(s0_5),s0_7)};
let mask2=_mm512_set1_epi64(4294967295u64 as i64);
let s2_0=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,_mm512_slli_epi64::<32>(s1_4),s1_0)} else {_mm512_ternarylogic_epi64::<0xca>(mask2,s1_0,_mm512_slli_epi64::<32>(s1_4))};
let s2_4=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,s1_4,_mm512_srli_epi64::<32>(s1_0))} else {_mm512_ternarylogic_epi64::<0xca>(mask2,_mm512_srli_epi64::<32>(s1_0),s1_4)};
let s2_1=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,_mm512_slli_epi64::<32>(s1_5),s1_1)} else {_mm512_ternarylogic_epi64::<0xca>(mask2,s1_1,_mm512_slli_epi64::<32>(s1_5))};
let s2_5=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,s1_5,_mm512_srli_epi64::<32>(s1_1))} else {_mm512_ternarylogic_epi64::<0xca>(mask2,_mm512_srli_epi64::<32>(s1_1),s1_5)};
let s2_2=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,_mm512_slli_epi64::<32>(s1_6),s1_2)} else {_mm512_ternarylogic_epi64::<0xca>(mask2,s1_2,_mm512_slli_epi64::<32>(s1_6))};
let s2_6=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,s1_6,_mm512_srli_epi64::<32>(s1_2))} else {_mm512_ternarylogic_epi64::<0xca>(mask2,_mm512_srli_epi64::<32>(s1_2),s1_6)};
let s2_3=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,_mm512_slli_epi64::<32>(s1_7),s1_3)} else {_mm512_ternarylogic_epi64::<0xca>(mask2,s1_3,_mm512_slli_epi64::<32>(s1_7))};
let s2_7=if BLEND {_mm512_mask_blend_epi8(1085102592571150095u64,s1_7,_mm512_srli_epi64::<32>(s1_3))} else {_mm512_ternarylogic_epi64::<0xca>(mask2,_mm512_srli_epi64::<32>(s1_3),s1_7)};
[s2_0,s2_1,s2_2,s2_3,s2_4,s2_5,s2_6,s2_7] }}
