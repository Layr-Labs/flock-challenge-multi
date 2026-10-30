.text
.p2align 5
.globl flock_ab_poly0_m0
.type flock_ab_poly0_m0,@function
flock_ab_poly0_m0:
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm25
vpxorq zmm25,zmm31,zmm28
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm24
vpxorq zmm24,zmm30,zmm27
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm23
vpxorq zmm23,zmm29,zmm26
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm20
vpxorq zmm20,zmm22,zmm21
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm18
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm16
vpxorq zmm16,zmm22,zmm19
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm15
vpxorq zmm15,zmm21,zmm18
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm14
vpxorq zmm14,zmm20,zmm17
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm13
vpxorq zmm13,zmm31,zmm22
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm12
vpxorq zmm12,zmm30,zmm21
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm11
vpxorq zmm11,zmm29,zmm20
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm10
vpxorq zmm10,zmm28,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm18
vpxorq zmm18,zmm26,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm17
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm17
vpxorq zmm17,zmm25,zmm16
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm17
vpxorq zmm17,zmm24,zmm15
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm23,zmm14
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm17
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 512]
vpxorq zmm31,zmm31,zmm17
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm31
vgf2p8affineqb zmm31,zmm17,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm31
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 576]
vpxorq zmm30,zmm30,zmm31
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm30
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm30
vpxorq zmm30,zmm17,zmm31
vpxorq zmm29,zmm29,zmm30
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm29
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm29
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm29
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm28
vpxorq zmm10,zmm29,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm10
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm10
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm27
vpxorq zmm19,zmm10,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm19
vpxorq zmm19,zmm29,zmm10
vpxorq zmm26,zmm26,zmm19
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm26
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm18
vpxorq zmm18,zmm17,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm29
vpxorq zmm25,zmm25,zmm18
vgf2p8affineqb zmm29,zmm18,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm29
vpxorq zmm29,zmm31,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm10
vpxorq zmm24,zmm24,zmm29
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm10
vpxorq zmm10,zmm30,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm19
vpxorq zmm23,zmm23,zmm10
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 768]
vpxorq zmm17,zmm17,zmm19
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm18
vpxorq zmm22,zmm22,zmm19
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm22
vpxorq zmm16,zmm19,zmm16
vpxorq zmm13,zmm13,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm17
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm13
vgf2p8affineqb zmm13,zmm19,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm13
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 832]
vpxorq zmm31,zmm31,zmm13
vpxorq zmm29,zmm13,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm29
vpxorq zmm21,zmm21,zmm13
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm21
vpxorq zmm15,zmm13,zmm15
vpxorq zmm12,zmm12,zmm31
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm31
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm12
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm12
vpxorq zmm12,zmm19,zmm13
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm19
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm13
vpxorq zmm30,zmm30,zmm12
vpxorq zmm10,zmm12,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm10
vpxorq zmm20,zmm20,zmm12
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm20
vpxorq zmm14,zmm12,zmm14
vpxorq zmm11,zmm11,zmm30
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm30
vgf2p8affineqb zmm11,zmm11,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm11
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm11
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm12
vgf2p8affineqb zmm12,zmm25,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm12
vpxorq zmm25,zmm16,zmm25
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm16
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm25
vgf2p8affineqb zmm25,zmm24,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm25
vpxorq zmm24,zmm15,zmm24
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm15
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm24
vgf2p8affineqb zmm24,zmm23,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm24
vpxorq zmm23,zmm14,zmm23
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm14
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm23
vzeroupper
ret
.size flock_ab_poly0_m0,.-flock_ab_poly0_m0
.p2align 5
.globl flock_ab_poly0_m1
.type flock_ab_poly0_m1,@function
flock_ab_poly0_m1:
prefetcht0 [rdi + 1856]
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
prefetcht0 [rdi + 1920]
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
prefetcht0 [rdi + 1984]
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
prefetcht0 [rdi + 2048]
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm25
vpxorq zmm25,zmm31,zmm28
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm24
vpxorq zmm24,zmm30,zmm27
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm23
vpxorq zmm23,zmm29,zmm26
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm22
prefetcht0 [rdi + 2112]
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm21
prefetcht0 [rdi + 2176]
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm20
vpxorq zmm20,zmm22,zmm21
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm19
prefetcht0 [rdi + 2240]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm18
prefetcht0 [rdi + 2304]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm16
vpxorq zmm16,zmm22,zmm19
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm15
vpxorq zmm15,zmm21,zmm18
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm14
vpxorq zmm14,zmm20,zmm17
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm13
vpxorq zmm13,zmm31,zmm22
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm12
vpxorq zmm12,zmm30,zmm21
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm11
vpxorq zmm11,zmm29,zmm20
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm10
vpxorq zmm10,zmm28,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm18
vpxorq zmm18,zmm26,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm17
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm17
vpxorq zmm17,zmm25,zmm16
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm17
vpxorq zmm17,zmm24,zmm15
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm23,zmm14
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm17
prefetcht0 [rdi + 2368]
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 512]
vpxorq zmm31,zmm31,zmm17
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm31
vgf2p8affineqb zmm31,zmm17,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm31
prefetcht0 [rdi + 2432]
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 576]
vpxorq zmm30,zmm30,zmm31
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm30
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm30
vpxorq zmm30,zmm17,zmm31
vpxorq zmm29,zmm29,zmm30
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm29
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm29
prefetcht0 [rdi + 2496]
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm29
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm28
vpxorq zmm10,zmm29,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm10
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm10
prefetcht0 [rdi + 2560]
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm10
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm27
vpxorq zmm19,zmm10,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm19
vpxorq zmm19,zmm29,zmm10
vpxorq zmm26,zmm26,zmm19
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm26
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm18
vpxorq zmm18,zmm17,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm29
vpxorq zmm25,zmm25,zmm18
vgf2p8affineqb zmm29,zmm18,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm29
vpxorq zmm29,zmm31,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm10
vpxorq zmm24,zmm24,zmm29
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm10
vpxorq zmm10,zmm30,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm19
vpxorq zmm23,zmm23,zmm10
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm19
prefetcht0 [rdi + 2624]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 768]
vpxorq zmm17,zmm17,zmm19
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm18
vpxorq zmm22,zmm22,zmm19
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm22
vpxorq zmm16,zmm19,zmm16
vpxorq zmm13,zmm13,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm17
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm13
vgf2p8affineqb zmm13,zmm19,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm13
prefetcht0 [rdi + 2688]
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 832]
vpxorq zmm31,zmm31,zmm13
vpxorq zmm29,zmm13,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm29
vpxorq zmm21,zmm21,zmm13
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm21
vpxorq zmm15,zmm13,zmm15
vpxorq zmm12,zmm12,zmm31
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm31
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm12
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm12
vpxorq zmm12,zmm19,zmm13
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm19
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm13
vpxorq zmm30,zmm30,zmm12
vpxorq zmm10,zmm12,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm10
vpxorq zmm20,zmm20,zmm12
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm20
vpxorq zmm14,zmm12,zmm14
vpxorq zmm11,zmm11,zmm30
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm30
vgf2p8affineqb zmm11,zmm11,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm11
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm11
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm12
vgf2p8affineqb zmm12,zmm25,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm12
vpxorq zmm25,zmm16,zmm25
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm16
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm25
vgf2p8affineqb zmm25,zmm24,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm25
vpxorq zmm24,zmm15,zmm24
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm15
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm24
vgf2p8affineqb zmm24,zmm23,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm24
vpxorq zmm23,zmm14,zmm23
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm14
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm23
vzeroupper
ret
.size flock_ab_poly0_m1,.-flock_ab_poly0_m1
.p2align 5
.globl flock_ab_poly0_m2
.type flock_ab_poly0_m2,@function
flock_ab_poly0_m2:
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
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm27
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm25
vpxorq zmm25,zmm31,zmm28
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm24
vpxorq zmm24,zmm30,zmm27
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm23
vpxorq zmm23,zmm29,zmm26
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm20
vpxorq zmm20,zmm22,zmm21
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm18
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm16
vpxorq zmm16,zmm22,zmm19
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm15
vpxorq zmm15,zmm21,zmm18
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm14
vpxorq zmm14,zmm20,zmm17
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm13
vpxorq zmm13,zmm31,zmm22
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm12
vpxorq zmm12,zmm30,zmm21
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm11
vpxorq zmm11,zmm29,zmm20
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm10
vpxorq zmm10,zmm28,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm18
vpxorq zmm18,zmm26,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm17
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm17
vpxorq zmm17,zmm25,zmm16
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm17
vpxorq zmm17,zmm24,zmm15
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm23,zmm14
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm17
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 512]
vpxorq zmm31,zmm31,zmm17
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm31
vgf2p8affineqb zmm31,zmm17,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm31
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 576]
vpxorq zmm30,zmm30,zmm31
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm30
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm30
vpxorq zmm30,zmm17,zmm31
vpxorq zmm29,zmm29,zmm30
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm29
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm29
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm29
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm28
vpxorq zmm10,zmm29,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm10
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm10
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm27
vpxorq zmm19,zmm10,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm19
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm19
vpxorq zmm19,zmm29,zmm10
vpxorq zmm26,zmm26,zmm19
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm26
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm18
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm18
vpxorq zmm18,zmm17,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm29
vpxorq zmm25,zmm25,zmm18
vgf2p8affineqb zmm29,zmm18,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm29
vpxorq zmm29,zmm31,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm10
vpxorq zmm24,zmm24,zmm29
vgf2p8affineqb zmm10,zmm29,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm10
vpxorq zmm10,zmm30,zmm19
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm19
vpxorq zmm23,zmm23,zmm10
vgf2p8affineqb zmm19,zmm10,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 768]
vpxorq zmm17,zmm17,zmm19
vpxorq zmm18,zmm19,zmm18
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm18
vpxorq zmm22,zmm22,zmm19
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm22
vpxorq zmm16,zmm19,zmm16
vpxorq zmm13,zmm13,zmm17
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm17
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm13
vgf2p8affineqb zmm13,zmm19,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm13
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 832]
vpxorq zmm31,zmm31,zmm13
vpxorq zmm29,zmm13,zmm29
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm29
vpxorq zmm21,zmm21,zmm13
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm21
vpxorq zmm15,zmm13,zmm15
vpxorq zmm12,zmm12,zmm31
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm31
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm12
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm12
vpxorq zmm12,zmm19,zmm13
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm19
vgf2p8affineqb zmm13,zmm13,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm13
vpxorq zmm30,zmm30,zmm12
vpxorq zmm10,zmm12,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm10
vpxorq zmm20,zmm20,zmm12
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm20
vpxorq zmm14,zmm12,zmm14
vpxorq zmm11,zmm11,zmm30
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm30
vgf2p8affineqb zmm11,zmm11,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm11
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm11
vgf2p8affineqb zmm12,zmm12,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm12
vgf2p8affineqb zmm12,zmm25,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm12
vpxorq zmm25,zmm16,zmm25
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm16
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm25
vgf2p8affineqb zmm25,zmm24,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm25
vpxorq zmm24,zmm15,zmm24
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm15
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm24
vgf2p8affineqb zmm24,zmm23,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm24
vpxorq zmm23,zmm14,zmm23
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm14
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm23
vzeroupper
ret
.size flock_ab_poly0_m2,.-flock_ab_poly0_m2
.p2align 5
.globl flock_ab_poly_interpolate0
.type flock_ab_poly_interpolate0,@function
flock_ab_poly_interpolate0:
push rbp
mov rbp,rsp
and rsp,-64
sub rsp,768
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm31
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 128]
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 64]
vpxorq zmm31,zmm31,zmm29
vpxorq zmm28,zmm30,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 384]
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vpxorq zmm26,zmm27,zmm28
vpxorq zmm26,zmm26,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm26
vmovdqu64 zmm26,ZMMWORD PTR [rdi + 512]
vpxorq zmm25,zmm28,zmm26
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 448]
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 320]
vpxorq zmm30,zmm30,zmm23
vpxorq zmm25,zmm25,zmm30
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 256]
vpxorq zmm27,zmm27,zmm22
vpxorq zmm31,zmm31,zmm27
vpxorq zmm21,zmm24,zmm31
vpxorq zmm25,zmm25,zmm21
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm25
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 576]
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 1152]
vpxorq zmm19,zmm25,zmm20
vpxorq zmm19,zmm19,zmm21
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 1280]
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 1216]
vpxorq zmm18,zmm20,zmm21
vpxorq zmm19,zmm19,zmm18
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 704]
vpxorq zmm16,zmm17,zmm30
vpxorq zmm16,zmm16,zmm19
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 640]
vpxorq zmm25,zmm25,zmm15
vpxorq zmm14,zmm25,zmm31
vpxorq zmm16,zmm16,zmm14
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm16
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1536]
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 1344]
vpxorq zmm18,zmm13,zmm18
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 960]
vpxorq zmm28,zmm28,zmm12
vpxorq zmm16,zmm16,zmm28
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 768]
vpxorq zmm10,zmm11,zmm16
vpxorq zmm10,zmm10,zmm18
vpxorq zmm10,zmm10,zmm14
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 1664]
vpxorq zmm10,zmm10,zmm19
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 1600]
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 1472]
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 1408]
vpxorq zmm13,zmm13,zmm8
vpxorq zmm9,zmm9,zmm13
vpxorq zmm21,zmm21,zmm13
vpxorq zmm22,zmm22,zmm8
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 1088]
vpxorq zmm26,zmm26,zmm13
vmovdqu64 zmm7,ZMMWORD PTR [rdi + 1024]
vpxorq zmm24,zmm24,zmm7
vpxorq zmm14,zmm14,zmm24
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 896]
vpxorq zmm17,zmm17,zmm6
vpxorq zmm30,zmm30,zmm17
vmovdqu64 zmm5,ZMMWORD PTR [rdi + 832]
vpxorq zmm11,zmm11,zmm5
vpxorq zmm25,zmm25,zmm11
vpxorq zmm31,zmm31,zmm25
vpxorq zmm27,zmm27,zmm25
vpxorq zmm6,zmm6,zmm11
vpxorq zmm4,zmm31,zmm30
vpxorq zmm4,zmm4,zmm9
vpxorq zmm4,zmm4,zmm16
vpxorq zmm4,zmm4,zmm14
vpxorq zmm4,zmm4,zmm26
vpxorq zmm4,zmm4,zmm10
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm4
vmovdqu64 zmm4,ZMMWORD PTR [rdi + 3264]
vpxorq zmm4,zmm4,zmm31
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 1728]
vpxorq zmm3,zmm31,zmm4
vpxorq zmm3,zmm3,zmm14
vpxorq zmm3,zmm3,zmm21
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm3
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 3392]
vpxorq zmm3,zmm3,zmm30
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 3328]
vmovdqu64 zmm2,ZMMWORD PTR [rdi + 1856]
vpxorq zmm1,zmm2,zmm30
vmovdqu64 zmm0,ZMMWORD PTR [rdi + 1792]
vpxorq zmm31,zmm31,zmm0
vpxorq zmm1,zmm1,zmm31
vpxorq zmm1,zmm1,zmm4
vpxorq zmm1,zmm1,zmm9
vpxorq zmm1,zmm1,zmm3
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm1
vmovdqu64 zmm1,ZMMWORD PTR [rdi + 3648]
vmovdqa64 ZMMWORD PTR [rsp + 0],zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 3456]
vpxorq zmm30,zmm30,zmm22
vpxorq zmm23,zmm23,zmm22
vpxorq zmm4,zmm4,zmm30
vpxorq zmm29,zmm29,zmm30
vpxorq zmm1,zmm1,zmm4
vpxorq zmm26,zmm1,zmm26
vpxorq zmm19,zmm4,zmm19
vpxorq zmm19,zmm19,zmm3
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 2112]
vpxorq zmm28,zmm30,zmm28
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 1920]
vpxorq zmm8,zmm8,zmm22
vpxorq zmm8,zmm8,zmm31
vpxorq zmm8,zmm8,zmm1
vpxorq zmm8,zmm8,zmm28
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm8
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 3776]
vpxorq zmm8,zmm8,zmm3
vpxorq zmm8,zmm8,zmm26
vmovdqu64 zmm26,ZMMWORD PTR [rdi + 3712]
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 3584]
vmovdqa64 ZMMWORD PTR [rsp + 64],zmm27
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 3520]
vmovdqa64 ZMMWORD PTR [rsp + 128],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 2240]
vmovdqa64 ZMMWORD PTR [rsp + 192],zmm29
vpxorq zmm29,zmm21,zmm27
vpxorq zmm29,zmm29,zmm3
vmovdqa64 ZMMWORD PTR [rsp + 256],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 2176]
vmovdqa64 ZMMWORD PTR [rsp + 320],zmm5
vpxorq zmm5,zmm21,zmm26
vmovdqa64 ZMMWORD PTR [rsp + 384],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 2048]
vpxorq zmm2,zmm2,zmm21
vpxorq zmm29,zmm29,zmm2
vpxorq zmm29,zmm29,zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 1984]
vpxorq zmm22,zmm22,zmm28
vpxorq zmm31,zmm31,zmm22
vpxorq zmm24,zmm31,zmm24
vpxorq zmm5,zmm5,zmm24
vpxorq zmm29,zmm29,zmm5
vpxorq zmm29,zmm29,zmm8
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm29
vpxorq zmm0,zmm0,zmm22
vpxorq zmm21,zmm21,zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 4416]
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 3840]
vpxorq zmm27,zmm27,zmm29
vpxorq zmm13,zmm13,zmm29
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 2688]
vpxorq zmm15,zmm15,zmm29
vpxorq zmm15,zmm15,zmm11
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 2304]
vpxorq zmm20,zmm20,zmm11
vpxorq zmm20,zmm20,zmm29
vpxorq zmm20,zmm20,zmm22
vpxorq zmm20,zmm20,zmm27
vpxorq zmm20,zmm20,zmm4
vpxorq zmm20,zmm20,zmm5
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm20
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 4544]
vmovdqu64 zmm5,ZMMWORD PTR [rdi + 4480]
vmovdqu64 zmm4,ZMMWORD PTR [rdi + 3968]
vpxorq zmm3,zmm3,zmm4
vpxorq zmm13,zmm13,zmm4
vmovdqu64 zmm4,ZMMWORD PTR [rdi + 3904]
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 2816]
vmovdqa64 ZMMWORD PTR [rsp + 448],zmm8
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 2752]
vpxorq zmm29,zmm29,zmm8
vmovdqa64 ZMMWORD PTR [rsp + 512],zmm13
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 2432]
vpxorq zmm2,zmm13,zmm2
vpxorq zmm24,zmm24,zmm2
vpxorq zmm17,zmm17,zmm2
vpxorq zmm24,zmm29,zmm24
vpxorq zmm20,zmm20,zmm24
vmovdqu64 zmm2,ZMMWORD PTR [rdi + 2368]
vpxorq zmm11,zmm11,zmm2
vpxorq zmm31,zmm11,zmm31
vpxorq zmm4,zmm4,zmm31
vpxorq zmm27,zmm4,zmm27
vpxorq zmm5,zmm5,zmm27
vpxorq zmm22,zmm22,zmm5
vpxorq zmm23,zmm23,zmm27
vpxorq zmm6,zmm6,zmm31
vpxorq zmm0,zmm0,zmm11
vpxorq zmm13,zmm13,zmm11
vmovdqa64 ZMMWORD PTR [rsp + 576],zmm2
vpxorq zmm2,zmm3,zmm22
vpxorq zmm20,zmm20,zmm2
vpxorq zmm19,zmm19,zmm20
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 4800]
vmovdqu64 zmm2,ZMMWORD PTR [rdi + 4608]
vmovdqa64 ZMMWORD PTR [rsp + 640],zmm0
vmovdqu64 zmm0,ZMMWORD PTR [rdi + 4224]
vpxorq zmm19,zmm0,zmm19
vpxorq zmm12,zmm12,zmm0
vmovdqu64 zmm0,ZMMWORD PTR [rdi + 4032]
vmovdqa64 ZMMWORD PTR [rsp + 704],zmm20
vpxorq zmm20,zmm0,zmm2
vpxorq zmm20,zmm20,zmm1
vpxorq zmm20,zmm20,zmm22
vpxorq zmm20,zmm20,zmm18
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 3072]
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 2880]
vpxorq zmm29,zmm22,zmm29
vpxorq zmm20,zmm20,zmm29
vmovdqu64 zmm1,ZMMWORD PTR [rdi + 2496]
vpxorq zmm30,zmm30,zmm1
vpxorq zmm18,zmm18,zmm30
vpxorq zmm25,zmm25,zmm30
vpxorq zmm12,zmm12,zmm25
vpxorq zmm16,zmm16,zmm18
vpxorq zmm19,zmm19,zmm16
vpxorq zmm31,zmm31,zmm18
vpxorq zmm20,zmm20,zmm19
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm20
vpxorq zmm28,zmm28,zmm1
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 4928]
vpxorq zmm20,zmm20,zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 4864]
vpxorq zmm10,zmm10,zmm14
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 4736]
vpxorq zmm14,zmm14,zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 4672]
vpxorq zmm2,zmm2,zmm9
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 4352]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 4288]
vpxorq zmm26,zmm26,zmm16
vpxorq zmm7,zmm7,zmm16
vpxorq zmm26,zmm2,zmm26
vpxorq zmm10,zmm10,zmm26
vmovdqu64 zmm26,ZMMWORD PTR [rdi + 4160]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 4096]
vpxorq zmm0,zmm0,zmm16
vmovdqa64 zmm25,ZMMWORD PTR [rsp + 320]
vpxorq zmm25,zmm25,zmm16
vpxorq zmm25,zmm25,zmm29
vpxorq zmm26,zmm26,zmm0
vpxorq zmm18,zmm18,zmm26
vpxorq zmm20,zmm20,zmm18
vpxorq zmm20,zmm20,zmm14
vmovdqa64 zmm29,ZMMWORD PTR [rsp + 192]
vpxorq zmm29,zmm29,zmm0
vpxorq zmm29,zmm29,zmm5
vmovdqa64 zmm5,ZMMWORD PTR [rsp + 128]
vpxorq zmm29,zmm29,zmm5
vmovdqa64 zmm5,ZMMWORD PTR [rsp + 64]
vpxorq zmm29,zmm29,zmm5
vpxorq zmm15,zmm15,zmm0
vpxorq zmm6,zmm6,zmm26
vpxorq zmm6,zmm6,zmm24
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm6
vpxorq zmm25,zmm25,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm25
vpxorq zmm24,zmm24,zmm31
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 3200]
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 3136]
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 3008]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 2944]
vpxorq zmm22,zmm22,zmm16
vpxorq zmm6,zmm6,zmm22
vpxorq zmm8,zmm8,zmm22
vpxorq zmm31,zmm31,zmm6
vpxorq zmm23,zmm23,zmm6
vpxorq zmm23,zmm23,zmm26
vpxorq zmm23,zmm23,zmm3
vpxorq zmm23,zmm23,zmm2
vpxorq zmm23,zmm23,zmm14
vpxorq zmm23,zmm23,zmm5
vpxorq zmm21,zmm21,zmm6
vpxorq zmm23,zmm23,zmm17
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm23
vmovdqa64 zmm23,ZMMWORD PTR [rsp + 0]
vpxorq zmm23,zmm23,zmm16
vpxorq zmm23,zmm23,zmm9
vpxorq zmm23,zmm23,zmm0
vpxorq zmm23,zmm23,zmm27
vpxorq zmm28,zmm28,zmm16
vpxorq zmm28,zmm28,zmm11
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm28
vpxorq zmm23,zmm23,zmm12
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm23
vpxorq zmm21,zmm21,zmm13
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 2624]
vmovdqa64 zmm23,ZMMWORD PTR [rsp + 256]
vpxorq zmm23,zmm23,zmm21
vmovdqa64 zmm28,ZMMWORD PTR [rsp + 512]
vpxorq zmm28,zmm28,zmm23
vpxorq zmm28,zmm28,zmm18
vpxorq zmm28,zmm28,zmm17
vpxorq zmm28,zmm28,zmm12
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 2560]
vmovdqa64 zmm17,ZMMWORD PTR [rsp + 384]
vpxorq zmm17,zmm17,zmm12
vpxorq zmm25,zmm25,zmm17
vpxorq zmm4,zmm4,zmm17
vpxorq zmm7,zmm7,zmm4
vpxorq zmm23,zmm25,zmm23
vpxorq zmm31,zmm31,zmm23
vpxorq zmm25,zmm25,zmm8
vpxorq zmm20,zmm20,zmm31
vmovdqa64 zmm8,ZMMWORD PTR [rsp + 448]
vpxorq zmm20,zmm20,zmm8
vpxorq zmm20,zmm20,zmm19
vmovdqa64 zmm19,ZMMWORD PTR [rsp + 704]
vpxorq zmm20,zmm20,zmm19
vpxorq zmm24,zmm24,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm24
vpxorq zmm20,zmm20,zmm10
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm20
vpxorq zmm29,zmm29,zmm25
vpxorq zmm29,zmm29,zmm10
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm29
vmovdqa64 zmm29,ZMMWORD PTR [rsp + 640]
vpxorq zmm29,zmm29,zmm25
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm29
vpxorq zmm28,zmm28,zmm7
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm28
vpxorq zmm15,zmm15,zmm7
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm15
vpxorq zmm1,zmm1,zmm12
vpxorq zmm1,zmm1,zmm21
vpxorq zmm1,zmm1,zmm13
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm1
vmovdqa64 zmm1,ZMMWORD PTR [rsp + 576]
vpxorq zmm1,zmm1,zmm12
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm1
mov rsp,rbp
pop rbp
vzeroupper
ret
.size flock_ab_poly_interpolate0,.-flock_ab_poly_interpolate0
.p2align 5
.globl flock_ab_poly2_m0
.type flock_ab_poly2_m0,@function
flock_ab_poly2_m0:
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
vgf2p8affineqb zmm28,zmm31,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm28
vgf2p8affineqb zmm28,zmm30,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm27
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm25
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm24
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm23
vpxorq zmm23,zmm25,zmm24
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm22
vpxorq zmm22,zmm28,zmm25
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm22
vpxorq zmm22,zmm27,zmm24
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm22
vpxorq zmm22,zmm26,zmm23
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm22
vgf2p8affineqb zmm22,zmm28,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm22
vgf2p8affineqb zmm22,zmm27,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm22
vgf2p8affineqb zmm22,zmm26,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm22
vpxorq zmm22,zmm31,zmm25
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm21
vpxorq zmm21,zmm30,zmm24
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm20
vpxorq zmm20,zmm29,zmm23
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm19
vpxorq zmm19,zmm28,zmm22
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm21
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm19
vpxorq zmm19,zmm26,zmm20
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm18
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm16
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 512]
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm15
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 576]
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm14
vpxorq zmm14,zmm16,zmm15
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm13
vpxorq zmm13,zmm19,zmm16
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm12
vpxorq zmm12,zmm18,zmm15
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm11
vpxorq zmm11,zmm17,zmm14
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm10
vgf2p8affineqb zmm9,zmm10,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm9
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm8
vpxorq zmm8,zmm10,zmm9
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm7,zmm8,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm7
vmovdqu64 zmm7,ZMMWORD PTR [rdi + 768]
vpxorq zmm25,zmm25,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm6
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 832]
vpxorq zmm24,zmm24,zmm6
vgf2p8affineqb zmm5,zmm6,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm5
vpxorq zmm5,zmm7,zmm6
vpxorq zmm23,zmm23,zmm5
vgf2p8affineqb zmm4,zmm5,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm4
vpxorq zmm4,zmm10,zmm7
vpxorq zmm10,zmm19,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm10
vgf2p8affineqb zmm10,zmm4,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm10
vpxorq zmm4,zmm13,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm4
vpxorq zmm4,zmm9,zmm6
vpxorq zmm9,zmm18,zmm9
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm9
vgf2p8affineqb zmm9,zmm4,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm9
vpxorq zmm4,zmm12,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm4
vpxorq zmm4,zmm8,zmm5
vpxorq zmm8,zmm17,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm8
vgf2p8affineqb zmm8,zmm4,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm8
vpxorq zmm4,zmm11,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm4
vpxorq zmm4,zmm16,zmm7
vpxorq zmm16,zmm31,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm16
vpxorq zmm31,zmm31,zmm13
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm31
vpxorq zmm7,zmm7,zmm22
vpxorq zmm22,zmm22,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm4
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm22
vpxorq zmm7,zmm7,zmm28
vpxorq zmm7,zmm7,zmm13
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm7
vpxorq zmm7,zmm15,zmm6
vpxorq zmm15,zmm30,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm15
vpxorq zmm30,zmm30,zmm12
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm30
vpxorq zmm6,zmm6,zmm21
vpxorq zmm21,zmm21,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm7
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm21
vpxorq zmm6,zmm6,zmm27
vpxorq zmm6,zmm6,zmm12
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm6
vpxorq zmm6,zmm14,zmm5
vpxorq zmm14,zmm29,zmm14
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm14
vpxorq zmm29,zmm29,zmm11
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm29
vpxorq zmm5,zmm5,zmm20
vpxorq zmm20,zmm20,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm6
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm20
vpxorq zmm5,zmm5,zmm26
vpxorq zmm5,zmm5,zmm11
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm5
vgf2p8affineqb zmm5,zmm19,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm5
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm19
vgf2p8affineqb zmm19,zmm18,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm19
vpxorq zmm18,zmm18,zmm27
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm18
vgf2p8affineqb zmm18,zmm17,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm18
vpxorq zmm17,zmm17,zmm26
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm17
vgf2p8affineqb zmm17,zmm28,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm17
vpxorq zmm28,zmm28,zmm25
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm25
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm28
vgf2p8affineqb zmm28,zmm27,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm28
vpxorq zmm27,zmm27,zmm24
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm24
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm27
vgf2p8affineqb zmm27,zmm26,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm27
vpxorq zmm26,zmm26,zmm23
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm23
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm26
vzeroupper
ret
.size flock_ab_poly2_m0,.-flock_ab_poly2_m0
.p2align 5
.globl flock_ab_poly2_m1
.type flock_ab_poly2_m1,@function
flock_ab_poly2_m1:
prefetcht0 [rdi + 1856]
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
prefetcht0 [rdi + 1920]
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
vgf2p8affineqb zmm28,zmm31,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm28
vgf2p8affineqb zmm28,zmm30,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm28
prefetcht0 [rdi + 1984]
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm27
prefetcht0 [rdi + 2048]
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm25
prefetcht0 [rdi + 2112]
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm24
prefetcht0 [rdi + 2176]
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm23
vpxorq zmm23,zmm25,zmm24
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm22
vpxorq zmm22,zmm28,zmm25
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm22
vpxorq zmm22,zmm27,zmm24
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm22
vpxorq zmm22,zmm26,zmm23
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm22
vgf2p8affineqb zmm22,zmm28,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm22
vgf2p8affineqb zmm22,zmm27,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm22
vgf2p8affineqb zmm22,zmm26,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm22
vpxorq zmm22,zmm31,zmm25
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm21
vpxorq zmm21,zmm30,zmm24
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm20
vpxorq zmm20,zmm29,zmm23
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm19
vpxorq zmm19,zmm28,zmm22
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm21
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm19
vpxorq zmm19,zmm26,zmm20
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm19
prefetcht0 [rdi + 2240]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm18
prefetcht0 [rdi + 2304]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm16
prefetcht0 [rdi + 2368]
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 512]
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm15
prefetcht0 [rdi + 2432]
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 576]
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm14
vpxorq zmm14,zmm16,zmm15
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm13
vpxorq zmm13,zmm19,zmm16
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm12
vpxorq zmm12,zmm18,zmm15
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm11
vpxorq zmm11,zmm17,zmm14
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm10
prefetcht0 [rdi + 2496]
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm10
vgf2p8affineqb zmm9,zmm10,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm9
prefetcht0 [rdi + 2560]
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm9
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm8
vpxorq zmm8,zmm10,zmm9
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm7,zmm8,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm7
prefetcht0 [rdi + 2624]
vmovdqu64 zmm7,ZMMWORD PTR [rdi + 768]
vpxorq zmm25,zmm25,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm6
prefetcht0 [rdi + 2688]
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 832]
vpxorq zmm24,zmm24,zmm6
vgf2p8affineqb zmm5,zmm6,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm5
vpxorq zmm5,zmm7,zmm6
vpxorq zmm23,zmm23,zmm5
vgf2p8affineqb zmm4,zmm5,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm4
vpxorq zmm4,zmm10,zmm7
vpxorq zmm10,zmm19,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm10
vgf2p8affineqb zmm10,zmm4,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm10
vpxorq zmm4,zmm13,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm4
vpxorq zmm4,zmm9,zmm6
vpxorq zmm9,zmm18,zmm9
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm9
vgf2p8affineqb zmm9,zmm4,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm9
vpxorq zmm4,zmm12,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm4
vpxorq zmm4,zmm8,zmm5
vpxorq zmm8,zmm17,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm8
vgf2p8affineqb zmm8,zmm4,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm8
vpxorq zmm4,zmm11,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm4
vpxorq zmm4,zmm16,zmm7
vpxorq zmm16,zmm31,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm16
vpxorq zmm31,zmm31,zmm13
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm31
vpxorq zmm7,zmm7,zmm22
vpxorq zmm22,zmm22,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm4
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm22
vpxorq zmm7,zmm7,zmm28
vpxorq zmm7,zmm7,zmm13
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm7
vpxorq zmm7,zmm15,zmm6
vpxorq zmm15,zmm30,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm15
vpxorq zmm30,zmm30,zmm12
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm30
vpxorq zmm6,zmm6,zmm21
vpxorq zmm21,zmm21,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm7
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm21
vpxorq zmm6,zmm6,zmm27
vpxorq zmm6,zmm6,zmm12
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm6
vpxorq zmm6,zmm14,zmm5
vpxorq zmm14,zmm29,zmm14
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm14
vpxorq zmm29,zmm29,zmm11
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm29
vpxorq zmm5,zmm5,zmm20
vpxorq zmm20,zmm20,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm6
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm20
vpxorq zmm5,zmm5,zmm26
vpxorq zmm5,zmm5,zmm11
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm5
vgf2p8affineqb zmm5,zmm19,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm5
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm19
vgf2p8affineqb zmm19,zmm18,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm19
vpxorq zmm18,zmm18,zmm27
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm18
vgf2p8affineqb zmm18,zmm17,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm18
vpxorq zmm17,zmm17,zmm26
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm17
vgf2p8affineqb zmm17,zmm28,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm17
vpxorq zmm28,zmm28,zmm25
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm25
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm28
vgf2p8affineqb zmm28,zmm27,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm28
vpxorq zmm27,zmm27,zmm24
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm24
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm27
vgf2p8affineqb zmm27,zmm26,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm27
vpxorq zmm26,zmm26,zmm23
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm23
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm26
vzeroupper
ret
.size flock_ab_poly2_m1,.-flock_ab_poly2_m1
.p2align 5
.globl flock_ab_poly2_m2
.type flock_ab_poly2_m2,@function
flock_ab_poly2_m2:
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
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 0]
vgf2p8affineqb zmm30,zmm31,QWORD PTR [rsi + 0]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 0]
vmovdqu64 ZMMWORD PTR [rdx + 0],zmm30
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 64]
vgf2p8affineqb zmm29,zmm30,QWORD PTR [rsi + 8]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 64]
vmovdqu64 ZMMWORD PTR [rdx + 64],zmm29
vpxorq zmm29,zmm31,zmm30
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 16]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 128]
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm28
vgf2p8affineqb zmm28,zmm31,QWORD PTR [rsi + 24]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 192]
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm28
vgf2p8affineqb zmm28,zmm30,QWORD PTR [rsi + 32]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 256]
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm28
vgf2p8affineqb zmm28,zmm29,QWORD PTR [rsi + 40]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 320]
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm28
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 128]
vgf2p8affineqb zmm27,zmm28,QWORD PTR [rsi + 48]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 384]
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm27
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 192]
vgf2p8affineqb zmm26,zmm27,QWORD PTR [rsi + 56]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 448]
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm26
vpxorq zmm26,zmm28,zmm27
vgf2p8affineqb zmm25,zmm26,QWORD PTR [rsi + 64]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 512]
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm25
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 256]
vgf2p8affineqb zmm24,zmm25,QWORD PTR [rsi + 72]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 576]
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm24
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 320]
vgf2p8affineqb zmm23,zmm24,QWORD PTR [rsi + 80]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 640]
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm23
vpxorq zmm23,zmm25,zmm24
vgf2p8affineqb zmm22,zmm23,QWORD PTR [rsi + 88]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 704]
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm22
vpxorq zmm22,zmm28,zmm25
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 96]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 768]
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm22
vpxorq zmm22,zmm27,zmm24
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 104]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 832]
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm22
vpxorq zmm22,zmm26,zmm23
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 112]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 896]
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm22
vgf2p8affineqb zmm22,zmm28,QWORD PTR [rsi + 120]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 960]
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm22
vgf2p8affineqb zmm22,zmm27,QWORD PTR [rsi + 128]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1024]
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm22
vgf2p8affineqb zmm22,zmm26,QWORD PTR [rsi + 136]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 1088]
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm22
vpxorq zmm22,zmm31,zmm25
vgf2p8affineqb zmm21,zmm22,QWORD PTR [rsi + 144]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 1152]
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm21
vpxorq zmm21,zmm30,zmm24
vgf2p8affineqb zmm20,zmm21,QWORD PTR [rsi + 152]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 1216]
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm20
vpxorq zmm20,zmm29,zmm23
vgf2p8affineqb zmm19,zmm20,QWORD PTR [rsi + 160]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1280]
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm19
vpxorq zmm19,zmm28,zmm22
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 168]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1344]
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm19
vpxorq zmm19,zmm27,zmm21
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 176]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1408]
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm19
vpxorq zmm19,zmm26,zmm20
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 184]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 1472]
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 384]
vgf2p8affineqb zmm18,zmm19,QWORD PTR [rsi + 192]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 1536]
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm18
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 448]
vgf2p8affineqb zmm17,zmm18,QWORD PTR [rsi + 200]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 1600]
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm17,zmm19,zmm18
vgf2p8affineqb zmm16,zmm17,QWORD PTR [rsi + 208]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 1664]
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm16
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 512]
vgf2p8affineqb zmm15,zmm16,QWORD PTR [rsi + 216]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 1728]
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm15
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 576]
vgf2p8affineqb zmm14,zmm15,QWORD PTR [rsi + 224]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 1792]
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm14
vpxorq zmm14,zmm16,zmm15
vgf2p8affineqb zmm13,zmm14,QWORD PTR [rsi + 232]{1to8},0
vpxorq zmm13,zmm13,ZMMWORD PTR [rdx + 1856]
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm13
vpxorq zmm13,zmm19,zmm16
vgf2p8affineqb zmm12,zmm13,QWORD PTR [rsi + 240]{1to8},0
vpxorq zmm12,zmm12,ZMMWORD PTR [rdx + 1920]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm12
vpxorq zmm12,zmm18,zmm15
vgf2p8affineqb zmm11,zmm12,QWORD PTR [rsi + 248]{1to8},0
vpxorq zmm11,zmm11,ZMMWORD PTR [rdx + 1984]
vmovdqu64 ZMMWORD PTR [rdx + 1984],zmm11
vpxorq zmm11,zmm17,zmm14
vgf2p8affineqb zmm10,zmm11,QWORD PTR [rsi + 256]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2048]
vmovdqu64 ZMMWORD PTR [rdx + 2048],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 640]
vpxorq zmm28,zmm28,zmm10
vgf2p8affineqb zmm9,zmm10,QWORD PTR [rsi + 264]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2112]
vmovdqu64 ZMMWORD PTR [rdx + 2112],zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 704]
vpxorq zmm27,zmm27,zmm9
vgf2p8affineqb zmm8,zmm9,QWORD PTR [rsi + 272]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2176]
vmovdqu64 ZMMWORD PTR [rdx + 2176],zmm8
vpxorq zmm8,zmm10,zmm9
vpxorq zmm26,zmm26,zmm8
vgf2p8affineqb zmm7,zmm8,QWORD PTR [rsi + 280]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2240]
vmovdqu64 ZMMWORD PTR [rdx + 2240],zmm7
vmovdqu64 zmm7,ZMMWORD PTR [rdi + 768]
vpxorq zmm25,zmm25,zmm7
vgf2p8affineqb zmm6,zmm7,QWORD PTR [rsi + 288]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 2304]
vmovdqu64 ZMMWORD PTR [rdx + 2304],zmm6
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 832]
vpxorq zmm24,zmm24,zmm6
vgf2p8affineqb zmm5,zmm6,QWORD PTR [rsi + 296]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 2368],zmm5
vpxorq zmm5,zmm7,zmm6
vpxorq zmm23,zmm23,zmm5
vgf2p8affineqb zmm4,zmm5,QWORD PTR [rsi + 304]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2432]
vmovdqu64 ZMMWORD PTR [rdx + 2432],zmm4
vpxorq zmm4,zmm10,zmm7
vpxorq zmm10,zmm19,zmm10
vgf2p8affineqb zmm10,zmm10,QWORD PTR [rsi + 336]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2688]
vmovdqu64 ZMMWORD PTR [rdx + 2688],zmm10
vgf2p8affineqb zmm10,zmm4,QWORD PTR [rsi + 312]{1to8},0
vpxorq zmm10,zmm10,ZMMWORD PTR [rdx + 2496]
vmovdqu64 ZMMWORD PTR [rdx + 2496],zmm10
vpxorq zmm4,zmm13,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 384]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3072]
vmovdqu64 ZMMWORD PTR [rdx + 3072],zmm4
vpxorq zmm4,zmm9,zmm6
vpxorq zmm9,zmm18,zmm9
vgf2p8affineqb zmm9,zmm9,QWORD PTR [rsi + 344]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2752]
vmovdqu64 ZMMWORD PTR [rdx + 2752],zmm9
vgf2p8affineqb zmm9,zmm4,QWORD PTR [rsi + 320]{1to8},0
vpxorq zmm9,zmm9,ZMMWORD PTR [rdx + 2560]
vmovdqu64 ZMMWORD PTR [rdx + 2560],zmm9
vpxorq zmm4,zmm12,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 392]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3136]
vmovdqu64 ZMMWORD PTR [rdx + 3136],zmm4
vpxorq zmm4,zmm8,zmm5
vpxorq zmm8,zmm17,zmm8
vgf2p8affineqb zmm8,zmm8,QWORD PTR [rsi + 352]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2816]
vmovdqu64 ZMMWORD PTR [rdx + 2816],zmm8
vgf2p8affineqb zmm8,zmm4,QWORD PTR [rsi + 328]{1to8},0
vpxorq zmm8,zmm8,ZMMWORD PTR [rdx + 2624]
vmovdqu64 ZMMWORD PTR [rdx + 2624],zmm8
vpxorq zmm4,zmm11,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 400]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 3200]
vmovdqu64 ZMMWORD PTR [rdx + 3200],zmm4
vpxorq zmm4,zmm16,zmm7
vpxorq zmm16,zmm31,zmm16
vgf2p8affineqb zmm16,zmm16,QWORD PTR [rsi + 432]{1to8},0
vpxorq zmm16,zmm16,ZMMWORD PTR [rdx + 3456]
vmovdqu64 ZMMWORD PTR [rdx + 3456],zmm16
vpxorq zmm31,zmm31,zmm13
vgf2p8affineqb zmm31,zmm31,QWORD PTR [rsi + 456]{1to8},0
vpxorq zmm31,zmm31,ZMMWORD PTR [rdx + 3648]
vmovdqu64 ZMMWORD PTR [rdx + 3648],zmm31
vpxorq zmm7,zmm7,zmm22
vpxorq zmm22,zmm22,zmm4
vgf2p8affineqb zmm4,zmm4,QWORD PTR [rsi + 360]{1to8},0
vpxorq zmm4,zmm4,ZMMWORD PTR [rdx + 2880]
vmovdqu64 ZMMWORD PTR [rdx + 2880],zmm4
vgf2p8affineqb zmm22,zmm22,QWORD PTR [rsi + 576]{1to8},0
vpxorq zmm22,zmm22,ZMMWORD PTR [rdx + 4608]
vmovdqu64 ZMMWORD PTR [rdx + 4608],zmm22
vpxorq zmm7,zmm7,zmm28
vpxorq zmm7,zmm7,zmm13
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 600]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 4800]
vmovdqu64 ZMMWORD PTR [rdx + 4800],zmm7
vpxorq zmm7,zmm15,zmm6
vpxorq zmm15,zmm30,zmm15
vgf2p8affineqb zmm15,zmm15,QWORD PTR [rsi + 440]{1to8},0
vpxorq zmm15,zmm15,ZMMWORD PTR [rdx + 3520]
vmovdqu64 ZMMWORD PTR [rdx + 3520],zmm15
vpxorq zmm30,zmm30,zmm12
vgf2p8affineqb zmm30,zmm30,QWORD PTR [rsi + 464]{1to8},0
vpxorq zmm30,zmm30,ZMMWORD PTR [rdx + 3712]
vmovdqu64 ZMMWORD PTR [rdx + 3712],zmm30
vpxorq zmm6,zmm6,zmm21
vpxorq zmm21,zmm21,zmm7
vgf2p8affineqb zmm7,zmm7,QWORD PTR [rsi + 368]{1to8},0
vpxorq zmm7,zmm7,ZMMWORD PTR [rdx + 2944]
vmovdqu64 ZMMWORD PTR [rdx + 2944],zmm7
vgf2p8affineqb zmm21,zmm21,QWORD PTR [rsi + 584]{1to8},0
vpxorq zmm21,zmm21,ZMMWORD PTR [rdx + 4672]
vmovdqu64 ZMMWORD PTR [rdx + 4672],zmm21
vpxorq zmm6,zmm6,zmm27
vpxorq zmm6,zmm6,zmm12
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 608]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 4864]
vmovdqu64 ZMMWORD PTR [rdx + 4864],zmm6
vpxorq zmm6,zmm14,zmm5
vpxorq zmm14,zmm29,zmm14
vgf2p8affineqb zmm14,zmm14,QWORD PTR [rsi + 448]{1to8},0
vpxorq zmm14,zmm14,ZMMWORD PTR [rdx + 3584]
vmovdqu64 ZMMWORD PTR [rdx + 3584],zmm14
vpxorq zmm29,zmm29,zmm11
vgf2p8affineqb zmm29,zmm29,QWORD PTR [rsi + 472]{1to8},0
vpxorq zmm29,zmm29,ZMMWORD PTR [rdx + 3776]
vmovdqu64 ZMMWORD PTR [rdx + 3776],zmm29
vpxorq zmm5,zmm5,zmm20
vpxorq zmm20,zmm20,zmm6
vgf2p8affineqb zmm6,zmm6,QWORD PTR [rsi + 376]{1to8},0
vpxorq zmm6,zmm6,ZMMWORD PTR [rdx + 3008]
vmovdqu64 ZMMWORD PTR [rdx + 3008],zmm6
vgf2p8affineqb zmm20,zmm20,QWORD PTR [rsi + 592]{1to8},0
vpxorq zmm20,zmm20,ZMMWORD PTR [rdx + 4736]
vmovdqu64 ZMMWORD PTR [rdx + 4736],zmm20
vpxorq zmm5,zmm5,zmm26
vpxorq zmm5,zmm5,zmm11
vgf2p8affineqb zmm5,zmm5,QWORD PTR [rsi + 616]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 4928]
vmovdqu64 ZMMWORD PTR [rdx + 4928],zmm5
vgf2p8affineqb zmm5,zmm19,QWORD PTR [rsi + 408]{1to8},0
vpxorq zmm5,zmm5,ZMMWORD PTR [rdx + 3264]
vmovdqu64 ZMMWORD PTR [rdx + 3264],zmm5
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm19,zmm19,QWORD PTR [rsi + 552]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 4416]
vmovdqu64 ZMMWORD PTR [rdx + 4416],zmm19
vgf2p8affineqb zmm19,zmm18,QWORD PTR [rsi + 416]{1to8},0
vpxorq zmm19,zmm19,ZMMWORD PTR [rdx + 3328]
vmovdqu64 ZMMWORD PTR [rdx + 3328],zmm19
vpxorq zmm18,zmm18,zmm27
vgf2p8affineqb zmm18,zmm18,QWORD PTR [rsi + 560]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 4480]
vmovdqu64 ZMMWORD PTR [rdx + 4480],zmm18
vgf2p8affineqb zmm18,zmm17,QWORD PTR [rsi + 424]{1to8},0
vpxorq zmm18,zmm18,ZMMWORD PTR [rdx + 3392]
vmovdqu64 ZMMWORD PTR [rdx + 3392],zmm18
vpxorq zmm17,zmm17,zmm26
vgf2p8affineqb zmm17,zmm17,QWORD PTR [rsi + 568]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 4544]
vmovdqu64 ZMMWORD PTR [rdx + 4544],zmm17
vgf2p8affineqb zmm17,zmm28,QWORD PTR [rsi + 480]{1to8},0
vpxorq zmm17,zmm17,ZMMWORD PTR [rdx + 3840]
vmovdqu64 ZMMWORD PTR [rdx + 3840],zmm17
vpxorq zmm28,zmm28,zmm25
vgf2p8affineqb zmm25,zmm25,QWORD PTR [rsi + 504]{1to8},0
vpxorq zmm25,zmm25,ZMMWORD PTR [rdx + 4032]
vmovdqu64 ZMMWORD PTR [rdx + 4032],zmm25
vgf2p8affineqb zmm28,zmm28,QWORD PTR [rsi + 528]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 4224]
vmovdqu64 ZMMWORD PTR [rdx + 4224],zmm28
vgf2p8affineqb zmm28,zmm27,QWORD PTR [rsi + 488]{1to8},0
vpxorq zmm28,zmm28,ZMMWORD PTR [rdx + 3904]
vmovdqu64 ZMMWORD PTR [rdx + 3904],zmm28
vpxorq zmm27,zmm27,zmm24
vgf2p8affineqb zmm24,zmm24,QWORD PTR [rsi + 512]{1to8},0
vpxorq zmm24,zmm24,ZMMWORD PTR [rdx + 4096]
vmovdqu64 ZMMWORD PTR [rdx + 4096],zmm24
vgf2p8affineqb zmm27,zmm27,QWORD PTR [rsi + 536]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 4288]
vmovdqu64 ZMMWORD PTR [rdx + 4288],zmm27
vgf2p8affineqb zmm27,zmm26,QWORD PTR [rsi + 496]{1to8},0
vpxorq zmm27,zmm27,ZMMWORD PTR [rdx + 3968]
vmovdqu64 ZMMWORD PTR [rdx + 3968],zmm27
vpxorq zmm26,zmm26,zmm23
vgf2p8affineqb zmm23,zmm23,QWORD PTR [rsi + 520]{1to8},0
vpxorq zmm23,zmm23,ZMMWORD PTR [rdx + 4160]
vmovdqu64 ZMMWORD PTR [rdx + 4160],zmm23
vgf2p8affineqb zmm26,zmm26,QWORD PTR [rsi + 544]{1to8},0
vpxorq zmm26,zmm26,ZMMWORD PTR [rdx + 4352]
vmovdqu64 ZMMWORD PTR [rdx + 4352],zmm26
vzeroupper
ret
.size flock_ab_poly2_m2,.-flock_ab_poly2_m2
.p2align 5
.globl flock_ab_poly_interpolate2
.type flock_ab_poly_interpolate2,@function
flock_ab_poly_interpolate2:
push rbp
mov rbp,rsp
and rsp,-64
sub rsp,960
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 192]
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 0]
vpxorq zmm29,zmm30,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 128],zmm29
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 320]
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 256]
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 128]
vpxorq zmm26,zmm27,zmm31
vpxorq zmm26,zmm26,zmm29
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 64]
vpxorq zmm30,zmm30,zmm25
vpxorq zmm24,zmm28,zmm30
vpxorq zmm26,zmm26,zmm24
vmovdqu64 ZMMWORD PTR [rdx + 192],zmm26
vmovdqu64 zmm26,ZMMWORD PTR [rdi + 384]
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 960]
vpxorq zmm22,zmm26,zmm23
vpxorq zmm22,zmm22,zmm24
vmovdqu64 ZMMWORD PTR [rdx + 256],zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 512]
vpxorq zmm27,zmm27,zmm22
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 448]
vpxorq zmm26,zmm26,zmm24
vpxorq zmm30,zmm30,zmm26
vpxorq zmm21,zmm30,zmm27
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 1088]
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 1024]
vpxorq zmm18,zmm23,zmm19
vpxorq zmm20,zmm20,zmm18
vpxorq zmm21,zmm21,zmm20
vmovdqu64 ZMMWORD PTR [rdx + 320],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 576]
vpxorq zmm17,zmm21,zmm30
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 1344]
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 1152]
vpxorq zmm18,zmm15,zmm18
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 768]
vpxorq zmm31,zmm31,zmm14
vpxorq zmm16,zmm16,zmm31
vpxorq zmm17,zmm17,zmm16
vpxorq zmm17,zmm17,zmm18
vmovdqu64 ZMMWORD PTR [rdx + 384],zmm17
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1472]
vpxorq zmm17,zmm17,zmm20
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 1408]
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 1280]
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 1216]
vpxorq zmm15,zmm15,zmm11
vpxorq zmm12,zmm12,zmm15
vpxorq zmm19,zmm19,zmm15
vpxorq zmm25,zmm25,zmm11
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 896]
vpxorq zmm29,zmm29,zmm15
vpxorq zmm22,zmm22,zmm15
vpxorq zmm17,zmm29,zmm17
vmovdqu64 zmm15,ZMMWORD PTR [rdi + 832]
vpxorq zmm28,zmm28,zmm15
vpxorq zmm13,zmm13,zmm28
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 704]
vpxorq zmm9,zmm10,zmm27
vpxorq zmm9,zmm9,zmm12
vpxorq zmm9,zmm9,zmm16
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 640]
vpxorq zmm21,zmm21,zmm8
vpxorq zmm7,zmm21,zmm30
vpxorq zmm7,zmm13,zmm7
vpxorq zmm9,zmm9,zmm7
vpxorq zmm9,zmm9,zmm17
vmovdqu64 ZMMWORD PTR [rdx + 448],zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 3264]
vmovdqu64 zmm6,ZMMWORD PTR [rdi + 1536]
vpxorq zmm5,zmm6,zmm9
vpxorq zmm5,zmm5,zmm19
vpxorq zmm5,zmm5,zmm7
vmovdqu64 ZMMWORD PTR [rdx + 512],zmm5
vmovdqu64 zmm5,ZMMWORD PTR [rdi + 3392]
vmovdqu64 zmm7,ZMMWORD PTR [rdi + 3328]
vmovdqu64 zmm4,ZMMWORD PTR [rdi + 1664]
vpxorq zmm10,zmm10,zmm4
vpxorq zmm27,zmm27,zmm10
vpxorq zmm5,zmm5,zmm27
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 1600]
vpxorq zmm6,zmm6,zmm3
vpxorq zmm21,zmm21,zmm6
vpxorq zmm30,zmm30,zmm21
vpxorq zmm7,zmm7,zmm30
vpxorq zmm9,zmm9,zmm7
vpxorq zmm26,zmm26,zmm21
vpxorq zmm2,zmm9,zmm12
vpxorq zmm2,zmm2,zmm5
vmovdqu64 ZMMWORD PTR [rdx + 576],zmm2
vmovdqu64 zmm2,ZMMWORD PTR [rdi + 3648]
vmovdqu64 zmm1,ZMMWORD PTR [rdi + 3456]
vmovdqu64 zmm0,ZMMWORD PTR [rdi + 1920]
vmovdqa64 ZMMWORD PTR [rsp + 0],zmm17
vpxorq zmm17,zmm0,zmm2
vpxorq zmm31,zmm31,zmm17
vmovdqu64 zmm17,ZMMWORD PTR [rdi + 1728]
vpxorq zmm11,zmm11,zmm17
vpxorq zmm11,zmm11,zmm1
vpxorq zmm11,zmm11,zmm9
vpxorq zmm11,zmm11,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 640],zmm11
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 3776]
vpxorq zmm11,zmm11,zmm5
vmovdqa64 ZMMWORD PTR [rsp + 64],zmm21
vmovdqu64 zmm21,ZMMWORD PTR [rdi + 3712]
vmovdqa64 ZMMWORD PTR [rsp + 128],zmm8
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 3584]
vmovdqa64 ZMMWORD PTR [rsp + 192],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 3520]
vpxorq zmm1,zmm1,zmm10
vpxorq zmm9,zmm9,zmm1
vmovdqa64 ZMMWORD PTR [rsp + 256],zmm1
vmovdqu64 zmm1,ZMMWORD PTR [rdi + 2048]
vmovdqa64 ZMMWORD PTR [rsp + 320],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 1984]
vmovdqa64 ZMMWORD PTR [rsp + 384],zmm25
vpxorq zmm25,zmm10,zmm21
vmovdqa64 ZMMWORD PTR [rsp + 448],zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 1856]
vmovdqa64 ZMMWORD PTR [rsp + 512],zmm3
vpxorq zmm3,zmm10,zmm1
vpxorq zmm3,zmm3,zmm8
vpxorq zmm3,zmm3,zmm9
vpxorq zmm3,zmm3,zmm29
vpxorq zmm3,zmm3,zmm11
vpxorq zmm3,zmm3,zmm31
vmovdqu64 zmm31,ZMMWORD PTR [rdi + 1792]
vpxorq zmm17,zmm17,zmm31
vpxorq zmm28,zmm17,zmm28
vpxorq zmm25,zmm25,zmm28
vpxorq zmm3,zmm3,zmm25
vmovdqu64 ZMMWORD PTR [rdx + 704],zmm3
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 4416]
vpxorq zmm3,zmm3,zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 3840]
vmovdqu64 zmm28,ZMMWORD PTR [rdi + 2688]
vpxorq zmm24,zmm24,zmm28
vmovdqu64 zmm29,ZMMWORD PTR [rdi + 2112]
vpxorq zmm23,zmm23,zmm29
vpxorq zmm23,zmm23,zmm28
vpxorq zmm23,zmm23,zmm9
vpxorq zmm23,zmm23,zmm3
vpxorq zmm23,zmm23,zmm25
vmovdqu64 ZMMWORD PTR [rdx + 768],zmm23
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 4544]
vpxorq zmm23,zmm23,zmm3
vmovdqu64 zmm25,ZMMWORD PTR [rdi + 4480]
vmovdqa64 ZMMWORD PTR [rsp + 576],zmm11
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 3968]
vpxorq zmm8,zmm8,zmm11
vpxorq zmm22,zmm22,zmm11
vpxorq zmm23,zmm8,zmm23
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 3904]
vpxorq zmm9,zmm9,zmm11
vpxorq zmm24,zmm24,zmm11
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 2816]
vmovdqa64 ZMMWORD PTR [rsp + 640],zmm24
vmovdqu64 zmm24,ZMMWORD PTR [rdi + 2752]
vpxorq zmm28,zmm28,zmm24
vpxorq zmm11,zmm11,zmm28
vmovdqa64 ZMMWORD PTR [rsp + 704],zmm22
vmovdqu64 zmm22,ZMMWORD PTR [rdi + 2240]
vpxorq zmm10,zmm10,zmm22
vmovdqa64 ZMMWORD PTR [rsp + 768],zmm8
vpxorq zmm8,zmm25,zmm10
vpxorq zmm8,zmm8,zmm20
vpxorq zmm8,zmm8,zmm11
vpxorq zmm8,zmm8,zmm5
vmovdqu64 zmm5,ZMMWORD PTR [rdi + 2176]
vpxorq zmm29,zmm29,zmm5
vpxorq zmm17,zmm17,zmm29
vpxorq zmm20,zmm17,zmm9
vpxorq zmm8,zmm8,zmm20
vpxorq zmm8,zmm8,zmm23
vmovdqu64 ZMMWORD PTR [rdx + 832],zmm8
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 4800]
vpxorq zmm8,zmm8,zmm16
vmovdqu64 zmm16,ZMMWORD PTR [rdi + 4608]
vpxorq zmm25,zmm25,zmm16
vpxorq zmm7,zmm7,zmm25
vpxorq zmm7,zmm7,zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 4224]
vpxorq zmm2,zmm2,zmm19
vpxorq zmm2,zmm2,zmm8
vpxorq zmm14,zmm14,zmm19
vmovdqu64 zmm19,ZMMWORD PTR [rdi + 4032]
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 3072]
vmovdqa64 ZMMWORD PTR [rsp + 832],zmm23
vmovdqu64 zmm23,ZMMWORD PTR [rdi + 2880]
vpxorq zmm28,zmm23,zmm28
vmovdqa64 ZMMWORD PTR [rsp + 896],zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 2496]
vpxorq zmm0,zmm0,zmm9
vpxorq zmm9,zmm9,zmm29
vpxorq zmm8,zmm8,zmm0
vpxorq zmm0,zmm0,zmm14
vpxorq zmm26,zmm26,zmm0
vpxorq zmm25,zmm8,zmm25
vpxorq zmm25,zmm25,zmm2
vpxorq zmm6,zmm6,zmm8
vpxorq zmm4,zmm4,zmm6
vmovdqu64 zmm8,ZMMWORD PTR [rdi + 2304]
vpxorq zmm2,zmm8,zmm19
vpxorq zmm2,zmm2,zmm3
vpxorq zmm2,zmm2,zmm18
vpxorq zmm2,zmm2,zmm28
vpxorq zmm2,zmm2,zmm20
vpxorq zmm2,zmm2,zmm25
vmovdqu64 ZMMWORD PTR [rdx + 896],zmm2
vmovdqu64 zmm2,ZMMWORD PTR [rdi + 4928]
vmovdqu64 zmm20,ZMMWORD PTR [rdi + 4864]
vpxorq zmm20,zmm20,zmm13
vmovdqu64 zmm13,ZMMWORD PTR [rdi + 4736]
vpxorq zmm13,zmm13,zmm12
vmovdqu64 zmm12,ZMMWORD PTR [rdi + 4672]
vmovdqu64 zmm18,ZMMWORD PTR [rdi + 4352]
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 4288]
vpxorq zmm21,zmm21,zmm3
vpxorq zmm15,zmm15,zmm3
vmovdqu64 zmm3,ZMMWORD PTR [rdi + 4160]
vpxorq zmm18,zmm3,zmm18
vpxorq zmm16,zmm3,zmm16
vpxorq zmm16,zmm16,zmm30
vpxorq zmm16,zmm16,zmm27
vpxorq zmm3,zmm3,zmm11
vmovdqu64 zmm27,ZMMWORD PTR [rdi + 4096]
vmovdqu64 zmm30,ZMMWORD PTR [rdi + 3200]
vpxorq zmm30,zmm30,zmm11
vmovdqu64 zmm11,ZMMWORD PTR [rdi + 3136]
vmovdqu64 zmm0,ZMMWORD PTR [rdi + 3008]
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 2944]
vpxorq zmm23,zmm23,zmm14
vpxorq zmm24,zmm24,zmm23
vpxorq zmm7,zmm7,zmm24
vmovdqa64 zmm29,ZMMWORD PTR [rsp + 512]
vpxorq zmm29,zmm29,zmm24
vmovdqa64 zmm24,ZMMWORD PTR [rsp + 384]
vpxorq zmm24,zmm24,zmm14
vmovdqa64 ZMMWORD PTR [rsp + 384],zmm9
vmovdqa64 zmm9,ZMMWORD PTR [rsp + 320]
vpxorq zmm24,zmm24,zmm9
vpxorq zmm31,zmm31,zmm14
vmovdqu64 zmm14,ZMMWORD PTR [rdi + 2624]
vpxorq zmm1,zmm1,zmm14
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 2560]
vmovdqa64 ZMMWORD PTR [rsp + 320],zmm31
vmovdqa64 zmm31,ZMMWORD PTR [rsp + 448]
vpxorq zmm31,zmm31,zmm9
vpxorq zmm11,zmm11,zmm31
vpxorq zmm31,zmm31,zmm15
vpxorq zmm21,zmm11,zmm21
vpxorq zmm20,zmm20,zmm21
vpxorq zmm22,zmm22,zmm9
vpxorq zmm22,zmm22,zmm14
vpxorq zmm5,zmm5,zmm9
vmovdqu64 zmm9,ZMMWORD PTR [rdi + 2432]
vpxorq zmm10,zmm9,zmm10
vpxorq zmm0,zmm0,zmm10
vpxorq zmm23,zmm23,zmm0
vmovdqa64 zmm0,ZMMWORD PTR [rsp + 192]
vpxorq zmm0,zmm0,zmm10
vpxorq zmm16,zmm16,zmm23
vmovdqa64 zmm10,ZMMWORD PTR [rsp + 768]
vpxorq zmm16,zmm16,zmm10
vpxorq zmm16,zmm16,zmm13
vpxorq zmm10,zmm23,zmm1
vpxorq zmm30,zmm30,zmm10
vmovdqu64 zmm10,ZMMWORD PTR [rdi + 2368]
vmovdqu64 ZMMWORD PTR [rdx + 1920],zmm10
vpxorq zmm8,zmm8,zmm10
vpxorq zmm17,zmm8,zmm17
vpxorq zmm27,zmm27,zmm17
vpxorq zmm19,zmm19,zmm27
vmovdqa64 zmm10,ZMMWORD PTR [rsp + 128]
vpxorq zmm10,zmm10,zmm27
vpxorq zmm10,zmm10,zmm28
vpxorq zmm10,zmm10,zmm6
vmovdqu64 ZMMWORD PTR [rdx + 1408],zmm10
vmovdqa64 zmm10,ZMMWORD PTR [rsp + 896]
vpxorq zmm10,zmm10,zmm19
vmovdqa64 zmm6,ZMMWORD PTR [rsp + 64]
vpxorq zmm6,zmm6,zmm19
vpxorq zmm12,zmm12,zmm10
vmovdqa64 zmm19,ZMMWORD PTR [rsp + 704]
vpxorq zmm19,zmm19,zmm10
vpxorq zmm19,zmm19,zmm1
vpxorq zmm2,zmm2,zmm12
vmovdqa64 zmm1,ZMMWORD PTR [rsp + 576]
vpxorq zmm2,zmm2,zmm1
vpxorq zmm2,zmm2,zmm18
vpxorq zmm2,zmm2,zmm13
vmovdqa64 zmm13,ZMMWORD PTR [rsp + 0]
vpxorq zmm2,zmm2,zmm13
vmovdqa64 zmm13,ZMMWORD PTR [rsp + 832]
vpxorq zmm2,zmm2,zmm13
vpxorq zmm19,zmm19,zmm18
vpxorq zmm2,zmm2,zmm30
vpxorq zmm2,zmm2,zmm20
vpxorq zmm2,zmm2,zmm25
vmovdqu64 ZMMWORD PTR [rdx + 960],zmm2
vmovdqa64 zmm2,ZMMWORD PTR [rsp + 256]
vpxorq zmm2,zmm2,zmm12
vpxorq zmm24,zmm24,zmm12
vpxorq zmm7,zmm7,zmm2
vpxorq zmm7,zmm7,zmm20
vmovdqu64 ZMMWORD PTR [rdx + 1024],zmm7
vpxorq zmm16,zmm16,zmm2
vmovdqu64 ZMMWORD PTR [rdx + 1088],zmm16
vpxorq zmm24,zmm24,zmm26
vmovdqu64 ZMMWORD PTR [rdx + 1152],zmm24
vpxorq zmm19,zmm19,zmm0
vpxorq zmm19,zmm19,zmm31
vpxorq zmm19,zmm19,zmm26
vmovdqu64 ZMMWORD PTR [rdx + 1216],zmm19
vmovdqa64 zmm19,ZMMWORD PTR [rsp + 640]
vpxorq zmm19,zmm19,zmm6
vpxorq zmm19,zmm19,zmm31
vmovdqu64 ZMMWORD PTR [rdx + 1280],zmm19
vpxorq zmm3,zmm3,zmm6
vpxorq zmm3,zmm3,zmm0
vmovdqu64 ZMMWORD PTR [rdx + 1344],zmm3
vpxorq zmm11,zmm17,zmm11
vpxorq zmm17,zmm17,zmm23
vmovdqu64 ZMMWORD PTR [rdx + 1600],zmm17
vpxorq zmm4,zmm4,zmm11
vpxorq zmm4,zmm4,zmm30
vmovdqu64 ZMMWORD PTR [rdx + 1472],zmm4
vpxorq zmm29,zmm29,zmm11
vmovdqu64 ZMMWORD PTR [rdx + 1536],zmm29
vmovdqa64 zmm29,ZMMWORD PTR [rsp + 320]
vpxorq zmm29,zmm29,zmm8
vmovdqa64 zmm11,ZMMWORD PTR [rsp + 384]
vpxorq zmm29,zmm29,zmm11
vmovdqu64 ZMMWORD PTR [rdx + 1664],zmm29
vpxorq zmm9,zmm9,zmm8
vmovdqu64 ZMMWORD PTR [rdx + 1856],zmm9
vpxorq zmm22,zmm22,zmm9
vpxorq zmm22,zmm22,zmm11
vmovdqu64 ZMMWORD PTR [rdx + 1728],zmm22
vpxorq zmm5,zmm5,zmm8
vmovdqu64 ZMMWORD PTR [rdx + 1792],zmm5
mov rsp,rbp
pop rbp
vzeroupper
ret
.size flock_ab_poly_interpolate2,.-flock_ab_poly_interpolate2
.p2align 5
.globl flock_ab_poly_finalize
.type flock_ab_poly_finalize,@function
flock_ab_poly_finalize:
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
.size flock_ab_poly_finalize,.-flock_ab_poly_finalize
.p2align 5
.globl flock_ab_poly_zero
.type flock_ab_poly_zero,@function
flock_ab_poly_zero:
vpxord zmm0,zmm0,zmm0
mov ecx,4
.Lleafzero4:
vmovdqu64 ZMMWORD PTR [rdi + 0],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 64],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 128],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 192],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 256],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 320],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 384],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 448],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 512],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 576],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 640],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 704],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 768],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 832],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 896],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 960],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1024],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1088],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1152],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1216],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1280],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1344],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1408],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1472],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1536],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1600],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1664],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1728],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1792],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1856],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1920],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 1984],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2048],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2112],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2176],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2240],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2304],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2368],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2432],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2496],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2560],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2624],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2688],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2752],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2816],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2880],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 2944],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3008],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3072],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3136],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3200],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3264],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3328],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3392],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3456],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3520],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3584],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3648],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3712],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3776],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3840],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3904],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 3968],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4032],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4096],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4160],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4224],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4288],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4352],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4416],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4480],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4544],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4608],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4672],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4736],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4800],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4864],zmm0
vmovdqu64 ZMMWORD PTR [rdi + 4928],zmm0
add rdi,4992
dec ecx
jne .Lleafzero4
vzeroupper
ret
.size flock_ab_poly_zero,.-flock_ab_poly_zero
