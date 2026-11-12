use super::*;

// Every pruned mode must equal the incumbent pruned convolution for arbitrary
// matrices. Inputs include single-bit vectors, all-ones, and garbage in the
// mode's known bytes (which both versions must ignore).
#[test]
fn pruned_shared_xor_matches_incumbent_all_modes() {
    let mut state = 0x6a09_e667_f3bc_c908u64;
    let mut next = || {
        state ^= state << 13;
        state ^= state >> 7;
        state ^= state << 17;
        state
    };
    macro_rules! check {
        ($mode:literal) => {{
            assert!(prune_wins($mode));
            for case in 0..1100 {
                let mut input: [u64; 8] = core::array::from_fn(|_| next());
                if case < 512 {
                    input.fill(0);
                    input[case / 64] = 1u64 << (case % 64);
                } else if case < 520 {
                    input.fill(!0);
                }
                let matrices: [u64; 128] = core::array::from_fn(|_| next());
                unsafe {
                    let expected: [u8; 512] = core::mem::transmute(
                        affine_conv_pruned::<$mode>(input.as_ptr(), matrices.as_ptr()));
                    let actual: [u8; 512] = core::mem::transmute(
                        pruned_cse::affine_pruned_cse::<$mode, false, false>(input.as_ptr(), matrices.as_ptr()));
                    assert_eq!(actual, expected, "mode={} case={case}", $mode);
                    let corrected: [u8; 512] = core::mem::transmute(
                        pruned_cse::affine_pruned_cse::<$mode, true, false>(input.as_ptr(), matrices.as_ptr()));
                    assert_eq!(corrected, expected.map(|v| v ^ 1), "corrected mode={} case={case}", $mode);
                    let kn = known($mode); let tau = prune_tau(kn);
                    let mut y: [u64;8] = core::array::from_fn(|j| if kn & (1 << (j ^ tau)) != 0 { 0 } else { !input[j ^ tau] });
                    y[0]^=y[1]; y[2]^=y[3]; y[4]^=y[5]; y[6]^=y[7];
                    y[0]^=y[2]; y[1]^=y[3]; y[4]^=y[6]; y[5]^=y[7];
                    y[0]^=y[4]; y[1]^=y[5]; y[2]^=y[6]; y[3]^=y[7];
                    let prepared: [u8;512] = core::mem::transmute(
                        pruned_cse::affine_pruned_cse::<$mode, true, true>(y.as_ptr(), matrices.as_ptr()));
                    assert_eq!(prepared, corrected, "prepared mode={} case={case}", $mode);
                }
            }
        }};
    }
    check!(1); check!(2); check!(3); check!(4); check!(5); check!(6);
    check!(8); check!(9); check!(10); check!(11); check!(12); check!(13);
}
