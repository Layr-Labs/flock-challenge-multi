use super::*;
fn check<const MODE:u8>() {
    assert!(partial_cse::enabled(MODE));
    let mut state=0x91af_89b7_7123_551fu64+MODE as u64;
    let mut next=||{state^=state<<13;state^=state>>7;state^=state<<17;state};
    for case in 0..1536 {
        let mut input:[u64;8]=core::array::from_fn(|_|next());
        if case<512 {input.fill(0);input[case/64]=1u64<<(case%64);}
        if case==512 {input.fill(u64::MAX);}
        let matrices:[u64;128]=core::array::from_fn(|_|next());
        // Arbitrary known-byte contents are deliberate: both maps must ignore them.
        unsafe {
            let expected:[u8;512]=core::mem::transmute(affine_conv_pruned::<MODE>(input.as_ptr(),matrices.as_ptr()));
            let actual:[u8;512]=core::mem::transmute(partial_cse::apply::<MODE>(input.as_ptr(),matrices.as_ptr()));
            assert_eq!(actual,expected,"MODE{MODE} case{case}");
        }
    }
}
#[test]
fn optimized_pruned_projection_matches_original_arbitrary_matrices(){
    check::<2>();check::<3>();check::<4>();check::<6>();check::<8>();
    check::<9>();check::<10>();check::<11>();check::<13>();
}
