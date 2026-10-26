.text
.p2align 6
.global flock_r2_b_known_guarded_w2
.type flock_r2_b_known_guarded_w2,@function
flock_r2_b_known_guarded_w2:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w2
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w2
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w2
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 0], zmm0
vmovdqu64 [rdx + 256], zmm0
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 64], zmm0
vmovdqu64 [rdx + 320], zmm0
mov rax, [rsi + 0]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 376]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm0
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm0
ret
.Lr2known_guarded_fallback_w2:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w2, .-flock_r2_b_known_guarded_w2
.p2align 6
.global flock_r2_b_known_guarded_w3
.type flock_r2_b_known_guarded_w3,@function
flock_r2_b_known_guarded_w3:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w3
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w3
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w3
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w3
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 360]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w3:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w3, .-flock_r2_b_known_guarded_w3
.p2align 6
.global flock_r2_b_known_guarded_w4
.type flock_r2_b_known_guarded_w4,@function
flock_r2_b_known_guarded_w4:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w4
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w4
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w4
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w4
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 104]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w4:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w4, .-flock_r2_b_known_guarded_w4
.p2align 6
.global flock_r2_b_known_guarded_w5
.type flock_r2_b_known_guarded_w5,@function
flock_r2_b_known_guarded_w5:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w5
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w5
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w5
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w5
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 88]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w5:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w5, .-flock_r2_b_known_guarded_w5
.p2align 6
.global flock_r2_b_known_guarded_w6
.type flock_r2_b_known_guarded_w6,@function
flock_r2_b_known_guarded_w6:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w6
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w6
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w6
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w6
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 328]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w6:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w6, .-flock_r2_b_known_guarded_w6
.p2align 6
.global flock_r2_b_known_guarded_w7
.type flock_r2_b_known_guarded_w7,@function
flock_r2_b_known_guarded_w7:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w7
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w7
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm0, zmm12, zmm8, 0
vgf2p8affineqb zmm1, zmm12, zmm9, 0
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 312]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm2
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm2
ret
.Lr2known_guarded_fallback_w7:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w7, .-flock_r2_b_known_guarded_w7
.p2align 6
.global flock_r2_b_known_guarded_w8
.type flock_r2_b_known_guarded_w8,@function
flock_r2_b_known_guarded_w8:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w8
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w8
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w8
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w8
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 56]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
ret
.Lr2known_guarded_fallback_w8:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w8, .-flock_r2_b_known_guarded_w8
.p2align 6
.global flock_r2_b_known_guarded_w9
.type flock_r2_b_known_guarded_w9,@function
flock_r2_b_known_guarded_w9:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w9
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w9
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w9
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w9
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 40]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm6, zmm6, zmm12
vpxorq zmm7, zmm7, zmm13
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
ret
.Lr2known_guarded_fallback_w9:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w9, .-flock_r2_b_known_guarded_w9
.p2align 6
.global flock_r2_b_known_guarded_w10
.type flock_r2_b_known_guarded_w10,@function
flock_r2_b_known_guarded_w10:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w10
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w10
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w10
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w10
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 280]
vgf2p8affineqb zmm4, zmm12, zmm10, 0
vgf2p8affineqb zmm5, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm6, zmm6, zmm12
vpxorq zmm7, zmm7, zmm13
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
ret
.Lr2known_guarded_fallback_w10:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w10, .-flock_r2_b_known_guarded_w10
.p2align 6
.global flock_r2_b_known_guarded_w11
.type flock_r2_b_known_guarded_w11,@function
flock_r2_b_known_guarded_w11:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w11
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w11
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w11
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w11
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 264]
vgf2p8affineqb zmm4, zmm12, zmm10, 0
vgf2p8affineqb zmm5, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
ret
.Lr2known_guarded_fallback_w11:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w11, .-flock_r2_b_known_guarded_w11
.p2align 6
.global flock_r2_b_known_guarded_w12
.type flock_r2_b_known_guarded_w12,@function
flock_r2_b_known_guarded_w12:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w12
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w12
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w12
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 8]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm2, zmm12, zmm8, 0
vgf2p8affineqb zmm3, zmm12, zmm9, 0
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 504]
vgf2p8affineqb zmm4, zmm12, zmm10, 0
vgf2p8affineqb zmm5, zmm12, zmm11, 0
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm4
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm0
ret
.Lr2known_guarded_fallback_w12:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w12, .-flock_r2_b_known_guarded_w12
.p2align 6
.global flock_r2_b_known_guarded_w13
.type flock_r2_b_known_guarded_w13,@function
flock_r2_b_known_guarded_w13:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w13
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w13
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w13
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w13
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
ret
.Lr2known_guarded_fallback_w13:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w13, .-flock_r2_b_known_guarded_w13
.p2align 6
.global flock_r2_b_known_guarded_w14
.type flock_r2_b_known_guarded_w14,@function
flock_r2_b_known_guarded_w14:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w14
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w14
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w14
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w14
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 232]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
ret
.Lr2known_guarded_fallback_w14:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w14, .-flock_r2_b_known_guarded_w14
.p2align 6
.global flock_r2_b_known_guarded_w15
.type flock_r2_b_known_guarded_w15,@function
flock_r2_b_known_guarded_w15:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w15
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w15
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w15
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w15
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 216]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 472]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
ret
.Lr2known_guarded_fallback_w15:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w15, .-flock_r2_b_known_guarded_w15
.p2align 6
.global flock_r2_b_known_guarded_w16
.type flock_r2_b_known_guarded_w16,@function
flock_r2_b_known_guarded_w16:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w16
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w16
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w16
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w16
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 456]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
ret
.Lr2known_guarded_fallback_w16:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w16, .-flock_r2_b_known_guarded_w16
.p2align 6
.global flock_r2_b_known_guarded_w17
.type flock_r2_b_known_guarded_w17,@function
flock_r2_b_known_guarded_w17:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w17
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w17
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm0, zmm12, zmm8, 0
vgf2p8affineqb zmm1, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm2, zmm12, zmm8, 0
vgf2p8affineqb zmm3, zmm12, zmm9, 0
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm2
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm2
ret
.Lr2known_guarded_fallback_w17:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w17, .-flock_r2_b_known_guarded_w17
.p2align 6
.global flock_r2_b_known_guarded_w18
.type flock_r2_b_known_guarded_w18,@function
flock_r2_b_known_guarded_w18:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w18
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w18
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w18
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 184]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm0
ret
.Lr2known_guarded_fallback_w18:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w18, .-flock_r2_b_known_guarded_w18
.p2align 6
.global flock_r2_b_known_guarded_w19
.type flock_r2_b_known_guarded_w19,@function
flock_r2_b_known_guarded_w19:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w19
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w19
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w19
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w19
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 168]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 424]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w19:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w19, .-flock_r2_b_known_guarded_w19
.p2align 6
.global flock_r2_b_known_guarded_w20
.type flock_r2_b_known_guarded_w20,@function
flock_r2_b_known_guarded_w20:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w20
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w20
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w20
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w20
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 408]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w20:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w20, .-flock_r2_b_known_guarded_w20
.p2align 6
.global flock_r2_b_known_guarded_w21
.type flock_r2_b_known_guarded_w21,@function
flock_r2_b_known_guarded_w21:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w21
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w21
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w21
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w21
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w21:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w21, .-flock_r2_b_known_guarded_w21
.p2align 6
.global flock_r2_b_known_guarded_w22
.type flock_r2_b_known_guarded_w22,@function
flock_r2_b_known_guarded_w22:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w22
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w22
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w22
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 136]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm4, zmm12, zmm8, 0
vgf2p8affineqb zmm5, zmm12, zmm9, 0
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm4
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm0
ret
.Lr2known_guarded_fallback_w22:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w22, .-flock_r2_b_known_guarded_w22
.p2align 6
.global flock_r2_b_known_guarded_w23
.type flock_r2_b_known_guarded_w23,@function
flock_r2_b_known_guarded_w23:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w23
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w23
mov rax, [rsi + 0]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 120]
vgf2p8affineqb zmm0, zmm12, zmm10, 0
vgf2p8affineqb zmm1, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 376]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm2
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 304]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 312]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm2
ret
.Lr2known_guarded_fallback_w23:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w23, .-flock_r2_b_known_guarded_w23
.p2align 6
.global flock_r2_b_known_guarded_w24
.type flock_r2_b_known_guarded_w24,@function
flock_r2_b_known_guarded_w24:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w24
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w24
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 192
jne .Lr2known_guarded_fallback_w24
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 31
jne .Lr2known_guarded_fallback_w24
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 40]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 296]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 360]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 144]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 80]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w24:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w24, .-flock_r2_b_known_guarded_w24
.p2align 6
.global flock_r2_b_known_guarded_w25
.type flock_r2_b_known_guarded_w25,@function
flock_r2_b_known_guarded_w25:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w25
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w25
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 224
jne .Lr2known_guarded_fallback_w25
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 15
jne .Lr2known_guarded_fallback_w25
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 280]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 32]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm0, zmm0, zmm12
vpxorq zmm1, zmm1, zmm13
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 288]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 160]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 64]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w25:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w25, .-flock_r2_b_known_guarded_w25
.p2align 6
.global flock_r2_b_known_guarded_w26
.type flock_r2_b_known_guarded_w26,@function
flock_r2_b_known_guarded_w26:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 240
jne .Lr2known_guarded_fallback_w26
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 7
jne .Lr2known_guarded_fallback_w26
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 248
jne .Lr2known_guarded_fallback_w26
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 3
jne .Lr2known_guarded_fallback_w26
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 16]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 24]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 88]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 272]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 176]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 48]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 192]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 32]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w26:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w26, .-flock_r2_b_known_guarded_w26
.p2align 6
.global flock_r2_b_known_guarded_w27
.type flock_r2_b_known_guarded_w27,@function
flock_r2_b_known_guarded_w27:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w27
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w27
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 252
jne .Lr2known_guarded_fallback_w27
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 1
jne .Lr2known_guarded_fallback_w27
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 8]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 72]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 256]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 264]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 328]
vgf2p8affineqb zmm6, zmm12, zmm10, 0
vgf2p8affineqb zmm7, zmm12, zmm11, 0
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 208]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vbroadcasti32x4 zmm10, [rcx + 16]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm6, zmm6, zmm10
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 504]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm6
ret
.Lr2known_guarded_fallback_w27:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w27, .-flock_r2_b_known_guarded_w27
.p2align 6
.global flock_r2_b_known_guarded_w28
.type flock_r2_b_known_guarded_w28,@function
flock_r2_b_known_guarded_w28:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 254
jne .Lr2known_guarded_fallback_w28
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 127
jne .Lr2known_guarded_fallback_w28
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w28
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 0]
vgf2p8affineqb zmm0, zmm12, zmm8, 0
vgf2p8affineqb zmm1, zmm12, zmm9, 0
vpbroadcastq zmm12, [rdi + 448]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 456]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 464]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 472]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 480]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 488]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 312]
vgf2p8affineqb zmm2, zmm12, zmm10, 0
vgf2p8affineqb zmm3, zmm12, zmm11, 0
vpbroadcastq zmm12, [rdi + 496]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm4, zmm4, zmm12
vpxorq zmm5, zmm5, zmm13
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 224]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 112]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 512], zmm12
vmovdqu64 [rdx + 768], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm4, zmm4, zmm10
vmovdqu64 [rdx + 704], zmm12
vmovdqu64 [rdx + 960], zmm4
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm4, zmm12, zmm14
vpxorq zmm5, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 320]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 328]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm6, zmm12, zmm14
vpxorq zmm7, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 336]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 344]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 352]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 360]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 248]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm4, zmm12, zmm14, 0x96
vpternlogq zmm5, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 368]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 376]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm6, zmm12, zmm14, 0x96
vpternlogq zmm7, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
vmovdqa64 zmm12, zmm4
vpermt2b zmm12, zmm8, zmm5
vpermt2b zmm4, zmm9, zmm5
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm4
vmovdqa64 zmm12, zmm6
vpermt2b zmm12, zmm8, zmm7
vpermt2b zmm6, zmm9, zmm7
vmovdqu64 [rdx + 576], zmm12
vmovdqu64 [rdx + 832], zmm6
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 384]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 392]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 400]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 408]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 416]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 424]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 432]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 440]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 640], zmm12
vmovdqu64 [rdx + 896], zmm0
ret
.Lr2known_guarded_fallback_w28:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w28, .-flock_r2_b_known_guarded_w28
.p2align 6
.global flock_r2_b_known_guarded_w29
.type flock_r2_b_known_guarded_w29,@function
flock_r2_b_known_guarded_w29:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 63
jne .Lr2known_guarded_fallback_w29
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 128
jne .Lr2known_guarded_fallback_w29
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w29
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w29
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w29
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lr2known_guarded_fallback_w29
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 512], zmm0
vmovdqu64 [rdx + 768], zmm0
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 576], zmm0
vmovdqu64 [rdx + 832], zmm0
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 640], zmm0
vmovdqu64 [rdx + 896], zmm0
vbroadcasti32x4 zmm0, [rcx + 240]
vmovdqu64 [rdx + 704], zmm0
vmovdqu64 [rdx + 960], zmm0
mov rax, [rsi + 0]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 192]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 200]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 208]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 216]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 224]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 232]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 48]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 56]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 240]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpxorq zmm2, zmm2, zmm12
vpxorq zmm3, zmm3, zmm13
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vbroadcasti32x4 zmm10, [rcx + 96]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm0, zmm0, zmm10
vmovdqu64 [rdx + 0], zmm12
vmovdqu64 [rdx + 256], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vbroadcasti32x4 zmm10, [rcx + 128]
vpxorq zmm12, zmm12, zmm10
vpxorq zmm2, zmm2, zmm10
vmovdqu64 [rdx + 192], zmm12
vmovdqu64 [rdx + 448], zmm2
mov rax, [rsi + 8]
vmovdqu64 zmm8, [rax + 0]
vmovdqu64 zmm9, [rax + 64]
vmovdqu64 zmm10, [rax + 128]
vmovdqu64 zmm11, [rax + 192]
vpbroadcastq zmm12, [rdi + 64]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 72]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm0, zmm12, zmm14
vpxorq zmm1, zmm13, zmm15
vpbroadcastq zmm12, [rdi + 128]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 136]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpxorq zmm2, zmm12, zmm14
vpxorq zmm3, zmm13, zmm15
vmovdqu64 zmm8, [rax + 256]
vmovdqu64 zmm9, [rax + 320]
vmovdqu64 zmm10, [rax + 384]
vmovdqu64 zmm11, [rax + 448]
vpbroadcastq zmm12, [rdi + 80]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 88]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 144]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 152]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 512]
vmovdqu64 zmm9, [rax + 576]
vmovdqu64 zmm10, [rax + 640]
vmovdqu64 zmm11, [rax + 704]
vpbroadcastq zmm12, [rdi + 96]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 104]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 160]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 168]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqu64 zmm8, [rax + 768]
vmovdqu64 zmm9, [rax + 832]
vmovdqu64 zmm10, [rax + 896]
vmovdqu64 zmm11, [rax + 960]
vpbroadcastq zmm12, [rdi + 112]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 120]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm0, zmm12, zmm14, 0x96
vpternlogq zmm1, zmm13, zmm15, 0x96
vpbroadcastq zmm12, [rdi + 176]
vgf2p8affineqb zmm13, zmm12, zmm9, 0
vgf2p8affineqb zmm12, zmm12, zmm8, 0
vpbroadcastq zmm14, [rdi + 184]
vgf2p8affineqb zmm15, zmm14, zmm11, 0
vgf2p8affineqb zmm14, zmm14, zmm10, 0
vpternlogq zmm2, zmm12, zmm14, 0x96
vpternlogq zmm3, zmm13, zmm15, 0x96
vmovdqa64 zmm8, [rip + .Lr2known_guarded_low]
vmovdqa64 zmm9, [rip + .Lr2known_guarded_high]
vmovdqa64 zmm12, zmm0
vpermt2b zmm12, zmm8, zmm1
vpermt2b zmm0, zmm9, zmm1
vmovdqu64 [rdx + 64], zmm12
vmovdqu64 [rdx + 320], zmm0
vmovdqa64 zmm12, zmm2
vpermt2b zmm12, zmm8, zmm3
vpermt2b zmm2, zmm9, zmm3
vmovdqu64 [rdx + 128], zmm12
vmovdqu64 [rdx + 384], zmm2
ret
.Lr2known_guarded_fallback_w29:
mov rsi, r9
jmp flock_r2_prepared_prefold
.size flock_r2_b_known_guarded_w29, .-flock_r2_b_known_guarded_w29
.section .rodata
.p2align 6
.Lr2known_guarded_low:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123
.p2align 6
.Lr2known_guarded_high:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127


