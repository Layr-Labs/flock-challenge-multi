.text
.p2align 6
.globl flock_ab_crt57_bank_m0
.type flock_ab_crt57_bank_m0,@function
flock_ab_crt57_bank_m0:
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
mov r8,rdi
lea r9,[rsi+0]
mov ecx,32
.p2align 5
.Lcrt57_m0_g0:
vmovdqu64 zmm14,ZMMWORD PTR [r8+0]
vmovdqu64 zmm15,ZMMWORD PTR [r8+64]
vmovdqu64 zmm16,ZMMWORD PTR [r8+128]
vmovdqu64 zmm17,ZMMWORD PTR [r8+192]
vmovdqu64 zmm18,ZMMWORD PTR [r8+256]
vmovdqu64 zmm19,ZMMWORD PTR [r8+320]
vmovdqu64 zmm20,ZMMWORD PTR [r8+384]
vmovdqu64 zmm21,ZMMWORD PTR [r8+448]
vmovdqu64 zmm22,ZMMWORD PTR [r8+512]
vmovdqu64 zmm23,ZMMWORD PTR [r8+576]
vmovdqu64 zmm24,ZMMWORD PTR [r8+640]
vmovdqu64 zmm25,ZMMWORD PTR [r8+704]
vmovdqu64 zmm26,ZMMWORD PTR [r8+768]
vmovdqu64 zmm27,ZMMWORD PTR [r8+832]
vpternlogq zmm21,zmm16,zmm26,0x96
vpternlogq zmm23,zmm18,zmm21,0x96
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+0]{1to8},0
vpternlogq zmm22,zmm21,zmm27,0x96
vpxorq zmm17,zmm17,zmm22
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+8]{1to8},0
vpxorq zmm23,zmm23,zmm17
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+16]{1to8},0
vpternlogq zmm14,zmm19,zmm24,0x96
vpxorq zmm21,zmm21,zmm14
vgf2p8affineqb zmm31,zmm21,QWORD PTR [r9+24]{1to8},0
vpxorq zmm10,zmm10,zmm29
vpxorq zmm11,zmm11,zmm28
vpternlogq zmm12,zmm30,zmm31,0x96
vpternlogq zmm13,zmm29,zmm31,0x96
vpternlogq zmm17,zmm21,zmm23,0x96
vgf2p8affineqb zmm28,zmm17,QWORD PTR [r9+32]{1to8},0
vpternlogq zmm14,zmm20,zmm25,0x96
vpxorq zmm15,zmm15,zmm14
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+40]{1to8},0
vpxorq zmm15,zmm15,zmm17
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+48]{1to8},0
vpxorq zmm23,zmm23,zmm15
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+56]{1to8},0
vpternlogq zmm10,zmm28,zmm30,0x96
vpxorq zmm10,zmm10,zmm31
vpternlogq zmm11,zmm28,zmm29,0x96
vpxorq zmm11,zmm11,zmm31
vpternlogq zmm12,zmm28,zmm31,0x96
vpternlogq zmm13,zmm28,zmm29,0x96
vpxorq zmm23,zmm23,zmm21
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+64]{1to8},0
vpternlogq zmm19,zmm21,zmm22,0x96
vpternlogq zmm15,zmm19,zmm20,0x96
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+72]{1to8},0
vpternlogq zmm27,zmm20,zmm23,0x96
vpternlogq zmm26,zmm24,zmm27,0x96
vgf2p8affineqb zmm30,zmm26,QWORD PTR [r9+80]{1to8},0
vpxorq zmm26,zmm26,zmm15
vgf2p8affineqb zmm31,zmm26,QWORD PTR [r9+88]{1to8},0
vpxorq zmm6,zmm6,zmm31
vpternlogq zmm7,zmm29,zmm31,0x96
vpternlogq zmm9,zmm29,zmm30,0x96
vpxorq zmm13,zmm13,zmm28
vpternlogq zmm24,zmm14,zmm17,0x96
vpternlogq zmm16,zmm21,zmm24,0x96
vgf2p8affineqb zmm28,zmm16,QWORD PTR [r9+96]{1to8},0
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+104]{1to8},0
vpternlogq zmm27,zmm18,zmm24,0x96
vpternlogq zmm22,zmm15,zmm27,0x96
vgf2p8affineqb zmm30,zmm22,QWORD PTR [r9+112]{1to8},0
vpxorq zmm22,zmm22,zmm16
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+120]{1to8},0
vpternlogq zmm6,zmm28,zmm29,0x96
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm28,zmm29,0x96
vpternlogq zmm8,zmm28,zmm29,0x96
vpxorq zmm8,zmm8,zmm30
vpxorq zmm9,zmm9,zmm28
vpternlogq zmm22,zmm15,zmm26,0x96
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+128]{1to8},0
vpternlogq zmm16,zmm15,zmm22,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm21,zmm17,zmm27,0x96
vpxorq zmm21,zmm21,zmm19
vgf2p8affineqb zmm30,zmm21,QWORD PTR [r9+144]{1to8},0
vpternlogq zmm20,zmm19,zmm25,0x96
vpternlogq zmm22,zmm20,zmm26,0x96
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm5,zmm5,zmm30
vpxorq zmm7,zmm7,zmm29
vpternlogq zmm8,zmm28,zmm29,0x96
vpternlogq zmm9,zmm28,zmm29,0x96
vpxorq zmm22,zmm22,zmm21
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm18,zmm16,zmm22,0x96
vpternlogq zmm19,zmm18,zmm26,0x96
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+168]{1to8},0
vpternlogq zmm24,zmm20,zmm26,0x96
vpternlogq zmm15,zmm17,zmm24,0x96
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+176]{1to8},0
vpxorq zmm15,zmm15,zmm21
vgf2p8affineqb zmm31,zmm15,QWORD PTR [r9+184]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm28
vpternlogq zmm4,zmm28,zmm31,0x96
vpternlogq zmm5,zmm28,zmm30,0x96
vpxorq zmm5,zmm5,zmm31
vpternlogq zmm24,zmm14,zmm21,0x96
vgf2p8affineqb zmm28,zmm24,QWORD PTR [r9+192]{1to8},0
vpxorq zmm19,zmm19,zmm24
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+200]{1to8},0
vpternlogq zmm24,zmm18,zmm20,0x96
vgf2p8affineqb zmm30,zmm24,QWORD PTR [r9+208]{1to8},0
vpxorq zmm24,zmm24,zmm15
vgf2p8affineqb zmm31,zmm24,QWORD PTR [r9+216]{1to8},0
vpternlogq zmm0,zmm28,zmm29,0x96
vpxorq zmm1,zmm1,zmm29
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm4,zmm4,zmm30
vpternlogq zmm5,zmm30,zmm31,0x96
vpternlogq zmm15,zmm22,zmm24,0x96
vgf2p8affineqb zmm28,zmm15,QWORD PTR [r9+224]{1to8},0
vpternlogq zmm21,zmm22,zmm24,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+232]{1to8},0
vpternlogq zmm3,zmm28,zmm29,0x96
vpxorq zmm4,zmm4,zmm29
vpternlogq zmm5,zmm28,zmm29,0x96
add r8,118784
add r9,240
dec ecx
jnz .Lcrt57_m0_g0
vmovdqu64 ZMMWORD PTR [rdx+384],zmm0
vmovdqu64 ZMMWORD PTR [rdx+448],zmm1
vmovdqu64 ZMMWORD PTR [rdx+896],zmm2
vmovdqu64 ZMMWORD PTR [rdx+960],zmm3
vmovdqu64 ZMMWORD PTR [rdx+1024],zmm4
vmovdqu64 ZMMWORD PTR [rdx+1088],zmm5
vmovdqu64 ZMMWORD PTR [rdx+1152],zmm6
vmovdqu64 ZMMWORD PTR [rdx+1216],zmm7
vmovdqu64 ZMMWORD PTR [rdx+1280],zmm8
vmovdqu64 ZMMWORD PTR [rdx+1344],zmm9
vmovdqu64 ZMMWORD PTR [rdx+1408],zmm10
vmovdqu64 ZMMWORD PTR [rdx+1472],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1536],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1600],zmm13
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
vpxorq zmm14,zmm14,zmm14
mov r8,rdi
lea r9,[rsi+7680]
mov ecx,32
.p2align 5
.Lcrt57_m0_g1:
vmovdqu64 zmm15,ZMMWORD PTR [r8+0]
vmovdqu64 zmm16,ZMMWORD PTR [r8+64]
vmovdqu64 zmm17,ZMMWORD PTR [r8+128]
vmovdqu64 zmm18,ZMMWORD PTR [r8+192]
vmovdqu64 zmm19,ZMMWORD PTR [r8+256]
vmovdqu64 zmm20,ZMMWORD PTR [r8+320]
vmovdqu64 zmm21,ZMMWORD PTR [r8+384]
vmovdqu64 zmm22,ZMMWORD PTR [r8+448]
vmovdqu64 zmm23,ZMMWORD PTR [r8+512]
vmovdqu64 zmm24,ZMMWORD PTR [r8+576]
vmovdqu64 zmm25,ZMMWORD PTR [r8+640]
vmovdqu64 zmm26,ZMMWORD PTR [r8+704]
vmovdqu64 zmm27,ZMMWORD PTR [r8+768]
vmovdqu64 zmm28,ZMMWORD PTR [r8+832]
vgf2p8affineqb zmm29,zmm26,QWORD PTR [r9+0]{1to8},0
vgf2p8affineqb zmm30,zmm27,QWORD PTR [r9+8]{1to8},0
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+16]{1to8},0
vpxorq zmm2,zmm2,zmm31
vpxorq zmm13,zmm13,zmm30
vpternlogq zmm14,zmm29,zmm30,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+24]{1to8},0
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+32]{1to8},0
vgf2p8affineqb zmm31,zmm28,QWORD PTR [r9+40]{1to8},0
vpxorq zmm0,zmm0,zmm30
vpternlogq zmm1,zmm29,zmm30,0x96
vpternlogq zmm2,zmm29,zmm30,0x96
vpxorq zmm12,zmm12,zmm31
vpxorq zmm13,zmm13,zmm31
vpxorq zmm14,zmm14,zmm31
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+48]{1to8},0
vpxorq zmm17,zmm17,zmm15
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+56]{1to8},0
vpxorq zmm27,zmm27,zmm28
vgf2p8affineqb zmm31,zmm27,QWORD PTR [r9+64]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm30
vpxorq zmm13,zmm13,zmm31
vpxorq zmm28,zmm28,zmm26
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+72]{1to8},0
vpternlogq zmm20,zmm24,zmm27,0x96
vpternlogq zmm23,zmm16,zmm19,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+80]{1to8},0
vpternlogq zmm20,zmm21,zmm22,0x96
vpxorq zmm17,zmm17,zmm20
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+88]{1to8},0
vpxorq zmm5,zmm5,zmm30
vpxorq zmm11,zmm11,zmm31
vpxorq zmm14,zmm14,zmm29
vpternlogq zmm28,zmm20,zmm23,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+96]{1to8},0
vpternlogq zmm18,zmm15,zmm25,0x96
vpternlogq zmm20,zmm18,zmm24,0x96
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+104]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+112]{1to8},0
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm29,zmm30,0x96
vpternlogq zmm8,zmm30,zmm31,0x96
vpternlogq zmm15,zmm19,zmm26,0x96
vpternlogq zmm22,zmm15,zmm17,0x96
vgf2p8affineqb zmm29,zmm22,QWORD PTR [r9+120]{1to8},0
vpxorq zmm20,zmm20,zmm22
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+128]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm6,zmm29,zmm30,0x96
vpxorq zmm7,zmm7,zmm30
vpxorq zmm8,zmm8,zmm31
vpternlogq zmm28,zmm15,zmm18,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+144]{1to8},0
vpxorq zmm17,zmm17,zmm28
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm23,zmm15,zmm21,0x96
vpternlogq zmm19,zmm23,zmm24,0x96
vgf2p8affineqb zmm31,zmm19,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm9,zmm30,zmm31,0x96
vpternlogq zmm10,zmm29,zmm31,0x96
vpxorq zmm11,zmm11,zmm30
vpxorq zmm17,zmm17,zmm19
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+168]{1to8},0
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm30,zmm19,QWORD PTR [r9+176]{1to8},0
vpternlogq zmm20,zmm24,zmm26,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+184]{1to8},0
vpxorq zmm3,zmm3,zmm31
vpxorq zmm4,zmm4,zmm31
vpxorq zmm5,zmm5,zmm31
vpxorq zmm9,zmm9,zmm30
vpternlogq zmm10,zmm29,zmm30,0x96
vpternlogq zmm11,zmm29,zmm30,0x96
vpternlogq zmm21,zmm15,zmm20,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+192]{1to8},0
vpternlogq zmm27,zmm20,zmm28,0x96
vpternlogq zmm25,zmm16,zmm27,0x96
vgf2p8affineqb zmm30,zmm25,QWORD PTR [r9+200]{1to8},0
vpxorq zmm25,zmm25,zmm23
vgf2p8affineqb zmm31,zmm25,QWORD PTR [r9+208]{1to8},0
vpternlogq zmm4,zmm30,zmm31,0x96
vpternlogq zmm5,zmm29,zmm31,0x96
add r8,118784
add r9,216
dec ecx
jnz .Lcrt57_m0_g1
vmovdqu64 ZMMWORD PTR [rdx+0],zmm0
vmovdqu64 ZMMWORD PTR [rdx+64],zmm1
vmovdqu64 ZMMWORD PTR [rdx+128],zmm2
vmovdqu64 ZMMWORD PTR [rdx+192],zmm3
vmovdqu64 ZMMWORD PTR [rdx+256],zmm4
vmovdqu64 ZMMWORD PTR [rdx+320],zmm5
vmovdqu64 ZMMWORD PTR [rdx+512],zmm6
vmovdqu64 ZMMWORD PTR [rdx+576],zmm7
vmovdqu64 ZMMWORD PTR [rdx+640],zmm8
vmovdqu64 ZMMWORD PTR [rdx+704],zmm9
vmovdqu64 ZMMWORD PTR [rdx+768],zmm10
vmovdqu64 ZMMWORD PTR [rdx+832],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1664],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1728],zmm13
vmovdqu64 ZMMWORD PTR [rdx+1792],zmm14
vzeroupper
ret
.size flock_ab_crt57_bank_m0,.-flock_ab_crt57_bank_m0
.p2align 6
.globl flock_ab_crt57_bank_m1
.type flock_ab_crt57_bank_m1,@function
flock_ab_crt57_bank_m1:
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
mov r8,rdi
lea r9,[rsi+0]
mov ecx,32
.p2align 5
.Lcrt57_m1_g0:
lea r11,[r8+237568]
cmp ecx,2
cmovbe r11,r8
vmovdqu64 zmm14,ZMMWORD PTR [r8+0]
vmovdqu64 zmm15,ZMMWORD PTR [r8+64]
vmovdqu64 zmm16,ZMMWORD PTR [r8+128]
vmovdqu64 zmm17,ZMMWORD PTR [r8+192]
vmovdqu64 zmm18,ZMMWORD PTR [r8+256]
vmovdqu64 zmm19,ZMMWORD PTR [r8+320]
vmovdqu64 zmm20,ZMMWORD PTR [r8+384]
vmovdqu64 zmm21,ZMMWORD PTR [r8+448]
vmovdqu64 zmm22,ZMMWORD PTR [r8+512]
vmovdqu64 zmm23,ZMMWORD PTR [r8+576]
vmovdqu64 zmm24,ZMMWORD PTR [r8+640]
vmovdqu64 zmm25,ZMMWORD PTR [r8+704]
vmovdqu64 zmm26,ZMMWORD PTR [r8+768]
vmovdqu64 zmm27,ZMMWORD PTR [r8+832]
vpternlogq zmm21,zmm16,zmm26,0x96
vpternlogq zmm23,zmm18,zmm21,0x96
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+0]{1to8},0
prefetcht1 BYTE PTR [r11+0]
vpternlogq zmm22,zmm21,zmm27,0x96
vpxorq zmm17,zmm17,zmm22
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+8]{1to8},0
prefetcht1 BYTE PTR [r11+64]
vpxorq zmm23,zmm23,zmm17
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+16]{1to8},0
prefetcht1 BYTE PTR [r11+128]
vpternlogq zmm14,zmm19,zmm24,0x96
vpxorq zmm21,zmm21,zmm14
vgf2p8affineqb zmm31,zmm21,QWORD PTR [r9+24]{1to8},0
prefetcht1 BYTE PTR [r11+192]
vpxorq zmm10,zmm10,zmm29
vpxorq zmm11,zmm11,zmm28
vpternlogq zmm12,zmm30,zmm31,0x96
vpternlogq zmm13,zmm29,zmm31,0x96
vpternlogq zmm17,zmm21,zmm23,0x96
vgf2p8affineqb zmm28,zmm17,QWORD PTR [r9+32]{1to8},0
prefetcht1 BYTE PTR [r11+256]
vpternlogq zmm14,zmm20,zmm25,0x96
vpxorq zmm15,zmm15,zmm14
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+40]{1to8},0
prefetcht1 BYTE PTR [r11+320]
vpxorq zmm15,zmm15,zmm17
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+48]{1to8},0
prefetcht1 BYTE PTR [r11+384]
vpxorq zmm23,zmm23,zmm15
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+56]{1to8},0
prefetcht1 BYTE PTR [r11+448]
vpternlogq zmm10,zmm28,zmm30,0x96
vpxorq zmm10,zmm10,zmm31
vpternlogq zmm11,zmm28,zmm29,0x96
vpxorq zmm11,zmm11,zmm31
vpternlogq zmm12,zmm28,zmm31,0x96
vpternlogq zmm13,zmm28,zmm29,0x96
vpxorq zmm23,zmm23,zmm21
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+64]{1to8},0
prefetcht1 BYTE PTR [r11+512]
vpternlogq zmm19,zmm21,zmm22,0x96
vpternlogq zmm15,zmm19,zmm20,0x96
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+72]{1to8},0
prefetcht1 BYTE PTR [r11+576]
vpternlogq zmm27,zmm20,zmm23,0x96
vpternlogq zmm26,zmm24,zmm27,0x96
vgf2p8affineqb zmm30,zmm26,QWORD PTR [r9+80]{1to8},0
prefetcht1 BYTE PTR [r11+640]
vpxorq zmm26,zmm26,zmm15
vgf2p8affineqb zmm31,zmm26,QWORD PTR [r9+88]{1to8},0
prefetcht1 BYTE PTR [r11+704]
vpxorq zmm6,zmm6,zmm31
vpternlogq zmm7,zmm29,zmm31,0x96
vpternlogq zmm9,zmm29,zmm30,0x96
vpxorq zmm13,zmm13,zmm28
vpternlogq zmm24,zmm14,zmm17,0x96
vpternlogq zmm16,zmm21,zmm24,0x96
vgf2p8affineqb zmm28,zmm16,QWORD PTR [r9+96]{1to8},0
prefetcht1 BYTE PTR [r11+768]
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+104]{1to8},0
prefetcht1 BYTE PTR [r11+832]
vpternlogq zmm27,zmm18,zmm24,0x96
vpternlogq zmm22,zmm15,zmm27,0x96
vgf2p8affineqb zmm30,zmm22,QWORD PTR [r9+112]{1to8},0
vpxorq zmm22,zmm22,zmm16
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+120]{1to8},0
vpternlogq zmm6,zmm28,zmm29,0x96
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm28,zmm29,0x96
vpternlogq zmm8,zmm28,zmm29,0x96
vpxorq zmm8,zmm8,zmm30
vpxorq zmm9,zmm9,zmm28
vpternlogq zmm22,zmm15,zmm26,0x96
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+128]{1to8},0
vpternlogq zmm16,zmm15,zmm22,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm21,zmm17,zmm27,0x96
vpxorq zmm21,zmm21,zmm19
vgf2p8affineqb zmm30,zmm21,QWORD PTR [r9+144]{1to8},0
vpternlogq zmm20,zmm19,zmm25,0x96
vpternlogq zmm22,zmm20,zmm26,0x96
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm5,zmm5,zmm30
vpxorq zmm7,zmm7,zmm29
vpternlogq zmm8,zmm28,zmm29,0x96
vpternlogq zmm9,zmm28,zmm29,0x96
vpxorq zmm22,zmm22,zmm21
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm18,zmm16,zmm22,0x96
vpternlogq zmm19,zmm18,zmm26,0x96
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+168]{1to8},0
vpternlogq zmm24,zmm20,zmm26,0x96
vpternlogq zmm15,zmm17,zmm24,0x96
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+176]{1to8},0
vpxorq zmm15,zmm15,zmm21
vgf2p8affineqb zmm31,zmm15,QWORD PTR [r9+184]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm28
vpternlogq zmm4,zmm28,zmm31,0x96
vpternlogq zmm5,zmm28,zmm30,0x96
vpxorq zmm5,zmm5,zmm31
vpternlogq zmm24,zmm14,zmm21,0x96
vgf2p8affineqb zmm28,zmm24,QWORD PTR [r9+192]{1to8},0
vpxorq zmm19,zmm19,zmm24
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+200]{1to8},0
vpternlogq zmm24,zmm18,zmm20,0x96
vgf2p8affineqb zmm30,zmm24,QWORD PTR [r9+208]{1to8},0
vpxorq zmm24,zmm24,zmm15
vgf2p8affineqb zmm31,zmm24,QWORD PTR [r9+216]{1to8},0
vpternlogq zmm0,zmm28,zmm29,0x96
vpxorq zmm1,zmm1,zmm29
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm4,zmm4,zmm30
vpternlogq zmm5,zmm30,zmm31,0x96
vpternlogq zmm15,zmm22,zmm24,0x96
vgf2p8affineqb zmm28,zmm15,QWORD PTR [r9+224]{1to8},0
vpternlogq zmm21,zmm22,zmm24,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+232]{1to8},0
vpternlogq zmm3,zmm28,zmm29,0x96
vpxorq zmm4,zmm4,zmm29
vpternlogq zmm5,zmm28,zmm29,0x96
add r8,118784
add r9,240
dec ecx
jnz .Lcrt57_m1_g0
vmovdqu64 ZMMWORD PTR [rdx+384],zmm0
vmovdqu64 ZMMWORD PTR [rdx+448],zmm1
vmovdqu64 ZMMWORD PTR [rdx+896],zmm2
vmovdqu64 ZMMWORD PTR [rdx+960],zmm3
vmovdqu64 ZMMWORD PTR [rdx+1024],zmm4
vmovdqu64 ZMMWORD PTR [rdx+1088],zmm5
vmovdqu64 ZMMWORD PTR [rdx+1152],zmm6
vmovdqu64 ZMMWORD PTR [rdx+1216],zmm7
vmovdqu64 ZMMWORD PTR [rdx+1280],zmm8
vmovdqu64 ZMMWORD PTR [rdx+1344],zmm9
vmovdqu64 ZMMWORD PTR [rdx+1408],zmm10
vmovdqu64 ZMMWORD PTR [rdx+1472],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1536],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1600],zmm13
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
vpxorq zmm14,zmm14,zmm14
mov r8,rdi
lea r9,[rsi+7680]
mov ecx,32
.p2align 5
.Lcrt57_m1_g1:
vmovdqu64 zmm15,ZMMWORD PTR [r8+0]
vmovdqu64 zmm16,ZMMWORD PTR [r8+64]
vmovdqu64 zmm17,ZMMWORD PTR [r8+128]
vmovdqu64 zmm18,ZMMWORD PTR [r8+192]
vmovdqu64 zmm19,ZMMWORD PTR [r8+256]
vmovdqu64 zmm20,ZMMWORD PTR [r8+320]
vmovdqu64 zmm21,ZMMWORD PTR [r8+384]
vmovdqu64 zmm22,ZMMWORD PTR [r8+448]
vmovdqu64 zmm23,ZMMWORD PTR [r8+512]
vmovdqu64 zmm24,ZMMWORD PTR [r8+576]
vmovdqu64 zmm25,ZMMWORD PTR [r8+640]
vmovdqu64 zmm26,ZMMWORD PTR [r8+704]
vmovdqu64 zmm27,ZMMWORD PTR [r8+768]
vmovdqu64 zmm28,ZMMWORD PTR [r8+832]
vgf2p8affineqb zmm29,zmm26,QWORD PTR [r9+0]{1to8},0
vgf2p8affineqb zmm30,zmm27,QWORD PTR [r9+8]{1to8},0
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+16]{1to8},0
vpxorq zmm2,zmm2,zmm31
vpxorq zmm13,zmm13,zmm30
vpternlogq zmm14,zmm29,zmm30,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+24]{1to8},0
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+32]{1to8},0
vgf2p8affineqb zmm31,zmm28,QWORD PTR [r9+40]{1to8},0
vpxorq zmm0,zmm0,zmm30
vpternlogq zmm1,zmm29,zmm30,0x96
vpternlogq zmm2,zmm29,zmm30,0x96
vpxorq zmm12,zmm12,zmm31
vpxorq zmm13,zmm13,zmm31
vpxorq zmm14,zmm14,zmm31
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+48]{1to8},0
vpxorq zmm17,zmm17,zmm15
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+56]{1to8},0
vpxorq zmm27,zmm27,zmm28
vgf2p8affineqb zmm31,zmm27,QWORD PTR [r9+64]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm30
vpxorq zmm13,zmm13,zmm31
vpxorq zmm28,zmm28,zmm26
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+72]{1to8},0
vpternlogq zmm20,zmm24,zmm27,0x96
vpternlogq zmm23,zmm16,zmm19,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+80]{1to8},0
vpternlogq zmm20,zmm21,zmm22,0x96
vpxorq zmm17,zmm17,zmm20
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+88]{1to8},0
vpxorq zmm5,zmm5,zmm30
vpxorq zmm11,zmm11,zmm31
vpxorq zmm14,zmm14,zmm29
vpternlogq zmm28,zmm20,zmm23,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+96]{1to8},0
vpternlogq zmm18,zmm15,zmm25,0x96
vpternlogq zmm20,zmm18,zmm24,0x96
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+104]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+112]{1to8},0
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm29,zmm30,0x96
vpternlogq zmm8,zmm30,zmm31,0x96
vpternlogq zmm15,zmm19,zmm26,0x96
vpternlogq zmm22,zmm15,zmm17,0x96
vgf2p8affineqb zmm29,zmm22,QWORD PTR [r9+120]{1to8},0
vpxorq zmm20,zmm20,zmm22
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+128]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm6,zmm29,zmm30,0x96
vpxorq zmm7,zmm7,zmm30
vpxorq zmm8,zmm8,zmm31
vpternlogq zmm28,zmm15,zmm18,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+144]{1to8},0
vpxorq zmm17,zmm17,zmm28
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm23,zmm15,zmm21,0x96
vpternlogq zmm19,zmm23,zmm24,0x96
vgf2p8affineqb zmm31,zmm19,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm9,zmm30,zmm31,0x96
vpternlogq zmm10,zmm29,zmm31,0x96
vpxorq zmm11,zmm11,zmm30
vpxorq zmm17,zmm17,zmm19
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+168]{1to8},0
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm30,zmm19,QWORD PTR [r9+176]{1to8},0
vpternlogq zmm20,zmm24,zmm26,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+184]{1to8},0
vpxorq zmm3,zmm3,zmm31
vpxorq zmm4,zmm4,zmm31
vpxorq zmm5,zmm5,zmm31
vpxorq zmm9,zmm9,zmm30
vpternlogq zmm10,zmm29,zmm30,0x96
vpternlogq zmm11,zmm29,zmm30,0x96
vpternlogq zmm21,zmm15,zmm20,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+192]{1to8},0
vpternlogq zmm27,zmm20,zmm28,0x96
vpternlogq zmm25,zmm16,zmm27,0x96
vgf2p8affineqb zmm30,zmm25,QWORD PTR [r9+200]{1to8},0
vpxorq zmm25,zmm25,zmm23
vgf2p8affineqb zmm31,zmm25,QWORD PTR [r9+208]{1to8},0
vpternlogq zmm4,zmm30,zmm31,0x96
vpternlogq zmm5,zmm29,zmm31,0x96
add r8,118784
add r9,216
dec ecx
jnz .Lcrt57_m1_g1
vmovdqu64 ZMMWORD PTR [rdx+0],zmm0
vmovdqu64 ZMMWORD PTR [rdx+64],zmm1
vmovdqu64 ZMMWORD PTR [rdx+128],zmm2
vmovdqu64 ZMMWORD PTR [rdx+192],zmm3
vmovdqu64 ZMMWORD PTR [rdx+256],zmm4
vmovdqu64 ZMMWORD PTR [rdx+320],zmm5
vmovdqu64 ZMMWORD PTR [rdx+512],zmm6
vmovdqu64 ZMMWORD PTR [rdx+576],zmm7
vmovdqu64 ZMMWORD PTR [rdx+640],zmm8
vmovdqu64 ZMMWORD PTR [rdx+704],zmm9
vmovdqu64 ZMMWORD PTR [rdx+768],zmm10
vmovdqu64 ZMMWORD PTR [rdx+832],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1664],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1728],zmm13
vmovdqu64 ZMMWORD PTR [rdx+1792],zmm14
vzeroupper
ret
.size flock_ab_crt57_bank_m1,.-flock_ab_crt57_bank_m1
.p2align 6
.globl flock_ab_crt57_bank_m2
.type flock_ab_crt57_bank_m2,@function
flock_ab_crt57_bank_m2:
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
mov r8,rdi
lea r9,[rsi+0]
mov ecx,32
.p2align 5
.Lcrt57_m2_g0:
vmovdqu64 zmm14,ZMMWORD PTR [r8+0]
vmovdqu64 zmm15,ZMMWORD PTR [r8+64]
vmovdqu64 zmm16,ZMMWORD PTR [r8+128]
vmovdqu64 zmm17,ZMMWORD PTR [r8+192]
vmovdqu64 zmm18,ZMMWORD PTR [r8+256]
vmovdqu64 zmm19,ZMMWORD PTR [r8+320]
vmovdqu64 zmm20,ZMMWORD PTR [r8+384]
vmovdqu64 zmm21,ZMMWORD PTR [r8+448]
vmovdqu64 zmm22,ZMMWORD PTR [r8+512]
vmovdqu64 zmm23,ZMMWORD PTR [r8+576]
vmovdqu64 zmm24,ZMMWORD PTR [r8+640]
vmovdqu64 zmm25,ZMMWORD PTR [r8+704]
vmovdqu64 zmm26,ZMMWORD PTR [r8+768]
vmovdqu64 zmm27,ZMMWORD PTR [r8+832]
prefetcht1 BYTE PTR [r8+0]
prefetcht1 BYTE PTR [r8+64]
prefetcht1 BYTE PTR [r8+128]
prefetcht1 BYTE PTR [r8+192]
prefetcht1 BYTE PTR [r8+256]
prefetcht1 BYTE PTR [r8+320]
prefetcht1 BYTE PTR [r8+384]
prefetcht1 BYTE PTR [r8+448]
prefetcht1 BYTE PTR [r8+512]
prefetcht1 BYTE PTR [r8+576]
prefetcht1 BYTE PTR [r8+640]
prefetcht1 BYTE PTR [r8+704]
prefetcht1 BYTE PTR [r8+768]
prefetcht1 BYTE PTR [r8+832]
vpternlogq zmm21,zmm16,zmm26,0x96
vpternlogq zmm23,zmm18,zmm21,0x96
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+0]{1to8},0
vpternlogq zmm22,zmm21,zmm27,0x96
vpxorq zmm17,zmm17,zmm22
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+8]{1to8},0
vpxorq zmm23,zmm23,zmm17
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+16]{1to8},0
vpternlogq zmm14,zmm19,zmm24,0x96
vpxorq zmm21,zmm21,zmm14
vgf2p8affineqb zmm31,zmm21,QWORD PTR [r9+24]{1to8},0
vpxorq zmm10,zmm10,zmm29
vpxorq zmm11,zmm11,zmm28
vpternlogq zmm12,zmm30,zmm31,0x96
vpternlogq zmm13,zmm29,zmm31,0x96
vpternlogq zmm17,zmm21,zmm23,0x96
vgf2p8affineqb zmm28,zmm17,QWORD PTR [r9+32]{1to8},0
vpternlogq zmm14,zmm20,zmm25,0x96
vpxorq zmm15,zmm15,zmm14
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+40]{1to8},0
vpxorq zmm15,zmm15,zmm17
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+48]{1to8},0
vpxorq zmm23,zmm23,zmm15
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+56]{1to8},0
vpternlogq zmm10,zmm28,zmm30,0x96
vpxorq zmm10,zmm10,zmm31
vpternlogq zmm11,zmm28,zmm29,0x96
vpxorq zmm11,zmm11,zmm31
vpternlogq zmm12,zmm28,zmm31,0x96
vpternlogq zmm13,zmm28,zmm29,0x96
vpxorq zmm23,zmm23,zmm21
vgf2p8affineqb zmm28,zmm23,QWORD PTR [r9+64]{1to8},0
vpternlogq zmm19,zmm21,zmm22,0x96
vpternlogq zmm15,zmm19,zmm20,0x96
vgf2p8affineqb zmm29,zmm15,QWORD PTR [r9+72]{1to8},0
vpternlogq zmm27,zmm20,zmm23,0x96
vpternlogq zmm26,zmm24,zmm27,0x96
vgf2p8affineqb zmm30,zmm26,QWORD PTR [r9+80]{1to8},0
vpxorq zmm26,zmm26,zmm15
vgf2p8affineqb zmm31,zmm26,QWORD PTR [r9+88]{1to8},0
vpxorq zmm6,zmm6,zmm31
vpternlogq zmm7,zmm29,zmm31,0x96
vpternlogq zmm9,zmm29,zmm30,0x96
vpxorq zmm13,zmm13,zmm28
vpternlogq zmm24,zmm14,zmm17,0x96
vpternlogq zmm16,zmm21,zmm24,0x96
vgf2p8affineqb zmm28,zmm16,QWORD PTR [r9+96]{1to8},0
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+104]{1to8},0
vpternlogq zmm27,zmm18,zmm24,0x96
vpternlogq zmm22,zmm15,zmm27,0x96
vgf2p8affineqb zmm30,zmm22,QWORD PTR [r9+112]{1to8},0
vpxorq zmm22,zmm22,zmm16
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+120]{1to8},0
vpternlogq zmm6,zmm28,zmm29,0x96
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm28,zmm29,0x96
vpternlogq zmm8,zmm28,zmm29,0x96
vpxorq zmm8,zmm8,zmm30
vpxorq zmm9,zmm9,zmm28
vpternlogq zmm22,zmm15,zmm26,0x96
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+128]{1to8},0
vpternlogq zmm16,zmm15,zmm22,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm21,zmm17,zmm27,0x96
vpxorq zmm21,zmm21,zmm19
vgf2p8affineqb zmm30,zmm21,QWORD PTR [r9+144]{1to8},0
vpternlogq zmm20,zmm19,zmm25,0x96
vpternlogq zmm22,zmm20,zmm26,0x96
vgf2p8affineqb zmm31,zmm22,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm5,zmm5,zmm30
vpxorq zmm7,zmm7,zmm29
vpternlogq zmm8,zmm28,zmm29,0x96
vpternlogq zmm9,zmm28,zmm29,0x96
vpxorq zmm22,zmm22,zmm21
vgf2p8affineqb zmm28,zmm22,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm18,zmm16,zmm22,0x96
vpternlogq zmm19,zmm18,zmm26,0x96
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+168]{1to8},0
vpternlogq zmm24,zmm20,zmm26,0x96
vpternlogq zmm15,zmm17,zmm24,0x96
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+176]{1to8},0
vpxorq zmm15,zmm15,zmm21
vgf2p8affineqb zmm31,zmm15,QWORD PTR [r9+184]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm28
vpternlogq zmm4,zmm28,zmm31,0x96
vpternlogq zmm5,zmm28,zmm30,0x96
vpxorq zmm5,zmm5,zmm31
vpternlogq zmm24,zmm14,zmm21,0x96
vgf2p8affineqb zmm28,zmm24,QWORD PTR [r9+192]{1to8},0
vpxorq zmm19,zmm19,zmm24
vgf2p8affineqb zmm29,zmm19,QWORD PTR [r9+200]{1to8},0
vpternlogq zmm24,zmm18,zmm20,0x96
vgf2p8affineqb zmm30,zmm24,QWORD PTR [r9+208]{1to8},0
vpxorq zmm24,zmm24,zmm15
vgf2p8affineqb zmm31,zmm24,QWORD PTR [r9+216]{1to8},0
vpternlogq zmm0,zmm28,zmm29,0x96
vpxorq zmm1,zmm1,zmm29
vpternlogq zmm2,zmm30,zmm31,0x96
vpxorq zmm3,zmm3,zmm30
vpxorq zmm4,zmm4,zmm30
vpternlogq zmm5,zmm30,zmm31,0x96
vpternlogq zmm15,zmm22,zmm24,0x96
vgf2p8affineqb zmm28,zmm15,QWORD PTR [r9+224]{1to8},0
vpternlogq zmm21,zmm22,zmm24,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+232]{1to8},0
vpternlogq zmm3,zmm28,zmm29,0x96
vpxorq zmm4,zmm4,zmm29
vpternlogq zmm5,zmm28,zmm29,0x96
add r8,118784
add r9,240
dec ecx
jnz .Lcrt57_m2_g0
vmovdqu64 ZMMWORD PTR [rdx+384],zmm0
vmovdqu64 ZMMWORD PTR [rdx+448],zmm1
vmovdqu64 ZMMWORD PTR [rdx+896],zmm2
vmovdqu64 ZMMWORD PTR [rdx+960],zmm3
vmovdqu64 ZMMWORD PTR [rdx+1024],zmm4
vmovdqu64 ZMMWORD PTR [rdx+1088],zmm5
vmovdqu64 ZMMWORD PTR [rdx+1152],zmm6
vmovdqu64 ZMMWORD PTR [rdx+1216],zmm7
vmovdqu64 ZMMWORD PTR [rdx+1280],zmm8
vmovdqu64 ZMMWORD PTR [rdx+1344],zmm9
vmovdqu64 ZMMWORD PTR [rdx+1408],zmm10
vmovdqu64 ZMMWORD PTR [rdx+1472],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1536],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1600],zmm13
vpxorq zmm0,zmm0,zmm0
vpxorq zmm1,zmm1,zmm1
vpxorq zmm2,zmm2,zmm2
vpxorq zmm3,zmm3,zmm3
vpxorq zmm4,zmm4,zmm4
vpxorq zmm5,zmm5,zmm5
vpxorq zmm6,zmm6,zmm6
vpxorq zmm7,zmm7,zmm7
vpxorq zmm8,zmm8,zmm8
vpxorq zmm9,zmm9,zmm9
vpxorq zmm10,zmm10,zmm10
vpxorq zmm11,zmm11,zmm11
vpxorq zmm12,zmm12,zmm12
vpxorq zmm13,zmm13,zmm13
vpxorq zmm14,zmm14,zmm14
mov r8,rdi
lea r9,[rsi+7680]
mov ecx,32
.p2align 5
.Lcrt57_m2_g1:
vmovdqu64 zmm15,ZMMWORD PTR [r8+0]
vmovdqu64 zmm16,ZMMWORD PTR [r8+64]
vmovdqu64 zmm17,ZMMWORD PTR [r8+128]
vmovdqu64 zmm18,ZMMWORD PTR [r8+192]
vmovdqu64 zmm19,ZMMWORD PTR [r8+256]
vmovdqu64 zmm20,ZMMWORD PTR [r8+320]
vmovdqu64 zmm21,ZMMWORD PTR [r8+384]
vmovdqu64 zmm22,ZMMWORD PTR [r8+448]
vmovdqu64 zmm23,ZMMWORD PTR [r8+512]
vmovdqu64 zmm24,ZMMWORD PTR [r8+576]
vmovdqu64 zmm25,ZMMWORD PTR [r8+640]
vmovdqu64 zmm26,ZMMWORD PTR [r8+704]
vmovdqu64 zmm27,ZMMWORD PTR [r8+768]
vmovdqu64 zmm28,ZMMWORD PTR [r8+832]
vgf2p8affineqb zmm29,zmm26,QWORD PTR [r9+0]{1to8},0
vgf2p8affineqb zmm30,zmm27,QWORD PTR [r9+8]{1to8},0
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+16]{1to8},0
vpxorq zmm2,zmm2,zmm31
vpxorq zmm13,zmm13,zmm30
vpternlogq zmm14,zmm29,zmm30,0x96
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+24]{1to8},0
vgf2p8affineqb zmm30,zmm15,QWORD PTR [r9+32]{1to8},0
vgf2p8affineqb zmm31,zmm28,QWORD PTR [r9+40]{1to8},0
vpxorq zmm0,zmm0,zmm30
vpternlogq zmm1,zmm29,zmm30,0x96
vpternlogq zmm2,zmm29,zmm30,0x96
vpxorq zmm12,zmm12,zmm31
vpxorq zmm13,zmm13,zmm31
vpxorq zmm14,zmm14,zmm31
vpxorq zmm16,zmm16,zmm15
vgf2p8affineqb zmm29,zmm16,QWORD PTR [r9+48]{1to8},0
vpxorq zmm17,zmm17,zmm15
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+56]{1to8},0
vpxorq zmm27,zmm27,zmm28
vgf2p8affineqb zmm31,zmm27,QWORD PTR [r9+64]{1to8},0
vpxorq zmm1,zmm1,zmm29
vpxorq zmm2,zmm2,zmm30
vpxorq zmm13,zmm13,zmm31
vpxorq zmm28,zmm28,zmm26
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+72]{1to8},0
vpternlogq zmm20,zmm24,zmm27,0x96
vpternlogq zmm23,zmm16,zmm19,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm30,zmm23,QWORD PTR [r9+80]{1to8},0
vpternlogq zmm20,zmm21,zmm22,0x96
vpxorq zmm17,zmm17,zmm20
vgf2p8affineqb zmm31,zmm17,QWORD PTR [r9+88]{1to8},0
vpxorq zmm5,zmm5,zmm30
vpxorq zmm11,zmm11,zmm31
vpxorq zmm14,zmm14,zmm29
vpternlogq zmm28,zmm20,zmm23,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+96]{1to8},0
vpternlogq zmm18,zmm15,zmm25,0x96
vpternlogq zmm20,zmm18,zmm24,0x96
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+104]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+112]{1to8},0
vpternlogq zmm6,zmm30,zmm31,0x96
vpternlogq zmm7,zmm29,zmm30,0x96
vpternlogq zmm8,zmm30,zmm31,0x96
vpternlogq zmm15,zmm19,zmm26,0x96
vpternlogq zmm22,zmm15,zmm17,0x96
vgf2p8affineqb zmm29,zmm22,QWORD PTR [r9+120]{1to8},0
vpxorq zmm20,zmm20,zmm22
vgf2p8affineqb zmm30,zmm20,QWORD PTR [r9+128]{1to8},0
vpxorq zmm20,zmm20,zmm28
vgf2p8affineqb zmm31,zmm20,QWORD PTR [r9+136]{1to8},0
vpternlogq zmm6,zmm29,zmm30,0x96
vpxorq zmm7,zmm7,zmm30
vpxorq zmm8,zmm8,zmm31
vpternlogq zmm28,zmm15,zmm18,0x96
vgf2p8affineqb zmm29,zmm28,QWORD PTR [r9+144]{1to8},0
vpxorq zmm17,zmm17,zmm28
vgf2p8affineqb zmm30,zmm17,QWORD PTR [r9+152]{1to8},0
vpternlogq zmm23,zmm15,zmm21,0x96
vpternlogq zmm19,zmm23,zmm24,0x96
vgf2p8affineqb zmm31,zmm19,QWORD PTR [r9+160]{1to8},0
vpternlogq zmm9,zmm30,zmm31,0x96
vpternlogq zmm10,zmm29,zmm31,0x96
vpxorq zmm11,zmm11,zmm30
vpxorq zmm17,zmm17,zmm19
vgf2p8affineqb zmm29,zmm17,QWORD PTR [r9+168]{1to8},0
vpxorq zmm19,zmm19,zmm28
vgf2p8affineqb zmm30,zmm19,QWORD PTR [r9+176]{1to8},0
vpternlogq zmm20,zmm24,zmm26,0x96
vpxorq zmm23,zmm23,zmm20
vgf2p8affineqb zmm31,zmm23,QWORD PTR [r9+184]{1to8},0
vpxorq zmm3,zmm3,zmm31
vpxorq zmm4,zmm4,zmm31
vpxorq zmm5,zmm5,zmm31
vpxorq zmm9,zmm9,zmm30
vpternlogq zmm10,zmm29,zmm30,0x96
vpternlogq zmm11,zmm29,zmm30,0x96
vpternlogq zmm21,zmm15,zmm20,0x96
vgf2p8affineqb zmm29,zmm21,QWORD PTR [r9+192]{1to8},0
vpternlogq zmm27,zmm20,zmm28,0x96
vpternlogq zmm25,zmm16,zmm27,0x96
vgf2p8affineqb zmm30,zmm25,QWORD PTR [r9+200]{1to8},0
vpxorq zmm25,zmm25,zmm23
vgf2p8affineqb zmm31,zmm25,QWORD PTR [r9+208]{1to8},0
vpternlogq zmm4,zmm30,zmm31,0x96
vpternlogq zmm5,zmm29,zmm31,0x96
add r8,118784
add r9,216
dec ecx
jnz .Lcrt57_m2_g1
vmovdqu64 ZMMWORD PTR [rdx+0],zmm0
vmovdqu64 ZMMWORD PTR [rdx+64],zmm1
vmovdqu64 ZMMWORD PTR [rdx+128],zmm2
vmovdqu64 ZMMWORD PTR [rdx+192],zmm3
vmovdqu64 ZMMWORD PTR [rdx+256],zmm4
vmovdqu64 ZMMWORD PTR [rdx+320],zmm5
vmovdqu64 ZMMWORD PTR [rdx+512],zmm6
vmovdqu64 ZMMWORD PTR [rdx+576],zmm7
vmovdqu64 ZMMWORD PTR [rdx+640],zmm8
vmovdqu64 ZMMWORD PTR [rdx+704],zmm9
vmovdqu64 ZMMWORD PTR [rdx+768],zmm10
vmovdqu64 ZMMWORD PTR [rdx+832],zmm11
vmovdqu64 ZMMWORD PTR [rdx+1664],zmm12
vmovdqu64 ZMMWORD PTR [rdx+1728],zmm13
vmovdqu64 ZMMWORD PTR [rdx+1792],zmm14
vzeroupper
ret
.size flock_ab_crt57_bank_m2,.-flock_ab_crt57_bank_m2
.p2align 6
.globl flock_ab_crt57_finalize
.type flock_ab_crt57_finalize,@function
flock_ab_crt57_finalize:

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

.size flock_ab_crt57_finalize,.-flock_ab_crt57_finalize
.section .note.GNU-stack,"",@progbits
