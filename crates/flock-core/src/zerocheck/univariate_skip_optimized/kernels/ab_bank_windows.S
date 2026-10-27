// RDI rows; RSI maps; RDX bank; RCX window stride; R8 count; R9 hint offset.
// SysV caller-clobbered registers only. Sixteen planes remain live across count windows.
// All inputs/maps are immutable and disjoint from the exclusive output bank.
.text
.p2align 6
.global flock_ab_bank_windows_0_0
.hidden flock_ab_bank_windows_0_0
.type flock_ab_bank_windows_0_0,@function
flock_ab_bank_windows_0_0:
sub rcx, 896
vmovdqu64 zmm0, [rdx + 0]
vmovdqu64 zmm1, [rdx + 64]
vmovdqu64 zmm2, [rdx + 128]
vmovdqu64 zmm3, [rdx + 192]
vmovdqu64 zmm4, [rdx + 256]
vmovdqu64 zmm5, [rdx + 320]
vmovdqu64 zmm6, [rdx + 384]
vmovdqu64 zmm7, [rdx + 448]
vmovdqu64 zmm8, [rdx + 512]
vmovdqu64 zmm9, [rdx + 576]
vmovdqu64 zmm10, [rdx + 640]
vmovdqu64 zmm11, [rdx + 704]
vmovdqu64 zmm12, [rdx + 768]
vmovdqu64 zmm13, [rdx + 832]
vmovdqu64 zmm14, [rdx + 896]
vmovdqu64 zmm15, [rdx + 960]
.Lflock_ab_bank_windows_0_0_w:
mov eax, 7
.Lflock_ab_bank_windows_0_0_pair:
test r9, r9
jz .Lflock_ab_bank_windows_0_0_no_pf
prefetcht0 [rdi + r9]
prefetcht0 [rdi + r9 + 64]
.Lflock_ab_bank_windows_0_0_no_pf:
vmovdqu64 zmm16, [rdi]
vmovdqu64 zmm17, [rdi + 64]
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 0]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 128]{1to8}, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 8]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 136]{1to8}, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 16]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 144]{1to8}, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 24]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 152]{1to8}, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 32]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 160]{1to8}, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 40]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 168]{1to8}, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 48]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 176]{1to8}, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 56]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 184]{1to8}, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 64]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 192]{1to8}, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 72]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 200]{1to8}, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 80]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 208]{1to8}, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 88]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 216]{1to8}, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 96]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 224]{1to8}, 0
vpternlogq zmm12, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 104]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 232]{1to8}, 0
vpternlogq zmm13, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 112]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 240]{1to8}, 0
vpternlogq zmm14, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 120]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 248]{1to8}, 0
vpternlogq zmm15, zmm18, zmm19, 0x96
add rdi, 128
add rsi, 256
dec eax
jnz .Lflock_ab_bank_windows_0_0_pair
add rdi, rcx
add rsi, 256
dec r8
jnz .Lflock_ab_bank_windows_0_0_w
vmovdqu64 [rdx + 0], zmm0
vmovdqu64 [rdx + 64], zmm1
vmovdqu64 [rdx + 128], zmm2
vmovdqu64 [rdx + 192], zmm3
vmovdqu64 [rdx + 256], zmm4
vmovdqu64 [rdx + 320], zmm5
vmovdqu64 [rdx + 384], zmm6
vmovdqu64 [rdx + 448], zmm7
vmovdqu64 [rdx + 512], zmm8
vmovdqu64 [rdx + 576], zmm9
vmovdqu64 [rdx + 640], zmm10
vmovdqu64 [rdx + 704], zmm11
vmovdqu64 [rdx + 768], zmm12
vmovdqu64 [rdx + 832], zmm13
vmovdqu64 [rdx + 896], zmm14
vmovdqu64 [rdx + 960], zmm15
ret
.size flock_ab_bank_windows_0_0,.-flock_ab_bank_windows_0_0
.text
.p2align 6
.global flock_ab_bank_windows_0_1
.hidden flock_ab_bank_windows_0_1
.type flock_ab_bank_windows_0_1,@function
flock_ab_bank_windows_0_1:
sub rcx, 896
vpxorq zmm0, zmm0, zmm0
vpxorq zmm1, zmm1, zmm1
vpxorq zmm2, zmm2, zmm2
vpxorq zmm3, zmm3, zmm3
vpxorq zmm4, zmm4, zmm4
vpxorq zmm5, zmm5, zmm5
vpxorq zmm6, zmm6, zmm6
vpxorq zmm7, zmm7, zmm7
vpxorq zmm8, zmm8, zmm8
vpxorq zmm9, zmm9, zmm9
vpxorq zmm10, zmm10, zmm10
vpxorq zmm11, zmm11, zmm11
vpxorq zmm12, zmm12, zmm12
vpxorq zmm13, zmm13, zmm13
vpxorq zmm14, zmm14, zmm14
vpxorq zmm15, zmm15, zmm15
.Lflock_ab_bank_windows_0_1_w:
mov eax, 7
.Lflock_ab_bank_windows_0_1_pair:
test r9, r9
jz .Lflock_ab_bank_windows_0_1_no_pf
prefetcht0 [rdi + r9]
prefetcht0 [rdi + r9 + 64]
.Lflock_ab_bank_windows_0_1_no_pf:
vmovdqu64 zmm16, [rdi]
vmovdqu64 zmm17, [rdi + 64]
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 0]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 128]{1to8}, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 8]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 136]{1to8}, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 16]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 144]{1to8}, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 24]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 152]{1to8}, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 32]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 160]{1to8}, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 40]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 168]{1to8}, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 48]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 176]{1to8}, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 56]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 184]{1to8}, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 64]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 192]{1to8}, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 72]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 200]{1to8}, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 80]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 208]{1to8}, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 88]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 216]{1to8}, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 96]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 224]{1to8}, 0
vpternlogq zmm12, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 104]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 232]{1to8}, 0
vpternlogq zmm13, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 112]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 240]{1to8}, 0
vpternlogq zmm14, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 120]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 248]{1to8}, 0
vpternlogq zmm15, zmm18, zmm19, 0x96
add rdi, 128
add rsi, 256
dec eax
jnz .Lflock_ab_bank_windows_0_1_pair
add rdi, rcx
add rsi, 256
dec r8
jnz .Lflock_ab_bank_windows_0_1_w
vmovdqu64 [rdx + 0], zmm0
vmovdqu64 [rdx + 64], zmm1
vmovdqu64 [rdx + 128], zmm2
vmovdqu64 [rdx + 192], zmm3
vmovdqu64 [rdx + 256], zmm4
vmovdqu64 [rdx + 320], zmm5
vmovdqu64 [rdx + 384], zmm6
vmovdqu64 [rdx + 448], zmm7
vmovdqu64 [rdx + 512], zmm8
vmovdqu64 [rdx + 576], zmm9
vmovdqu64 [rdx + 640], zmm10
vmovdqu64 [rdx + 704], zmm11
vmovdqu64 [rdx + 768], zmm12
vmovdqu64 [rdx + 832], zmm13
vmovdqu64 [rdx + 896], zmm14
vmovdqu64 [rdx + 960], zmm15
ret
.size flock_ab_bank_windows_0_1,.-flock_ab_bank_windows_0_1
.text
.p2align 6
.global flock_ab_bank_windows_2_0
.hidden flock_ab_bank_windows_2_0
.type flock_ab_bank_windows_2_0,@function
flock_ab_bank_windows_2_0:
sub rcx, 896
add rsi, 256
vmovdqu64 zmm0, [rdx + 0]
vmovdqu64 zmm1, [rdx + 64]
vmovdqu64 zmm2, [rdx + 128]
vmovdqu64 zmm3, [rdx + 192]
vmovdqu64 zmm4, [rdx + 256]
vmovdqu64 zmm5, [rdx + 320]
vmovdqu64 zmm6, [rdx + 384]
vmovdqu64 zmm7, [rdx + 448]
vmovdqu64 zmm8, [rdx + 512]
vmovdqu64 zmm9, [rdx + 576]
vmovdqu64 zmm10, [rdx + 640]
vmovdqu64 zmm11, [rdx + 704]
vmovdqu64 zmm12, [rdx + 768]
vmovdqu64 zmm13, [rdx + 832]
vmovdqu64 zmm14, [rdx + 896]
vmovdqu64 zmm15, [rdx + 960]
.Lflock_ab_bank_windows_2_0_w:
mov eax, 7
.Lflock_ab_bank_windows_2_0_pair:
test r9, r9
jz .Lflock_ab_bank_windows_2_0_no_pf
prefetcht0 [rdi + r9]
prefetcht0 [rdi + r9 + 64]
.Lflock_ab_bank_windows_2_0_no_pf:
vmovdqu64 zmm16, [rdi]
vmovdqu64 zmm17, [rdi + 64]
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 0]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 128]{1to8}, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 8]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 136]{1to8}, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 16]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 144]{1to8}, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 24]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 152]{1to8}, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 32]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 160]{1to8}, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 40]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 168]{1to8}, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 48]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 176]{1to8}, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 56]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 184]{1to8}, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 64]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 192]{1to8}, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 72]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 200]{1to8}, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 80]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 208]{1to8}, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 88]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 216]{1to8}, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 96]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 224]{1to8}, 0
vpternlogq zmm12, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 104]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 232]{1to8}, 0
vpternlogq zmm13, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 112]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 240]{1to8}, 0
vpternlogq zmm14, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 120]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 248]{1to8}, 0
vpternlogq zmm15, zmm18, zmm19, 0x96
add rdi, 128
add rsi, 256
dec eax
jnz .Lflock_ab_bank_windows_2_0_pair
add rdi, rcx
add rsi, 256
dec r8
jnz .Lflock_ab_bank_windows_2_0_w
vmovdqu64 [rdx + 0], zmm0
vmovdqu64 [rdx + 64], zmm1
vmovdqu64 [rdx + 128], zmm2
vmovdqu64 [rdx + 192], zmm3
vmovdqu64 [rdx + 256], zmm4
vmovdqu64 [rdx + 320], zmm5
vmovdqu64 [rdx + 384], zmm6
vmovdqu64 [rdx + 448], zmm7
vmovdqu64 [rdx + 512], zmm8
vmovdqu64 [rdx + 576], zmm9
vmovdqu64 [rdx + 640], zmm10
vmovdqu64 [rdx + 704], zmm11
vmovdqu64 [rdx + 768], zmm12
vmovdqu64 [rdx + 832], zmm13
vmovdqu64 [rdx + 896], zmm14
vmovdqu64 [rdx + 960], zmm15
ret
.size flock_ab_bank_windows_2_0,.-flock_ab_bank_windows_2_0
.text
.p2align 6
.global flock_ab_bank_windows_2_1
.hidden flock_ab_bank_windows_2_1
.type flock_ab_bank_windows_2_1,@function
flock_ab_bank_windows_2_1:
sub rcx, 896
add rsi, 256
vpxorq zmm0, zmm0, zmm0
vpxorq zmm1, zmm1, zmm1
vpxorq zmm2, zmm2, zmm2
vpxorq zmm3, zmm3, zmm3
vpxorq zmm4, zmm4, zmm4
vpxorq zmm5, zmm5, zmm5
vpxorq zmm6, zmm6, zmm6
vpxorq zmm7, zmm7, zmm7
vpxorq zmm8, zmm8, zmm8
vpxorq zmm9, zmm9, zmm9
vpxorq zmm10, zmm10, zmm10
vpxorq zmm11, zmm11, zmm11
vpxorq zmm12, zmm12, zmm12
vpxorq zmm13, zmm13, zmm13
vpxorq zmm14, zmm14, zmm14
vpxorq zmm15, zmm15, zmm15
.Lflock_ab_bank_windows_2_1_w:
mov eax, 7
.Lflock_ab_bank_windows_2_1_pair:
test r9, r9
jz .Lflock_ab_bank_windows_2_1_no_pf
prefetcht0 [rdi + r9]
prefetcht0 [rdi + r9 + 64]
.Lflock_ab_bank_windows_2_1_no_pf:
vmovdqu64 zmm16, [rdi]
vmovdqu64 zmm17, [rdi + 64]
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 0]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 128]{1to8}, 0
vpternlogq zmm0, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 8]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 136]{1to8}, 0
vpternlogq zmm1, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 16]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 144]{1to8}, 0
vpternlogq zmm2, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 24]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 152]{1to8}, 0
vpternlogq zmm3, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 32]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 160]{1to8}, 0
vpternlogq zmm4, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 40]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 168]{1to8}, 0
vpternlogq zmm5, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 48]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 176]{1to8}, 0
vpternlogq zmm6, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 56]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 184]{1to8}, 0
vpternlogq zmm7, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 64]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 192]{1to8}, 0
vpternlogq zmm8, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 72]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 200]{1to8}, 0
vpternlogq zmm9, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 80]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 208]{1to8}, 0
vpternlogq zmm10, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 88]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 216]{1to8}, 0
vpternlogq zmm11, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 96]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 224]{1to8}, 0
vpternlogq zmm12, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 104]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 232]{1to8}, 0
vpternlogq zmm13, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 112]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 240]{1to8}, 0
vpternlogq zmm14, zmm18, zmm19, 0x96
vgf2p8affineqb zmm18, zmm16, QWORD PTR [rsi + 120]{1to8}, 0
vgf2p8affineqb zmm19, zmm17, QWORD PTR [rsi + 248]{1to8}, 0
vpternlogq zmm15, zmm18, zmm19, 0x96
add rdi, 128
add rsi, 256
dec eax
jnz .Lflock_ab_bank_windows_2_1_pair
add rdi, rcx
add rsi, 256
dec r8
jnz .Lflock_ab_bank_windows_2_1_w
vmovdqu64 [rdx + 0], zmm0
vmovdqu64 [rdx + 64], zmm1
vmovdqu64 [rdx + 128], zmm2
vmovdqu64 [rdx + 192], zmm3
vmovdqu64 [rdx + 256], zmm4
vmovdqu64 [rdx + 320], zmm5
vmovdqu64 [rdx + 384], zmm6
vmovdqu64 [rdx + 448], zmm7
vmovdqu64 [rdx + 512], zmm8
vmovdqu64 [rdx + 576], zmm9
vmovdqu64 [rdx + 640], zmm10
vmovdqu64 [rdx + 704], zmm11
vmovdqu64 [rdx + 768], zmm12
vmovdqu64 [rdx + 832], zmm13
vmovdqu64 [rdx + 896], zmm14
vmovdqu64 [rdx + 960], zmm15
ret
.size flock_ab_bank_windows_2_1,.-flock_ab_bank_windows_2_1
.section .note.GNU-stack,"",@progbits
