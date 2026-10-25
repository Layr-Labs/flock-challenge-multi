// SPDX-License-Identifier: Apache-2.0 OR MIT
// Private ranked round2 ABI: RDI rows, RSI matrices, RDX output.
// RAX, flags and ZMM0..7 clobbered; every other GPR and ZMM8..31 preserved.
// No vzeroupper; 512 bytes of aligned scratch, all live input staged first.
.text
.p2align 6
.global flock_r2eight_single_full
.hidden flock_r2eight_single_full
.type flock_r2eight_single_full,@function
flock_r2eight_single_full:
mov rax, rsp
and rsp, -64
sub rsp, 1536
vmovdqa64 [rsp + 512], zmm8
vmovdqa64 [rsp + 576], zmm9
vmovdqa64 [rsp + 640], zmm10
vmovdqa64 [rsp + 704], zmm11
vmovdqa64 [rsp + 768], zmm12
vmovdqa64 [rsp + 832], zmm13
vmovdqa64 [rsp + 896], zmm14
vmovdqa64 [rsp + 960], zmm15
vmovdqa64 [rsp + 1024], zmm16
vmovdqa64 [rsp + 1088], zmm17
vmovdqa64 [rsp + 1152], zmm18
vmovdqa64 [rsp + 1216], zmm19
vmovdqa64 [rsp + 1280], zmm20
vmovdqa64 [rsp + 1344], zmm21
vmovdqa64 [rsp + 1408], zmm22
vmovdqa64 [rsp + 1472], zmm23
vmovdqu64 zmm8, [rsi + 0]
vmovdqu64 zmm9, [rsi + 64]
vmovdqu64 zmm10, [rsi + 128]
vmovdqu64 zmm11, [rsi + 192]
vmovdqu64 zmm12, [rsi + 256]
vmovdqu64 zmm13, [rsi + 320]
vmovdqu64 zmm14, [rsi + 384]
vmovdqu64 zmm15, [rsi + 448]
vmovdqu64 zmm16, [rsi + 512]
vmovdqu64 zmm17, [rsi + 576]
vmovdqu64 zmm18, [rsi + 640]
vmovdqu64 zmm19, [rsi + 704]
vmovdqu64 zmm20, [rsi + 768]
vmovdqu64 zmm21, [rsi + 832]
vmovdqu64 zmm22, [rsi + 896]
vmovdqu64 zmm23, [rsi + 960]
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 0]
vmovdqa64 [rsp + 0], zmm1
vpermb zmm1, zmm0, [rdi + 64]
vmovdqa64 [rsp + 64], zmm1
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpermb zmm1, zmm0, [rdi + 384]
vmovdqa64 [rsp + 384], zmm1
vpermb zmm1, zmm0, [rdi + 448]
vmovdqa64 [rsp + 448], zmm1
vpbroadcastq zmm0, [rsp + 0]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 8]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 16]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 24]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 32]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 40]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 48]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 56]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 64]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 72]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 80]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 88]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 96]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 104]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 112]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 120]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 0], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 256], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 512], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 768], zmm0
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
vpbroadcastq zmm0, [rsp + 384]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 392]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 400]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 408]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 416]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 424]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 432]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 440]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 448]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 456]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 464]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 472]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 480]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 488]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 496]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 504]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 192], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 448], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 704], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 960], zmm0
vmovdqa64 zmm8, [rsp + 512]
vmovdqa64 zmm9, [rsp + 576]
vmovdqa64 zmm10, [rsp + 640]
vmovdqa64 zmm11, [rsp + 704]
vmovdqa64 zmm12, [rsp + 768]
vmovdqa64 zmm13, [rsp + 832]
vmovdqa64 zmm14, [rsp + 896]
vmovdqa64 zmm15, [rsp + 960]
vmovdqa64 zmm16, [rsp + 1024]
vmovdqa64 zmm17, [rsp + 1088]
vmovdqa64 zmm18, [rsp + 1152]
vmovdqa64 zmm19, [rsp + 1216]
vmovdqa64 zmm20, [rsp + 1280]
vmovdqa64 zmm21, [rsp + 1344]
vmovdqa64 zmm22, [rsp + 1408]
vmovdqa64 zmm23, [rsp + 1472]
mov rsp, rax
ret
.size flock_r2eight_single_full, .-flock_r2eight_single_full
.p2align 6
.global flock_r2eight_single_0
.hidden flock_r2eight_single_0
.type flock_r2eight_single_0,@function
flock_r2eight_single_0:
mov rax, rsp
and rsp, -64
sub rsp, 1536
vmovdqa64 [rsp + 512], zmm8
vmovdqa64 [rsp + 576], zmm9
vmovdqa64 [rsp + 640], zmm10
vmovdqa64 [rsp + 704], zmm11
vmovdqa64 [rsp + 768], zmm12
vmovdqa64 [rsp + 832], zmm13
vmovdqa64 [rsp + 896], zmm14
vmovdqa64 [rsp + 960], zmm15
vmovdqa64 [rsp + 1024], zmm16
vmovdqa64 [rsp + 1088], zmm17
vmovdqa64 [rsp + 1152], zmm18
vmovdqa64 [rsp + 1216], zmm19
vmovdqa64 [rsp + 1280], zmm20
vmovdqa64 [rsp + 1344], zmm21
vmovdqa64 [rsp + 1408], zmm22
vmovdqa64 [rsp + 1472], zmm23
vmovdqu64 zmm8, [rsi + 0]
vmovdqu64 zmm9, [rsi + 64]
vmovdqu64 zmm10, [rsi + 128]
vmovdqu64 zmm11, [rsi + 192]
vmovdqu64 zmm12, [rsi + 256]
vmovdqu64 zmm13, [rsi + 320]
vmovdqu64 zmm14, [rsi + 384]
vmovdqu64 zmm15, [rsi + 448]
vmovdqu64 zmm16, [rsi + 512]
vmovdqu64 zmm17, [rsi + 576]
vmovdqu64 zmm18, [rsi + 640]
vmovdqu64 zmm19, [rsi + 704]
vmovdqu64 zmm20, [rsi + 768]
vmovdqu64 zmm21, [rsi + 832]
vmovdqu64 zmm22, [rsi + 896]
vmovdqu64 zmm23, [rsi + 960]
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpermb zmm1, zmm0, [rdi + 384]
vmovdqa64 [rsp + 384], zmm1
vpermb zmm1, zmm0, [rdi + 448]
vmovdqa64 [rsp + 448], zmm1
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
vpbroadcastq zmm0, [rsp + 384]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 392]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 400]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 408]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 416]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 424]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 432]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 440]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 448]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 456]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 464]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 472]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 480]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 488]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 496]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 504]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 192], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 448], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 704], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 960], zmm0
vmovdqa64 zmm8, [rsp + 512]
vmovdqa64 zmm9, [rsp + 576]
vmovdqa64 zmm10, [rsp + 640]
vmovdqa64 zmm11, [rsp + 704]
vmovdqa64 zmm12, [rsp + 768]
vmovdqa64 zmm13, [rsp + 832]
vmovdqa64 zmm14, [rsp + 896]
vmovdqa64 zmm15, [rsp + 960]
vmovdqa64 zmm16, [rsp + 1024]
vmovdqa64 zmm17, [rsp + 1088]
vmovdqa64 zmm18, [rsp + 1152]
vmovdqa64 zmm19, [rsp + 1216]
vmovdqa64 zmm20, [rsp + 1280]
vmovdqa64 zmm21, [rsp + 1344]
vmovdqa64 zmm22, [rsp + 1408]
vmovdqa64 zmm23, [rsp + 1472]
mov rsp, rax
ret
.size flock_r2eight_single_0, .-flock_r2eight_single_0
.p2align 6
.global flock_r2eight_single_3
.hidden flock_r2eight_single_3
.type flock_r2eight_single_3,@function
flock_r2eight_single_3:
mov rax, rsp
and rsp, -64
sub rsp, 1536
vmovdqa64 [rsp + 512], zmm8
vmovdqa64 [rsp + 576], zmm9
vmovdqa64 [rsp + 640], zmm10
vmovdqa64 [rsp + 704], zmm11
vmovdqa64 [rsp + 768], zmm12
vmovdqa64 [rsp + 832], zmm13
vmovdqa64 [rsp + 896], zmm14
vmovdqa64 [rsp + 960], zmm15
vmovdqa64 [rsp + 1024], zmm16
vmovdqa64 [rsp + 1088], zmm17
vmovdqa64 [rsp + 1152], zmm18
vmovdqa64 [rsp + 1216], zmm19
vmovdqa64 [rsp + 1280], zmm20
vmovdqa64 [rsp + 1344], zmm21
vmovdqa64 [rsp + 1408], zmm22
vmovdqa64 [rsp + 1472], zmm23
vmovdqu64 zmm8, [rsi + 0]
vmovdqu64 zmm9, [rsi + 64]
vmovdqu64 zmm10, [rsi + 128]
vmovdqu64 zmm11, [rsi + 192]
vmovdqu64 zmm12, [rsi + 256]
vmovdqu64 zmm13, [rsi + 320]
vmovdqu64 zmm14, [rsi + 384]
vmovdqu64 zmm15, [rsi + 448]
vmovdqu64 zmm16, [rsi + 512]
vmovdqu64 zmm17, [rsi + 576]
vmovdqu64 zmm18, [rsi + 640]
vmovdqu64 zmm19, [rsi + 704]
vmovdqu64 zmm20, [rsi + 768]
vmovdqu64 zmm21, [rsi + 832]
vmovdqu64 zmm22, [rsi + 896]
vmovdqu64 zmm23, [rsi + 960]
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 0]
vmovdqa64 [rsp + 0], zmm1
vpermb zmm1, zmm0, [rdi + 64]
vmovdqa64 [rsp + 64], zmm1
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpbroadcastq zmm0, [rsp + 0]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 8]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 16]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 24]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 32]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 40]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 48]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 56]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 64]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 72]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 80]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 88]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 96]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 104]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 112]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 120]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 0], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 256], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 512], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 768], zmm0
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, zmm9, 0
vgf2p8affineqb zmm0, zmm0, zmm8, 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, zmm11, 0
vgf2p8affineqb zmm2, zmm2, zmm10, 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, zmm13, 0
vgf2p8affineqb zmm4, zmm4, zmm12, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, zmm15, 0
vgf2p8affineqb zmm2, zmm2, zmm14, 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, zmm17, 0
vgf2p8affineqb zmm4, zmm4, zmm16, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, zmm19, 0
vgf2p8affineqb zmm2, zmm2, zmm18, 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, zmm21, 0
vgf2p8affineqb zmm4, zmm4, zmm20, 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, zmm23, 0
vgf2p8affineqb zmm2, zmm2, zmm22, 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
vmovdqa64 zmm8, [rsp + 512]
vmovdqa64 zmm9, [rsp + 576]
vmovdqa64 zmm10, [rsp + 640]
vmovdqa64 zmm11, [rsp + 704]
vmovdqa64 zmm12, [rsp + 768]
vmovdqa64 zmm13, [rsp + 832]
vmovdqa64 zmm14, [rsp + 896]
vmovdqa64 zmm15, [rsp + 960]
vmovdqa64 zmm16, [rsp + 1024]
vmovdqa64 zmm17, [rsp + 1088]
vmovdqa64 zmm18, [rsp + 1152]
vmovdqa64 zmm19, [rsp + 1216]
vmovdqa64 zmm20, [rsp + 1280]
vmovdqa64 zmm21, [rsp + 1344]
vmovdqa64 zmm22, [rsp + 1408]
vmovdqa64 zmm23, [rsp + 1472]
mov rsp, rax
ret
.size flock_r2eight_single_3, .-flock_r2eight_single_3
.p2align 6
.global flock_r2eight_multi_full
.hidden flock_r2eight_multi_full
.type flock_r2eight_multi_full,@function
flock_r2eight_multi_full:
mov rax, rsp
and rsp, -64
sub rsp, 512
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 0]
vmovdqa64 [rsp + 0], zmm1
vpermb zmm1, zmm0, [rdi + 64]
vmovdqa64 [rsp + 64], zmm1
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpermb zmm1, zmm0, [rdi + 384]
vmovdqa64 [rsp + 384], zmm1
vpermb zmm1, zmm0, [rdi + 448]
vmovdqa64 [rsp + 448], zmm1
vpbroadcastq zmm0, [rsp + 0]
vgf2p8affineqb zmm1, zmm0, [rsi + 64], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rsp + 8]
vgf2p8affineqb zmm3, zmm2, [rsi + 192], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
vpbroadcastq zmm4, [rsp + 16]
vgf2p8affineqb zmm5, zmm4, [rsi + 320], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 24]
vgf2p8affineqb zmm3, zmm2, [rsi + 448], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rsp + 32]
vgf2p8affineqb zmm5, zmm4, [rsi + 576], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 40]
vgf2p8affineqb zmm3, zmm2, [rsi + 704], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rsp + 48]
vgf2p8affineqb zmm5, zmm4, [rsi + 832], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 56]
vgf2p8affineqb zmm3, zmm2, [rsi + 960], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 64]
vgf2p8affineqb zmm1, zmm0, [rsi + 64], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rsp + 72]
vgf2p8affineqb zmm3, zmm2, [rsi + 192], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
vpbroadcastq zmm4, [rsp + 80]
vgf2p8affineqb zmm5, zmm4, [rsi + 320], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 88]
vgf2p8affineqb zmm3, zmm2, [rsi + 448], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rsp + 96]
vgf2p8affineqb zmm5, zmm4, [rsi + 576], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 104]
vgf2p8affineqb zmm3, zmm2, [rsi + 704], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rsp + 112]
vgf2p8affineqb zmm5, zmm4, [rsi + 832], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 120]
vgf2p8affineqb zmm3, zmm2, [rsi + 960], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 0], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 256], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 512], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 768], zmm0
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
vpbroadcastq zmm0, [rsp + 384]
vgf2p8affineqb zmm1, zmm0, [rsi + 3136], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 3072], 0
vpbroadcastq zmm2, [rsp + 392]
vgf2p8affineqb zmm3, zmm2, [rsi + 3264], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3200], 0
vpbroadcastq zmm4, [rsp + 400]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3328], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 408]
vgf2p8affineqb zmm3, zmm2, [rsi + 3520], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3456], 0
vpbroadcastq zmm4, [rsp + 416]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3584], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 424]
vgf2p8affineqb zmm3, zmm2, [rsi + 3776], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3712], 0
vpbroadcastq zmm4, [rsp + 432]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3840], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 440]
vgf2p8affineqb zmm3, zmm2, [rsi + 4032], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3968], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 448]
vgf2p8affineqb zmm1, zmm0, [rsi + 3136], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 3072], 0
vpbroadcastq zmm2, [rsp + 456]
vgf2p8affineqb zmm3, zmm2, [rsi + 3264], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3200], 0
vpbroadcastq zmm4, [rsp + 464]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3328], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 472]
vgf2p8affineqb zmm3, zmm2, [rsi + 3520], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3456], 0
vpbroadcastq zmm4, [rsp + 480]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3584], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 488]
vgf2p8affineqb zmm3, zmm2, [rsi + 3776], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3712], 0
vpbroadcastq zmm4, [rsp + 496]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3840], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 504]
vgf2p8affineqb zmm3, zmm2, [rsi + 4032], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3968], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 192], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 448], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 704], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 960], zmm0
mov rsp, rax
ret
.size flock_r2eight_multi_full, .-flock_r2eight_multi_full
.p2align 6
.global flock_r2eight_multi_0
.hidden flock_r2eight_multi_0
.type flock_r2eight_multi_0,@function
flock_r2eight_multi_0:
mov rax, rsp
and rsp, -64
sub rsp, 512
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpermb zmm1, zmm0, [rdi + 384]
vmovdqa64 [rsp + 384], zmm1
vpermb zmm1, zmm0, [rdi + 448]
vmovdqa64 [rsp + 448], zmm1
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
vpbroadcastq zmm0, [rsp + 384]
vgf2p8affineqb zmm1, zmm0, [rsi + 3136], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 3072], 0
vpbroadcastq zmm2, [rsp + 392]
vgf2p8affineqb zmm3, zmm2, [rsi + 3264], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3200], 0
vpbroadcastq zmm4, [rsp + 400]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3328], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 408]
vgf2p8affineqb zmm3, zmm2, [rsi + 3520], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3456], 0
vpbroadcastq zmm4, [rsp + 416]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3584], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 424]
vgf2p8affineqb zmm3, zmm2, [rsi + 3776], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3712], 0
vpbroadcastq zmm4, [rsp + 432]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3840], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 440]
vgf2p8affineqb zmm3, zmm2, [rsi + 4032], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3968], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 448]
vgf2p8affineqb zmm1, zmm0, [rsi + 3136], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 3072], 0
vpbroadcastq zmm2, [rsp + 456]
vgf2p8affineqb zmm3, zmm2, [rsi + 3264], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3200], 0
vpbroadcastq zmm4, [rsp + 464]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3328], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 472]
vgf2p8affineqb zmm3, zmm2, [rsi + 3520], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3456], 0
vpbroadcastq zmm4, [rsp + 480]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3584], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 488]
vgf2p8affineqb zmm3, zmm2, [rsi + 3776], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3712], 0
vpbroadcastq zmm4, [rsp + 496]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 3840], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 504]
vgf2p8affineqb zmm3, zmm2, [rsi + 4032], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 3968], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 192], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 448], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 704], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 960], zmm0
mov rsp, rax
ret
.size flock_r2eight_multi_0, .-flock_r2eight_multi_0
.p2align 6
.global flock_r2eight_multi_3
.hidden flock_r2eight_multi_3
.type flock_r2eight_multi_3,@function
flock_r2eight_multi_3:
mov rax, rsp
and rsp, -64
sub rsp, 512
vmovdqa64 zmm0, [rip + .Lflock_r2eight_bt]
vpermb zmm1, zmm0, [rdi + 0]
vmovdqa64 [rsp + 0], zmm1
vpermb zmm1, zmm0, [rdi + 64]
vmovdqa64 [rsp + 64], zmm1
vpermb zmm1, zmm0, [rdi + 128]
vmovdqa64 [rsp + 128], zmm1
vpermb zmm1, zmm0, [rdi + 192]
vmovdqa64 [rsp + 192], zmm1
vpermb zmm1, zmm0, [rdi + 256]
vmovdqa64 [rsp + 256], zmm1
vpermb zmm1, zmm0, [rdi + 320]
vmovdqa64 [rsp + 320], zmm1
vpbroadcastq zmm0, [rsp + 0]
vgf2p8affineqb zmm1, zmm0, [rsi + 64], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rsp + 8]
vgf2p8affineqb zmm3, zmm2, [rsi + 192], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
vpbroadcastq zmm4, [rsp + 16]
vgf2p8affineqb zmm5, zmm4, [rsi + 320], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 24]
vgf2p8affineqb zmm3, zmm2, [rsi + 448], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rsp + 32]
vgf2p8affineqb zmm5, zmm4, [rsi + 576], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 40]
vgf2p8affineqb zmm3, zmm2, [rsi + 704], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rsp + 48]
vgf2p8affineqb zmm5, zmm4, [rsi + 832], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 56]
vgf2p8affineqb zmm3, zmm2, [rsi + 960], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 64]
vgf2p8affineqb zmm1, zmm0, [rsi + 64], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rsp + 72]
vgf2p8affineqb zmm3, zmm2, [rsi + 192], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
vpbroadcastq zmm4, [rsp + 80]
vgf2p8affineqb zmm5, zmm4, [rsi + 320], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 88]
vgf2p8affineqb zmm3, zmm2, [rsi + 448], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rsp + 96]
vgf2p8affineqb zmm5, zmm4, [rsi + 576], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 104]
vgf2p8affineqb zmm3, zmm2, [rsi + 704], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rsp + 112]
vgf2p8affineqb zmm5, zmm4, [rsi + 832], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 120]
vgf2p8affineqb zmm3, zmm2, [rsi + 960], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 0], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 256], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 512], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 768], zmm0
vpbroadcastq zmm0, [rsp + 128]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 136]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 144]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 152]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 160]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 168]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 176]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 184]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 192]
vgf2p8affineqb zmm1, zmm0, [rsi + 1088], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
vpbroadcastq zmm2, [rsp + 200]
vgf2p8affineqb zmm3, zmm2, [rsi + 1216], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rsp + 208]
vgf2p8affineqb zmm5, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 216]
vgf2p8affineqb zmm3, zmm2, [rsi + 1472], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rsp + 224]
vgf2p8affineqb zmm5, zmm4, [rsi + 1600], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 232]
vgf2p8affineqb zmm3, zmm2, [rsi + 1728], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rsp + 240]
vgf2p8affineqb zmm5, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 248]
vgf2p8affineqb zmm3, zmm2, [rsi + 1984], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 64], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 320], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 576], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 832], zmm0
vpbroadcastq zmm0, [rsp + 256]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 264]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 272]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 280]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 288]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 296]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 304]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 312]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vmovdqa64 zmm6, zmm2
vmovdqa64 zmm7, zmm3
vpbroadcastq zmm0, [rsp + 320]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 2048], 0
vpbroadcastq zmm2, [rsp + 328]
vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
vpbroadcastq zmm4, [rsp + 336]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2304], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 344]
vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
vpbroadcastq zmm4, [rsp + 352]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2560], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 360]
vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
vpbroadcastq zmm4, [rsp + 368]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 2816], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rsp + 376]
vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, [rip + .Lflock_r2eight_out01]
vmovdqa64 zmm3, [rip + .Lflock_r2eight_out23]
vpermi2b zmm2, zmm0, zmm1
vpermi2b zmm3, zmm0, zmm1
vinserti64x4 zmm0, zmm6, ymm2, 1
vmovdqu64 [rdx + 128], zmm0
vshufi64x2 zmm0, zmm6, zmm2, 0xee
vmovdqu64 [rdx + 384], zmm0
vinserti64x4 zmm0, zmm7, ymm3, 1
vmovdqu64 [rdx + 640], zmm0
vshufi64x2 zmm0, zmm7, zmm3, 0xee
vmovdqu64 [rdx + 896], zmm0
mov rsp, rax
ret
.size flock_r2eight_multi_3, .-flock_r2eight_multi_3
.section .rodata
.p2align 6
.Lflock_r2eight_bt:
.byte 0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57,2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59,4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61,6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63
.p2align 6
.Lflock_r2eight_out01:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125
.p2align 6
.Lflock_r2eight_out23:
.byte 2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
