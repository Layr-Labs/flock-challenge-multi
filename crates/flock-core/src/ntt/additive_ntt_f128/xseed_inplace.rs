//! X16 canonical in-place half-row deep transform, without query replay.
use super::{AdditiveNttF128,F128,kernels};
impl AdditiveNttF128 {
pub(crate) unsafe fn rs_encode_generated_inplace(
        &self,msg:&mut [F128],codeword:&mut [F128],
        produce:&(dyn Fn(*mut F128,usize,usize,Option<&super::WitnessSeedTarget>)+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,usize,&[F128],&mut [u8])+Sync),
    )->bool {
        if !cfg!(target_feature="avx512vl") || !crate::sl2_env_set!("FLOCK_XSEED_INPLACE_STRIPED") {return false;}
        let (odd_tail,raw_tail)=super::ranked_zero_odd_tail_snapshot(20,64);
        if msg.len()!=1<<25 || codeword.len()!=1<<26 || self.log_domain_size()!=20
            || odd_tail!=4 || super::rate_half_seed_disabled() || super::ntt_seed_top_fusion_disabled()
            || super::ntt_fused3_disabled() || !super::deep_block_fuse_enabled()
            || !Self::scatter_nt_enabled() || !(codeword.as_ptr() as usize).is_multiple_of(16)
            || super::ntt_direct_fused2_publish_disabled() || !super::st_fmp_balanced_enabled()
            || super::st_fmp_bufs()!=super::ST_FMP_BALANCED_BUFS {return false;}
        let Some(pairs)=super::deep_split_pairs() else{return false;};
        if pairs.len()*2!=rayon::current_num_threads() || !crate::owns_whole_pool(){return false;}
        // Resolve preparation before touching the input: failed gates may fall back.
        let plans:Option<Vec<_>>=(0..512).map(|sub|unsafe {kernels::prepare_four(&self.xseed_inplace_four(9,sub))}).collect();
        let Some(plans)=plans else{return false;};
        let Some(_claim)=super::DeepSplitClaim::take() else{return false;};
        let state=unsafe{super::xseed_inplace_queue::Session::new(512,pairs,codeword.as_mut_ptr())};
        let packed=raw_tail==7 && super::ntt_raw7_pack_enabled();
        let make=|sub:usize,stripe:usize,dst:*mut F128,publish:&dyn Fn(usize)|unsafe{
            self.xseed_inplace_make(sub,stripe,dst,&plans[sub],packed,publish);
        };
        let input=unsafe{super::SeedInput::generating(msg,produce)};
        let after=|idx|state.worker(idx,pairs,&make,consume);
        let merged=self.seed_top_fused8_pass(input,codeword,64,20,4,
            if super::merged_pass_enabled(){Some(&after)}else{None});
        if !merged {state.run(pairs,&make,consume);}
        true
    }
unsafe fn xseed_inplace_make(&self,sub:usize,stripe:usize,dst:*mut F128,first:&kernels::PreparedFour,packed:bool,publish:&dyn Fn(usize)) {
        thread_local! {
            static PLANS:std::cell::RefCell<(Vec<kernels::PreparedFour>,Vec<[F128;7]>)>=const {std::cell::RefCell::new((Vec::new(),Vec::new()))};
        }
            PLANS.with_borrow_mut(|(second,last)| {
                if stripe==0 {
                    second.clear();last.clear();
                    for b in 0..16 {second.push(unsafe{kernels::prepare_four(&self.xseed_inplace_four(13,sub*16+b))}.expect("prepared gate checked before top"));}
                    for b in 0..256 {last.push(core::array::from_fn(|i| {
                        let l=(i+1).ilog2() as usize;
                        self.twiddle(17+l,((sub*256+b)<<l)+i+1-(1<<l))
                    }));}
                }
                unsafe {
                    kernels::xseed_inplace_first(dst,first,stripe);
                    for b in 0..16 {
                        let block=dst.add(b*128*64+stripe*32);
                        if packed && stripe==1 {
                            kernels::xseed_inplace_second_packed(block,&second[b]);
                        } else {
                            kernels::xseed_inplace_second(block,&second[b],stripe);
                        }
                        for j in 0..16 {
                            kernels::xseed_inplace_last(block.add(j*8*64),if stripe==1{28}else{32},&last[b*16+j]);
                        }
                        publish(b);
                    }
                }
            });
    }
fn xseed_inplace_four(&self,layer:usize,block:usize)->[F128;15] {
        core::array::from_fn(|i| {
            let local_layer=(i+1).ilog2() as usize;
            self.twiddle(layer+local_layer,(block<<local_layer)+i+1-(1<<local_layer))
        })
    }
}
#[cfg(test)]
mod tests {use super::*;
#[test]
fn inplace_complete_deep_matches_scalar() {
        let ntt=AdditiveNttF128::standard(20);
        let mut state=0x5eed13u64;
        let mut next=||{let mut word=||{state^=state<<13;state^=state>>7;state^=state<<17;state};F128{lo:word(),hi:word()}};
        let guard=F128{lo:u64::MAX,hi:0x1313};let mut cases=0;
        for sub in [0,1,347,511] {for (tail,packed) in [(4,false),(7,false),(7,true)] {for fixture in 0..3 {
            let source:Vec<_>=(0..2048*64).map(|i| {
                if i/64%2==1 && i%64>=64-tail || fixture==0 {F128::ZERO}
                else if fixture==1 {F128{lo:u64::MAX,hi:u64::MAX}}else{next()}
            }).collect();
            let original=source.clone();let mut expected=source.clone();
            for layer in 9..20 {let width=1<<(20-layer);for b in 0..1<<(layer-9) {
                let t=ntt.twiddle(layer,(sub<<(layer-9))+b);
                for row in 0..width/2 {for lane in 0..64 {
                    let a=(b*width+row)*64+lane;let z=a+width/2*64;
                    let old=expected[z];expected[a]+=old*t;expected[z]=old+expected[a];
                }}
            }}
            let first=unsafe{kernels::prepare_four(&ntt.xseed_inplace_four(9,sub))}.unwrap();
            let mut tile=vec![guard;2048*64+8];
            tile[4..4+2048*64].copy_from_slice(&source);
            for stripe in 0..2 {
                let done=std::cell::Cell::new(0u32);
                unsafe {ntt.xseed_inplace_make(sub,stripe,tile.as_mut_ptr().add(4),&first,packed,&|b| {
                    assert_eq!(done.get()&(1<<b),0);done.set(done.get()|(1<<b));
                });}
                assert_eq!(done.get(),0xffff);
                for row in 0..2048 {
                    assert_eq!(&tile[4+row*64+stripe*32..4+row*64+(stripe+1)*32],&expected[row*64+stripe*32..row*64+(stripe+1)*32],"sub={sub} tail={tail} fixture={fixture} stripe={stripe} row={row}");
                    if stripe==0 {assert_eq!(&tile[4+row*64+32..4+(row+1)*64],&source[row*64+32..(row+1)*64]);}
                }
                assert!(tile[..4].iter().chain(&tile[4+2048*64..]).all(|&x|x==guard));
            }
            assert_eq!(&tile[4..4+2048*64],expected.as_slice());assert_eq!(source,original);cases+=1;
        }}}
        println!("X16 canonical in-place composition: {cases} subgroup cases PASS, canonical output, all stripes/tails/guards/callbacks");
    }
}
