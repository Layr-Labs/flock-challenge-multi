.text

.p2align 6
.globl flock_partial_gpr_free3_first
.hidden flock_partial_gpr_free3_first
.type flock_partial_gpr_free3_first,@function
flock_partial_gpr_free3_first:
vpbroadcastq zmm0,QWORD PTR [rdi+0x38]
vpbroadcastq zmm1,QWORD PTR [rdi+0x18]
vmovdqu64 zmm2,ZMMWORD PTR [rdx+0x580]
vgf2p8affineqb zmm0,zmm0,zmm2,0x0
vpbroadcastq zmm3,QWORD PTR [rdi]
vgf2p8affineqb zmm4,zmm3,ZMMWORD PTR [rdx+0x480],0x0
vgf2p8affineqb zmm5,zmm1,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm4,zmm0,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm7,zmm6,zmm2,0x0
vpbroadcastq zmm8,QWORD PTR [rdi+0x28]
vgf2p8affineqb zmm2,zmm8,zmm2,0x0
vpternlogq zmm6,zmm1,zmm8,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x8]
vpbroadcastq zmm10,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm11,zmm10,ZMMWORD PTR [rdx+0x700],0x0
vpternlogq zmm10,zmm3,zmm9,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm8,zmm12,zmm10,0x96
vgf2p8affineqb zmm8,zmm8,ZMMWORD PTR [rdx+0x440],0x0
vpxorq zmm13,zmm9,zmm6
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm8,zmm4,0x96
vgf2p8affineqb zmm15,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vgf2p8affineqb zmm16,zmm9,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm16,zmm15,zmm14,0x96
vpternlogq zmm12,zmm3,zmm1,0x96
vgf2p8affineqb zmm1,zmm1,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm17,zmm6,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm12,zmm17,zmm14,0x96
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x7c0],0x0
vgf2p8affineqb zmm18,zmm3,ZMMWORD PTR [rdx+0x840],0x0
vpternlogq zmm3,zmm9,zmm6,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm3,zmm10,zmm12,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm18,zmm11,zmm16,0x96
vpternlogq zmm10,zmm6,zmm16,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x680],0x0
vgf2p8affineqb zmm19,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm11,zmm19,zmm12,0x96
vgf2p8affineqb zmm20,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm6,zmm20,zmm1,0x96
vpternlogq zmm20,zmm7,zmm10,0x96
vgf2p8affineqb zmm0,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm7,zmm0,zmm18,0x96
vpternlogq zmm19,zmm18,zmm6,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm13,zmm9,zmm11,0x96
vpternlogq zmm9,zmm1,zmm10,0x96
vpternlogq zmm1,zmm2,zmm11,0x96
vpternlogq zmm2,zmm6,zmm3,0x96
mov rax,QWORD PTR [rsi+0x20]
mov r8,QWORD PTR [rsi+24]
mov r10,rax
mov r9,QWORD PTR [rsi+0x30]
xor r10,r9
mov r11,QWORD PTR [rsi+40]
not r8
xor r11,QWORD PTR [rsi+32]
not rax
vpbroadcastq zmm5,r10
mov r10,r11
xor r10,QWORD PTR [rsi+0x38]
mov rsi,r8
xor rsi,r9
xor rsi,r10
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x300]
vmovdqu64 zmm4,ZMMWORD PTR [rcx+0x280]
vpbroadcastq zmm15,r11
vmovdqu64 zmm17,ZMMWORD PTR [rcx+0x380]
vpbroadcastq zmm14,r8
vpbroadcastq zmm16,rsi
vgf2p8affineqb zmm12,zmm5,zmm17,0x0
vgf2p8affineqb zmm17,zmm16,zmm17,0x0
vgf2p8affineqb zmm0,zmm5,zmm4,0x0
vmovdqu64 zmm18,ZMMWORD PTR [rcx+0x340]
vgf2p8affineqb zmm10,zmm16,ZMMWORD PTR [rcx+0x3c0],0x1
vgf2p8affineqb zmm11,zmm15,zmm18,0x0
vpternlogq zmm11,zmm12,zmm10,0x96
vgf2p8affineqb zmm18,zmm16,zmm18,0x0
vpbroadcastq zmm6,rax
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x2c0]
vgf2p8affineqb zmm10,zmm16,zmm12,0x0
vpxorq zmm0,zmm0,zmm10
vgf2p8affineqb zmm12,zmm14,zmm12,0x0
vgf2p8affineqb zmm10,zmm15,zmm8,0x0
vpxorq zmm10,zmm10,zmm17
vgf2p8affineqb zmm17,zmm6,zmm8,0x0
vpternlogq zmm12,zmm11,zmm17,0x96
vgf2p8mulb zmm24,zmm1,zmm12
vmovdqu64 zmm11,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm6,zmm6,zmm11,0x0
vmovdqu64 zmm17,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm1,zmm14,zmm4,0x0
vpternlogq zmm1,zmm12,zmm10,0x96
vgf2p8affineqb zmm4,zmm16,zmm4,0x0
vgf2p8mulb zmm25,zmm20,zmm1
vgf2p8affineqb zmm10,zmm16,zmm17,0x0
vgf2p8affineqb zmm20,zmm15,zmm11,0x0
vgf2p8affineqb zmm15,zmm15,zmm17,0x0
vpternlogq zmm6,zmm0,zmm15,0x96
vpternlogq zmm4,zmm6,zmm20,0x96
vgf2p8affineqb zmm17,zmm14,zmm17,0x0
vgf2p8affineqb zmm14,zmm14,zmm11,0x0
vgf2p8affineqb zmm0,zmm16,zmm11,0x0
vgf2p8affineqb zmm16,zmm16,zmm8,0x0
vpxorq zmm14,zmm14,zmm16
vgf2p8affineqb zmm11,zmm5,zmm11,0x0
vgf2p8affineqb zmm5,zmm5,zmm8,0x0
vpternlogq zmm17,zmm5,zmm18,0x96
vpxorq zmm11,zmm11,zmm10
vpternlogq zmm14,zmm1,zmm17,0x96
vpxorq zmm17,zmm12,zmm17
vgf2p8mulb zmm26,zmm3,zmm17
vpternlogq zmm17,zmm6,zmm11,0x96
vpxorq zmm12,zmm12,zmm6
vgf2p8mulb zmm30,zmm13,zmm17
vpxorq zmm11,zmm11,zmm0
vgf2p8mulb zmm28,zmm2,zmm12
vpternlogq zmm11,zmm14,zmm4,0x96
vgf2p8mulb zmm31,zmm9,zmm11
vgf2p8mulb zmm27,zmm19,zmm14
vpxorq zmm1,zmm1,zmm4
vgf2p8mulb zmm29,zmm7,zmm1
ret
.size flock_partial_gpr_free3_first,.-flock_partial_gpr_free3_first

.p2align 6
.globl flock_partial_gpr_free3_next
.hidden flock_partial_gpr_free3_next
.type flock_partial_gpr_free3_next,@function
flock_partial_gpr_free3_next:
vpbroadcastq zmm0,QWORD PTR [rdi]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x580]
vpbroadcastq zmm2,QWORD PTR [rdi+0x38]
vgf2p8affineqb zmm2,zmm2,zmm1,0x0
vgf2p8affineqb zmm3,zmm0,ZMMWORD PTR [rdx+0x480],0x0
vpbroadcastq zmm4,QWORD PTR [rdi+0x18]
vgf2p8affineqb zmm5,zmm4,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm3,zmm2,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x28]
vpbroadcastq zmm7,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm8,zmm7,zmm1,0x0
vgf2p8affineqb zmm1,zmm6,zmm1,0x0
vpternlogq zmm7,zmm4,zmm6,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm10,zmm9,ZMMWORD PTR [rdx+0x700],0x0
vpbroadcastq zmm11,QWORD PTR [rdi+0x8]
vpternlogq zmm9,zmm0,zmm11,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm6,zmm12,zmm9,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x440],0x0
vpxorq zmm13,zmm11,zmm7
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm6,zmm3,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x7c0],0x0
vgf2p8affineqb zmm15,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vpternlogq zmm12,zmm0,zmm4,0x96
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm4,zmm4,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm16,zmm7,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm12,zmm16,zmm14,0x96
vgf2p8affineqb zmm17,zmm11,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm17,zmm15,zmm14,0x96
vgf2p8affineqb zmm18,zmm0,ZMMWORD PTR [rdx+0x840],0x0
vpternlogq zmm0,zmm11,zmm7,0x96
vpternlogq zmm18,zmm10,zmm17,0x96
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x800],0x0
vgf2p8affineqb zmm0,zmm0,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm17,zmm9,zmm7,0x96
vpternlogq zmm0,zmm9,zmm12,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x680],0x0
vgf2p8affineqb zmm19,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm10,zmm19,zmm12,0x96
vgf2p8affineqb zmm20,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm7,zmm20,zmm4,0x96
vpternlogq zmm19,zmm18,zmm7,0x96
vgf2p8affineqb zmm2,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm2,zmm8,zmm18,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm20,zmm8,zmm17,0x96
vpternlogq zmm17,zmm4,zmm11,0x96
vpternlogq zmm11,zmm13,zmm10,0x96
vpternlogq zmm7,zmm1,zmm0,0x96
vpternlogq zmm4,zmm1,zmm10,0x96
mov rax,QWORD PTR [rsi+0x20]
mov r8,QWORD PTR [rsi+24]
mov r10,rax
mov r9,QWORD PTR [rsi+0x30]
xor r10,r9
mov r11,QWORD PTR [rsi+40]
not r8
xor r11,QWORD PTR [rsi+32]
not rax
vpbroadcastq zmm5,r10
mov r10,r11
xor r10,QWORD PTR [rsi+0x38]
mov rsi,r8
xor rsi,r9
xor rsi,r10
vmovdqu64 zmm6,ZMMWORD PTR [rcx+0x300]
vmovdqu64 zmm3,ZMMWORD PTR [rcx+0x280]
vpbroadcastq zmm16,r11
vmovdqu64 zmm15,ZMMWORD PTR [rcx+0x380]
vpbroadcastq zmm14,r8
vpbroadcastq zmm9,rsi
vgf2p8affineqb zmm12,zmm5,zmm15,0x0
vgf2p8affineqb zmm15,zmm9,zmm15,0x0
vgf2p8affineqb zmm18,zmm5,zmm3,0x0
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x340]
vgf2p8affineqb zmm13,zmm9,ZMMWORD PTR [rcx+0x3c0],0x1
vgf2p8affineqb zmm1,zmm16,zmm8,0x0
vpternlogq zmm1,zmm12,zmm13,0x96
vgf2p8affineqb zmm8,zmm9,zmm8,0x0
vpbroadcastq zmm10,rax
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x2c0]
vgf2p8affineqb zmm13,zmm9,zmm12,0x0
vpxorq zmm18,zmm18,zmm13
vgf2p8affineqb zmm12,zmm14,zmm12,0x0
vgf2p8affineqb zmm13,zmm16,zmm6,0x0
vpxorq zmm13,zmm13,zmm15
vgf2p8affineqb zmm15,zmm10,zmm6,0x0
vpternlogq zmm12,zmm1,zmm15,0x96
vgf2p8mulb zmm4,zmm4,zmm12
vpxorq zmm24,zmm24,zmm4
vmovdqu64 zmm1,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm10,zmm10,zmm1,0x0
vmovdqu64 zmm15,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm4,zmm14,zmm3,0x0
vpternlogq zmm4,zmm12,zmm13,0x96
vgf2p8affineqb zmm3,zmm9,zmm3,0x0
vgf2p8mulb zmm20,zmm20,zmm4
vpxorq zmm25,zmm25,zmm20
vgf2p8affineqb zmm13,zmm9,zmm15,0x0
vgf2p8affineqb zmm20,zmm16,zmm1,0x0
vgf2p8affineqb zmm16,zmm16,zmm15,0x0
vpternlogq zmm10,zmm18,zmm16,0x96
vpternlogq zmm3,zmm10,zmm20,0x96
vgf2p8affineqb zmm15,zmm14,zmm15,0x0
vgf2p8affineqb zmm14,zmm14,zmm1,0x0
vgf2p8affineqb zmm18,zmm9,zmm1,0x0
vgf2p8affineqb zmm9,zmm9,zmm6,0x0
vpxorq zmm14,zmm14,zmm9
vgf2p8affineqb zmm1,zmm5,zmm1,0x0
vgf2p8affineqb zmm5,zmm5,zmm6,0x0
vpternlogq zmm15,zmm5,zmm8,0x96
vpxorq zmm1,zmm1,zmm13
vpternlogq zmm14,zmm4,zmm15,0x96
vpxorq zmm15,zmm12,zmm15
vgf2p8mulb zmm0,zmm0,zmm15
vpxorq zmm26,zmm26,zmm0
vpternlogq zmm15,zmm10,zmm1,0x96
vpxorq zmm12,zmm12,zmm10
vgf2p8mulb zmm11,zmm11,zmm15
vpxorq zmm30,zmm30,zmm11
vpxorq zmm1,zmm1,zmm18
vgf2p8mulb zmm7,zmm7,zmm12
vpxorq zmm28,zmm28,zmm7
vpternlogq zmm1,zmm14,zmm3,0x96
vgf2p8mulb zmm17,zmm17,zmm1
vpxorq zmm31,zmm31,zmm17
vgf2p8mulb zmm19,zmm19,zmm14
vpxorq zmm27,zmm27,zmm19
vpxorq zmm4,zmm4,zmm3
vgf2p8mulb zmm2,zmm2,zmm4
vpxorq zmm29,zmm29,zmm2
ret
.size flock_partial_gpr_free3_next,.-flock_partial_gpr_free3_next

.section .note.GNU-stack,"",@progbits
