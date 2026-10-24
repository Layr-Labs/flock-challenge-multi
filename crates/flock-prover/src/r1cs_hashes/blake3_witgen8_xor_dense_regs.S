// Dense MODE0 row products with eight accumulator arguments/results in
// zmm24..31. Called only by the Rust inline-assembly wrapper declaring all
// vector clobbers. All general registers are preserved. This is a private custom ABI, not a C-callable API.
// Input pointers: rdi=A rows, rsi=B rows, rdx=A matrix bank, rcx=B matrix bank.
// Superset transforms and 27-term GFNI convolutions match the scalar oracle.
.intel_syntax noprefix
.text
.p2align 5
.globl flock_projection_dense_register_add
.hidden flock_projection_dense_register_add
.type flock_projection_dense_register_add,@function
flock_projection_dense_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vpxorq zmm0, zmm0, zmm1
    vpxorq zmm2, zmm2, zmm3
    vpxorq zmm4, zmm4, zmm5
    vpxorq zmm6, zmm6, zmm7
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpxorq zmm4, zmm4, zmm6
    vpxorq zmm5, zmm5, zmm7
    vpxorq zmm0, zmm0, zmm4
    vpxorq zmm1, zmm1, zmm5
    vpxorq zmm2, zmm2, zmm6
    vpxorq zmm3, zmm3, zmm7
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vpxorq zmm3, zmm3, zmm22
    vgf2p8affineqb zmm2, zmm2, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm18, 0
    vpxorq zmm2, zmm2, zmm22
    vgf2p8affineqb zmm1, zmm1, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm17, 0
    vpxorq zmm1, zmm1, zmm22
    vgf2p8affineqb zmm0, zmm0, zmm16, 0
    vpxorq zmm0, zmm0, zmm1
    vpxorq zmm2, zmm2, zmm3
    vpxorq zmm4, zmm4, zmm5
    vpxorq zmm6, zmm6, zmm7
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpxorq zmm4, zmm4, zmm6
    vpxorq zmm5, zmm5, zmm7
    vpxorq zmm0, zmm0, zmm4
    vpxorq zmm1, zmm1, zmm5
    vpxorq zmm2, zmm2, zmm6
    vpxorq zmm3, zmm3, zmm7
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vpxorq zmm11, zmm11, zmm15
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vpxorq zmm11, zmm11, zmm22
    vgf2p8affineqb zmm10, zmm10, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm18, 0
    vpxorq zmm10, zmm10, zmm22
    vgf2p8affineqb zmm9, zmm9, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm17, 0
    vpxorq zmm9, zmm9, zmm22
    vgf2p8affineqb zmm8, zmm8, zmm16, 0
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vpxorq zmm11, zmm11, zmm15
    vgf2p8mulb zmm0, zmm0, zmm8
    vpxorq zmm24, zmm24, zmm0
    vgf2p8mulb zmm1, zmm1, zmm9
    vpxorq zmm25, zmm25, zmm1
    vgf2p8mulb zmm2, zmm2, zmm10
    vpxorq zmm26, zmm26, zmm2
    vgf2p8mulb zmm3, zmm3, zmm11
    vpxorq zmm27, zmm27, zmm3
    vgf2p8mulb zmm4, zmm4, zmm12
    vpxorq zmm28, zmm28, zmm4
    vgf2p8mulb zmm5, zmm5, zmm13
    vpxorq zmm29, zmm29, zmm5
    vgf2p8mulb zmm6, zmm6, zmm14
    vpxorq zmm30, zmm30, zmm6
    vgf2p8mulb zmm7, zmm7, zmm15
    vpxorq zmm31, zmm31, zmm7
    ret
.size flock_projection_dense_register_add,.-flock_projection_dense_register_add
.p2align 5
.globl flock_projection_dense_register_first
.hidden flock_projection_dense_register_first
.type flock_projection_dense_register_first,@function
flock_projection_dense_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vpxorq zmm0, zmm0, zmm1
    vpxorq zmm2, zmm2, zmm3
    vpxorq zmm4, zmm4, zmm5
    vpxorq zmm6, zmm6, zmm7
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpxorq zmm4, zmm4, zmm6
    vpxorq zmm5, zmm5, zmm7
    vpxorq zmm0, zmm0, zmm4
    vpxorq zmm1, zmm1, zmm5
    vpxorq zmm2, zmm2, zmm6
    vpxorq zmm3, zmm3, zmm7
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vpxorq zmm3, zmm3, zmm22
    vgf2p8affineqb zmm2, zmm2, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm18, 0
    vpxorq zmm2, zmm2, zmm22
    vgf2p8affineqb zmm1, zmm1, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm17, 0
    vpxorq zmm1, zmm1, zmm22
    vgf2p8affineqb zmm0, zmm0, zmm16, 0
    vpxorq zmm0, zmm0, zmm1
    vpxorq zmm2, zmm2, zmm3
    vpxorq zmm4, zmm4, zmm5
    vpxorq zmm6, zmm6, zmm7
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpxorq zmm4, zmm4, zmm6
    vpxorq zmm5, zmm5, zmm7
    vpxorq zmm0, zmm0, zmm4
    vpxorq zmm1, zmm1, zmm5
    vpxorq zmm2, zmm2, zmm6
    vpxorq zmm3, zmm3, zmm7
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vpxorq zmm11, zmm11, zmm15
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vpxorq zmm11, zmm11, zmm22
    vgf2p8affineqb zmm10, zmm10, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm18, 0
    vpxorq zmm10, zmm10, zmm22
    vgf2p8affineqb zmm9, zmm9, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm17, 0
    vpxorq zmm9, zmm9, zmm22
    vgf2p8affineqb zmm8, zmm8, zmm16, 0
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vpxorq zmm11, zmm11, zmm15
    vgf2p8mulb zmm24, zmm0, zmm8
    vgf2p8mulb zmm25, zmm1, zmm9
    vgf2p8mulb zmm26, zmm2, zmm10
    vgf2p8mulb zmm27, zmm3, zmm11
    vgf2p8mulb zmm28, zmm4, zmm12
    vgf2p8mulb zmm29, zmm5, zmm13
    vgf2p8mulb zmm30, zmm6, zmm14
    vgf2p8mulb zmm31, zmm7, zmm15
    ret
.size flock_projection_dense_register_first,.-flock_projection_dense_register_first
.section .note.GNU-stack,"",@progbits
