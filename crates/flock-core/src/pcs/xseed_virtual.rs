//! Explicit sparse final-row view of an immutable X9 pre-deep codeword.
use crate::field::F128;

pub(super) struct QueryCache {
    blocks:std::collections::BTreeMap<usize,Vec<F128>>,
}
impl QueryCache {
    #[cfg(test)]
    pub(super) fn from_final_rows(source:&[F128],queries:&[usize])->Self {
        let blocks=queries.iter().map(|q| {
            let base=q/32*32;(q/32,source[base*64..(base+32)*64].to_vec())
        }).collect();
        Self{blocks}
    }
    pub(super) fn new(source:&[F128],queries:&[usize])->Self {
        #[cfg(all(target_os="linux",target_arch="x86_64",target_feature="avx512f",target_feature="avx512bw",target_feature="vpclmulqdq"))]
        {
            use rayon::prelude::*;
            assert_eq!(source.len(),1<<26);
            let mut blocks:Vec<_>=queries.iter().map(|q|q/32).collect();
            blocks.sort_unstable();blocks.dedup();
            let ntt=crate::ntt::AdditiveNttF128::standard(20);
            let mut groups=std::collections::BTreeMap::<usize,Vec<usize>>::new();
            for block in blocks {groups.entry(block/64).or_default().push(block%64);}
            let blocks=groups.into_par_iter().flat_map_iter(|(sub,blocks)| {
                ntt.xseed_virtual_query_blocks(&source[sub*2048*64..(sub+1)*2048*64],sub,&blocks)
                    .into_iter().map(move |(block,data)|(sub*64+block,data))
            }).collect();
            Self{blocks}
        }
        #[cfg(not(all(target_os="linux",target_arch="x86_64",target_feature="avx512f",target_feature="avx512bw",target_feature="vpclmulqdq")))]
        {let _=(source,queries);panic!("virtual deep state requires its x86 encoder");}
    }
    pub(super) fn rows(&self,base:usize,len:usize)->&[F128] {
        assert!(len>0 && base/32==(base+len-1)/32);
        let block=&self.blocks[&(base/32)];
        &block[(base%32)*64..(base%32+len)*64]
    }
}
