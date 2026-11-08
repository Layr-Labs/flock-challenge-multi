// SPDX-License-Identifier: Apache-2.0 OR MIT
// Fixed 64-lane three-layer NTT. SysV arguments: rows, seven twiddles, dense lanes.
// Preconditions: dense <= 64, dense % 4 == 0; twiddles 1..7 have hi == 0;
// odd rows are zero in tail lanes. No stack or callee-saved GPR is touched.
.text
.p2align 6
.globl flock_ntt_three_64_0
.hidden flock_ntt_three_64_0
.type flock_ntt_three_64_0, @function
flock_ntt_three_64_0:
    shl rdx, 4
    xor eax, eax
    mov ecx, 0x87
    vmovq xmm31, rcx
    vshufi32x4 zmm31, zmm31, zmm31, 0
    vbroadcasti32x4 zmm16, [rsi]
    vbroadcasti32x4 zmm18, [rsi + 16]
    vbroadcasti32x4 zmm19, [rsi + 32]
    vbroadcasti32x4 zmm20, [rsi + 48]
    vbroadcasti32x4 zmm21, [rsi + 64]
    vbroadcasti32x4 zmm22, [rsi + 80]
    vbroadcasti32x4 zmm23, [rsi + 96]
    test rdx, rdx
    jz .Lthree_tail_0
.p2align 5
.Lthree_dense_0:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm1, [rdi + rax + 1024]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm3, [rdi + rax + 3072]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm5, [rdi + rax + 5120]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vmovdqu64 zmm7, [rdi + rax + 7168]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm25, zmm4, zmm16, 1
    vpxorq zmm0, zmm0, zmm24
    vmovdqa64 zmm8, zmm25
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm5, zmm16, 0
    vpclmulqdq zmm25, zmm5, zmm16, 1
    vpxorq zmm1, zmm1, zmm24
    vmovdqa64 zmm9, zmm25
    vpxorq zmm5, zmm5, zmm1
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm25, zmm6, zmm16, 1
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm7, zmm16, 0
    vpclmulqdq zmm25, zmm7, zmm16, 1
    vpxorq zmm3, zmm3, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm3, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm3
    vmovdqa64 zmm10, zmm8
    vmovdqa64 zmm11, zmm9
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm8, zmm8, zmm25
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm3, zmm18, 0
    vpclmulqdq zmm25, zmm3, zmm18, 1
    vpxorq zmm1, zmm1, zmm24
    vpxorq zmm9, zmm9, zmm25
    vpslldq zmm26, zmm9, 8
    vpclmulqdq zmm27, zmm9, zmm31, 1
    vpternlogq zmm1, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm1
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm10, zmm10, zmm25
    vpxorq zmm6, zmm6, zmm4
    vpclmulqdq zmm24, zmm7, zmm19, 0
    vpclmulqdq zmm25, zmm7, zmm19, 1
    vpxorq zmm5, zmm5, zmm24
    vpxorq zmm11, zmm11, zmm25
    vpslldq zmm26, zmm11, 8
    vpclmulqdq zmm27, zmm11, zmm31, 1
    vpternlogq zmm5, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm5
    vpclmulqdq zmm24, zmm1, zmm20, 0
    vpclmulqdq zmm25, zmm1, zmm20, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm1, zmm1, zmm0
    vpclmulqdq zmm24, zmm3, zmm21, 0
    vpclmulqdq zmm25, zmm3, zmm21, 1
    vpxorq zmm2, zmm2, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm2
    vpclmulqdq zmm24, zmm5, zmm22, 0
    vpclmulqdq zmm25, zmm5, zmm22, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm5, zmm5, zmm4
    vpclmulqdq zmm24, zmm7, zmm23, 0
    vpclmulqdq zmm25, zmm7, zmm23, 1
    vpxorq zmm6, zmm6, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm6, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm6
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm1
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm3
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm5
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm7
    add rax, 64
    cmp rax, rdx
    jb .Lthree_dense_0
.Lthree_tail_0:
    cmp rax, 1024
    jae .Lthree_done_0
.p2align 5
.Lthree_zero_0:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm25, zmm4, zmm16, 1
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm25, zmm6, zmm16, 1
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm4
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm0
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm2
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm4
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm6
    add rax, 64
    cmp rax, 1024
    jb .Lthree_zero_0
.Lthree_done_0:
    vzeroupper
    ret
.size flock_ntt_three_64_0, .-flock_ntt_three_64_0
.p2align 6
.globl flock_ntt_three_64_1
.hidden flock_ntt_three_64_1
.type flock_ntt_three_64_1, @function
flock_ntt_three_64_1:
    shl rdx, 4
    xor eax, eax
    mov ecx, 0x87
    vmovq xmm31, rcx
    vshufi32x4 zmm31, zmm31, zmm31, 0
    vbroadcasti32x4 zmm16, [rsi]
    vbroadcasti32x4 zmm18, [rsi + 16]
    vbroadcasti32x4 zmm19, [rsi + 32]
    vbroadcasti32x4 zmm20, [rsi + 48]
    vbroadcasti32x4 zmm21, [rsi + 64]
    vbroadcasti32x4 zmm22, [rsi + 80]
    vbroadcasti32x4 zmm23, [rsi + 96]
    test rdx, rdx
    jz .Lthree_tail_1
.p2align 5
.Lthree_dense_1:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm1, [rdi + rax + 1024]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm3, [rdi + rax + 3072]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm5, [rdi + rax + 5120]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vmovdqu64 zmm7, [rdi + rax + 7168]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm25, zmm4, zmm16, 1
    vpxorq zmm25, zmm25, zmm4
    vpxorq zmm0, zmm0, zmm24
    vmovdqa64 zmm8, zmm25
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm5, zmm16, 0
    vpclmulqdq zmm25, zmm5, zmm16, 1
    vpxorq zmm25, zmm25, zmm5
    vpxorq zmm1, zmm1, zmm24
    vmovdqa64 zmm9, zmm25
    vpxorq zmm5, zmm5, zmm1
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm25, zmm6, zmm16, 1
    vpxorq zmm25, zmm25, zmm6
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm7, zmm16, 0
    vpclmulqdq zmm25, zmm7, zmm16, 1
    vpxorq zmm25, zmm25, zmm7
    vpxorq zmm3, zmm3, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm3, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm3
    vmovdqa64 zmm10, zmm8
    vmovdqa64 zmm11, zmm9
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm8, zmm8, zmm25
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm3, zmm18, 0
    vpclmulqdq zmm25, zmm3, zmm18, 1
    vpxorq zmm1, zmm1, zmm24
    vpxorq zmm9, zmm9, zmm25
    vpslldq zmm26, zmm9, 8
    vpclmulqdq zmm27, zmm9, zmm31, 1
    vpternlogq zmm1, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm1
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm10, zmm10, zmm25
    vpxorq zmm6, zmm6, zmm4
    vpclmulqdq zmm24, zmm7, zmm19, 0
    vpclmulqdq zmm25, zmm7, zmm19, 1
    vpxorq zmm5, zmm5, zmm24
    vpxorq zmm11, zmm11, zmm25
    vpslldq zmm26, zmm11, 8
    vpclmulqdq zmm27, zmm11, zmm31, 1
    vpternlogq zmm5, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm5
    vpclmulqdq zmm24, zmm1, zmm20, 0
    vpclmulqdq zmm25, zmm1, zmm20, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm1, zmm1, zmm0
    vpclmulqdq zmm24, zmm3, zmm21, 0
    vpclmulqdq zmm25, zmm3, zmm21, 1
    vpxorq zmm2, zmm2, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm2
    vpclmulqdq zmm24, zmm5, zmm22, 0
    vpclmulqdq zmm25, zmm5, zmm22, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm5, zmm5, zmm4
    vpclmulqdq zmm24, zmm7, zmm23, 0
    vpclmulqdq zmm25, zmm7, zmm23, 1
    vpxorq zmm6, zmm6, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm6, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm6
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm1
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm3
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm5
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm7
    add rax, 64
    cmp rax, rdx
    jb .Lthree_dense_1
.Lthree_tail_1:
    cmp rax, 1024
    jae .Lthree_done_1
.p2align 5
.Lthree_zero_1:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm25, zmm4, zmm16, 1
    vpxorq zmm25, zmm25, zmm4
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm25, zmm6, zmm16, 1
    vpxorq zmm25, zmm25, zmm6
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm4
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm0
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm2
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm4
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm6
    add rax, 64
    cmp rax, 1024
    jb .Lthree_zero_1
.Lthree_done_1:
    vzeroupper
    ret
.size flock_ntt_three_64_1, .-flock_ntt_three_64_1
.p2align 6
.globl flock_ntt_three_64_2
.hidden flock_ntt_three_64_2
.type flock_ntt_three_64_2, @function
flock_ntt_three_64_2:
    shl rdx, 4
    xor eax, eax
    mov ecx, 0x87
    vmovq xmm31, rcx
    vshufi32x4 zmm31, zmm31, zmm31, 0
    vbroadcasti32x4 zmm16, [rsi]
    vpslldq zmm17, zmm16, 8
    vpclmulqdq zmm24, zmm16, zmm31, 1
    vpxorq zmm17, zmm17, zmm24
    vbroadcasti32x4 zmm18, [rsi + 16]
    vbroadcasti32x4 zmm19, [rsi + 32]
    vbroadcasti32x4 zmm20, [rsi + 48]
    vbroadcasti32x4 zmm21, [rsi + 64]
    vbroadcasti32x4 zmm22, [rsi + 80]
    vbroadcasti32x4 zmm23, [rsi + 96]
    test rdx, rdx
    jz .Lthree_tail_2
.p2align 5
.Lthree_dense_2:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm1, [rdi + rax + 1024]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm3, [rdi + rax + 3072]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm5, [rdi + rax + 5120]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vmovdqu64 zmm7, [rdi + rax + 7168]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm28, zmm4, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm4, zmm16, 16
    vpclmulqdq zmm28, zmm4, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm0, zmm0, zmm24
    vmovdqa64 zmm8, zmm25
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm5, zmm16, 0
    vpclmulqdq zmm28, zmm5, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm5, zmm16, 16
    vpclmulqdq zmm28, zmm5, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm1, zmm1, zmm24
    vmovdqa64 zmm9, zmm25
    vpxorq zmm5, zmm5, zmm1
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm28, zmm6, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm6, zmm16, 16
    vpclmulqdq zmm28, zmm6, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm7, zmm16, 0
    vpclmulqdq zmm28, zmm7, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm7, zmm16, 16
    vpclmulqdq zmm28, zmm7, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm3, zmm3, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm3, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm3
    vmovdqa64 zmm10, zmm8
    vmovdqa64 zmm11, zmm9
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm8, zmm8, zmm25
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm3, zmm18, 0
    vpclmulqdq zmm25, zmm3, zmm18, 1
    vpxorq zmm1, zmm1, zmm24
    vpxorq zmm9, zmm9, zmm25
    vpslldq zmm26, zmm9, 8
    vpclmulqdq zmm27, zmm9, zmm31, 1
    vpternlogq zmm1, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm1
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm10, zmm10, zmm25
    vpxorq zmm6, zmm6, zmm4
    vpclmulqdq zmm24, zmm7, zmm19, 0
    vpclmulqdq zmm25, zmm7, zmm19, 1
    vpxorq zmm5, zmm5, zmm24
    vpxorq zmm11, zmm11, zmm25
    vpslldq zmm26, zmm11, 8
    vpclmulqdq zmm27, zmm11, zmm31, 1
    vpternlogq zmm5, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm5
    vpclmulqdq zmm24, zmm1, zmm20, 0
    vpclmulqdq zmm25, zmm1, zmm20, 1
    vpxorq zmm0, zmm0, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm1, zmm1, zmm0
    vpclmulqdq zmm24, zmm3, zmm21, 0
    vpclmulqdq zmm25, zmm3, zmm21, 1
    vpxorq zmm2, zmm2, zmm24
    vpxorq zmm25, zmm25, zmm8
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm3, zmm3, zmm2
    vpclmulqdq zmm24, zmm5, zmm22, 0
    vpclmulqdq zmm25, zmm5, zmm22, 1
    vpxorq zmm4, zmm4, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm5, zmm5, zmm4
    vpclmulqdq zmm24, zmm7, zmm23, 0
    vpclmulqdq zmm25, zmm7, zmm23, 1
    vpxorq zmm6, zmm6, zmm24
    vpxorq zmm25, zmm25, zmm10
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm6, zmm26, zmm27, 0x96
    vpxorq zmm7, zmm7, zmm6
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm1
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm3
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm5
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm7
    add rax, 64
    cmp rax, rdx
    jb .Lthree_dense_2
.Lthree_tail_2:
    cmp rax, 1024
    jae .Lthree_done_2
.p2align 5
.Lthree_zero_2:
    vmovdqu64 zmm0, [rdi + rax + 0]
    vmovdqu64 zmm2, [rdi + rax + 2048]
    vmovdqu64 zmm4, [rdi + rax + 4096]
    vmovdqu64 zmm6, [rdi + rax + 6144]
    vpclmulqdq zmm24, zmm4, zmm16, 0
    vpclmulqdq zmm28, zmm4, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm4, zmm16, 16
    vpclmulqdq zmm28, zmm4, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm4, zmm4, zmm0
    vpclmulqdq zmm24, zmm6, zmm16, 0
    vpclmulqdq zmm28, zmm6, zmm17, 1
    vpxorq zmm24, zmm24, zmm28
    vpclmulqdq zmm25, zmm6, zmm16, 16
    vpclmulqdq zmm28, zmm6, zmm17, 17
    vpxorq zmm25, zmm25, zmm28
    vpxorq zmm2, zmm2, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm2, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm2
    vpclmulqdq zmm24, zmm2, zmm18, 0
    vpclmulqdq zmm25, zmm2, zmm18, 1
    vpxorq zmm0, zmm0, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm0, zmm26, zmm27, 0x96
    vpxorq zmm2, zmm2, zmm0
    vpclmulqdq zmm24, zmm6, zmm19, 0
    vpclmulqdq zmm25, zmm6, zmm19, 1
    vpxorq zmm4, zmm4, zmm24
    vpslldq zmm26, zmm25, 8
    vpclmulqdq zmm27, zmm25, zmm31, 1
    vpternlogq zmm4, zmm26, zmm27, 0x96
    vpxorq zmm6, zmm6, zmm4
    vmovdqu64 [rdi + rax + 0], zmm0
    vmovdqu64 [rdi + rax + 1024], zmm0
    vmovdqu64 [rdi + rax + 2048], zmm2
    vmovdqu64 [rdi + rax + 3072], zmm2
    vmovdqu64 [rdi + rax + 4096], zmm4
    vmovdqu64 [rdi + rax + 5120], zmm4
    vmovdqu64 [rdi + rax + 6144], zmm6
    vmovdqu64 [rdi + rax + 7168], zmm6
    add rax, 64
    cmp rax, 1024
    jb .Lthree_zero_2
.Lthree_done_2:
    vzeroupper
    ret
.size flock_ntt_three_64_2, .-flock_ntt_three_64_2
.section .note.GNU-stack,"",@progbits
