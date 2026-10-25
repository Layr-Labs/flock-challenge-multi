// SPDX-License-Identifier: Apache-2.0 OR MIT
// Exact composed GFNI fold, lane-major output, with a private register ABI.
// Inputs: RDI = 512 input bytes, RSI = CFoldMats.1, RDX = 256 output bytes.
// Clobbers: RAX, flags, ZMM0..11. Preserves every other GPR and ZMM12..31.
// ZMM12/13 are explicitly saved/restored while reusing each matrix across passes.
// Called ONLY by the matching inline-asm wrapper, never through the C ABI.
// No vzeroupper: the upper lanes of ZMM12..15 belong to the caller.
.text
.p2align 6
.globl flock_gfni_c4_lm_preserving
.hidden flock_gfni_c4_lm_preserving
.type flock_gfni_c4_lm_preserving,@function
flock_gfni_c4_lm_preserving:
    mov rax, rsp
    and rsp, -64
    sub rsp, 640
    // Borrow two additional vector registers without changing the private ABI.
    vmovdqa64 [rsp + 512], zmm12
    vmovdqa64 [rsp + 576], zmm13
    vmovdqa64 zmm10, [rip + .Lflock_c4_g1_lo]
    vmovdqa64 zmm11, [rip + .Lflock_c4_g1_hi]
    vmovdqa64 zmm8, [rip + .Lflock_c4_oct_even]
    vmovdqa64 zmm9, [rip + .Lflock_c4_oct_odd]

// Materialize both passes before publishing anything, just as in Rust.
.macro flock_c4_gather p
    vmovdqu64 zmm0, [rdi + 64*\p]
    vmovdqu64 zmm1, [rdi + 64*\p + 128]
    vmovdqu64 zmm2, [rdi + 64*\p + 256]
    vmovdqu64 zmm3, [rdi + 64*\p + 384]
    vmovdqa64 zmm4, zmm0
    vpermt2q zmm4, zmm10, zmm1
    vpermt2q zmm0, zmm11, zmm1
    vmovdqa64 zmm5, zmm2
    vpermt2q zmm5, zmm10, zmm3
    vpermt2q zmm2, zmm11, zmm3
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
    flock_c4_gather 0
    flock_c4_gather 1

// Octet k = 8a + j of pass p sits at [rsp + 256*p + 8*k]; it multiplies the
// low matrix [rsi + 64*k] and the high matrix [rsi + 2048 + 64*k]. Each pair
// is loaded once into ZMM12/13 and applied to both independent passes.
.macro flock_c4_shared l0, h0, l1, h1, k
    vmovdqu64 zmm12, [rsi + 64*\k]
    vmovdqu64 zmm13, [rsi + 2048 + 64*\k]
    vpbroadcastq zmm\l0, [rsp + 8*\k]
    vgf2p8affineqb zmm\h0, zmm\l0, zmm13, 0
    vgf2p8affineqb zmm\l0, zmm\l0, zmm12, 0
    vpbroadcastq zmm\l1, [rsp + 256 + 8*\k]
    vgf2p8affineqb zmm\h1, zmm\l1, zmm13, 0
    vgf2p8affineqb zmm\l1, zmm\l1, zmm12, 0
.endm
// ZMM0/1 accumulate pass 0 low/high, ZMM2/3 pass 1 low/high.
.macro flock_c4_shared_fold k0, k1
    flock_c4_shared 4, 5, 6, 7, \k0
    flock_c4_shared 8, 9, 10, 11, \k1
    vpternlogq zmm0, zmm4, zmm8, 0x96
    vpternlogq zmm1, zmm5, zmm9, 0x96
    vpternlogq zmm2, zmm6, zmm10, 0x96
    vpternlogq zmm3, zmm7, zmm11, 0x96
.endm
    flock_c4_shared 0, 1, 2, 3, 0
    flock_c4_shared_fold 1, 2
    flock_c4_shared_fold 3, 4
    flock_c4_shared_fold 5, 6
    flock_c4_shared_fold 7, 8
    flock_c4_shared_fold 9, 10
    flock_c4_shared_fold 11, 12
    flock_c4_shared_fold 13, 14
    flock_c4_shared_fold 15, 16
    flock_c4_shared_fold 17, 18
    flock_c4_shared_fold 19, 20
    flock_c4_shared_fold 21, 22
    flock_c4_shared_fold 23, 24
    flock_c4_shared_fold 25, 26
    flock_c4_shared_fold 27, 28
    flock_c4_shared_fold 29, 30
    flock_c4_shared 4, 5, 6, 7, 31
    vpxorq zmm0, zmm0, zmm4
    vpxorq zmm1, zmm1, zmm5
    vpxorq zmm2, zmm2, zmm6
    vpxorq zmm3, zmm3, zmm7
    vmovdqa64 zmm4, [rip + .Lflock_c4_out_even]
    vmovdqa64 zmm5, [rip + .Lflock_c4_out_odd]
    vmovdqa64 zmm8, zmm0
    vpermt2b zmm8, zmm4, zmm1
    vpermt2b zmm0, zmm5, zmm1
    vmovdqu64 [rdx], zmm8
    vmovdqu64 [rdx + 64], zmm0
    vmovdqa64 zmm9, zmm2
    vpermt2b zmm9, zmm4, zmm3
    vpermt2b zmm2, zmm5, zmm3
    vmovdqu64 [rdx + 128], zmm9
    vmovdqu64 [rdx + 192], zmm2
    vmovdqa64 zmm12, [rsp + 512]
    vmovdqa64 zmm13, [rsp + 576]
    mov rsp, rax
    ret
.size flock_gfni_c4_lm_preserving, .-flock_gfni_c4_lm_preserving
.purgem flock_c4_gather
.purgem flock_c4_shared
.purgem flock_c4_shared_fold

.section .rodata

.p2align 6
.Lflock_c4_g1_lo:
    .quad 0, 4, 8, 12, 1, 5, 9, 13

.p2align 6
.Lflock_c4_g1_hi:
    .quad 2, 6, 10, 14, 3, 7, 11, 15

.p2align 6
.Lflock_c4_oct_even:
    .byte 0, 8, 16, 24, 64, 72, 80, 88, 1, 9, 17, 25, 65, 73, 81, 89, 2, 10, 18, 26, 66, 74, 82, 90, 3, 11, 19, 27, 67, 75, 83, 91, 4, 12, 20, 28, 68, 76, 84, 92, 5, 13, 21, 29, 69, 77, 85, 93, 6, 14, 22, 30, 70, 78, 86, 94, 7, 15, 23, 31, 71, 79, 87, 95

.p2align 6
.Lflock_c4_oct_odd:
    .byte 32, 40, 48, 56, 96, 104, 112, 120, 33, 41, 49, 57, 97, 105, 113, 121, 34, 42, 50, 58, 98, 106, 114, 122, 35, 43, 51, 59, 99, 107, 115, 123, 36, 44, 52, 60, 100, 108, 116, 124, 37, 45, 53, 61, 101, 109, 117, 125, 38, 46, 54, 62, 102, 110, 118, 126, 39, 47, 55, 63, 103, 111, 119, 127

.p2align 6
.Lflock_c4_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c4_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
