// SPDX-License-Identifier: Apache-2.0 OR MIT
// Software-pipelined forms of flock_gfni_c4_lm_register_result and
// flock_gfni_c4_pass4_register_result: the same GFNI/XOR sequence over an
// input that the PREVIOUS call already gathered (RDX), while this call gathers
// the NEXT call's input (RDI) into the other buffer (RCX) between its pair
// steps. The incumbent gathers at entry and broadcasts the freshly stored
// qwords at once, so every call starts behind a load -> shuffle -> permute ->
// store -> forwarded-load chain; here that chain runs in the shadow of the
// previous call's GFNI work. Same bytes, same operations, same order of the
// XOR accumulation: outputs are bit-identical. The gather and finish
// permutes use single-source vpermb + vpunpck instead of vpermi2b/vpermt2b
// (same bytes, one uop fewer each).
//
// Buffers: 64-byte aligned. A two-pass buffer is 512 bytes (pass p at 256*p,
// the incumbent's stack-scratch layout); a one-pass buffer is 256 bytes.
// RDX and RCX must not overlap. RDI is only read.
// Private register ABI (matching inline-asm wrappers only):
//   two-pass compute: returns ZMM8..11 like flock_gfni_c4_lm_register_result,
//     clobbers flags, ZMM0..7; preserves every GPR and ZMM12..31.
//   pass4 compute:    returns ZMM8, ZMM9 like flock_gfni_c4_pass4_register_result,
//     clobbers flags, ZMM0..7; preserves every GPR and ZMM10..31.
//   gather only:      clobbers ZMM0..7.
// No vzeroupper: the upper lanes of ZMM12..15 belong to the caller.
.text

// Two-pass gather of pass p from RDI (line stride 128 bytes) into RCX.
// Uses only ZMM0..7, which are dead between pair steps.
.macro flock_c4pp_g2 p
    vmovdqu64 zmm0, [rdi + 64*\p]
    vmovdqu64 zmm1, [rdi + 64*\p + 128]
    vmovdqu64 zmm2, [rdi + 64*\p + 256]
    vmovdqu64 zmm3, [rdi + 64*\p + 384]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm7, [rip + .Lflock_c4pp_dword_gather]
    vpermb zmm6, zmm7, zmm4
    vpermb zmm4, zmm7, zmm5
    vpunpckldq zmm5, zmm6, zmm4
    vpunpckhdq zmm6, zmm6, zmm4
    vmovdqa64 [rcx + 256*\p], zmm5
    vmovdqa64 [rcx + 256*\p + 64], zmm6
    vpermb zmm6, zmm7, zmm0
    vpermb zmm0, zmm7, zmm2
    vpunpckldq zmm2, zmm6, zmm0
    vpunpckhdq zmm6, zmm6, zmm0
    vmovdqa64 [rcx + 256*\p + 128], zmm2
    vmovdqa64 [rcx + 256*\p + 192], zmm6
.endm

// One-pass gather from RDI (line stride 64 bytes) into RCX: the pass4
// kernel's gather.
.macro flock_c4pp_g1
    vmovdqu64 zmm0, [rdi]
    vmovdqu64 zmm1, [rdi + 64]
    vmovdqu64 zmm2, [rdi + 128]
    vmovdqu64 zmm3, [rdi + 192]
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm7, [rip + .Lflock_c4pp_dword_gather]
    vpermb zmm6, zmm7, zmm4
    vpermb zmm4, zmm7, zmm5
    vpunpckldq zmm5, zmm6, zmm4
    vpunpckhdq zmm6, zmm6, zmm4
    vmovdqa64 [rcx], zmm5
    vmovdqa64 [rcx + 64], zmm6
    vpermb zmm6, zmm7, zmm0
    vpermb zmm0, zmm7, zmm2
    vpunpckldq zmm2, zmm6, zmm0
    vpunpckhdq zmm6, zmm6, zmm0
    vmovdqa64 [rcx + 128], zmm2
    vmovdqa64 [rcx + 192], zmm6
.endm

// flock_gfni_c4_lm_register_result's pair step, reading RDX.
.macro flock_c4pp_pair j
    vpbroadcastq zmm4, [rdx + 8*\j]
    vpbroadcastq zmm5, [rdx + 256 + 8*\j]
    vmovdqu64 zmm6, [rsi + 64*\j]
    vmovdqu64 zmm7, [rsi + 2048 + 64*\j]
    vgf2p8affineqb zmm0, zmm4, zmm6, 0
    vgf2p8affineqb zmm1, zmm4, zmm7, 0
    vgf2p8affineqb zmm2, zmm5, zmm6, 0
    vgf2p8affineqb zmm3, zmm5, zmm7, 0
    vpbroadcastq zmm4, [rdx + 8*(\j+1)]
    vpbroadcastq zmm5, [rdx + 256 + 8*(\j+1)]
    vmovdqu64 zmm6, [rsi + 64*(\j+1)]
    vgf2p8affineqb zmm7, zmm4, zmm6, 0
.if \j == 0
    vpxorq zmm8, zmm0, zmm7
.else
    vpternlogq zmm8, zmm0, zmm7, 0x96
.endif
    vmovdqu64 zmm0, [rsi + 2048 + 64*(\j+1)]
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

// flock_gfni_c4_lm_register_result's lane-major finish.
.macro flock_c4pp_finish2
    vmovdqa64 zmm2, [rip + .Lflock_c4pp_byte_tr]
    vpermb zmm0, zmm2, zmm8
    vpermb zmm1, zmm2, zmm9
    vpunpcklqdq zmm8, zmm0, zmm1
    vpunpckhqdq zmm9, zmm0, zmm1
    vpermb zmm0, zmm2, zmm10
    vpermb zmm1, zmm2, zmm11
    vpunpcklqdq zmm10, zmm0, zmm1
    vpunpckhqdq zmm11, zmm0, zmm1
.endm

// flock_gfni_c4_pass4_register_result's pair step, reading RDX.
.macro flock_c4pp_p4pair j
    vpbroadcastq zmm4, [rdx + 8*\j]
    vpbroadcastq zmm5, [rdx + 8*(\j+1)]
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

// Two-pass compute from RDX; gathers a two-pass input for the next call.
.p2align 6
.globl flock_gfni_c4_pipe_g2
.hidden flock_gfni_c4_pipe_g2
.type flock_gfni_c4_pipe_g2,@function
flock_gfni_c4_pipe_g2:
    flock_c4pp_pair 0
    flock_c4pp_pair 2
    flock_c4pp_pair 4
    flock_c4pp_pair 6
    flock_c4pp_g2 0
    flock_c4pp_pair 8
    flock_c4pp_pair 10
    flock_c4pp_pair 12
    flock_c4pp_pair 14
    flock_c4pp_g2 1
    flock_c4pp_pair 16
    flock_c4pp_pair 18
    flock_c4pp_pair 20
    flock_c4pp_pair 22
    flock_c4pp_pair 24
    flock_c4pp_pair 26
    flock_c4pp_pair 28
    flock_c4pp_pair 30
    flock_c4pp_finish2
    ret
.size flock_gfni_c4_pipe_g2, .-flock_gfni_c4_pipe_g2

// Two-pass compute from RDX; gathers a one-pass (pass4) input for the next call.
.p2align 6
.globl flock_gfni_c4_pipe_g1
.hidden flock_gfni_c4_pipe_g1
.type flock_gfni_c4_pipe_g1,@function
flock_gfni_c4_pipe_g1:
    flock_c4pp_pair 0
    flock_c4pp_pair 2
    flock_c4pp_pair 4
    flock_c4pp_pair 6
    flock_c4pp_pair 8
    flock_c4pp_g1
    flock_c4pp_pair 10
    flock_c4pp_pair 12
    flock_c4pp_pair 14
    flock_c4pp_pair 16
    flock_c4pp_pair 18
    flock_c4pp_pair 20
    flock_c4pp_pair 22
    flock_c4pp_pair 24
    flock_c4pp_pair 26
    flock_c4pp_pair 28
    flock_c4pp_pair 30
    flock_c4pp_finish2
    ret
.size flock_gfni_c4_pipe_g1, .-flock_gfni_c4_pipe_g1

// One-pass (pass4) compute from RDX; gathers a two-pass input for the next call.
.p2align 6
.globl flock_gfni_c4_pass4_pipe_g2
.hidden flock_gfni_c4_pass4_pipe_g2
.type flock_gfni_c4_pass4_pipe_g2,@function
flock_gfni_c4_pass4_pipe_g2:
    flock_c4pp_p4pair 0
    flock_c4pp_p4pair 2
    flock_c4pp_p4pair 4
    flock_c4pp_p4pair 6
    flock_c4pp_g2 0
    flock_c4pp_p4pair 8
    flock_c4pp_p4pair 10
    flock_c4pp_p4pair 12
    flock_c4pp_p4pair 14
    flock_c4pp_g2 1
    flock_c4pp_p4pair 16
    flock_c4pp_p4pair 18
    flock_c4pp_p4pair 20
    flock_c4pp_p4pair 22
    flock_c4pp_p4pair 24
    flock_c4pp_p4pair 26
    flock_c4pp_p4pair 28
    flock_c4pp_p4pair 30
    vmovdqa64 zmm2, [rip + .Lflock_c4pp_byte_tr]
    vpermb zmm0, zmm2, zmm8
    vpermb zmm1, zmm2, zmm9
    vpunpcklqdq zmm8, zmm0, zmm1
    vpunpckhqdq zmm9, zmm0, zmm1
    ret
.size flock_gfni_c4_pass4_pipe_g2, .-flock_gfni_c4_pass4_pipe_g2

// Gather only (pipeline prologue): two-pass input from RDI into RCX.
.p2align 6
.globl flock_gfni_c4_pipe_gather2
.hidden flock_gfni_c4_pipe_gather2
.type flock_gfni_c4_pipe_gather2,@function
flock_gfni_c4_pipe_gather2:
    flock_c4pp_g2 0
    flock_c4pp_g2 1
    ret
.size flock_gfni_c4_pipe_gather2, .-flock_gfni_c4_pipe_gather2

.purgem flock_c4pp_g2
.purgem flock_c4pp_g1
.purgem flock_c4pp_pair
.purgem flock_c4pp_finish2
.purgem flock_c4pp_p4pair
.section .rodata

// The incumbent's two-source tables, as single-source vpermb + vpunpck
// (two-source byte permutes cost three uops here, these two): vpermb each
// source with dword_gather, then vpunpckl/hdq = its oct_even / oct_odd;
// vpermb with byte_tr, then vpunpckl/hqdq = its out_even / out_odd.
.p2align 6
.Lflock_c4pp_dword_gather:
    .byte 0, 16, 32, 48, 1, 17, 33, 49, 8, 24, 40, 56, 9, 25, 41, 57, 2, 18, 34, 50, 3, 19, 35, 51, 10, 26, 42, 58, 11, 27, 43, 59, 4, 20, 36, 52, 5, 21, 37, 53, 12, 28, 44, 60, 13, 29, 45, 61, 6, 22, 38, 54, 7, 23, 39, 55, 14, 30, 46, 62, 15, 31, 47, 63

.p2align 6
.Lflock_c4pp_byte_tr:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
