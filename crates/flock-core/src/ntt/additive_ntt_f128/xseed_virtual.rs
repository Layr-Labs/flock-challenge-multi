//! X9: immutable pre-deep state, private final transform, sparse query replay.
use super::{AdditiveNttF128,F128,kernels};

thread_local! {
    static QUERY_TMP:std::cell::RefCell<Vec<F128>>=const {std::cell::RefCell::new(Vec::new())};
}

impl AdditiveNttF128 {
    /// False means no buffers were touched and the ordinary encoder must run.
    /// Uses the same exclusive generated-witness contract as its caller.
    pub(crate) unsafe fn rs_encode_generated_virtual(
        &self, msg:&mut [F128], codeword:&mut [F128],
        produce:&(dyn Fn(*mut F128,usize,usize,Option<&super::WitnessSeedTarget>)+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,&[F128])+Sync),
    )->bool {
        if !crate::sl2_env_set!("FLOCK_XSEED_VIRTUAL_DEEP") {return false;}
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
        let plans:Option<Vec<_>>=(0..512).map(|sub|unsafe {kernels::prepare_four(&self.xseed_virtual_four(9,sub))}).collect();
        let Some(plans)=plans else{return false;};
        let Some(_claim)=super::DeepSplitClaim::take() else{return false;};
        let state=super::xseed_virtual_queue::Session::new(512,pairs);
        let source_addr=codeword.as_ptr() as usize;
        let raw7=raw_tail==7 && super::ntt_raw7_pack_enabled();
        let hint=super::deep_pf_hint();
        let make=|sub:usize,dst:*mut F128,publish:&dyn Fn(usize)|unsafe{
            // Only entered after the top sfences + joined role barrier.
            // No shared codeword slice coexists with the top mutable borrow.
            kernels::xseed_virtual_first((source_addr as *const F128).add(sub*2048*64),dst,&plans[sub],hint);
            for b in 0..16 {
                self.v2_deep_block_x86(sub,b,dst,&|_,_|{},9,20,64,4,raw7,2048,hint);
                publish(b);
            }
        };
        let input=unsafe{super::SeedInput::generating(msg,produce)};
        let after=|idx|state.worker(idx,pairs,&make,consume);
        let merged=self.seed_top_fused8_pass(input,codeword,64,20,4,
            if super::merged_pass_enabled(){Some(&after)}else{None});
        if !merged {state.run(pairs,&make,consume);}
        true
    }

    /// Correctness fallback for non-ranked opening modes, not the timed path.
    pub(crate) fn xseed_virtual_materialize(&self,source:&[F128])->Vec<F128> {
        use rayon::prelude::*;
        assert_eq!(source.len(),1<<26);
        let mut out=crate::alloc_uninit_vec::<F128>(source.len());
        out.par_chunks_mut(2048*64).enumerate().for_each(|(sub,dst)| {
            // A diagnostic may disable prepared kernels after commit; query
            // replay also supports the fully generic arithmetic fallback.
            let blocks:Vec<_>=(0..64).collect();
            for (block,data) in self.xseed_virtual_query_blocks(&source[sub*2048*64..(sub+1)*2048*64],sub,&blocks) {
                dst[block*32*64..(block+1)*32*64].copy_from_slice(&data);
            }
        });
        out
    }


    fn xseed_virtual_four(&self,layer:usize,block:usize)->[F128;15] {
        core::array::from_fn(|i| {
            let local_layer=(i+1).ilog2() as usize;
            self.twiddle(layer+local_layer,(block<<local_layer)+i+1-(1<<local_layer))
        })
    }

    fn xseed_virtual_three_twiddles(&self,layer:usize,group:usize,branch:usize)->[F128;3] {
        let a=branch>>2;let b=(branch>>1)&1;let c=branch&1;
        [self.twiddle(layer,group)+if a!=0{F128::ONE}else{F128::ZERO},
         self.twiddle(layer+1,group*2+a)+if b!=0{F128::ONE}else{F128::ZERO},
         self.twiddle(layer+2,group*4+a*2+b)+if c!=0{F128::ONE}else{F128::ZERO}]
    }

    /// Reconstruct requested32-row blocks, sharing every common prefix.
    /// Accepts either nine- or ten-layer top state; this does not change the
    /// encoder geometry. Workspace is private to the calling worker.
    pub(crate) fn xseed_virtual_query_blocks(&self,source:&[F128],sub:usize,blocks:&[usize])->Vec<(usize,Vec<F128>)> {
        let rows=source.len()/64;
        assert!(matches!(rows,1024|2048) && source.len()==rows*64);
        let layer=20-rows.ilog2() as usize;
        assert!(sub<1<<layer && blocks.iter().all(|&b|b<rows/32));
        let mut blocks=blocks.to_vec();blocks.sort_unstable();blocks.dedup();
        if blocks.is_empty(){return Vec::new();}
        fn visit(ntt:&AdditiveNttF128,data:&mut [F128],layer:usize,group:usize,
            base:usize,blocks:&[usize],out:&mut Vec<(usize,Vec<F128>)>) {
            if layer==15 {
                assert_eq!(blocks,&[base]);
                let four=kernels::FourBlock::new(ntt.xseed_virtual_four(15,group));
                for row in 0..2 {
                    unsafe {kernels::butterfly_fused_4layer_cached(data.as_mut_ptr(),2,64,64,row,&four);}
                }
                for row in 0..16 {
                    let (a,b)=data[2*row*64..(2*row+2)*64].split_at_mut(64);
                    kernels::butterfly_row_pair(a,b,ntt.twiddle(19,group*16+row));
                }
                out.push((base,data.to_vec()));return;
            }
            if layer<=12 {
                let eighth=data.len()/8;
                let span=eighth/(32*64);
                let branch=(blocks[0]-base)/span;
                if (blocks[blocks.len()-1]-base)/span==branch {
                    unsafe {kernels::xseed_virtual_project_three(data.as_ptr(),data.as_mut_ptr(),eighth,
                        ntt.xseed_virtual_three_twiddles(layer,group,branch));}
                    visit(ntt,&mut data[..eighth],layer+3,group*8+branch,base+branch*span,blocks,out);
                    return;
                }
            }
            let half=data.len()/2;
            let middle=base+half/(32*64);
            let split=blocks.partition_point(|&b|b<middle);
            if split!=0 && split!=blocks.len() {
                // Exact in-place operation: both inputs of each butterfly
                // are loaded before either output is stored.
                unsafe {kernels::xseed_virtual_project_pair(data.as_ptr(),data.as_mut_ptr(),half,ntt.twiddle(layer,group));}
                let (left,right)=data.split_at_mut(half);
                visit(ntt,left,layer+1,group*2,base,&blocks[..split],out);
                visit(ntt,right,layer+1,group*2+1,middle,&blocks[split..],out);
            } else {
                let right=split==0;
                // Keep one child in the left prefix, preserving the original
                // single-query working set rather than allocating per level.
                unsafe {kernels::xseed_virtual_project(data.as_ptr(),data.as_mut_ptr(),half,ntt.twiddle(layer,group),right);}
                visit(ntt,&mut data[..half],layer+1,group*2+usize::from(right),if right{middle}else{base},blocks,out);
            }
        }
        QUERY_TMP.with_borrow_mut(|tmp| {
            let eighth=source.len()/8;
            let span=eighth/(32*64);
            let branch=blocks[0]/span;
            if blocks[blocks.len()-1]/span==branch {
                if tmp.len()<eighth {tmp.resize(eighth,F128::ZERO);}
                let data=&mut tmp[..eighth];
                unsafe {kernels::xseed_virtual_project_three(source.as_ptr(),data.as_mut_ptr(),eighth,
                    self.xseed_virtual_three_twiddles(layer,sub,branch));}
                let mut out=Vec::with_capacity(blocks.len());
                visit(self,data,layer+3,sub*8+branch,branch*span,&blocks,&mut out);
                return out;
            }
            let half=source.len()/2;
            let middle=rows/64;
            let split=blocks.partition_point(|&b|b<middle);
            let both=split!=0 && split!=blocks.len();
            let needed=if both{source.len()}else{half};
            if tmp.len()<needed {tmp.resize(needed,F128::ZERO);}
            let data=&mut tmp[..needed];
            let mut out=Vec::with_capacity(blocks.len());
            if both {
                unsafe {kernels::xseed_virtual_project_pair(source.as_ptr(),data.as_mut_ptr(),half,self.twiddle(layer,sub));}
                let (left,right)=data.split_at_mut(half);
                visit(self,left,layer+1,sub*2,0,&blocks[..split],&mut out);
                visit(self,right,layer+1,sub*2+1,middle,&blocks[split..],&mut out);
            } else {
                let right=split==0;
                unsafe {kernels::xseed_virtual_project(source.as_ptr(),data.as_mut_ptr(),half,self.twiddle(layer,sub),right);}
                visit(self,data,layer+1,sub*2+usize::from(right),if right{middle}else{0},&blocks,&mut out);
            }
            out
        })
    }

    /// Reconstruct one aligned32-row block from a1024-row pre-deep subgroup.
    /// Inputs stay immutable; returned rows are complete canonical field values.
    pub(crate) fn xseed_virtual_query_block(&self,source:&[F128],sub:usize,block:usize)->Vec<F128> {
        assert_eq!(source.len(),1024*64);
        assert!(sub<1024 && block<32);
        QUERY_TMP.with_borrow_mut(|tmp| {
            tmp.resize(512*64,F128::ZERO);
            let mut width=1024;
            let mut global_block=sub;
            let mut src=source.as_ptr();
            for layer in 10..15 {
                let right=block & (1<<(14-layer)) != 0;
                width/=2;
                // Each step reads both halves before overwriting only the
                // left prefix. First step reads the immutable global input.
                unsafe {kernels::xseed_virtual_project(src,tmp.as_mut_ptr(),width*64,
                    self.twiddle(layer,global_block),right);}
                global_block=2*global_block+usize::from(right);
                src=tmp.as_ptr();
            }
            let four=kernels::FourBlock::new(self.xseed_virtual_four(15,global_block));
            for row in 0..2 {
                unsafe {kernels::butterfly_fused_4layer_cached(tmp.as_mut_ptr(),2,64,64,row,&four);}
            }
            for row in 0..16 {
                let pair=&mut tmp[2*row*64..(2*row+2)*64];
                let (a,b)=pair.split_at_mut(64);
                kernels::butterfly_row_pair(a,b,self.twiddle(19,global_block*16+row));
            }
            tmp[..32*64].to_vec()
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

#[test]
fn virtual_three_projection_handles_prefix_alias(){
    let mut state=0x12abcde123u64;
    let mut next=||{let mut word=||{state^=state<<13;state^=state>>7;state^=state<<17;state};F128{lo:word(),hi:word()}};
    let mut cases=0;
    for n in [4usize,12,64,256]{for fixture in 0..4{for path in 0..8{
        let source:Vec<_>=(0..8*n).map(|_|if fixture==0{F128::ZERO}else if fixture==1{F128{lo:u64::MAX,hi:u64::MAX}}else{next()}).collect();
        let original_t:[F128;3]=core::array::from_fn(|_|if fixture==0{F128::ZERO}else if fixture==1{F128::ONE}else{next()});
        let mut t=original_t;
        for l in 0..3{if path&(1<<(2-l))!=0{t[l]+=F128::ONE;}}
        let mut expect=source.clone();let mut width=8*n;
        for l in 0..3{let half=width/2;for j in 0..half{
            let b=expect[j+half];expect[j]+=b*original_t[l];
            if path&(1<<(2-l))!=0{expect[j]+=b;}
        }width=half;}
        let guard=next();let mut dest=vec![guard;n+8];
        unsafe{kernels::xseed_virtual_project_three(source.as_ptr(),dest.as_mut_ptr().add(4),n,t);}
        assert_eq!(&dest[4..n+4],&expect[..n]);assert!(dest[..4].iter().chain(&dest[n+4..]).all(|&x|x==guard));
        let mut inplace=vec![guard;source.len()+8];inplace[4..4+source.len()].copy_from_slice(&source);
        unsafe{kernels::xseed_virtual_project_three(inplace.as_ptr().add(4),inplace.as_mut_ptr().add(4),n,t);}
        assert_eq!(&inplace[4..4+n],&expect[..n]);assert_eq!(&inplace[4+n..4+source.len()],&source[n..]);
        assert!(inplace[..4].iter().chain(&inplace[4+source.len()..]).all(|&x|x==guard));cases+=1;
    }}}
    println!("X12 native dot3: {cases} cases PASS, all paths/disjoint/exact-prefix/guards");
}

    #[test]
    fn virtual_private_deep_matches_scalar_and_preserves_input() {
        let ntt=AdditiveNttF128::standard(20);
        let mut state=0x5eed0902u64;
        let mut next=||{let mut word=||{state^=state<<13;state^=state>>7;state^=state<<17;state};F128{lo:word(),hi:word()}};
        let mut cases=0;
        for sub in [0,1,347,511] {for hint in 0..3 {for raw7 in [false,true] {
            let mut source:Vec<_>=(0..2048*64).map(|_|next()).collect();
            for row in (1..2048).step_by(2) {source[row*64+if raw7{57}else{60}..(row+1)*64].fill(F128::ZERO);}
            let before=source.clone();let mut expected=source.clone();
            for layer in 9..20 {let width=1<<(20-layer);for b in 0..1<<(layer-9) {
                let t=ntt.twiddle(layer,(sub<<(layer-9))+b);
                for row in 0..width/2 {for lane in 0..64 {
                    let a=(b*width+row)*64+lane;let z=a+width/2*64;
                    let v=expected[z];expected[a]+=v*t;expected[z]=v+expected[a];
                }}
            }}
            let guard=next();let mut storage=vec![guard;2048*64+8];
            let dst=&mut storage[4..4+2048*64];
            unsafe {
                let p=kernels::prepare_four(&ntt.xseed_virtual_four(9,sub)).unwrap();
                kernels::xseed_virtual_first(source.as_ptr(),dst.as_mut_ptr(),&p,hint);
                for b in (0..16).rev() {ntt.v2_deep_block_x86(sub,b,dst.as_mut_ptr(),&|range,data| {
                    let lo=range.start-sub*2048;
                    assert_eq!(data,&expected[lo*64..(lo+128)*64]);
                },9,20,64,4,raw7,2048,hint);}
            }
            assert_eq!(dst,expected);assert_eq!(source,before);
            assert!(storage[..4].iter().chain(&storage[4+2048*64..]).all(|&v|v==guard));
            cases+=1;
        }}}
        println!("X9 private complete deep: {cases} scalar comparisons PASS");
    }

    #[test]
    fn virtual_batched_queries_match_independent_full_transform() {
        let ntt=AdditiveNttF128::standard(20);
        let mut state=0x5eed0912u64;
        let mut next=||{let mut word=||{state^=state<<13;state^=state>>7;state^=state<<17;state};F128{lo:word(),hi:word()}};
        let mut cases=0;
        for rows in [1024usize,2048] {
            let start=20-rows.ilog2() as usize;
            for sub in [0,1,(1<<start)-1] {for tail in [0,4,7] {
                let mut source:Vec<_>=(0..rows*64).map(|_|next()).collect();
                for r in (1..rows).step_by(2) {source[r*64+64-tail..(r+1)*64].fill(F128::ZERO);}
                let before=source.clone();let mut expected=source.clone();
                for layer in start..20 {let width=1<<(20-layer);for b in 0..1<<(layer-start) {
                    let t=ntt.twiddle(layer,(sub<<(layer-start))+b);
                    for row in 0..width/2 {for lane in 0..64 {
                        let a=(b*width+row)*64+lane;let z=a+width/2*64;
                        let v=expected[z];expected[a]+=v*t;expected[z]=v+expected[a];
                    }}
                }}
                let count=rows/32;
                let mut sets=vec![vec![],vec![0],vec![count-1],vec![0,1,5,count/2,count-1],
                    vec![count-1,0,0,1,count-1],(0..count).collect()];
                for eighth in 0..8 {
                    let base=eighth*count/8;
                    sets.push(vec![base,base+count/8-1]);
                    sets.push(vec![base+count/16]);
                }
                for mut blocks in sets {
                    let got=ntt.xseed_virtual_query_blocks(&source,sub,&blocks);
                    blocks.sort_unstable();blocks.dedup();
                    assert_eq!(got.len(),blocks.len());
                    for ((block,data),expected_block) in got.iter().zip(&blocks) {
                        assert_eq!(block,expected_block);
                        assert_eq!(data,&expected[block*32*64..(block+1)*32*64]);
                    }
                    assert_eq!(source,before);cases+=1;
                }
            }}
        }
        println!("X9 batched query replay: {cases} independent full-transform cases PASS; both top geometries, duplicate/empty/full query sets, source unchanged");
    }

    #[test]
    fn virtual_query_cones_match_complete_deep_transform() {
        let ntt=AdditiveNttF128::standard(20);
        let mut state=0x5eed09u64;
        let mut next=|| {let mut word=||{state^=state<<13;state^=state>>7;state^=state<<17;state};F128{lo:word(),hi:word()}};
        let mut cases=0;
        for sub in [0,1,1023] {for tail in [0,4] {
            let mut source:Vec<_>=(0..1024*64).map(|_|next()).collect();
            for r in (1..1024).step_by(2) {source[r*64+64-tail..(r+1)*64].fill(F128::ZERO);}
            let before=source.clone();let mut expected=source.clone();
            for layer in 10..20 {let width=1<<(20-layer);for b in 0..1<<(layer-10) {
                let t=ntt.twiddle(layer,(sub<<(layer-10))+b);
                for row in 0..width/2 {for lane in 0..64 {
                    let a=(b*width+row)*64+lane;let z=a+width/2*64;
                    let v=expected[z];expected[a]+=v*t;expected[z]=v+expected[a];
                }}
            }}
            for block in [0,1,5,16,31] {
                let got=ntt.xseed_virtual_query_block(&source,sub,block);
                assert_eq!(got,&expected[block*32*64..(block+1)*32*64]);
                assert_eq!(source,before);cases+=1;
            }
        }}
        println!("X9 pruned query cones: {cases} independent full-transform comparisons PASS");
    }
}
