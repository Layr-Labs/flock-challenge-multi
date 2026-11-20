// FLOCK_MAH_ASM=1 alternate (crate::MAH_ASM): Mahmoud514 a4aa6fa2's gfni_c4_pass4_register_result.S verbatim, every flock_ name suffixed _m.
// SPDX-License-Identifier: Apache-2.0 OR MIT
// One pass of the exact composed GFNI fold over FOUR CONTIGUOUS input lines.
// Inputs: RDI = 256 input bytes (4 lines of 8 packed rows), RSI = CFoldMats.1.
// Returns ZMM8 = the four row-0..3 half folds, ZMM9 = the four row-4..7 half
// folds; lane t of either is input line t.
// Same private register ABI as flock_gfni_c4_lm_register_result_m:
// clobbers RAX, flags, ZMM0..9. Preserves every other GPR and ZMM10..31.
// Called ONLY by the matching inline-asm wrapper, never through the C ABI.
.section .text.r345,"ax",@progbits
.p2align 6
.globl flock_gfni_c4_pass4_register_result_m
.hidden flock_gfni_c4_pass4_register_result_m
.type flock_gfni_c4_pass4_register_result_m,@function
flock_gfni_c4_pass4_register_result_m:
    mov rax, rsp
    and rsp, -64
    sub rsp, 256
    vmovdqa64 zmm9, [rip + .Lflock_c4p4_oct_m]

    // The two-pass kernel's gather with line stride 1 instead of 2.
    vmovdqu64 zmm0, [rdi]
    vmovdqu64 zmm1, [rdi + 64]
    vmovdqu64 zmm2, [rdi + 128]
    vmovdqu64 zmm3, [rdi + 192]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vshufpd zmm6, zmm4, zmm5, 0x00
    vshufpd zmm4, zmm4, zmm5, 0xff
    vpermb zmm6, zmm9, zmm6
    vpermb zmm4, zmm9, zmm4
    vmovdqa64 [rsp], zmm6
    vmovdqa64 [rsp + 64], zmm4
    vshufpd zmm6, zmm0, zmm2, 0x00
    vshufpd zmm0, zmm0, zmm2, 0xff
    vpermb zmm6, zmm9, zmm6
    vpermb zmm0, zmm9, zmm0
    vmovdqa64 [rsp + 128], zmm6
    vmovdqa64 [rsp + 192], zmm0

// Accumulators: ZMM8/9 = low/high output bytes of the single pass.
.macro flock_c4p4_pair_m j
    vpbroadcastq zmm4, [rsp + 8*\j]
    vpbroadcastq zmm5, [rsp + 8*(\j+1)]
    vgf2p8affineqb zmm0, zmm4, [rsi + 64*\j], 0
    vgf2p8affineqb zmm1, zmm4, [rsi + 2048 + 64*\j], 0
    vgf2p8affineqb zmm2, zmm5, [rsi + 64*(\j+1)], 0
    vgf2p8affineqb zmm3, zmm5, [rsi + 2048 + 64*(\j+1)], 0
.if \j == 0
    vpxorq zmm8, zmm0, zmm2
    vpxorq zmm9, zmm1, zmm3
.else
    vpternlogq zmm8, zmm0, zmm2, 0x96
    vpternlogq zmm9, zmm1, zmm3, 0x96
.endif
.endm
    flock_c4p4_pair_m 0
    flock_c4p4_pair_m 2
    flock_c4p4_pair_m 4
    flock_c4p4_pair_m 6
    flock_c4p4_pair_m 8
    flock_c4p4_pair_m 10
    flock_c4p4_pair_m 12
    flock_c4p4_pair_m 14
    flock_c4p4_pair_m 16
    flock_c4p4_pair_m 18
    flock_c4p4_pair_m 20
    flock_c4p4_pair_m 22
    flock_c4p4_pair_m 24
    flock_c4p4_pair_m 26
    flock_c4p4_pair_m 28
    flock_c4p4_pair_m 30

    vmovdqa64 zmm0, [rip + .Lflock_c4p4_bt_m]
    vpermb zmm1, zmm0, zmm8
    vpermb zmm2, zmm0, zmm9
    vpunpcklqdq zmm8, zmm1, zmm2
    vpunpckhqdq zmm9, zmm1, zmm2
    mov rsp, rax
    ret
.size flock_gfni_c4_pass4_register_result_m, .-flock_gfni_c4_pass4_register_result_m
.purgem flock_c4p4_pair_m
.section .rodata

.p2align 6
.Lflock_c4p4_oct_m:
    .byte 0, 16, 32, 48, 8, 24, 40, 56, 1, 17, 33, 49, 9, 25, 41, 57, 2, 18, 34, 50, 10, 26, 42, 58, 3, 19, 35, 51, 11, 27, 43, 59, 4, 20, 36, 52, 12, 28, 44, 60, 5, 21, 37, 53, 13, 29, 45, 61, 6, 22, 38, 54, 14, 30, 46, 62, 7, 23, 39, 55, 15, 31, 47, 63

.p2align 6
.Lflock_c4p4_bt_m:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
