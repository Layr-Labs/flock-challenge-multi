// SPDX-License-Identifier: Apache-2.0 OR MIT
// Two exact C4 folds sharing one immutable matrix frame.
// RDI/RSI: two 512-byte inputs. RDX: 4096-byte matrix frame.
// Returns first result in ZMM8..11, second in ZMM12..15.
// Clobbers RAX, flags and ZMM0..15; preserves every other GPR and ZMM16..31.
.text
.p2align 6
.globl flock_gfni_c4_dual_register_result
.hidden flock_gfni_c4_dual_register_result
.type flock_gfni_c4_dual_register_result,@function
flock_gfni_c4_dual_register_result:
    mov rax, rsp
    and rsp, -64
    sub rsp, 1408
    vmovdqa64 [rsp + 0], zmm16
    vmovdqa64 [rsp + 64], zmm17
    vmovdqa64 [rsp + 128], zmm18
    vmovdqa64 [rsp + 192], zmm19
    vmovdqa64 [rsp + 256], zmm20
    vmovdqa64 [rsp + 320], zmm21
    vmovdqa64 zmm9, [rip + .Lflock_c4_dual_oct_odd]
.macro flock_c4_dual_gather p, base, slot
    vmovdqu64 zmm0, [\base + 64*\p + 0]
    vmovdqu64 zmm1, [\base + 64*\p + 128]
    vmovdqu64 zmm2, [\base + 64*\p + 256]
    vmovdqu64 zmm3, [\base + 64*\p + 384]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c4_dual_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vpermt2b zmm4, zmm9, zmm5
    vmovdqa64 [rsp + 384 + 256*\slot], zmm6
    vmovdqa64 [rsp + 384 + 256*\slot + 64], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c4_dual_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm9, zmm2
    vmovdqa64 [rsp + 384 + 256*\slot + 128], zmm6
    vmovdqa64 [rsp + 384 + 256*\slot + 192], zmm0
.endm
    flock_c4_dual_gather 0, rdi, 0
    flock_c4_dual_gather 1, rdi, 1
    flock_c4_dual_gather 0, rsi, 2
    flock_c4_dual_gather 1, rsi, 3
.macro flock_c4_dual_pair j
    vpbroadcastq zmm16, [rsp + 384 + 0 + 8*\j]
    vpbroadcastq zmm17, [rsp + 384 + 256 + 8*\j]
    vpbroadcastq zmm18, [rsp + 384 + 512 + 8*\j]
    vpbroadcastq zmm19, [rsp + 384 + 768 + 8*\j]
    vmovdqu64 zmm20, [rdx + 64*\j]
    vmovdqu64 zmm21, [rdx + 2048 + 64*\j]
    vgf2p8affineqb zmm0, zmm16, zmm20, 0
    vgf2p8affineqb zmm1, zmm16, zmm21, 0
    vgf2p8affineqb zmm2, zmm17, zmm20, 0
    vgf2p8affineqb zmm3, zmm17, zmm21, 0
    vgf2p8affineqb zmm4, zmm18, zmm20, 0
    vgf2p8affineqb zmm5, zmm18, zmm21, 0
    vgf2p8affineqb zmm6, zmm19, zmm20, 0
    vgf2p8affineqb zmm7, zmm19, zmm21, 0
    vmovdqu64 zmm20, [rdx + 64*(\j+1)]
    vmovdqu64 zmm21, [rdx + 2048 + 64*(\j+1)]
    vpbroadcastq zmm16, [rsp + 384 + 0 + 8*(\j+1)]
    vgf2p8affineqb zmm17, zmm16, zmm20, 0
.if \j == 0
    vpxorq zmm8, zmm0, zmm17
.else
    vpternlogq zmm8, zmm0, zmm17, 0x96
.endif
    vgf2p8affineqb zmm17, zmm16, zmm21, 0
.if \j == 0
    vpxorq zmm9, zmm1, zmm17
.else
    vpternlogq zmm9, zmm1, zmm17, 0x96
.endif
    vpbroadcastq zmm16, [rsp + 384 + 256 + 8*(\j+1)]
    vgf2p8affineqb zmm17, zmm16, zmm20, 0
.if \j == 0
    vpxorq zmm10, zmm2, zmm17
.else
    vpternlogq zmm10, zmm2, zmm17, 0x96
.endif
    vgf2p8affineqb zmm17, zmm16, zmm21, 0
.if \j == 0
    vpxorq zmm11, zmm3, zmm17
.else
    vpternlogq zmm11, zmm3, zmm17, 0x96
.endif
    vpbroadcastq zmm16, [rsp + 384 + 512 + 8*(\j+1)]
    vgf2p8affineqb zmm17, zmm16, zmm20, 0
.if \j == 0
    vpxorq zmm12, zmm4, zmm17
.else
    vpternlogq zmm12, zmm4, zmm17, 0x96
.endif
    vgf2p8affineqb zmm17, zmm16, zmm21, 0
.if \j == 0
    vpxorq zmm13, zmm5, zmm17
.else
    vpternlogq zmm13, zmm5, zmm17, 0x96
.endif
    vpbroadcastq zmm16, [rsp + 384 + 768 + 8*(\j+1)]
    vgf2p8affineqb zmm17, zmm16, zmm20, 0
.if \j == 0
    vpxorq zmm14, zmm6, zmm17
.else
    vpternlogq zmm14, zmm6, zmm17, 0x96
.endif
    vgf2p8affineqb zmm17, zmm16, zmm21, 0
.if \j == 0
    vpxorq zmm15, zmm7, zmm17
.else
    vpternlogq zmm15, zmm7, zmm17, 0x96
.endif
.endm
    flock_c4_dual_pair 0
    flock_c4_dual_pair 2
    flock_c4_dual_pair 4
    flock_c4_dual_pair 6
    flock_c4_dual_pair 8
    flock_c4_dual_pair 10
    flock_c4_dual_pair 12
    flock_c4_dual_pair 14
    flock_c4_dual_pair 16
    flock_c4_dual_pair 18
    flock_c4_dual_pair 20
    flock_c4_dual_pair 22
    flock_c4_dual_pair 24
    flock_c4_dual_pair 26
    flock_c4_dual_pair 28
    flock_c4_dual_pair 30
    vmovdqa64 zmm0, [rip + .Lflock_c4_dual_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c4_dual_out_odd]
    vpermi2b zmm0, zmm8, zmm9
    vpermi2b zmm1, zmm8, zmm9
    vmovdqa64 zmm8, zmm0
    vmovdqa64 zmm9, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c4_dual_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c4_dual_out_odd]
    vpermi2b zmm0, zmm10, zmm11
    vpermi2b zmm1, zmm10, zmm11
    vmovdqa64 zmm10, zmm0
    vmovdqa64 zmm11, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c4_dual_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c4_dual_out_odd]
    vpermi2b zmm0, zmm12, zmm13
    vpermi2b zmm1, zmm12, zmm13
    vmovdqa64 zmm12, zmm0
    vmovdqa64 zmm13, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c4_dual_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c4_dual_out_odd]
    vpermi2b zmm0, zmm14, zmm15
    vpermi2b zmm1, zmm14, zmm15
    vmovdqa64 zmm14, zmm0
    vmovdqa64 zmm15, zmm1
    vmovdqa64 zmm16, [rsp + 0]
    vmovdqa64 zmm17, [rsp + 64]
    vmovdqa64 zmm18, [rsp + 128]
    vmovdqa64 zmm19, [rsp + 192]
    vmovdqa64 zmm20, [rsp + 256]
    vmovdqa64 zmm21, [rsp + 320]
    mov rsp, rax
    ret
.size flock_gfni_c4_dual_register_result, .-flock_gfni_c4_dual_register_result
.purgem flock_c4_dual_gather
.purgem flock_c4_dual_pair
.section .rodata

.p2align 6
.Lflock_c4_dual_oct_even:
    .byte 0, 16, 32, 48, 64, 80, 96, 112, 1, 17, 33, 49, 65, 81, 97, 113, 2, 18, 34, 50, 66, 82, 98, 114, 3, 19, 35, 51, 67, 83, 99, 115, 4, 20, 36, 52, 68, 84, 100, 116, 5, 21, 37, 53, 69, 85, 101, 117, 6, 22, 38, 54, 70, 86, 102, 118, 7, 23, 39, 55, 71, 87, 103, 119

.p2align 6
.Lflock_c4_dual_oct_odd:
    .byte 8, 24, 40, 56, 72, 88, 104, 120, 9, 25, 41, 57, 73, 89, 105, 121, 10, 26, 42, 58, 74, 90, 106, 122, 11, 27, 43, 59, 75, 91, 107, 123, 12, 28, 44, 60, 76, 92, 108, 124, 13, 29, 45, 61, 77, 93, 109, 125, 14, 30, 46, 62, 78, 94, 110, 126, 15, 31, 47, 63, 79, 95, 111, 127

.p2align 6
.Lflock_c4_dual_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c4_dual_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
