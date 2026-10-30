.text
.p2align 5
.globl flock_ab_cantor29_partial_m0
.type flock_ab_cantor29_partial_m0,@function
flock_ab_cantor29_partial_m0:
vpxord zmm24,zmm24,zmm24
vpxord zmm25,zmm25,zmm25
vpxord zmm26,zmm26,zmm26
vpxord zmm27,zmm27,zmm27
vpxord zmm28,zmm28,zmm28
vpxord zmm29,zmm29,zmm29
vpxord zmm30,zmm30,zmm30
vpxord zmm31,zmm31,zmm31
vpxord zmm0,zmm0,zmm0
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm0
mov r8d,32
.Lflock_ab_cantor29_partial_m0_window:
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm24,zmm24,zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 576]
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 512]
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 448]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 320]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 256]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 128]
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 832]
vpxorq zmm22,zmm14,zmm22
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 768]
vpternlogq zmm16,zmm14,zmm13,0x96
vpxorq zmm21,zmm13,zmm21
vpxorq zmm15,zmm13,zmm15
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 704]
vpternlogq zmm20,zmm14,zmm12,0x96
vpternlogq zmm19,zmm13,zmm12,0x96
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 640]
vpternlogq zmm11,zmm14,zmm12,0x96
vpternlogq zmm19,zmm11,zmm20,0x96
vpternlogq zmm22,zmm13,zmm11,0x96
vpternlogq zmm16,zmm12,zmm22,0x96
vpternlogq zmm16,zmm20,zmm19,0x96
vpternlogq zmm15,zmm11,zmm22,0x96
vpternlogq zmm15,zmm21,zmm19,0x96
vpternlogq zmm18,zmm12,zmm11,0x96
vpternlogq zmm18,zmm22,zmm19,0x96
vpternlogq zmm15,zmm18,zmm16,0x96
vpternlogq zmm17,zmm14,zmm11,0x96
vpternlogq zmm17,zmm21,zmm20,0x96
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 64]
vpxorq zmm10,zmm21,zmm10
vpternlogq zmm10,zmm17,zmm15,0x96
vpxorq zmm9,zmm10,zmm23
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm25,zmm25,zmm9
vpxorq zmm9,zmm16,zmm10
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm8,zmm15,zmm23,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,zmm9
vpxorq zmm9,zmm20,zmm16
vpxorq zmm8,zmm19,zmm15
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm18,zmm10,0x96
vpxorq zmm9,zmm9,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm5,zmm17,zmm23,0x96
vpxorq zmm6,zmm5,zmm6
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm29,zmm29,zmm7
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm5,zmm7,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm30,zmm30,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm31,zmm31,zmm9
vpxorq zmm9,zmm18,zmm14
vpxorq zmm8,zmm17,zmm13
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm16,zmm12,0x96
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm6,zmm11,zmm15,0x96
vgf2p8affineqb zmm4,zmm6,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm3,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm3,zmm22,zmm10,0x96
vpxorq zmm5,zmm3,zmm5
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm1,zmm21,zmm23,0x96
vpxorq zmm4,zmm1,zmm4
vpxorq zmm2,zmm4,zmm2
vgf2p8affineqb zmm0,zmm2,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm0,zmm0,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vpxorq zmm2,zmm5,zmm2
vgf2p8affineqb zmm2,zmm2,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm2,zmm2,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm2
vpxorq zmm5,zmm7,zmm5
vpxorq zmm7,zmm20,zmm7
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm4,zmm6,zmm2,0x96
vpxorq zmm5,zmm5,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm4
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm5
vpxorq zmm6,zmm19,zmm6
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm9,zmm3,zmm5,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm5,zmm9,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm3,zmm6,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm1,zmm3,0x96
vpxorq zmm5,zmm8,zmm5
vpxorq zmm9,zmm9,zmm5
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm5
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 1888]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm9,zmm14,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm9,zmm9,zmm18
vpxorq zmm14,zmm9,zmm14
vgf2p8affineqb zmm18,zmm9,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm8,zmm13,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm8,zmm8,zmm17
vpxorq zmm13,zmm8,zmm13
vgf2p8affineqb zmm17,zmm8,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm12,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm5,zmm5,zmm16
vpxorq zmm7,zmm5,zmm7
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm3,zmm11,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm3,zmm3,zmm15
vpxorq zmm6,zmm3,zmm6
vgf2p8affineqb zmm15,zmm6,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm22,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm1,zmm1,zmm10
vpxorq zmm18,zmm1,zmm18
vpxorq zmm16,zmm18,zmm16
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 1392]{1to8},0
vgf2p8affineqb zmm4,zmm21,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm4,zmm4,zmm23
vpxorq zmm17,zmm4,zmm17
vpxorq zmm15,zmm17,zmm15
vpxorq zmm10,zmm15,zmm10
vgf2p8affineqb zmm23,zmm10,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm23
vpxorq zmm10,zmm16,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm10
vpxorq zmm16,zmm7,zmm16
vpxorq zmm7,zmm7,zmm20
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 144]{1to8},0
vpternlogq zmm15,zmm6,zmm10,0x96
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm15
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm16
vpxorq zmm6,zmm6,zmm19
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm9,zmm18,zmm16,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm16,zmm9,QWORD PTR [rcx + 1936]{1to8},0
vgf2p8affineqb zmm18,zmm6,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm8,zmm17,zmm18,0x96
vpxorq zmm16,zmm8,zmm16
vpxorq zmm9,zmm9,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm16
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 624]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm5,zmm12,zmm7,0x96
vpxorq zmm20,zmm20,zmm5
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm7,zmm5,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm12,zmm19,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm3,zmm11,zmm12,0x96
vpxorq zmm19,zmm3,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm12,zmm3,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm11,zmm14,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm1,zmm22,zmm11,0x96
vpternlogq zmm14,zmm1,zmm20,0x96
vpxorq zmm1,zmm1,zmm7
vpxorq zmm5,zmm5,zmm1
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rcx + 2032]{1to8},0
vgf2p8affineqb zmm7,zmm1,QWORD PTR [rcx + 1296]{1to8},0
vgf2p8affineqb zmm20,zmm13,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm4,zmm21,zmm20,0x96
vpxorq zmm12,zmm4,zmm12
vpxorq zmm13,zmm13,zmm4
vpternlogq zmm13,zmm19,zmm14,0x96
vpxorq zmm7,zmm12,zmm7
vpxorq zmm1,zmm1,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm7
vgf2p8affineqb zmm1,zmm1,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm1,zmm1,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm1
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm13
vgf2p8affineqb zmm13,zmm5,QWORD PTR [rcx + 240]{1to8},0
vpternlogq zmm3,zmm12,zmm13,0x96
vpxorq zmm5,zmm5,zmm3
vgf2p8affineqb zmm3,zmm3,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm3,zmm3,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm3
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm5
add rdi,118784
add rsi,232
dec r8d
jne .Lflock_ab_cantor29_partial_m0_window
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm24
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm25
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm26
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm29
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm30
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm31
vzeroupper
ret
.size flock_ab_cantor29_partial_m0,.-flock_ab_cantor29_partial_m0
.p2align 5
.globl flock_ab_cantor29_partial_m1
.type flock_ab_cantor29_partial_m1,@function
flock_ab_cantor29_partial_m1:
vpxord zmm24,zmm24,zmm24
vpxord zmm25,zmm25,zmm25
vpxord zmm26,zmm26,zmm26
vpxord zmm27,zmm27,zmm27
vpxord zmm28,zmm28,zmm28
vpxord zmm29,zmm29,zmm29
vpxord zmm30,zmm30,zmm30
vpxord zmm31,zmm31,zmm31
vpxord zmm0,zmm0,zmm0
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm0
mov r8d,32
.Lflock_ab_cantor29_partial_m1_window:
prefetcht0 [rdi + 1856]
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm24,zmm24,zmm22
prefetcht0 [rdi + 2432]
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 576]
prefetcht0 [rdi + 2368]
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 512]
prefetcht0 [rdi + 2304]
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 448]
prefetcht0 [rdi + 2240]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
prefetcht0 [rdi + 2176]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 320]
prefetcht0 [rdi + 2112]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 256]
prefetcht0 [rdi + 2048]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 192]
prefetcht0 [rdi + 1984]
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 128]
prefetcht0 [rdi + 2688]
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 832]
vpxorq zmm22,zmm14,zmm22
prefetcht0 [rdi + 2624]
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 768]
vpternlogq zmm16,zmm14,zmm13,0x96
vpxorq zmm21,zmm13,zmm21
vpxorq zmm15,zmm13,zmm15
prefetcht0 [rdi + 2560]
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 704]
vpternlogq zmm20,zmm14,zmm12,0x96
vpternlogq zmm19,zmm13,zmm12,0x96
prefetcht0 [rdi + 2496]
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 640]
vpternlogq zmm11,zmm14,zmm12,0x96
vpternlogq zmm19,zmm11,zmm20,0x96
vpternlogq zmm22,zmm13,zmm11,0x96
vpternlogq zmm16,zmm12,zmm22,0x96
vpternlogq zmm16,zmm20,zmm19,0x96
vpternlogq zmm15,zmm11,zmm22,0x96
vpternlogq zmm15,zmm21,zmm19,0x96
vpternlogq zmm18,zmm12,zmm11,0x96
vpternlogq zmm18,zmm22,zmm19,0x96
vpternlogq zmm15,zmm18,zmm16,0x96
vpternlogq zmm17,zmm14,zmm11,0x96
vpternlogq zmm17,zmm21,zmm20,0x96
prefetcht0 [rdi + 1920]
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 64]
vpxorq zmm10,zmm21,zmm10
vpternlogq zmm10,zmm17,zmm15,0x96
vpxorq zmm9,zmm10,zmm23
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm25,zmm25,zmm9
vpxorq zmm9,zmm16,zmm10
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm8,zmm15,zmm23,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,zmm9
vpxorq zmm9,zmm20,zmm16
vpxorq zmm8,zmm19,zmm15
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm18,zmm10,0x96
vpxorq zmm9,zmm9,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm5,zmm17,zmm23,0x96
vpxorq zmm6,zmm5,zmm6
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm29,zmm29,zmm7
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm5,zmm7,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm30,zmm30,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm31,zmm31,zmm9
vpxorq zmm9,zmm18,zmm14
vpxorq zmm8,zmm17,zmm13
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm16,zmm12,0x96
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm6,zmm11,zmm15,0x96
vgf2p8affineqb zmm4,zmm6,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm3,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm3,zmm22,zmm10,0x96
vpxorq zmm5,zmm3,zmm5
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm1,zmm21,zmm23,0x96
vpxorq zmm4,zmm1,zmm4
vpxorq zmm2,zmm4,zmm2
vgf2p8affineqb zmm0,zmm2,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm0,zmm0,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vpxorq zmm2,zmm5,zmm2
vgf2p8affineqb zmm2,zmm2,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm2,zmm2,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm2
vpxorq zmm5,zmm7,zmm5
vpxorq zmm7,zmm20,zmm7
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm4,zmm6,zmm2,0x96
vpxorq zmm5,zmm5,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm4
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm5
vpxorq zmm6,zmm19,zmm6
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm9,zmm3,zmm5,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm5,zmm9,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm3,zmm6,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm1,zmm3,0x96
vpxorq zmm5,zmm8,zmm5
vpxorq zmm9,zmm9,zmm5
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm5
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 1888]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm9,zmm14,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm9,zmm9,zmm18
vpxorq zmm14,zmm9,zmm14
vgf2p8affineqb zmm18,zmm9,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm8,zmm13,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm8,zmm8,zmm17
vpxorq zmm13,zmm8,zmm13
vgf2p8affineqb zmm17,zmm8,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm12,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm5,zmm5,zmm16
vpxorq zmm7,zmm5,zmm7
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm3,zmm11,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm3,zmm3,zmm15
vpxorq zmm6,zmm3,zmm6
vgf2p8affineqb zmm15,zmm6,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm22,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm1,zmm1,zmm10
vpxorq zmm18,zmm1,zmm18
vpxorq zmm16,zmm18,zmm16
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 1392]{1to8},0
vgf2p8affineqb zmm4,zmm21,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm4,zmm4,zmm23
vpxorq zmm17,zmm4,zmm17
vpxorq zmm15,zmm17,zmm15
vpxorq zmm10,zmm15,zmm10
vgf2p8affineqb zmm23,zmm10,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm23
vpxorq zmm10,zmm16,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm10
vpxorq zmm16,zmm7,zmm16
vpxorq zmm7,zmm7,zmm20
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 144]{1to8},0
vpternlogq zmm15,zmm6,zmm10,0x96
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm15
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm16
vpxorq zmm6,zmm6,zmm19
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm9,zmm18,zmm16,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm16,zmm9,QWORD PTR [rcx + 1936]{1to8},0
vgf2p8affineqb zmm18,zmm6,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm8,zmm17,zmm18,0x96
vpxorq zmm16,zmm8,zmm16
vpxorq zmm9,zmm9,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm16
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 624]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm5,zmm12,zmm7,0x96
vpxorq zmm20,zmm20,zmm5
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm7,zmm5,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm12,zmm19,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm3,zmm11,zmm12,0x96
vpxorq zmm19,zmm3,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm12,zmm3,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm11,zmm14,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm1,zmm22,zmm11,0x96
vpternlogq zmm14,zmm1,zmm20,0x96
vpxorq zmm1,zmm1,zmm7
vpxorq zmm5,zmm5,zmm1
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rcx + 2032]{1to8},0
vgf2p8affineqb zmm7,zmm1,QWORD PTR [rcx + 1296]{1to8},0
vgf2p8affineqb zmm20,zmm13,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm4,zmm21,zmm20,0x96
vpxorq zmm12,zmm4,zmm12
vpxorq zmm13,zmm13,zmm4
vpternlogq zmm13,zmm19,zmm14,0x96
vpxorq zmm7,zmm12,zmm7
vpxorq zmm1,zmm1,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm7
vgf2p8affineqb zmm1,zmm1,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm1,zmm1,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm1
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm13
vgf2p8affineqb zmm13,zmm5,QWORD PTR [rcx + 240]{1to8},0
vpternlogq zmm3,zmm12,zmm13,0x96
vpxorq zmm5,zmm5,zmm3
vgf2p8affineqb zmm3,zmm3,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm3,zmm3,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm3
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm5
add rdi,118784
add rsi,232
dec r8d
jne .Lflock_ab_cantor29_partial_m1_window
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm24
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm25
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm26
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm29
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm30
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm31
vzeroupper
ret
.size flock_ab_cantor29_partial_m1,.-flock_ab_cantor29_partial_m1
.p2align 5
.globl flock_ab_cantor29_partial_m2
.type flock_ab_cantor29_partial_m2,@function
flock_ab_cantor29_partial_m2:
vpxord zmm24,zmm24,zmm24
vpxord zmm25,zmm25,zmm25
vpxord zmm26,zmm26,zmm26
vpxord zmm27,zmm27,zmm27
vpxord zmm28,zmm28,zmm28
vpxord zmm29,zmm29,zmm29
vpxord zmm30,zmm30,zmm30
vpxord zmm31,zmm31,zmm31
vpxord zmm0,zmm0,zmm0
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm0
mov r8d,32
.Lflock_ab_cantor29_partial_m2_window:
prefetcht0 [rdi + 1856]
prefetcht0 [rdi + 1920]
prefetcht0 [rdi + 1984]
prefetcht0 [rdi + 2048]
prefetcht0 [rdi + 2112]
prefetcht0 [rdi + 2176]
prefetcht0 [rdi + 2240]
prefetcht0 [rdi + 2304]
prefetcht0 [rdi + 2368]
prefetcht0 [rdi + 2432]
prefetcht0 [rdi + 2496]
prefetcht0 [rdi + 2560]
prefetcht0 [rdi + 2624]
prefetcht0 [rdi + 2688]
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm24,zmm24,zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 576]
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 512]
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 448]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 320]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 256]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 128]
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 832]
vpxorq zmm22,zmm14,zmm22
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 768]
vpternlogq zmm16,zmm14,zmm13,0x96
vpxorq zmm21,zmm13,zmm21
vpxorq zmm15,zmm13,zmm15
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 704]
vpternlogq zmm20,zmm14,zmm12,0x96
vpternlogq zmm19,zmm13,zmm12,0x96
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 640]
vpternlogq zmm11,zmm14,zmm12,0x96
vpternlogq zmm19,zmm11,zmm20,0x96
vpternlogq zmm22,zmm13,zmm11,0x96
vpternlogq zmm16,zmm12,zmm22,0x96
vpternlogq zmm16,zmm20,zmm19,0x96
vpternlogq zmm15,zmm11,zmm22,0x96
vpternlogq zmm15,zmm21,zmm19,0x96
vpternlogq zmm18,zmm12,zmm11,0x96
vpternlogq zmm18,zmm22,zmm19,0x96
vpternlogq zmm15,zmm18,zmm16,0x96
vpternlogq zmm17,zmm14,zmm11,0x96
vpternlogq zmm17,zmm21,zmm20,0x96
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 64]
vpxorq zmm10,zmm21,zmm10
vpternlogq zmm10,zmm17,zmm15,0x96
vpxorq zmm9,zmm10,zmm23
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm25,zmm25,zmm9
vpxorq zmm9,zmm16,zmm10
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm8,zmm15,zmm23,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,zmm9
vpxorq zmm9,zmm20,zmm16
vpxorq zmm8,zmm19,zmm15
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm18,zmm10,0x96
vpxorq zmm9,zmm9,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm5,zmm17,zmm23,0x96
vpxorq zmm6,zmm5,zmm6
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm29,zmm29,zmm7
vgf2p8affineqb zmm7,zmm9,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm5,zmm7,0x96
vpxorq zmm9,zmm9,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm30,zmm30,zmm8
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm31,zmm31,zmm9
vpxorq zmm9,zmm18,zmm14
vpxorq zmm8,zmm17,zmm13
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm7,zmm16,zmm12,0x96
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm6,zmm11,zmm15,0x96
vgf2p8affineqb zmm4,zmm6,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm3,zmm9,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm3,zmm22,zmm10,0x96
vpxorq zmm5,zmm3,zmm5
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm8,QWORD PTR [rcx + 1504]{1to8},0
vpternlogq zmm1,zmm21,zmm23,0x96
vpxorq zmm4,zmm1,zmm4
vpxorq zmm2,zmm4,zmm2
vgf2p8affineqb zmm0,zmm2,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm0,zmm0,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm0
vpxorq zmm2,zmm5,zmm2
vgf2p8affineqb zmm2,zmm2,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm2,zmm2,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm2
vpxorq zmm5,zmm7,zmm5
vpxorq zmm7,zmm20,zmm7
vgf2p8affineqb zmm2,zmm5,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm4,zmm6,zmm2,0x96
vpxorq zmm5,zmm5,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm4
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm5
vpxorq zmm6,zmm19,zmm6
vgf2p8affineqb zmm5,zmm7,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm9,zmm3,zmm5,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm5,zmm9,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm3,zmm6,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm8,zmm1,zmm3,0x96
vpxorq zmm5,zmm8,zmm5
vpxorq zmm9,zmm9,zmm5
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm5
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 1888]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm6,zmm19,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm9,zmm14,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm9,zmm9,zmm18
vpxorq zmm14,zmm9,zmm14
vgf2p8affineqb zmm18,zmm9,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm8,zmm13,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm8,zmm8,zmm17
vpxorq zmm13,zmm8,zmm13
vgf2p8affineqb zmm17,zmm8,QWORD PTR [rcx + 736]{1to8},0
vgf2p8affineqb zmm5,zmm12,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm5,zmm5,zmm16
vpxorq zmm7,zmm5,zmm7
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm3,zmm11,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm3,zmm3,zmm15
vpxorq zmm6,zmm3,zmm6
vgf2p8affineqb zmm15,zmm6,QWORD PTR [rcx + 96]{1to8},0
vgf2p8affineqb zmm1,zmm22,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm1,zmm1,zmm10
vpxorq zmm18,zmm1,zmm18
vpxorq zmm16,zmm18,zmm16
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 1392]{1to8},0
vgf2p8affineqb zmm4,zmm21,QWORD PTR [rcx + 1504]{1to8},0
vpxorq zmm4,zmm4,zmm23
vpxorq zmm17,zmm4,zmm17
vpxorq zmm15,zmm17,zmm15
vpxorq zmm10,zmm15,zmm10
vgf2p8affineqb zmm23,zmm10,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm23
vpxorq zmm10,zmm16,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm10
vpxorq zmm16,zmm7,zmm16
vpxorq zmm7,zmm7,zmm20
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rcx + 144]{1to8},0
vpternlogq zmm15,zmm6,zmm10,0x96
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm15
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm16
vpxorq zmm6,zmm6,zmm19
vgf2p8affineqb zmm16,zmm7,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm9,zmm18,zmm16,0x96
vpxorq zmm7,zmm7,zmm9
vgf2p8affineqb zmm16,zmm9,QWORD PTR [rcx + 1936]{1to8},0
vgf2p8affineqb zmm18,zmm6,QWORD PTR [rcx + 1408]{1to8},0
vpternlogq zmm8,zmm17,zmm18,0x96
vpxorq zmm16,zmm8,zmm16
vpxorq zmm9,zmm9,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm16
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm9
vgf2p8affineqb zmm9,zmm7,QWORD PTR [rcx + 624]{1to8},0
vpternlogq zmm6,zmm8,zmm9,0x96
vpxorq zmm7,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm6
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm7
vgf2p8affineqb zmm7,zmm20,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm5,zmm12,zmm7,0x96
vpxorq zmm20,zmm20,zmm5
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm7,zmm5,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm12,zmm19,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm3,zmm11,zmm12,0x96
vpxorq zmm19,zmm3,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rcx + 1888]{1to8},0
vgf2p8affineqb zmm12,zmm3,QWORD PTR [rcx + 640]{1to8},0
vgf2p8affineqb zmm11,zmm14,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm1,zmm22,zmm11,0x96
vpternlogq zmm14,zmm1,zmm20,0x96
vpxorq zmm1,zmm1,zmm7
vpxorq zmm5,zmm5,zmm1
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rcx + 2032]{1to8},0
vgf2p8affineqb zmm7,zmm1,QWORD PTR [rcx + 1296]{1to8},0
vgf2p8affineqb zmm20,zmm13,QWORD PTR [rcx + 1792]{1to8},0
vpternlogq zmm4,zmm21,zmm20,0x96
vpxorq zmm12,zmm4,zmm12
vpxorq zmm13,zmm13,zmm4
vpternlogq zmm13,zmm19,zmm14,0x96
vpxorq zmm7,zmm12,zmm7
vpxorq zmm1,zmm1,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm7
vgf2p8affineqb zmm1,zmm1,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm1,zmm1,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm1
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm13
vgf2p8affineqb zmm13,zmm5,QWORD PTR [rcx + 240]{1to8},0
vpternlogq zmm3,zmm12,zmm13,0x96
vpxorq zmm5,zmm5,zmm3
vgf2p8affineqb zmm3,zmm3,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm3,zmm3,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm3
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm5
add rdi,118784
add rsi,232
dec r8d
jne .Lflock_ab_cantor29_partial_m2_window
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm24
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm25
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm26
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm29
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm30
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm31
vzeroupper
ret
.size flock_ab_cantor29_partial_m2,.-flock_ab_cantor29_partial_m2
.p2align 5
.globl flock_ab_cantor29_partial_finalize
.type flock_ab_cantor29_partial_finalize,@function
flock_ab_cantor29_partial_finalize:
vmovdqu64 zmm16,ZMMWORD PTR [rdi]
vgf2p8affineqb zmm0,zmm16,QWORD PTR [rsi + 0]{1to8},0
vgf2p8affineqb zmm1,zmm16,QWORD PTR [rsi + 8]{1to8},0
vgf2p8affineqb zmm2,zmm16,QWORD PTR [rsi + 16]{1to8},0
vgf2p8affineqb zmm3,zmm16,QWORD PTR [rsi + 24]{1to8},0
vgf2p8affineqb zmm4,zmm16,QWORD PTR [rsi + 32]{1to8},0
vgf2p8affineqb zmm5,zmm16,QWORD PTR [rsi + 40]{1to8},0
vgf2p8affineqb zmm6,zmm16,QWORD PTR [rsi + 48]{1to8},0
vgf2p8affineqb zmm7,zmm16,QWORD PTR [rsi + 56]{1to8},0
vgf2p8affineqb zmm8,zmm16,QWORD PTR [rsi + 64]{1to8},0
vgf2p8affineqb zmm9,zmm16,QWORD PTR [rsi + 72]{1to8},0
vgf2p8affineqb zmm10,zmm16,QWORD PTR [rsi + 80]{1to8},0
vgf2p8affineqb zmm11,zmm16,QWORD PTR [rsi + 88]{1to8},0
vgf2p8affineqb zmm12,zmm16,QWORD PTR [rsi + 96]{1to8},0
vgf2p8affineqb zmm13,zmm16,QWORD PTR [rsi + 104]{1to8},0
vgf2p8affineqb zmm14,zmm16,QWORD PTR [rsi + 112]{1to8},0
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 120]{1to8},0
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 64]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 128]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 256]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 136]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 264]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 144]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 272]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 152]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 280]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 160]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 288]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 168]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 296]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 176]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 304]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 184]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 312]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 192]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 320]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 200]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 328]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 208]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 336]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 216]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 344]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 224]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 352]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 232]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 360]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 240]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 368]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 248]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 376]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 384]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 512]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 392]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 520]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 400]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 528]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 408]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 536]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 416]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 544]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 424]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 552]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 432]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 560]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 440]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 568]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 448]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 576]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 456]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 584]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 464]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 592]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 472]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 600]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 480]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 608]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 488]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 616]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 496]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 624]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 504]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 632]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 320]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 640]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 768]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 648]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 776]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 656]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 784]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 664]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 792]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 672]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 800]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 680]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 808]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 688]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 816]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 696]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 824]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 704]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 832]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 712]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 840]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 720]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 848]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 728]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 856]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 736]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 864]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 744]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 872]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 752]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 880]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 760]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 888]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 448]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 512]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 896]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1024]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 904]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1032]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 912]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1040]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 920]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1048]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 928]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1056]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 936]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1064]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 944]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1072]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 952]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1080]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 960]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1088]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 968]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1096]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 976]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1104]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 984]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1112]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 992]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1120]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1000]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1128]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1008]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1136]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1016]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1144]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 576]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 640]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1152]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1280]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1160]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1288]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1168]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1296]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1176]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1304]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1184]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1312]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1192]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1320]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1200]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1328]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1208]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1336]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1216]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1344]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1224]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1352]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1232]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1360]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1240]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1368]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1248]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1376]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1256]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1384]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1264]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1392]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1272]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1400]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 704]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 768]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1408]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1536]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1416]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1544]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1424]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1552]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1432]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1560]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1440]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1568]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1448]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1576]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1456]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1584]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1464]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1592]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1472]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1600]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1480]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1608]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1488]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1616]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1496]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1624]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1504]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1632]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1512]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1640]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1520]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1648]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1528]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1656]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 832]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 896]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1664]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1792]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1672]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1800]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1680]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1808]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1688]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1816]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1696]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1824]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1704]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1832]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1712]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1840]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1720]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1848]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1728]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1856]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1736]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1864]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1744]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1872]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1752]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1880]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1760]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1888]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1768]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1896]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1776]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1904]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1784]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 1912]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 960]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1024]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1920]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2048]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1928]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2056]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1936]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2064]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1944]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2072]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1952]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2080]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1960]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2088]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1968]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2096]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1976]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2104]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1984]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2112]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 1992]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2120]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2000]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2128]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2008]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2136]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2016]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2144]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2024]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2152]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2032]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2160]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2040]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2168]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1088]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1152]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2176]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2304]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2184]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2312]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2192]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2320]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2200]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2328]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2208]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2336]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2216]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2344]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2224]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2352]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2232]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2360]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2240]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2368]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2248]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2376]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2256]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2384]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2264]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2392]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2272]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2400]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2280]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2408]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2288]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2416]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2296]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2424]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1216]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1280]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2432]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2560]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2440]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2568]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2448]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2576]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2456]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2584]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2464]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2592]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2472]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2600]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2480]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2608]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2488]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2616]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2496]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2624]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2504]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2632]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2512]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2640]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2520]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2648]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2528]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2656]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2536]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2664]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2544]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2672]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2552]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2680]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1344]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1408]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2688]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2816]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2696]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2824]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2704]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2832]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2712]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2840]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2720]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2848]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2728]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2856]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2736]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2864]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2744]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2872]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2752]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2880]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2760]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2888]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2768]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2896]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2776]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2904]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2784]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2912]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2792]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2920]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2800]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2928]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2808]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 2936]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1472]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1536]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2944]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3072]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2952]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3080]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2960]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3088]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2968]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3096]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2976]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3104]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2984]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3112]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 2992]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3120]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3000]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3128]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3008]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3136]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3016]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3144]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3024]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3152]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3032]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3160]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3040]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3168]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3048]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3176]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3056]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3184]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3064]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3192]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1600]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1664]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3200]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3328]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3208]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3336]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3216]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3344]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3224]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3352]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3232]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3360]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3240]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3368]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3248]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3376]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3256]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3384]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3264]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3392]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3272]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3400]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3280]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3408]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3288]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3416]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3296]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3424]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3304]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3432]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3312]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3440]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3320]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3448]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1728]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1792]
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3456]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3584]{1to8},0
vpternlogq zmm0,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3464]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3592]{1to8},0
vpternlogq zmm1,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3472]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3600]{1to8},0
vpternlogq zmm2,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3480]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3608]{1to8},0
vpternlogq zmm3,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3488]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3616]{1to8},0
vpternlogq zmm4,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3496]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3624]{1to8},0
vpternlogq zmm5,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3504]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3632]{1to8},0
vpternlogq zmm6,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3512]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3640]{1to8},0
vpternlogq zmm7,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3520]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3648]{1to8},0
vpternlogq zmm8,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3528]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3656]{1to8},0
vpternlogq zmm9,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3536]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3664]{1to8},0
vpternlogq zmm10,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3544]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3672]{1to8},0
vpternlogq zmm11,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3552]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3680]{1to8},0
vpternlogq zmm12,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3560]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3688]{1to8},0
vpternlogq zmm13,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3568]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3696]{1to8},0
vpternlogq zmm14,zmm18,zmm19,0x96
vgf2p8affineqb zmm18,zmm16,QWORD PTR [rsi + 3576]{1to8},0
vgf2p8affineqb zmm19,zmm17,QWORD PTR [rsi + 3704]{1to8},0
vpternlogq zmm15,zmm18,zmm19,0x96
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm0
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm1
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm2
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm3
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm4
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm5
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm6
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm7
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm8
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm9
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm10
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm11
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm12
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm13
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm14
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm15
vzeroupper
ret
.size flock_ab_cantor29_partial_finalize,.-flock_ab_cantor29_partial_finalize
