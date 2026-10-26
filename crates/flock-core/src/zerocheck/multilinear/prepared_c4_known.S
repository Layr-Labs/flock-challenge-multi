.text
.p2align 6
.global flock_c4_b_known_w0
.type flock_c4_b_known_w0,@function
flock_c4_b_known_w0:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_0
vbroadcasti32x4 zmm8, [rcx + 0]
vmovdqa64 zmm9, zmm8
vbroadcasti32x4 zmm10, [rcx + 16]
vmovdqa64 zmm11, zmm10
ret
.Lc4known_fallback_0:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w0, .-flock_c4_b_known_w0
.p2align 6
.global flock_c4_b_known_w1
.type flock_c4_b_known_w1,@function
flock_c4_b_known_w1:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_1
vbroadcasti32x4 zmm8, [rcx + 0]
vmovdqa64 zmm9, zmm8
vbroadcasti32x4 zmm10, [rcx + 16]
vmovdqa64 zmm11, zmm10
ret
.Lc4known_fallback_1:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w1, .-flock_c4_b_known_w1
.p2align 6
.global flock_c4_b_known_w2
.type flock_c4_b_known_w2,@function
flock_c4_b_known_w2:
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_2
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_2
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_2
vpbroadcastq zmm0, [rdi + 128]
vgf2p8affineqb zmm1, zmm0, [rsi + 3072], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 1024], 0
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
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_2:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w2, .-flock_c4_b_known_w2
.p2align 6
.global flock_c4_b_known_w3
.type flock_c4_b_known_w3,@function
flock_c4_b_known_w3:
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_3
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_3
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_3
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_3
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
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_3:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w3, .-flock_c4_b_known_w3
.p2align 6
.global flock_c4_b_known_w4
.type flock_c4_b_known_w4,@function
flock_c4_b_known_w4:
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_4
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_4
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_4
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_4
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
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_4:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w4, .-flock_c4_b_known_w4
.p2align 6
.global flock_c4_b_known_w5
.type flock_c4_b_known_w5,@function
flock_c4_b_known_w5:
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_5
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_5
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_5
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_5
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
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_5:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w5, .-flock_c4_b_known_w5
.p2align 6
.global flock_c4_b_known_w6
.type flock_c4_b_known_w6,@function
flock_c4_b_known_w6:
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_6
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_6
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_6
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_6
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
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 256]
vgf2p8affineqb zmm1, zmm0, [rdx + 2048], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 0], 0
vpbroadcastq zmm2, [rdi + 264]
vgf2p8affineqb zmm3, zmm2, [rdx + 2112], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 64], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_6:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w6, .-flock_c4_b_known_w6
.p2align 6
.global flock_c4_b_known_w7
.type flock_c4_b_known_w7,@function
flock_c4_b_known_w7:
vmovdqa64 zmm0, [rip + .Lc4known_expected_13]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_7
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_7
vpbroadcastq zmm0, [rdi + 0]
vgf2p8affineqb zmm1, zmm0, [rsi + 2048], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rdi + 64]
vgf2p8affineqb zmm3, zmm2, [rsi + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 312]
vgf2p8affineqb zmm1, zmm0, [rdx + 2496], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 448], 0
vpbroadcastq zmm2, [rdi + 320]
vgf2p8affineqb zmm3, zmm2, [rdx + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 512], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_7:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w7, .-flock_c4_b_known_w7
.p2align 6
.global flock_c4_b_known_w8
.type flock_c4_b_known_w8,@function
flock_c4_b_known_w8:
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_8
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_8
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_8
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_8
vpbroadcastq zmm0, [rdi + 56]
vgf2p8affineqb zmm1, zmm0, [rsi + 2496], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 448], 0
vpbroadcastq zmm2, [rdi + 64]
vgf2p8affineqb zmm3, zmm2, [rsi + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 304]
vgf2p8affineqb zmm1, zmm0, [rdx + 2432], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 384], 0
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
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_8:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w8, .-flock_c4_b_known_w8
.p2align 6
.global flock_c4_b_known_w9
.type flock_c4_b_known_w9,@function
flock_c4_b_known_w9:
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_9
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_9
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_9
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_9
vpbroadcastq zmm0, [rdi + 40]
vgf2p8affineqb zmm1, zmm0, [rsi + 2368], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 320], 0
vpbroadcastq zmm2, [rdi + 48]
vgf2p8affineqb zmm3, zmm2, [rsi + 2432], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rdi + 56]
vgf2p8affineqb zmm5, zmm4, [rsi + 2496], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 448], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 64]
vgf2p8affineqb zmm3, zmm2, [rsi + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 288]
vgf2p8affineqb zmm1, zmm0, [rdx + 2304], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 256], 0
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
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_9:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w9, .-flock_c4_b_known_w9
.p2align 6
.global flock_c4_b_known_w10
.type flock_c4_b_known_w10,@function
flock_c4_b_known_w10:
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_10
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_10
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_10
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_10
vpbroadcastq zmm0, [rdi + 32]
vgf2p8affineqb zmm1, zmm0, [rsi + 2304], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 256], 0
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
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 280]
vgf2p8affineqb zmm1, zmm0, [rdx + 2240], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 192], 0
vpbroadcastq zmm2, [rdi + 288]
vgf2p8affineqb zmm3, zmm2, [rdx + 2304], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 256], 0
vpbroadcastq zmm4, [rdi + 296]
vgf2p8affineqb zmm5, zmm4, [rdx + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 320], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 304]
vgf2p8affineqb zmm3, zmm2, [rdx + 2432], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 384], 0
vpbroadcastq zmm4, [rdi + 312]
vgf2p8affineqb zmm5, zmm4, [rdx + 2496], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 448], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 320]
vgf2p8affineqb zmm3, zmm2, [rdx + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 512], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_10:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w10, .-flock_c4_b_known_w10
.p2align 6
.global flock_c4_b_known_w11
.type flock_c4_b_known_w11,@function
flock_c4_b_known_w11:
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_11
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_11
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_11
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_11
vpbroadcastq zmm0, [rdi + 16]
vgf2p8affineqb zmm1, zmm0, [rsi + 2176], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 128], 0
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
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 264]
vgf2p8affineqb zmm1, zmm0, [rdx + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 64], 0
vpbroadcastq zmm2, [rdi + 272]
vgf2p8affineqb zmm3, zmm2, [rdx + 2176], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 128], 0
vpbroadcastq zmm4, [rdi + 280]
vgf2p8affineqb zmm5, zmm4, [rdx + 2240], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 192], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 288]
vgf2p8affineqb zmm3, zmm2, [rdx + 2304], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 256], 0
vpbroadcastq zmm4, [rdi + 296]
vgf2p8affineqb zmm5, zmm4, [rdx + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 320], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 304]
vgf2p8affineqb zmm3, zmm2, [rdx + 2432], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 384], 0
vpbroadcastq zmm4, [rdi + 312]
vgf2p8affineqb zmm5, zmm4, [rdx + 2496], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 448], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 320]
vgf2p8affineqb zmm3, zmm2, [rdx + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 512], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_11:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w11, .-flock_c4_b_known_w11
.p2align 6
.global flock_c4_b_known_w12
.type flock_c4_b_known_w12,@function
flock_c4_b_known_w12:
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_12
vmovdqa64 zmm0, [rip + .Lc4known_expected_13]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_12
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_12
vpbroadcastq zmm0, [rdi + 8]
vgf2p8affineqb zmm1, zmm0, [rsi + 2112], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 64], 0
vpbroadcastq zmm2, [rdi + 16]
vgf2p8affineqb zmm3, zmm2, [rsi + 2176], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 128], 0
vpbroadcastq zmm4, [rdi + 24]
vgf2p8affineqb zmm5, zmm4, [rsi + 2240], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 192], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 32]
vgf2p8affineqb zmm3, zmm2, [rsi + 2304], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 256], 0
vpbroadcastq zmm4, [rdi + 40]
vgf2p8affineqb zmm5, zmm4, [rsi + 2368], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 320], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 48]
vgf2p8affineqb zmm3, zmm2, [rsi + 2432], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 384], 0
vpbroadcastq zmm4, [rdi + 56]
vgf2p8affineqb zmm5, zmm4, [rsi + 2496], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 448], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 64]
vgf2p8affineqb zmm3, zmm2, [rsi + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_12:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w12, .-flock_c4_b_known_w12
.p2align 6
.global flock_c4_b_known_w13
.type flock_c4_b_known_w13,@function
flock_c4_b_known_w13:
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_13
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_13
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_13
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_13
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
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_13:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w13, .-flock_c4_b_known_w13
.p2align 6
.global flock_c4_b_known_w14
.type flock_c4_b_known_w14,@function
flock_c4_b_known_w14:
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_14
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_14
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_14
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_14
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
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_14:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w14, .-flock_c4_b_known_w14
.p2align 6
.global flock_c4_b_known_w15
.type flock_c4_b_known_w15,@function
flock_c4_b_known_w15:
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_15
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_15
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_15
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_15
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
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_15:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w15, .-flock_c4_b_known_w15
.p2align 6
.global flock_c4_b_known_w16
.type flock_c4_b_known_w16,@function
flock_c4_b_known_w16:
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_16
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_16
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_16
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_16
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
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_16:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w16, .-flock_c4_b_known_w16
.p2align 6
.global flock_c4_b_known_w17
.type flock_c4_b_known_w17,@function
flock_c4_b_known_w17:
vmovdqa64 zmm0, [rip + .Lc4known_expected_13]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_17
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_17
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
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_17:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w17, .-flock_c4_b_known_w17
.p2align 6
.global flock_c4_b_known_w18
.type flock_c4_b_known_w18,@function
flock_c4_b_known_w18:
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_18
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_18
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_18
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
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_18:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w18, .-flock_c4_b_known_w18
.p2align 6
.global flock_c4_b_known_w19
.type flock_c4_b_known_w19,@function
flock_c4_b_known_w19:
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_19
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_19
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_19
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_19
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
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_19:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w19, .-flock_c4_b_known_w19
.p2align 6
.global flock_c4_b_known_w20
.type flock_c4_b_known_w20,@function
flock_c4_b_known_w20:
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_20
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_20
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_20
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_20
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
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_20:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w20, .-flock_c4_b_known_w20
.p2align 6
.global flock_c4_b_known_w21
.type flock_c4_b_known_w21,@function
flock_c4_b_known_w21:
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_21
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_21
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_21
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_21
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
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_21:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w21, .-flock_c4_b_known_w21
.p2align 6
.global flock_c4_b_known_w22
.type flock_c4_b_known_w22,@function
flock_c4_b_known_w22:
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_22
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_22
vmovdqa64 zmm0, [rip + .Lc4known_expected_13]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_22
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
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_22:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w22, .-flock_c4_b_known_w22
.p2align 6
.global flock_c4_b_known_w23
.type flock_c4_b_known_w23,@function
flock_c4_b_known_w23:
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_23
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_23
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
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_23:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w23, .-flock_c4_b_known_w23
.p2align 6
.global flock_c4_b_known_w24
.type flock_c4_b_known_w24,@function
flock_c4_b_known_w24:
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_24
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_24
vmovdqa64 zmm0, [rip + .Lc4known_expected_3]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 192
jne .Lc4known_fallback_24
vmovdqa64 zmm0, [rip + .Lc4known_expected_4]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 31
jne .Lc4known_fallback_24
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
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_24:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w24, .-flock_c4_b_known_w24
.p2align 6
.global flock_c4_b_known_w25
.type flock_c4_b_known_w25,@function
flock_c4_b_known_w25:
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_25
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_25
vmovdqa64 zmm0, [rip + .Lc4known_expected_5]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 224
jne .Lc4known_fallback_25
vmovdqa64 zmm0, [rip + .Lc4known_expected_6]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 15
jne .Lc4known_fallback_25
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
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_25:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w25, .-flock_c4_b_known_w25
.p2align 6
.global flock_c4_b_known_w26
.type flock_c4_b_known_w26,@function
flock_c4_b_known_w26:
vmovdqa64 zmm0, [rip + .Lc4known_expected_7]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 240
jne .Lc4known_fallback_26
vmovdqa64 zmm0, [rip + .Lc4known_expected_8]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 7
jne .Lc4known_fallback_26
vmovdqa64 zmm0, [rip + .Lc4known_expected_9]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 248
jne .Lc4known_fallback_26
vmovdqa64 zmm0, [rip + .Lc4known_expected_10]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 3
jne .Lc4known_fallback_26
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
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
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
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_26:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w26, .-flock_c4_b_known_w26
.p2align 6
.global flock_c4_b_known_w27
.type flock_c4_b_known_w27,@function
flock_c4_b_known_w27:
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_27
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_27
vmovdqa64 zmm0, [rip + .Lc4known_expected_11]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 252
jne .Lc4known_fallback_27
vmovdqa64 zmm0, [rip + .Lc4known_expected_12]
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 1
jne .Lc4known_fallback_27
vpbroadcastq zmm0, [rdi + 0]
vgf2p8affineqb zmm1, zmm0, [rsi + 2048], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rdi + 8]
vgf2p8affineqb zmm3, zmm2, [rsi + 2112], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 64], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 256]
vgf2p8affineqb zmm1, zmm0, [rdx + 2048], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 0], 0
vpbroadcastq zmm2, [rdi + 264]
vgf2p8affineqb zmm3, zmm2, [rdx + 2112], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 64], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpbroadcastq zmm4, [rdi + 504]
vgf2p8affineqb zmm5, zmm4, [rdx + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_27:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w27, .-flock_c4_b_known_w27
.p2align 6
.global flock_c4_b_known_w28
.type flock_c4_b_known_w28,@function
flock_c4_b_known_w28:
vmovdqa64 zmm0, [rip + .Lc4known_expected_13]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 254
jne .Lc4known_fallback_28
vmovdqa64 zmm0, [rip + .Lc4known_expected_0]
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 127
jne .Lc4known_fallback_28
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_28
vpbroadcastq zmm0, [rdi + 0]
vgf2p8affineqb zmm1, zmm0, [rsi + 2048], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 0], 0
vpbroadcastq zmm2, [rdi + 64]
vgf2p8affineqb zmm3, zmm2, [rsi + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 512], 0
vpbroadcastq zmm4, [rdi + 72]
vgf2p8affineqb zmm5, zmm4, [rsi + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 80]
vgf2p8affineqb zmm3, zmm2, [rsi + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 640], 0
vpbroadcastq zmm4, [rdi + 88]
vgf2p8affineqb zmm5, zmm4, [rsi + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 96]
vgf2p8affineqb zmm3, zmm2, [rsi + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 768], 0
vpbroadcastq zmm4, [rdi + 104]
vgf2p8affineqb zmm5, zmm4, [rsi + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 112]
vgf2p8affineqb zmm3, zmm2, [rsi + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 896], 0
vpbroadcastq zmm4, [rdi + 120]
vgf2p8affineqb zmm5, zmm4, [rsi + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 128]
vgf2p8affineqb zmm3, zmm2, [rsi + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1024], 0
vpbroadcastq zmm4, [rdi + 136]
vgf2p8affineqb zmm5, zmm4, [rsi + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 144]
vgf2p8affineqb zmm3, zmm2, [rsi + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1152], 0
vpbroadcastq zmm4, [rdi + 152]
vgf2p8affineqb zmm5, zmm4, [rsi + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 160]
vgf2p8affineqb zmm3, zmm2, [rsi + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1280], 0
vpbroadcastq zmm4, [rdi + 168]
vgf2p8affineqb zmm5, zmm4, [rsi + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 176]
vgf2p8affineqb zmm3, zmm2, [rsi + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1408], 0
vpbroadcastq zmm4, [rdi + 184]
vgf2p8affineqb zmm5, zmm4, [rsi + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 192]
vgf2p8affineqb zmm3, zmm2, [rsi + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1536], 0
vpbroadcastq zmm4, [rdi + 200]
vgf2p8affineqb zmm5, zmm4, [rsi + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 208]
vgf2p8affineqb zmm3, zmm2, [rsi + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1664], 0
vpbroadcastq zmm4, [rdi + 216]
vgf2p8affineqb zmm5, zmm4, [rsi + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 224]
vgf2p8affineqb zmm3, zmm2, [rsi + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1792], 0
vpbroadcastq zmm4, [rdi + 232]
vgf2p8affineqb zmm5, zmm4, [rsi + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 240]
vgf2p8affineqb zmm3, zmm2, [rsi + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rsi + 1920], 0
vpbroadcastq zmm4, [rdi + 248]
vgf2p8affineqb zmm5, zmm4, [rsi + 4032], 0
vgf2p8affineqb zmm4, zmm4, [rsi + 1984], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vpbroadcastq zmm0, [rdi + 312]
vgf2p8affineqb zmm1, zmm0, [rdx + 2496], 0
vgf2p8affineqb zmm0, zmm0, [rdx + 448], 0
vpbroadcastq zmm2, [rdi + 320]
vgf2p8affineqb zmm3, zmm2, [rdx + 2560], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 512], 0
vpbroadcastq zmm4, [rdi + 328]
vgf2p8affineqb zmm5, zmm4, [rdx + 2624], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 576], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 336]
vgf2p8affineqb zmm3, zmm2, [rdx + 2688], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 640], 0
vpbroadcastq zmm4, [rdi + 344]
vgf2p8affineqb zmm5, zmm4, [rdx + 2752], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 704], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 352]
vgf2p8affineqb zmm3, zmm2, [rdx + 2816], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 768], 0
vpbroadcastq zmm4, [rdi + 360]
vgf2p8affineqb zmm5, zmm4, [rdx + 2880], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 832], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 368]
vgf2p8affineqb zmm3, zmm2, [rdx + 2944], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 896], 0
vpbroadcastq zmm4, [rdi + 376]
vgf2p8affineqb zmm5, zmm4, [rdx + 3008], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 960], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 384]
vgf2p8affineqb zmm3, zmm2, [rdx + 3072], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1024], 0
vpbroadcastq zmm4, [rdi + 392]
vgf2p8affineqb zmm5, zmm4, [rdx + 3136], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1088], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 400]
vgf2p8affineqb zmm3, zmm2, [rdx + 3200], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1152], 0
vpbroadcastq zmm4, [rdi + 408]
vgf2p8affineqb zmm5, zmm4, [rdx + 3264], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1216], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 416]
vgf2p8affineqb zmm3, zmm2, [rdx + 3328], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1280], 0
vpbroadcastq zmm4, [rdi + 424]
vgf2p8affineqb zmm5, zmm4, [rdx + 3392], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1344], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 432]
vgf2p8affineqb zmm3, zmm2, [rdx + 3456], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1408], 0
vpbroadcastq zmm4, [rdi + 440]
vgf2p8affineqb zmm5, zmm4, [rdx + 3520], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1472], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 448]
vgf2p8affineqb zmm3, zmm2, [rdx + 3584], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1536], 0
vpbroadcastq zmm4, [rdi + 456]
vgf2p8affineqb zmm5, zmm4, [rdx + 3648], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1600], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 464]
vgf2p8affineqb zmm3, zmm2, [rdx + 3712], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1664], 0
vpbroadcastq zmm4, [rdi + 472]
vgf2p8affineqb zmm5, zmm4, [rdx + 3776], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1728], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 480]
vgf2p8affineqb zmm3, zmm2, [rdx + 3840], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1792], 0
vpbroadcastq zmm4, [rdi + 488]
vgf2p8affineqb zmm5, zmm4, [rdx + 3904], 0
vgf2p8affineqb zmm4, zmm4, [rdx + 1856], 0
vpternlogq zmm0, zmm2, zmm4, 0x96
vpternlogq zmm1, zmm3, zmm5, 0x96
vpbroadcastq zmm2, [rdi + 496]
vgf2p8affineqb zmm3, zmm2, [rdx + 3968], 0
vgf2p8affineqb zmm2, zmm2, [rdx + 1920], 0
vpxorq zmm0, zmm0, zmm2
vpxorq zmm1, zmm1, zmm3
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm10, zmm0
vmovdqa64 zmm11, zmm0
vpermt2b zmm10, zmm6, zmm1
vpermt2b zmm11, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 16]
vpxorq zmm10, zmm10, zmm0
vpxorq zmm11, zmm11, zmm0
ret
.Lc4known_fallback_28:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w28, .-flock_c4_b_known_w28
.p2align 6
.global flock_c4_b_known_w29
.type flock_c4_b_known_w29,@function
flock_c4_b_known_w29:
vmovdqa64 zmm0, [rip + .Lc4known_expected_2]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 63
jne .Lc4known_fallback_29
vmovdqa64 zmm0, [rip + .Lc4known_expected_1]
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 128
jne .Lc4known_fallback_29
vpternlogd zmm0, zmm0, zmm0, 255
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_29
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_29
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_29
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_29
vpbroadcastq zmm0, [rdi + 48]
vgf2p8affineqb zmm1, zmm0, [rsi + 2432], 0
vgf2p8affineqb zmm0, zmm0, [rsi + 384], 0
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
vmovdqa64 zmm6, [rip + .Lc4known_out_even]
vmovdqa64 zmm7, [rip + .Lc4known_out_odd]
vmovdqa64 zmm8, zmm0
vmovdqa64 zmm9, zmm0
vpermt2b zmm8, zmm6, zmm1
vpermt2b zmm9, zmm7, zmm1
vbroadcasti32x4 zmm0, [rcx + 0]
vpxorq zmm8, zmm8, zmm0
vpxorq zmm9, zmm9, zmm0
vbroadcasti32x4 zmm10, [rcx + 16]
vmovdqa64 zmm11, zmm10
ret
.Lc4known_fallback_29:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w29, .-flock_c4_b_known_w29
.p2align 6
.global flock_c4_b_known_w30
.type flock_c4_b_known_w30,@function
flock_c4_b_known_w30:
vmovdqa64 zmm0, [rip + .Lc4known_expected_14]
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpxorq zmm0, zmm0, zmm0
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_30
vbroadcasti32x4 zmm8, [rcx + 0]
vmovdqa64 zmm9, zmm8
vbroadcasti32x4 zmm10, [rcx + 16]
vmovdqa64 zmm11, zmm10
ret
.Lc4known_fallback_30:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w30, .-flock_c4_b_known_w30
.p2align 6
.global flock_c4_b_known_w31
.type flock_c4_b_known_w31,@function
flock_c4_b_known_w31:
vpxorq zmm0, zmm0, zmm0
vpcmpuq k1, zmm0, [rdi + 0], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 64], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 128], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 192], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 256], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 320], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 384], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vpcmpuq k1, zmm0, [rdi + 448], 4
kmovw eax, k1
test eax, 255
jne .Lc4known_fallback_31
vbroadcasti32x4 zmm8, [rcx + 0]
vmovdqa64 zmm9, zmm8
vbroadcasti32x4 zmm10, [rcx + 16]
vmovdqa64 zmm11, zmm10
ret
.Lc4known_fallback_31:
jmp flock_c4_two_bank_result
.size flock_c4_b_known_w31, .-flock_c4_b_known_w31
.section .rodata
.p2align 6
.Lc4known_input:
.byte 0,4,8,12,16,20,24,28,1,5,9,13,17,21,25,29,2,6,10,14,18,22,26,30,3,7,11,15,19,23,27,31,32,36,40,44,48,52,56,60,33,37,41,45,49,53,57,61,34,38,42,46,50,54,58,62,35,39,43,47,51,55,59,63
.p2align 6
.Lc4known_out_even:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123
.p2align 6
.Lc4known_out_odd:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127

.p2align 6
.Lc4known_expected_0:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x0
.p2align 6
.Lc4known_expected_1:
.quad 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xffffffffffffffff
.p2align 6
.Lc4known_expected_2:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x0,0x0
.p2align 6
.Lc4known_expected_3:
.quad 0x0,0x0,0x0,0x0,0x0,0x0,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_4:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x0,0x0,0x0
.p2align 6
.Lc4known_expected_5:
.quad 0x0,0x0,0x0,0x0,0x0,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_6:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x0,0x0,0x0,0x0
.p2align 6
.Lc4known_expected_7:
.quad 0x0,0x0,0x0,0x0,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_8:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x0,0x0,0x0,0x0,0x0
.p2align 6
.Lc4known_expected_9:
.quad 0x0,0x0,0x0,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_10:
.quad 0xffffffffffffffff,0xffffffffffffffff,0x0,0x0,0x0,0x0,0x0,0x0
.p2align 6
.Lc4known_expected_11:
.quad 0x0,0x0,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_12:
.quad 0xffffffffffffffff,0x0,0x0,0x0,0x0,0x0,0x0,0x0
.p2align 6
.Lc4known_expected_13:
.quad 0x0,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff
.p2align 6
.Lc4known_expected_14:
.quad 0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0xffffffffffffffff,0x101010101010101,0x0
