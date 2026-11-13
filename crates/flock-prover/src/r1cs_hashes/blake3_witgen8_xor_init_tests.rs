//! First-write versus zero-initialized accumulation; no claim to detect optimized UB.
use super::*;
use core::mem::MaybeUninit;

unsafe fn check<const MODE: u8, const PRUNE: bool>(t: &Tables, case: usize) {
    unsafe {
        let a = core::array::from_fn::<_, 8, _>(|i| (i as u64 + 1).wrapping_mul(0x123456789abcdef).rotate_left(case as u32));
        let b = core::array::from_fn::<_, 8, _>(|i| (i as u64 + 7).wrapping_mul(0xfedcba987654321).rotate_right(case as u32));
        let m = t.0.as_ptr();
        let mut fresh = [MaybeUninit::<__m512i>::uninit(); 8];
        let zero = _mm512_setzero_si512();
        let poison = _mm512_set1_epi8(0x5a);
        let mut control = [MaybeUninit::new(zero); 8];
        let mut poisoned = [MaybeUninit::new(poison); 8];
        row_product::<MODE, true, PRUNE>(a.as_ptr(), b.as_ptr(), m, m, &mut fresh);
        row_product::<MODE, false, PRUNE>(a.as_ptr(), b.as_ptr(), m, m, &mut control);
        row_product::<MODE, true, PRUNE>(a.as_ptr(), b.as_ptr(), m, m, &mut poisoned);
        for i in 0..8 {
            let f: [u8; 64] = core::mem::transmute(fresh[i].assume_init());
            let c: [u8; 64] = core::mem::transmute(control[i].assume_init());
            let p: [u8; 64] = core::mem::transmute(poisoned[i].assume_init());
            assert_eq!(f, c, "first/zero mode={MODE} prune={PRUNE} case={case} slot={i}");
            assert_eq!(p, c, "first/poison mode={MODE} prune={PRUNE} case={case} slot={i}");
        }
        row_product::<MODE, false, PRUNE>(a.as_ptr(), b.as_ptr(), m, m, &mut fresh);
        for slot in fresh {
            let actual: [u8; 64] = core::mem::transmute(slot.assume_init());
            assert_eq!(actual, [0; 64], "second equal contribution must cancel");
        }
    }
}

#[test]
fn first_writer_initializes_every_accumulator_slot() {
    unsafe {
        let ns = flock_core::ntt::AdditiveNttGf8::new(6, flock_core::field::F8::ZERO);
        let nl = flock_core::ntt::AdditiveNttGf8::new(6, flock_core::field::F8(64));
        let table = InvNttTableByteSingleGf8::new(&ns, &nl);
        let t = Tables::new(&table);
        macro_rules! modes {
            ($($m:literal),*) => { $(for case in [0, 1, 7, 31, 63] {
                check::<$m, false>(&t, case);
                check::<$m, true>(&t, case);
            })* };
        }
        modes!(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        println!("160 row cases: fresh/zero/poison equality and second-write cancellation, all 8 slots");
    }
}
