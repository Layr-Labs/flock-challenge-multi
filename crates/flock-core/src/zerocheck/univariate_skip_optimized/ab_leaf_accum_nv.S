// FLOCK_AB_NOVZU=1 alternates: Mahmoud514 5b2ced50's flock_ab_leaf_interpolate0/2
// from ab_leaf_accum.S, renamed *_nv. They drop the trailing vzeroupper (the
// next call, flock_ab_poly_finalize, is ZMM code) and one dead vmovdqa64.
// Every other instruction equals the incumbent copies in ab_leaf_accum.S (regenerated on c0202046's ternlog-folded copies).
.text
.p2align 5
.globl flock_ab_leaf_interpolate0_nv
.type flock_ab_leaf_interpolate0_nv, @function
flock_ab_leaf_interpolate0_nv:
push rbp
mov rbp, rsp
and rsp, -64
sub rsp, 2432
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 64]
vmovdqu64 zmm25, ZMMWORD PTR [rdi + 384]
vpxorq zmm24, zmm30, zmm25
vmovdqu64 zmm23, ZMMWORD PTR [rdi + 0]
vmovdqu64 ZMMWORD PTR [rsi + 0], zmm23
vpxorq zmm23, zmm23, zmm28
vpxorq zmm24, zmm24, zmm23
vmovdqu64 ZMMWORD PTR [rsi + 128], zmm24
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 1792]
vmovdqu64 zmm19, ZMMWORD PTR [rdi + 1856]
vmovdqu64 zmm18, ZMMWORD PTR [rdi + 1728]
vpxorq zmm17, zmm18, zmm22
vmovdqu64 zmm14, ZMMWORD PTR [rdi + 2752]
vmovdqu64 zmm13, ZMMWORD PTR [rdi + 2560]
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 2368]
vmovdqa64 zmm11, zmm12
vpxorq zmm11, zmm11, zmm13
vmovdqu64 ZMMWORD PTR [rsi + 1792], zmm11
vmovdqu64 zmm7, ZMMWORD PTR [rdi + 2816]
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 2688]
vpxorq zmm5, zmm6, zmm14
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 2624]
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 2496]
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 2432]
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 2304]
vpxorq zmm12, zmm1, zmm12
vmovdqu64 ZMMWORD PTR [rsp + 0], zmm18
vmovdqu64 zmm24, ZMMWORD PTR [rdi + 3328]
vmovdqu64 zmm9, ZMMWORD PTR [rdi + 3136]
vmovdqu64 ZMMWORD PTR [rsp + 128], zmm6
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 2944]
vmovdqu64 ZMMWORD PTR [rsp + 192], zmm1
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 2176]
vpxorq zmm8, zmm1, zmm13
vpxorq zmm9, zmm9, zmm8
vpternlogq zmm13, zmm3, zmm4, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 320], zmm8
vmovdqu64 zmm8, ZMMWORD PTR [rdi + 1984]
vmovdqu64 ZMMWORD PTR [rsp + 448], zmm1
vmovdqu64 ZMMWORD PTR [rsp + 576], zmm28
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 3200]
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 3264]
vmovdqu64 ZMMWORD PTR [rsp + 704], zmm21
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 3072]
vmovdqu64 zmm11, ZMMWORD PTR [rdi + 3008]
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 2880]
vmovdqu64 ZMMWORD PTR [rsp + 896], zmm30
vpxorq zmm30, zmm0, zmm6
vpxorq zmm11, zmm11, zmm30
vpternlogq zmm14, zmm30, zmm9, 0x96
vpxorq zmm0, zmm0, zmm5
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 2240]
vpxorq zmm4, zmm30, zmm4
vpxorq zmm9, zmm9, zmm4
vpternlogq zmm28, zmm11, zmm9, 0x96
vmovdqu64 zmm9, ZMMWORD PTR [rdi + 2112]
vpxorq zmm10, zmm9, zmm3
vpxorq zmm21, zmm21, zmm10
vpternlogq zmm3, zmm8, zmm6, 0x96
vpxorq zmm3, zmm3, zmm12
vmovdqu64 ZMMWORD PTR [rsi + 1664], zmm3
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 2048]
vmovdqu64 ZMMWORD PTR [rsp + 1024], zmm4
vpxorq zmm4, zmm19, zmm3
vpternlogq zmm19, zmm24, zmm17, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 1088], zmm19
vpxorq zmm19, zmm2, zmm4
vpternlogq zmm7, zmm19, zmm5, 0x96
vpxorq zmm2, zmm2, zmm12
vpxorq zmm13, zmm13, zmm2
vmovdqu64 ZMMWORD PTR [rsi + 1728], zmm13
vmovdqu64 zmm13, ZMMWORD PTR [rdi + 1920]
vpxorq zmm8, zmm13, zmm8
vpternlogq zmm3, zmm8, zmm11, 0x96
vpxorq zmm3, zmm3, zmm2
vmovdqu64 ZMMWORD PTR [rsi + 1600], zmm3
vpternlogq zmm22, zmm8, zmm12, 0x96
vpxorq zmm22, zmm22, zmm14
vmovdqu64 ZMMWORD PTR [rsi + 1536], zmm22
vpxorq zmm8, zmm17, zmm8
vpxorq zmm12, zmm12, zmm8
vpxorq zmm22, zmm12, zmm21
vpxorq zmm3, zmm7, zmm22
vpxorq zmm3, zmm3, zmm28
vmovdqu64 ZMMWORD PTR [rsi + 1472], zmm3
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 4096]
vmovdqu64 zmm5, ZMMWORD PTR [rdi + 832]
vmovdqu64 ZMMWORD PTR [rsp + 1152], zmm28
vmovdqu64 ZMMWORD PTR [rsp + 1216], zmm17
vmovdqu64 ZMMWORD PTR [rsp + 1280], zmm4
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 4160]
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 4032]
vmovdqu64 ZMMWORD PTR [rsp + 1408], zmm19
vpxorq zmm19, zmm1, zmm2
vpxorq zmm4, zmm4, zmm19
vpternlogq zmm2, zmm5, zmm0, 0x96
vpxorq zmm2, zmm2, zmm22
vmovdqu64 ZMMWORD PTR [rsi + 1408], zmm2
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 896]
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 768]
vpxorq zmm5, zmm22, zmm5
vmovdqu64 ZMMWORD PTR [rsp + 1472], zmm0
vpxorq zmm0, zmm2, zmm5
vpternlogq zmm0, zmm12, zmm4, 0x96
vpxorq zmm0, zmm0, zmm7
vmovdqu64 ZMMWORD PTR [rsi + 1344], zmm0
vmovdqu64 zmm20, ZMMWORD PTR [rdi + 3392]
vmovdqu64 ZMMWORD PTR [rsp + 1536], zmm7
vmovdqu64 zmm7, ZMMWORD PTR [rdi + 128]
vmovdqu64 ZMMWORD PTR [rsp + 1600], zmm20
vmovdqa64 zmm20, zmm7
vpxorq zmm20, zmm20, zmm23
vmovdqu64 ZMMWORD PTR [rsi + 64], zmm20
vmovdqu64 ZMMWORD PTR [rsp + 1664], zmm2
vmovdqu64 ZMMWORD PTR [rsp + 1792], zmm22
vmovdqu64 zmm15, ZMMWORD PTR [rdi + 512]
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 448]
vmovdqu64 ZMMWORD PTR [rsp + 1984], zmm14
vmovdqu64 zmm14, ZMMWORD PTR [rdi + 320]
vpxorq zmm7, zmm7, zmm14
vmovdqa64 zmm17, zmm25
vpternlogq zmm17, zmm15, zmm7, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 2112], zmm15
vmovdqu64 zmm15, ZMMWORD PTR [rdi + 256]
vmovdqu64 ZMMWORD PTR [rsp + 2176], zmm7
vmovdqu64 zmm7, ZMMWORD PTR [rsp + 896]
vpxorq zmm7, zmm7, zmm15
vpxorq zmm23, zmm23, zmm7
vmovdqu64 ZMMWORD PTR [rsp + 896], zmm21
vpxorq zmm21, zmm22, zmm23
vpxorq zmm17, zmm17, zmm21
vmovdqu64 ZMMWORD PTR [rsi + 192], zmm17
vmovdqu64 ZMMWORD PTR [rsp + 2240], zmm21
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 3520]
vmovdqu64 zmm17, ZMMWORD PTR [rdi + 4672]
vmovdqu64 zmm20, ZMMWORD PTR [rdi + 1408]
vpxorq zmm15, zmm15, zmm20
vpternlogq zmm15, zmm6, zmm17, 0x96
vpxorq zmm30, zmm30, zmm21
vpxorq zmm13, zmm20, zmm13
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 3456]
vpxorq zmm24, zmm24, zmm6
vmovdqu64 ZMMWORD PTR [rsp + 832], zmm13
vmovdqu64 zmm13, ZMMWORD PTR [rsp + 576]
vpternlogq zmm13, zmm24, zmm19, 0x96
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 4608]
vpxorq zmm17, zmm16, zmm17
vpxorq zmm1, zmm1, zmm16
vmovdqu64 zmm31, ZMMWORD PTR [rdi + 1344]
vpxorq zmm20, zmm31, zmm20
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 3712]
vmovdqu64 ZMMWORD PTR [rsp + 576], zmm1
vmovdqu64 ZMMWORD PTR [rsp + 2304], zmm30
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 4480]
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 1600]
vmovdqu64 zmm29, ZMMWORD PTR [rdi + 1216]
vmovdqu64 ZMMWORD PTR [rsp + 512], zmm31
vmovdqu64 zmm31, ZMMWORD PTR [rdi + 1024]
vpxorq zmm22, zmm22, zmm31
vpxorq zmm8, zmm8, zmm22
vmovdqu64 ZMMWORD PTR [rsp + 2368], zmm13
vmovdqu64 zmm13, ZMMWORD PTR [rsp + 448]
vpternlogq zmm13, zmm16, zmm8, 0x96
vpxorq zmm2, zmm2, zmm22
vmovdqu64 zmm18, ZMMWORD PTR [rdi + 4864]
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 4288]
vpternlogq zmm16, zmm3, zmm17, 0x96
vpternlogq zmm18, zmm2, zmm16, 0x96
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 3904]
vpxorq zmm22, zmm22, zmm12
vmovdqu64 zmm12, ZMMWORD PTR [rsp + 320]
vpxorq zmm12, zmm22, zmm12
vpternlogq zmm31, zmm3, zmm12, 0x96
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 640]
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 4416]
vmovdqu64 zmm27, ZMMWORD PTR [rdi + 1152]
vmovdqu64 zmm8, ZMMWORD PTR [rsp + 192]
vpxorq zmm8, zmm27, zmm8
vmovdqu64 ZMMWORD PTR [rsp + 192], zmm17
vmovdqu64 zmm17, ZMMWORD PTR [rsp + 128]
vpternlogq zmm8, zmm17, zmm16, 0x96
vmovdqu64 zmm26, ZMMWORD PTR [rdi + 1536]
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 1280]
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 4544]
vpxorq zmm17, zmm12, zmm17
vpternlogq zmm17, zmm5, zmm19, 0x96
vpxorq zmm17, zmm17, zmm31
vmovdqu64 ZMMWORD PTR [rsi + 1280], zmm17
vmovdqu64 ZMMWORD PTR [rsp + 128], zmm31
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 576]
vpxorq zmm12, zmm3, zmm12
vpxorq zmm5, zmm12, zmm5
vmovdqu64 zmm31, ZMMWORD PTR [rdi + 3840]
vpxorq zmm21, zmm21, zmm31
vpxorq zmm7, zmm7, zmm5
vpxorq zmm22, zmm22, zmm21
vpternlogq zmm15, zmm19, zmm22, 0x96
vpternlogq zmm14, zmm6, zmm22, 0x96
vpxorq zmm30, zmm30, zmm22
vpternlogq zmm14, zmm11, zmm4, 0x96
vpxorq zmm10, zmm5, zmm10
vpxorq zmm5, zmm23, zmm5
vpxorq zmm12, zmm12, zmm23
vmovdqu64 zmm23, ZMMWORD PTR [rsp + 704]
vpxorq zmm23, zmm23, zmm5
vpxorq zmm24, zmm23, zmm24
vpternlogq zmm8, zmm21, zmm24, 0x96
vpxorq zmm8, zmm8, zmm13
vmovdqu64 ZMMWORD PTR [rsi + 768], zmm8
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 960]
vpxorq zmm25, zmm25, zmm28
vpxorq zmm26, zmm26, zmm25
vpxorq zmm9, zmm9, zmm25
vmovdqu64 zmm25, ZMMWORD PTR [rsp + 0]
vpternlogq zmm25, zmm23, zmm2, 0x96
vmovdqu64 zmm8, ZMMWORD PTR [rsp + 896]
vpxorq zmm8, zmm26, zmm8
vpxorq zmm16, zmm16, zmm30
vpxorq zmm3, zmm3, zmm27
vmovdqu64 zmm21, ZMMWORD PTR [rsp + 2240]
vpxorq zmm3, zmm3, zmm21
vmovdqu64 ZMMWORD PTR [rsi + 256], zmm3
vpxorq zmm27, zmm27, zmm29
vpxorq zmm29, zmm29, zmm20
vpxorq zmm25, zmm25, zmm29
vmovdqu64 ZMMWORD PTR [rsi + 512], zmm25
vmovdqu64 zmm25, ZMMWORD PTR [rsp + 2368]
vpternlogq zmm25, zmm30, zmm29, 0x96
vmovdqu64 zmm29, ZMMWORD PTR [rsp + 1984]
vpternlogq zmm25, zmm7, zmm29, 0x96
vpxorq zmm25, zmm25, zmm18
vmovdqu64 ZMMWORD PTR [rsi + 1024], zmm25
vpxorq zmm0, zmm0, zmm27
vmovdqu64 zmm25, ZMMWORD PTR [rsp + 512]
vpxorq zmm25, zmm25, zmm27
vmovdqu64 zmm27, ZMMWORD PTR [rsp + 1792]
vpternlogq zmm27, zmm26, zmm25, 0x96
vpxorq zmm27, zmm27, zmm12
vmovdqu64 ZMMWORD PTR [rsi + 384], zmm27
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 3968]
vmovdqu64 zmm27, ZMMWORD PTR [rdi + 704]
vmovdqu64 zmm11, ZMMWORD PTR [rsp + 1664]
vpxorq zmm11, zmm27, zmm11
vmovdqu64 zmm22, ZMMWORD PTR [rsp + 1408]
vpxorq zmm22, zmm11, zmm22
vmovdqu64 zmm6, ZMMWORD PTR [rsp + 2176]
vpternlogq zmm27, zmm6, zmm0, 0x96
vpxorq zmm27, zmm27, zmm12
vmovdqu64 ZMMWORD PTR [rsi + 320], zmm27
vpxorq zmm6, zmm6, zmm11
vpxorq zmm5, zmm5, zmm6
vmovdqu64 zmm11, ZMMWORD PTR [rsp + 1600]
vpxorq zmm11, zmm11, zmm6
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 1088]
vpternlogq zmm31, zmm21, zmm30, 0x96
vmovdqu64 zmm27, ZMMWORD PTR [rsp + 2112]
vpxorq zmm27, zmm27, zmm21
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 1664]
vpxorq zmm6, zmm6, zmm0
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 1472]
vpxorq zmm3, zmm3, zmm20
vpternlogq zmm5, zmm3, zmm26, 0x96
vpternlogq zmm5, zmm2, zmm27, 0x96
vpxorq zmm5, zmm5, zmm6
vmovdqu64 ZMMWORD PTR [rsi + 448], zmm5
vmovdqu64 zmm5, ZMMWORD PTR [rsp + 1088]
vpternlogq zmm5, zmm23, zmm3, 0x96
vpxorq zmm5, zmm5, zmm11
vmovdqu64 ZMMWORD PTR [rsi + 576], zmm5
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 4736]
vpxorq zmm12, zmm12, zmm3
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 3584]
vmovdqu64 zmm3, ZMMWORD PTR [rsp + 2304]
vmovdqu64 zmm5, ZMMWORD PTR [rsp + 1280]
vpternlogq zmm3, zmm21, zmm5, 0x96
vpxorq zmm21, zmm21, zmm30
vmovdqu64 zmm30, ZMMWORD PTR [rsp + 192]
vpternlogq zmm14, zmm21, zmm30, 0x96
vpternlogq zmm14, zmm12, zmm7, 0x96
vpxorq zmm14, zmm14, zmm22
vmovdqu64 ZMMWORD PTR [rsi + 1088], zmm14
vpternlogq zmm3, zmm9, zmm13, 0x96
vpxorq zmm21, zmm21, zmm16
vmovdqu64 zmm13, ZMMWORD PTR [rsp + 1536]
vpternlogq zmm1, zmm13, zmm21, 0x96
vpternlogq zmm0, zmm24, zmm11, 0x96
vpxorq zmm0, zmm0, zmm1
vmovdqu64 ZMMWORD PTR [rsi + 832], zmm0
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 4352]
vpxorq zmm0, zmm0, zmm4
vmovdqu64 zmm4, ZMMWORD PTR [rsp + 1024]
vpternlogq zmm31, zmm4, zmm0, 0x96
vmovdqu64 zmm29, ZMMWORD PTR [rdi + 4928]
vpxorq zmm29, zmm29, zmm6
vpternlogq zmm29, zmm0, zmm12, 0x96
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 3776]
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 4224]
vpternlogq zmm28, zmm12, zmm10, 0x96
vpxorq zmm15, zmm15, zmm28
vmovdqu64 ZMMWORD PTR [rsi + 1152], zmm15
vpternlogq zmm31, zmm22, zmm28, 0x96
vmovdqu64 zmm28, ZMMWORD PTR [rsp + 128]
vpxorq zmm31, zmm31, zmm28
vmovdqu64 ZMMWORD PTR [rsi + 1216], zmm31
vmovdqu64 zmm17, ZMMWORD PTR [rdi + 4800]
vpternlogq zmm12, zmm17, zmm8, 0x96
vmovdqu64 zmm31, ZMMWORD PTR [rdi + 3648]
vpxorq zmm31, zmm31, zmm24
vmovdqu64 zmm24, ZMMWORD PTR [rsp + 576]
vpternlogq zmm24, zmm31, zmm16, 0x96
vmovdqu64 zmm16, ZMMWORD PTR [rsp + 1472]
vpternlogq zmm24, zmm25, zmm16, 0x96
vpxorq zmm24, zmm24, zmm12
vmovdqu64 ZMMWORD PTR [rsi + 896], zmm24
vmovdqu64 zmm24, ZMMWORD PTR [rsp + 832]
vmovdqu64 zmm16, ZMMWORD PTR [rsp + 1216]
vpternlogq zmm24, zmm16, zmm31, 0x96
vpxorq zmm24, zmm24, zmm9
vmovdqu64 ZMMWORD PTR [rsi + 640], zmm24
vpxorq zmm31, zmm31, zmm27
vpternlogq zmm4, zmm11, zmm31, 0x96
vpxorq zmm3, zmm3, zmm4
vmovdqu64 ZMMWORD PTR [rsi + 704], zmm3
vmovdqu64 zmm3, ZMMWORD PTR [rsp + 1152]
vpternlogq zmm29, zmm3, zmm4, 0x96
vpternlogq zmm29, zmm12, zmm1, 0x96
vpxorq zmm29, zmm29, zmm18
vmovdqu64 ZMMWORD PTR [rsi + 960], zmm29
mov rsp, rbp
pop rbp
ret
.size flock_ab_leaf_interpolate0_nv, .-flock_ab_leaf_interpolate0_nv
.p2align 5
.globl flock_ab_leaf_interpolate2_nv
.type flock_ab_leaf_interpolate2_nv, @function
flock_ab_leaf_interpolate2_nv:
push rbp
mov rbp, rsp
and rsp, -64
sub rsp, 2432
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm29, ZMMWORD PTR [rdi + 0]
vmovdqa64 zmm28, zmm29
vpxorq zmm28, zmm28, zmm30
vmovdqu64 ZMMWORD PTR [rsi + 128], zmm28
vmovdqu64 zmm26, ZMMWORD PTR [rdi + 320]
vmovdqu64 zmm25, ZMMWORD PTR [rdi + 256]
vmovdqu64 zmm24, ZMMWORD PTR [rdi + 128]
vmovdqa64 zmm23, zmm24
vpternlogq zmm23, zmm30, zmm26, 0x96
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 64]
vpxorq zmm29, zmm29, zmm22
vpxorq zmm21, zmm25, zmm29
vpxorq zmm23, zmm23, zmm21
vmovdqu64 ZMMWORD PTR [rsi + 192], zmm23
vmovdqu64 zmm20, ZMMWORD PTR [rdi + 384]
vmovdqu64 zmm19, ZMMWORD PTR [rdi + 960]
vpxorq zmm18, zmm20, zmm19
vpxorq zmm18, zmm18, zmm21
vmovdqu64 ZMMWORD PTR [rsi + 256], zmm18
vmovdqu64 zmm17, ZMMWORD PTR [rdi + 512]
vpxorq zmm24, zmm24, zmm17
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 448]
vpxorq zmm20, zmm20, zmm16
vpxorq zmm29, zmm29, zmm20
vpxorq zmm15, zmm29, zmm24
vmovdqu64 zmm14, ZMMWORD PTR [rdi + 1088]
vmovdqu64 zmm13, ZMMWORD PTR [rdi + 1024]
vpxorq zmm12, zmm19, zmm13
vpxorq zmm14, zmm14, zmm12
vpxorq zmm15, zmm15, zmm14
vmovdqu64 ZMMWORD PTR [rsi + 320], zmm15
vmovdqu64 zmm10, ZMMWORD PTR [rdi + 1344]
vmovdqu64 zmm9, ZMMWORD PTR [rdi + 768]
vpxorq zmm30, zmm30, zmm9
vpxorq zmm10, zmm10, zmm30
vmovdqu64 zmm8, ZMMWORD PTR [rdi + 576]
vmovdqa64 zmm7, zmm8
vpternlogq zmm7, zmm29, zmm10, 0x96
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 1152]
vpxorq zmm12, zmm6, zmm12
vpxorq zmm7, zmm7, zmm12
vmovdqu64 ZMMWORD PTR [rsi + 384], zmm7
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 1408]
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 832]
vpxorq zmm25, zmm25, zmm3
vpxorq zmm4, zmm4, zmm25
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 896]
vpxorq zmm26, zmm26, zmm1
vpxorq zmm17, zmm17, zmm1
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 1472]
vpternlogq zmm0, zmm14, zmm26, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 0], zmm17
vmovdqu64 zmm17, ZMMWORD PTR [rdi + 1280]
vmovdqu64 ZMMWORD PTR [rsp + 64], zmm3
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 1216]
vpxorq zmm6, zmm6, zmm3
vpxorq zmm17, zmm17, zmm6
vpxorq zmm13, zmm13, zmm6
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 704]
vmovdqu64 ZMMWORD PTR [rsp + 128], zmm22
vmovdqa64 zmm22, zmm6
vpternlogq zmm22, zmm24, zmm17, 0x96
vmovdqu64 zmm5, ZMMWORD PTR [rdi + 640]
vpxorq zmm8, zmm8, zmm5
vmovdqu64 ZMMWORD PTR [rsp + 256], zmm5
vmovdqa64 zmm5, zmm8
vpternlogq zmm5, zmm29, zmm4, 0x96
vpternlogq zmm22, zmm10, zmm5, 0x96
vpxorq zmm22, zmm22, zmm0
vmovdqu64 ZMMWORD PTR [rsi + 448], zmm22
vmovdqu64 ZMMWORD PTR [rsp + 320], zmm0
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 3264]
vmovdqu64 ZMMWORD PTR [rsp + 384], zmm4
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 1536]
vmovdqa64 zmm1, zmm4
vpternlogq zmm1, zmm0, zmm13, 0x96
vpxorq zmm1, zmm1, zmm5
vmovdqu64 ZMMWORD PTR [rsi + 512], zmm1
vmovdqu64 zmm7, ZMMWORD PTR [rdi + 3392]
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 3328]
vmovdqu64 ZMMWORD PTR [rsp + 640], zmm12
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 1664]
vpxorq zmm6, zmm6, zmm12
vpxorq zmm24, zmm24, zmm6
vpxorq zmm7, zmm7, zmm24
vmovdqu64 ZMMWORD PTR [rsp + 704], zmm12
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 1600]
vpxorq zmm4, zmm4, zmm12
vpxorq zmm8, zmm8, zmm4
vpxorq zmm29, zmm29, zmm8
vpxorq zmm2, zmm2, zmm29
vpxorq zmm0, zmm0, zmm2
vmovdqu64 ZMMWORD PTR [rsp + 768], zmm12
vpxorq zmm12, zmm0, zmm17
vpxorq zmm12, zmm12, zmm7
vmovdqu64 ZMMWORD PTR [rsi + 576], zmm12
vmovdqu64 ZMMWORD PTR [rsp + 832], zmm24
vmovdqu64 zmm24, ZMMWORD PTR [rdi + 3456]
vmovdqu64 ZMMWORD PTR [rsp + 896], zmm6
vmovdqu64 zmm31, ZMMWORD PTR [rdi + 3648]
vmovdqu64 ZMMWORD PTR [rsp + 960], zmm29
vmovdqu64 zmm29, ZMMWORD PTR [rdi + 1920]
vpternlogq zmm30, zmm29, zmm31, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 1024], zmm17
vmovdqu64 zmm17, ZMMWORD PTR [rdi + 1728]
vmovdqu64 ZMMWORD PTR [rsp + 1088], zmm4
vpxorq zmm4, zmm3, zmm17
vpternlogq zmm4, zmm24, zmm0, 0x96
vpxorq zmm4, zmm4, zmm30
vmovdqu64 ZMMWORD PTR [rsi + 640], zmm4
vmovdqu64 ZMMWORD PTR [rsp + 1152], zmm3
vmovdqu64 ZMMWORD PTR [rsp + 1216], zmm20
vmovdqu64 zmm20, ZMMWORD PTR [rdi + 3584]
vmovdqu64 ZMMWORD PTR [rsp + 1280], zmm8
vmovdqu64 zmm8, ZMMWORD PTR [rdi + 3520]
vpxorq zmm24, zmm24, zmm8
vpxorq zmm0, zmm0, zmm24
vmovdqu64 ZMMWORD PTR [rsp + 1344], zmm24
vmovdqu64 zmm27, ZMMWORD PTR [rdi + 3776]
vpxorq zmm27, zmm27, zmm7
vmovdqu64 ZMMWORD PTR [rsp + 1408], zmm8
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 3712]
vmovdqu64 ZMMWORD PTR [rsp + 1472], zmm9
vmovdqu64 zmm9, ZMMWORD PTR [rdi + 2048]
vmovdqu64 zmm24, ZMMWORD PTR [rdi + 1984]
vmovdqu64 zmm8, ZMMWORD PTR [rdi + 1856]
vmovdqa64 zmm3, zmm8
vpternlogq zmm3, zmm9, zmm20, 0x96
vpternlogq zmm3, zmm0, zmm26, 0x96
vpternlogq zmm3, zmm27, zmm30, 0x96
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 1792]
vpxorq zmm17, zmm17, zmm30
vpxorq zmm25, zmm17, zmm25
vpternlogq zmm25, zmm24, zmm28, 0x96
vpxorq zmm3, zmm3, zmm25
vmovdqu64 ZMMWORD PTR [rsi + 704], zmm3
vmovdqu64 zmm26, ZMMWORD PTR [rdi + 4416]
vpxorq zmm26, zmm26, zmm0
vmovdqu64 zmm22, ZMMWORD PTR [rdi + 2688]
vpxorq zmm16, zmm16, zmm22
vmovdqu64 zmm0, ZMMWORD PTR [rdi + 3840]
vmovdqu64 ZMMWORD PTR [rsp + 1728], zmm16
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 2112]
vpternlogq zmm19, zmm16, zmm22, 0x96
vpternlogq zmm19, zmm0, zmm26, 0x96
vpxorq zmm19, zmm19, zmm25
vmovdqu64 ZMMWORD PTR [rsi + 768], zmm19
vmovdqu64 ZMMWORD PTR [rsp + 1792], zmm27
vmovdqu64 zmm27, ZMMWORD PTR [rdi + 4544]
vmovdqu64 zmm5, ZMMWORD PTR [rdi + 2816]
vmovdqu64 ZMMWORD PTR [rsp + 1856], zmm30
vmovdqu64 zmm30, ZMMWORD PTR [rdi + 4480]
vmovdqu64 zmm1, ZMMWORD PTR [rdi + 2752]
vpxorq zmm22, zmm22, zmm1
vpxorq zmm5, zmm5, zmm22
vmovdqu64 ZMMWORD PTR [rsp + 1920], zmm28
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 3968]
vpxorq zmm20, zmm20, zmm28
vpternlogq zmm27, zmm26, zmm20, 0x96
vmovdqu64 ZMMWORD PTR [rsp + 1984], zmm28
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 3904]
vpxorq zmm0, zmm0, zmm28
vmovdqu64 ZMMWORD PTR [rsp + 2048], zmm28
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 2240]
vpxorq zmm8, zmm8, zmm28
vmovdqu64 ZMMWORD PTR [rsp + 2112], zmm28
vpxorq zmm28, zmm30, zmm8
vpternlogq zmm28, zmm14, zmm5, 0x96
vmovdqu64 zmm14, ZMMWORD PTR [rdi + 2176]
vpxorq zmm16, zmm16, zmm14
vpxorq zmm17, zmm17, zmm16
vmovdqu64 ZMMWORD PTR [rsp + 2176], zmm14
vpxorq zmm14, zmm17, zmm0
vpternlogq zmm28, zmm7, zmm14, 0x96
vpxorq zmm28, zmm28, zmm27
vmovdqu64 ZMMWORD PTR [rsi + 832], zmm28
vmovdqu64 zmm7, ZMMWORD PTR [rdi + 4800]
vpxorq zmm7, zmm7, zmm10
vmovdqu64 zmm11, ZMMWORD PTR [rdi + 4608]
vpxorq zmm30, zmm30, zmm11
vpternlogq zmm2, zmm30, zmm13, 0x96
vmovdqu64 zmm23, ZMMWORD PTR [rdi + 4224]
vpternlogq zmm31, zmm23, zmm7, 0x96
vmovdqu64 zmm15, ZMMWORD PTR [rdi + 4032]
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 3072]
vmovdqu64 zmm12, ZMMWORD PTR [rdi + 2880]
vpxorq zmm22, zmm12, zmm22
vmovdqu64 zmm3, ZMMWORD PTR [rdi + 2496]
vpxorq zmm29, zmm29, zmm3
vmovdqu64 zmm7, ZMMWORD PTR [rsp + 1472]
vpternlogq zmm7, zmm23, zmm29, 0x96
vpxorq zmm6, zmm6, zmm29
vpternlogq zmm30, zmm6, zmm31, 0x96
vmovdqu64 zmm31, ZMMWORD PTR [rsp + 1216]
vmovdqu64 zmm29, ZMMWORD PTR [rsp + 1280]
vpternlogq zmm31, zmm29, zmm7, 0x96
vmovdqu64 zmm7, ZMMWORD PTR [rsp + 1088]
vpxorq zmm7, zmm7, zmm6
vpxorq zmm3, zmm3, zmm16
vmovdqu64 zmm16, ZMMWORD PTR [rdi + 2304]
vpxorq zmm6, zmm16, zmm15
vmovdqu64 zmm23, ZMMWORD PTR [rsp + 640]
vpternlogq zmm6, zmm26, zmm23, 0x96
vpternlogq zmm6, zmm22, zmm14, 0x96
vpxorq zmm6, zmm6, zmm30
vmovdqu64 ZMMWORD PTR [rsi + 896], zmm6
vmovdqu64 zmm10, ZMMWORD PTR [rdi + 4928]
vmovdqu64 zmm13, ZMMWORD PTR [rdi + 4736]
vmovdqu64 ZMMWORD PTR [rsp + 1536], zmm2
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 1024]
vpxorq zmm13, zmm13, zmm2
vmovdqu64 zmm21, ZMMWORD PTR [rdi + 4352]
vmovdqu64 zmm23, ZMMWORD PTR [rdi + 4160]
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 960]
vpternlogq zmm11, zmm23, zmm2, 0x96
vpxorq zmm21, zmm23, zmm21
vmovdqu64 zmm29, ZMMWORD PTR [rdi + 3200]
vmovdqu64 zmm14, ZMMWORD PTR [rdi + 3008]
vmovdqu64 zmm25, ZMMWORD PTR [rdi + 2624]
vpxorq zmm9, zmm9, zmm25
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 2432]
vpxorq zmm8, zmm28, zmm8
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 896]
vpxorq zmm2, zmm2, zmm8
vmovdqu64 ZMMWORD PTR [rsp + 896], zmm25
vmovdqu64 ZMMWORD PTR [rsp + 960], zmm28
vmovdqu64 ZMMWORD PTR [rsp + 1024], zmm2
vmovdqu64 zmm28, ZMMWORD PTR [rdi + 4864]
vmovdqu64 zmm25, ZMMWORD PTR [rdi + 4672]
vmovdqu64 zmm18, ZMMWORD PTR [rdi + 4288]
vmovdqu64 zmm26, ZMMWORD PTR [rdi + 4096]
vmovdqu64 zmm2, ZMMWORD PTR [rdi + 3136]
vmovdqu64 zmm4, ZMMWORD PTR [rdi + 2944]
vmovdqu64 ZMMWORD PTR [rsp + 1600], zmm23
vmovdqu64 zmm23, ZMMWORD PTR [rsp + 128]
vmovdqu64 ZMMWORD PTR [rsp + 192], zmm31
vmovdqu64 zmm31, ZMMWORD PTR [rsp + 1152]
vpternlogq zmm23, zmm31, zmm4, 0x96
vpxorq zmm12, zmm12, zmm4
vpternlogq zmm14, zmm8, zmm12, 0x96
vpxorq zmm1, zmm1, zmm12
vmovdqu64 zmm12, ZMMWORD PTR [rsp + 832]
vpternlogq zmm11, zmm12, zmm14, 0x96
vpternlogq zmm11, zmm20, zmm13, 0x96
vmovdqu64 zmm19, ZMMWORD PTR [rdi + 2560]
vpxorq zmm24, zmm24, zmm19
vpxorq zmm2, zmm2, zmm24
vmovdqu64 zmm20, ZMMWORD PTR [rsp + 64]
vpternlogq zmm20, zmm18, zmm24, 0x96
vmovdqu64 zmm24, ZMMWORD PTR [rsp + 1920]
vpternlogq zmm24, zmm18, zmm2, 0x96
vmovdqu64 zmm18, ZMMWORD PTR [rsp + 384]
vpternlogq zmm28, zmm18, zmm24, 0x96
vmovdqu64 zmm6, ZMMWORD PTR [rdi + 2368]
vmovdqa64 zmm24, zmm6
vmovdqu64 ZMMWORD PTR [rsi + 1920], zmm24
vpxorq zmm16, zmm16, zmm6
vmovdqu64 zmm6, ZMMWORD PTR [rsp + 1856]
vpternlogq zmm6, zmm4, zmm16, 0x96
vpxorq zmm6, zmm6, zmm3
vmovdqu64 ZMMWORD PTR [rsi + 1664], zmm6
vpxorq zmm17, zmm16, zmm17
vmovdqa64 zmm6, zmm17
vpxorq zmm6, zmm6, zmm14
vmovdqu64 ZMMWORD PTR [rsi + 1600], zmm6
vpxorq zmm14, zmm14, zmm9
vpternlogq zmm29, zmm5, zmm14, 0x96
vpxorq zmm26, zmm26, zmm17
vmovdqu64 zmm14, ZMMWORD PTR [rsp + 256]
vpternlogq zmm14, zmm26, zmm22, 0x96
vpxorq zmm14, zmm14, zmm7
vmovdqu64 ZMMWORD PTR [rsi + 1408], zmm14
vpxorq zmm15, zmm15, zmm26
vpxorq zmm17, zmm17, zmm2
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 704]
vpternlogq zmm2, zmm7, zmm17, 0x96
vpxorq zmm2, zmm2, zmm29
vmovdqu64 ZMMWORD PTR [rsi + 1472], zmm2
vpxorq zmm0, zmm0, zmm15
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 0]
vmovdqu64 zmm7, ZMMWORD PTR [rsp + 1984]
vpternlogq zmm2, zmm7, zmm0, 0x96
vpxorq zmm25, zmm25, zmm0
vmovdqu64 zmm0, ZMMWORD PTR [rsp + 1792]
vpternlogq zmm10, zmm25, zmm0, 0x96
vpternlogq zmm10, zmm21, zmm13, 0x96
vmovdqu64 zmm13, ZMMWORD PTR [rsp + 320]
vpternlogq zmm10, zmm13, zmm27, 0x96
vpternlogq zmm2, zmm9, zmm21, 0x96
vpternlogq zmm10, zmm29, zmm28, 0x96
vpxorq zmm10, zmm10, zmm30
vmovdqu64 ZMMWORD PTR [rsi + 960], zmm10
vmovdqu64 zmm10, ZMMWORD PTR [rsp + 1408]
vpternlogq zmm23, zmm10, zmm25, 0x96
vmovdqu64 zmm10, ZMMWORD PTR [rsp + 192]
vpxorq zmm23, zmm23, zmm10
vmovdqu64 ZMMWORD PTR [rsi + 1152], zmm23
vmovdqu64 zmm23, ZMMWORD PTR [rsp + 1344]
vpxorq zmm23, zmm23, zmm25
vpxorq zmm11, zmm11, zmm23
vmovdqu64 ZMMWORD PTR [rsi + 1088], zmm11
vmovdqu64 zmm11, ZMMWORD PTR [rsp + 1536]
vpternlogq zmm11, zmm1, zmm23, 0x96
vpxorq zmm11, zmm11, zmm28
vmovdqu64 ZMMWORD PTR [rsi + 1024], zmm11
vmovdqu64 zmm11, ZMMWORD PTR [rsp + 1280]
vpxorq zmm11, zmm11, zmm15
vmovdqu64 zmm15, ZMMWORD PTR [rsp + 1728]
vmovdqu64 zmm28, ZMMWORD PTR [rsp + 2048]
vpternlogq zmm15, zmm28, zmm11, 0x96
vpxorq zmm15, zmm15, zmm20
vmovdqu64 ZMMWORD PTR [rsi + 1280], zmm15
vmovdqu64 zmm15, ZMMWORD PTR [rsp + 1600]
vpternlogq zmm15, zmm5, zmm11, 0x96
vmovdqu64 zmm11, ZMMWORD PTR [rsp + 1024]
vpxorq zmm15, zmm15, zmm11
vmovdqu64 ZMMWORD PTR [rsi + 1344], zmm15
vpternlogq zmm2, zmm11, zmm20, 0x96
vpxorq zmm2, zmm2, zmm10
vmovdqu64 ZMMWORD PTR [rsi + 1216], zmm2
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 768]
vpternlogq zmm2,zmm1,zmm17,0x96
vmovdqu64 ZMMWORD PTR [rsi + 1536], zmm2
vmovdqu64 zmm2, ZMMWORD PTR [rsp + 960]
vpxorq zmm2, zmm2, zmm16
vmovdqa64 zmm17, zmm2
vmovdqu64 ZMMWORD PTR [rsi + 1856], zmm17
vmovdqu64 zmm17, ZMMWORD PTR [rsp + 2112]
vpxorq zmm17, zmm17, zmm19
vmovdqu64 zmm1, ZMMWORD PTR [rsp + 896]
vpternlogq zmm17, zmm1, zmm2, 0x96
vpxorq zmm17, zmm17, zmm3
vmovdqu64 ZMMWORD PTR [rsi + 1728], zmm17
vmovdqu64 zmm17, ZMMWORD PTR [rsp + 2176]
vpternlogq zmm17,zmm19,zmm16,0x96
vmovdqu64 ZMMWORD PTR [rsi + 1792], zmm17
mov rsp, rbp
pop rbp
ret
.size flock_ab_leaf_interpolate2_nv, .-flock_ab_leaf_interpolate2_nv
