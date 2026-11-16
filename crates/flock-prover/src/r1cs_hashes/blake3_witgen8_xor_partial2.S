.text

.p2align 6
.globl flock_partial_gpr_free2_first
.hidden flock_partial_gpr_free2_first
.type flock_partial_gpr_free2_first,@function
flock_partial_gpr_free2_first:
vmovdqu64 zmm0,ZMMWORD PTR [rdx+0x580]
vpbroadcastq zmm1,QWORD PTR [rdi+0x38]
vgf2p8affineqb zmm1,zmm1,zmm0,0x0
vpbroadcastq zmm2,QWORD PTR [rdi]
vpbroadcastq zmm3,QWORD PTR [rdi+0x18]
vgf2p8affineqb zmm4,zmm2,ZMMWORD PTR [rdx+0x480],0x0
vgf2p8affineqb zmm5,zmm3,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm4,zmm1,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x20]
vpbroadcastq zmm7,QWORD PTR [rdi+0x28]
vgf2p8affineqb zmm8,zmm7,zmm0,0x0
vgf2p8affineqb zmm0,zmm6,zmm0,0x0
vpternlogq zmm6,zmm3,zmm7,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x8]
vpbroadcastq zmm10,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm11,zmm10,ZMMWORD PTR [rdx+0x700],0x0
vpternlogq zmm10,zmm2,zmm9,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm7,zmm12,zmm10,0x96
vpxorq zmm13,zmm9,zmm6
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x440],0x0
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm7,zmm4,0x96
vgf2p8affineqb zmm15,zmm3,ZMMWORD PTR [rdx+0x540],0x0
vpternlogq zmm3,zmm2,zmm12,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vgf2p8affineqb zmm16,zmm9,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm16,zmm12,zmm14,0x96
vgf2p8affineqb zmm17,zmm6,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm3,zmm17,zmm14,0x96
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x7c0],0x0
vgf2p8affineqb zmm18,zmm2,ZMMWORD PTR [rdx+0x840],0x0
vgf2p8affineqb zmm19,zmm6,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm2,zmm9,zmm6,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x680],0x0
vpternlogq zmm18,zmm11,zmm16,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm16,zmm10,zmm19,0x96
vpternlogq zmm2,zmm10,zmm3,0x96
vgf2p8affineqb zmm20,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm11,zmm20,zmm3,0x96
vgf2p8affineqb zmm21,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm19,zmm21,zmm15,0x96
vpternlogq zmm21,zmm0,zmm16,0x96
vpternlogq zmm16,zmm15,zmm9,0x96
vgf2p8affineqb zmm1,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm9,zmm1,zmm11,0x96
vpternlogq zmm15,zmm8,zmm11,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm0,zmm13,zmm18,0x96
vpternlogq zmm20,zmm18,zmm19,0x96
vpternlogq zmm8,zmm19,zmm2,0x96
mov r9,QWORD PTR [rsi+0x18]
mov r10,QWORD PTR [rsi+0x28]
mov r11,QWORD PTR [rsi+0x38]
mov rax,r9
not rax
mov r8,r11
xor r8,r10
xor r8,rax
xor r9,QWORD PTR [rsi+0x10]
xor r11,r9
vpbroadcastq zmm5,r8
mov r8,QWORD PTR [rsi+0x20]
xor r8,r10
not r10
vpbroadcastq zmm7,r8
xor r8,QWORD PTR [rsi+0x30]
xor r11,r8
vpbroadcastq zmm4,r11
vgf2p8affineqb zmm12,zmm4,ZMMWORD PTR [rcx+0x3c0],0x1
vmovdqu64 zmm17,ZMMWORD PTR [rcx+0x380]
vgf2p8affineqb zmm14,zmm5,zmm17,0x0
vpxorq zmm14,zmm14,zmm12
vgf2p8affineqb zmm17,zmm4,zmm17,0x0
vmovdqu64 zmm6,ZMMWORD PTR [rcx+0x340]
vpbroadcastq zmm10,r10
vmovdqu64 zmm3,ZMMWORD PTR [rcx+0x280]
vmovdqu64 zmm1,ZMMWORD PTR [rcx+0x300]
vgf2p8affineqb zmm11,zmm10,zmm1,0x0
vgf2p8affineqb zmm13,zmm7,zmm6,0x0
vpternlogq zmm11,zmm14,zmm13,0x96
vgf2p8affineqb zmm6,zmm4,zmm6,0x0
vpbroadcastq zmm18,r9
vpbroadcastq zmm19,rax
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x2c0]
vgf2p8affineqb zmm14,zmm18,zmm12,0x0
vgf2p8affineqb zmm12,zmm4,zmm12,0x0
vgf2p8affineqb zmm13,zmm5,zmm1,0x0
vpxorq zmm13,zmm13,zmm6
vgf2p8affineqb zmm6,zmm5,zmm3,0x0
vpxorq zmm6,zmm6,zmm12
vgf2p8affineqb zmm12,zmm7,zmm1,0x0
vpxorq zmm12,zmm12,zmm17
vgf2p8affineqb zmm1,zmm4,zmm1,0x0
vgf2p8affineqb zmm17,zmm19,zmm3,0x0
vpternlogq zmm17,zmm11,zmm14,0x96
vgf2p8mulb zmm25,zmm21,zmm17
vmovdqu64 zmm11,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm14,zmm4,zmm11,0x0
vgf2p8affineqb zmm21,zmm18,zmm3,0x0
vpternlogq zmm21,zmm17,zmm12,0x96
vgf2p8affineqb zmm3,zmm4,zmm3,0x0
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm19,zmm19,zmm12,0x0
vgf2p8affineqb zmm10,zmm10,zmm12,0x0
vgf2p8affineqb zmm4,zmm4,zmm12,0x0
vgf2p8affineqb zmm5,zmm5,zmm12,0x0
vpxorq zmm5,zmm5,zmm14
vpxorq zmm4,zmm5,zmm4
vgf2p8mulb zmm24,zmm15,zmm21
vgf2p8affineqb zmm14,zmm7,zmm12,0x0
vgf2p8affineqb zmm12,zmm18,zmm12,0x0
vpxorq zmm12,zmm12,zmm1
vgf2p8affineqb zmm18,zmm18,zmm11,0x0
vpternlogq zmm19,zmm13,zmm18,0x96
vgf2p8affineqb zmm7,zmm7,zmm11,0x0
vpternlogq zmm10,zmm6,zmm7,0x96
vpternlogq zmm3,zmm10,zmm14,0x96
vpternlogq zmm12,zmm21,zmm19,0x96
vpxorq zmm19,zmm17,zmm19
vpxorq zmm17,zmm17,zmm10
vpternlogq zmm10,zmm19,zmm5,0x96
vgf2p8mulb zmm31,zmm16,zmm10
vgf2p8mulb zmm29,zmm0,zmm17
vgf2p8mulb zmm27,zmm20,zmm19
vpxorq zmm21,zmm21,zmm3
vgf2p8mulb zmm28,zmm8,zmm21
vpternlogq zmm4,zmm12,zmm3,0x96
vgf2p8mulb zmm26,zmm2,zmm12
vgf2p8mulb zmm30,zmm9,zmm4
ret
.size flock_partial_gpr_free2_first,.-flock_partial_gpr_free2_first

.p2align 6
.globl flock_partial_gpr_free2_next
.hidden flock_partial_gpr_free2_next
.type flock_partial_gpr_free2_next,@function
flock_partial_gpr_free2_next:
vpbroadcastq zmm0,QWORD PTR [rdi+0x38]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x580]
vgf2p8affineqb zmm0,zmm0,zmm1,0x0
vpbroadcastq zmm2,QWORD PTR [rdi+0x28]
vpbroadcastq zmm3,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm4,zmm2,zmm1,0x0
vgf2p8affineqb zmm1,zmm3,zmm1,0x0
vpbroadcastq zmm5,QWORD PTR [rdi+0x18]
vpternlogq zmm3,zmm5,zmm2,0x96
vgf2p8affineqb zmm6,zmm5,ZMMWORD PTR [rdx+0x640],0x0
vpbroadcastq zmm7,QWORD PTR [rdi]
vgf2p8affineqb zmm8,zmm7,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm8,zmm0,zmm6,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x10]
vpbroadcastq zmm10,QWORD PTR [rdi+0x8]
vpbroadcastq zmm11,QWORD PTR [rdi+0x30]
vgf2p8affineqb zmm12,zmm9,ZMMWORD PTR [rdx+0x700],0x0
vpternlogq zmm9,zmm7,zmm10,0x96
vpternlogq zmm2,zmm11,zmm9,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x440],0x0
vpxorq zmm13,zmm10,zmm3
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm2,zmm8,0x96
vgf2p8affineqb zmm15,zmm10,ZMMWORD PTR [rdx+0x600],0x0
vgf2p8affineqb zmm16,zmm11,ZMMWORD PTR [rdx+0x780],0x0
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x7c0],0x0
vpternlogq zmm15,zmm16,zmm14,0x96
vpternlogq zmm11,zmm7,zmm5,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm17,zmm3,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm11,zmm17,zmm14,0x96
vgf2p8affineqb zmm5,zmm5,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm18,zmm10,ZMMWORD PTR [rdx+0x680],0x0
vpternlogq zmm10,zmm7,zmm3,0x96
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x840],0x0
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm7,zmm12,zmm15,0x96
vpternlogq zmm10,zmm9,zmm11,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm9,zmm3,zmm15,0x96
vgf2p8affineqb zmm19,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm12,zmm19,zmm11,0x96
vgf2p8affineqb zmm20,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm20,zmm18,zmm12,0x96
vpternlogq zmm18,zmm5,zmm9,0x96
vpternlogq zmm12,zmm5,zmm4,0x96
vgf2p8affineqb zmm21,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm5,zmm21,zmm3,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm21,zmm1,zmm9,0x96
vpternlogq zmm1,zmm13,zmm7,0x96
vpternlogq zmm19,zmm7,zmm5,0x96
vpternlogq zmm4,zmm5,zmm10,0x96
mov r9,QWORD PTR [rsi+0x18]
mov r10,QWORD PTR [rsi+0x28]
mov r11,QWORD PTR [rsi+0x38]
mov rax,r9
not rax
mov r8,r11
xor r8,r10
xor r8,rax
xor r9,QWORD PTR [rsi+0x10]
xor r11,r9
vpbroadcastq zmm0,r8
mov r8,QWORD PTR [rsi+0x20]
xor r8,r10
not r10
vpbroadcastq zmm6,r8
xor r8,QWORD PTR [rsi+0x30]
xor r11,r8
vpbroadcastq zmm2,r11
vgf2p8affineqb zmm8,zmm2,ZMMWORD PTR [rcx+0x3c0],0x1
vmovdqu64 zmm16,ZMMWORD PTR [rcx+0x380]
vgf2p8affineqb zmm17,zmm0,zmm16,0x0
vpxorq zmm17,zmm17,zmm8
vgf2p8affineqb zmm16,zmm2,zmm16,0x0
vmovdqu64 zmm14,ZMMWORD PTR [rcx+0x340]
vpbroadcastq zmm15,r10
vmovdqu64 zmm11,ZMMWORD PTR [rcx+0x280]
vmovdqu64 zmm3,ZMMWORD PTR [rcx+0x300]
vgf2p8affineqb zmm9,zmm15,zmm3,0x0
vgf2p8affineqb zmm13,zmm6,zmm14,0x0
vpternlogq zmm9,zmm17,zmm13,0x96
vgf2p8affineqb zmm14,zmm2,zmm14,0x0
vpbroadcastq zmm7,r9
vpbroadcastq zmm5,rax
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x2c0]
vgf2p8affineqb zmm17,zmm7,zmm8,0x0
vgf2p8affineqb zmm8,zmm2,zmm8,0x0
vgf2p8affineqb zmm13,zmm0,zmm3,0x0
vpxorq zmm13,zmm13,zmm14
vgf2p8affineqb zmm14,zmm0,zmm11,0x0
vpxorq zmm14,zmm14,zmm8
vgf2p8affineqb zmm8,zmm6,zmm3,0x0
vpxorq zmm8,zmm8,zmm16
vgf2p8affineqb zmm3,zmm2,zmm3,0x0
vgf2p8affineqb zmm16,zmm5,zmm11,0x0
vpternlogq zmm16,zmm9,zmm17,0x96
vgf2p8mulb zmm21,zmm21,zmm16
vpxorq zmm25,zmm25,zmm21
vmovdqu64 zmm9,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm17,zmm2,zmm9,0x0
vgf2p8affineqb zmm21,zmm7,zmm11,0x0
vpternlogq zmm21,zmm16,zmm8,0x96
vgf2p8affineqb zmm11,zmm2,zmm11,0x0
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm5,zmm5,zmm8,0x0
vgf2p8affineqb zmm15,zmm15,zmm8,0x0
vgf2p8affineqb zmm2,zmm2,zmm8,0x0
vgf2p8affineqb zmm0,zmm0,zmm8,0x0
vpxorq zmm0,zmm0,zmm17
vpxorq zmm2,zmm0,zmm2
vgf2p8mulb zmm12,zmm12,zmm21
vpxorq zmm24,zmm24,zmm12
vgf2p8affineqb zmm17,zmm6,zmm8,0x0
vgf2p8affineqb zmm8,zmm7,zmm8,0x0
vpxorq zmm8,zmm8,zmm3
vgf2p8affineqb zmm7,zmm7,zmm9,0x0
vpternlogq zmm5,zmm13,zmm7,0x96
vgf2p8affineqb zmm6,zmm6,zmm9,0x0
vpternlogq zmm15,zmm14,zmm6,0x96
vpternlogq zmm11,zmm15,zmm17,0x96
vpternlogq zmm8,zmm21,zmm5,0x96
vpxorq zmm5,zmm16,zmm5
vpxorq zmm16,zmm16,zmm15
vpternlogq zmm15,zmm5,zmm0,0x96
vgf2p8mulb zmm18,zmm18,zmm15
vpxorq zmm31,zmm31,zmm18
vgf2p8mulb zmm1,zmm1,zmm16
vpxorq zmm29,zmm29,zmm1
vgf2p8mulb zmm19,zmm19,zmm5
vpxorq zmm27,zmm27,zmm19
vpxorq zmm21,zmm21,zmm11
vgf2p8mulb zmm4,zmm4,zmm21
vpxorq zmm28,zmm28,zmm4
vpternlogq zmm2,zmm8,zmm11,0x96
vgf2p8mulb zmm10,zmm10,zmm8
vpxorq zmm26,zmm26,zmm10
vgf2p8mulb zmm20,zmm20,zmm2
vpxorq zmm30,zmm30,zmm20
ret
.size flock_partial_gpr_free2_next,.-flock_partial_gpr_free2_next

.section .note.GNU-stack,"",@progbits
