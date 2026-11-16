.text

.p2align 6
.globl flock_partial_gpr_free5_first
.hidden flock_partial_gpr_free5_first
.type flock_partial_gpr_free5_first,@function
flock_partial_gpr_free5_first:
vmovdqu64 zmm0,ZMMWORD PTR [rdx+0x580]
vpbroadcastq zmm1,QWORD PTR [rdi+0x38]
vgf2p8affineqb zmm1,zmm1,zmm0,0x0
vpbroadcastq zmm2,QWORD PTR [rdi+0x18]
vpbroadcastq zmm3,QWORD PTR [rdi]
vgf2p8affineqb zmm4,zmm2,ZMMWORD PTR [rdx+0x640],0x0
vgf2p8affineqb zmm5,zmm3,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm5,zmm1,zmm4,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x30]
vpbroadcastq zmm7,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm8,zmm7,zmm0,0x0
vpbroadcastq zmm9,QWORD PTR [rdi+0x28]
vgf2p8affineqb zmm0,zmm9,zmm0,0x0
vpternlogq zmm7,zmm2,zmm9,0x96
vpbroadcastq zmm10,QWORD PTR [rdi+0x10]
vpbroadcastq zmm11,QWORD PTR [rdi+0x8]
vgf2p8affineqb zmm12,zmm10,ZMMWORD PTR [rdx+0x700],0x0
vpternlogq zmm10,zmm3,zmm11,0x96
vpternlogq zmm9,zmm6,zmm10,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x440],0x0
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x7c0],0x0
vpxorq zmm13,zmm11,zmm7
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm9,zmm5,0x96
vgf2p8affineqb zmm15,zmm11,ZMMWORD PTR [rdx+0x600],0x0
vgf2p8affineqb zmm16,zmm6,ZMMWORD PTR [rdx+0x780],0x0
vpternlogq zmm6,zmm3,zmm2,0x96
vpternlogq zmm15,zmm16,zmm14,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm1,zmm7,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm6,zmm1,zmm14,0x96
vgf2p8affineqb zmm4,zmm3,ZMMWORD PTR [rdx+0x840],0x0
vpternlogq zmm3,zmm11,zmm7,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x4c0],0x0
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm3,zmm10,zmm6,0x96
vpternlogq zmm10,zmm7,zmm15,0x96
vpternlogq zmm4,zmm12,zmm15,0x96
vgf2p8affineqb zmm9,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm12,zmm9,zmm6,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x680],0x0
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm5,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm7,zmm5,zmm2,0x96
vpternlogq zmm5,zmm8,zmm10,0x96
vgf2p8affineqb zmm16,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm8,zmm16,zmm4,0x96
vpternlogq zmm9,zmm4,zmm7,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm10,zmm2,zmm11,0x96
vpternlogq zmm11,zmm13,zmm12,0x96
vpternlogq zmm2,zmm0,zmm12,0x96
vpternlogq zmm0,zmm7,zmm3,0x96
mov r9,QWORD PTR [rsi+0x30]
mov r10,r9
xor r9,QWORD PTR [rsi+0x38]
mov rax,QWORD PTR [rsi+0x28]
not rax
not r10
xor r9,rax
vpbroadcastq zmm1,rax
vpbroadcastq zmm14,r10
vmovdqu64 zmm15,ZMMWORD PTR [rcx+0x340]
vmovdqu64 zmm6,ZMMWORD PTR [rcx+0x280]
vpbroadcastq zmm16,r9
vmovdqu64 zmm4,ZMMWORD PTR [rcx+0x380]
vgf2p8affineqb zmm13,zmm16,ZMMWORD PTR [rcx+0x3c0],0x1
vgf2p8affineqb zmm12,zmm14,zmm4,0x0
vgf2p8affineqb zmm4,zmm16,zmm4,0x0
vgf2p8affineqb zmm7,zmm16,zmm15,0x0
vgf2p8affineqb zmm15,zmm1,zmm15,0x0
vpternlogq zmm15,zmm12,zmm13,0x96
vgf2p8mulb zmm24,zmm2,zmm15
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x300]
vgf2p8affineqb zmm13,zmm1,zmm12,0x0
vpternlogq zmm4,zmm15,zmm13,0x96
vgf2p8mulb zmm25,zmm5,zmm4
vgf2p8affineqb zmm2,zmm14,zmm12,0x0
vpxorq zmm2,zmm2,zmm7
vgf2p8affineqb zmm12,zmm16,zmm12,0x0
vpternlogq zmm12,zmm4,zmm2,0x96
vpxorq zmm2,zmm15,zmm2
vgf2p8mulb zmm27,zmm9,zmm12
vgf2p8mulb zmm26,zmm3,zmm2
vmovdqu64 zmm13,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm5,zmm14,zmm6,0x0
vgf2p8affineqb zmm6,zmm16,zmm6,0x0
vgf2p8affineqb zmm14,zmm14,zmm13,0x0
vmovdqu64 zmm7,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm9,zmm16,ZMMWORD PTR [rcx+0x2c0],0x0
vgf2p8affineqb zmm3,zmm16,zmm7,0x0
vpxorq zmm14,zmm14,zmm3
vgf2p8affineqb zmm7,zmm1,zmm7,0x0
vpternlogq zmm7,zmm5,zmm9,0x96
vgf2p8affineqb zmm1,zmm1,zmm13,0x0
vgf2p8affineqb zmm16,zmm16,zmm13,0x0
vpternlogq zmm6,zmm7,zmm1,0x96
vpxorq zmm15,zmm15,zmm7
vgf2p8mulb zmm28,zmm0,zmm15
vpternlogq zmm7,zmm2,zmm14,0x96
vpxorq zmm14,zmm14,zmm16
vpternlogq zmm14,zmm12,zmm6,0x96
vgf2p8mulb zmm31,zmm10,zmm14
vpxorq zmm4,zmm4,zmm6
vgf2p8mulb zmm30,zmm11,zmm7
vgf2p8mulb zmm29,zmm8,zmm4
ret
.size flock_partial_gpr_free5_first,.-flock_partial_gpr_free5_first

.p2align 6
.globl flock_partial_gpr_free5_next
.hidden flock_partial_gpr_free5_next
.type flock_partial_gpr_free5_next,@function
flock_partial_gpr_free5_next:
vpbroadcastq zmm0,QWORD PTR [rdi+0x18]
vpbroadcastq zmm1,QWORD PTR [rdi]
vpbroadcastq zmm2,QWORD PTR [rdi+0x38]
vmovdqu64 zmm3,ZMMWORD PTR [rdx+0x580]
vgf2p8affineqb zmm2,zmm2,zmm3,0x0
vgf2p8affineqb zmm4,zmm1,ZMMWORD PTR [rdx+0x480],0x0
vgf2p8affineqb zmm5,zmm0,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm4,zmm2,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x28]
vpbroadcastq zmm7,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm8,zmm7,zmm3,0x0
vgf2p8affineqb zmm3,zmm6,zmm3,0x0
vpternlogq zmm7,zmm0,zmm6,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm10,zmm9,ZMMWORD PTR [rdx+0x700],0x0
vpbroadcastq zmm11,QWORD PTR [rdi+0x8]
vpternlogq zmm9,zmm1,zmm11,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm6,zmm12,zmm9,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x440],0x0
vpxorq zmm13,zmm11,zmm7
vgf2p8affineqb zmm14,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm14,zmm6,zmm4,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x7c0],0x0
vgf2p8affineqb zmm15,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vpternlogq zmm12,zmm1,zmm0,0x96
vgf2p8affineqb zmm16,zmm11,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm16,zmm15,zmm14,0x96
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm2,zmm7,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm12,zmm2,zmm14,0x96
vgf2p8affineqb zmm0,zmm0,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm5,zmm1,ZMMWORD PTR [rdx+0x840],0x0
vpternlogq zmm1,zmm11,zmm7,0x96
vgf2p8affineqb zmm1,zmm1,ZMMWORD PTR [rdx+0x4c0],0x0
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm1,zmm9,zmm12,0x96
vpternlogq zmm9,zmm7,zmm16,0x96
vpternlogq zmm5,zmm10,zmm16,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x680],0x0
vgf2p8affineqb zmm6,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm10,zmm6,zmm12,0x96
vgf2p8affineqb zmm4,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm7,zmm4,zmm0,0x96
vpternlogq zmm6,zmm5,zmm7,0x96
vpternlogq zmm4,zmm8,zmm9,0x96
vpternlogq zmm7,zmm3,zmm1,0x96
vgf2p8affineqb zmm15,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm8,zmm15,zmm5,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm3,zmm0,zmm10,0x96
vpternlogq zmm13,zmm11,zmm10,0x96
vpternlogq zmm0,zmm11,zmm9,0x96
mov r9,QWORD PTR [rsi+0x30]
mov r10,r9
xor r9,QWORD PTR [rsi+0x38]
mov rax,QWORD PTR [rsi+0x28]
not rax
not r10
xor r9,rax
vpbroadcastq zmm2,rax
vpbroadcastq zmm14,r10
vmovdqu64 zmm16,ZMMWORD PTR [rcx+0x340]
vmovdqu64 zmm12,ZMMWORD PTR [rcx+0x280]
vpbroadcastq zmm15,r9
vmovdqu64 zmm5,ZMMWORD PTR [rcx+0x380]
vgf2p8affineqb zmm10,zmm15,ZMMWORD PTR [rcx+0x3c0],0x1
vgf2p8affineqb zmm11,zmm14,zmm5,0x0
vgf2p8affineqb zmm5,zmm15,zmm5,0x0
vgf2p8affineqb zmm9,zmm15,zmm16,0x0
vgf2p8affineqb zmm16,zmm2,zmm16,0x0
vpternlogq zmm16,zmm11,zmm10,0x96
vgf2p8mulb zmm3,zmm3,zmm16
vpxorq zmm24,zmm24,zmm3
vmovdqu64 zmm11,ZMMWORD PTR [rcx+0x300]
vgf2p8affineqb zmm10,zmm2,zmm11,0x0
vpternlogq zmm5,zmm16,zmm10,0x96
vgf2p8mulb zmm4,zmm4,zmm5
vpxorq zmm25,zmm25,zmm4
vgf2p8affineqb zmm3,zmm14,zmm11,0x0
vpxorq zmm3,zmm3,zmm9
vgf2p8affineqb zmm11,zmm15,zmm11,0x0
vpternlogq zmm11,zmm5,zmm3,0x96
vpxorq zmm3,zmm16,zmm3
vgf2p8mulb zmm6,zmm6,zmm11
vpxorq zmm27,zmm27,zmm6
vgf2p8mulb zmm1,zmm1,zmm3
vpxorq zmm26,zmm26,zmm1
vmovdqu64 zmm10,ZMMWORD PTR [rcx+0x200]
vgf2p8affineqb zmm4,zmm14,zmm12,0x0
vgf2p8affineqb zmm12,zmm15,zmm12,0x0
vgf2p8affineqb zmm14,zmm14,zmm10,0x0
vmovdqu64 zmm9,ZMMWORD PTR [rcx+0x240]
vgf2p8affineqb zmm6,zmm15,ZMMWORD PTR [rcx+0x2c0],0x0
vgf2p8affineqb zmm1,zmm15,zmm9,0x0
vpxorq zmm14,zmm14,zmm1
vgf2p8affineqb zmm9,zmm2,zmm9,0x0
vpternlogq zmm9,zmm4,zmm6,0x96
vgf2p8affineqb zmm2,zmm2,zmm10,0x0
vgf2p8affineqb zmm15,zmm15,zmm10,0x0
vpternlogq zmm12,zmm9,zmm2,0x96
vpxorq zmm16,zmm16,zmm9
vgf2p8mulb zmm7,zmm7,zmm16
vpxorq zmm28,zmm28,zmm7
vpternlogq zmm9,zmm3,zmm14,0x96
vpxorq zmm14,zmm14,zmm15
vpternlogq zmm14,zmm11,zmm12,0x96
vgf2p8mulb zmm0,zmm0,zmm14
vpxorq zmm31,zmm31,zmm0
vpxorq zmm5,zmm5,zmm12
vgf2p8mulb zmm13,zmm13,zmm9
vpxorq zmm30,zmm30,zmm13
vgf2p8mulb zmm8,zmm8,zmm5
vpxorq zmm29,zmm29,zmm8
ret
.size flock_partial_gpr_free5_next,.-flock_partial_gpr_free5_next

.section .note.GNU-stack,"",@progbits
