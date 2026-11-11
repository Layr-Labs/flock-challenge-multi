// SPDX-License-Identifier: Apache-2.0 OR MIT
// Direct eight-coefficient A/B fold. Private ABI: RDI=A1024B, RDX=B1024B,
// RSI=8192B low/high matrix table. Returns A in ZMM8..11, B in ZMM12..15.
// Clobbers RAX,flags,ZMM0..15; preserves other GPRs and ZMM16..31.
// Transpose from published 92d1814b; matrix-sharing schedule extends C4.
.text
.p2align 6
.globl flock_gfni_c8_ab_register_result
.hidden flock_gfni_c8_ab_register_result
.type flock_gfni_c8_ab_register_result,@function
flock_gfni_c8_ab_register_result:
 mov rax, rsp
 and rsp, -64
 sub rsp, 2048
.macro flock_c8_ab_gather src, p, dst
vmovdqu64 zmm0, [\src + 128*0 + 64*\p]
vmovdqu64 zmm1, [\src + 128*1 + 64*\p]
vmovdqu64 zmm2, [\src + 128*2 + 64*\p]
vmovdqu64 zmm3, [\src + 128*3 + 64*\p]
vmovdqu64 zmm4, [\src + 128*4 + 64*\p]
vmovdqu64 zmm5, [\src + 128*5 + 64*\p]
vmovdqu64 zmm6, [\src + 128*6 + 64*\p]
vmovdqu64 zmm7, [\src + 128*7 + 64*\p]
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
vmovdqa64 zmm11, [rip + .Lflock_c8_ab_transpose_bytes]
vpermb zmm3, zmm11, zmm3
vmovdqa64 [rsp + \dst + 0], zmm3
vpermb zmm10, zmm11, zmm10
vmovdqa64 [rsp + \dst + 64], zmm10
vpermb zmm4, zmm11, zmm4
vmovdqa64 [rsp + \dst + 128], zmm4
vpermb zmm9, zmm11, zmm9
vmovdqa64 [rsp + \dst + 192], zmm9
vpermb zmm2, zmm11, zmm2
vmovdqa64 [rsp + \dst + 256], zmm2
vpermb zmm6, zmm11, zmm6
vmovdqa64 [rsp + \dst + 320], zmm6
vpermb zmm5, zmm11, zmm5
vmovdqa64 [rsp + \dst + 384], zmm5
vpermb zmm7, zmm11, zmm7
vmovdqa64 [rsp + \dst + 448], zmm7
.endm
    flock_c8_ab_gather rdi, 0, 0
    flock_c8_ab_gather rdi, 1, 512
    flock_c8_ab_gather rdx, 0, 1024
    flock_c8_ab_gather rdx, 1, 1536
.macro flock_c8_ab_pass j, off, lo, hi
    vpbroadcastq zmm4, [rsp + \off + 8*\j]
    vgf2p8affineqb zmm6, zmm4, zmm0, 0
    vgf2p8affineqb zmm7, zmm4, zmm1, 0
    vpbroadcastq zmm5, [rsp + \off + 8*(\j+1)]
    vgf2p8affineqb zmm4, zmm5, zmm2, 0
.if \j == 0
    vpxorq \lo, zmm6, zmm4
.else
    vpternlogq \lo, zmm6, zmm4, 0x96
.endif
    vgf2p8affineqb zmm6, zmm5, zmm3, 0
.if \j == 0
    vpxorq \hi, zmm7, zmm6
.else
    vpternlogq \hi, zmm7, zmm6, 0x96
.endif
.endm
.macro flock_c8_ab_pair j
    vmovdqu64 zmm0, [rsi + 64*\j]
    vmovdqu64 zmm1, [rsi + 4096 + 64*\j]
    vmovdqu64 zmm2, [rsi + 64*(\j+1)]
    vmovdqu64 zmm3, [rsi + 4096 + 64*(\j+1)]
    flock_c8_ab_pass \j, 0, zmm8, zmm9
    flock_c8_ab_pass \j, 512, zmm10, zmm11
    flock_c8_ab_pass \j, 1024, zmm12, zmm13
    flock_c8_ab_pass \j, 1536, zmm14, zmm15
.endm
    flock_c8_ab_pair 0
    flock_c8_ab_pair 2
    flock_c8_ab_pair 4
    flock_c8_ab_pair 6
    flock_c8_ab_pair 8
    flock_c8_ab_pair 10
    flock_c8_ab_pair 12
    flock_c8_ab_pair 14
    flock_c8_ab_pair 16
    flock_c8_ab_pair 18
    flock_c8_ab_pair 20
    flock_c8_ab_pair 22
    flock_c8_ab_pair 24
    flock_c8_ab_pair 26
    flock_c8_ab_pair 28
    flock_c8_ab_pair 30
    flock_c8_ab_pair 32
    flock_c8_ab_pair 34
    flock_c8_ab_pair 36
    flock_c8_ab_pair 38
    flock_c8_ab_pair 40
    flock_c8_ab_pair 42
    flock_c8_ab_pair 44
    flock_c8_ab_pair 46
    flock_c8_ab_pair 48
    flock_c8_ab_pair 50
    flock_c8_ab_pair 52
    flock_c8_ab_pair 54
    flock_c8_ab_pair 56
    flock_c8_ab_pair 58
    flock_c8_ab_pair 60
    flock_c8_ab_pair 62
    vmovdqa64 zmm0, [rip + .Lflock_c8_ab_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_ab_out_odd]
    vpermi2b zmm0, zmm8, zmm9
    vpermi2b zmm1, zmm8, zmm9
    vmovdqa64 zmm8, zmm0
    vmovdqa64 zmm9, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c8_ab_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_ab_out_odd]
    vpermi2b zmm0, zmm10, zmm11
    vpermi2b zmm1, zmm10, zmm11
    vmovdqa64 zmm10, zmm0
    vmovdqa64 zmm11, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c8_ab_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_ab_out_odd]
    vpermi2b zmm0, zmm12, zmm13
    vpermi2b zmm1, zmm12, zmm13
    vmovdqa64 zmm12, zmm0
    vmovdqa64 zmm13, zmm1
    vmovdqa64 zmm0, [rip + .Lflock_c8_ab_out_even]
    vmovdqa64 zmm1, [rip + .Lflock_c8_ab_out_odd]
    vpermi2b zmm0, zmm14, zmm15
    vpermi2b zmm1, zmm14, zmm15
    vmovdqa64 zmm14, zmm0
    vmovdqa64 zmm15, zmm1
    vmovdqa64 zmm0,zmm9
    vmovdqa64 zmm9,zmm10
    vmovdqa64 zmm10,zmm0
    vmovdqa64 zmm0,zmm13
    vmovdqa64 zmm13,zmm14
    vmovdqa64 zmm14,zmm0
    mov rsp, rax
    ret
.size flock_gfni_c8_ab_register_result, .-flock_gfni_c8_ab_register_result
.purgem flock_c8_ab_gather
.purgem flock_c8_ab_pass
.purgem flock_c8_ab_pair
.section .rodata

.p2align 6
.Lflock_c8_ab_oct_even:
    .byte 0, 16, 32, 48, 64, 80, 96, 112, 1, 17, 33, 49, 65, 81, 97, 113, 2, 18, 34, 50, 66, 82, 98, 114, 3, 19, 35, 51, 67, 83, 99, 115, 4, 20, 36, 52, 68, 84, 100, 116, 5, 21, 37, 53, 69, 85, 101, 117, 6, 22, 38, 54, 70, 86, 102, 118, 7, 23, 39, 55, 71, 87, 103, 119

.p2align 6
.Lflock_c8_ab_oct_odd:
    .byte 8, 24, 40, 56, 72, 88, 104, 120, 9, 25, 41, 57, 73, 89, 105, 121, 10, 26, 42, 58, 74, 90, 106, 122, 11, 27, 43, 59, 75, 91, 107, 123, 12, 28, 44, 60, 76, 92, 108, 124, 13, 29, 45, 61, 77, 93, 109, 125, 14, 30, 46, 62, 78, 94, 110, 126, 15, 31, 47, 63, 79, 95, 111, 127

.p2align 6
.Lflock_c8_ab_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c8_ab_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127

.p2align 6
.Lflock_c8_ab_transpose_bytes:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
