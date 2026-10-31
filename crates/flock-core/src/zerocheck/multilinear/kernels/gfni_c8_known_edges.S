.text
.p2align 5
.globl flock_c8_edges_common
.hidden flock_c8_edges_common
.type flock_c8_edges_common,@function
flock_c8_edges_common:
vpunpcklqdq zmm8, zmm0, zmm1
vpunpckhqdq zmm9, zmm0, zmm1
vpunpcklqdq zmm10, zmm2, zmm3
vpunpckhqdq zmm0, zmm2, zmm3
vpunpcklqdq zmm1, zmm4, zmm5
vpunpckhqdq zmm2, zmm4, zmm5
vpunpcklqdq zmm3, zmm6, zmm7
vpunpckhqdq zmm4, zmm6, zmm7
vshufi64x2 zmm5, zmm8, zmm10, 136
vshufi64x2 zmm6, zmm8, zmm10, 221
vshufi64x2 zmm7, zmm9, zmm0, 136
vshufi64x2 zmm8, zmm9, zmm0, 221
vshufi64x2 zmm10, zmm1, zmm3, 136
vshufi64x2 zmm9, zmm1, zmm3, 221
vshufi64x2 zmm0, zmm2, zmm4, 136
vshufi64x2 zmm1, zmm2, zmm4, 221
vshufi64x2 zmm3, zmm5, zmm10, 136
vshufi64x2 zmm2, zmm5, zmm10, 221
vshufi64x2 zmm4, zmm6, zmm9, 136
vshufi64x2 zmm5, zmm6, zmm9, 221
vshufi64x2 zmm10, zmm7, zmm0, 136
vshufi64x2 zmm6, zmm7, zmm0, 221
vshufi64x2 zmm9, zmm8, zmm1, 136
vshufi64x2 zmm7, zmm8, zmm1, 221
vmovdqa64 zmm0, [rip + .Lknown_transpose_bytes]
vpermb zmm11, zmm0, zmm9
vpermb zmm9, zmm0, zmm10
vpermb zmm10, zmm0, zmm4
vpermb zmm8, zmm0, zmm3
vpermb zmm12, zmm0, zmm2
vpermb zmm13, zmm0, zmm6
vpermb zmm14, zmm0, zmm5
vpermb zmm15, zmm0, zmm7
vshufi64x2 zmm4, zmm8, zmm8, 0
vgf2p8affineqb zmm0, zmm4, [rsi + 0], 0
vgf2p8affineqb zmm1, zmm4, [rsi + 64], 0
vgf2p8affineqb zmm2, zmm4, [rsi + 128], 0
vgf2p8affineqb zmm3, zmm4, [rsi + 192], 0
vshufi64x2 zmm4, zmm8, zmm8, 85
vshufi64x2 zmm5, zmm8, zmm8, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 256], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 512], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 320], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 576], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 384], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 640], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 448], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 704], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm8, zmm8, 255
vshufi64x2 zmm5, zmm9, zmm9, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 768], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1024], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 832], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1088], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 896], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1152], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 960], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1216], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm9, zmm9, 85
vshufi64x2 zmm5, zmm9, zmm9, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 1280], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1536], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1344], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1600], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1408], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1664], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1472], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 1728], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm9, zmm9, 255
vshufi64x2 zmm5, zmm10, zmm10, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 1792], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2048], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1856], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2112], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1920], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2176], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 1984], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2240], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm10, zmm10, 85
vshufi64x2 zmm5, zmm10, zmm10, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 2304], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2560], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2624], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 2432], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2688], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 2496], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 2752], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm10, zmm10, 255
vshufi64x2 zmm5, zmm11, zmm11, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 2816], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3072], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3136], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 2944], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3200], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3264], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm11, zmm11, 85
vshufi64x2 zmm5, zmm11, zmm11, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 3328], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3584], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3648], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3456], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3712], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 3776], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm11, zmm11, 255
vshufi64x2 zmm5, zmm12, zmm12, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 3840], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4096], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4160], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 3968], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4224], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4288], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm12, zmm12, 85
vshufi64x2 zmm5, zmm12, zmm12, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 4352], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4608], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4416], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4672], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4480], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4736], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4544], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 4800], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm12, zmm12, 255
vshufi64x2 zmm5, zmm13, zmm13, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 4864], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5120], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4928], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5184], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 4992], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5248], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 5056], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5312], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm13, zmm13, 85
vshufi64x2 zmm5, zmm13, zmm13, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 5376], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5632], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 5440], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5696], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 5504], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5760], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 5568], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 5824], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm13, zmm13, 255
vshufi64x2 zmm5, zmm14, zmm14, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 5888], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6144], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 5952], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6208], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6016], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6272], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6080], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6336], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm14, zmm14, 85
vshufi64x2 zmm5, zmm14, zmm14, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 6400], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6656], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6464], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6720], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6528], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6784], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6592], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 6848], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm14, zmm14, 255
vshufi64x2 zmm5, zmm15, zmm15, 0
vgf2p8affineqb zmm6, zmm4, [rsi + 6912], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7168], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 6976], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7232], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 7040], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7296], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 7104], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7360], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm15, zmm15, 85
vshufi64x2 zmm5, zmm15, zmm15, 170
vgf2p8affineqb zmm6, zmm4, [rsi + 7424], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7680], 0
vpternlogq zmm0, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 7488], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7744], 0
vpternlogq zmm1, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 7552], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7808], 0
vpternlogq zmm2, zmm6, zmm7, 0x96
vgf2p8affineqb zmm6, zmm4, [rsi + 7616], 0
vgf2p8affineqb zmm7, zmm5, [rsi + 7872], 0
vpternlogq zmm3, zmm6, zmm7, 0x96
vshufi64x2 zmm4, zmm15, zmm15, 255
vgf2p8affineqb zmm6, zmm4, [rsi + 7936], 0
vpxorq zmm0, zmm0, zmm6
vgf2p8affineqb zmm6, zmm4, [rsi + 8000], 0
vpxorq zmm1, zmm1, zmm6
vgf2p8affineqb zmm6, zmm4, [rsi + 8064], 0
vpxorq zmm2, zmm2, zmm6
vgf2p8affineqb zmm6, zmm4, [rsi + 8128], 0
vpxorq zmm3, zmm3, zmm6
vpshufd zmm4, zmm0, 0x4e
vpxorq zmm0, zmm0, zmm4
vpshufd zmm4, zmm1, 0x4e
vpxorq zmm1, zmm1, zmm4
vpshufd zmm4, zmm2, 0x4e
vpxorq zmm2, zmm2, zmm4
vpshufd zmm4, zmm3, 0x4e
vpxorq zmm3, zmm3, zmm4
vmovdqa64 zmm4, [rip + .Lknown_pack]
vpermi2b zmm4, zmm0, zmm1
vmovdqa64 zmm5, [rip + .Lknown_pack]
vpermi2b zmm5, zmm2, zmm3
vmovdqa64 zmm8, [rip + .Lknown_out_even]
vpermi2b zmm8, zmm4, zmm5
vmovdqa64 zmm9, [rip + .Lknown_out_odd]
vpermi2b zmm9, zmm4, zmm5
ret
.size flock_c8_edges_common,.-flock_c8_edges_common
.p2align 5
.globl flock_c8_edges_base0
.hidden flock_c8_edges_base0
.type flock_c8_edges_base0,@function
flock_c8_edges_base0:
vmovdqu64 zmm0, [rdi + 0]
vmovdqu64 zmm1, [rdi + 64]
vmovdqu64 zmm2, [rdi + 128]
vmovdqu64 zmm3, [rdi + 192]
vmovdqu64 zmm4, [rdi + 256]
vmovdqu64 zmm5, [rdi + 320]
vmovdqu64 zmm6, [rdi + 384]
vmovdqu64 zmm7, [rdi + 448]
jmp flock_c8_edges_common
.size flock_c8_edges_base0,.-flock_c8_edges_base0
.p2align 5
.globl flock_c8_edges_base1
.hidden flock_c8_edges_base1
.type flock_c8_edges_base1,@function
flock_c8_edges_base1:
vmovdqu64 zmm0, [rdi + 1536]
vmovdqu64 zmm1, [rdi + 1600]
vmovdqu64 zmm2, [rdi + 1664]
vmovdqu64 zmm3, [rdi + 1728]
vmovdqu64 zmm4, [rdi + 1792]
vmovdqu64 zmm5, [rdi + 1856]
vmovdqu64 zmm6, [rdi + 1920]
vmovdqu64 zmm7, [rdi + 1984]
jmp flock_c8_edges_common
.size flock_c8_edges_base1,.-flock_c8_edges_base1
.p2align 5
.globl flock_c8_edges_base2
.hidden flock_c8_edges_base2
.type flock_c8_edges_base2,@function
flock_c8_edges_base2:
vmovdqu64 zmm0, [rdi + 2048]
vmovdqu64 zmm1, [rdi + 2112]
vmovdqu64 zmm2, [rdi + 2176]
vmovdqu64 zmm3, [rdi + 2240]
vmovdqu64 zmm4, [rdi + 2304]
vmovdqu64 zmm5, [rdi + 2368]
vmovdqu64 zmm6, [rdi + 2432]
vmovdqu64 zmm7, [rdi + 2496]
jmp flock_c8_edges_common
.size flock_c8_edges_base2,.-flock_c8_edges_base2
.p2align 5
.globl flock_c8_edges_base3
.hidden flock_c8_edges_base3
.type flock_c8_edges_base3,@function
flock_c8_edges_base3:
vmovdqu64 zmm0, [rdi + 3584]
vmovdqu64 zmm1, [rdi + 3648]
vmovdqu64 zmm2, [rdi + 3712]
vmovdqu64 zmm3, [rdi + 3776]
vmovdqu64 zmm4, [rdi + 3840]
vmovdqu64 zmm5, [rdi + 3904]
vmovdqu64 zmm6, [rdi + 3968]
vmovdqu64 zmm7, [rdi + 4032]
jmp flock_c8_edges_common
.size flock_c8_edges_base3,.-flock_c8_edges_base3
.p2align 5
.globl flock_c8_edges_base4
.hidden flock_c8_edges_base4
.type flock_c8_edges_base4,@function
flock_c8_edges_base4:
vmovdqu64 zmm0, [rdi + 4096]
vmovdqu64 zmm1, [rdi + 4160]
vmovdqu64 zmm2, [rdi + 4224]
vmovdqu64 zmm3, [rdi + 4288]
vmovdqu64 zmm4, [rdi + 4352]
vmovdqu64 zmm5, [rdi + 4416]
vmovdqu64 zmm6, [rdi + 4480]
vmovdqu64 zmm7, [rdi + 4544]
jmp flock_c8_edges_common
.size flock_c8_edges_base4,.-flock_c8_edges_base4
.p2align 5
.globl flock_c8_edges_base5
.hidden flock_c8_edges_base5
.type flock_c8_edges_base5,@function
flock_c8_edges_base5:
vmovdqu64 zmm0, [rdi + 5632]
vmovdqu64 zmm1, [rdi + 5696]
vmovdqu64 zmm2, [rdi + 5760]
vmovdqu64 zmm3, [rdi + 5824]
vmovdqu64 zmm4, [rdi + 5888]
vmovdqu64 zmm5, [rdi + 5952]
vmovdqu64 zmm6, [rdi + 6016]
vmovdqu64 zmm7, [rdi + 6080]
jmp flock_c8_edges_common
.size flock_c8_edges_base5,.-flock_c8_edges_base5
.p2align 5
.globl flock_c8_edges_base6
.hidden flock_c8_edges_base6
.type flock_c8_edges_base6,@function
flock_c8_edges_base6:
vmovdqu64 zmm0, [rdi + 6144]
vmovdqu64 zmm1, [rdi + 6208]
vmovdqu64 zmm2, [rdi + 6272]
vmovdqu64 zmm3, [rdi + 6336]
vmovdqu64 zmm4, [rdi + 6400]
vmovdqu64 zmm5, [rdi + 6464]
vmovdqu64 zmm6, [rdi + 6528]
vmovdqu64 zmm7, [rdi + 6592]
jmp flock_c8_edges_common
.size flock_c8_edges_base6,.-flock_c8_edges_base6
.p2align 5
.globl flock_c8_edges_base7
.hidden flock_c8_edges_base7
.type flock_c8_edges_base7,@function
flock_c8_edges_base7:
vmovdqu64 zmm0, [rdi + 7680]
vmovdqu64 zmm1, [rdi + 7744]
vmovdqu64 zmm2, [rdi + 7808]
vmovdqu64 zmm3, [rdi + 7872]
vmovdqu64 zmm4, [rdi + 7936]
vmovdqu64 zmm5, [rdi + 8000]
vmovdqu64 zmm6, [rdi + 8064]
vmovdqu64 zmm7, [rdi + 8128]
jmp flock_c8_edges_common
.size flock_c8_edges_base7,.-flock_c8_edges_base7
.p2align 5
.globl flock_c8_edges_base8
.hidden flock_c8_edges_base8
.type flock_c8_edges_base8,@function
flock_c8_edges_base8:
vmovdqu64 zmm0, [rdi + 8192]
vmovdqu64 zmm1, [rdi + 8256]
vmovdqu64 zmm2, [rdi + 8320]
vmovdqu64 zmm3, [rdi + 8384]
vmovdqu64 zmm4, [rdi + 8448]
vmovdqu64 zmm5, [rdi + 8512]
vmovdqu64 zmm6, [rdi + 8576]
vmovdqu64 zmm7, [rdi + 8640]
jmp flock_c8_edges_common
.size flock_c8_edges_base8,.-flock_c8_edges_base8
.p2align 5
.globl flock_c8_edges_base9
.hidden flock_c8_edges_base9
.type flock_c8_edges_base9,@function
flock_c8_edges_base9:
vmovdqu64 zmm0, [rdi + 9728]
vmovdqu64 zmm1, [rdi + 9792]
vmovdqu64 zmm2, [rdi + 9856]
vmovdqu64 zmm3, [rdi + 9920]
vmovdqu64 zmm4, [rdi + 9984]
vmovdqu64 zmm5, [rdi + 10048]
vmovdqu64 zmm6, [rdi + 10112]
vmovdqu64 zmm7, [rdi + 10176]
jmp flock_c8_edges_common
.size flock_c8_edges_base9,.-flock_c8_edges_base9
.p2align 5
.globl flock_c8_edges_base10
.hidden flock_c8_edges_base10
.type flock_c8_edges_base10,@function
flock_c8_edges_base10:
vmovdqu64 zmm0, [rdi + 10240]
vmovdqu64 zmm1, [rdi + 10304]
vmovdqu64 zmm2, [rdi + 10368]
vmovdqu64 zmm3, [rdi + 10432]
vmovdqu64 zmm4, [rdi + 10496]
vmovdqu64 zmm5, [rdi + 10560]
vmovdqu64 zmm6, [rdi + 10624]
vmovdqu64 zmm7, [rdi + 10688]
jmp flock_c8_edges_common
.size flock_c8_edges_base10,.-flock_c8_edges_base10
.p2align 5
.globl flock_c8_edges_base11
.hidden flock_c8_edges_base11
.type flock_c8_edges_base11,@function
flock_c8_edges_base11:
vmovdqu64 zmm0, [rdi + 11776]
vmovdqu64 zmm1, [rdi + 11840]
vmovdqu64 zmm2, [rdi + 11904]
vmovdqu64 zmm3, [rdi + 11968]
vmovdqu64 zmm4, [rdi + 12032]
vmovdqu64 zmm5, [rdi + 12096]
vmovdqu64 zmm6, [rdi + 12160]
vmovdqu64 zmm7, [rdi + 12224]
jmp flock_c8_edges_common
.size flock_c8_edges_base11,.-flock_c8_edges_base11
.p2align 5
.globl flock_c8_edges_base12
.hidden flock_c8_edges_base12
.type flock_c8_edges_base12,@function
flock_c8_edges_base12:
vmovdqu64 zmm0, [rdi + 12288]
vmovdqu64 zmm1, [rdi + 12352]
vmovdqu64 zmm2, [rdi + 12416]
vmovdqu64 zmm3, [rdi + 12480]
vmovdqu64 zmm4, [rdi + 12544]
vmovdqu64 zmm5, [rdi + 12608]
vmovdqu64 zmm6, [rdi + 12672]
vmovdqu64 zmm7, [rdi + 12736]
jmp flock_c8_edges_common
.size flock_c8_edges_base12,.-flock_c8_edges_base12
.p2align 5
.globl flock_c8_edges_base13
.hidden flock_c8_edges_base13
.type flock_c8_edges_base13,@function
flock_c8_edges_base13:
vmovdqu64 zmm0, [rdi + 13824]
vmovdqu64 zmm1, [rdi + 13888]
vmovdqu64 zmm2, [rdi + 13952]
vmovdqu64 zmm3, [rdi + 14016]
vmovdqu64 zmm4, [rdi + 14080]
vmovdqu64 zmm5, [rdi + 14144]
vmovdqu64 zmm6, [rdi + 14208]
vmovdqu64 zmm7, [rdi + 14272]
jmp flock_c8_edges_common
.size flock_c8_edges_base13,.-flock_c8_edges_base13
.p2align 5
.globl flock_c8_edges_base14
.hidden flock_c8_edges_base14
.type flock_c8_edges_base14,@function
flock_c8_edges_base14:
vmovdqu64 zmm0, [rdi + 14336]
vmovdqu64 zmm1, [rdi + 14400]
vmovdqu64 zmm2, [rdi + 14464]
vmovdqu64 zmm3, [rdi + 14528]
vmovdqu64 zmm4, [rdi + 14592]
vmovdqu64 zmm5, [rdi + 14656]
vmovdqu64 zmm6, [rdi + 14720]
vmovdqu64 zmm7, [rdi + 14784]
jmp flock_c8_edges_common
.size flock_c8_edges_base14,.-flock_c8_edges_base14
.p2align 5
.globl flock_c8_edges_base15
.hidden flock_c8_edges_base15
.type flock_c8_edges_base15,@function
flock_c8_edges_base15:
vmovdqu64 zmm0, [rdi + 15872]
vmovdqu64 zmm1, [rdi + 15936]
vmovdqu64 zmm2, [rdi + 16000]
vmovdqu64 zmm3, [rdi + 16064]
vmovdqu64 zmm4, [rdi + 16128]
vmovdqu64 zmm5, [rdi + 16192]
vmovdqu64 zmm6, [rdi + 16256]
vmovdqu64 zmm7, [rdi + 16320]
jmp flock_c8_edges_common
.size flock_c8_edges_base15,.-flock_c8_edges_base15
.p2align 5
.globl flock_c8_edges_pack0
.hidden flock_c8_edges_pack0
.type flock_c8_edges_pack0,@function
flock_c8_edges_pack0:
vmovdqu64 zmm0, [rdi + 128]
vmovdqu64 zmm1, [rdi + 192]
vmovdqu64 zmm2, [rdi + 256]
vmovdqu64 zmm3, [rdi + 320]
vmovdqu64 zmm4, [rdi + 384]
vmovdqu64 zmm5, [rdi + 448]
vmovdqu64 zmm6, [rdi + 1536]
vmovdqu64 zmm7, [rdi + 1600]
jmp flock_c8_edges_common
.size flock_c8_edges_pack0,.-flock_c8_edges_pack0
.p2align 5
.globl flock_c8_edges_pack1
.hidden flock_c8_edges_pack1
.type flock_c8_edges_pack1,@function
flock_c8_edges_pack1:
vmovdqu64 zmm0, [rdi + 1664]
vmovdqu64 zmm1, [rdi + 1728]
vmovdqu64 zmm2, [rdi + 1792]
vmovdqu64 zmm3, [rdi + 1856]
vmovdqu64 zmm4, [rdi + 2176]
vmovdqu64 zmm5, [rdi + 2240]
vmovdqu64 zmm6, [rdi + 2304]
vmovdqu64 zmm7, [rdi + 2368]
jmp flock_c8_edges_common
.size flock_c8_edges_pack1,.-flock_c8_edges_pack1
.p2align 5
.globl flock_c8_edges_pack2
.hidden flock_c8_edges_pack2
.type flock_c8_edges_pack2,@function
flock_c8_edges_pack2:
vmovdqu64 zmm0, [rdi + 2432]
vmovdqu64 zmm1, [rdi + 2496]
vmovdqu64 zmm2, [rdi + 3584]
vmovdqu64 zmm3, [rdi + 3648]
vmovdqu64 zmm4, [rdi + 3712]
vmovdqu64 zmm5, [rdi + 3776]
vmovdqu64 zmm6, [rdi + 3840]
vmovdqu64 zmm7, [rdi + 3904]
jmp flock_c8_edges_common
.size flock_c8_edges_pack2,.-flock_c8_edges_pack2
.p2align 5
.globl flock_c8_edges_pack3
.hidden flock_c8_edges_pack3
.type flock_c8_edges_pack3,@function
flock_c8_edges_pack3:
vmovdqu64 zmm0, [rdi + 4224]
vmovdqu64 zmm1, [rdi + 4288]
vmovdqu64 zmm2, [rdi + 4352]
vmovdqu64 zmm3, [rdi + 4416]
vmovdqu64 zmm4, [rdi + 4480]
vmovdqu64 zmm5, [rdi + 4544]
vmovdqu64 zmm6, [rdi + 5632]
vmovdqu64 zmm7, [rdi + 5696]
jmp flock_c8_edges_common
.size flock_c8_edges_pack3,.-flock_c8_edges_pack3
.p2align 5
.globl flock_c8_edges_pack4
.hidden flock_c8_edges_pack4
.type flock_c8_edges_pack4,@function
flock_c8_edges_pack4:
vmovdqu64 zmm0, [rdi + 5760]
vmovdqu64 zmm1, [rdi + 5824]
vmovdqu64 zmm2, [rdi + 5888]
vmovdqu64 zmm3, [rdi + 5952]
vmovdqu64 zmm4, [rdi + 6272]
vmovdqu64 zmm5, [rdi + 6336]
vmovdqu64 zmm6, [rdi + 6400]
vmovdqu64 zmm7, [rdi + 6464]
jmp flock_c8_edges_common
.size flock_c8_edges_pack4,.-flock_c8_edges_pack4
.p2align 5
.globl flock_c8_edges_pack5
.hidden flock_c8_edges_pack5
.type flock_c8_edges_pack5,@function
flock_c8_edges_pack5:
vmovdqu64 zmm0, [rdi + 6528]
vmovdqu64 zmm1, [rdi + 6592]
vmovdqu64 zmm2, [rdi + 7680]
vmovdqu64 zmm3, [rdi + 7744]
vmovdqu64 zmm4, [rdi + 7808]
vmovdqu64 zmm5, [rdi + 7872]
vmovdqu64 zmm6, [rdi + 7936]
vmovdqu64 zmm7, [rdi + 8000]
jmp flock_c8_edges_common
.size flock_c8_edges_pack5,.-flock_c8_edges_pack5
.p2align 5
.globl flock_c8_edges_pack6
.hidden flock_c8_edges_pack6
.type flock_c8_edges_pack6,@function
flock_c8_edges_pack6:
vmovdqu64 zmm0, [rdi + 8320]
vmovdqu64 zmm1, [rdi + 8384]
vmovdqu64 zmm2, [rdi + 8448]
vmovdqu64 zmm3, [rdi + 8512]
vmovdqu64 zmm4, [rdi + 8576]
vmovdqu64 zmm5, [rdi + 8640]
vmovdqu64 zmm6, [rdi + 9728]
vmovdqu64 zmm7, [rdi + 9792]
jmp flock_c8_edges_common
.size flock_c8_edges_pack6,.-flock_c8_edges_pack6
.p2align 5
.globl flock_c8_edges_pack7
.hidden flock_c8_edges_pack7
.type flock_c8_edges_pack7,@function
flock_c8_edges_pack7:
vmovdqu64 zmm0, [rdi + 9856]
vmovdqu64 zmm1, [rdi + 9920]
vmovdqu64 zmm2, [rdi + 9984]
vmovdqu64 zmm3, [rdi + 10048]
vmovdqu64 zmm4, [rdi + 10368]
vmovdqu64 zmm5, [rdi + 10432]
vmovdqu64 zmm6, [rdi + 10496]
vmovdqu64 zmm7, [rdi + 10560]
jmp flock_c8_edges_common
.size flock_c8_edges_pack7,.-flock_c8_edges_pack7
.p2align 5
.globl flock_c8_edges_pack8
.hidden flock_c8_edges_pack8
.type flock_c8_edges_pack8,@function
flock_c8_edges_pack8:
vmovdqu64 zmm0, [rdi + 10624]
vmovdqu64 zmm1, [rdi + 10688]
vmovdqu64 zmm2, [rdi + 11776]
vmovdqu64 zmm3, [rdi + 11840]
vmovdqu64 zmm4, [rdi + 11904]
vmovdqu64 zmm5, [rdi + 11968]
vmovdqu64 zmm6, [rdi + 12032]
vmovdqu64 zmm7, [rdi + 12096]
jmp flock_c8_edges_common
.size flock_c8_edges_pack8,.-flock_c8_edges_pack8
.p2align 5
.globl flock_c8_edges_pack9
.hidden flock_c8_edges_pack9
.type flock_c8_edges_pack9,@function
flock_c8_edges_pack9:
vmovdqu64 zmm0, [rdi + 12416]
vmovdqu64 zmm1, [rdi + 12480]
vmovdqu64 zmm2, [rdi + 12544]
vmovdqu64 zmm3, [rdi + 12608]
vmovdqu64 zmm4, [rdi + 12672]
vmovdqu64 zmm5, [rdi + 12736]
vmovdqu64 zmm6, [rdi + 13824]
vmovdqu64 zmm7, [rdi + 13888]
jmp flock_c8_edges_common
.size flock_c8_edges_pack9,.-flock_c8_edges_pack9
.p2align 5
.globl flock_c8_edges_pack10
.hidden flock_c8_edges_pack10
.type flock_c8_edges_pack10,@function
flock_c8_edges_pack10:
vmovdqu64 zmm0, [rdi + 13952]
vmovdqu64 zmm1, [rdi + 14016]
vmovdqu64 zmm2, [rdi + 14080]
vmovdqu64 zmm3, [rdi + 14144]
vmovdqu64 zmm4, [rdi + 14464]
vmovdqu64 zmm5, [rdi + 14528]
vmovdqu64 zmm6, [rdi + 14592]
vmovdqu64 zmm7, [rdi + 14656]
jmp flock_c8_edges_common
.size flock_c8_edges_pack10,.-flock_c8_edges_pack10
.p2align 5
.globl flock_c8_edges_pack11
.hidden flock_c8_edges_pack11
.type flock_c8_edges_pack11,@function
flock_c8_edges_pack11:
vmovdqu64 zmm0, [rdi + 14720]
vmovdqu64 zmm1, [rdi + 14784]
vmovdqu64 zmm2, [rdi + 15872]
vmovdqu64 zmm3, [rdi + 15936]
vmovdqu64 zmm4, [rdi + 16000]
vmovdqu64 zmm5, [rdi + 16064]
vmovdqu64 zmm6, [rdi + 16128]
vmovdqu64 zmm7, [rdi + 16192]
jmp flock_c8_edges_common
.size flock_c8_edges_pack11,.-flock_c8_edges_pack11
.p2align 5
.globl flock_c8_edges_baseline
.hidden flock_c8_edges_baseline
.type flock_c8_edges_baseline,@function
flock_c8_edges_baseline:
call flock_c8_edges_base0
vmovdqu64 [rdx + 0], zmm8
vmovdqu64 [rdx + 64], zmm9
call flock_c8_edges_base1
vmovdqu64 [rdx + 128], zmm8
vmovdqu64 [rdx + 192], zmm9
call flock_c8_edges_base2
vmovdqu64 [rdx + 256], zmm8
vmovdqu64 [rdx + 320], zmm9
call flock_c8_edges_base3
vmovdqu64 [rdx + 384], zmm8
vmovdqu64 [rdx + 448], zmm9
call flock_c8_edges_base4
vmovdqu64 [rdx + 512], zmm8
vmovdqu64 [rdx + 576], zmm9
call flock_c8_edges_base5
vmovdqu64 [rdx + 640], zmm8
vmovdqu64 [rdx + 704], zmm9
call flock_c8_edges_base6
vmovdqu64 [rdx + 768], zmm8
vmovdqu64 [rdx + 832], zmm9
call flock_c8_edges_base7
vmovdqu64 [rdx + 896], zmm8
vmovdqu64 [rdx + 960], zmm9
call flock_c8_edges_base8
vmovdqu64 [rdx + 1024], zmm8
vmovdqu64 [rdx + 1088], zmm9
call flock_c8_edges_base9
vmovdqu64 [rdx + 1152], zmm8
vmovdqu64 [rdx + 1216], zmm9
call flock_c8_edges_base10
vmovdqu64 [rdx + 1280], zmm8
vmovdqu64 [rdx + 1344], zmm9
call flock_c8_edges_base11
vmovdqu64 [rdx + 1408], zmm8
vmovdqu64 [rdx + 1472], zmm9
call flock_c8_edges_base12
vmovdqu64 [rdx + 1536], zmm8
vmovdqu64 [rdx + 1600], zmm9
call flock_c8_edges_base13
vmovdqu64 [rdx + 1664], zmm8
vmovdqu64 [rdx + 1728], zmm9
call flock_c8_edges_base14
vmovdqu64 [rdx + 1792], zmm8
vmovdqu64 [rdx + 1856], zmm9
call flock_c8_edges_base15
vmovdqu64 [rdx + 1920], zmm8
vmovdqu64 [rdx + 1984], zmm9
xor eax, eax
ret
.size flock_c8_edges_baseline,.-flock_c8_edges_baseline
.p2align 5
.globl flock_c8_edges_compact
.hidden flock_c8_edges_compact
.type flock_c8_edges_compact,@function
flock_c8_edges_compact:
vpxord zmm1, zmm1, zmm1
vpternlogd zmm0, zmm0, zmm0, 255
vmovdqa64 zmm2, [rip + .Ledges_expected_tail]
vpternlogq zmm1, zmm0, [rdi + 0], 246
vpternlogq zmm1, zmm0, [rdi + 64], 246
vpternlogq zmm1, zmm2, [rdi + 1920], 246
vporq zmm1, zmm1, [rdi + 1984]
vpternlogq zmm1, zmm0, [rdi + 2048], 246
vpternlogq zmm1, zmm0, [rdi + 2112], 246
vpternlogq zmm1, zmm2, [rdi + 3968], 246
vporq zmm1, zmm1, [rdi + 4032]
vpternlogq zmm1, zmm0, [rdi + 4096], 246
vpternlogq zmm1, zmm0, [rdi + 4160], 246
vpternlogq zmm1, zmm2, [rdi + 6016], 246
vporq zmm1, zmm1, [rdi + 6080]
vpternlogq zmm1, zmm0, [rdi + 6144], 246
vpternlogq zmm1, zmm0, [rdi + 6208], 246
vpternlogq zmm1, zmm2, [rdi + 8064], 246
vporq zmm1, zmm1, [rdi + 8128]
vpternlogq zmm1, zmm0, [rdi + 8192], 246
vpternlogq zmm1, zmm0, [rdi + 8256], 246
vpternlogq zmm1, zmm2, [rdi + 10112], 246
vporq zmm1, zmm1, [rdi + 10176]
vpternlogq zmm1, zmm0, [rdi + 10240], 246
vpternlogq zmm1, zmm0, [rdi + 10304], 246
vpternlogq zmm1, zmm2, [rdi + 12160], 246
vporq zmm1, zmm1, [rdi + 12224]
vpternlogq zmm1, zmm0, [rdi + 12288], 246
vpternlogq zmm1, zmm0, [rdi + 12352], 246
vpternlogq zmm1, zmm2, [rdi + 14208], 246
vporq zmm1, zmm1, [rdi + 14272]
vpternlogq zmm1, zmm0, [rdi + 14336], 246
vpternlogq zmm1, zmm0, [rdi + 14400], 246
vpternlogq zmm1, zmm2, [rdi + 16256], 246
vporq zmm1, zmm1, [rdi + 16320]
vptestmq k1, zmm1, zmm1
kortestw k1, k1
jnz flock_c8_edges_baseline
mov eax, 3
kmovw k1, eax
knotw k4, k1
mov eax, 15
kmovw k2, eax
knotw k5, k2
mov eax, 63
kmovw k3, eax
knotw k6, k3
call flock_c8_edges_pack0
vmovdqu64 [rdx + 16] {k3}, zmm8
vmovdqu64 [rdx + 80] {k6}, zmm8
vmovdqu64 [rdx + 80] {k3}, zmm9
vmovdqu64 [rdx + 144] {k6}, zmm9
call flock_c8_edges_pack1
vmovdqu64 [rdx + 144] {k2}, zmm8
vmovdqu64 [rdx + 240] {k5}, zmm8
vmovdqu64 [rdx + 208] {k2}, zmm9
vmovdqu64 [rdx + 304] {k5}, zmm9
call flock_c8_edges_pack2
vmovdqu64 [rdx + 304] {k1}, zmm8
vmovdqu64 [rdx + 368] {k4}, zmm8
vmovdqu64 [rdx + 368] {k1}, zmm9
vmovdqu64 [rdx + 432] {k4}, zmm9
call flock_c8_edges_pack3
vmovdqu64 [rdx + 528] {k3}, zmm8
vmovdqu64 [rdx + 592] {k6}, zmm8
vmovdqu64 [rdx + 592] {k3}, zmm9
vmovdqu64 [rdx + 656] {k6}, zmm9
call flock_c8_edges_pack4
vmovdqu64 [rdx + 656] {k2}, zmm8
vmovdqu64 [rdx + 752] {k5}, zmm8
vmovdqu64 [rdx + 720] {k2}, zmm9
vmovdqu64 [rdx + 816] {k5}, zmm9
call flock_c8_edges_pack5
vmovdqu64 [rdx + 816] {k1}, zmm8
vmovdqu64 [rdx + 880] {k4}, zmm8
vmovdqu64 [rdx + 880] {k1}, zmm9
vmovdqu64 [rdx + 944] {k4}, zmm9
call flock_c8_edges_pack6
vmovdqu64 [rdx + 1040] {k3}, zmm8
vmovdqu64 [rdx + 1104] {k6}, zmm8
vmovdqu64 [rdx + 1104] {k3}, zmm9
vmovdqu64 [rdx + 1168] {k6}, zmm9
call flock_c8_edges_pack7
vmovdqu64 [rdx + 1168] {k2}, zmm8
vmovdqu64 [rdx + 1264] {k5}, zmm8
vmovdqu64 [rdx + 1232] {k2}, zmm9
vmovdqu64 [rdx + 1328] {k5}, zmm9
call flock_c8_edges_pack8
vmovdqu64 [rdx + 1328] {k1}, zmm8
vmovdqu64 [rdx + 1392] {k4}, zmm8
vmovdqu64 [rdx + 1392] {k1}, zmm9
vmovdqu64 [rdx + 1456] {k4}, zmm9
call flock_c8_edges_pack9
vmovdqu64 [rdx + 1552] {k3}, zmm8
vmovdqu64 [rdx + 1616] {k6}, zmm8
vmovdqu64 [rdx + 1616] {k3}, zmm9
vmovdqu64 [rdx + 1680] {k6}, zmm9
call flock_c8_edges_pack10
vmovdqu64 [rdx + 1680] {k2}, zmm8
vmovdqu64 [rdx + 1776] {k5}, zmm8
vmovdqu64 [rdx + 1744] {k2}, zmm9
vmovdqu64 [rdx + 1840] {k5}, zmm9
call flock_c8_edges_pack11
vmovdqu64 [rdx + 1840] {k1}, zmm8
vmovdqu64 [rdx + 1904] {k4}, zmm8
vmovdqu64 [rdx + 1904] {k1}, zmm9
vmovdqu64 [rdx + 1968] {k4}, zmm9
vmovdqu xmm0, [rcx]
vmovdqu xmm1, [rcx + 16]
vpxord xmm2, xmm2, xmm2
vmovdqu [rdx + 0], xmm0
vmovdqu [rdx + 64], xmm0
vmovdqu [rdx + 176], xmm1
vmovdqu [rdx + 240], xmm2
vmovdqu [rdx + 256], xmm0
vmovdqu [rdx + 320], xmm0
vmovdqu [rdx + 432], xmm1
vmovdqu [rdx + 496], xmm2
vmovdqu [rdx + 512], xmm0
vmovdqu [rdx + 576], xmm0
vmovdqu [rdx + 688], xmm1
vmovdqu [rdx + 752], xmm2
vmovdqu [rdx + 768], xmm0
vmovdqu [rdx + 832], xmm0
vmovdqu [rdx + 944], xmm1
vmovdqu [rdx + 1008], xmm2
vmovdqu [rdx + 1024], xmm0
vmovdqu [rdx + 1088], xmm0
vmovdqu [rdx + 1200], xmm1
vmovdqu [rdx + 1264], xmm2
vmovdqu [rdx + 1280], xmm0
vmovdqu [rdx + 1344], xmm0
vmovdqu [rdx + 1456], xmm1
vmovdqu [rdx + 1520], xmm2
vmovdqu [rdx + 1536], xmm0
vmovdqu [rdx + 1600], xmm0
vmovdqu [rdx + 1712], xmm1
vmovdqu [rdx + 1776], xmm2
vmovdqu [rdx + 1792], xmm0
vmovdqu [rdx + 1856], xmm0
vmovdqu [rdx + 1968], xmm1
vmovdqu [rdx + 2032], xmm2
mov eax, 1
ret
.size flock_c8_edges_compact,.-flock_c8_edges_compact
.section .rodata
.p2align 6
.Lknown_transpose_bytes:
.byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
.p2align 6
.Lknown_out_even:
.byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126
.p2align 6
.Lknown_out_odd:
.byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
.p2align 6
.Lknown_pack:
.byte 0, 1, 2, 3, 4, 5, 6, 7, 16, 17, 18, 19, 20, 21, 22, 23, 32, 33, 34, 35, 36, 37, 38, 39, 48, 49, 50, 51, 52, 53, 54, 55, 64, 65, 66, 67, 68, 69, 70, 71, 80, 81, 82, 83, 84, 85, 86, 87, 96, 97, 98, 99, 100, 101, 102, 103, 112, 113, 114, 115, 116, 117, 118, 119


.section .rodata
.p2align 6
.Ledges_expected_tail:
.quad 0x1ffffffffffff,0,0,0,0,0,0,0
