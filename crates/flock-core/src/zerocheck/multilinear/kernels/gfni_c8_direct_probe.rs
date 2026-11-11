use super::*;
use core::arch::x86_64::*;
use crate::field::gf2_128::x86_64::{ghash_broadcast_split,ghash_mul_x4_split};
core::arch::global_asm!(include_str!("gfni_c8_direct_register_result.S"));
unsafe extern "C"{fn flock_gfni_c8_direct_register_result();}
#[repr(C,align(64))]
struct Mats8([[u64;8];128]);
#[inline(always)]
unsafe fn direct(rows:*const u8,m:&Mats8)->[__m512i;4]{unsafe{
 let(a,b,c,d):(__m512i,__m512i,__m512i,__m512i);
 core::arch::asm!("call {kernel}",kernel=sym flock_gfni_c8_direct_register_result,in("rdi") rows,in("rsi") m.0.as_ptr(),lateout("rax") _,
 out("zmm0") _,out("zmm1") _,out("zmm2") _,out("zmm3") _,out("zmm4") _,out("zmm5") _,out("zmm6") _,out("zmm7") _,out("zmm8") a,out("zmm9") b,out("zmm10") c,out("zmm11") d);
 [a,b,c,d]
}}
#[inline(always)]
unsafe fn c4<const PAIR:bool>(rows:*const u8,m:&CFoldMats,r:__m512i,r64:__m512i)->[__m512i;4]{unsafe{
 let [q0,q1,q2,q3,p0,p1,p2,p3]=if PAIR{gfni_fold128_rows_c4_pair_registers(rows,m)}else{
 let[q0,q1,q2,q3]=gfni_fold64_rows_c4_lm_registers(rows,m);let[p0,p1,p2,p3]=gfni_fold64_rows_c4_lm_registers(rows.add(512),m);[q0,q1,q2,q3,p0,p1,p2,p3]};
 let fold=|e:__m512i,o:__m512i|_mm512_xor_si512(e,ghash_mul_x4_split(_mm512_xor_si512(e,o),r,r64));
 let e0=fold(q0,q1);let o0=fold(q2,q3);let e1=fold(p0,p1);let o1=fold(p2,p3);
 [_mm512_shuffle_i64x2::<0x88>(e0,e1),_mm512_shuffle_i64x2::<0x88>(o0,o1),_mm512_shuffle_i64x2::<0xdd>(e0,e1),_mm512_shuffle_i64x2::<0xdd>(o0,o1)]
}}
fn next(s:&mut u64)->u64{*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;*s}
fn matrices(s:&mut u64,r:F128)->(CFoldMats,Mats8){
 let mut f=||F128::new(next(s),next(s));let weights:Vec<_>=(0..64).map(|_|f()).collect();let coeff:[F128;4]=core::array::from_fn(|_|f());let table=crate::zerocheck::multilinear::UniSkipFoldTable::from_weights(8,&weights);
 let m4=build_cfold_mats_ext(&table.data,coeff,false);let right=coeff.map(|c|c*r);let left=core::array::from_fn::<_,4,_>(|i|coeff[i]+right[i]);let coeff8:[F128;8]=core::array::from_fn(|i|if i<4{left[i]}else{right[i-4]});let mut m8=Mats8([[0;8];128]);
 for c in 0..8{let row=build_row_fold_mats_scaled(&table.data,coeff8[c]);for j in 0..8{m8.0[c*8+j].copy_from_slice(&row[j*16..j*16+8]);m8.0[64+c*8+j].copy_from_slice(&row[j*16+8..j*16+16]);}}
 (m4,m8)
}
unsafe fn bytes(v:[__m512i;4])->[u8;256]{unsafe{core::mem::transmute(v)}}
#[test]
fn c8_direct_all_bits_random_challenges_unaligned(){
 let mut seed=0x8e027191ab1;let mut r=F128::new(next(&mut seed),next(&mut seed));let(mut m4,mut m8)=matrices(&mut seed,r);
 for case in 0..8192+256{
  if case>=8192{r=match case%8{0=>F128::ZERO,1=>F128::ONE,2=>F128::new(0,1<<63),_=>F128::new(next(&mut seed),next(&mut seed))};(m4,m8)=matrices(&mut seed,r);}
  let offset=[0,1,7,31,63][case%5];let mut input=vec![0xa5;offset+1024+64];let d=&mut input[offset..offset+1024];d.fill(0);if case<8192{d[case/8]=1<<(case%8)}else{for b in d{*b=next(&mut seed) as u8;}}
  let original=input.clone();unsafe{let(rb,r64)=ghash_broadcast_split(r);let p=input.as_ptr().add(offset);assert_eq!(bytes(direct(p,&m8)),bytes(c4::<false>(p,&m4,rb,r64)),"case={case}");assert_eq!(bytes(direct(p,&m8)),bytes(c4::<true>(p,&m4,rb,r64)),"paired case={case}");}assert_eq!(input,original);
 }
 println!("8192 input basis cases and256 random challenges/matrices/inputs, including zero/one/high-bit challenges; unaligned inputs and unchanged guards match C4+rho3");
}
#[test]
#[ignore]
fn c8_direct_component_16_workers(){
 use std::sync::{Arc,Barrier};use std::time::Instant;let barrier=Arc::new(Barrier::new(16));
 let handles:Vec<_>=(0..16).map(|worker|{let barrier=barrier.clone();std::thread::spawn(move||{
  unsafe{let mut mask=[0u64;16];mask[worker/64]|=1<<(worker%64);unsafe extern "C"{fn sched_setaffinity(pid:i32,len:usize,mask:*const u64)->i32;}assert_eq!(sched_setaffinity(0,128,mask.as_ptr()),0);}
  let mut seed=0x991ab753+worker as u64;let rho=F128::new(next(&mut seed),next(&mut seed));let(m4,m8)=matrices(&mut seed,rho);let data:Vec<u8>=(0..262144).map(|_|next(&mut seed) as u8).collect();let(r,r64)=unsafe{ghash_broadcast_split(rho)};let mut times=vec![[0f64;3];24];
  for i in 0..256{unsafe{let p=data.as_ptr().add(i*1024);assert_eq!(bytes(direct(p,&m8)),bytes(c4::<false>(p,&m4,r,r64)));}}
  for round in 0..24{for turn in 0..3{let arm=(round+turn)%3;barrier.wait();let start=Instant::now();
   for i in 0..20001{unsafe{let p=data.as_ptr().add((i&255)*1024);let out=match arm{0=>c4::<false>(p,&m4,r,r64),1=>c4::<true>(p,&m4,r,r64),_=>direct(p,&m8)};std::hint::black_box(out);}}
   times[round][arm]=start.elapsed().as_secs_f64()*1000.;barrier.wait();
  }}times
 })}).collect();let results:Vec<_>=handles.into_iter().map(|h|h.join().unwrap()).collect();
 for round in 0..24{let t:[f64;3]=core::array::from_fn(|arm|results.iter().map(|r|r[round][arm]).fold(0f64,f64::max));println!("C8_DIRECT round={round} old_ms={:.6} pair_ms={:.6} direct_ms={:.6} pair_ratio={:.6} direct_ratio={:.6}",t[0],t[1],t[2],t[1]/t[0],t[2]/t[0]);}
}


unsafe extern "C"{fn flock_gfni_c8_ab_register_result();}
#[inline(always)]
unsafe fn ab(a:*const u8,b:*const u8,m:&Mats8)->[__m512i;8]{unsafe{
 let(v0,v1,v2,v3,v4,v5,v6,v7):(__m512i,__m512i,__m512i,__m512i,__m512i,__m512i,__m512i,__m512i);
 core::arch::asm!("call {kernel}",kernel=sym flock_gfni_c8_ab_register_result,in("rdi") a,in("rdx") b,in("rsi") m.0.as_ptr(),lateout("rax") _,
 out("zmm0") _,out("zmm1") _,out("zmm2") _,out("zmm3") _,out("zmm4") _,out("zmm5") _,out("zmm6") _,out("zmm7") _,out("zmm8") v0,out("zmm9") v1,out("zmm10") v2,out("zmm11") v3,out("zmm12") v4,out("zmm13") v5,out("zmm14") v6,out("zmm15") v7);
 [v0,v1,v2,v3,v4,v5,v6,v7]
}}
#[test]
fn c8_ab_all_input_bits_random_unaligned(){
 let mut seed=0x761bc37;let mut rho=F128::new(next(&mut seed),next(&mut seed));let(mut m4,mut m8)=matrices(&mut seed,rho);
 for case in 0..16384+256{
  if case>=16384{rho=match case%4{0=>F128::ZERO,1=>F128::ONE,_=>F128::new(next(&mut seed),next(&mut seed))};(m4,m8)=matrices(&mut seed,rho);}
  let ao=[0,1,7,31,63][case%5];let bo=[63,31,7,1,0][(case/5)%5];let mut a=vec![0xa5;ao+1024+64];let mut b=vec![0x5a;bo+1024+64];a[ao..ao+1024].fill(0);b[bo..bo+1024].fill(0);
  if case<16384{if case<8192{a[ao+case/8]=1<<(case%8)}else{b[bo+(case-8192)/8]=1<<(case%8)}}else{for byte in a[ao..ao+1024].iter_mut().chain(b[bo..bo+1024].iter_mut()){*byte=next(&mut seed) as u8;}}
  let originals=(a.clone(),b.clone());unsafe{let ap=a.as_ptr().add(ao);let bp=b.as_ptr().add(bo);let(rb,r64)=ghash_broadcast_split(rho);let out=ab(ap,bp,&m8);let want_a=c4::<false>(ap,&m4,rb,r64);let want_b=c4::<false>(bp,&m4,rb,r64);assert_eq!(bytes(out[..4].try_into().unwrap()),bytes(want_a),"Acase={case}");assert_eq!(bytes(out[4..].try_into().unwrap()),bytes(want_b),"Bcase={case}");}assert_eq!((a,b),originals);
 }
 println!("16384 A/B basis cases and256 random matrices/challenges/inputs,25alignment combinations,complete512Boutputs and unchangedsourceguards match");
}
#[test]
#[ignore]
fn c8_ab_component_16_workers(){
 use std::sync::{Arc,Barrier};use std::time::Instant;let barrier=Arc::new(Barrier::new(16));
 let handles:Vec<_>=(0..16).map(|worker|{let barrier=barrier.clone();std::thread::spawn(move||{
  unsafe{let mut mask=[0u64;16];mask[worker/64]|=1<<(worker%64);unsafe extern "C"{fn sched_setaffinity(pid:i32,len:usize,mask:*const u64)->i32;}assert_eq!(sched_setaffinity(0,128,mask.as_ptr()),0);}
  let mut seed=0x227394d+worker as u64;let rho=F128::new(next(&mut seed),next(&mut seed));let(m4,m8)=matrices(&mut seed,rho);let a:Vec<u8>=(0..262144).map(|_|next(&mut seed) as u8).collect();let b:Vec<u8>=(0..262144).map(|_|next(&mut seed) as u8).collect();let(r,r64)=unsafe{ghash_broadcast_split(rho)};let mut times=vec![[0f64;4];24];
  for round in 0..24{for turn in 0..4{let arm=(round+turn)%4;barrier.wait();let start=Instant::now();
   for i in 0..10001{unsafe{let ap=a.as_ptr().add((i&255)*1024);let bp=b.as_ptr().add((i&255)*1024);let out=if arm==3{ab(ap,bp,&m8)}else{let x=match arm{0=>c4::<false>(ap,&m4,r,r64),1=>c4::<true>(ap,&m4,r,r64),_=>direct(ap,&m8)};let y=match arm{0=>c4::<false>(bp,&m4,r,r64),1=>c4::<true>(bp,&m4,r,r64),_=>direct(bp,&m8)};[x[0],x[1],x[2],x[3],y[0],y[1],y[2],y[3]]};std::hint::black_box(out);}}
   times[round][arm]=start.elapsed().as_secs_f64()*1000.;barrier.wait();
  }}times
 })}).collect();let results:Vec<_>=handles.into_iter().map(|h|h.join().unwrap()).collect();
 for round in 0..24{let t:[f64;4]=core::array::from_fn(|arm|results.iter().map(|r|r[round][arm]).fold(0f64,f64::max));println!("C8_AB round={round} old_ms={:.6} pair_ms={:.6} single_ms={:.6} ab_ms={:.6}",t[0],t[1],t[2],t[3]);}
}
