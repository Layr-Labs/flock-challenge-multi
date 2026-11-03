// Exact eight-row GFNI fold. Private ABI matches Rust wrapper.
// RDI: 512 input bytes, RSI: 8192-byte matrix table; returns ZMM8/9.
// Clobbers RAX, flags, K1, ZMM0..11; preserves other registers.
.text
.p2align 6
.globl flock_gfni_c8_lm_register_result
.hidden flock_gfni_c8_lm_register_result
.type flock_gfni_c8_lm_register_result,@function
flock_gfni_c8_lm_register_result:
    mov rax, rsp
    and rsp, -64
    sub rsp, 512
    vmovdqu64 zmm0, [rdi + 0]
    vmovdqu64 zmm1, [rdi + 64]
    vmovdqu64 zmm2, [rdi + 128]
    vmovdqu64 zmm3, [rdi + 192]
    vmovdqu64 zmm4, [rdi + 256]
    vmovdqu64 zmm5, [rdi + 320]
    vmovdqu64 zmm6, [rdi + 384]
    vmovdqu64 zmm7, [rdi + 448]
    vpunpcklqdq zmm8, zmm0, zmm1
    vpunpckhqdq zmm1, zmm0, zmm1
    vmovdqa64 zmm0, zmm8
    vpunpcklqdq zmm8, zmm2, zmm3
    vpunpckhqdq zmm3, zmm2, zmm3
    vmovdqa64 zmm2, zmm8
    vpunpcklqdq zmm8, zmm4, zmm5
    vpunpckhqdq zmm5, zmm4, zmm5
    vmovdqa64 zmm4, zmm8
    vpunpcklqdq zmm8, zmm6, zmm7
    vpunpckhqdq zmm7, zmm6, zmm7
    vmovdqa64 zmm6, zmm8
    vshufi64x2 zmm8, zmm0, zmm2, 0x88
    vshufi64x2 zmm2, zmm0, zmm2, 0xdd
    vmovdqa64 zmm0, zmm8
    vshufi64x2 zmm8, zmm1, zmm3, 0x88
    vshufi64x2 zmm3, zmm1, zmm3, 0xdd
    vmovdqa64 zmm1, zmm8
    vshufi64x2 zmm8, zmm4, zmm6, 0x88
    vshufi64x2 zmm6, zmm4, zmm6, 0xdd
    vmovdqa64 zmm4, zmm8
    vshufi64x2 zmm8, zmm5, zmm7, 0x88
    vshufi64x2 zmm7, zmm5, zmm7, 0xdd
    vmovdqa64 zmm5, zmm8
    vshufi64x2 zmm8, zmm0, zmm4, 0x88
    vshufi64x2 zmm4, zmm0, zmm4, 0xdd
    vmovdqa64 zmm0, zmm8
    vshufi64x2 zmm8, zmm1, zmm5, 0x88
    vshufi64x2 zmm5, zmm1, zmm5, 0xdd
    vmovdqa64 zmm1, zmm8
    vshufi64x2 zmm8, zmm2, zmm6, 0x88
    vshufi64x2 zmm6, zmm2, zmm6, 0xdd
    vmovdqa64 zmm2, zmm8
    vshufi64x2 zmm8, zmm3, zmm7, 0x88
    vshufi64x2 zmm7, zmm3, zmm7, 0xdd
    vmovdqa64 zmm3, zmm8
    vmovdqa64 zmm8, [rip + .Lc8_transpose]
    vpermb zmm0, zmm8, zmm0
    vmovdqa64 [rsp + 0], zmm0
    vpermb zmm1, zmm8, zmm1
    vmovdqa64 [rsp + 64], zmm1
    vpermb zmm2, zmm8, zmm2
    vmovdqa64 [rsp + 128], zmm2
    vpermb zmm3, zmm8, zmm3
    vmovdqa64 [rsp + 192], zmm3
    vpermb zmm4, zmm8, zmm4
    vmovdqa64 [rsp + 256], zmm4
    vpermb zmm5, zmm8, zmm5
    vmovdqa64 [rsp + 320], zmm5
    vpermb zmm6, zmm8, zmm6
    vmovdqa64 [rsp + 384], zmm6
    vpermb zmm7, zmm8, zmm7
    vmovdqa64 [rsp + 448], zmm7
    vpbroadcastq zmm2, [rsp + 0]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4096], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 0], 0
    vmovdqa64 zmm0, zmm2
    vmovdqa64 zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 8]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4160], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 64], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 16]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4224], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 24]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4288], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 192], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 32]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4352], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 256], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 40]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4416], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 320], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 48]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4480], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 56]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4544], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 448], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 64]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4608], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 72]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4672], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 576], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 80]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4736], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 88]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4800], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 704], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 96]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4864], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 104]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4928], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 832], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 112]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4992], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 120]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5056], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 960], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 128]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5120], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 136]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5184], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1088], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 144]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5248], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 152]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5312], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1216], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 160]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5376], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 168]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5440], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1344], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 176]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5504], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 184]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5568], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1472], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 192]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5632], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 200]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5696], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1600], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 208]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5760], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 216]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5824], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1728], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 224]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5888], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 232]
    vgf2p8affineqb zmm3, zmm2, [rsi + 5952], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1856], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 240]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6016], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 248]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6080], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1984], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 256]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6144], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2048], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 264]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6208], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2112], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 272]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6272], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2176], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 280]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6336], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2240], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 288]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6400], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2304], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 296]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6464], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2368], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 304]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6528], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2432], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 312]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6592], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2496], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 320]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6656], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2560], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 328]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6720], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2624], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 336]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6784], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2688], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 344]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6848], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2752], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 352]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6912], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2816], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 360]
    vgf2p8affineqb zmm3, zmm2, [rsi + 6976], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2880], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 368]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7040], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 2944], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 376]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7104], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3008], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 384]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7168], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3072], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 392]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7232], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3136], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 400]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7296], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3200], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 408]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7360], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3264], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 416]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7424], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3328], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 424]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7488], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3392], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 432]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7552], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3456], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 440]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7616], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3520], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 448]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7680], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3584], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 456]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7744], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3648], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 464]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7808], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3712], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 472]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7872], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3776], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 480]
    vgf2p8affineqb zmm3, zmm2, [rsi + 7936], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3840], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 488]
    vgf2p8affineqb zmm3, zmm2, [rsi + 8000], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3904], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 496]
    vgf2p8affineqb zmm3, zmm2, [rsi + 8064], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 3968], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vpbroadcastq zmm2, [rsp + 504]
    vgf2p8affineqb zmm3, zmm2, [rsi + 8128], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 4032], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vmovdqa64 zmm8, [rip + .Lc8_out0]
    vpermi2b zmm8, zmm0, zmm1
    vmovdqa64 zmm9, [rip + .Lc8_out1]
    vpermi2b zmm9, zmm0, zmm1
    mov rsp, rax
    ret
.size flock_gfni_c8_lm_register_result, .-flock_gfni_c8_lm_register_result
.section .rodata
.p2align 6
.Lc8_gather:
    .quad 0, 64, 128, 192, 256, 320, 384, 448
.Lc8_transpose:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63
.Lc8_out0:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126
.Lc8_out1:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
