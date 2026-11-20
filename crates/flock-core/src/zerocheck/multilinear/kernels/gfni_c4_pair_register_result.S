// SPDX-License-Identifier: Apache-2.0 OR MIT
// Two-source batch of gfni_c4_register_result_m.S, sharing register matrices.
// RDI/RDX: two 512-byte inputs; RSI: CFoldMats.1. Returns ZMM8..11/ZMM12..15.
// Clobbers RAX, flags, ZMM0..19; preserves other GPRs and ZMM20..31.
// Private register ABI, called only by the matching inline-asm wrapper.
.text
.p2align 6
.globl flock_gfni_c4_pair_register_result
.hidden flock_gfni_c4_pair_register_result
.type flock_gfni_c4_pair_register_result,@function
flock_gfni_c4_pair_register_result:
    mov rax, rsp
    and rsp, -64
    sub rsp, 1024
    vmovdqa64 zmm9, [rip + .Lflock_c4_pair_oct]

.macro flock_c4_pair_gather src, base, p
    vmovdqu64 zmm0, [\src + 64*\p]
    vmovdqu64 zmm1, [\src + 64*\p + 128]
    vmovdqu64 zmm2, [\src + 64*\p + 256]
    vmovdqu64 zmm3, [\src + 64*\p + 384]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vshufpd zmm6, zmm4, zmm5, 0x00
    vshufpd zmm4, zmm4, zmm5, 0xff
    vpermb zmm6, zmm9, zmm6
    vpermb zmm4, zmm9, zmm4
    vmovdqa64 [rsp + \base + 256*\p], zmm6
    vmovdqa64 [rsp + \base + 256*\p + 64], zmm4
    vshufpd zmm6, zmm0, zmm2, 0x00
    vshufpd zmm0, zmm0, zmm2, 0xff
    vpermb zmm6, zmm9, zmm6
    vpermb zmm0, zmm9, zmm0
    vmovdqa64 [rsp + \base + 256*\p + 128], zmm6
    vmovdqa64 [rsp + \base + 256*\p + 192], zmm0
.endm
    flock_c4_pair_gather rdi, 0, 0
    flock_c4_pair_gather rdi, 0, 1
    flock_c4_pair_gather rdx, 512, 0
    flock_c4_pair_gather rdx, 512, 1

.macro flock_c4_pair_reduce j, base, a, b, c, d
    vpbroadcastq zmm4, [rsp + \base + 8*\j]
    vpbroadcastq zmm5, [rsp + \base + 256 + 8*\j]
    vgf2p8affineqb zmm0, zmm4, zmm16, 0
    vgf2p8affineqb zmm1, zmm4, zmm17, 0
    vgf2p8affineqb zmm2, zmm5, zmm16, 0
    vgf2p8affineqb zmm3, zmm5, zmm17, 0
    vpbroadcastq zmm4, [rsp + \base + 8*(\j+1)]
    vpbroadcastq zmm5, [rsp + \base + 256 + 8*(\j+1)]
    vgf2p8affineqb zmm6, zmm4, zmm18, 0
    vgf2p8affineqb zmm7, zmm5, zmm18, 0
.if \j == 0
    vpxorq \a, zmm0, zmm6
    vpxorq \c, zmm2, zmm7
.else
    vpternlogq \a, zmm0, zmm6, 0x96
    vpternlogq \c, zmm2, zmm7, 0x96
.endif
    vgf2p8affineqb zmm4, zmm4, zmm19, 0
    vgf2p8affineqb zmm5, zmm5, zmm19, 0
.if \j == 0
    vpxorq \b, zmm1, zmm4
    vpxorq \d, zmm3, zmm5
.else
    vpternlogq \b, zmm1, zmm4, 0x96
    vpternlogq \d, zmm3, zmm5, 0x96
.endif
.endm
.macro flock_c4_pair_step j
    vmovdqu64 zmm16, [rsi + 64*\j]
    vmovdqu64 zmm17, [rsi + 2048 + 64*\j]
    vmovdqu64 zmm18, [rsi + 64*(\j+1)]
    vmovdqu64 zmm19, [rsi + 2048 + 64*(\j+1)]
    flock_c4_pair_reduce \j, 0, zmm8, zmm9, zmm10, zmm11
    flock_c4_pair_reduce \j, 512, zmm12, zmm13, zmm14, zmm15
.endm
    flock_c4_pair_step 0
    flock_c4_pair_step 2
    flock_c4_pair_step 4
    flock_c4_pair_step 6
    flock_c4_pair_step 8
    flock_c4_pair_step 10
    flock_c4_pair_step 12
    flock_c4_pair_step 14
    flock_c4_pair_step 16
    flock_c4_pair_step 18
    flock_c4_pair_step 20
    flock_c4_pair_step 22
    flock_c4_pair_step 24
    flock_c4_pair_step 26
    flock_c4_pair_step 28
    flock_c4_pair_step 30

    vmovdqa64 zmm0, [rip + .Lflock_c4_pair_bt]
.macro flock_c4_pair_transpose a, b, c, d
    vpermb zmm1, zmm0, \a
    vpermb zmm2, zmm0, \b
    vpermb zmm3, zmm0, \c
    vpermb zmm4, zmm0, \d
    vpunpcklqdq \a, zmm1, zmm2
    vpunpckhqdq \b, zmm1, zmm2
    vpunpcklqdq \c, zmm3, zmm4
    vpunpckhqdq \d, zmm3, zmm4
.endm
    flock_c4_pair_transpose zmm8, zmm9, zmm10, zmm11
    flock_c4_pair_transpose zmm12, zmm13, zmm14, zmm15
    mov rsp, rax
    ret
.size flock_gfni_c4_pair_register_result, .-flock_gfni_c4_pair_register_result
.purgem flock_c4_pair_gather
.purgem flock_c4_pair_reduce
.purgem flock_c4_pair_step
.purgem flock_c4_pair_transpose
.section .rodata
.p2align 6
.Lflock_c4_pair_oct:
    .byte 0, 16, 32, 48, 8, 24, 40, 56, 1, 17, 33, 49, 9, 25, 41, 57, 2, 18, 34, 50, 10, 26, 42, 58, 3, 19, 35, 51, 11, 27, 43, 59, 4, 20, 36, 52, 12, 28, 44, 60, 5, 21, 37, 53, 13, 29, 45, 61, 6, 22, 38, 54, 14, 30, 46, 62, 7, 23, 39, 55, 15, 31, 47, 63
.p2align 6
.Lflock_c4_pair_bt:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
