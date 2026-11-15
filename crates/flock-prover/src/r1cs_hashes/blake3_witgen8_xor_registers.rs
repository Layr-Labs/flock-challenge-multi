//! Private Linux kernel: inputs RDI/RSI=data, RDX/RCX=coefficient banks.
//! ZMM0..19 are scratch; ZMM24..31 carry the eight accumulators. All GPRs
//! and ZMM20..23 are preserved. FIRST initializes all eight outputs. The kernel
//! reads only input memory, with no explicit stack use or output stores;
//! CALL/RET uses the private return-address stack permitted by readonly.
use super::*;
core::arch::global_asm!(include_str!("blake3_witgen8_xor_registers.S"),options(raw));
unsafe extern "C" {fn flock_family19_mixedp20_first();fn flock_family19_mixedp20_next();}
// Register feed (default; FLOCK_NO_PROJ_REG_FEED keeps `run`): the same kernels
// with the prepared A/B row vectors in ZMM20/ZMM21 instead of a stack round trip.
core::arch::global_asm!(include_str!("blake3_witgen8_xor_registers_zr.S"),options(raw));
unsafe extern "C" {fn flock_family19_mixedp20_first_zr();fn flock_family19_mixedp20_next_zr();}
/// `va`/`vb` are the 64-byte vectors `run` would read at `ap`/`bp`. The kernel
/// preserves ZMM20..23, so the inputs are not clobbers.
#[inline(always)]
pub(super) unsafe fn run_zr<const FIRST:bool>(va:__m512i,vb:__m512i,ma:*const u64,mb:*const u64,acc:[__m512i;8])->[__m512i;8]{unsafe{
 let [mut a0,mut a1,mut a2,mut a3,mut a4,mut a5,mut a6,mut a7]=acc;
if FIRST {
core::arch::asm!("call {kernel}",kernel=sym flock_family19_mixedp20_first_zr,
in("zmm20")va,in("zmm21")vb,in("rdx")ma,in("rcx")mb,
out("zmm24")a0,out("zmm25")a1,out("zmm26")a2,out("zmm27")a3,
out("zmm28")a4,out("zmm29")a5,out("zmm30")a6,out("zmm31")a7,
out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,out("zmm4")_,
out("zmm5")_,out("zmm6")_,out("zmm7")_,out("zmm8")_,out("zmm9")_,
out("zmm10")_,out("zmm11")_,out("zmm12")_,out("zmm13")_,out("zmm14")_,
out("zmm15")_,out("zmm16")_,out("zmm17")_,out("zmm18")_,out("zmm19")_,
options(pure,readonly));
}else{
core::arch::asm!("call {kernel}",kernel=sym flock_family19_mixedp20_next_zr,
in("zmm20")va,in("zmm21")vb,in("rdx")ma,in("rcx")mb,
inout("zmm24")a0,inout("zmm25")a1,inout("zmm26")a2,inout("zmm27")a3,
inout("zmm28")a4,inout("zmm29")a5,inout("zmm30")a6,inout("zmm31")a7,
out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,out("zmm4")_,
out("zmm5")_,out("zmm6")_,out("zmm7")_,out("zmm8")_,out("zmm9")_,
out("zmm10")_,out("zmm11")_,out("zmm12")_,out("zmm13")_,out("zmm14")_,
out("zmm15")_,out("zmm16")_,out("zmm17")_,out("zmm18")_,out("zmm19")_,
options(pure,readonly));
}
[a0,a1,a2,a3,a4,a5,a6,a7]
}}
#[inline(always)]
pub(super) unsafe fn run<const FIRST:bool>(ap:*const u64,bp:*const u64,ma:*const u64,mb:*const u64,acc:[__m512i;8])->[__m512i;8]{unsafe{
 let [mut a0,mut a1,mut a2,mut a3,mut a4,mut a5,mut a6,mut a7]=acc;
if FIRST {
core::arch::asm!("call {kernel}",kernel=sym flock_family19_mixedp20_first,
in("rdi")ap,in("rsi")bp,in("rdx")ma,in("rcx")mb,
out("zmm24")a0,
out("zmm25")a1,
out("zmm26")a2,
out("zmm27")a3,
out("zmm28")a4,
out("zmm29")a5,
out("zmm30")a6,
out("zmm31")a7,
out("zmm0")_,
out("zmm1")_,
out("zmm2")_,
out("zmm3")_,
out("zmm4")_,
out("zmm5")_,
out("zmm6")_,
out("zmm7")_,
out("zmm8")_,
out("zmm9")_,
out("zmm10")_,
out("zmm11")_,
out("zmm12")_,
out("zmm13")_,
out("zmm14")_,
out("zmm15")_,
out("zmm16")_,
out("zmm17")_,
out("zmm18")_,
out("zmm19")_,
options(pure,readonly));
}else{
core::arch::asm!("call {kernel}",kernel=sym flock_family19_mixedp20_next,
in("rdi")ap,in("rsi")bp,in("rdx")ma,in("rcx")mb,
inout("zmm24")a0,
inout("zmm25")a1,
inout("zmm26")a2,
inout("zmm27")a3,
inout("zmm28")a4,
inout("zmm29")a5,
inout("zmm30")a6,
inout("zmm31")a7,
out("zmm0")_,
out("zmm1")_,
out("zmm2")_,
out("zmm3")_,
out("zmm4")_,
out("zmm5")_,
out("zmm6")_,
out("zmm7")_,
out("zmm8")_,
out("zmm9")_,
out("zmm10")_,
out("zmm11")_,
out("zmm12")_,
out("zmm13")_,
out("zmm14")_,
out("zmm15")_,
out("zmm16")_,
out("zmm17")_,
out("zmm18")_,
out("zmm19")_,
options(pure,readonly));
}
[a0,a1,a2,a3,a4,a5,a6,a7]
}}

#[cfg(test)]
mod zr_tests {
    use super::*;

    /// The register-fed kernels equal the memory-fed ones bit for bit, for
    /// random inputs, coefficient banks and incoming accumulators.
    #[test]
    fn register_feed_matches_memory_feed() {
        #[repr(align(64))]
        struct Q([u64; 8]);
        let mut s = 0x9e37_79b9_7f4a_7c15u64;
        let mut next = move || {
            s ^= s << 13;
            s ^= s >> 7;
            s ^= s << 17;
            s
        };
        for case in 0..512 {
            let ap = Q(core::array::from_fn(|_| next()));
            let bp = Q(core::array::from_fn(|_| next()));
            // The kernels read banks [0x400, 0x8c0) bytes past RDX and RCX.
            let ma: Vec<u64> = (0..280).map(|_| next()).collect();
            let mb: Vec<u64> = (0..280).map(|_| next()).collect();
            let raw: [u64; 64] = core::array::from_fn(|_| next());
            unsafe {
                let acc: [__m512i; 8] =
                    core::array::from_fn(|i| _mm512_loadu_si512(raw.as_ptr().add(8 * i).cast()));
                let va = _mm512_load_si512(ap.0.as_ptr().cast());
                let vb = _mm512_load_si512(bp.0.as_ptr().cast());
                let words = |v: [__m512i; 8]| core::mem::transmute::<[__m512i; 8], [u64; 64]>(v);
                let want = words(run::<true>(ap.0.as_ptr(), bp.0.as_ptr(), ma.as_ptr(), mb.as_ptr(), acc));
                let got = words(run_zr::<true>(va, vb, ma.as_ptr(), mb.as_ptr(), acc));
                assert_eq!(got, want, "first case={case}");
                let want = words(run::<false>(ap.0.as_ptr(), bp.0.as_ptr(), ma.as_ptr(), mb.as_ptr(), acc));
                let got = words(run_zr::<false>(va, vb, ma.as_ptr(), mb.as_ptr(), acc));
                assert_eq!(got, want, "next case={case}");
            }
        }
    }
}
