// SPDX-License-Identifier: Apache-2.0 OR MIT
// Exact composed GFNI fold, lane-major output, with a private register ABI.
// Inputs: RDI = 512 input bytes, RSI = CFoldMats.1. Returns ZMM8..11 in lane-major order.
// Clobbers: RAX, flags, ZMM0..11. Preserves every other GPR and ZMM12..31.
// Called ONLY by the matching inline-asm wrapper, never through the C ABI.
// No vzeroupper: the upper lanes of ZMM12..15 belong to the caller.
.text
.p2align 6
.globl flock_gfni_c4_lm_register_result
.hidden flock_gfni_c4_lm_register_result
.type flock_gfni_c4_lm_register_result,@function
flock_gfni_c4_lm_register_result:
    mov rax, rsp
    and rsp, -64
    sub rsp, 512
    vmovdqa64 zmm8, [rip + .Lflock_c4_result_oct_even]
    vmovdqa64 zmm9, [rip + .Lflock_c4_result_oct_odd]

// Gather both passes into the original initialized scratch before reducing.
.macro flock_c4_result_gather p
    vmovdqu64 zmm0, [rdi + 64*\p]
    vmovdqu64 zmm1, [rdi + 64*\p + 128]
    vmovdqu64 zmm2, [rdi + 64*\p + 256]
    vmovdqu64 zmm3, [rdi + 64*\p + 384]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, zmm4
    vpermt2b zmm6, zmm8, zmm5
    vpermt2b zmm4, zmm9, zmm5
    vmovdqa64 [rsp + 256*\p], zmm6
    vmovdqa64 [rsp + 256*\p + 64], zmm4
    vmovdqa64 zmm6, zmm0
    vpermt2b zmm6, zmm8, zmm2
    vpermt2b zmm0, zmm9, zmm2
    vmovdqa64 [rsp + 256*\p + 128], zmm6
    vmovdqa64 [rsp + 256*\p + 192], zmm0
.endm
    flock_c4_result_gather 0
    flock_c4_result_gather 1

    vpxorq zmm0, zmm0, zmm0
    vpxorq zmm1, zmm1, zmm1
    vpxorq zmm2, zmm2, zmm2
    vpxorq zmm3, zmm3, zmm3
    vpbroadcastq zmm4, [rsp + 0]
    vpbroadcastq zmm5, [rsp + 256]
    vpbroadcastq zmm6, [rsp + 8]
    vpbroadcastq zmm7, [rsp + 264]
    vmovdqu64 zmm8, [rsi + 0]
    vmovdqu64 zmm11, [rsi + 64]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2048]
    vmovdqu64 zmm11, [rsi + 2112]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 16]
    vpbroadcastq zmm5, [rsp + 272]
    vpbroadcastq zmm6, [rsp + 24]
    vpbroadcastq zmm7, [rsp + 280]
    vmovdqu64 zmm8, [rsi + 128]
    vmovdqu64 zmm11, [rsi + 192]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2176]
    vmovdqu64 zmm11, [rsi + 2240]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 32]
    vpbroadcastq zmm5, [rsp + 288]
    vpbroadcastq zmm6, [rsp + 40]
    vpbroadcastq zmm7, [rsp + 296]
    vmovdqu64 zmm8, [rsi + 256]
    vmovdqu64 zmm11, [rsi + 320]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2304]
    vmovdqu64 zmm11, [rsi + 2368]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 48]
    vpbroadcastq zmm5, [rsp + 304]
    vpbroadcastq zmm6, [rsp + 56]
    vpbroadcastq zmm7, [rsp + 312]
    vmovdqu64 zmm8, [rsi + 384]
    vmovdqu64 zmm11, [rsi + 448]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2432]
    vmovdqu64 zmm11, [rsi + 2496]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 64]
    vpbroadcastq zmm5, [rsp + 320]
    vpbroadcastq zmm6, [rsp + 72]
    vpbroadcastq zmm7, [rsp + 328]
    vmovdqu64 zmm8, [rsi + 512]
    vmovdqu64 zmm11, [rsi + 576]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2560]
    vmovdqu64 zmm11, [rsi + 2624]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 80]
    vpbroadcastq zmm5, [rsp + 336]
    vpbroadcastq zmm6, [rsp + 88]
    vpbroadcastq zmm7, [rsp + 344]
    vmovdqu64 zmm8, [rsi + 640]
    vmovdqu64 zmm11, [rsi + 704]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2688]
    vmovdqu64 zmm11, [rsi + 2752]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 96]
    vpbroadcastq zmm5, [rsp + 352]
    vpbroadcastq zmm6, [rsp + 104]
    vpbroadcastq zmm7, [rsp + 360]
    vmovdqu64 zmm8, [rsi + 768]
    vmovdqu64 zmm11, [rsi + 832]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2816]
    vmovdqu64 zmm11, [rsi + 2880]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 112]
    vpbroadcastq zmm5, [rsp + 368]
    vpbroadcastq zmm6, [rsp + 120]
    vpbroadcastq zmm7, [rsp + 376]
    vmovdqu64 zmm8, [rsi + 896]
    vmovdqu64 zmm11, [rsi + 960]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 2944]
    vmovdqu64 zmm11, [rsi + 3008]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 128]
    vpbroadcastq zmm5, [rsp + 384]
    vpbroadcastq zmm6, [rsp + 136]
    vpbroadcastq zmm7, [rsp + 392]
    vmovdqu64 zmm8, [rsi + 1024]
    vmovdqu64 zmm11, [rsi + 1088]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3072]
    vmovdqu64 zmm11, [rsi + 3136]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 144]
    vpbroadcastq zmm5, [rsp + 400]
    vpbroadcastq zmm6, [rsp + 152]
    vpbroadcastq zmm7, [rsp + 408]
    vmovdqu64 zmm8, [rsi + 1152]
    vmovdqu64 zmm11, [rsi + 1216]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3200]
    vmovdqu64 zmm11, [rsi + 3264]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 160]
    vpbroadcastq zmm5, [rsp + 416]
    vpbroadcastq zmm6, [rsp + 168]
    vpbroadcastq zmm7, [rsp + 424]
    vmovdqu64 zmm8, [rsi + 1280]
    vmovdqu64 zmm11, [rsi + 1344]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3328]
    vmovdqu64 zmm11, [rsi + 3392]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 176]
    vpbroadcastq zmm5, [rsp + 432]
    vpbroadcastq zmm6, [rsp + 184]
    vpbroadcastq zmm7, [rsp + 440]
    vmovdqu64 zmm8, [rsi + 1408]
    vmovdqu64 zmm11, [rsi + 1472]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3456]
    vmovdqu64 zmm11, [rsi + 3520]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 192]
    vpbroadcastq zmm5, [rsp + 448]
    vpbroadcastq zmm6, [rsp + 200]
    vpbroadcastq zmm7, [rsp + 456]
    vmovdqu64 zmm8, [rsi + 1536]
    vmovdqu64 zmm11, [rsi + 1600]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3584]
    vmovdqu64 zmm11, [rsi + 3648]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 208]
    vpbroadcastq zmm5, [rsp + 464]
    vpbroadcastq zmm6, [rsp + 216]
    vpbroadcastq zmm7, [rsp + 472]
    vmovdqu64 zmm8, [rsi + 1664]
    vmovdqu64 zmm11, [rsi + 1728]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3712]
    vmovdqu64 zmm11, [rsi + 3776]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 224]
    vpbroadcastq zmm5, [rsp + 480]
    vpbroadcastq zmm6, [rsp + 232]
    vpbroadcastq zmm7, [rsp + 488]
    vmovdqu64 zmm8, [rsi + 1792]
    vmovdqu64 zmm11, [rsi + 1856]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3840]
    vmovdqu64 zmm11, [rsi + 3904]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vpbroadcastq zmm4, [rsp + 240]
    vpbroadcastq zmm5, [rsp + 496]
    vpbroadcastq zmm6, [rsp + 248]
    vpbroadcastq zmm7, [rsp + 504]
    vmovdqu64 zmm8, [rsi + 1920]
    vmovdqu64 zmm11, [rsi + 1984]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm0, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm2, zmm9, zmm10, 0x96
    vmovdqu64 zmm8, [rsi + 3968]
    vmovdqu64 zmm11, [rsi + 4032]
    vgf2p8affineqb zmm9, zmm4, zmm8, 0
    vgf2p8affineqb zmm10, zmm6, zmm11, 0
    vpternlogq zmm1, zmm9, zmm10, 0x96
    vgf2p8affineqb zmm9, zmm5, zmm8, 0
    vgf2p8affineqb zmm10, zmm7, zmm11, 0
    vpternlogq zmm3, zmm9, zmm10, 0x96
    vmovdqa64 zmm6, [rip + .Lflock_c4_result_out_even]
    vmovdqa64 zmm7, [rip + .Lflock_c4_result_out_odd]
    vmovdqa64 zmm8, zmm0
    vmovdqa64 zmm9, zmm0
    vpermt2b zmm8, zmm6, zmm1
    vpermt2b zmm9, zmm7, zmm1
    vmovdqa64 zmm10, zmm2
    vmovdqa64 zmm11, zmm2
    vpermt2b zmm10, zmm6, zmm3
    vpermt2b zmm11, zmm7, zmm3
    mov rsp, rax
    ret
.size flock_gfni_c4_lm_register_result, .-flock_gfni_c4_lm_register_result
.purgem flock_c4_result_gather
.section .rodata

.p2align 6
.Lflock_c4_result_oct_even:
    .byte 0, 16, 32, 48, 64, 80, 96, 112, 1, 17, 33, 49, 65, 81, 97, 113, 2, 18, 34, 50, 66, 82, 98, 114, 3, 19, 35, 51, 67, 83, 99, 115, 4, 20, 36, 52, 68, 84, 100, 116, 5, 21, 37, 53, 69, 85, 101, 117, 6, 22, 38, 54, 70, 86, 102, 118, 7, 23, 39, 55, 71, 87, 103, 119

.p2align 6
.Lflock_c4_result_oct_odd:
    .byte 8, 24, 40, 56, 72, 88, 104, 120, 9, 25, 41, 57, 73, 89, 105, 121, 10, 26, 42, 58, 74, 90, 106, 122, 11, 27, 43, 59, 75, 91, 107, 123, 12, 28, 44, 60, 76, 92, 108, 124, 13, 29, 45, 61, 77, 93, 109, 125, 14, 30, 46, 62, 78, 94, 110, 126, 15, 31, 47, 63, 79, 95, 111, 127

.p2align 6
.Lflock_c4_result_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c4_result_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
