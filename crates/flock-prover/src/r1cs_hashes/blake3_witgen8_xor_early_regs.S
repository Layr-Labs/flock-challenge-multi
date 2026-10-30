// Private register ABI: rdi/rsi rows, rdx/rcx matrices; zmm24..31 accumulator.
// All general registers are preserved. No stack operands or nested calls.
.section .text.flock_window_prepared_mode00_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode00_register_add
.hidden flock_window_prepared_mode00_register_add
.type flock_window_prepared_mode00_register_add,@function
flock_window_prepared_mode00_register_add:
    vpbroadcastq zmm0, qword ptr [rdi]
    vmovdqu64 zmm1, zmmword ptr [rdx+0x240]
    vmovdqu64 zmm2, zmmword ptr [rdx+0x280]
    vmovdqu64 zmm3, zmmword ptr [rdx+0x2c0]
    vpbroadcastq zmm4, qword ptr [rdi+0x8]
    vpbroadcastq zmm5, qword ptr [rdi+0x10]
    vgf2p8affineqb zmm6, zmm0, zmm3, 0x0
    vgf2p8affineqb zmm7, zmm4, zmm2, 0x0
    vgf2p8affineqb zmm8, zmm5, zmm1, 0x0
    vpternlogq zmm8, zmm6, zmm7, 0x96
    vpbroadcastq zmm6, qword ptr [rdi+0x18]
    vmovdqu64 zmm7, zmmword ptr [rdx+0x300]
    vpbroadcastq zmm9, qword ptr [rdi+0x20]
    vmovdqu64 zmm10, zmmword ptr [rdx+0x340]
    vgf2p8affineqb zmm11, zmm0, zmm10, 0x0
    vgf2p8affineqb zmm12, zmm4, zmm7, 0x0
    vgf2p8affineqb zmm13, zmm9, zmm1, 0x0
    vpternlogq zmm13, zmm11, zmm12, 0x96
    vpbroadcastq zmm11, qword ptr [rdi+0x28]
    vmovdqu64 zmm12, zmmword ptr [rdx+0x380]
    vgf2p8affineqb zmm14, zmm0, zmm12, 0x0
    vgf2p8affineqb zmm15, zmm5, zmm7, 0x0
    vgf2p8affineqb zmm16, zmm9, zmm2, 0x0
    vpternlogq zmm16, zmm14, zmm15, 0x96
    vpbroadcastq zmm14, qword ptr [rdi+0x30]
    vgf2p8affineqb zmm15, zmm0, zmmword ptr [rdx+0x3c0], 0x0
    vgf2p8affineqb zmm12, zmm4, zmm12, 0x0
    vgf2p8affineqb zmm10, zmm5, zmm10, 0x0
    vpternlogq zmm10, zmm15, zmm12, 0x96
    vgf2p8affineqb zmm12, zmm6, zmm7, 0x0
    vgf2p8affineqb zmm3, zmm9, zmm3, 0x0
    vpternlogq zmm3, zmm10, zmm12, 0x96
    vgf2p8affineqb zmm10, zmm11, zmm2, 0x0
    vgf2p8affineqb zmm12, zmm14, zmm1, 0x0
    vpternlogq zmm12, zmm3, zmm10, 0x96
    vmovdqu64 zmm3, zmmword ptr [rdx+0x200]
    vgf2p8affineqb zmm1, zmm0, zmm1, 0x0
    vgf2p8affineqb zmm4, zmm4, zmm3, 0x0
    vpxorq zmm1, zmm4, zmm1
    vgf2p8affineqb zmm6, zmm6, zmm3, 0x0
    vpxord zmm6, zmm6, zmm8
    vgf2p8affineqb zmm7, zmm0, zmm7, 0x0
    vgf2p8affineqb zmm9, zmm9, zmm3, 0x0
    vpxorq zmm7, zmm9, zmm7
    vgf2p8affineqb zmm11, zmm11, zmm3, 0x0
    vpxord zmm11, zmm11, zmm13
    vpbroadcastq zmm4, qword ptr [rdi+0x38]
    vgf2p8affineqb zmm4, zmm4, zmm3, 0x0
    vpxord zmm4, zmm4, zmm12
    vgf2p8affineqb zmm2, zmm0, zmm2, 0x0
    vgf2p8affineqb zmm5, zmm5, zmm3, 0x0
    vpternlogd zmm5, zmm6, zmm2, 0x96
    vgf2p8affineqb zmm14, zmm14, zmm3, 0x0
    vpternlogd zmm14, zmm4, zmm16, 0x96
    vpternlogd zmm7, zmm11, zmm14, 0x96
    vpxord zmm11, zmm4, zmm11
    vmovdqa64 zmm2, zmm11
    vpternlogd zmm2, zmm6, zmm1, 0x96
    vpxord zmm8, zmm14, zmm5
    vpxord zmm6, zmm4, zmm6
    vgf2p8affineqb zmm0, zmm0, zmm3, 0x0
    vpxorq zmm0, zmm0, zmm1
    vpternlogd zmm0, zmm5, zmm7, 0x96
    vpbroadcastq zmm1, qword ptr [rsi]
    vmovdqu64 zmm3, zmmword ptr [rcx+0x240]
    vmovdqu64 zmm5, zmmword ptr [rcx+0x280]
    vmovdqu64 zmm9, zmmword ptr [rcx+0x2c0]
    vpbroadcastq zmm10, qword ptr [rsi+0x8]
    vpbroadcastq zmm12, qword ptr [rsi+0x10]
    vgf2p8affineqb zmm13, zmm1, zmm9, 0x0
    vgf2p8affineqb zmm15, zmm10, zmm5, 0x0
    vgf2p8affineqb zmm16, zmm12, zmm3, 0x0
    vpternlogq zmm16, zmm13, zmm15, 0x96
    vpbroadcastq zmm13, qword ptr [rsi+0x18]
    vmovdqu64 zmm15, zmmword ptr [rcx+0x300]
    vpbroadcastq zmm17, qword ptr [rsi+0x20]
    vmovdqu64 zmm18, zmmword ptr [rcx+0x340]
    vgf2p8affineqb zmm19, zmm1, zmm18, 0x0
    vgf2p8affineqb zmm20, zmm10, zmm15, 0x0
    vgf2p8affineqb zmm21, zmm17, zmm3, 0x0
    vpternlogq zmm21, zmm19, zmm20, 0x96
    vmovdqu64 zmm19, zmmword ptr [rcx+0x380]
    vgf2p8affineqb zmm20, zmm1, zmm19, 0x0
    vgf2p8affineqb zmm22, zmm12, zmm15, 0x0
    vgf2p8affineqb zmm23, zmm17, zmm5, 0x0
    vpternlogq zmm23, zmm20, zmm22, 0x96
    vgf2p8affineqb zmm20, zmm1, zmmword ptr [rcx+0x3c0], 0x0
    vpbroadcastq zmm22, qword ptr [rsi+0x28]
    vgf2p8affineqb zmm19, zmm10, zmm19, 0x0
    vgf2p8affineqb zmm18, zmm12, zmm18, 0x0
    vpternlogq zmm18, zmm20, zmm19, 0x96
    vpbroadcastq zmm19, qword ptr [rsi+0x30]
    vgf2p8affineqb zmm20, zmm13, zmm15, 0x0
    vgf2p8affineqb zmm9, zmm17, zmm9, 0x0
    vpternlogq zmm9, zmm18, zmm20, 0x96
    vgf2p8affineqb zmm18, zmm22, zmm5, 0x0
    vgf2p8affineqb zmm20, zmm19, zmm3, 0x0
    vpternlogq zmm20, zmm9, zmm18, 0x96
    vmovdqu64 zmm9, zmmword ptr [rcx+0x200]
    vgf2p8affineqb zmm3, zmm1, zmm3, 0x0
    vgf2p8affineqb zmm10, zmm10, zmm9, 0x0
    vpxorq zmm3, zmm10, zmm3
    vgf2p8affineqb zmm13, zmm13, zmm9, 0x0
    vpxord zmm13, zmm13, zmm16
    vgf2p8affineqb zmm15, zmm1, zmm15, 0x0
    vgf2p8affineqb zmm17, zmm17, zmm9, 0x0
    vpxorq zmm15, zmm17, zmm15
    vgf2p8affineqb zmm5, zmm1, zmm5, 0x0
    vgf2p8affineqb zmm12, zmm12, zmm9, 0x0
    vgf2p8affineqb zmm22, zmm22, zmm9, 0x0
    vpxord zmm21, zmm22, zmm21
    vpbroadcastq zmm10, qword ptr [rsi+0x38]
    vgf2p8affineqb zmm10, zmm10, zmm9, 0x0
    vpxord zmm10, zmm10, zmm20
    vgf2p8mulb zmm4, zmm4, zmm10
    vpxorq zmm31, zmm31, zmm4
    vpternlogd zmm12, zmm13, zmm5, 0x96
    vpxord zmm4, zmm10, zmm21
    vgf2p8mulb zmm11, zmm11, zmm4
    vpxorq zmm29, zmm29, zmm11
    vgf2p8affineqb zmm19, zmm19, zmm9, 0x0
    vpternlogd zmm19, zmm10, zmm23, 0x96
    vgf2p8mulb zmm14, zmm14, zmm19
    vpxorq zmm30, zmm30, zmm14
    vpternlogd zmm4, zmm13, zmm3, 0x96
    vgf2p8mulb zmm2, zmm2, zmm4
    vpxorq zmm25, zmm25, zmm2
    vpxord zmm2, zmm19, zmm12
    vgf2p8mulb zmm2, zmm8, zmm2
    vpxorq zmm26, zmm26, zmm2
    vpxord zmm10, zmm10, zmm13
    vgf2p8mulb zmm6, zmm6, zmm10
    vpxorq zmm27, zmm27, zmm6
    vpternlogd zmm15, zmm21, zmm19, 0x96
    vgf2p8mulb zmm7, zmm7, zmm15
    vpxorq zmm28, zmm28, zmm7
    vgf2p8affineqb zmm1, zmm1, zmm9, 0x0
    vpxorq zmm1, zmm1, zmm3
    vpternlogd zmm1, zmm12, zmm15, 0x96
    vgf2p8mulb zmm0, zmm0, zmm1
    vpxorq zmm24, zmm24, zmm0
    ret
.size flock_window_prepared_mode00_register_add,.-flock_window_prepared_mode00_register_add
.section .text.flock_window_prepared_mode00_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode00_register_first
.hidden flock_window_prepared_mode00_register_first
.type flock_window_prepared_mode00_register_first,@function
flock_window_prepared_mode00_register_first:
    vpbroadcastq zmm0, qword ptr [rdi]
    vmovdqu64 zmm1, zmmword ptr [rdx+0x240]
    vmovdqu64 zmm2, zmmword ptr [rdx+0x280]
    vmovdqu64 zmm3, zmmword ptr [rdx+0x2c0]
    vpbroadcastq zmm4, qword ptr [rdi+0x8]
    vpbroadcastq zmm5, qword ptr [rdi+0x10]
    vgf2p8affineqb zmm6, zmm0, zmm3, 0x0
    vgf2p8affineqb zmm7, zmm4, zmm2, 0x0
    vgf2p8affineqb zmm8, zmm5, zmm1, 0x0
    vpternlogq zmm8, zmm6, zmm7, 0x96
    vpbroadcastq zmm6, qword ptr [rdi+0x18]
    vmovdqu64 zmm7, zmmword ptr [rdx+0x300]
    vpbroadcastq zmm9, qword ptr [rdi+0x20]
    vmovdqu64 zmm10, zmmword ptr [rdx+0x340]
    vgf2p8affineqb zmm11, zmm0, zmm10, 0x0
    vgf2p8affineqb zmm12, zmm4, zmm7, 0x0
    vgf2p8affineqb zmm13, zmm9, zmm1, 0x0
    vpternlogq zmm13, zmm11, zmm12, 0x96
    vpbroadcastq zmm11, qword ptr [rdi+0x28]
    vmovdqu64 zmm12, zmmword ptr [rdx+0x380]
    vgf2p8affineqb zmm14, zmm0, zmm12, 0x0
    vgf2p8affineqb zmm15, zmm5, zmm7, 0x0
    vgf2p8affineqb zmm16, zmm9, zmm2, 0x0
    vpternlogq zmm16, zmm14, zmm15, 0x96
    vpbroadcastq zmm14, qword ptr [rdi+0x30]
    vgf2p8affineqb zmm15, zmm0, zmmword ptr [rdx+0x3c0], 0x0
    vgf2p8affineqb zmm12, zmm4, zmm12, 0x0
    vgf2p8affineqb zmm10, zmm5, zmm10, 0x0
    vpternlogq zmm10, zmm15, zmm12, 0x96
    vgf2p8affineqb zmm12, zmm6, zmm7, 0x0
    vgf2p8affineqb zmm3, zmm9, zmm3, 0x0
    vpternlogq zmm3, zmm10, zmm12, 0x96
    vgf2p8affineqb zmm10, zmm11, zmm2, 0x0
    vgf2p8affineqb zmm12, zmm14, zmm1, 0x0
    vpternlogq zmm12, zmm3, zmm10, 0x96
    vmovdqu64 zmm3, zmmword ptr [rdx+0x200]
    vgf2p8affineqb zmm1, zmm0, zmm1, 0x0
    vgf2p8affineqb zmm4, zmm4, zmm3, 0x0
    vpxorq zmm1, zmm4, zmm1
    vgf2p8affineqb zmm6, zmm6, zmm3, 0x0
    vpxord zmm6, zmm6, zmm8
    vgf2p8affineqb zmm7, zmm0, zmm7, 0x0
    vgf2p8affineqb zmm9, zmm9, zmm3, 0x0
    vpxorq zmm7, zmm9, zmm7
    vgf2p8affineqb zmm11, zmm11, zmm3, 0x0
    vpxord zmm11, zmm11, zmm13
    vpbroadcastq zmm4, qword ptr [rdi+0x38]
    vgf2p8affineqb zmm4, zmm4, zmm3, 0x0
    vpxord zmm4, zmm4, zmm12
    vgf2p8affineqb zmm2, zmm0, zmm2, 0x0
    vgf2p8affineqb zmm5, zmm5, zmm3, 0x0
    vpternlogd zmm5, zmm6, zmm2, 0x96
    vgf2p8affineqb zmm14, zmm14, zmm3, 0x0
    vpternlogd zmm14, zmm4, zmm16, 0x96
    vpternlogd zmm7, zmm11, zmm14, 0x96
    vpxord zmm11, zmm4, zmm11
    vmovdqa64 zmm2, zmm11
    vpternlogd zmm2, zmm6, zmm1, 0x96
    vpxord zmm8, zmm14, zmm5
    vpxord zmm6, zmm4, zmm6
    vgf2p8affineqb zmm0, zmm0, zmm3, 0x0
    vpxorq zmm0, zmm0, zmm1
    vpternlogd zmm0, zmm5, zmm7, 0x96
    vpbroadcastq zmm1, qword ptr [rsi]
    vmovdqu64 zmm3, zmmword ptr [rcx+0x240]
    vmovdqu64 zmm5, zmmword ptr [rcx+0x280]
    vmovdqu64 zmm9, zmmword ptr [rcx+0x2c0]
    vpbroadcastq zmm10, qword ptr [rsi+0x8]
    vpbroadcastq zmm12, qword ptr [rsi+0x10]
    vgf2p8affineqb zmm13, zmm1, zmm9, 0x0
    vgf2p8affineqb zmm15, zmm10, zmm5, 0x0
    vgf2p8affineqb zmm16, zmm12, zmm3, 0x0
    vpternlogq zmm16, zmm13, zmm15, 0x96
    vpbroadcastq zmm13, qword ptr [rsi+0x18]
    vmovdqu64 zmm15, zmmword ptr [rcx+0x300]
    vpbroadcastq zmm17, qword ptr [rsi+0x20]
    vmovdqu64 zmm18, zmmword ptr [rcx+0x340]
    vgf2p8affineqb zmm19, zmm1, zmm18, 0x0
    vgf2p8affineqb zmm20, zmm10, zmm15, 0x0
    vgf2p8affineqb zmm21, zmm17, zmm3, 0x0
    vpternlogq zmm21, zmm19, zmm20, 0x96
    vmovdqu64 zmm19, zmmword ptr [rcx+0x380]
    vgf2p8affineqb zmm20, zmm1, zmm19, 0x0
    vgf2p8affineqb zmm22, zmm12, zmm15, 0x0
    vgf2p8affineqb zmm23, zmm17, zmm5, 0x0
    vpternlogq zmm23, zmm20, zmm22, 0x96
    vgf2p8affineqb zmm20, zmm1, zmmword ptr [rcx+0x3c0], 0x0
    vpbroadcastq zmm22, qword ptr [rsi+0x28]
    vgf2p8affineqb zmm19, zmm10, zmm19, 0x0
    vgf2p8affineqb zmm18, zmm12, zmm18, 0x0
    vpternlogq zmm18, zmm20, zmm19, 0x96
    vpbroadcastq zmm19, qword ptr [rsi+0x30]
    vgf2p8affineqb zmm20, zmm13, zmm15, 0x0
    vgf2p8affineqb zmm9, zmm17, zmm9, 0x0
    vpternlogq zmm9, zmm18, zmm20, 0x96
    vgf2p8affineqb zmm18, zmm22, zmm5, 0x0
    vgf2p8affineqb zmm20, zmm19, zmm3, 0x0
    vpternlogq zmm20, zmm9, zmm18, 0x96
    vmovdqu64 zmm9, zmmword ptr [rcx+0x200]
    vgf2p8affineqb zmm3, zmm1, zmm3, 0x0
    vgf2p8affineqb zmm10, zmm10, zmm9, 0x0
    vpxorq zmm3, zmm10, zmm3
    vgf2p8affineqb zmm13, zmm13, zmm9, 0x0
    vpxord zmm13, zmm13, zmm16
    vgf2p8affineqb zmm15, zmm1, zmm15, 0x0
    vgf2p8affineqb zmm17, zmm17, zmm9, 0x0
    vpxorq zmm15, zmm17, zmm15
    vgf2p8affineqb zmm5, zmm1, zmm5, 0x0
    vgf2p8affineqb zmm12, zmm12, zmm9, 0x0
    vgf2p8affineqb zmm22, zmm22, zmm9, 0x0
    vpxord zmm21, zmm22, zmm21
    vpbroadcastq zmm10, qword ptr [rsi+0x38]
    vgf2p8affineqb zmm10, zmm10, zmm9, 0x0
    vpxord zmm10, zmm10, zmm20
    vgf2p8mulb zmm31, zmm4, zmm10
    vpternlogd zmm12, zmm13, zmm5, 0x96
    vpxord zmm4, zmm10, zmm21
    vgf2p8mulb zmm29, zmm11, zmm4
    vgf2p8affineqb zmm19, zmm19, zmm9, 0x0
    vpternlogd zmm19, zmm10, zmm23, 0x96
    vgf2p8mulb zmm30, zmm14, zmm19
    vpternlogd zmm4, zmm13, zmm3, 0x96
    vgf2p8mulb zmm25, zmm2, zmm4
    vpxord zmm2, zmm19, zmm12
    vgf2p8mulb zmm26, zmm8, zmm2
    vpxord zmm10, zmm10, zmm13
    vgf2p8mulb zmm27, zmm6, zmm10
    vpternlogd zmm15, zmm21, zmm19, 0x96
    vgf2p8mulb zmm28, zmm7, zmm15
    vgf2p8affineqb zmm1, zmm1, zmm9, 0x0
    vpxorq zmm1, zmm1, zmm3
    vpternlogd zmm1, zmm12, zmm15, 0x96
    vgf2p8mulb zmm24, zmm0, zmm1
    ret
.size flock_window_prepared_mode00_register_first,.-flock_window_prepared_mode00_register_first
.section .text.flock_window_prepared_mode01_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode01_register_add
.hidden flock_window_prepared_mode01_register_add
.type flock_window_prepared_mode01_register_add,@function
flock_window_prepared_mode01_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode01_register_add,.-flock_window_prepared_mode01_register_add
.section .text.flock_window_prepared_mode01_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode01_register_first
.hidden flock_window_prepared_mode01_register_first
.type flock_window_prepared_mode01_register_first,@function
flock_window_prepared_mode01_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode01_register_first,.-flock_window_prepared_mode01_register_first
.section .text.flock_window_prepared_mode02_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode02_register_add
.hidden flock_window_prepared_mode02_register_add
.type flock_window_prepared_mode02_register_add,@function
flock_window_prepared_mode02_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode02_register_add,.-flock_window_prepared_mode02_register_add
.section .text.flock_window_prepared_mode02_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode02_register_first
.hidden flock_window_prepared_mode02_register_first
.type flock_window_prepared_mode02_register_first,@function
flock_window_prepared_mode02_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode02_register_first,.-flock_window_prepared_mode02_register_first
.section .text.flock_window_prepared_mode03_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode03_register_add
.hidden flock_window_prepared_mode03_register_add
.type flock_window_prepared_mode03_register_add,@function
flock_window_prepared_mode03_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode03_register_add,.-flock_window_prepared_mode03_register_add
.section .text.flock_window_prepared_mode03_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode03_register_first
.hidden flock_window_prepared_mode03_register_first
.type flock_window_prepared_mode03_register_first,@function
flock_window_prepared_mode03_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode03_register_first,.-flock_window_prepared_mode03_register_first
.section .text.flock_window_prepared_mode04_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode04_register_add
.hidden flock_window_prepared_mode04_register_add
.type flock_window_prepared_mode04_register_add,@function
flock_window_prepared_mode04_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode04_register_add,.-flock_window_prepared_mode04_register_add
.section .text.flock_window_prepared_mode04_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode04_register_first
.hidden flock_window_prepared_mode04_register_first
.type flock_window_prepared_mode04_register_first,@function
flock_window_prepared_mode04_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode04_register_first,.-flock_window_prepared_mode04_register_first
.section .text.flock_window_prepared_mode05_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode05_register_add
.hidden flock_window_prepared_mode05_register_add
.type flock_window_prepared_mode05_register_add,@function
flock_window_prepared_mode05_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode05_register_add,.-flock_window_prepared_mode05_register_add
.section .text.flock_window_prepared_mode05_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode05_register_first
.hidden flock_window_prepared_mode05_register_first
.type flock_window_prepared_mode05_register_first,@function
flock_window_prepared_mode05_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode05_register_first,.-flock_window_prepared_mode05_register_first
.section .text.flock_window_prepared_mode06_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode06_register_add
.hidden flock_window_prepared_mode06_register_add
.type flock_window_prepared_mode06_register_add,@function
flock_window_prepared_mode06_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode06_register_add,.-flock_window_prepared_mode06_register_add
.section .text.flock_window_prepared_mode06_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode06_register_first
.hidden flock_window_prepared_mode06_register_first
.type flock_window_prepared_mode06_register_first,@function
flock_window_prepared_mode06_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode06_register_first,.-flock_window_prepared_mode06_register_first
.section .text.flock_window_prepared_mode07_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode07_register_add
.hidden flock_window_prepared_mode07_register_add
.type flock_window_prepared_mode07_register_add,@function
flock_window_prepared_mode07_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode07_register_add,.-flock_window_prepared_mode07_register_add
.section .text.flock_window_prepared_mode07_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode07_register_first
.hidden flock_window_prepared_mode07_register_first
.type flock_window_prepared_mode07_register_first,@function
flock_window_prepared_mode07_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode07_register_first,.-flock_window_prepared_mode07_register_first
.section .text.flock_window_prepared_mode08_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode08_register_add
.hidden flock_window_prepared_mode08_register_add
.type flock_window_prepared_mode08_register_add,@function
flock_window_prepared_mode08_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode08_register_add,.-flock_window_prepared_mode08_register_add
.section .text.flock_window_prepared_mode08_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode08_register_first
.hidden flock_window_prepared_mode08_register_first
.type flock_window_prepared_mode08_register_first,@function
flock_window_prepared_mode08_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode08_register_first,.-flock_window_prepared_mode08_register_first
.section .text.flock_window_prepared_mode09_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode09_register_add
.hidden flock_window_prepared_mode09_register_add
.type flock_window_prepared_mode09_register_add,@function
flock_window_prepared_mode09_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode09_register_add,.-flock_window_prepared_mode09_register_add
.section .text.flock_window_prepared_mode09_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode09_register_first
.hidden flock_window_prepared_mode09_register_first
.type flock_window_prepared_mode09_register_first,@function
flock_window_prepared_mode09_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode09_register_first,.-flock_window_prepared_mode09_register_first
.section .text.flock_window_prepared_mode10_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode10_register_add
.hidden flock_window_prepared_mode10_register_add
.type flock_window_prepared_mode10_register_add,@function
flock_window_prepared_mode10_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode10_register_add,.-flock_window_prepared_mode10_register_add
.section .text.flock_window_prepared_mode10_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode10_register_first
.hidden flock_window_prepared_mode10_register_first
.type flock_window_prepared_mode10_register_first,@function
flock_window_prepared_mode10_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode10_register_first,.-flock_window_prepared_mode10_register_first
.section .text.flock_window_prepared_mode11_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode11_register_add
.hidden flock_window_prepared_mode11_register_add
.type flock_window_prepared_mode11_register_add,@function
flock_window_prepared_mode11_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode11_register_add,.-flock_window_prepared_mode11_register_add
.section .text.flock_window_prepared_mode11_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode11_register_first
.hidden flock_window_prepared_mode11_register_first
.type flock_window_prepared_mode11_register_first,@function
flock_window_prepared_mode11_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode11_register_first,.-flock_window_prepared_mode11_register_first
.section .text.flock_window_prepared_mode12_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode12_register_add
.hidden flock_window_prepared_mode12_register_add
.type flock_window_prepared_mode12_register_add,@function
flock_window_prepared_mode12_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode12_register_add,.-flock_window_prepared_mode12_register_add
.section .text.flock_window_prepared_mode12_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode12_register_first
.hidden flock_window_prepared_mode12_register_first
.type flock_window_prepared_mode12_register_first,@function
flock_window_prepared_mode12_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode12_register_first,.-flock_window_prepared_mode12_register_first
.section .text.flock_window_prepared_mode13_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode13_register_add
.hidden flock_window_prepared_mode13_register_add
.type flock_window_prepared_mode13_register_add,@function
flock_window_prepared_mode13_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode13_register_add,.-flock_window_prepared_mode13_register_add
.section .text.flock_window_prepared_mode13_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode13_register_first
.hidden flock_window_prepared_mode13_register_first
.type flock_window_prepared_mode13_register_first,@function
flock_window_prepared_mode13_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode13_register_first,.-flock_window_prepared_mode13_register_first
.section .text.flock_window_prepared_mode14_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode14_register_add
.hidden flock_window_prepared_mode14_register_add
.type flock_window_prepared_mode14_register_add,@function
flock_window_prepared_mode14_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode14_register_add,.-flock_window_prepared_mode14_register_add
.section .text.flock_window_prepared_mode14_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode14_register_first
.hidden flock_window_prepared_mode14_register_first
.type flock_window_prepared_mode14_register_first,@function
flock_window_prepared_mode14_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
.size flock_window_prepared_mode14_register_first,.-flock_window_prepared_mode14_register_first
.section .text.flock_window_prepared_mode15_register_add,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode15_register_add
.hidden flock_window_prepared_mode15_register_add
.type flock_window_prepared_mode15_register_add,@function
flock_window_prepared_mode15_register_add:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
    vpxorq zmm24, zmm24, zmm0
    vpxorq zmm25, zmm25, zmm1
    vpxorq zmm26, zmm26, zmm2
    vpxorq zmm27, zmm27, zmm3
    vpxorq zmm28, zmm28, zmm4
    vpxorq zmm29, zmm29, zmm5
    vpxorq zmm30, zmm30, zmm6
    vpxorq zmm31, zmm31, zmm7
    ret
.size flock_window_prepared_mode15_register_add,.-flock_window_prepared_mode15_register_add
.section .text.flock_window_prepared_mode15_register_first,"ax",@progbits
.p2align 5
.globl flock_window_prepared_mode15_register_first
.hidden flock_window_prepared_mode15_register_first
.type flock_window_prepared_mode15_register_first,@function
flock_window_prepared_mode15_register_first:
    vpbroadcastq zmm0, qword ptr [rdi + 0]
    vpbroadcastq zmm1, qword ptr [rdi + 8]
    vpbroadcastq zmm2, qword ptr [rdi + 16]
    vpbroadcastq zmm3, qword ptr [rdi + 24]
    vpbroadcastq zmm4, qword ptr [rdi + 32]
    vpbroadcastq zmm5, qword ptr [rdi + 40]
    vpbroadcastq zmm6, qword ptr [rdi + 48]
    vpbroadcastq zmm7, qword ptr [rdi + 56]
    vmovdqu64 zmm16, zmmword ptr [rdx + 512]
    vmovdqu64 zmm17, zmmword ptr [rdx + 576]
    vmovdqu64 zmm18, zmmword ptr [rdx + 640]
    vmovdqu64 zmm19, zmmword ptr [rdx + 704]
    vmovdqu64 zmm20, zmmword ptr [rdx + 768]
    vmovdqu64 zmm21, zmmword ptr [rdx + 832]
    vgf2p8affineqb zmm7, zmm7, zmm16, 0
    vgf2p8affineqb zmm22, zmm6, zmm17, 0
    vgf2p8affineqb zmm23, zmm5, zmm18, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm4, zmm19, 0
    vgf2p8affineqb zmm23, zmm3, zmm20, 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm2, zmm21, 0
    vgf2p8affineqb zmm23, zmm1, zmmword ptr [rdx + 896], 0
    vpternlogq zmm7, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 960], 0
    vpxorq zmm7, zmm7, zmm22
    vgf2p8affineqb zmm6, zmm6, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm18, 0
    vgf2p8affineqb zmm23, zmm2, zmm20, 0
    vpternlogq zmm6, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmmword ptr [rdx + 896], 0
    vpxorq zmm6, zmm6, zmm22
    vgf2p8affineqb zmm5, zmm5, zmm16, 0
    vgf2p8affineqb zmm22, zmm4, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm20, 0
    vpternlogq zmm5, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm21, 0
    vpxorq zmm5, zmm5, zmm22
    vgf2p8affineqb zmm4, zmm4, zmm16, 0
    vgf2p8affineqb zmm22, zmm0, zmm20, 0
    vpxorq zmm4, zmm4, zmm22
    vgf2p8affineqb zmm3, zmm3, zmm16, 0
    vgf2p8affineqb zmm22, zmm2, zmm17, 0
    vgf2p8affineqb zmm23, zmm1, zmm18, 0
    vpternlogq zmm3, zmm22, zmm23, 0x96
    vgf2p8affineqb zmm22, zmm0, zmm19, 0
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
    vmovdqa64 zmm24, zmm0
    vmovdqa64 zmm25, zmm1
    vmovdqa64 zmm26, zmm2
    vmovdqa64 zmm27, zmm3
    vmovdqa64 zmm28, zmm4
    vmovdqa64 zmm29, zmm5
    vmovdqa64 zmm30, zmm6
    vmovdqa64 zmm31, zmm7
    ret
.size flock_window_prepared_mode15_register_first,.-flock_window_prepared_mode15_register_first
.section .note.GNU-stack,"",@progbits

