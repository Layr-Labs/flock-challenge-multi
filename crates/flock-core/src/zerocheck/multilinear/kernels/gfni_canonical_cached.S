// Three live groups; six input lines are captured before output publication.
// Single-map: ZMM0..26 clobbered. Multi-map: ZMM0..15 clobbered.
// All GPRs preserved; 384 bytes of aligned local transpose scratch.
.text
.p2align 6
.global flock_canonical_cached1
.type flock_canonical_cached1,@function
flock_canonical_cached1:
push rbp
mov rbp, rsp
and rsp, -64
sub rsp, 384
vmovdqa64 zmm9, [rip + .Lflock_canonical_bt]
vpermb zmm8, zmm9, [rdi + 0]
vmovdqa64 [rsp + 0], zmm8
vpermb zmm8, zmm9, [rdi + 64]
vmovdqa64 [rsp + 64], zmm8
vpermb zmm8, zmm9, [rdi + 128]
vmovdqa64 [rsp + 128], zmm8
vpermb zmm8, zmm9, [rdi + 192]
vmovdqa64 [rsp + 192], zmm8
vpermb zmm8, zmm9, [rdi + 256]
vmovdqa64 [rsp + 256], zmm8
vpermb zmm8, zmm9, [rdi + 320]
vmovdqa64 [rsp + 320], zmm8
vmovdqu64 zmm0, [rsi + 0]
vmovdqu64 zmm1, [rsi + 64]
vmovdqu64 zmm2, [rsi + 128]
vmovdqu64 zmm3, [rsi + 192]
vmovdqu64 zmm4, [rsi + 256]
vmovdqu64 zmm5, [rsi + 320]
vmovdqu64 zmm6, [rsi + 384]
vmovdqu64 zmm7, [rsi + 448]
vmovdqu64 zmm8, [rsi + 512]
vmovdqu64 zmm9, [rsi + 576]
vmovdqu64 zmm10, [rsi + 640]
vmovdqu64 zmm11, [rsi + 704]
vmovdqu64 zmm12, [rsi + 768]
vmovdqu64 zmm13, [rsi + 832]
vmovdqu64 zmm14, [rsi + 896]
vmovdqu64 zmm15, [rsi + 960]
vpbroadcastq zmm16, [rsp + 0]
vpbroadcastq zmm17, [rsp + 64]
vgf2p8affineqb zmm18, zmm16, zmm0, 0
vgf2p8affineqb zmm19, zmm17, zmm0, 0
vgf2p8affineqb zmm20, zmm16, zmm1, 0
vgf2p8affineqb zmm21, zmm17, zmm1, 0
vpbroadcastq zmm16, [rsp + 8]
vpbroadcastq zmm17, [rsp + 72]
vgf2p8affineqb zmm22, zmm16, zmm2, 0
vgf2p8affineqb zmm23, zmm17, zmm2, 0
vgf2p8affineqb zmm24, zmm16, zmm3, 0
vgf2p8affineqb zmm25, zmm17, zmm3, 0
vpxorq zmm18, zmm18, zmm22
vpxorq zmm19, zmm19, zmm23
vpxorq zmm20, zmm20, zmm24
vpxorq zmm21, zmm21, zmm25
vpbroadcastq zmm16, [rsp + 16]
vpbroadcastq zmm17, [rsp + 80]
vgf2p8affineqb zmm22, zmm16, zmm4, 0
vgf2p8affineqb zmm23, zmm17, zmm4, 0
vgf2p8affineqb zmm24, zmm16, zmm5, 0
vgf2p8affineqb zmm25, zmm17, zmm5, 0
vpbroadcastq zmm16, [rsp + 24]
vpbroadcastq zmm17, [rsp + 88]
vgf2p8affineqb zmm26, zmm16, zmm6, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm6, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm7, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm7, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 32]
vpbroadcastq zmm17, [rsp + 96]
vgf2p8affineqb zmm22, zmm16, zmm8, 0
vgf2p8affineqb zmm23, zmm17, zmm8, 0
vgf2p8affineqb zmm24, zmm16, zmm9, 0
vgf2p8affineqb zmm25, zmm17, zmm9, 0
vpbroadcastq zmm16, [rsp + 40]
vpbroadcastq zmm17, [rsp + 104]
vgf2p8affineqb zmm26, zmm16, zmm10, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm10, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm11, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm11, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 48]
vpbroadcastq zmm17, [rsp + 112]
vgf2p8affineqb zmm22, zmm16, zmm12, 0
vgf2p8affineqb zmm23, zmm17, zmm12, 0
vgf2p8affineqb zmm24, zmm16, zmm13, 0
vgf2p8affineqb zmm25, zmm17, zmm13, 0
vpbroadcastq zmm16, [rsp + 56]
vpbroadcastq zmm17, [rsp + 120]
vgf2p8affineqb zmm26, zmm16, zmm14, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm14, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm15, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm15, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vmovdqa64 zmm16, [rip + .Lflock_canonical_bt]
vpermb zmm18, zmm16, zmm18
vpermb zmm19, zmm16, zmm19
vpermb zmm20, zmm16, zmm20
vpermb zmm21, zmm16, zmm21
vmovdqa64 zmm16, [rip + .Lflock_canonical_p01]
vmovdqa64 zmm17, [rip + .Lflock_canonical_p23]
vmovdqa64 zmm22, zmm16
vmovdqa64 zmm23, zmm17
vpermi2q zmm22, zmm18, zmm20
vpermi2q zmm23, zmm18, zmm20
vpermi2q zmm16, zmm19, zmm21
vpermi2q zmm17, zmm19, zmm21
vinserti64x4 zmm18, zmm22, ymm16, 1
vshufi64x2 zmm19, zmm22, zmm16, 0xee
vinserti64x4 zmm20, zmm23, ymm17, 1
vshufi64x2 zmm21, zmm23, zmm17, 0xee
vmovdqu64 [rdx + 0], zmm18
vmovdqu64 [rdx + 256], zmm19
vmovdqu64 [rdx + 512], zmm20
vmovdqu64 [rdx + 768], zmm21
vpbroadcastq zmm16, [rsp + 128]
vpbroadcastq zmm17, [rsp + 192]
vgf2p8affineqb zmm18, zmm16, zmm0, 0
vgf2p8affineqb zmm19, zmm17, zmm0, 0
vgf2p8affineqb zmm20, zmm16, zmm1, 0
vgf2p8affineqb zmm21, zmm17, zmm1, 0
vpbroadcastq zmm16, [rsp + 136]
vpbroadcastq zmm17, [rsp + 200]
vgf2p8affineqb zmm22, zmm16, zmm2, 0
vgf2p8affineqb zmm23, zmm17, zmm2, 0
vgf2p8affineqb zmm24, zmm16, zmm3, 0
vgf2p8affineqb zmm25, zmm17, zmm3, 0
vpxorq zmm18, zmm18, zmm22
vpxorq zmm19, zmm19, zmm23
vpxorq zmm20, zmm20, zmm24
vpxorq zmm21, zmm21, zmm25
vpbroadcastq zmm16, [rsp + 144]
vpbroadcastq zmm17, [rsp + 208]
vgf2p8affineqb zmm22, zmm16, zmm4, 0
vgf2p8affineqb zmm23, zmm17, zmm4, 0
vgf2p8affineqb zmm24, zmm16, zmm5, 0
vgf2p8affineqb zmm25, zmm17, zmm5, 0
vpbroadcastq zmm16, [rsp + 152]
vpbroadcastq zmm17, [rsp + 216]
vgf2p8affineqb zmm26, zmm16, zmm6, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm6, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm7, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm7, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 160]
vpbroadcastq zmm17, [rsp + 224]
vgf2p8affineqb zmm22, zmm16, zmm8, 0
vgf2p8affineqb zmm23, zmm17, zmm8, 0
vgf2p8affineqb zmm24, zmm16, zmm9, 0
vgf2p8affineqb zmm25, zmm17, zmm9, 0
vpbroadcastq zmm16, [rsp + 168]
vpbroadcastq zmm17, [rsp + 232]
vgf2p8affineqb zmm26, zmm16, zmm10, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm10, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm11, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm11, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 176]
vpbroadcastq zmm17, [rsp + 240]
vgf2p8affineqb zmm22, zmm16, zmm12, 0
vgf2p8affineqb zmm23, zmm17, zmm12, 0
vgf2p8affineqb zmm24, zmm16, zmm13, 0
vgf2p8affineqb zmm25, zmm17, zmm13, 0
vpbroadcastq zmm16, [rsp + 184]
vpbroadcastq zmm17, [rsp + 248]
vgf2p8affineqb zmm26, zmm16, zmm14, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm14, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm15, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm15, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vmovdqa64 zmm16, [rip + .Lflock_canonical_bt]
vpermb zmm18, zmm16, zmm18
vpermb zmm19, zmm16, zmm19
vpermb zmm20, zmm16, zmm20
vpermb zmm21, zmm16, zmm21
vmovdqa64 zmm16, [rip + .Lflock_canonical_p01]
vmovdqa64 zmm17, [rip + .Lflock_canonical_p23]
vmovdqa64 zmm22, zmm16
vmovdqa64 zmm23, zmm17
vpermi2q zmm22, zmm18, zmm20
vpermi2q zmm23, zmm18, zmm20
vpermi2q zmm16, zmm19, zmm21
vpermi2q zmm17, zmm19, zmm21
vinserti64x4 zmm18, zmm22, ymm16, 1
vshufi64x2 zmm19, zmm22, zmm16, 0xee
vinserti64x4 zmm20, zmm23, ymm17, 1
vshufi64x2 zmm21, zmm23, zmm17, 0xee
vmovdqu64 [rdx + 64], zmm18
vmovdqu64 [rdx + 320], zmm19
vmovdqu64 [rdx + 576], zmm20
vmovdqu64 [rdx + 832], zmm21
vpbroadcastq zmm16, [rsp + 256]
vpbroadcastq zmm17, [rsp + 320]
vgf2p8affineqb zmm18, zmm16, zmm0, 0
vgf2p8affineqb zmm19, zmm17, zmm0, 0
vgf2p8affineqb zmm20, zmm16, zmm1, 0
vgf2p8affineqb zmm21, zmm17, zmm1, 0
vpbroadcastq zmm16, [rsp + 264]
vpbroadcastq zmm17, [rsp + 328]
vgf2p8affineqb zmm22, zmm16, zmm2, 0
vgf2p8affineqb zmm23, zmm17, zmm2, 0
vgf2p8affineqb zmm24, zmm16, zmm3, 0
vgf2p8affineqb zmm25, zmm17, zmm3, 0
vpxorq zmm18, zmm18, zmm22
vpxorq zmm19, zmm19, zmm23
vpxorq zmm20, zmm20, zmm24
vpxorq zmm21, zmm21, zmm25
vpbroadcastq zmm16, [rsp + 272]
vpbroadcastq zmm17, [rsp + 336]
vgf2p8affineqb zmm22, zmm16, zmm4, 0
vgf2p8affineqb zmm23, zmm17, zmm4, 0
vgf2p8affineqb zmm24, zmm16, zmm5, 0
vgf2p8affineqb zmm25, zmm17, zmm5, 0
vpbroadcastq zmm16, [rsp + 280]
vpbroadcastq zmm17, [rsp + 344]
vgf2p8affineqb zmm26, zmm16, zmm6, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm6, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm7, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm7, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 288]
vpbroadcastq zmm17, [rsp + 352]
vgf2p8affineqb zmm22, zmm16, zmm8, 0
vgf2p8affineqb zmm23, zmm17, zmm8, 0
vgf2p8affineqb zmm24, zmm16, zmm9, 0
vgf2p8affineqb zmm25, zmm17, zmm9, 0
vpbroadcastq zmm16, [rsp + 296]
vpbroadcastq zmm17, [rsp + 360]
vgf2p8affineqb zmm26, zmm16, zmm10, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm10, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm11, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm11, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vpbroadcastq zmm16, [rsp + 304]
vpbroadcastq zmm17, [rsp + 368]
vgf2p8affineqb zmm22, zmm16, zmm12, 0
vgf2p8affineqb zmm23, zmm17, zmm12, 0
vgf2p8affineqb zmm24, zmm16, zmm13, 0
vgf2p8affineqb zmm25, zmm17, zmm13, 0
vpbroadcastq zmm16, [rsp + 312]
vpbroadcastq zmm17, [rsp + 376]
vgf2p8affineqb zmm26, zmm16, zmm14, 0
vpternlogq zmm18, zmm22, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm14, 0
vpternlogq zmm19, zmm23, zmm26, 0x96
vgf2p8affineqb zmm26, zmm16, zmm15, 0
vpternlogq zmm20, zmm24, zmm26, 0x96
vgf2p8affineqb zmm26, zmm17, zmm15, 0
vpternlogq zmm21, zmm25, zmm26, 0x96
vmovdqa64 zmm16, [rip + .Lflock_canonical_bt]
vpermb zmm18, zmm16, zmm18
vpermb zmm19, zmm16, zmm19
vpermb zmm20, zmm16, zmm20
vpermb zmm21, zmm16, zmm21
vmovdqa64 zmm16, [rip + .Lflock_canonical_p01]
vmovdqa64 zmm17, [rip + .Lflock_canonical_p23]
vmovdqa64 zmm22, zmm16
vmovdqa64 zmm23, zmm17
vpermi2q zmm22, zmm18, zmm20
vpermi2q zmm23, zmm18, zmm20
vpermi2q zmm16, zmm19, zmm21
vpermi2q zmm17, zmm19, zmm21
vinserti64x4 zmm18, zmm22, ymm16, 1
vshufi64x2 zmm19, zmm22, zmm16, 0xee
vinserti64x4 zmm20, zmm23, ymm17, 1
vshufi64x2 zmm21, zmm23, zmm17, 0xee
vmovdqu64 [rdx + 128], zmm18
vmovdqu64 [rdx + 384], zmm19
vmovdqu64 [rdx + 640], zmm20
vmovdqu64 [rdx + 896], zmm21
mov rsp, rbp
pop rbp
ret
.size flock_canonical_cached1, .-flock_canonical_cached1
.p2align 6
.global flock_canonical_cached4
.type flock_canonical_cached4,@function
flock_canonical_cached4:
push rbp
mov rbp, rsp
and rsp, -64
sub rsp, 384
vmovdqa64 zmm13, [rip + .Lflock_canonical_bt]
vpermb zmm8, zmm13, [rdi + 0]
vmovdqa64 [rsp + 0], zmm8
vpermb zmm8, zmm13, [rdi + 64]
vmovdqa64 [rsp + 64], zmm8
vpermb zmm8, zmm13, [rdi + 128]
vmovdqa64 [rsp + 128], zmm8
vpermb zmm8, zmm13, [rdi + 192]
vmovdqa64 [rsp + 192], zmm8
vpermb zmm8, zmm13, [rdi + 256]
vmovdqa64 [rsp + 256], zmm8
vpermb zmm8, zmm13, [rdi + 320]
vmovdqa64 [rsp + 320], zmm8
vmovdqa64 zmm14, [rip + .Lflock_canonical_p01]
vmovdqa64 zmm15, [rip + .Lflock_canonical_p23]
vpbroadcastq zmm0, [rsp + 0]
vpbroadcastq zmm1, [rsp + 64]
vmovdqu64 zmm2, [rsi + 0]
vmovdqu64 zmm3, [rsi + 64]
vgf2p8affineqb zmm8, zmm0, zmm2, 0
vgf2p8affineqb zmm9, zmm1, zmm2, 0
vgf2p8affineqb zmm10, zmm0, zmm3, 0
vgf2p8affineqb zmm11, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 8]
vpbroadcastq zmm1, [rsp + 72]
vmovdqu64 zmm2, [rsi + 128]
vmovdqu64 zmm3, [rsi + 192]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpxorq zmm8, zmm8, zmm4
vpxorq zmm9, zmm9, zmm5
vpxorq zmm10, zmm10, zmm6
vpxorq zmm11, zmm11, zmm7
vpbroadcastq zmm0, [rsp + 16]
vpbroadcastq zmm1, [rsp + 80]
vmovdqu64 zmm2, [rsi + 256]
vmovdqu64 zmm3, [rsi + 320]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 24]
vpbroadcastq zmm1, [rsp + 88]
vmovdqu64 zmm2, [rsi + 384]
vmovdqu64 zmm3, [rsi + 448]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 32]
vpbroadcastq zmm1, [rsp + 96]
vmovdqu64 zmm2, [rsi + 512]
vmovdqu64 zmm3, [rsi + 576]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 40]
vpbroadcastq zmm1, [rsp + 104]
vmovdqu64 zmm2, [rsi + 640]
vmovdqu64 zmm3, [rsi + 704]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 48]
vpbroadcastq zmm1, [rsp + 112]
vmovdqu64 zmm2, [rsi + 768]
vmovdqu64 zmm3, [rsi + 832]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 56]
vpbroadcastq zmm1, [rsp + 120]
vmovdqu64 zmm2, [rsi + 896]
vmovdqu64 zmm3, [rsi + 960]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpermb zmm8, zmm13, zmm8
vpermb zmm9, zmm13, zmm9
vpermb zmm10, zmm13, zmm10
vpermb zmm11, zmm13, zmm11
vmovdqa64 zmm0, zmm14
vmovdqa64 zmm1, zmm15
vmovdqa64 zmm2, zmm0
vmovdqa64 zmm3, zmm1
vpermi2q zmm2, zmm8, zmm10
vpermi2q zmm3, zmm8, zmm10
vpermi2q zmm0, zmm9, zmm11
vpermi2q zmm1, zmm9, zmm11
vinserti64x4 zmm4, zmm2, ymm0, 1
vshufi64x2 zmm5, zmm2, zmm0, 0xee
vinserti64x4 zmm6, zmm3, ymm1, 1
vshufi64x2 zmm7, zmm3, zmm1, 0xee
vmovdqu64 [rdx + 0], zmm4
vmovdqu64 [rdx + 256], zmm5
vmovdqu64 [rdx + 512], zmm6
vmovdqu64 [rdx + 768], zmm7
vpbroadcastq zmm0, [rsp + 128]
vpbroadcastq zmm1, [rsp + 192]
vmovdqu64 zmm2, [rsi + 1024]
vmovdqu64 zmm3, [rsi + 1088]
vgf2p8affineqb zmm8, zmm0, zmm2, 0
vgf2p8affineqb zmm9, zmm1, zmm2, 0
vgf2p8affineqb zmm10, zmm0, zmm3, 0
vgf2p8affineqb zmm11, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 136]
vpbroadcastq zmm1, [rsp + 200]
vmovdqu64 zmm2, [rsi + 1152]
vmovdqu64 zmm3, [rsi + 1216]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpxorq zmm8, zmm8, zmm4
vpxorq zmm9, zmm9, zmm5
vpxorq zmm10, zmm10, zmm6
vpxorq zmm11, zmm11, zmm7
vpbroadcastq zmm0, [rsp + 144]
vpbroadcastq zmm1, [rsp + 208]
vmovdqu64 zmm2, [rsi + 1280]
vmovdqu64 zmm3, [rsi + 1344]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 152]
vpbroadcastq zmm1, [rsp + 216]
vmovdqu64 zmm2, [rsi + 1408]
vmovdqu64 zmm3, [rsi + 1472]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 160]
vpbroadcastq zmm1, [rsp + 224]
vmovdqu64 zmm2, [rsi + 1536]
vmovdqu64 zmm3, [rsi + 1600]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 168]
vpbroadcastq zmm1, [rsp + 232]
vmovdqu64 zmm2, [rsi + 1664]
vmovdqu64 zmm3, [rsi + 1728]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 176]
vpbroadcastq zmm1, [rsp + 240]
vmovdqu64 zmm2, [rsi + 1792]
vmovdqu64 zmm3, [rsi + 1856]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 184]
vpbroadcastq zmm1, [rsp + 248]
vmovdqu64 zmm2, [rsi + 1920]
vmovdqu64 zmm3, [rsi + 1984]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpermb zmm8, zmm13, zmm8
vpermb zmm9, zmm13, zmm9
vpermb zmm10, zmm13, zmm10
vpermb zmm11, zmm13, zmm11
vmovdqa64 zmm0, zmm14
vmovdqa64 zmm1, zmm15
vmovdqa64 zmm2, zmm0
vmovdqa64 zmm3, zmm1
vpermi2q zmm2, zmm8, zmm10
vpermi2q zmm3, zmm8, zmm10
vpermi2q zmm0, zmm9, zmm11
vpermi2q zmm1, zmm9, zmm11
vinserti64x4 zmm4, zmm2, ymm0, 1
vshufi64x2 zmm5, zmm2, zmm0, 0xee
vinserti64x4 zmm6, zmm3, ymm1, 1
vshufi64x2 zmm7, zmm3, zmm1, 0xee
vmovdqu64 [rdx + 64], zmm4
vmovdqu64 [rdx + 320], zmm5
vmovdqu64 [rdx + 576], zmm6
vmovdqu64 [rdx + 832], zmm7
vpbroadcastq zmm0, [rsp + 256]
vpbroadcastq zmm1, [rsp + 320]
vmovdqu64 zmm2, [rsi + 2048]
vmovdqu64 zmm3, [rsi + 2112]
vgf2p8affineqb zmm8, zmm0, zmm2, 0
vgf2p8affineqb zmm9, zmm1, zmm2, 0
vgf2p8affineqb zmm10, zmm0, zmm3, 0
vgf2p8affineqb zmm11, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 264]
vpbroadcastq zmm1, [rsp + 328]
vmovdqu64 zmm2, [rsi + 2176]
vmovdqu64 zmm3, [rsi + 2240]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpxorq zmm8, zmm8, zmm4
vpxorq zmm9, zmm9, zmm5
vpxorq zmm10, zmm10, zmm6
vpxorq zmm11, zmm11, zmm7
vpbroadcastq zmm0, [rsp + 272]
vpbroadcastq zmm1, [rsp + 336]
vmovdqu64 zmm2, [rsi + 2304]
vmovdqu64 zmm3, [rsi + 2368]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 280]
vpbroadcastq zmm1, [rsp + 344]
vmovdqu64 zmm2, [rsi + 2432]
vmovdqu64 zmm3, [rsi + 2496]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 288]
vpbroadcastq zmm1, [rsp + 352]
vmovdqu64 zmm2, [rsi + 2560]
vmovdqu64 zmm3, [rsi + 2624]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 296]
vpbroadcastq zmm1, [rsp + 360]
vmovdqu64 zmm2, [rsi + 2688]
vmovdqu64 zmm3, [rsi + 2752]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpbroadcastq zmm0, [rsp + 304]
vpbroadcastq zmm1, [rsp + 368]
vmovdqu64 zmm2, [rsi + 2816]
vmovdqu64 zmm3, [rsi + 2880]
vgf2p8affineqb zmm4, zmm0, zmm2, 0
vgf2p8affineqb zmm5, zmm1, zmm2, 0
vgf2p8affineqb zmm6, zmm0, zmm3, 0
vgf2p8affineqb zmm7, zmm1, zmm3, 0
vpbroadcastq zmm0, [rsp + 312]
vpbroadcastq zmm1, [rsp + 376]
vmovdqu64 zmm2, [rsi + 2944]
vmovdqu64 zmm3, [rsi + 3008]
vgf2p8affineqb zmm12, zmm0, zmm2, 0
vpternlogq zmm8, zmm4, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm2, 0
vpternlogq zmm9, zmm5, zmm12, 0x96
vgf2p8affineqb zmm12, zmm0, zmm3, 0
vpternlogq zmm10, zmm6, zmm12, 0x96
vgf2p8affineqb zmm12, zmm1, zmm3, 0
vpternlogq zmm11, zmm7, zmm12, 0x96
vpermb zmm8, zmm13, zmm8
vpermb zmm9, zmm13, zmm9
vpermb zmm10, zmm13, zmm10
vpermb zmm11, zmm13, zmm11
vmovdqa64 zmm0, zmm14
vmovdqa64 zmm1, zmm15
vmovdqa64 zmm2, zmm0
vmovdqa64 zmm3, zmm1
vpermi2q zmm2, zmm8, zmm10
vpermi2q zmm3, zmm8, zmm10
vpermi2q zmm0, zmm9, zmm11
vpermi2q zmm1, zmm9, zmm11
vinserti64x4 zmm4, zmm2, ymm0, 1
vshufi64x2 zmm5, zmm2, zmm0, 0xee
vinserti64x4 zmm6, zmm3, ymm1, 1
vshufi64x2 zmm7, zmm3, zmm1, 0xee
vmovdqu64 [rdx + 128], zmm4
vmovdqu64 [rdx + 384], zmm5
vmovdqu64 [rdx + 640], zmm6
vmovdqu64 [rdx + 896], zmm7
mov rsp, rbp
pop rbp
ret
.size flock_canonical_cached4, .-flock_canonical_cached4
.section .rodata
.p2align 6
.Lflock_canonical_bt:
.byte 0,8,16,24,32,40,48,56,1,9,17,25,33,41,49,57,2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59,4,12,20,28,36,44,52,60,5,13,21,29,37,45,53,61,6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63
.p2align 6
.Lflock_canonical_p01:
.quad 0,8,4,12,1,9,5,13
.p2align 6
.Lflock_canonical_p23:
.quad 2,10,6,14,3,11,7,15
.p2align 6

.p2align 6
