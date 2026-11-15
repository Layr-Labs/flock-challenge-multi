//! Private 64-column NTT layout: exchange the column halves on odd-parity rows.
//! Arithmetic and the fixed-register four-layer schedule derive from the
//! adjacent incumbent x86_64 module. Only publication/consumption addresses
//! change. The final three-layer kernel loads paired halves before overwriting
//! either half, restoring canonical rows in place.
use super::*;
use core::arch::x86_64::*;

/// Publish four disjoint rows, swapping their halves according to MASK.
/// MASK is 6 or 9 for consecutive four-row NTT quads. Inactive columns
/// lanes..64 are contractual zeros and are initialized from a zero register.
#[inline]
pub(crate) unsafe fn publish<const ALIGNED:bool>(src:*const F128,step:usize,dst:[*mut F128;4],lanes:usize,t:[F128;3],flip:bool){unsafe{
 macro_rules! call {($mask:expr,$outer:expr,$inner:expr)=>{publish_impl::<$mask,$outer,$inner,true,ALIGNED>(src,step,dst[0],dst[1],dst[2],dst[3],lanes,t[0],t[1],t[2])};}
 macro_rules! select {($mask:expr)=>{match (t[0].hi==0,t[1].hi==0&&t[2].hi==0){
 (false,false)=>call!($mask,false,false),(false,true)=>call!($mask,false,true),
 (true,false)=>call!($mask,true,false),(true,true)=>call!($mask,true,true),
 }};}
 if flip{select!(9);}else{select!(6);}
}}

#[inline(always)]
unsafe fn publish_impl<const MASK:u8,
    const OUTER_LOW: bool,
    const INNER_LOW: bool,
    const DIET: bool,
    const ALIGNED_ZMM: bool,
>(
    src: *const F128,
    src_step: usize,
    dst_a: *mut F128,
    dst_b: *mut F128,
    dst_c: *mut F128,
    dst_d: *mut F128,
    lanes: usize,
    t_outer: F128,
    t_inner_a: F128,
    t_inner_b: F128,
) {
    use core::arch::x86_64::*;

    // SAFETY: the caller guarantees four readable scratch rows, four disjoint
    // 16-byte-aligned destinations, target features, and lanes in {60, 64}.
    unsafe {
        debug_assert!(lanes == 60 || lanes == 64);
        debug_assert!(!OUTER_LOW || t_outer.hi == 0);
        debug_assert!(!INNER_LOW || (t_inner_a.hi == 0 && t_inner_b.hi == 0));
        let a = src;
        let b = src.add(src_step);
        let c = src.add(2 * src_step);
        let d = src.add(3 * src_step);
        let outer = tw_x4::<OUTER_LOW, DIET>(t_outer);
        let inner_a = tw_x4::<INNER_LOW, DIET>(t_inner_a);
        let inner_b = tw_x4::<INNER_LOW, DIET>(t_inner_b);

        let mut i = 0;
        while i + 8 <= lanes {
            let mut va0 = _mm512_loadu_si512(a.add(i) as *const __m512i);
            let mut vb0 = _mm512_loadu_si512(b.add(i) as *const __m512i);
            let mut vc0 = _mm512_loadu_si512(c.add(i) as *const __m512i);
            let mut vd0 = _mm512_loadu_si512(d.add(i) as *const __m512i);

            let mut va1 = _mm512_loadu_si512(a.add(i + 4) as *const __m512i);
            let mut vb1 = _mm512_loadu_si512(b.add(i + 4) as *const __m512i);
            let mut vc1 = _mm512_loadu_si512(c.add(i + 4) as *const __m512i);
            let mut vd1 = _mm512_loadu_si512(d.add(i + 4) as *const __m512i);

            if DIET {
                (va0, vb0, vc0, vd0) = butterfly_2layer_diet_x4::<OUTER_LOW, INNER_LOW>(
                    outer, inner_a, inner_b, va0, vb0, vc0, vd0,
                );
                (va1, vb1, vc1, vd1) = butterfly_2layer_diet_x4::<OUTER_LOW, INNER_LOW>(
                    outer, inner_a, inner_b, va1, vb1, vc1, vd1,
                );
            } else {
                let new_a0 = _mm512_xor_si512(va0, mul_x4::<OUTER_LOW, DIET>(outer, vc0));
                let new_a1 = _mm512_xor_si512(va1, mul_x4::<OUTER_LOW, DIET>(outer, vc1));
                vc0 = _mm512_xor_si512(vc0, new_a0);
                vc1 = _mm512_xor_si512(vc1, new_a1);
                va0 = new_a0;
                va1 = new_a1;

                let new_b0 = _mm512_xor_si512(vb0, mul_x4::<OUTER_LOW, DIET>(outer, vd0));
                let new_b1 = _mm512_xor_si512(vb1, mul_x4::<OUTER_LOW, DIET>(outer, vd1));
                vd0 = _mm512_xor_si512(vd0, new_b0);
                vd1 = _mm512_xor_si512(vd1, new_b1);
                vb0 = new_b0;
                vb1 = new_b1;

                let new_a0 = _mm512_xor_si512(va0, mul_x4::<INNER_LOW, DIET>(inner_a, vb0));
                let new_a1 = _mm512_xor_si512(va1, mul_x4::<INNER_LOW, DIET>(inner_a, vb1));
                vb0 = _mm512_xor_si512(vb0, new_a0);
                vb1 = _mm512_xor_si512(vb1, new_a1);
                va0 = new_a0;
                va1 = new_a1;

                let new_c0 = _mm512_xor_si512(vc0, mul_x4::<INNER_LOW, DIET>(inner_b, vd0));
                let new_c1 = _mm512_xor_si512(vc1, mul_x4::<INNER_LOW, DIET>(inner_b, vd1));
                vd0 = _mm512_xor_si512(vd0, new_c0);
                vd1 = _mm512_xor_si512(vd1, new_c1);
                vc0 = new_c0;
                vc1 = new_c1;
            }

            stream_f128x4::<ALIGNED_ZMM>(dst_a.add((i) ^ (if MASK & 1 != 0 {32} else {0})), va0);
            stream_f128x4::<ALIGNED_ZMM>(dst_b.add((i) ^ (if MASK & 2 != 0 {32} else {0})), vb0);
            stream_f128x4::<ALIGNED_ZMM>(dst_c.add((i) ^ (if MASK & 4 != 0 {32} else {0})), vc0);
            stream_f128x4::<ALIGNED_ZMM>(dst_d.add((i) ^ (if MASK & 8 != 0 {32} else {0})), vd0);

            stream_f128x4::<ALIGNED_ZMM>(dst_a.add((i + 4) ^ (if MASK & 1 != 0 {32} else {0})), va1);
            stream_f128x4::<ALIGNED_ZMM>(dst_b.add((i + 4) ^ (if MASK & 2 != 0 {32} else {0})), vb1);
            stream_f128x4::<ALIGNED_ZMM>(dst_c.add((i + 4) ^ (if MASK & 4 != 0 {32} else {0})), vc1);
            stream_f128x4::<ALIGNED_ZMM>(dst_d.add((i + 4) ^ (if MASK & 8 != 0 {32} else {0})), vd1);
            i += 8;
        }
        while i < lanes {
            let mut va = _mm512_loadu_si512(a.add(i) as *const __m512i);
            let mut vb = _mm512_loadu_si512(b.add(i) as *const __m512i);
            let mut vc = _mm512_loadu_si512(c.add(i) as *const __m512i);
            let mut vd = _mm512_loadu_si512(d.add(i) as *const __m512i);

            if DIET {
                (va, vb, vc, vd) = butterfly_2layer_diet_x4::<OUTER_LOW, INNER_LOW>(
                    outer, inner_a, inner_b, va, vb, vc, vd,
                );
            } else {
                let new_a = _mm512_xor_si512(va, mul_x4::<OUTER_LOW, DIET>(outer, vc));
                vc = _mm512_xor_si512(vc, new_a);
                va = new_a;
                let new_b = _mm512_xor_si512(vb, mul_x4::<OUTER_LOW, DIET>(outer, vd));
                vd = _mm512_xor_si512(vd, new_b);
                vb = new_b;

                let new_a = _mm512_xor_si512(va, mul_x4::<INNER_LOW, DIET>(inner_a, vb));
                vb = _mm512_xor_si512(vb, new_a);
                va = new_a;
                let new_c = _mm512_xor_si512(vc, mul_x4::<INNER_LOW, DIET>(inner_b, vd));
                vd = _mm512_xor_si512(vd, new_c);
                vc = new_c;
            }

            stream_f128x4::<ALIGNED_ZMM>(dst_a.add((i) ^ (if MASK & 1 != 0 {32} else {0})), va);
            stream_f128x4::<ALIGNED_ZMM>(dst_b.add((i) ^ (if MASK & 2 != 0 {32} else {0})), vb);
            stream_f128x4::<ALIGNED_ZMM>(dst_c.add((i) ^ (if MASK & 4 != 0 {32} else {0})), vc);
            stream_f128x4::<ALIGNED_ZMM>(dst_d.add((i) ^ (if MASK & 8 != 0 {32} else {0})), vd);
            i += 4;
        }

        // The exact-shape caller reaches i=60 only for odd_tail=4. That value is
        // published from the R1CS padding descriptor, so lanes 60..64 are
        // contractually zero. Publish a zero register: every destination byte
        // is initialized, with no dependency or reload from the scratch suffix.
        if i < 64 {
            debug_assert_eq!(i, 60);
            let zero = _mm512_setzero_si512();
            stream_f128x4::<ALIGNED_ZMM>(dst_a.add((i) ^ (if MASK & 1 != 0 {32} else {0})), zero);
            stream_f128x4::<ALIGNED_ZMM>(dst_b.add((i) ^ (if MASK & 2 != 0 {32} else {0})), zero);
            stream_f128x4::<ALIGNED_ZMM>(dst_c.add((i) ^ (if MASK & 4 != 0 {32} else {0})), zero);
            stream_f128x4::<ALIGNED_ZMM>(dst_d.add((i) ^ (if MASK & 8 != 0 {32} else {0})), zero);
        }
    }
}
/// Sixteen initialized 64-column rows, in the private parity layout.
/// Row spacing S must be a power of two, with disjoint rows. Prefetch addresses
/// have the same geometry. This kernel preserves the private layout.
#[inline]
pub(crate) unsafe fn four<const S:usize>(ptr:*mut F128,prepared:&PreparedFour,hint:u8,prefetch:*const F128){unsafe{
 macro_rules! call {($h:expr)=>{{
 four_kernel::<512,S,64,$h,1>(ptr,prepared,512,prefetch);
 four_kernel::<-512,S,64,$h,1>(ptr.add(32),prepared,512,prefetch.add(32));
 }};}
 match hint{1=>call!(1),2=>call!(2),_=>call!(0)}
}}

unsafe fn four_kernel<const COLOR: isize, const S16: usize, const NN: usize, const H: u8, const ORD: u8>(
    ptr: *mut F128,
    prepared: *const PreparedFour,
    vector_bytes: usize,
    prefetch: *const F128,
) {
    // SAFETY: the caller establishes all storage and ISA preconditions.
    // All clobbered vector registers, flags and rax are declared. Memory is
    // both read and written; nostack only asserts that this block uses no
    // stack space. No options claim purity or read-only memory.
    unsafe {
        core::arch::asm!(
            "test rdx, rdx",
            "jz 3f",
            "vbroadcasti32x4 zmm16, [rsi+0]",
            "vbroadcasti32x4 zmm17, [rsi+16]",
            "mov eax, 0x87",
            "vmovq xmm30, rax",
            "vshufi32x4 zmm30, zmm30, zmm30, 0",
            "vbroadcasti32x4 zmm18, [rsi+32]",
            "vbroadcasti32x4 zmm19, [rsi+48]",
            "vbroadcasti32x4 zmm20, [rsi+64]",
            "vbroadcasti32x4 zmm21, [rsi+80]",
            "xor eax, eax",
            ".p2align 5",
            "2:",
            // Load order (`ord`). In the two deep fused-four sweeps the 16 rows of a group are a multiple of
            // 4 KiB apart, so the 16 lines of one lane step fall into ONE set of the 12-way L1D and four of
            // them are always out of L1 when their turn comes. The near hint fetched rows 0..15 in that
            // order, so the set has already dropped rows 0..3. ord == 1 loads rows 12..15 first (their
            // stores come last), then 4..11, and rows 0..3 last: the four L1 misses then evict only rows
            // whose value is already in a register and whose store is the last of the step, instead of
            // rows that are about to be loaded. The 16 loads are independent, so the register contents,
            // and with them every output byte, are the same for either order.
            ".if {ord} == 1",
            "vmovdqu64 zmm12, [rdi+rax+{stride}*12]",
            "vmovdqu64 zmm13, [rdi+rax+{stride}*13 + {color}]",
            "vmovdqu64 zmm14, [rdi+rax+{stride}*14 + {color}]",
            "vmovdqu64 zmm15, [rdi+rax+{stride}*15]",
            "vmovdqu64 zmm4, [rdi+rax+{stride}*4 + {color}]",
            "vmovdqu64 zmm5, [rdi+rax+{stride}*5]",
            "vmovdqu64 zmm6, [rdi+rax+{stride}*6]",
            "vmovdqu64 zmm7, [rdi+rax+{stride}*7 + {color}]",
            "vmovdqu64 zmm8, [rdi+rax+{stride}*8 + {color}]",
            "vmovdqu64 zmm9, [rdi+rax+{stride}*9]",
            "vmovdqu64 zmm10, [rdi+rax+{stride}*10]",
            "vmovdqu64 zmm11, [rdi+rax+{stride}*11 + {color}]",
            "vmovdqu64 zmm0, [rdi+rax+{stride}*0]",
            "vmovdqu64 zmm1, [rdi+rax+{stride}*1 + {color}]",
            "vmovdqu64 zmm2, [rdi+rax+{stride}*2 + {color}]",
            "vmovdqu64 zmm3, [rdi+rax+{stride}*3]",
            ".else",
            "vmovdqu64 zmm0, [rdi+rax+{stride}*0]",
            "vmovdqu64 zmm1, [rdi+rax+{stride}*1 + {color}]",
            "vmovdqu64 zmm2, [rdi+rax+{stride}*2 + {color}]",
            "vmovdqu64 zmm3, [rdi+rax+{stride}*3]",
            "vmovdqu64 zmm4, [rdi+rax+{stride}*4 + {color}]",
            "vmovdqu64 zmm5, [rdi+rax+{stride}*5]",
            "vmovdqu64 zmm6, [rdi+rax+{stride}*6]",
            "vmovdqu64 zmm7, [rdi+rax+{stride}*7 + {color}]",
            "vmovdqu64 zmm8, [rdi+rax+{stride}*8 + {color}]",
            "vmovdqu64 zmm9, [rdi+rax+{stride}*9]",
            "vmovdqu64 zmm10, [rdi+rax+{stride}*10]",
            "vmovdqu64 zmm11, [rdi+rax+{stride}*11 + {color}]",
            "vmovdqu64 zmm12, [rdi+rax+{stride}*12]",
            "vmovdqu64 zmm13, [rdi+rax+{stride}*13 + {color}]",
            "vmovdqu64 zmm14, [rdi+rax+{stride}*14 + {color}]",
            "vmovdqu64 zmm15, [rdi+rax+{stride}*15]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*0]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*0]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*1 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*1 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*2 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*2 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*3]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*3]",
            ".endif",
            "vpclmulqdq zmm22, zmm12, zmm16, 0",
            "vpclmulqdq zmm23, zmm12, zmm17, 1",
            "vpternlogd zmm4, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm13, zmm16, 0",
            "vpclmulqdq zmm23, zmm13, zmm17, 1",
            "vpternlogd zmm5, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm14, zmm16, 0",
            "vpclmulqdq zmm23, zmm14, zmm17, 1",
            "vpternlogd zmm6, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm15, zmm16, 0",
            "vpclmulqdq zmm23, zmm15, zmm17, 1",
            "vpternlogd zmm7, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm12, zmm16, 16",
            "vpclmulqdq zmm23, zmm12, zmm17, 17",
            "vpclmulqdq zmm24, zmm13, zmm16, 16",
            "vpclmulqdq zmm25, zmm13, zmm17, 17",
            "vpclmulqdq zmm26, zmm14, zmm16, 16",
            "vpclmulqdq zmm27, zmm14, zmm17, 17",
            "vpclmulqdq zmm28, zmm15, zmm16, 16",
            "vpclmulqdq zmm29, zmm15, zmm17, 17",
            "vpxorq zmm22, zmm22, zmm23",
            "vpxorq zmm23, zmm24, zmm25",
            "vpxorq zmm24, zmm26, zmm27",
            "vpxorq zmm25, zmm28, zmm29",
            "vpslldq zmm26, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpternlogd zmm4, zmm22, zmm26, 0x96",
            "vpxorq zmm12, zmm12, zmm4",
            "vpslldq zmm22, zmm23, 8",
            "vpclmulqdq zmm23, zmm23, zmm30, 1",
            "vpternlogd zmm5, zmm23, zmm22, 0x96",
            "vpxorq zmm13, zmm13, zmm5",
            "vpslldq zmm22, zmm24, 8",
            "vpclmulqdq zmm23, zmm24, zmm30, 1",
            "vpternlogd zmm6, zmm23, zmm22, 0x96",
            "vpxorq zmm14, zmm14, zmm6",
            "vpslldq zmm22, zmm25, 8",
            "vpclmulqdq zmm23, zmm25, zmm30, 1",
            "vpternlogd zmm7, zmm23, zmm22, 0x96",
            "vpxorq zmm15, zmm15, zmm7",
            "vpclmulqdq zmm22, zmm8, zmm16, 0",
            "vpclmulqdq zmm23, zmm8, zmm17, 1",
            "vpternlogd zmm0, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm9, zmm16, 0",
            "vpclmulqdq zmm23, zmm9, zmm17, 1",
            "vpternlogd zmm1, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm10, zmm16, 0",
            "vpclmulqdq zmm23, zmm10, zmm17, 1",
            "vpternlogd zmm2, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm11, zmm16, 0",
            "vpclmulqdq zmm23, zmm11, zmm17, 1",
            "vpternlogd zmm3, zmm22, zmm23, 0x96",
            "vpclmulqdq zmm22, zmm8, zmm16, 16",
            "vpclmulqdq zmm23, zmm8, zmm17, 17",
            "vpclmulqdq zmm24, zmm9, zmm16, 16",
            "vpclmulqdq zmm25, zmm9, zmm17, 17",
            "vpclmulqdq zmm26, zmm10, zmm16, 16",
            "vpclmulqdq zmm27, zmm10, zmm17, 17",
            "vpclmulqdq zmm28, zmm11, zmm16, 16",
            "vpclmulqdq zmm29, zmm11, zmm17, 17",
            "vpxorq zmm22, zmm22, zmm23",
            "vpxorq zmm23, zmm24, zmm25",
            "vpxorq zmm24, zmm26, zmm27",
            "vpxorq zmm25, zmm28, zmm29",
            "vpxorq zmm8, zmm8, zmm0",
            "vpxorq zmm9, zmm9, zmm1",
            "vpxorq zmm10, zmm10, zmm2",
            "vpxorq zmm11, zmm11, zmm3",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*4 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*4 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*5]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*5]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*6]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*6]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*7 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*7 + {color}]",
            ".endif",
            "vpclmulqdq zmm26, zmm14, zmm20, 0",
            "vpclmulqdq zmm27, zmm14, zmm21, 1",
            "vpternlogd zmm10, zmm26, zmm27, 0x96",
            "vpclmulqdq zmm26, zmm15, zmm20, 0",
            "vpclmulqdq zmm27, zmm15, zmm21, 1",
            "vpternlogd zmm11, zmm26, zmm27, 0x96",
            "vpclmulqdq zmm26, zmm14, zmm20, 16",
            "vpclmulqdq zmm27, zmm14, zmm21, 17",
            "vpclmulqdq zmm28, zmm15, zmm20, 16",
            "vpclmulqdq zmm29, zmm15, zmm21, 17",
            "vpternlogd zmm26, zmm27, zmm24, 0x96",
            "vpternlogd zmm28, zmm29, zmm25, 0x96",
            "vpslldq zmm27, zmm26, 8",
            "vpclmulqdq zmm26, zmm26, zmm30, 1",
            "vpternlogd zmm10, zmm26, zmm27, 0x96",
            "vpxorq zmm14, zmm14, zmm10",
            "vpslldq zmm26, zmm28, 8",
            "vpclmulqdq zmm27, zmm28, zmm30, 1",
            "vpternlogd zmm11, zmm27, zmm26, 0x96",
            "vpxorq zmm15, zmm15, zmm11",
            "vpclmulqdq zmm26, zmm6, zmm18, 0",
            "vpclmulqdq zmm27, zmm6, zmm19, 1",
            "vpternlogd zmm2, zmm26, zmm27, 0x96",
            "vpclmulqdq zmm26, zmm7, zmm18, 0",
            "vpclmulqdq zmm27, zmm7, zmm19, 1",
            "vpternlogd zmm3, zmm26, zmm27, 0x96",
            "vpclmulqdq zmm26, zmm6, zmm18, 16",
            "vpclmulqdq zmm27, zmm6, zmm19, 17",
            "vpclmulqdq zmm28, zmm7, zmm18, 16",
            "vpclmulqdq zmm29, zmm7, zmm19, 17",
            "vpternlogd zmm24, zmm26, zmm27, 0x96",
            "vpternlogd zmm25, zmm28, zmm29, 0x96",
            "vpslldq zmm26, zmm24, 8",
            "vpclmulqdq zmm24, zmm24, zmm30, 1",
            "vpternlogd zmm2, zmm24, zmm26, 0x96",
            "vpxorq zmm6, zmm6, zmm2",
            "vpslldq zmm24, zmm25, 8",
            "vpclmulqdq zmm25, zmm25, zmm30, 1",
            "vpternlogd zmm3, zmm25, zmm24, 0x96",
            "vpxorq zmm7, zmm7, zmm3",
            "vpclmulqdq zmm24, zmm12, zmm20, 0",
            "vpclmulqdq zmm25, zmm12, zmm21, 1",
            "vpternlogd zmm8, zmm24, zmm25, 0x96",
            "vpclmulqdq zmm24, zmm13, zmm20, 0",
            "vpclmulqdq zmm25, zmm13, zmm21, 1",
            "vpternlogd zmm9, zmm24, zmm25, 0x96",
            "vpclmulqdq zmm24, zmm12, zmm20, 16",
            "vpclmulqdq zmm25, zmm12, zmm21, 17",
            "vpclmulqdq zmm26, zmm13, zmm20, 16",
            "vpclmulqdq zmm27, zmm13, zmm21, 17",
            "vpternlogd zmm24, zmm25, zmm22, 0x96",
            "vpternlogd zmm26, zmm27, zmm23, 0x96",
            "vpxorq zmm12, zmm12, zmm8",
            "vpxorq zmm13, zmm13, zmm9",
            "vpclmulqdq zmm25, zmm4, zmm18, 0",
            "vpclmulqdq zmm27, zmm4, zmm19, 1",
            "vpternlogd zmm0, zmm25, zmm27, 0x96",
            "vpclmulqdq zmm25, zmm5, zmm18, 0",
            "vpclmulqdq zmm27, zmm5, zmm19, 1",
            "vpternlogd zmm1, zmm25, zmm27, 0x96",
            "vpclmulqdq zmm25, zmm4, zmm18, 16",
            "vpclmulqdq zmm27, zmm4, zmm19, 17",
            "vpclmulqdq zmm28, zmm5, zmm18, 16",
            "vpclmulqdq zmm29, zmm5, zmm19, 17",
            "vpternlogd zmm22, zmm25, zmm27, 0x96",
            "vpternlogd zmm23, zmm28, zmm29, 0x96",
            "vpxorq zmm4, zmm4, zmm0",
            "vpxorq zmm5, zmm5, zmm1",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*8 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*8 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*9]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*9]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*10]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*10]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*11 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*11 + {color}]",
            ".endif",
            "vbroadcasti32x4 zmm25, [rsi+128]",
            "vbroadcasti32x4 zmm27, [rsi+144]",
            "vpclmulqdq zmm28, zmm7, zmm25, 0",
            "vpclmulqdq zmm29, zmm7, zmm27, 1",
            "vpternlogd zmm5, zmm28, zmm29, 0x96",
            "vpclmulqdq zmm28, zmm6, zmm25, 0",
            "vpclmulqdq zmm29, zmm6, zmm27, 1",
            "vpternlogd zmm4, zmm28, zmm29, 0x96",
            "vpclmulqdq zmm28, zmm7, zmm25, 16",
            "vpclmulqdq zmm29, zmm7, zmm27, 17",
            "vpclmulqdq zmm25, zmm6, zmm25, 16",
            "vpclmulqdq zmm27, zmm6, zmm27, 17",
            "vpternlogd zmm28, zmm29, zmm23, 0x96",
            "vpternlogd zmm25, zmm27, zmm22, 0x96",
            "vpslldq zmm27, zmm28, 8",
            "vpclmulqdq zmm28, zmm28, zmm30, 1",
            "vpternlogd zmm5, zmm28, zmm27, 0x96",
            "vpxorq zmm7, zmm7, zmm5",
            "vpxorq zmm6, zmm6, zmm4",
            "vbroadcasti32x4 zmm27, [rsi+96]",
            "vbroadcasti32x4 zmm28, [rsi+112]",
            "vpclmulqdq zmm29, zmm3, zmm27, 0",
            "vpclmulqdq zmm31, zmm3, zmm28, 1",
            "vpternlogd zmm1, zmm29, zmm31, 0x96",
            "vpclmulqdq zmm29, zmm2, zmm27, 0",
            "vpclmulqdq zmm31, zmm2, zmm28, 1",
            "vpternlogd zmm0, zmm29, zmm31, 0x96",
            "vpclmulqdq zmm29, zmm3, zmm27, 16",
            "vpclmulqdq zmm31, zmm3, zmm28, 17",
            "vpclmulqdq zmm27, zmm2, zmm27, 16",
            "vpclmulqdq zmm28, zmm2, zmm28, 17",
            "vpternlogd zmm23, zmm29, zmm31, 0x96",
            "vpternlogd zmm22, zmm27, zmm28, 0x96",
            "vpslldq zmm27, zmm23, 8",
            "vpclmulqdq zmm23, zmm23, zmm30, 1",
            "vpternlogd zmm1, zmm23, zmm27, 0x96",
            "vpxorq zmm3, zmm3, zmm1",
            "vpxorq zmm2, zmm2, zmm0",
            "vbroadcasti32x4 zmm23, [rsi+192]",
            "vbroadcasti32x4 zmm27, [rsi+208]",
            "vpclmulqdq zmm28, zmm15, zmm23, 0",
            "vpclmulqdq zmm29, zmm15, zmm27, 1",
            "vpternlogd zmm13, zmm28, zmm29, 0x96",
            "vpclmulqdq zmm28, zmm14, zmm23, 0",
            "vpclmulqdq zmm29, zmm14, zmm27, 1",
            "vpternlogd zmm12, zmm28, zmm29, 0x96",
            "vpclmulqdq zmm28, zmm15, zmm23, 16",
            "vpclmulqdq zmm29, zmm15, zmm27, 17",
            "vpclmulqdq zmm23, zmm14, zmm23, 16",
            "vpclmulqdq zmm27, zmm14, zmm27, 17",
            "vpternlogd zmm28, zmm29, zmm26, 0x96",
            "vpternlogd zmm23, zmm27, zmm24, 0x96",
            "vpslldq zmm27, zmm28, 8",
            "vpclmulqdq zmm28, zmm28, zmm30, 1",
            "vpternlogd zmm13, zmm28, zmm27, 0x96",
            "vpxorq zmm15, zmm15, zmm13",
            "vpxorq zmm14, zmm14, zmm12",
            "vbroadcasti32x4 zmm27, [rsi+160]",
            "vbroadcasti32x4 zmm28, [rsi+176]",
            "vpclmulqdq zmm29, zmm11, zmm27, 0",
            "vpclmulqdq zmm31, zmm11, zmm28, 1",
            "vpternlogd zmm9, zmm29, zmm31, 0x96",
            "vpclmulqdq zmm29, zmm10, zmm27, 0",
            "vpclmulqdq zmm31, zmm10, zmm28, 1",
            "vpternlogd zmm8, zmm29, zmm31, 0x96",
            "vpclmulqdq zmm29, zmm11, zmm27, 16",
            "vpclmulqdq zmm31, zmm11, zmm28, 17",
            "vpclmulqdq zmm27, zmm10, zmm27, 16",
            "vpclmulqdq zmm28, zmm10, zmm28, 17",
            "vpternlogd zmm26, zmm29, zmm31, 0x96",
            "vpternlogd zmm24, zmm27, zmm28, 0x96",
            "vpslldq zmm27, zmm26, 8",
            "vpclmulqdq zmm26, zmm26, zmm30, 1",
            "vpternlogd zmm9, zmm26, zmm27, 0x96",
            "vpxorq zmm11, zmm11, zmm9",
            "vpxorq zmm10, zmm10, zmm8",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*12]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*12]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*13 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*13 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*14 + {color}]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*14 + {color}]",
            ".endif",
            ".if {hint} == 1",
            "prefetcht0 [rcx+rax+{stride}*15]",
            ".elseif {hint} == 2",
            "prefetcht1 [rcx+rax+{stride}*15]",
            ".endif",
            "vbroadcasti32x4 zmm26, [rsi+256]",
            "vbroadcasti32x4 zmm27, [rsi+272]",
            "vpclmulqdq zmm28, zmm3, zmm26, 0",
            "vpclmulqdq zmm29, zmm3, zmm27, 1",
            "vpternlogd zmm2, zmm28, zmm29, 0x96",
            "vpclmulqdq zmm26, zmm3, zmm26, 16",
            "vpclmulqdq zmm27, zmm3, zmm27, 17",
            "vpternlogd zmm26, zmm27, zmm22, 0x96",
            "vbroadcasti32x4 zmm27, [rsi+224]",
            "vbroadcasti32x4 zmm28, [rsi+240]",
            "vpslldq zmm29, zmm26, 8",
            "vpclmulqdq zmm26, zmm26, zmm30, 1",
            "vpclmulqdq zmm31, zmm1, zmm27, 0",
            "vpternlogd zmm2, zmm26, zmm29, 0x96",
            "vpxorq zmm3, zmm3, zmm2",
            "vmovdqu64 [rdi+rax+{stride}*2 + {color}], zmm2",
            "vmovdqu64 [rdi+rax+{stride}*3], zmm3",
            "vpclmulqdq zmm26, zmm1, zmm28, 1",
            "vpternlogd zmm0, zmm31, zmm26, 0x96",
            "vpclmulqdq zmm26, zmm1, zmm27, 16",
            "vpclmulqdq zmm27, zmm1, zmm28, 17",
            "vpternlogd zmm26, zmm27, zmm22, 0x96",
            "vpslldq zmm22, zmm26, 8",
            "vpclmulqdq zmm26, zmm26, zmm30, 1",
            "vpternlogd zmm0, zmm26, zmm22, 0x96",
            "vpxorq zmm1, zmm1, zmm0",
            "vmovdqu64 [rdi+rax+{stride}*0], zmm0",
            "vmovdqu64 [rdi+rax+{stride}*1 + {color}], zmm1",
            "vbroadcasti32x4 zmm22, [rsi+320]",
            "vbroadcasti32x4 zmm26, [rsi+336]",
            "vpclmulqdq zmm27, zmm7, zmm22, 0",
            "vpclmulqdq zmm28, zmm7, zmm26, 1",
            "vpternlogd zmm6, zmm27, zmm28, 0x96",
            "vpclmulqdq zmm22, zmm7, zmm22, 16",
            "vpclmulqdq zmm26, zmm7, zmm26, 17",
            "vpternlogd zmm22, zmm26, zmm25, 0x96",
            "vbroadcasti32x4 zmm26, [rsi+288]",
            "vbroadcasti32x4 zmm27, [rsi+304]",
            "vpslldq zmm28, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpclmulqdq zmm29, zmm5, zmm26, 0",
            "vpternlogd zmm6, zmm22, zmm28, 0x96",
            "vpxorq zmm7, zmm7, zmm6",
            "vmovdqu64 [rdi+rax+{stride}*6], zmm6",
            "vmovdqu64 [rdi+rax+{stride}*7 + {color}], zmm7",
            "vpclmulqdq zmm22, zmm5, zmm27, 1",
            "vpternlogd zmm4, zmm29, zmm22, 0x96",
            "vpclmulqdq zmm22, zmm5, zmm26, 16",
            "vpclmulqdq zmm26, zmm5, zmm27, 17",
            "vpternlogd zmm22, zmm26, zmm25, 0x96",
            "vpslldq zmm25, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpternlogd zmm4, zmm22, zmm25, 0x96",
            "vpxorq zmm5, zmm5, zmm4",
            "vmovdqu64 [rdi+rax+{stride}*4 + {color}], zmm4",
            "vmovdqu64 [rdi+rax+{stride}*5], zmm5",
            "vbroadcasti32x4 zmm22, [rsi+384]",
            "vbroadcasti32x4 zmm25, [rsi+400]",
            "vpclmulqdq zmm26, zmm11, zmm22, 0",
            "vpclmulqdq zmm27, zmm11, zmm25, 1",
            "vpternlogd zmm10, zmm26, zmm27, 0x96",
            "vpclmulqdq zmm22, zmm11, zmm22, 16",
            "vpclmulqdq zmm25, zmm11, zmm25, 17",
            "vpternlogd zmm22, zmm25, zmm24, 0x96",
            "vbroadcasti32x4 zmm25, [rsi+352]",
            "vbroadcasti32x4 zmm26, [rsi+368]",
            "vpslldq zmm27, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpclmulqdq zmm28, zmm9, zmm25, 0",
            "vpternlogd zmm10, zmm22, zmm27, 0x96",
            "vpxorq zmm11, zmm11, zmm10",
            "vmovdqu64 [rdi+rax+{stride}*10], zmm10",
            "vmovdqu64 [rdi+rax+{stride}*11 + {color}], zmm11",
            "vpclmulqdq zmm22, zmm9, zmm26, 1",
            "vpternlogd zmm8, zmm28, zmm22, 0x96",
            "vpclmulqdq zmm22, zmm9, zmm25, 16",
            "vpclmulqdq zmm25, zmm9, zmm26, 17",
            "vpternlogd zmm22, zmm25, zmm24, 0x96",
            "vpslldq zmm24, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpternlogd zmm8, zmm22, zmm24, 0x96",
            "vpxorq zmm9, zmm9, zmm8",
            "vmovdqu64 [rdi+rax+{stride}*8 + {color}], zmm8",
            "vmovdqu64 [rdi+rax+{stride}*9], zmm9",
            "vbroadcasti32x4 zmm22, [rsi+448]",
            "vbroadcasti32x4 zmm24, [rsi+464]",
            "vpclmulqdq zmm25, zmm15, zmm22, 0",
            "vpclmulqdq zmm26, zmm15, zmm24, 1",
            "vpternlogd zmm14, zmm25, zmm26, 0x96",
            "vpclmulqdq zmm22, zmm15, zmm22, 16",
            "vpclmulqdq zmm24, zmm15, zmm24, 17",
            "vpternlogd zmm22, zmm24, zmm23, 0x96",
            "vbroadcasti32x4 zmm24, [rsi+416]",
            "vbroadcasti32x4 zmm25, [rsi+432]",
            "vpslldq zmm26, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpclmulqdq zmm27, zmm13, zmm24, 0",
            "vpternlogd zmm14, zmm22, zmm26, 0x96",
            "vpxorq zmm15, zmm15, zmm14",
            "vmovdqu64 [rdi+rax+{stride}*14 + {color}], zmm14",
            "vmovdqu64 [rdi+rax+{stride}*15], zmm15",
            "vpclmulqdq zmm22, zmm13, zmm25, 1",
            "vpternlogd zmm12, zmm27, zmm22, 0x96",
            "vpclmulqdq zmm22, zmm13, zmm24, 16",
            "vpclmulqdq zmm24, zmm13, zmm25, 17",
            "vpternlogd zmm22, zmm24, zmm23, 0x96",
            "vpslldq zmm23, zmm22, 8",
            "vpclmulqdq zmm22, zmm22, zmm30, 1",
            "vpternlogd zmm12, zmm22, zmm23, 0x96",
            "vpxorq zmm13, zmm13, zmm12",
            "vmovdqu64 [rdi+rax+{stride}*12], zmm12",
            "vmovdqu64 [rdi+rax+{stride}*13 + {color}], zmm13",
            "add rax, 64",
            "cmp rax, rdx",
            "jb 2b",
            "3:",
            color = const COLOR,
            stride = const S16 * NN * core::mem::size_of::<F128>(),
            hint = const H,
            ord = const ORD,
            in("rdi") ptr,
            in("rsi") prepared,
            in("rdx") vector_bytes,
            in("rcx") prefetch,
            out("rax") _,
            out("zmm0") _,
            out("zmm1") _,
            out("zmm2") _,
            out("zmm3") _,
            out("zmm4") _,
            out("zmm5") _,
            out("zmm6") _,
            out("zmm7") _,
            out("zmm8") _,
            out("zmm9") _,
            out("zmm10") _,
            out("zmm11") _,
            out("zmm12") _,
            out("zmm13") _,
            out("zmm14") _,
            out("zmm15") _,
            out("zmm16") _,
            out("zmm17") _,
            out("zmm18") _,
            out("zmm19") _,
            out("zmm20") _,
            out("zmm21") _,
            out("zmm22") _,
            out("zmm23") _,
            out("zmm24") _,
            out("zmm25") _,
            out("zmm26") _,
            out("zmm27") _,
            out("zmm28") _,
            out("zmm29") _,
            out("zmm30") _,
            out("zmm31") _,
            options(nostack),
        );
    }
}
/// Transform all initialized columns and restore canonical row order.
///
/// The colored publisher initializes the entire row, including the odd zero
/// suffix. The preceding sweeps have even row spacings (128 and 8), so they
/// preserve those zero suffixes. This entry can load every column directly;
/// unlike `three`, it does not synthesize zeros for inactive input storage.
#[inline]
pub(crate) unsafe fn three_initialized(ptr: *mut F128, t: &[F128; 7], flip: bool) {
    unsafe { three_dispatch::<64>(ptr, 64, t, flip) }
}

/// Restore canonical layout during the final three layers. Eight rows of
/// 64 columns are initialized; odd-row columns dense_lanes..64 are zero.
/// flip is the population-count parity of the global first row index.
#[inline]
pub(crate) unsafe fn three(ptr: *mut F128, dense_lanes: usize, t: &[F128; 7], flip: bool) {
    // These exact bounds cover the ranked encoder. Keeping them in the leaf
    // type lets LLVM omit masks for full chunks. Other bounds retain the
    // general poisoned-tail-safe path.
    unsafe {
        match dense_lanes {
            60 => three_dispatch::<60>(ptr, dense_lanes, t, flip),
            64 => three_dispatch::<64>(ptr, dense_lanes, t, flip),
            _ => three_dispatch::<{ usize::MAX }>(ptr, dense_lanes, t, flip),
        }
    }
}
#[inline]
unsafe fn three_dispatch<const DENSE: usize>(ptr:*mut F128,dense_lanes:usize,t:&[F128;7],flip:bool){unsafe{
 macro_rules! call {($f:expr,$i:expr,$o:expr,$h:expr)=>{three_impl::<$i,$o,$h,$f,DENSE>(ptr,dense_lanes,t)};}
 macro_rules! select {($f:expr)=>{match (t[1..].iter().all(|v|v.hi==0),t[0].hi){
 (false,0)=>call!($f,false,true,false),(true,0)=>call!($f,true,true,false),
 (false,1)=>call!($f,false,false,true),(true,1)=>call!($f,true,false,true),
 (false,_)=>call!($f,false,false,false),(true,_)=>call!($f,true,false,false),
 }};}
 if flip{select!(true);}else{select!(false);}
}}
#[inline(never)]
unsafe fn three_impl<const LOW_INNER:bool,const LOW_OUTER:bool,const HIGH_ONE_OUTER:bool,const FLIP:bool,const DENSE:usize>(ptr:*mut F128,dense_lanes:usize,twiddles:&[F128;7]){
    let dense_lanes = if DENSE == usize::MAX { dense_lanes } else { DENSE };
    const DIET:bool=true; const NNC:usize=64; let num_ntts=64;

    // Shape substitution (identity: the wrapper only pins the runtime value).
    let num_ntts = if NNC != 0 { NNC } else { num_ntts };
    debug_assert!(!HIGH_ONE_OUTER || twiddles[0].hi == 1);

    // SAFETY: caller provides target features and pointer geometry.
    unsafe {
        // Seven broadcasts (plus their x^64 companions under DIET) hoisted
        // out of the lane loop: 8 rows stay live in registers across all
        // three layers, so a row is loaded once and stored once for 12
        // butterflies instead of the fused-two + single-layer pair's two
        // loads and two stores for the same 12.
        let zero = _mm512_setzero_si512();
        let mut tw = [(zero, zero); 7];
        // The high-one product needs only the original twiddle broadcast.
        tw[0] = if HIGH_ONE_OUTER {
            tw_x4::<false, false>(twiddles[0])
        } else {
            tw_x4::<LOW_OUTER, DIET>(twiddles[0])
        };
        for (slot, value) in tw[1..].iter_mut().zip(twiddles[1..].iter()) {
            *slot = tw_x4::<LOW_INNER, DIET>(*value);
        }
        let row = |i: usize| ptr.add(i * num_ntts);
        let mut lane = 0;

        macro_rules! butterfly {
            ($values:ident, $u:expr, $v:expr, $twiddle:expr, $low:expr) => {{
                butterfly!($values, $u, $v, $twiddle, $low, false);
            }};
            ($values:ident, $u:expr, $v:expr, $twiddle:expr, $low:expr, $high_one:expr) => {{
                let product = if $high_one {
                    mul_x4_high_one($twiddle, $values[$v])
                } else {
                    mul_x4::<$low, DIET>($twiddle, $values[$v])
                };
                let new_u = _mm512_xor_si512($values[$u], product);
                $values[$v] = _mm512_xor_si512($values[$v], new_u);
                $values[$u] = new_u;
            }};
        }
        // Two lane chunks per iteration: 16 live row registers + 14 twiddle
        // registers still fit the 32 zmm file, and doubling the independent
        // butterflies per layer (4 -> 8) covers the CLMUL latency and doubles
        // the outstanding row misses.
        // Dense-loop butterfly with lazy x^64 folds (diet forms only): the
        // product's x^64-position half accumulates in `$m[$u]`, `v ^= u`
        // shares it, and it is folded when `$fold` (the row is a multiplicand
        // in the next layer, or this is the last layer). Eight folds per four
        // lanes instead of twelve; same field elements.
        macro_rules! lazy_butterfly {
            ($p:expr, $m:expr, $u:expr, $v:expr, $twiddle:expr, $low:expr, $high_one:expr, $fold:expr) => {{
                if DIET {
                    let (lo, hi) = if $high_one {
                        mul_x4_high_one_parts($twiddle, $p[$v])
                    } else {
                        mul_x4_parts::<$low>($twiddle, $p[$v])
                    };
                    $m[$u] = _mm512_xor_si512($m[$u], hi);
                    let mut new_u = _mm512_xor_si512($p[$u], lo);
                    if $fold {
                        new_u = _mm512_xor_si512(new_u, fold_x64($m[$u]));
                        $m[$u] = zero;
                    }
                    $p[$v] = _mm512_xor_si512($p[$v], new_u);
                    $m[$v] = _mm512_xor_si512($m[$v], $m[$u]);
                    $p[$u] = new_u;
                } else {
                    let product = if $high_one {
                        mul_x4_high_one($twiddle, $p[$v])
                    } else {
                        mul_x4::<$low, DIET>($twiddle, $p[$v])
                    };
                    let new_u = _mm512_xor_si512($p[$u], product);
                    $p[$v] = _mm512_xor_si512($p[$v], new_u);
                    $p[$u] = new_u;
                }
            }};
        }

        while lane < 32 {
            let mut values = [[zero; 8]; 2];
            for (c, chunk) in values.iter_mut().enumerate() {
                for (i, value) in chunk.iter_mut().enumerate() {
                    *value = _mm512_maskz_loadu_epi64(
                        if i & 1 == 0 {255} else {((1u32 << (2 * dense_lanes.saturating_sub(lane+32*c).min(4))) - 1) as u8},row(i).add((lane + 32 * c) ^ (if (i.count_ones() & 1 != 0) ^ FLIP {32} else {0})) as *const i64);
                }
            }

            let outer = tw[0];
            let mut pending = [[zero; 8]; 2];
            for i in 0..4 {
                for c in 0..2 {
                    lazy_butterfly!(
                        values[c],
                        pending[c],
                        i,
                        i + 4,
                        outer,
                        LOW_OUTER,
                        HIGH_ONE_OUTER,
                        i & 2 != 0
                    );
                }
            }
            for s in 0..2 {
                let twiddle = tw[1 + s];
                for i in 0..2 {
                    for c in 0..2 {
                        lazy_butterfly!(
                            values[c],
                            pending[c],
                            4 * s + i,
                            4 * s + i + 2,
                            twiddle,
                            LOW_INNER,
                            false,
                            i & 1 != 0
                        );
                    }
                }
            }
            for s in 0..4 {
                for c in 0..2 {
                    lazy_butterfly!(
                        values[c],
                        pending[c],
                        2 * s,
                        2 * s + 1,
                        tw[3 + s],
                        LOW_INNER,
                        false,
                        true
                    );
                }
            }

            for (c, chunk) in values.iter().enumerate() {
                for (i, value) in chunk.iter().enumerate() {
                    _mm512_storeu_si512(row(i).add(lane + 32 * c) as *mut __m512i, *value);
                }
            }
            lane += 4;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:F128)->u128{v.lo as u128|((v.hi as u128)<<64)}
    fn field(v:u128)->F128{F128{lo:v as u64,hi:(v>>64)as u64}}
    fn mul(mut a:u128,mut b:u128)->u128{
        let mut r=0;
        for _ in 0..128 {if b&1!=0{r^=a;}let top=a>>127;a<<=1;if top!=0{a^=0x87;}b>>=1;}
        r
    }
    fn next(s:&mut u64)->F128{
        let mut r=0;
        for _ in 0..2{*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;r=(r<<64)|*s as u128;}
        field(r)
    }
    fn scalar(data:&mut[F128],stride:usize,lanes:usize,t:&[F128],layers:usize){
        for layer in 0..layers{
            let half=(1usize<<(layers-1))>>layer;
            for block in 0..1<<layer{
                let tw=bits(t[(1<<layer)-1+block]);
                for r in 0..half{for lane in 0..lanes{
                    let a=(block*2*half+r)*stride+lane;let b=a+half*stride;
                    let av=bits(data[a])^mul(tw,bits(data[b]));
                    data[b]=field(bits(data[b])^av);data[a]=field(av);
                }}
            }
        }
    }
    fn permute(data:&mut[F128],rows:usize,stride:usize,flip:bool){
        for row in 0..rows{if (row.count_ones()&1!=0)^flip{
            for lane in 0..32{data.swap(row*stride+lane,row*stride+32+lane);}
        }}
    }
    #[test]
    fn colored_publish_matches_scalar_and_initializes_tail(){unsafe{
        let mut state=771628;
        for step in [64,1024]{for lanes in [60,64]{for flip in [false,true]{for low in 0..4{
            let mut src:Vec<_>=(0..4*step).map(|_|next(&mut state)).collect();
            let mut t=core::array::from_fn::<_,3,_>(|_|next(&mut state));
            if low&1!=0{t[0].hi=0;}if low&2!=0{t[1].hi=0;t[2].hi=0;}
            let mut expected=vec![F128::ZERO;256];
            for r in 0..4{expected[r*64..r*64+lanes].copy_from_slice(&src[r*step..r*step+lanes]);}
            scalar(&mut expected,64,lanes,&t,2);
            let sentinel=field(0xfeed0dd);
            let mut actual=vec![sentinel;272];let p=actual.as_mut_ptr().add(8);
            publish::<false>(src.as_mut_ptr(),step,[p,p.add(64),p.add(128),p.add(192)],lanes,t,flip);
            _mm_sfence();
            permute(&mut actual[8..264],4,64,flip);
            assert_eq!(&actual[8..264],expected.as_slice(),"step={step} lanes={lanes} flip={flip} low={low}");
            assert!(actual[..8].iter().chain(actual[264..].iter()).all(|v|*v==sentinel));
        }}}}
    }}
    fn check_four<const S:usize>(){unsafe{
        let mut state=198219;
        for flip in [false,true]{for _ in 0..4{
            let mut expected:Vec<_>=(0..16*S*64).map(|_|next(&mut state)).collect();
            let t=core::array::from_fn::<_,15,_>(|_|next(&mut state));
            let prepared=PreparedFour{pairs:core::array::from_fn(|i|[t[i],field(mul(bits(t[i]),1u128<<64))]),zero_chain:false,prefetch_lines:4};
            let mut actual=expected.clone();permute(&mut actual,16,S*64,flip);
            scalar(&mut expected,S*64,64,&t,4);
            let p=actual.as_mut_ptr();four::<S>(p,&prepared,0,p);
            permute(&mut actual,16,S*64,flip);
            assert_eq!(actual,expected,"S={S} flip={flip}");
        }}
    }}
    #[test]
    fn colored_four_matches_scalar_and_guards(){check_four::<1>();check_four::<8>();check_four::<128>();}
    #[test]
    fn colored_three_restores_in_place_with_masked_zero_tails(){unsafe{
        let mut state=7652121;
        for dense in [0,1,4,57,60,64]{for flip in [false,true]{for low in [false,true]{for outer in [0,1,19]{
            let mut expected:Vec<_>=(0..512).map(|_|next(&mut state)).collect();
            let mut actual=expected.clone();
            // Poison remains in actual's inactive inputs. Only the oracle is
            // explicitly zeroed, checking the masked-load contract.
            for row in [1,3,5,7]{for c in dense..64{expected[row*64+c]=F128::ZERO;}}
            let mut t=core::array::from_fn::<_,7,_>(|_|next(&mut state));
            t[0].hi=outer;if low{for x in &mut t[1..]{x.hi=0;}}
            scalar(&mut expected,64,64,&t,3);
            let mut initialized = actual.clone();
            for row in [1, 3, 5, 7] {
                initialized[row * 64 + dense..(row + 1) * 64].fill(F128::ZERO);
            }
            permute(&mut initialized, 8, 64, flip);
            three_initialized(initialized.as_mut_ptr(), &t, flip);
            assert_eq!(initialized, expected, "initialized dense={dense} flip={flip} low={low} outer={outer}");
            permute(&mut actual,8,64,flip);
            three(actual.as_mut_ptr(),dense,&t,flip);
            assert_eq!(actual,expected,"dense={dense} flip={flip} low={low} outer={outer}");
        }}}}
    }}
}

/// Prepare the same split twiddles even when a diagnostic switch disables
/// the incumbent preparation cache. Never derive private-layout correctness
/// from an unrelated runtime tuning switch.
#[inline]
pub(crate) unsafe fn prepare(t:&[F128;15])->PreparedFour{unsafe{
    if let Some(p)=super::prepare_four(t){return p;}
    PreparedFour{pairs:core::array::from_fn(|i|{
        let v=_mm_set_epi64x(t[i].hi as i64,t[i].lo as i64);
        let folded=_mm_xor_si128(_mm_slli_si128::<8>(v),_mm_clmulepi64_si128::<0x01>(v,_mm_set_epi64x(0,0x87)));
        [t[i],F128{lo:_mm_cvtsi128_si64(folded)as u64,hi:_mm_extract_epi64::<1>(folded)as u64}]
    }),zero_chain:false,prefetch_lines:4}
}}

#[cfg(test)]
mod boundary_bench {
    use super::*;
    use std::hint::black_box;
    #[inline(never)]
    unsafe fn three_time<const NEW:bool>(n:usize)->f64{unsafe{
        let mut values=core::array::from_fn::<_,512,_>(|i|F128{lo:(i as u64).wrapping_mul(0x91381737241),hi:(i as u64).wrapping_mul(0x77151215)});
        let mut t=core::array::from_fn::<_,7,_>(|i|F128{lo:(i as u64+1).wrapping_mul(0x92716ba710617),hi:0});t[0].hi=1;
        let now=std::time::Instant::now();
        for _ in 0..n{
            if NEW{three_initialized(black_box(values.as_mut_ptr()),black_box(&t),false);}
            else{super::super::butterfly_fused_3layer_rows_shaped::<64>(black_box(values.as_mut_ptr()),black_box(60),black_box(&t));}
        }
        black_box(values);
        now.elapsed().as_secs_f64()*1e9/n as f64
    }}
    #[test]
    #[ignore]
    fn colored_three_boundary_throughput(){unsafe{
        three_time::<false>(2000);three_time::<true>(2000);
        for pair in 0..16{
            let(a,b)=if pair%2==0{(three_time::<false>(20000),three_time::<true>(20000))}else{let b=three_time::<true>(20000);(three_time::<false>(20000),b)};
            println!("pair={pair} baseline_ns={a} colored_ns={b} ratio={}",b/a);
        }
    }}
}
