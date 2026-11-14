//! X16 leaf hashing in two canonical half-row stripes, preserving BLAKE3 CVs.
use super::{Hash,BLAKE3_IV,BLAKE3_CHUNK_START,BLAKE3_CHUNK_END,BLAKE3_PARENT};
use crate::field::F128;
core::arch::global_asm!(include_str!("merkle_xseed_inplace.S"));
unsafe extern "C" {
    fn flock_xseed_inplace_blake3_planes_leaf_512(data:*const u8,count:usize,blocks:usize,key:*const u32,counter:u64,increment:bool,flags:u8,start:u8,end:u8,out:*mut u8);
    fn flock_xseed_inplace_blake3_contiguous_512(data:*const u8,count:usize,blocks:usize,key:*const u32,counter:u64,increment:bool,flags:u8,start:u8,end:u8,out:*mut u8);
    fn flock_blake3_planes_parent(data:*const u8,count:usize,blocks:usize,key:*const u32,counter:u64,increment:bool,flags:u8,start:u8,end:u8,out:*mut u8);
}
type Kernel=unsafe extern "C" fn(*const u8,usize,usize,*const u32,u64,bool,u8,u8,u8,*mut u8);

/// Each group is presented in increasing stripe order. CV bytes are exclusively
/// owned across each call and preserved until the next stripe. Only the last stripe
/// writes `out`; cut=true returns ordinary pair-parent CVs, otherwise leaves.
pub(crate) fn hash_leaf_stripe(data:&[F128],stripe:usize,width:usize,cvs:&mut [u8],cut:bool,out:&mut [Hash]) {
    let active_width=width.min(32); // width64 denotes a canonical in-place half-row.
    assert!(width==64 && stripe<2);
    let final_stripe=stripe==64/active_width-1;
    assert_eq!(data.len()%width,0);
    let count=data.len()/width;
    assert!(count!=0 && count%32==0);
    assert_eq!(cvs.len(),count*32);
    assert_eq!(out.len(),if cut{count/2}else{count});
    let kernel:Kernel=match (width,final_stripe && !cut) {
        (64,false)=>flock_xseed_inplace_blake3_planes_leaf_512,
        (64,true)=>flock_xseed_inplace_blake3_contiguous_512,
        _=>unreachable!(),
    };
    // SAFETY: ISA/module gate, initialized canonical1024B rows with512B active halves,
    // disjoint owned CV/output buffers, full SIMD groups. Every continuation
    // reads only CVs initialized by the preceding stripe; stripe0 reads IV.
    unsafe {
        let input=data.as_ptr().add(if width==64{stripe*32}else{0});
        kernel(input.cast(),count,active_width/4,BLAKE3_IV.as_ptr(),0,false,0,
            if stripe==0{BLAKE3_CHUNK_START}else{0},if final_stripe{BLAKE3_CHUNK_END}else{0},cvs.as_mut_ptr());
        if final_stripe {
            if cut {
                flock_blake3_planes_parent(cvs.as_ptr(),out.len(),1,BLAKE3_IV.as_ptr(),0,false,BLAKE3_PARENT,0,0,out.as_mut_ptr().cast());
            } else {
                core::ptr::copy_nonoverlapping(cvs.as_ptr(),out.as_mut_ptr().cast(),cvs.len());
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn striped_leaf_continuations_match_canonical_hashes() {
        check_width(64);
    }
    fn check_width(width:usize) {
        let mut rng=0x5eed13u64;
        for count in [32,128] {for fixture in 0..3 {for cut in [false,true] {
            let mut data=vec![F128::ZERO;count*64];
            for x in &mut data {
                rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;let lo=rng;
                rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;
                *x=match fixture {0=>F128::ZERO,1=>F128{lo:u64::MAX,hi:u64::MAX},_=>F128{lo,hi:rng}};
            }
            let bytes=unsafe{std::slice::from_raw_parts(data.as_ptr().cast::<u8>(),data.len()*16)};
            let n=if cut{count/2}else{count};
            let mut expected=vec![[0u8;32];n];
            if cut {super::super::hash_leaf_pairs_serial(bytes,1024,&mut expected,super::super::HashKind::Blake3);}
            else {super::super::hash_leaves_serial(bytes,1024,&mut expected,super::super::HashKind::Blake3);}
            let sentinel=[0xa5u8;32];
            let mut output=vec![sentinel;n+2];
            let mut cvs=vec![0xa5u8;count*32+2];
            for stripe in 0..64/width.min(32) {
                let mut input=Vec::with_capacity(count*width);
                if width==64 {input.extend_from_slice(&data);} else {
                    for row in data.chunks_exact(64) {input.extend_from_slice(&row[stripe*width..(stripe+1)*width]);}
                }
                hash_leaf_stripe(&input,stripe,width,&mut cvs[1..count*32+1],cut,&mut output[1..n+1]);
                if stripe<64/width.min(32)-1 {assert!(output.iter().all(|x|*x==sentinel));}
                assert_eq!((cvs[0],cvs[count*32+1]),(0xa5,0xa5));
                assert_eq!((output[0],output[n+1]),(sentinel,sentinel));
            }
            assert_eq!(&output[1..n+1],expected.as_slice());
        }}}
    }
}
