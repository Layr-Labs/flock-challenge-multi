//! Sixteen-lane arithmetic feeding two existing eight-lane window drains.
use super::*;
type V16=__m512i;
struct Prepared16 {cv:[V16;8],message:[V16;16],counter_lo:V16,counter_hi:V16,block_len:V16,flags:V16}
#[inline(always)] fn dup16(x:u32)->V16 {unsafe{_mm512_set1_epi32(x as i32)}}
#[inline(always)] fn xor16(x:V16,y:V16)->V16 {unsafe{_mm512_xor_si512(x,y)}}
#[inline(always)] fn or16(x:V16,y:V16)->V16 {unsafe{_mm512_or_si512(x,y)}}
#[inline(always)] fn shl16<const N:u32>(x:V16)->V16 {unsafe{_mm512_slli_epi32::<N>(x)}}
#[inline(always)] fn shr16<const N:u32>(x:V16)->V16 {unsafe{_mm512_srli_epi32::<N>(x)}}
#[inline(always)] fn initial16(x:V16)->V16 {shl16::<31>(x)}
#[inline(always)] fn xor_rotr16<const N:i32,const M:i32>(x:V16,y:V16)->V16 {unsafe{_mm512_ror_epi32::<N>(xor16(x,y))}}
#[inline(always)] fn add_carry16(x:V16,y:V16)->(V16,V16,V16) {unsafe{let sum=_mm512_add_epi32(x,y);(sum,xor16(sum,y),xor16(sum,x))}}
#[inline(always)] unsafe fn prepare(init:u64,bases:[usize;2])->Prepared16 {unsafe {
 let a=prepare_closed_inputs_ordered(init,bases[0],true);let b=prepare_closed_inputs_ordered(init,bases[1],true);
 let join=|x:V8,y:V8|_mm512_inserti64x4::<1>(_mm512_castsi256_si512(x),y);
 Prepared16{cv:core::array::from_fn(|i|join(a.cv[i],b.cv[i])),message:core::array::from_fn(|i|join(a.message[i],b.message[i])),counter_lo:join(a.counter_lo,b.counter_lo),counter_hi:join(a.counter_hi,b.counter_hi),block_len:join(a.block_len,b.block_len),flags:join(a.flags,b.flags)}
}}
#[inline(always)] unsafe fn store_split(stage:[*mut V8;2],word:usize,value:V16) {unsafe{
 store_v8(stage[0].add(word).cast(),_mm512_castsi512_si256(value));
 store_v8(stage[1].add(word).cast(),_mm512_extracti64x4_epi64::<1>(value));
}}
#[inline(never)] unsafe fn drain_both<const COLS:usize>(drains:*mut Drain8<'_>,base:usize,ring:usize,words:usize) {unsafe{
 #[cfg(test)] if capture_tests::drain(drains,base,ring,words) {return;}
 for i in 0..2 {(*drains.add(i)).drain_range_gen::<true,COLS>(base,ring,words);}
}}
struct Packed16<'t,const FLUSH:bool,const COLS:usize> {pending:V16,stage:[*mut V8;2],drains:*mut Drain8<'t>}
impl<'t,const FLUSH:bool,const COLS:usize> Packed16<'t,FLUSH,COLS> {
 #[inline(always)] fn at(stage:[*mut V8;2],pending:V16,drains:*mut Drain8<'t>)->Self {Self{stage,pending,drains}}
 #[inline(always)] unsafe fn write_word<const WORD:usize>(&mut self,value:V16) {unsafe {
  if !(FLUSH&&(WORD<RANKED_STATIC_B_PREFIX_END||WORD>=RANKED_STATIC_B_TAIL_START)) {store_split(self.stage,WORD&(RING_WORDS-1),value);}
  if FLUSH&&WORD%RING_WORDS==RING_WORDS-1 {
   if WORD+1==RING_WORDS {drain_both::<COLS>(self.drains,16,16,RING_WORDS-16);}
   else {drain_both::<COLS>(self.drains,WORD+1-RING_WORDS,0,RING_WORDS);}
  }
 }}
 #[inline(always)] unsafe fn push<const USED:i32,const WIDTH:i32,const BACK:i32,const WORD:usize>(&mut self,value:V16) {unsafe{
  const {assert!(USED>=0&&USED<32);assert!(WIDTH==31||WIDTH==32);assert!(WORD<U32_PER_BLOCK);}
  if USED==0 {if WIDTH==32 {self.write_word::<WORD>(value);self.pending=dup16(0);}else{self.pending=shl16::<1>(value);}}
  else {self.write_word::<WORD>(_mm512_shldi_epi32::<USED>(value,self.pending));self.pending=if WIDTH==31 {shl16::<1>(value)}else{value};}
 }}
 #[inline(always)] unsafe fn finish(&mut self) {unsafe{self.write_word::<LAST_WORD>(shr16::<15>(self.pending));}}
}
/// Build two disjoint ranked octas with one sixteen-lane arithmetic stream.
///
/// # Safety
/// The caller supplies the same exact closed-source and ranked-window brand
/// as `build_octa_witness_ab_stream_ranked_window`. Each base must match its
/// projection and seed context, and its mapped cross-quarter z/a/b spans must
/// cover all eight compression lanes. The two contexts own disjoint kpairs,
/// compact tiles, prefixes and staging/output regions for the whole call.
/// Every seed context and immutable table must outlive both drains. The
/// producer retains its normal publication fence before releasing outputs.
#[inline(never)]
pub(in super::super) unsafe fn generate<'a,const COLS:usize>(init:u64,bases:[usize;2],z:[*mut u32;2],a:[*mut u32;2],b:[*mut u32;2],projs:[StreamProj<'a>;2],preps:&'a RankedClosedWindowPreps) {unsafe{
 debug_assert!(matches!(COLS,8|16|32|64));
 let prepared=prepare(init,bases);
 let ranked_static=true;
 let mut astorage=core::mem::MaybeUninit::<[[V8;RING_WORDS];2]>::uninit();
 let mut bstorage=core::mem::MaybeUninit::<[[V8;RING_WORDS];2]>::uninit();
 let ast=[astorage.as_mut_ptr().cast::<V8>(),astorage.as_mut_ptr().cast::<V8>().add(RING_WORDS)];
 let bs=[bstorage.as_mut_ptr().cast::<V8>(),bstorage.as_mut_ptr().cast::<V8>().add(RING_WORDS)];
 let mut index=0;
 let mut drains=projs.map(|proj|{let i=index;index+=1;debug_assert!(proj.elide_z&&proj.cross_quarter);debug_assert_eq!(proj.compact_z_tile_words,COLS*4);Drain8{ast:ast[i],bs:bs[i],z:z[i],a:a[i],b:b[i],proj,elide:[true;3],ranked_static:true,ranked_fast:true,cached_z:false,ranked_preps:Some(preps),roots:None}});
 let drain_ptr=drains.as_mut_ptr();
        let cv_v = &prepared.cv;
        let m = &prepared.message;
        let tlo = prepared.counter_lo;
        let thi = prepared.counter_hi;
        let blen = prepared.block_len;
        let flags = prepared.flags;

        let mut state: [V16; 16] = [
            cv_v[0],
            cv_v[1],
            cv_v[2],
            cv_v[3],
            cv_v[4],
            cv_v[5],
            cv_v[6],
            cv_v[7],
            dup16(BLAKE3_IV[0]),
            dup16(BLAKE3_IV[1]),
            dup16(BLAKE3_IV[2]),
            dup16(BLAKE3_IV[3]),
            tlo,
            thi,
            blen,
            flags,
        ];

        let zero = dup16(0);
        let maxv = dup16(u32::MAX);
        let one = dup16(1);
        let chain: [V16; 20] = [
            m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13],
            m[14], m[15], tlo, thi, blen, flags,
        ];
        // Words 16..35 are available before the rounds. Retain them in the
        // rolling epochs; the writer publishes each epoch when it completes
        // that epoch's last word.
        for k in 0..20usize {
            let v = if k == 0 {
                or16(one, shl16::<1>(chain[0]))
            } else {
                or16(shr16::<31>(chain[k - 1]), shl16::<1>(chain[k]))
            };
            let w = 16 + k;
            store_split(ast,w & (RING_WORDS - 1),v);
        }
        // Unswitch the static-prefix decision once per octa. Ranked blocks
        // 0/1 source B from RANKED_B_MAX; block 2 still needs words 32..35.
        if !ranked_static {
            for w in 16..RANKED_STATIC_B_PREFIX_END {
                store_split(bs,w & (RING_WORDS - 1),maxv);
            }
        }
        for w in RANKED_STATIC_B_PREFIX_END..16 + PROLOGUE_WORDS {
            store_split(bs,w & (RING_WORDS - 1),maxv);
        }

        // The round stream starts at word `PROLOGUE_WORDS + 16`, so a first
        // epoch that ends inside the prologue never reaches the writers'
        // epoch boundary — publish it here instead. Constant-folded away for
        // every ring long enough to reach the round stream.
        if RING_WORDS <= PROLOGUE_WORDS + 16 {
            drain_both::<COLS>(drain_ptr,16, 16, RING_WORDS - 16);
        }

        let pending_bit = initial16(shr16::<31>(flags));
        let mut wa = Packed16::<false,COLS>::at(ast,pending_bit,drain_ptr);
        // B is pushed after A at every site; it alone triggers a band drain
        // once both rings contain the completed word. Z is derived there.
        let mut wb =
            Packed16::<true,COLS>::at(bs,initial16(one),drain_ptr);

        macro_rules! g {
            ($g:expr, $la:literal, $lb:literal, $lc:literal, $ld:literal,
             $mx:literal, $my:literal) => {{
                let (t0, l0, r0) = add_carry16(state[$la], state[$lb]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C0, 31, l0);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C0, 31, r0);
                let (a1, l1, r1) = add_carry16(t0, m[$mx]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C1, 31, l1);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C1, 31, r1);
                let d1 = xor_rotr16::<16, 16>(state[$ld], a1);
                let (c1s, l2, r2) = add_carry16(state[$lc], d1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C2, 31, l2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C2, 31, r2);
                let b1 = xor_rotr16::<12, 20>(state[$lb], c1s);
                let (t1, l3, r3) = add_carry16(a1, b1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C3, 31, l3);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C3, 31, r3);
                let (a2, l4, r4) = add_carry16(t1, m[$my]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C4, 31, l4);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C4, 31, r4);
                let d2 = xor_rotr16::<8, 24>(d1, a2);
                let (c2s, l5, r5) = add_carry16(c1s, d2);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C5, 31, l5);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C5, 31, r5);
                let bn = xor_rotr16::<7, 25>(b1, c2s);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, bn);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, maxv);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, d2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, maxv);
                state[$la] = a2;
                state[$lb] = bn;
                state[$lc] = c2s;
                state[$ld] = d2;
            }};
        }
        macro_rules! round {
            ($gb:literal, $m0:literal, $m1:literal, $m2:literal, $m3:literal,
             $m4:literal, $m5:literal, $m6:literal, $m7:literal,
             $m8:literal, $m9:literal, $m10:literal, $m11:literal,
             $m12:literal, $m13:literal, $m14:literal, $m15:literal) => {{
                g!($gb, 0, 4, 8, 12, $m0, $m1);
                g!($gb + 1, 1, 5, 9, 13, $m2, $m3);
                g!($gb + 2, 2, 6, 10, 14, $m4, $m5);
                g!($gb + 3, 3, 7, 11, 15, $m6, $m7);
                g!($gb + 4, 0, 5, 10, 15, $m8, $m9);
                g!($gb + 5, 1, 6, 11, 12, $m10, $m11);
                g!($gb + 6, 2, 7, 8, 13, $m12, $m13);
                g!($gb + 7, 3, 4, 9, 14, $m14, $m15);
            }};
        }
        round!(0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        round!(8, 2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8);
        round!(16, 3, 4, 10, 12, 13, 2, 7, 14, 6, 5, 9, 0, 11, 15, 8, 1);
        round!(24, 10, 7, 12, 9, 14, 3, 13, 15, 4, 0, 11, 2, 5, 8, 1, 6);
        round!(32, 12, 13, 9, 11, 15, 10, 14, 8, 7, 2, 5, 3, 0, 1, 6, 4);
        round!(40, 9, 14, 11, 5, 8, 12, 15, 1, 13, 3, 0, 10, 2, 6, 4, 7);
        round!(48, 11, 15, 5, 0, 1, 9, 8, 6, 14, 10, 2, 12, 3, 4, 7, 13);

        const {
            assert!(OUT_HI_BASE % 32 == 17);
        }
        macro_rules! oh {
            ($w:literal) => {{
                let hv = xor16(state[$w + 8], cv_v[$w]);
                pushf8!(wa, OUT_HI_BASE + 32 * $w, 32, hv);
                pushf8!(wb, OUT_HI_BASE + 32 * $w, 32, maxv);
            }};
        }
        oh!(0);
        oh!(1);
        oh!(2);
        oh!(3);
        oh!(4);
        oh!(5);
        oh!(6);
        oh!(7);
        wa.finish();
        wb.finish();

        const ZF: usize = USEFUL_BITS.div_ceil(32);
        const {
            assert!(U32_PER_BLOCK - ZF == 30);
        }
        // finish() completed word 481. The ranked blk30 path reads only ring
        // words 480/481 and constructs its zero tail directly; blk31 is a
        // direct zero output. Cold/rollback paths retain the complete tail.
        if !ranked_static {
            for w in ZF..U32_PER_BLOCK {
                let i = w & (RING_WORDS - 1);
                store_split(ast,i,zero);
                store_split(bs,i,zero);
            }
        }
        drain_both::<COLS>(drain_ptr,U32_PER_BLOCK - RING_WORDS, 0, RING_WORDS);

        // Band 0 is the one intentional deferral: words 0..7 are the input
        // CV, while words 8..15 depend on the final compression state. Build
        // the complete cache line now, then publish it through the exact same
        // elide/NT/window policy as every rolling band.
        for w in 0..8usize {
            let lo = xor16(state[w], state[w + 8]);
            store_split(ast,w,cv_v[w]);
            store_split(ast,8 + w,lo);
        }
        if !ranked_static {
            for w in 0..8usize {
                store_split(bs,w,maxv);
                store_split(bs,8 + w,maxv);
            }
        }
        drain_both::<COLS>(drain_ptr,0, 0, 16);
    }
}

#[cfg(test)]
mod capture_tests {
 use super::*;
 use std::cell::Cell;
 struct Capture {a:Vec<u32>,b:Vec<u32>,written:Vec<u8>}
 thread_local! {static ACTIVE:Cell<*mut Capture>=const {Cell::new(core::ptr::null_mut())};}
 struct Guard;
 impl Drop for Guard {fn drop(&mut self){ACTIVE.with(|p|p.set(core::ptr::null_mut()));}}
 pub(super) unsafe fn drain(drains:*mut Drain8<'_>,base:usize,ring:usize,words:usize)->bool {unsafe {
  let p=ACTIVE.with(Cell::get);if p.is_null(){return false;}let c=&mut *p;
  for octa in 0..2 {let d=&*drains.add(octa);for lane in 0..8 {for w in 0..words {
   let word=base+w;let out=(octa*8+lane)*512+word;
   let av=if word>=482 {0}else{*d.ast.add(ring+w).cast::<u32>().add(lane)};
   let bv=if word<32||word==480 {u32::MAX}else if word==481 {(1<<17)-1}else if word>=482 {0}else{*d.bs.add(ring+w).cast::<u32>().add(lane)};
   c.a[out]=av;c.b[out]=bv;c.written[out]+=1;
  }}}
  true
 }}
 #[test]
 fn paired_witness_arithmetic_and_packing_match_scalar() {unsafe {
  use flock_core::{field::F8,ntt::AdditiveNttGf8};
  let short=AdditiveNttGf8::new(6,F8::ZERO);let long=AdditiveNttGf8::new(6,F8(64));
  let table=InvNttTableByteSingleGf8::new(&short,&long);
  let dummy=vec![0u8;29*64*8];
  let plan=flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(&table,&dummy,true);
  let preps=prepare_ranked_closed_window_preps(&table,plan);
  for init in [0u64,1,0x8193a2b4c5d6e7f0,u64::MAX] {for bases in [[0usize,4096],[1023,5119],[25087,29183],[60415,64511]] {
   let mut cap=Capture{a:vec![0xa5a5a5a5;16*512],b:vec![0xa5a5a5a5;16*512],written:vec![0;16*512]};
   ACTIVE.with(|p|{assert!(p.get().is_null());p.set(&mut cap)});let guard=Guard;
   let projs=std::array::from_fn(|_|StreamProj{compact_z_tile_words:16*4,seed_window:None,stage:core::ptr::null_mut(),out:core::ptr::null_mut(),out_stride:29*64,cross_quarter:true,compact_z:core::ptr::null_mut(),elide_z:true,out_bias:2*64,inv_table:&table,plan,one_rows_elided:true,w30_elided:true});
   generate::<16>(init,bases,[core::ptr::null_mut();2],[core::ptr::null_mut();2],[core::ptr::null_mut();2],projs,&preps);
   drop(guard);assert!(cap.written.iter().all(|&n|n==1));
   for octa in 0..2 {
    let prep=prepare_closed_inputs_ordered(init,bases[octa],true);
    let mut cv=[[0u32;8];8];let mut m=[[0u32;8];16];let mut t=[0u32;8];
    for k in 0..8 {store_v8(cv[k].as_mut_ptr(),prep.cv[k]);}for k in 0..16 {store_v8(m[k].as_mut_ptr(),prep.message[k]);}store_v8(t.as_mut_ptr(),prep.counter_lo);
    for lane in 0..8 {
     let cv=std::array::from_fn(|k|cv[k][lane]);let m=std::array::from_fn(|k|m[k][lane]);
     let mut z=vec![0u64;256];let mut a=z.clone();let mut b=z.clone();
     super::super::super::build_block_witness_ab_packed_into(&cv,&m,t[lane] as u64,64,11,&mut z,&mut a,&mut b);
     for w in 0..512 {
      let off=(octa*8+lane)*512+w;
      assert_eq!(cap.a[off],(a[w/2]>>(32*(w%2))) as u32,"A init={init} bases={bases:?} octa={octa} lane={lane} word={w}");
      assert_eq!(cap.b[off],(b[w/2]>>(32*(w%2))) as u32,"B init={init} bases={bases:?} octa={octa} lane={lane} word={w}");
     }
    }
   }
  }}
 }}
}
