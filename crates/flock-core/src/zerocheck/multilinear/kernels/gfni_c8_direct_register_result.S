// SPDX-License-Identifier: Apache-2.0 OR MIT
// Direct eight-coefficient fold. Private ABI: RDI=1024 input bytes,
// RSI=8192-byte low/high matrix table. Returns lane-major ZMM8..11.
// Clobbers RAX, flags, ZMM0..11; preserves every other GPR and ZMM12..31.
// Eight-line transpose adapted from published 92d1814b paired C8 assembly;
// two-pass reuse and output masks adapted from the inherited C4 leaf.
.text
.p2align 6
.globl flock_gfni_c8_direct_register_result
.hidden flock_gfni_c8_direct_register_result
.type flock_gfni_c8_direct_register_result,@function
flock_gfni_c8_direct_register_result:
    mov rax, rsp
    and rsp, -64
    sub rsp, 1024
.macro flock_c8_direct_gather p
vmovdqu64 zmm0, [rdi + 128*0 + 64*\p]
vmovdqu64 zmm1, [rdi + 128*1 + 64*\p]
vmovdqu64 zmm2, [rdi + 128*2 + 64*\p]
vmovdqu64 zmm3, [rdi + 128*3 + 64*\p]
vmovdqu64 zmm4, [rdi + 128*4 + 64*\p]
vmovdqu64 zmm5, [rdi + 128*5 + 64*\p]
vmovdqu64 zmm6, [rdi + 128*6 + 64*\p]
vmovdqu64 zmm7, [rdi + 128*7 + 64*\p]
vpunpcklqdq zmm8, zmm0, zmm1
vpunpckhqdq zmm9, zmm0, zmm1
vpunpcklqdq zmm10, zmm2, zmm3
vpunpckhqdq zmm0, zmm2, zmm3
vpunpcklqdq zmm1, zmm4, zmm5
vpunpckhqdq zmm2, zmm4, zmm5
vpunpcklqdq zmm3, zmm6, zmm7
vpunpckhqdq zmm4, zmm6, zmm7
vshufi64x2 zmm5, zmm8, zmm10, 136
vshufi64x2 zmm6, zmm8, zmm10, 221
vshufi64x2 zmm7, zmm9, zmm0, 136
vshufi64x2 zmm8, zmm9, zmm0, 221
vshufi64x2 zmm10, zmm1, zmm3, 136
vshufi64x2 zmm9, zmm1, zmm3, 221
vshufi64x2 zmm0, zmm2, zmm4, 136
vshufi64x2 zmm1, zmm2, zmm4, 221
vshufi64x2 zmm3, zmm5, zmm10, 136
vshufi64x2 zmm2, zmm5, zmm10, 221
vshufi64x2 zmm4, zmm6, zmm9, 136
vshufi64x2 zmm5, zmm6, zmm9, 221
vshufi64x2 zmm10, zmm7, zmm0, 136
vshufi64x2 zmm6, zmm7, zmm0, 221
vshufi64x2 zmm9, zmm8, zmm1, 136
vshufi64x2 zmm7, zmm8, zmm1, 221
vmovdqa64 zmm11, [rip + .Lflock_c8_direct_transpose_bytes]
vpermb zmm3, zmm11, zmm3
vmovdqa64 [rsp + 512*\p + 0], zmm3
vpermb zmm10, zmm11, zmm10
vmovdqa64 [rsp + 512*\p + 64], zmm10
vpermb zmm4, zmm11, zmm4
vmovdqa64 [rsp + 512*\p + 128], zmm4
vpermb zmm9, zmm11, zmm9
vmovdqa64 [rsp + 512*\p + 192], zmm9
vpermb zmm2, zmm11, zmm2
vmovdqa64 [rsp + 512*\p + 256], zmm2
vpermb zmm6, zmm11, zmm6
vmovdqa64 [rsp + 512*\p + 320], zmm6
vpermb zmm5, zmm11, zmm5
vmovdqa64 [rsp + 512*\p + 384], zmm5
vpermb zmm7, zmm11, zmm7
vmovdqa64 [rsp + 512*\p + 448], zmm7
.endm
    flock_c8_direct_gather 0
    flock_c8_direct_gather 1
.macro flock_c8_direct_pair j
    vpbroadcastq zmm4, [rsp + 8*\j]
    vpbroadcastq zmm5, [rsp + 512 + 8*\j]
    vmovdqu64 zmm6, [rsi + 64*\j]
    vmovdqu64 zmm7, [rsi + 4096 + 64*\j]
    vgf2p8affineqb zmm0, zmm4, zmm6, 0
    vgf2p8affineqb zmm1, zmm4, zmm7, 0
    vgf2p8affineqb zmm2, zmm5, zmm6, 0
    vgf2p8affineqb zmm3, zmm5, zmm7, 0
    vpbroadcastq zmm4, [rsp + 8*(\j+1)]
    vpbroadcastq zmm5, [rsp + 512 + 8*(\j+1)]
    vmovdqu64 zmm6, [rsi + 64*(\j+1)]
    vgf2p8affineqb zmm7, zmm4, zmm6, 0
.if \j == 0
    vpxorq zmm8, zmm0, zmm7
.else
    vpternlogq zmm8, zmm0, zmm7, 0x96
.endif
    vmovdqu64 zmm0, [rsi + 4096 + 64*(\j+1)]
    vgf2p8affineqb zmm7, zmm4, zmm0, 0
.if \j == 0
    vpxorq zmm9, zmm1, zmm7
.else
    vpternlogq zmm9, zmm1, zmm7, 0x96
.endif
    vgf2p8affineqb zmm7, zmm5, zmm6, 0
.if \j == 0
    vpxorq zmm10, zmm2, zmm7
.else
    vpternlogq zmm10, zmm2, zmm7, 0x96
.endif
    vgf2p8affineqb zmm7, zmm5, zmm0, 0
.if \j == 0
    vpxorq zmm11, zmm3, zmm7
.else
    vpternlogq zmm11, zmm3, zmm7, 0x96
.endif
.endm
    flock_c8_direct_pair 0
    flock_c8_direct_pair 2
    flock_c8_direct_pair 4
    flock_c8_direct_pair 6
    flock_c8_direct_pair 8
    flock_c8_direct_pair 10
    flock_c8_direct_pair 12
    flock_c8_direct_pair 14
    flock_c8_direct_pair 16
    flock_c8_direct_pair 18
    flock_c8_direct_pair 20
    flock_c8_direct_pair 22
    flock_c8_direct_pair 24
    flock_c8_direct_pair 26
    flock_c8_direct_pair 28
    flock_c8_direct_pair 30
    flock_c8_direct_pair 32
    flock_c8_direct_pair 34
    flock_c8_direct_pair 36
    flock_c8_direct_pair 38
    flock_c8_direct_pair 40
    flock_c8_direct_pair 42
    flock_c8_direct_pair 44
    flock_c8_direct_pair 46
    flock_c8_direct_pair 48
    flock_c8_direct_pair 50
    flock_c8_direct_pair 52
    flock_c8_direct_pair 54
    flock_c8_direct_pair 56
    flock_c8_direct_pair 58
    flock_c8_direct_pair 60
    flock_c8_direct_pair 62
    vmovdqa64 zmm0, [rip + .Lflock_c8_direct_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_direct_out_odd]
    vpermi2b zmm0, zmm8, zmm9
    vpermi2b zmm1, zmm8, zmm9
    vmovdqa64 zmm8, zmm0
    vmovdqa64 zmm2, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c8_direct_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_direct_out_odd]
    vpermi2b zmm0, zmm10, zmm11
    vpermi2b zmm1, zmm10, zmm11
    vmovdqa64 zmm9, zmm0
    vmovdqa64 zmm10, zmm2
    vmovdqa64 zmm11, zmm1
    mov rsp, rax
    ret
.size flock_gfni_c8_direct_register_result, .-flock_gfni_c8_direct_register_result
.purgem flock_c8_direct_gather
.purgem flock_c8_direct_pair
.section .rodata

.p2align 6
.Lflock_c8_direct_oct_even:
    .byte 0, 16, 32, 48, 64, 80, 96, 112, 1, 17, 33, 49, 65, 81, 97, 113, 2, 18, 34, 50, 66, 82, 98, 114, 3, 19, 35, 51, 67, 83, 99, 115, 4, 20, 36, 52, 68, 84, 100, 116, 5, 21, 37, 53, 69, 85, 101, 117, 6, 22, 38, 54, 70, 86, 102, 118, 7, 23, 39, 55, 71, 87, 103, 119

.p2align 6
.Lflock_c8_direct_oct_odd:
    .byte 8, 24, 40, 56, 72, 88, 104, 120, 9, 25, 41, 57, 73, 89, 105, 121, 10, 26, 42, 58, 74, 90, 106, 122, 11, 27, 43, 59, 75, 91, 107, 123, 12, 28, 44, 60, 76, 92, 108, 124, 13, 29, 45, 61, 77, 93, 109, 125, 14, 30, 46, 62, 78, 94, 110, 126, 15, 31, 47, 63, 79, 95, 111, 127

.p2align 6
.Lflock_c8_direct_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c8_direct_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127

.p2align 6
.Lflock_c8_direct_transpose_bytes:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
