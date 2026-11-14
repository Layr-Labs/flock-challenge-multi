use super::*;
use core::arch::x86_64::*;

/// Compact q-major source, sixteen-field output pitch. The arithmetic is the
/// unchanged crown sparse+dense seed; only pitches and call batching differ.
#[inline]
#[target_feature(enable = "avx512f,avx512bw,vpclmulqdq")]
pub(crate) unsafe fn xseed_compact_seed(src: *const F128, kp: usize,
    dst: *mut F128, active: usize, prepared: &[F128; 8]) { unsafe {
    let dense = [prepared[2], prepared[4], prepared[6]];
    assert!(matches!(active, 12 | 16));
    if dense[0].hi == 0 {
        seed_sparse_dense_compact::<true, true>(src, 64, kp, dst,
            dst.add(256 * 16), 64, 16, active, prepared[0], &dense,
            core::ptr::null(), prepared.as_ptr(), 64);
    } else {
        seed_sparse_dense_compact::<false, true>(src, 64, kp, dst,
            dst.add(256 * 16), 64, 16, active, prepared[0], &dense,
            core::ptr::null(), prepared.as_ptr(), 64);
    }
}}

#[inline]
#[target_feature(enable = "avx512f,avx512bw,vpclmulqdq")]
pub(crate) unsafe fn xseed_compact_publish(src: *const F128, step: usize,
    dst: [*mut F128; 4], active: usize, p: &[F128; 6]) { unsafe {
    assert!(matches!(active, 12 | 16));
    macro_rules! call {($a:literal,$b:literal) => {
        if dst[0] as usize % 64 == 0 {
            publish_impl::<$a,$b,true>(src,step,dst,active,p)
        } else { publish_impl::<$a,$b,false>(src,step,dst,active,p) }
    }}
    if p[0].hi == 0 && p[2].hi == 0 && p[4].hi == 0 { call!(true,true); }
    else if p[0].hi == 0 { call!(true,false); }
    else { call!(false,false); }
}}

#[inline]
#[target_feature(enable = "avx512f,avx512bw,vpclmulqdq")]
unsafe fn publish_impl<const OUTER: bool, const INNER: bool, const ZMM: bool>(
    src: *const F128, step: usize, dst: [*mut F128; 4], active: usize,
    p: &[F128; 6]) { unsafe {
    let pair = |i: usize, low: bool| {
        let t = _mm512_broadcast_i32x4(_mm_loadu_si128(p.as_ptr().add(i * 2).cast()));
        let c = if low { t } else {
            _mm512_broadcast_i32x4(_mm_loadu_si128(p.as_ptr().add(i * 2 + 1).cast()))
        };
        (t, c)
    };
    let a = pair(0, OUTER); let b = pair(1, INNER); let c = pair(2, INNER);
    for lane in (0..active).step_by(4) {
        let u = _mm512_loadu_si512(src.add(lane).cast());
        let v = _mm512_loadu_si512(src.add(step + lane).cast());
        let w = _mm512_loadu_si512(src.add(2 * step + lane).cast());
        let x = _mm512_loadu_si512(src.add(3 * step + lane).cast());
        let (u,v,w,x) = butterfly_2layer_diet_x4::<OUTER,INNER>(a,b,c,u,v,w,x);
        stream_f128x4::<ZMM>(dst[0].add(lane),u);
        stream_f128x4::<ZMM>(dst[1].add(lane),v);
        stream_f128x4::<ZMM>(dst[2].add(lane),w);
        stream_f128x4::<ZMM>(dst[3].add(lane),x);
    }
    if active == 12 {
        let zero = _mm512_setzero_si512();
        for p in dst { stream_f128x4::<ZMM>(p.add(12),zero); }
    }
}}

#[cfg(test)]
mod tests {
    use super::*;
    fn next(s: &mut u64) -> F128 {
        *s ^= *s << 13; *s ^= *s >> 7; *s ^= *s << 17;
        let lo = *s;
        *s ^= *s << 13; *s ^= *s >> 7; *s ^= *s << 17;
        F128::new(lo, *s)
    }
    #[test]
    fn xseed_compact_seed_and_publish_match_scalar() { unsafe {
        let mut s = 0x8374af82u64;
        let guard = F128::new(!0, 0xabc);
        for low in [false, true] { for active in [12, 16] { for col in [0, 16, 48] {
            let mut tw: [F128; 4] = core::array::from_fn(|_| next(&mut s));
            if low { tw[1].hi = 0; }
            let p: [F128; 8] = core::array::from_fn(|i| if i % 2 == 0 { tw[i/2] } else { tw[i/2] * F128::new(0, 1) });
            let input: Vec<_> = (0..256*64).map(|_| next(&mut s)).collect();
            for kp in [0, 17, 63] {
                let mut out = vec![guard; 512*16+8]; let mut expected = out.clone();
                for lane in 0..active {
                    let [a,b,c,d] = core::array::from_fn(|q| input[(q*64+kp)*64+col+lane]);
                    let sc = c+a+(d+b)*tw[0];
                    let aa = a+c*tw[1]; let bb=b+d*tw[1];
                    let cc=c+aa; let dd=d+bb;
                    let oa=aa+bb*tw[2]; let oc=cc+dd*tw[3];
                    let rows=[a,b+a,sc,d+b+sc,oa,bb+oa,oc,dd+oc];
                    for row in 0..8 { expected[4+(row*64+kp)*16+lane]=rows[row]; }
                }
                xseed_compact_seed(input.as_ptr().add(col),kp,out.as_mut_ptr().add(4+kp*16),active,&p);
                assert_eq!(out,expected,"seed low={low} active={active} col={col} kp={kp}");
            }
        }}}
        for class in 0..3 { for active in [12,16] { for step in [16,256] { for misalign in 0..4 {
            let mut tw: [F128;3] = core::array::from_fn(|_|next(&mut s));
            if class > 0 {tw[0].hi=0;} if class==2 {tw[1].hi=0;tw[2].hi=0;}
            let p=core::array::from_fn(|i|if i%2==0{tw[i/2]}else{tw[i/2]*F128::new(0,1)});
            let input:Vec<_>=(0..4*step).map(|_|next(&mut s)).collect();
            let mut out=vec![guard;4*64+16]; let mut expected=out.clone();
            let start=4+misalign;
            for lane in 0..16 {
                let vals=if lane>=active{[F128::ZERO;4]}else{
                    let [a,b,c,d]=core::array::from_fn(|i|input[i*step+lane]);
                    let aa=a+c*tw[0];let bb=b+d*tw[0];let cc=c+aa;let dd=d+bb;
                    let oa=aa+bb*tw[1];let oc=cc+dd*tw[2];[oa,bb+oa,oc,dd+oc]
                };
                for row in 0..4 {expected[start+row*64+lane]=vals[row];}
            }
            let dst=core::array::from_fn(|i|out.as_mut_ptr().add(start+i*64));
            xseed_compact_publish(input.as_ptr(),step,dst,active,&p);_mm_sfence();
            assert_eq!(out,expected,"publish class={class} active={active} step={step} align={misalign}");
        }}}}
    }}
    #[test]
    fn xseed_compact_f4_pitch16_matches_scalar() { unsafe {
        let mut s=0x83747u64;let guard=F128::new(!0,123);
        for step in [1,4] {for active in [12,16] {for zero_chain in [false,true] {
            let mut tw:[F128;15]=core::array::from_fn(|_|next(&mut s));
            if zero_chain {for i in [0,1,3,7] {tw[i]=F128::ZERO;}}
            let prepared=prepare_four(&tw).expect("test requires prepared twiddles");
            let mut input:Vec<_>=(0..16*step*16+8).map(|_|next(&mut s)).collect();
            input[..4].fill(guard);let mut expected=input.clone();
            for layer in 0..4 {let width=16>>layer;for b in 0..(1<<layer) {for j in 0..width/2 {for lane in 0..active {
                let u=4+(b*width+j)*step*16+lane;let v=u+width/2*step*16;
                expected[u]=expected[u]+expected[v]*tw[(1<<layer)-1+b];expected[v]=expected[v]+expected[u];
            }}}}
            row_prepared::<0>(input.as_mut_ptr().add(4),step,16,active,0,&tw,0,&prepared);
            assert_eq!(input,expected,"F4 step={step} active={active} zero_chain={zero_chain}");
        }}}
    }}
}

