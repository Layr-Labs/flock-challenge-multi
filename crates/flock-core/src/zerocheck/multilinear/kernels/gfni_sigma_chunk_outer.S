// Chunk-outer B maps: keep output planes resident and load each matrix once.
// 6 input octets; RDI rows, RSI immutable matrices, RDX output.
// Clobbers RAX, flags and ZMM0..20; preserves other registers.
// Captures all live input before output; restores RSP exactly.
.text
.p2align 6
.global flock_sigma_chunk_outer6
.hidden flock_sigma_chunk_outer6
.type flock_sigma_chunk_outer6,@function
flock_sigma_chunk_outer6:
mov rax, rsp
and rsp, -64
sub rsp, 384
vmovdqa64 zmm20, [rip + .Lflock_co6_bt]
vpermb zmm19, zmm20, [rdi + 0]
vmovdqa64 [rsp + 0], zmm19
vpermb zmm19, zmm20, [rdi + 64]
vmovdqa64 [rsp + 64], zmm19
vpermb zmm19, zmm20, [rdi + 128]
vmovdqa64 [rsp + 128], zmm19
vpermb zmm19, zmm20, [rdi + 192]
vmovdqa64 [rsp + 192], zmm19
vpermb zmm19, zmm20, [rdi + 256]
vmovdqa64 [rsp + 256], zmm19
vpermb zmm19, zmm20, [rdi + 320]
vmovdqa64 [rsp + 320], zmm19
vmovdqu64 zmm12, [rsi + 0]
vmovdqu64 zmm13, [rsi + 64]
vpbroadcastq zmm16, [rsp + 0]
vgf2p8affineqb zmm0, zmm16, zmm12, 0
vgf2p8affineqb zmm1, zmm16, zmm13, 0
vpbroadcastq zmm16, [rsp + 64]
vgf2p8affineqb zmm2, zmm16, zmm12, 0
vgf2p8affineqb zmm3, zmm16, zmm13, 0
vpbroadcastq zmm16, [rsp + 128]
vgf2p8affineqb zmm4, zmm16, zmm12, 0
vgf2p8affineqb zmm5, zmm16, zmm13, 0
vpbroadcastq zmm16, [rsp + 192]
vgf2p8affineqb zmm6, zmm16, zmm12, 0
vgf2p8affineqb zmm7, zmm16, zmm13, 0
vpbroadcastq zmm16, [rsp + 256]
vgf2p8affineqb zmm8, zmm16, zmm12, 0
vgf2p8affineqb zmm9, zmm16, zmm13, 0
vpbroadcastq zmm16, [rsp + 320]
vgf2p8affineqb zmm10, zmm16, zmm12, 0
vgf2p8affineqb zmm11, zmm16, zmm13, 0
vmovdqu64 zmm12, [rsi + 128]
vmovdqu64 zmm13, [rsi + 192]
vmovdqu64 zmm14, [rsi + 256]
vmovdqu64 zmm15, [rsi + 320]
vpbroadcastq zmm16, [rsp + 8]
vpbroadcastq zmm17, [rsp + 16]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 72]
vpbroadcastq zmm17, [rsp + 80]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 136]
vpbroadcastq zmm17, [rsp + 144]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 200]
vpbroadcastq zmm17, [rsp + 208]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 264]
vpbroadcastq zmm17, [rsp + 272]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 328]
vpbroadcastq zmm17, [rsp + 336]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vmovdqu64 zmm12, [rsi + 384]
vmovdqu64 zmm13, [rsi + 448]
vmovdqu64 zmm14, [rsi + 512]
vmovdqu64 zmm15, [rsi + 576]
vpbroadcastq zmm16, [rsp + 24]
vpbroadcastq zmm17, [rsp + 32]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 88]
vpbroadcastq zmm17, [rsp + 96]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 152]
vpbroadcastq zmm17, [rsp + 160]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 216]
vpbroadcastq zmm17, [rsp + 224]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 280]
vpbroadcastq zmm17, [rsp + 288]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 344]
vpbroadcastq zmm17, [rsp + 352]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vmovdqu64 zmm12, [rsi + 640]
vmovdqu64 zmm13, [rsi + 704]
vmovdqu64 zmm14, [rsi + 768]
vmovdqu64 zmm15, [rsi + 832]
vpbroadcastq zmm16, [rsp + 40]
vpbroadcastq zmm17, [rsp + 48]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 104]
vpbroadcastq zmm17, [rsp + 112]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 168]
vpbroadcastq zmm17, [rsp + 176]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 232]
vpbroadcastq zmm17, [rsp + 240]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 296]
vpbroadcastq zmm17, [rsp + 304]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vpbroadcastq zmm16, [rsp + 360]
vpbroadcastq zmm17, [rsp + 368]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vgf2p8affineqb zmm19, zmm17, zmm14, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vgf2p8affineqb zmm19, zmm17, zmm15, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vmovdqu64 zmm12, [rsi + 896]
vmovdqu64 zmm13, [rsi + 960]
vpbroadcastq zmm16, [rsp + 56]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm0, zmm0, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm1, zmm1, zmm18
vpbroadcastq zmm16, [rsp + 120]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm2, zmm2, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm3, zmm3, zmm18
vpbroadcastq zmm16, [rsp + 184]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm4, zmm4, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm5, zmm5, zmm18
vpbroadcastq zmm16, [rsp + 248]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm6, zmm6, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm7, zmm7, zmm18
vpbroadcastq zmm16, [rsp + 312]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm8, zmm8, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm9, zmm9, zmm18
vpbroadcastq zmm16, [rsp + 376]
vgf2p8affineqb zmm18, zmm16, zmm12, 0
vpxorq zmm10, zmm10, zmm18
vgf2p8affineqb zmm18, zmm16, zmm13, 0
vpxorq zmm11, zmm11, zmm18
vmovdqa64 zmm12, [rip + .Lflock_co6_p01]
vmovdqa64 zmm13, [rip + .Lflock_co6_p23]
vpermb zmm0, zmm20, zmm0
vpermb zmm1, zmm20, zmm1
vpermb zmm2, zmm20, zmm2
vpermb zmm3, zmm20, zmm3
vmovdqa64 zmm14, zmm12
vmovdqa64 zmm15, zmm13
vmovdqa64 zmm16, zmm12
vmovdqa64 zmm17, zmm13
vpermi2q zmm14, zmm0, zmm1
vpermi2q zmm15, zmm0, zmm1
vpermi2q zmm16, zmm2, zmm3
vpermi2q zmm17, zmm2, zmm3
vinserti64x4 zmm18, zmm14, ymm16, 1
vmovdqu64 [rdx + 0], zmm18
vshufi64x2 zmm19, zmm14, zmm16, 0xee
vmovdqu64 [rdx + 256], zmm19
vinserti64x4 zmm18, zmm15, ymm17, 1
vmovdqu64 [rdx + 512], zmm18
vshufi64x2 zmm19, zmm15, zmm17, 0xee
vmovdqu64 [rdx + 768], zmm19
vpermb zmm4, zmm20, zmm4
vpermb zmm5, zmm20, zmm5
vpermb zmm6, zmm20, zmm6
vpermb zmm7, zmm20, zmm7
vmovdqa64 zmm14, zmm12
vmovdqa64 zmm15, zmm13
vmovdqa64 zmm16, zmm12
vmovdqa64 zmm17, zmm13
vpermi2q zmm14, zmm4, zmm5
vpermi2q zmm15, zmm4, zmm5
vpermi2q zmm16, zmm6, zmm7
vpermi2q zmm17, zmm6, zmm7
vinserti64x4 zmm18, zmm14, ymm16, 1
vmovdqu64 [rdx + 64], zmm18
vshufi64x2 zmm19, zmm14, zmm16, 0xee
vmovdqu64 [rdx + 320], zmm19
vinserti64x4 zmm18, zmm15, ymm17, 1
vmovdqu64 [rdx + 576], zmm18
vshufi64x2 zmm19, zmm15, zmm17, 0xee
vmovdqu64 [rdx + 832], zmm19
vpermb zmm8, zmm20, zmm8
vpermb zmm9, zmm20, zmm9
vpermb zmm10, zmm20, zmm10
vpermb zmm11, zmm20, zmm11
vmovdqa64 zmm14, zmm12
vmovdqa64 zmm15, zmm13
vmovdqa64 zmm16, zmm12
vmovdqa64 zmm17, zmm13
vpermi2q zmm14, zmm8, zmm9
vpermi2q zmm15, zmm8, zmm9
vpermi2q zmm16, zmm10, zmm11
vpermi2q zmm17, zmm10, zmm11
vinserti64x4 zmm18, zmm14, ymm16, 1
vmovdqu64 [rdx + 128], zmm18
vshufi64x2 zmm19, zmm14, zmm16, 0xee
vmovdqu64 [rdx + 384], zmm19
vinserti64x4 zmm18, zmm15, ymm17, 1
vmovdqu64 [rdx + 640], zmm18
vshufi64x2 zmm19, zmm15, zmm17, 0xee
vmovdqu64 [rdx + 896], zmm19
mov rsp, rax
ret
.size flock_sigma_chunk_outer6,.-flock_sigma_chunk_outer6
.section .rodata
.p2align 6
.Lflock_co6_bt:
.byte 0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57,2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59,4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61,6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63
.p2align 6
.Lflock_co6_p01:
.quad 0,8,4,12,1,9,5,13
.p2align 6
.Lflock_co6_p23:
.quad 2,10,6,14,3,11,7,15
// 8 input octets; RDI rows, RSI immutable matrices, RDX output.
// Clobbers RAX, flags and ZMM0..24; preserves other registers.
// Captures all live input before output; restores RSP exactly.
.text
.p2align 6
.global flock_sigma_chunk_outer8
.hidden flock_sigma_chunk_outer8
.type flock_sigma_chunk_outer8,@function
flock_sigma_chunk_outer8:
mov rax, rsp
and rsp, -64
sub rsp, 512
vmovdqa64 zmm24, [rip + .Lflock_co8_bt]
vpermb zmm23, zmm24, [rdi + 0]
vmovdqa64 [rsp + 0], zmm23
vpermb zmm23, zmm24, [rdi + 64]
vmovdqa64 [rsp + 64], zmm23
vpermb zmm23, zmm24, [rdi + 128]
vmovdqa64 [rsp + 128], zmm23
vpermb zmm23, zmm24, [rdi + 192]
vmovdqa64 [rsp + 192], zmm23
vpermb zmm23, zmm24, [rdi + 256]
vmovdqa64 [rsp + 256], zmm23
vpermb zmm23, zmm24, [rdi + 320]
vmovdqa64 [rsp + 320], zmm23
vpermb zmm23, zmm24, [rdi + 384]
vmovdqa64 [rsp + 384], zmm23
vpermb zmm23, zmm24, [rdi + 448]
vmovdqa64 [rsp + 448], zmm23
vmovdqu64 zmm16, [rsi + 0]
vmovdqu64 zmm17, [rsi + 64]
vpbroadcastq zmm20, [rsp + 0]
vgf2p8affineqb zmm0, zmm20, zmm16, 0
vgf2p8affineqb zmm1, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 64]
vgf2p8affineqb zmm2, zmm20, zmm16, 0
vgf2p8affineqb zmm3, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 128]
vgf2p8affineqb zmm4, zmm20, zmm16, 0
vgf2p8affineqb zmm5, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 192]
vgf2p8affineqb zmm6, zmm20, zmm16, 0
vgf2p8affineqb zmm7, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 256]
vgf2p8affineqb zmm8, zmm20, zmm16, 0
vgf2p8affineqb zmm9, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 320]
vgf2p8affineqb zmm10, zmm20, zmm16, 0
vgf2p8affineqb zmm11, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 384]
vgf2p8affineqb zmm12, zmm20, zmm16, 0
vgf2p8affineqb zmm13, zmm20, zmm17, 0
vpbroadcastq zmm20, [rsp + 448]
vgf2p8affineqb zmm14, zmm20, zmm16, 0
vgf2p8affineqb zmm15, zmm20, zmm17, 0
vmovdqu64 zmm16, [rsi + 128]
vmovdqu64 zmm17, [rsi + 192]
vmovdqu64 zmm18, [rsi + 256]
vmovdqu64 zmm19, [rsi + 320]
vpbroadcastq zmm20, [rsp + 8]
vpbroadcastq zmm21, [rsp + 16]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm0, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm1, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 72]
vpbroadcastq zmm21, [rsp + 80]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm2, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm3, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 136]
vpbroadcastq zmm21, [rsp + 144]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm4, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm5, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 200]
vpbroadcastq zmm21, [rsp + 208]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm6, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm7, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 264]
vpbroadcastq zmm21, [rsp + 272]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm8, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm9, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 328]
vpbroadcastq zmm21, [rsp + 336]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm10, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm11, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 392]
vpbroadcastq zmm21, [rsp + 400]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm12, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm13, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 456]
vpbroadcastq zmm21, [rsp + 464]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm14, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm15, zmm22, zmm23, 0x96
vmovdqu64 zmm16, [rsi + 384]
vmovdqu64 zmm17, [rsi + 448]
vmovdqu64 zmm18, [rsi + 512]
vmovdqu64 zmm19, [rsi + 576]
vpbroadcastq zmm20, [rsp + 24]
vpbroadcastq zmm21, [rsp + 32]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm0, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm1, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 88]
vpbroadcastq zmm21, [rsp + 96]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm2, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm3, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 152]
vpbroadcastq zmm21, [rsp + 160]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm4, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm5, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 216]
vpbroadcastq zmm21, [rsp + 224]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm6, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm7, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 280]
vpbroadcastq zmm21, [rsp + 288]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm8, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm9, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 344]
vpbroadcastq zmm21, [rsp + 352]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm10, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm11, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 408]
vpbroadcastq zmm21, [rsp + 416]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm12, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm13, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 472]
vpbroadcastq zmm21, [rsp + 480]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm14, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm15, zmm22, zmm23, 0x96
vmovdqu64 zmm16, [rsi + 640]
vmovdqu64 zmm17, [rsi + 704]
vmovdqu64 zmm18, [rsi + 768]
vmovdqu64 zmm19, [rsi + 832]
vpbroadcastq zmm20, [rsp + 40]
vpbroadcastq zmm21, [rsp + 48]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm0, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm1, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 104]
vpbroadcastq zmm21, [rsp + 112]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm2, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm3, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 168]
vpbroadcastq zmm21, [rsp + 176]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm4, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm5, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 232]
vpbroadcastq zmm21, [rsp + 240]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm6, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm7, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 296]
vpbroadcastq zmm21, [rsp + 304]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm8, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm9, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 360]
vpbroadcastq zmm21, [rsp + 368]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm10, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm11, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 424]
vpbroadcastq zmm21, [rsp + 432]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm12, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm13, zmm22, zmm23, 0x96
vpbroadcastq zmm20, [rsp + 488]
vpbroadcastq zmm21, [rsp + 496]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vgf2p8affineqb zmm23, zmm21, zmm18, 0
vpternlogq zmm14, zmm22, zmm23, 0x96
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vgf2p8affineqb zmm23, zmm21, zmm19, 0
vpternlogq zmm15, zmm22, zmm23, 0x96
vmovdqu64 zmm16, [rsi + 896]
vmovdqu64 zmm17, [rsi + 960]
vpbroadcastq zmm20, [rsp + 56]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm0, zmm0, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm1, zmm1, zmm22
vpbroadcastq zmm20, [rsp + 120]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm2, zmm2, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm3, zmm3, zmm22
vpbroadcastq zmm20, [rsp + 184]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm4, zmm4, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm5, zmm5, zmm22
vpbroadcastq zmm20, [rsp + 248]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm6, zmm6, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm7, zmm7, zmm22
vpbroadcastq zmm20, [rsp + 312]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm8, zmm8, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm9, zmm9, zmm22
vpbroadcastq zmm20, [rsp + 376]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm10, zmm10, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm11, zmm11, zmm22
vpbroadcastq zmm20, [rsp + 440]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm12, zmm12, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm13, zmm13, zmm22
vpbroadcastq zmm20, [rsp + 504]
vgf2p8affineqb zmm22, zmm20, zmm16, 0
vpxorq zmm14, zmm14, zmm22
vgf2p8affineqb zmm22, zmm20, zmm17, 0
vpxorq zmm15, zmm15, zmm22
vmovdqa64 zmm16, [rip + .Lflock_co8_p01]
vmovdqa64 zmm17, [rip + .Lflock_co8_p23]
vpermb zmm0, zmm24, zmm0
vpermb zmm1, zmm24, zmm1
vpermb zmm2, zmm24, zmm2
vpermb zmm3, zmm24, zmm3
vmovdqa64 zmm18, zmm16
vmovdqa64 zmm19, zmm17
vmovdqa64 zmm20, zmm16
vmovdqa64 zmm21, zmm17
vpermi2q zmm18, zmm0, zmm1
vpermi2q zmm19, zmm0, zmm1
vpermi2q zmm20, zmm2, zmm3
vpermi2q zmm21, zmm2, zmm3
vinserti64x4 zmm22, zmm18, ymm20, 1
vmovdqu64 [rdx + 0], zmm22
vshufi64x2 zmm23, zmm18, zmm20, 0xee
vmovdqu64 [rdx + 256], zmm23
vinserti64x4 zmm22, zmm19, ymm21, 1
vmovdqu64 [rdx + 512], zmm22
vshufi64x2 zmm23, zmm19, zmm21, 0xee
vmovdqu64 [rdx + 768], zmm23
vpermb zmm4, zmm24, zmm4
vpermb zmm5, zmm24, zmm5
vpermb zmm6, zmm24, zmm6
vpermb zmm7, zmm24, zmm7
vmovdqa64 zmm18, zmm16
vmovdqa64 zmm19, zmm17
vmovdqa64 zmm20, zmm16
vmovdqa64 zmm21, zmm17
vpermi2q zmm18, zmm4, zmm5
vpermi2q zmm19, zmm4, zmm5
vpermi2q zmm20, zmm6, zmm7
vpermi2q zmm21, zmm6, zmm7
vinserti64x4 zmm22, zmm18, ymm20, 1
vmovdqu64 [rdx + 64], zmm22
vshufi64x2 zmm23, zmm18, zmm20, 0xee
vmovdqu64 [rdx + 320], zmm23
vinserti64x4 zmm22, zmm19, ymm21, 1
vmovdqu64 [rdx + 576], zmm22
vshufi64x2 zmm23, zmm19, zmm21, 0xee
vmovdqu64 [rdx + 832], zmm23
vpermb zmm8, zmm24, zmm8
vpermb zmm9, zmm24, zmm9
vpermb zmm10, zmm24, zmm10
vpermb zmm11, zmm24, zmm11
vmovdqa64 zmm18, zmm16
vmovdqa64 zmm19, zmm17
vmovdqa64 zmm20, zmm16
vmovdqa64 zmm21, zmm17
vpermi2q zmm18, zmm8, zmm9
vpermi2q zmm19, zmm8, zmm9
vpermi2q zmm20, zmm10, zmm11
vpermi2q zmm21, zmm10, zmm11
vinserti64x4 zmm22, zmm18, ymm20, 1
vmovdqu64 [rdx + 128], zmm22
vshufi64x2 zmm23, zmm18, zmm20, 0xee
vmovdqu64 [rdx + 384], zmm23
vinserti64x4 zmm22, zmm19, ymm21, 1
vmovdqu64 [rdx + 640], zmm22
vshufi64x2 zmm23, zmm19, zmm21, 0xee
vmovdqu64 [rdx + 896], zmm23
vpermb zmm12, zmm24, zmm12
vpermb zmm13, zmm24, zmm13
vpermb zmm14, zmm24, zmm14
vpermb zmm15, zmm24, zmm15
vmovdqa64 zmm18, zmm16
vmovdqa64 zmm19, zmm17
vmovdqa64 zmm20, zmm16
vmovdqa64 zmm21, zmm17
vpermi2q zmm18, zmm12, zmm13
vpermi2q zmm19, zmm12, zmm13
vpermi2q zmm20, zmm14, zmm15
vpermi2q zmm21, zmm14, zmm15
vinserti64x4 zmm22, zmm18, ymm20, 1
vmovdqu64 [rdx + 192], zmm22
vshufi64x2 zmm23, zmm18, zmm20, 0xee
vmovdqu64 [rdx + 448], zmm23
vinserti64x4 zmm22, zmm19, ymm21, 1
vmovdqu64 [rdx + 704], zmm22
vshufi64x2 zmm23, zmm19, zmm21, 0xee
vmovdqu64 [rdx + 960], zmm23
mov rsp, rax
ret
.size flock_sigma_chunk_outer8,.-flock_sigma_chunk_outer8
.section .rodata
.p2align 6
.Lflock_co8_bt:
.byte 0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57,2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59,4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61,6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63
.p2align 6
.Lflock_co8_p01:
.quad 0,8,4,12,1,9,5,13
.p2align 6
.Lflock_co8_p23:
.quad 2,10,6,14,3,11,7,15
.section .note.GNU-stack,"",@progbits
