.text
.p2align 6
.global flock_r2_prepared_a_pair_cache
.type flock_r2_prepared_a_pair_cache,@function
flock_r2_prepared_a_pair_cache:
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm0, zmm12, zmm8, 0
vgf2p8affineqb zmm1, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm2, zmm12, zmm8, 0
vgf2p8affineqb zmm3, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm4, zmm12, zmm8, 0
vgf2p8affineqb zmm5, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm6, zmm12, zmm8, 0
vgf2p8affineqb zmm7, zmm12, zmm9, 0
vmovdqu64 zmm8, [rax + 128]
vmovdqu64 zmm9, [rax + 192]
vmovdqu64 zmm10, [rax + 256]
vmovdqu64 zmm11, [rax + 320]
vpbroadcastq zmm12, [rdi + 8]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 16]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 72]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 80]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 136]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 144]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 200]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 208]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 384]
vmovdqu64 zmm9, [rax + 448]
vmovdqu64 zmm10, [rax + 512]
vmovdqu64 zmm11, [rax + 576]
vpbroadcastq zmm12, [rdi + 24]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 32]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 88]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 96]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 152]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 160]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 216]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 224]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 640]
vmovdqu64 zmm9, [rax + 704]
vmovdqu64 zmm10, [rax + 768]
vmovdqu64 zmm11, [rax + 832]
vpbroadcastq zmm12, [rdi + 40]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 48]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 104]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 112]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 168]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 176]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 232]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 240]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 896]
vmovdqu64 zmm9, [rax + 960]
vpbroadcastq zmm12, [rdi + 56]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 120]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vpbroadcastq zmm12, [rdi + 184]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 248]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm6, zmm6, zmm12
vpxorq zmm7, zmm7, zmm13
vmovdqa64 zmm8, [rip + .Lr2pair_low]
vmovdqa64 zmm9, [rip + .Lr2pair_high]
vmovdqa64 zmm10, zmm0
vpermt2b zmm10, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm10
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm10, zmm2
vpermt2b zmm10, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm10
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm10, zmm4
vpermt2b zmm10, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 128], zmm10
vmovdqu64 [rdx + 384], zmm4
vmovdqa64 zmm10, zmm6
vpermt2b zmm10, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 192], zmm10
vmovdqu64 [rdx + 448], zmm6
mov rax, [rsi + 32]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm0, zmm12, zmm8, 0
vgf2p8affineqb zmm1, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm2, zmm12, zmm8, 0
vgf2p8affineqb zmm3, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm4, zmm12, zmm8, 0
vgf2p8affineqb zmm5, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm6, zmm12, zmm8, 0
vgf2p8affineqb zmm7, zmm12, zmm9, 0
vmovdqu64 zmm8, [rax + 128]
vmovdqu64 zmm9, [rax + 192]
vmovdqu64 zmm10, [rax + 256]
vmovdqu64 zmm11, [rax + 320]
vpbroadcastq zmm12, [rdi + 264]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 272]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 328]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 336]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 392]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 400]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 456]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 464]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 384]
vmovdqu64 zmm9, [rax + 448]
vmovdqu64 zmm10, [rax + 512]
vmovdqu64 zmm11, [rax + 576]
vpbroadcastq zmm12, [rdi + 280]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 288]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 344]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 352]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 408]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 416]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 472]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 480]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 640]
vmovdqu64 zmm9, [rax + 704]
vmovdqu64 zmm10, [rax + 768]
vmovdqu64 zmm11, [rax + 832]
vpbroadcastq zmm12, [rdi + 296]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 304]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 360]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 368]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 424]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 432]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 488]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 496]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 896]
vmovdqu64 zmm9, [rax + 960]
vpbroadcastq zmm12, [rdi + 312]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 376]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vpbroadcastq zmm12, [rdi + 440]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 504]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm6, zmm6, zmm12
vpxorq zmm7, zmm7, zmm13
vmovdqa64 zmm8, [rip + .Lr2pair_low]
vmovdqa64 zmm9, [rip + .Lr2pair_high]
vmovdqa64 zmm10, zmm0
vpermt2b zmm10, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 512], zmm10
vmovdqu64 [rdx + 768], zmm0
vmovdqa64 zmm10, zmm2
vpermt2b zmm10, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 576], zmm10
vmovdqu64 [rdx + 832], zmm2
vmovdqa64 zmm10, zmm4
vpermt2b zmm10, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm10
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm10, zmm6
vpermt2b zmm10, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm10
vmovdqu64 [rdx + 960], zmm6
ret
.size flock_r2_prepared_a_pair_cache, .-flock_r2_prepared_a_pair_cache
.section .rodata
.p2align 6
.Lr2pair_low:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123
.p2align 6
.Lr2pair_high:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
