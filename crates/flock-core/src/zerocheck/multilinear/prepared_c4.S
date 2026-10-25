// SPDX-License-Identifier: Apache-2.0 OR MIT
// Exact composed GFNI fold, lane-major output, with a private register ABI.
// Inputs: RDI = 512 prepared/raw octet bytes, RSI = two 4 KiB matrix banks. Returns ZMM8..11 as [row-group][four-block-half], with contiguous blocks in each vector.
// Clobbers: RAX, flags, ZMM0..11. Preserves every other GPR and ZMM12..31.
// Called ONLY by the matching inline-asm wrapper, never through the C ABI.
// No vzeroupper: the upper lanes of ZMM12..15 belong to the caller.
.text
.p2align 6
.globl flock_c4_two_bank_result
.hidden flock_c4_two_bank_result
.type flock_c4_two_bank_result,@function
flock_c4_two_bank_result:
    vpbroadcastq zmm0, [rdi + 0]
    vgf2p8affineqb zmm1, zmm0, [rsi + 2048], 0
    vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
    vpbroadcastq zmm2, [rdi + 8]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2112], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 64], 0
    vpbroadcastq zmm4, [rdi + 16]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2176], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 128], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 24]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2240], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 192], 0
    vpbroadcastq zmm4, [rdi + 32]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2304], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 256], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 40]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2368], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 320], 0
    vpbroadcastq zmm4, [rdi + 48]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2432], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 384], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 56]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2496], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 448], 0
    vpbroadcastq zmm4, [rdi + 64]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2560], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 512], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 72]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2624], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 576], 0
    vpbroadcastq zmm4, [rdi + 80]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2688], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 640], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 88]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2752], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 704], 0
    vpbroadcastq zmm4, [rdi + 96]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2816], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 768], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 104]
    vgf2p8affineqb zmm3, zmm2, [rsi + 2880], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 832], 0
    vpbroadcastq zmm4, [rdi + 112]
    vgf2p8affineqb zmm5, zmm4, [rsi + 2944], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 896], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 120]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3008], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 960], 0
    vpbroadcastq zmm4, [rdi + 128]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3072], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1024], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 136]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3136], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1088], 0
    vpbroadcastq zmm4, [rdi + 144]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3200], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1152], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 152]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3264], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1216], 0
    vpbroadcastq zmm4, [rdi + 160]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3328], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1280], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 168]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3392], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1344], 0
    vpbroadcastq zmm4, [rdi + 176]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3456], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1408], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 184]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3520], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1472], 0
    vpbroadcastq zmm4, [rdi + 192]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3584], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1536], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 200]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3648], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1600], 0
    vpbroadcastq zmm4, [rdi + 208]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3712], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1664], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 216]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3776], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1728], 0
    vpbroadcastq zmm4, [rdi + 224]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3840], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1792], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 232]
    vgf2p8affineqb zmm3, zmm2, [rsi + 3904], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1856], 0
    vpbroadcastq zmm4, [rdi + 240]
    vgf2p8affineqb zmm5, zmm4, [rsi + 3968], 0
    vgf2p8affineqb zmm4, zmm4, [rsi + 1920], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 248]
    vgf2p8affineqb zmm3, zmm2, [rsi + 4032], 0
    vgf2p8affineqb zmm2, zmm2, [rsi + 1984], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vmovdqa64 zmm6, [rip + .Lflock_c4_ring_out_even]
    vmovdqa64 zmm7, [rip + .Lflock_c4_ring_out_odd]
    vmovdqa64 zmm8, zmm0
    vmovdqa64 zmm9, zmm0
    vpermt2b zmm8, zmm6, zmm1
    vpermt2b zmm9, zmm7, zmm1
    vpbroadcastq zmm0, [rdi + 256]
    vgf2p8affineqb zmm1, zmm0, [rdx + 2048], 0
    vgf2p8affineqb zmm0, zmm0, [rdx + 0], 0
    vpbroadcastq zmm2, [rdi + 264]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2112], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 64], 0
    vpbroadcastq zmm4, [rdi + 272]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2176], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 128], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 280]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2240], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 192], 0
    vpbroadcastq zmm4, [rdi + 288]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2304], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 256], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 296]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2368], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 320], 0
    vpbroadcastq zmm4, [rdi + 304]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2432], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 384], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 312]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2496], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 448], 0
    vpbroadcastq zmm4, [rdi + 320]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2560], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 512], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 328]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2624], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 576], 0
    vpbroadcastq zmm4, [rdi + 336]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2688], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 640], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 344]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2752], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 704], 0
    vpbroadcastq zmm4, [rdi + 352]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2816], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 768], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 360]
    vgf2p8affineqb zmm3, zmm2, [rdx + 2880], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 832], 0
    vpbroadcastq zmm4, [rdi + 368]
    vgf2p8affineqb zmm5, zmm4, [rdx + 2944], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 896], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 376]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3008], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 960], 0
    vpbroadcastq zmm4, [rdi + 384]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3072], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1024], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 392]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3136], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1088], 0
    vpbroadcastq zmm4, [rdi + 400]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3200], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1152], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 408]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3264], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1216], 0
    vpbroadcastq zmm4, [rdi + 416]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3328], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1280], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 424]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3392], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1344], 0
    vpbroadcastq zmm4, [rdi + 432]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3456], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1408], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 440]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3520], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1472], 0
    vpbroadcastq zmm4, [rdi + 448]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3584], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1536], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 456]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3648], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1600], 0
    vpbroadcastq zmm4, [rdi + 464]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3712], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1664], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 472]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3776], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1728], 0
    vpbroadcastq zmm4, [rdi + 480]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3840], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1792], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 488]
    vgf2p8affineqb zmm3, zmm2, [rdx + 3904], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1856], 0
    vpbroadcastq zmm4, [rdi + 496]
    vgf2p8affineqb zmm5, zmm4, [rdx + 3968], 0
    vgf2p8affineqb zmm4, zmm4, [rdx + 1920], 0
    vpternlogq zmm0, zmm2, zmm4, 0x96
    vpternlogq zmm1, zmm3, zmm5, 0x96
    vpbroadcastq zmm2, [rdi + 504]
    vgf2p8affineqb zmm3, zmm2, [rdx + 4032], 0
    vgf2p8affineqb zmm2, zmm2, [rdx + 1984], 0
    vpxorq zmm0, zmm0, zmm2
    vpxorq zmm1, zmm1, zmm3
    vmovdqa64 zmm6, [rip + .Lflock_c4_ring_out_even]
    vmovdqa64 zmm7, [rip + .Lflock_c4_ring_out_odd]
    vmovdqa64 zmm10, zmm0
    vmovdqa64 zmm11, zmm0
    vpermt2b zmm10, zmm6, zmm1
    vpermt2b zmm11, zmm7, zmm1
    ret
.size flock_c4_two_bank_result, .-flock_c4_two_bank_result
.section .rodata
.p2align 6
.Lflock_c4_ring_input:
.byte 0,4,8,12,16,20,24,28,1,5,9,13,17,21,25,29,2,6,10,14,18,22,26,30,3,7,11,15,19,23,27,31,32,36,40,44,48,52,56,60,33,37,41,45,49,53,57,61,34,38,42,46,50,54,58,62,35,39,43,47,51,55,59,63
.p2align 6
.Lflock_c4_ring_out_even:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123
.p2align 6
.Lflock_c4_ring_out_odd:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
