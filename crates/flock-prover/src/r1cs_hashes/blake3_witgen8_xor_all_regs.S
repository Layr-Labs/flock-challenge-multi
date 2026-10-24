// Private suffix ABI: A projection in zmm0..7; rsi B row, rcx B matrices; zmm24..31 accumulator.
// The caller executes the identical 78-instruction A prefix immediately before each private call.
// All general registers are preserved. No stack operands or nested calls.
.section .text.flock_projection_mode00_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode00_register_add
.hidden flock_projection_mode00_register_add
.type flock_projection_mode00_register_add,@function
flock_projection_mode00_register_add:
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
.size flock_projection_mode00_register_add,.-flock_projection_mode00_register_add
.section .text.flock_projection_mode00_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode00_register_first
.hidden flock_projection_mode00_register_first
.type flock_projection_mode00_register_first,@function
flock_projection_mode00_register_first:
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
.size flock_projection_mode00_register_first,.-flock_projection_mode00_register_first
.section .text.flock_projection_mode01_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode01_register_add
.hidden flock_projection_mode01_register_add
.type flock_projection_mode01_register_add,@function
flock_projection_mode01_register_add:
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vmovdqa64 zmm8, zmm9
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode01_register_add,.-flock_projection_mode01_register_add
.section .text.flock_projection_mode01_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode01_register_first
.hidden flock_projection_mode01_register_first
.type flock_projection_mode01_register_first,@function
flock_projection_mode01_register_first:
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vmovdqa64 zmm8, zmm9
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode01_register_first,.-flock_projection_mode01_register_first
.section .text.flock_projection_mode02_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode02_register_add
.hidden flock_projection_mode02_register_add
.type flock_projection_mode02_register_add,@function
flock_projection_mode02_register_add:
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vmovdqa64 zmm8, zmm10
    vmovdqa64 zmm9, zmm11
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode02_register_add,.-flock_projection_mode02_register_add
.section .text.flock_projection_mode02_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode02_register_first
.hidden flock_projection_mode02_register_first
.type flock_projection_mode02_register_first,@function
flock_projection_mode02_register_first:
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vmovdqa64 zmm8, zmm10
    vmovdqa64 zmm9, zmm11
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode02_register_first,.-flock_projection_mode02_register_first
.section .text.flock_projection_mode03_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode03_register_add
.hidden flock_projection_mode03_register_add
.type flock_projection_mode03_register_add,@function
flock_projection_mode03_register_add:
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vmovdqa64 zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vmovdqa64 zmm8, zmm10
    vmovdqa64 zmm9, zmm11
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode03_register_add,.-flock_projection_mode03_register_add
.section .text.flock_projection_mode03_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode03_register_first
.hidden flock_projection_mode03_register_first
.type flock_projection_mode03_register_first,@function
flock_projection_mode03_register_first:
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vmovdqa64 zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vmovdqa64 zmm8, zmm10
    vmovdqa64 zmm9, zmm11
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
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode03_register_first,.-flock_projection_mode03_register_first
.section .text.flock_projection_mode04_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode04_register_add
.hidden flock_projection_mode04_register_add
.type flock_projection_mode04_register_add,@function
flock_projection_mode04_register_add:
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vmovdqu64 zmm16, zmmword ptr [rcx + 768]
    vmovdqu64 zmm17, zmmword ptr [rcx + 832]
    vmovdqu64 zmm18, zmmword ptr [rcx + 896]
    vmovdqu64 zmm19, zmmword ptr [rcx + 960]
    vgf2p8affineqb zmm11, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm11, zmm11, zmm22
    vgf2p8affineqb zmm10, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm10, zmm10, zmm22
    vgf2p8affineqb zmm9, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm9, zmm9, zmm22
    vgf2p8affineqb zmm8, zmm12, zmm16, 0
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vgf2p8affineqb zmm15, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm12, zmm12, zmm8
    vpxorq zmm13, zmm13, zmm9
    vpxorq zmm14, zmm14, zmm10
    vpxorq zmm15, zmm15, zmm11
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode04_register_add,.-flock_projection_mode04_register_add
.section .text.flock_projection_mode04_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode04_register_first
.hidden flock_projection_mode04_register_first
.type flock_projection_mode04_register_first,@function
flock_projection_mode04_register_first:
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpbroadcastq zmm15, qword ptr [rsi + 56]
    vpternlogq zmm15, zmm15, zmm15, 0x55
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vmovdqu64 zmm16, zmmword ptr [rcx + 768]
    vmovdqu64 zmm17, zmmword ptr [rcx + 832]
    vmovdqu64 zmm18, zmmword ptr [rcx + 896]
    vmovdqu64 zmm19, zmmword ptr [rcx + 960]
    vgf2p8affineqb zmm11, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm11, zmm11, zmm22
    vgf2p8affineqb zmm10, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm10, zmm10, zmm22
    vgf2p8affineqb zmm9, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm9, zmm9, zmm22
    vgf2p8affineqb zmm8, zmm12, zmm16, 0
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vgf2p8affineqb zmm15, zmm15, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm13, zmm18, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm14, zmm17, 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm14, zmm14, zmm15
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm13, zmm13, zmm15
    vpxorq zmm12, zmm12, zmm8
    vpxorq zmm13, zmm13, zmm9
    vpxorq zmm14, zmm14, zmm10
    vpxorq zmm15, zmm15, zmm11
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode04_register_first,.-flock_projection_mode04_register_first
.section .text.flock_projection_mode05_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode05_register_add
.hidden flock_projection_mode05_register_add
.type flock_projection_mode05_register_add,@function
flock_projection_mode05_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 40]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 48]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vpbroadcastq zmm18, qword ptr [rsi + 56]
    vpternlogq zmm18, zmm18, zmm18, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vgf2p8affineqb zmm19, zmm18, zmm15, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vgf2p8affineqb zmm19, zmm18, zmm14, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vgf2p8affineqb zmm19, zmm18, zmm13, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vgf2p8affineqb zmm19, zmm18, zmm12, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vgf2p8affineqb zmm19, zmm18, zmm11, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vgf2p8affineqb zmm19, zmm18, zmm10, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vgf2p8affineqb zmm19, zmm18, zmm9, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vgf2p8affineqb zmm19, zmm18, zmm8, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode05_register_add,.-flock_projection_mode05_register_add
.section .text.flock_projection_mode05_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode05_register_first
.hidden flock_projection_mode05_register_first
.type flock_projection_mode05_register_first,@function
flock_projection_mode05_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 40]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 48]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vpbroadcastq zmm18, qword ptr [rsi + 56]
    vpternlogq zmm18, zmm18, zmm18, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vgf2p8affineqb zmm19, zmm18, zmm15, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vgf2p8affineqb zmm19, zmm18, zmm14, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vgf2p8affineqb zmm19, zmm18, zmm13, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vgf2p8affineqb zmm19, zmm18, zmm12, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vgf2p8affineqb zmm19, zmm18, zmm11, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vgf2p8affineqb zmm19, zmm18, zmm10, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vgf2p8affineqb zmm19, zmm18, zmm9, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vgf2p8affineqb zmm19, zmm18, zmm8, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode05_register_first,.-flock_projection_mode05_register_first
.section .text.flock_projection_mode06_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode06_register_add
.hidden flock_projection_mode06_register_add
.type flock_projection_mode06_register_add,@function
flock_projection_mode06_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 48]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 56]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode06_register_add,.-flock_projection_mode06_register_add
.section .text.flock_projection_mode06_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode06_register_first
.hidden flock_projection_mode06_register_first
.type flock_projection_mode06_register_first,@function
flock_projection_mode06_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 48]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 56]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode06_register_first,.-flock_projection_mode06_register_first
.section .text.flock_projection_mode07_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode07_register_add
.hidden flock_projection_mode07_register_add
.type flock_projection_mode07_register_add,@function
flock_projection_mode07_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 56]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 448], 0
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 384], 0
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 320], 0
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 256], 0
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 192], 0
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 128], 0
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 64], 0
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 0], 0
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode07_register_add,.-flock_projection_mode07_register_add
.section .text.flock_projection_mode07_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode07_register_first
.hidden flock_projection_mode07_register_first
.type flock_projection_mode07_register_first,@function
flock_projection_mode07_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 56]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 448], 0
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 384], 0
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 320], 0
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 256], 0
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 192], 0
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 128], 0
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 64], 0
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 0], 0
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode07_register_first,.-flock_projection_mode07_register_first
.section .text.flock_projection_mode08_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode08_register_add
.hidden flock_projection_mode08_register_add
.type flock_projection_mode08_register_add,@function
flock_projection_mode08_register_add:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm14, zmm17, 0
    vgf2p8affineqb zmm22, zmm13, zmm18, 0
    vgf2p8affineqb zmm23, zmm12, zmm19, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm11, zmm20, 0
    vgf2p8affineqb zmm23, zmm10, zmm21, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm9, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 960], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode08_register_add,.-flock_projection_mode08_register_add
.section .text.flock_projection_mode08_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode08_register_first
.hidden flock_projection_mode08_register_first
.type flock_projection_mode08_register_first,@function
flock_projection_mode08_register_first:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpbroadcastq zmm14, qword ptr [rsi + 48]
    vpternlogq zmm14, zmm14, zmm14, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm12, zmm12, zmm14
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vpxorq zmm10, zmm10, zmm14
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm14, zmm17, 0
    vgf2p8affineqb zmm22, zmm13, zmm18, 0
    vgf2p8affineqb zmm23, zmm12, zmm19, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm11, zmm20, 0
    vgf2p8affineqb zmm23, zmm10, zmm21, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm9, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 960], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm14, zmm14, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm18, 0
    vgf2p8affineqb zmm23, zmm10, zmm20, 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode08_register_first,.-flock_projection_mode08_register_first
.section .text.flock_projection_mode09_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode09_register_add
.hidden flock_projection_mode09_register_add
.type flock_projection_mode09_register_add,@function
flock_projection_mode09_register_add:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm13, zmm18, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm12, zmm18, 0
    vgf2p8affineqb zmm22, zmm10, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 896], 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode09_register_add,.-flock_projection_mode09_register_add
.section .text.flock_projection_mode09_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode09_register_first
.hidden flock_projection_mode09_register_first
.type flock_projection_mode09_register_first,@function
flock_projection_mode09_register_first:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpbroadcastq zmm13, qword ptr [rsi + 40]
    vpternlogq zmm13, zmm13, zmm13, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm12, zmm12, zmm13
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm8, zmm8, zmm12
    vpxorq zmm9, zmm9, zmm13
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm13, zmm18, 0
    vgf2p8affineqb zmm22, zmm12, zmm19, 0
    vgf2p8affineqb zmm23, zmm11, zmm20, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm12, zmm18, 0
    vgf2p8affineqb zmm22, zmm10, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 896], 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm13, zmm13, zmm16, 0
    vgf2p8affineqb zmm22, zmm12, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm20, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode09_register_first,.-flock_projection_mode09_register_first
.section .text.flock_projection_mode10_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode10_register_add
.hidden flock_projection_mode10_register_add
.type flock_projection_mode10_register_add,@function
flock_projection_mode10_register_add:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm8, zmm8, zmm12
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm12, zmm19, 0
    vgf2p8affineqb zmm22, zmm11, zmm20, 0
    vgf2p8affineqb zmm23, zmm10, zmm21, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm9, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 960], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm14, zmm12, zmm18, 0
    vgf2p8affineqb zmm22, zmm10, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 896], 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm13, zmm12, zmm17, 0
    vgf2p8affineqb zmm22, zmm9, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmm21, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode10_register_add,.-flock_projection_mode10_register_add
.section .text.flock_projection_mode10_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode10_register_first
.hidden flock_projection_mode10_register_first
.type flock_projection_mode10_register_first,@function
flock_projection_mode10_register_first:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpbroadcastq zmm12, qword ptr [rsi + 32]
    vpternlogq zmm12, zmm12, zmm12, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vpxorq zmm8, zmm8, zmm12
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm12, zmm19, 0
    vgf2p8affineqb zmm22, zmm11, zmm20, 0
    vgf2p8affineqb zmm23, zmm10, zmm21, 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm9, zmmword ptr [rcx + 896], 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 960], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm14, zmm12, zmm18, 0
    vgf2p8affineqb zmm22, zmm10, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmmword ptr [rcx + 896], 0
    vpternlogq zmm14, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm13, zmm12, zmm17, 0
    vgf2p8affineqb zmm22, zmm9, zmm20, 0
    vgf2p8affineqb zmm23, zmm8, zmm21, 0
    vpternlogq zmm13, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm12, zmm12, zmm16, 0
    vgf2p8affineqb zmm22, zmm8, zmm20, 0
    vpxorq zmm12, zmm12, zmm22
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode10_register_first,.-flock_projection_mode10_register_first
.section .text.flock_projection_mode11_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode11_register_add
.hidden flock_projection_mode11_register_add
.type flock_projection_mode11_register_add,@function
flock_projection_mode11_register_add:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm11, zmm20, 0
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm10, zmm20, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm9, zmm20, 0
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm8, zmm20, 0
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpternlogq zmm24, zmm0, zmm8, 0x96
    vgf2p8mulb zmm9, zmm1, zmm9
    vpternlogq zmm25, zmm1, zmm9, 0x96
    vgf2p8mulb zmm10, zmm2, zmm10
    vpternlogq zmm26, zmm2, zmm10, 0x96
    vgf2p8mulb zmm11, zmm3, zmm11
    vpternlogq zmm27, zmm3, zmm11, 0x96
    vgf2p8mulb zmm12, zmm4, zmm12
    vpternlogq zmm28, zmm4, zmm12, 0x96
    vgf2p8mulb zmm13, zmm5, zmm13
    vpternlogq zmm29, zmm5, zmm13, 0x96
    vgf2p8mulb zmm14, zmm6, zmm14
    vpternlogq zmm30, zmm6, zmm14, 0x96
    vgf2p8mulb zmm15, zmm7, zmm15
    vpternlogq zmm31, zmm7, zmm15, 0x96
    ret
.size flock_projection_mode11_register_add,.-flock_projection_mode11_register_add
.section .text.flock_projection_mode11_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode11_register_first
.hidden flock_projection_mode11_register_first
.type flock_projection_mode11_register_first,@function
flock_projection_mode11_register_first:
    vpbroadcastq zmm8, qword ptr [rsi + 0]
    vpternlogq zmm8, zmm8, zmm8, 0x55
    vpbroadcastq zmm9, qword ptr [rsi + 8]
    vpternlogq zmm9, zmm9, zmm9, 0x55
    vpbroadcastq zmm10, qword ptr [rsi + 16]
    vpternlogq zmm10, zmm10, zmm10, 0x55
    vpbroadcastq zmm11, qword ptr [rsi + 24]
    vpternlogq zmm11, zmm11, zmm11, 0x55
    vpxorq zmm8, zmm8, zmm9
    vpxorq zmm10, zmm10, zmm11
    vpxorq zmm8, zmm8, zmm10
    vpxorq zmm9, zmm9, zmm11
    vmovdqu64 zmm16, zmmword ptr [rcx + 512]
    vmovdqu64 zmm17, zmmword ptr [rcx + 576]
    vmovdqu64 zmm18, zmmword ptr [rcx + 640]
    vmovdqu64 zmm19, zmmword ptr [rcx + 704]
    vmovdqu64 zmm20, zmmword ptr [rcx + 768]
    vmovdqu64 zmm21, zmmword ptr [rcx + 832]
    vgf2p8affineqb zmm15, zmm11, zmm20, 0
    vgf2p8affineqb zmm22, zmm10, zmm21, 0
    vgf2p8affineqb zmm23, zmm9, zmmword ptr [rcx + 896], 0
    vpternlogq zmm15, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 960], 0
    vpxorq zmm15, zmm15, zmm22
    vgf2p8affineqb zmm14, zmm10, zmm20, 0
    vgf2p8affineqb zmm22, zmm8, zmmword ptr [rcx + 896], 0
    vpxorq zmm14, zmm14, zmm22
    vgf2p8affineqb zmm13, zmm9, zmm20, 0
    vgf2p8affineqb zmm22, zmm8, zmm21, 0
    vpxorq zmm13, zmm13, zmm22
    vgf2p8affineqb zmm12, zmm8, zmm20, 0
    vgf2p8affineqb zmm11, zmm11, zmm16, 0
    vgf2p8affineqb zmm22, zmm10, zmm17, 0
    vgf2p8affineqb zmm23, zmm9, zmm18, 0
    vpternlogq zmm11, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm8, zmm19, 0
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
    vgf2p8mulb zmm8, zmm0, zmm8
    vpxorq zmm24, zmm0, zmm8
    vgf2p8mulb zmm9, zmm1, zmm9
    vpxorq zmm25, zmm1, zmm9
    vgf2p8mulb zmm10, zmm2, zmm10
    vpxorq zmm26, zmm2, zmm10
    vgf2p8mulb zmm11, zmm3, zmm11
    vpxorq zmm27, zmm3, zmm11
    vgf2p8mulb zmm12, zmm4, zmm12
    vpxorq zmm28, zmm4, zmm12
    vgf2p8mulb zmm13, zmm5, zmm13
    vpxorq zmm29, zmm5, zmm13
    vgf2p8mulb zmm14, zmm6, zmm14
    vpxorq zmm30, zmm6, zmm14
    vgf2p8mulb zmm15, zmm7, zmm15
    vpxorq zmm31, zmm7, zmm15
    ret
.size flock_projection_mode11_register_first,.-flock_projection_mode11_register_first
.section .text.flock_projection_mode12_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode12_register_add
.hidden flock_projection_mode12_register_add
.type flock_projection_mode12_register_add,@function
flock_projection_mode12_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 8]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vpbroadcastq zmm18, qword ptr [rsi + 16]
    vpternlogq zmm18, zmm18, zmm18, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vgf2p8affineqb zmm19, zmm18, zmm10, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vgf2p8affineqb zmm19, zmm18, zmm11, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vgf2p8affineqb zmm19, zmm18, zmm8, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vgf2p8affineqb zmm19, zmm18, zmm9, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vgf2p8affineqb zmm19, zmm18, zmm14, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vgf2p8affineqb zmm19, zmm18, zmm15, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vgf2p8affineqb zmm19, zmm18, zmm12, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vgf2p8affineqb zmm19, zmm18, zmm13, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode12_register_add,.-flock_projection_mode12_register_add
.section .text.flock_projection_mode12_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode12_register_first
.hidden flock_projection_mode12_register_first
.type flock_projection_mode12_register_first,@function
flock_projection_mode12_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 8]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vpbroadcastq zmm18, qword ptr [rsi + 16]
    vpternlogq zmm18, zmm18, zmm18, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vgf2p8affineqb zmm19, zmm18, zmm10, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vgf2p8affineqb zmm19, zmm18, zmm11, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vgf2p8affineqb zmm19, zmm18, zmm8, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vgf2p8affineqb zmm19, zmm18, zmm9, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vgf2p8affineqb zmm19, zmm18, zmm14, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vgf2p8affineqb zmm19, zmm18, zmm15, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vgf2p8affineqb zmm19, zmm18, zmm12, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vgf2p8affineqb zmm19, zmm18, zmm13, 0
    vpternlogq zmm22, zmm23, zmm19, 0x96
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode12_register_first,.-flock_projection_mode12_register_first
.section .text.flock_projection_mode13_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode13_register_add
.hidden flock_projection_mode13_register_add
.type flock_projection_mode13_register_add,@function
flock_projection_mode13_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 8]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode13_register_add,.-flock_projection_mode13_register_add
.section .text.flock_projection_mode13_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode13_register_first
.hidden flock_projection_mode13_register_first
.type flock_projection_mode13_register_first,@function
flock_projection_mode13_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vpbroadcastq zmm17, qword ptr [rsi + 8]
    vpternlogq zmm17, zmm17, zmm17, 0x55
    vmovdqu64 zmm8, zmmword ptr [rcx + 0]
    vmovdqu64 zmm9, zmmword ptr [rcx + 64]
    vmovdqu64 zmm10, zmmword ptr [rcx + 128]
    vmovdqu64 zmm11, zmmword ptr [rcx + 192]
    vmovdqu64 zmm12, zmmword ptr [rcx + 256]
    vmovdqu64 zmm13, zmmword ptr [rcx + 320]
    vmovdqu64 zmm14, zmmword ptr [rcx + 384]
    vmovdqu64 zmm15, zmmword ptr [rcx + 448]
    vgf2p8affineqb zmm22, zmm16, zmm8, 0
    vgf2p8affineqb zmm23, zmm17, zmm9, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm9, 0
    vgf2p8affineqb zmm23, zmm17, zmm8, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm10, 0
    vgf2p8affineqb zmm23, zmm17, zmm11, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm11, 0
    vgf2p8affineqb zmm23, zmm17, zmm10, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm12, 0
    vgf2p8affineqb zmm23, zmm17, zmm13, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm13, 0
    vgf2p8affineqb zmm23, zmm17, zmm12, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm14, 0
    vgf2p8affineqb zmm23, zmm17, zmm15, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmm15, 0
    vgf2p8affineqb zmm23, zmm17, zmm14, 0
    vpxorq zmm22, zmm22, zmm23
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode13_register_first,.-flock_projection_mode13_register_first
.section .text.flock_projection_mode14_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode14_register_add
.hidden flock_projection_mode14_register_add
.type flock_projection_mode14_register_add,@function
flock_projection_mode14_register_add:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 0], 0
    vgf2p8mulb zmm22, zmm0, zmm22
    vpternlogq zmm24, zmm0, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 64], 0
    vgf2p8mulb zmm22, zmm1, zmm22
    vpternlogq zmm25, zmm1, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 128], 0
    vgf2p8mulb zmm22, zmm2, zmm22
    vpternlogq zmm26, zmm2, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 192], 0
    vgf2p8mulb zmm22, zmm3, zmm22
    vpternlogq zmm27, zmm3, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 256], 0
    vgf2p8mulb zmm22, zmm4, zmm22
    vpternlogq zmm28, zmm4, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 320], 0
    vgf2p8mulb zmm22, zmm5, zmm22
    vpternlogq zmm29, zmm5, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 384], 0
    vgf2p8mulb zmm22, zmm6, zmm22
    vpternlogq zmm30, zmm6, zmm22, 0x96
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 448], 0
    vgf2p8mulb zmm22, zmm7, zmm22
    vpternlogq zmm31, zmm7, zmm22, 0x96
    ret
.size flock_projection_mode14_register_add,.-flock_projection_mode14_register_add
.section .text.flock_projection_mode14_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode14_register_first
.hidden flock_projection_mode14_register_first
.type flock_projection_mode14_register_first,@function
flock_projection_mode14_register_first:
    vpbroadcastq zmm16, qword ptr [rsi + 0]
    vpternlogq zmm16, zmm16, zmm16, 0x55
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 0], 0
    vgf2p8mulb zmm22, zmm0, zmm22
    vpxorq zmm24, zmm0, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 64], 0
    vgf2p8mulb zmm22, zmm1, zmm22
    vpxorq zmm25, zmm1, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 128], 0
    vgf2p8mulb zmm22, zmm2, zmm22
    vpxorq zmm26, zmm2, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 192], 0
    vgf2p8mulb zmm22, zmm3, zmm22
    vpxorq zmm27, zmm3, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 256], 0
    vgf2p8mulb zmm22, zmm4, zmm22
    vpxorq zmm28, zmm4, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 320], 0
    vgf2p8mulb zmm22, zmm5, zmm22
    vpxorq zmm29, zmm5, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 384], 0
    vgf2p8mulb zmm22, zmm6, zmm22
    vpxorq zmm30, zmm6, zmm22
    vgf2p8affineqb zmm22, zmm16, zmmword ptr [rcx + 448], 0
    vgf2p8mulb zmm22, zmm7, zmm22
    vpxorq zmm31, zmm7, zmm22
    ret
.size flock_projection_mode14_register_first,.-flock_projection_mode14_register_first
.section .text.flock_projection_mode15_register_add,"ax",@progbits
.p2align 5
.globl flock_projection_mode15_register_add
.hidden flock_projection_mode15_register_add
.type flock_projection_mode15_register_add,@function
flock_projection_mode15_register_add:
    vpxorq zmm24, zmm24, zmm0
    vpxorq zmm25, zmm25, zmm1
    vpxorq zmm26, zmm26, zmm2
    vpxorq zmm27, zmm27, zmm3
    vpxorq zmm28, zmm28, zmm4
    vpxorq zmm29, zmm29, zmm5
    vpxorq zmm30, zmm30, zmm6
    vpxorq zmm31, zmm31, zmm7
    ret
.size flock_projection_mode15_register_add,.-flock_projection_mode15_register_add
.section .text.flock_projection_mode15_register_first,"ax",@progbits
.p2align 5
.globl flock_projection_mode15_register_first
.hidden flock_projection_mode15_register_first
.type flock_projection_mode15_register_first,@function
flock_projection_mode15_register_first:
    vmovdqa64 zmm24, zmm0
    vmovdqa64 zmm25, zmm1
    vmovdqa64 zmm26, zmm2
    vmovdqa64 zmm27, zmm3
    vmovdqa64 zmm28, zmm4
    vmovdqa64 zmm29, zmm5
    vmovdqa64 zmm30, zmm6
    vmovdqa64 zmm31, zmm7
    ret
.size flock_projection_mode15_register_first,.-flock_projection_mode15_register_first
.section .note.GNU-stack,"",@progbits
