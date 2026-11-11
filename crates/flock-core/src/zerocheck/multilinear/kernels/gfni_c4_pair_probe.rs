use super::*;
use core::arch::x86_64::*;
#[inline(always)]
unsafe fn pair(rows:*const u8,m:&CFoldMats)->[__m512i;8]{unsafe{gfni_fold128_rows_c4_pair_registers(rows,m)}}
#[inline(always)]
unsafe fn old(rows:*const u8,m:&CFoldMats)->[__m512i;8]{unsafe{
 let [a,b,c,d]=gfni_fold64_rows_c4_lm_registers(rows,m);
 let [e,f,g,h]=gfni_fold64_rows_c4_lm_registers(rows.add(512),m);
 [a,b,c,d,e,f,g,h]
}}
fn next(s:&mut u64)->u64{*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;*s}
fn mats(seed:&mut u64)->CFoldMats { CFoldMats([[0;8];128],core::array::from_fn(|_|core::array::from_fn(|_|next(seed)))) }
unsafe fn bytes(v:[__m512i;8])->[u8;512]{unsafe{core::mem::transmute(v)}}
#[test]
fn c4_pair_all_bits_random_unaligned(){
 let mut seed=0x90aa17e15f20345;let mut m=mats(&mut seed);
 for case in 0..(8192+256){
  let offset=[0,1,7,31,63][case%5];let mut input=vec![0xa5;offset+1024+64];let data=&mut input[offset..offset+1024];
  data.fill(0);if case<8192{data[case/8]=1<<(case%8)}else{for b in data{*b=next(&mut seed) as u8;}m=mats(&mut seed);}
  let original=input.clone();unsafe{let ptr=input.as_ptr().add(offset);assert_eq!(bytes(pair(ptr,&m)),bytes(old(ptr,&m)),"case={case}");}
  assert_eq!(input,original);
 }
 println!("8192 input basis vectors and 256 random matrices/inputs match; offsets 0,1,7,31,63 and source guards unchanged");
}
#[test]
#[ignore]
fn c4_pair_component_16_workers(){
 use std::sync::{Arc,Barrier};use std::time::Instant;
 let barrier=Arc::new(Barrier::new(16));
 let handles:Vec<_>=(0..16).map(|worker|{let barrier=barrier.clone();std::thread::spawn(move||{
  unsafe{let mut mask=[0u64;16];mask[worker/64]|=1<<(worker%64);unsafe extern "C"{fn sched_setaffinity(pid:i32,len:usize,mask:*const u64)->i32;}assert_eq!(sched_setaffinity(0,128,mask.as_ptr()),0);}
  let mut seed=0x91f028aa3u64+worker as u64;let m=mats(&mut seed);let data:Vec<u8>=(0..262144).map(|_|next(&mut seed) as u8).collect();
  for i in 0..256 {unsafe{assert_eq!(bytes(pair(data.as_ptr().add(i*1024),&m)),bytes(old(data.as_ptr().add(i*1024),&m)));}}
  let mut times=vec![[0f64;2];24];
  for round in 0..24{for turn in 0..2{let arm=(round+turn)%2;barrier.wait();let start=Instant::now();
   for iteration in 0..20001{unsafe{let ptr=data.as_ptr().add((iteration&255)*1024);let output=if arm==0{old(ptr,&m)}else{pair(ptr,&m)};std::hint::black_box(output);}}
   times[round][arm]=start.elapsed().as_secs_f64()*1000.;barrier.wait();
  }}times
 })}).collect();
 let results:Vec<_>=handles.into_iter().map(|h|h.join().unwrap()).collect();
 for round in 0..24{let old=results.iter().map(|r|r[round][0]).fold(0f64,f64::max);let new=results.iter().map(|r|r[round][1]).fold(0f64,f64::max);println!("CFOLD_PAIR round={round} old_ms={old:.6} new_ms={new:.6} ratio={:.6}",new/old);}
}
