.text
.p2align 6
.global flock_r2_prepared_prefold
.type flock_r2_prepared_prefold,@function
flock_r2_prepared_prefold:
vmovdqa64 zmm6, [rip + .Lr2prep_low]
vmovdqa64 zmm7, [rip + .Lr2prep_high]
mov rax, [rsi + 0]
vpbroadcastq zmm0, [rdi + 0]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 8]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 16]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 24]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 32]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 40]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 48]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 56]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 0], zmm2
vmovdqu64 [rdx + 256], zmm0
mov rax, [rsi + 8]
vpbroadcastq zmm0, [rdi + 64]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 72]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 80]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 88]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 96]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 104]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 112]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 120]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 64], zmm2
vmovdqu64 [rdx + 320], zmm0
mov rax, [rsi + 16]
vpbroadcastq zmm0, [rdi + 128]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 136]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 144]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 152]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 160]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 168]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 176]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 184]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 128], zmm2
vmovdqu64 [rdx + 384], zmm0
mov rax, [rsi + 24]
vpbroadcastq zmm0, [rdi + 192]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 200]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 208]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 216]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 224]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 232]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 240]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 248]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 192], zmm2
vmovdqu64 [rdx + 448], zmm0
mov rax, [rsi + 32]
vpbroadcastq zmm0, [rdi + 256]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 264]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 272]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 280]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 288]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 296]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 304]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 312]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 512], zmm2
vmovdqu64 [rdx + 768], zmm0
mov rax, [rsi + 40]
vpbroadcastq zmm0, [rdi + 320]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 328]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 336]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 344]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 352]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 360]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 368]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 376]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 576], zmm2
vmovdqu64 [rdx + 832], zmm0
mov rax, [rsi + 48]
vpbroadcastq zmm0, [rdi + 384]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 392]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 400]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 408]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 416]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 424]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 432]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 440]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 640], zmm2
vmovdqu64 [rdx + 896], zmm0
mov rax, [rsi + 56]
vpbroadcastq zmm0, [rdi + 448]
vgf2p8affineqb zmm1, zmm0, [rax + 64], 0
vgf2p8affineqb zmm0, zmm0, [rax + 0], 0
vpbroadcastq zmm2, [rdi + 456]
vgf2p8affineqb zmm3, zmm2, [rax + 192], 0
vgf2p8affineqb zmm2, zmm2, [rax + 128], 0
vpbroadcastq zmm4, [rdi + 464]
vgf2p8affineqb zmm5, zmm4, [rax + 320], 0
vgf2p8affineqb zmm4, zmm4, [rax + 256], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 472]
vgf2p8affineqb zmm3, zmm2, [rax + 448], 0
vgf2p8affineqb zmm2, zmm2, [rax + 384], 0
vpbroadcastq zmm4, [rdi + 480]
vgf2p8affineqb zmm5, zmm4, [rax + 576], 0
vgf2p8affineqb zmm4, zmm4, [rax + 512], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 488]
vgf2p8affineqb zmm3, zmm2, [rax + 704], 0
vgf2p8affineqb zmm2, zmm2, [rax + 640], 0
vpbroadcastq zmm4, [rdi + 496]
vgf2p8affineqb zmm5, zmm4, [rax + 832], 0
vgf2p8affineqb zmm4, zmm4, [rax + 768], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 504]
vgf2p8affineqb zmm3, zmm2, [rax + 960], 0
vgf2p8affineqb zmm2, zmm2, [rax + 896], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm2, zmm0
vpermt2b zmm2, zmm6, zmm1
vpermt2b zmm0, zmm7, zmm1
vmovdqu64 [rdx + 704], zmm2
vmovdqu64 [rdx + 960], zmm0
ret
.size flock_r2_prepared_prefold, .-flock_r2_prepared_prefold
.section .rodata
.p2align 6
.Lr2prep_low:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123
.p2align 6
.Lr2prep_high:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
