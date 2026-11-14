use super::*;
use crate::field::F128;

fn rng(seed: u64) -> impl FnMut() -> F128 {
    let mut st = seed | 1;
    move || {
        let mut n = || {
            st ^= st << 13;
            st ^= st >> 7;
            st ^= st << 17;
            st
        };
        F128 { lo: n(), hi: n() }
    }
}

/// The scalar low-multiplier path must equal the general product for
/// every multiplier with a zero high limb, including zero and one.
#[test]
fn mul_low_rhs_matches_general() {
    let mut next = rng(0xA11CE_5EED);
    for _ in 0..4096 {
        let a = next();
        let b = F128 {
            lo: next().lo,
            hi: 0,
        };
        assert_eq!(
            crate::field::gf2_128::mul_low_rhs(a, b),
            a * b,
            "a={a:?} b={b:?}"
        );
    }
    for a in [F128::ZERO, F128::ONE, next()] {
        for b in [
            F128::ZERO,
            F128::ONE,
            F128 {
                lo: u64::MAX,
                hi: 0,
            },
        ] {
            assert_eq!(crate::field::gf2_128::mul_low_rhs(a, b), a * b);
        }
    }
}

/// The specialized row-pair kernel must be bit-identical to the general
/// one on any low twiddle, through whichever backend this host dispatches.
#[test]
fn row_pair_low_matches_general() {
    let mut next = rng(0xB0B_5EED);
    for len in [1usize, 3, 4, 7, 8, 64] {
        let twiddle = F128 {
            lo: next().lo,
            hi: 0,
        };
        let top: Vec<F128> = (0..len).map(|_| next()).collect();
        let bot: Vec<F128> = (0..len).map(|_| next()).collect();
        let (mut t1, mut b1) = (top.clone(), bot.clone());
        let (mut t2, mut b2) = (top.clone(), bot.clone());
        #[cfg(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        ))]
        // SAFETY: cfg supplies the features; the twiddle's high limb is zero.
        unsafe {
            x86_64::butterfly_row_pair_gen::<true>(&mut t1, &mut b1, twiddle);
            x86_64::butterfly_row_pair_gen::<false>(&mut t2, &mut b2, twiddle);
        }
        #[cfg(not(all(
            target_arch = "x86_64",
            target_feature = "avx512f",
            target_feature = "vpclmulqdq"
        )))]
        {
            portable::butterfly_row_pair_gen::<true>(&mut t1, &mut b1, twiddle);
            portable::butterfly_row_pair_gen::<false>(&mut t2, &mut b2, twiddle);
        }
        assert_eq!(t1, t2, "len={len}");
        assert_eq!(b1, b2, "len={len}");
    }
}

/// Same for the fused pair, across all four low/general monomorphizations.
#[test]
fn fused_2layer_low_matches_general() {
    let mut next = rng(0xC0FFEE_5EED);
    for len in [1usize, 4, 5, 64] {
        let t_outer = F128 {
            lo: next().lo,
            hi: 0,
        };
        let t_a = F128 {
            lo: next().lo,
            hi: 0,
        };
        let t_b = F128 {
            lo: next().lo,
            hi: 0,
        };
        let rows: Vec<Vec<F128>> = (0..4).map(|_| (0..len).map(|_| next()).collect()).collect();
        let run = |outer_low: bool, inner_low: bool| -> Vec<Vec<F128>> {
            let mut r: Vec<Vec<F128>> = rows.clone();
            let (a, rest) = r.split_at_mut(1);
            let (b, rest) = rest.split_at_mut(1);
            let (c, d) = rest.split_at_mut(1);
            let (a, b, c, d) = (&mut a[0], &mut b[0], &mut c[0], &mut d[0]);
            macro_rules! call {
                ($o:expr, $i:expr) => {{
                    #[cfg(all(
                        target_arch = "x86_64",
                        target_feature = "avx512f",
                        target_feature = "vpclmulqdq"
                    ))]
                    // SAFETY: cfg supplies features; both twiddle sets have zero high limbs.
                    unsafe {
                        x86_64::butterfly_fused_2layer_gen::<$o, $i>(a, b, c, d, t_outer, t_a, t_b)
                    }
                    #[cfg(not(all(
                        target_arch = "x86_64",
                        target_feature = "avx512f",
                        target_feature = "vpclmulqdq"
                    )))]
                    portable::butterfly_fused_2layer_gen::<$o, $i>(a, b, c, d, t_outer, t_a, t_b)
                }};
            }
            match (outer_low, inner_low) {
                (false, false) => call!(false, false),
                (false, true) => call!(false, true),
                (true, false) => call!(true, false),
                (true, true) => call!(true, true),
            }
            r
        };
        let reference = run(false, false);
        for (o, i) in [(false, true), (true, false), (true, true)] {
            assert_eq!(
                run(o, i),
                reference,
                "len={len} outer_low={o} inner_low={i}"
            );
        }
    }
}
