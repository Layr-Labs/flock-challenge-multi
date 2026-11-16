.text

.p2align 6
.globl flock_partial_gpr_free14_first
.hidden flock_partial_gpr_free14_first
.type flock_partial_gpr_free14_first,@function
flock_partial_gpr_free14_first:
vpbroadcastq zmm0,QWORD PTR [rdi+0x38]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x580]
vgf2p8affineqb zmm0,zmm0,zmm1,0x0
vpbroadcastq zmm2,QWORD PTR [rdi+0x18]
vpbroadcastq zmm3,QWORD PTR [rdi]
vgf2p8affineqb zmm4,zmm3,ZMMWORD PTR [rdx+0x480],0x0
vgf2p8affineqb zmm5,zmm2,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm4,zmm0,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm7,zmm6,ZMMWORD PTR [rdx+0x700],0x0
vpbroadcastq zmm8,QWORD PTR [rdi+0x8]
vpternlogq zmm6,zmm3,zmm8,0x96
vpbroadcastq zmm9,QWORD PTR [rdi+0x28]
vpbroadcastq zmm10,QWORD PTR [rdi+0x20]
vgf2p8affineqb zmm11,zmm10,zmm1,0x0
vgf2p8affineqb zmm1,zmm9,zmm1,0x0
vpternlogq zmm10,zmm2,zmm9,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm9,zmm12,zmm6,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x7c0],0x0
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x440],0x0
vpxorq zmm13,zmm8,zmm10
vgf2p8affineqb zmm0,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm0,zmm9,zmm4,0x96
vgf2p8affineqb zmm5,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vpternlogq zmm12,zmm3,zmm2,0x96
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm9,zmm10,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm12,zmm9,zmm0,0x96
vgf2p8affineqb zmm4,zmm8,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm4,zmm5,zmm0,0x96
vgf2p8affineqb zmm9,zmm10,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm10,zmm3,zmm8,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x840],0x0
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm10,zmm6,zmm12,0x96
vpternlogq zmm6,zmm9,zmm4,0x96
vpternlogq zmm3,zmm7,zmm4,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm5,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm7,zmm5,zmm12,0x96
vgf2p8affineqb zmm0,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm9,zmm0,zmm2,0x96
vpternlogq zmm0,zmm11,zmm6,0x96
vgf2p8affineqb zmm8,zmm8,ZMMWORD PTR [rdx+0x680],0x0
vpternlogq zmm5,zmm3,zmm9,0x96
vgf2p8affineqb zmm4,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm11,zmm4,zmm3,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm13,zmm8,zmm7,0x96
vpternlogq zmm8,zmm2,zmm6,0x96
vpternlogq zmm2,zmm1,zmm7,0x96
vpternlogq zmm1,zmm9,zmm10,0x96
mov rax,QWORD PTR [rsi]
not rax
vpbroadcastq zmm12,rax
vgf2p8affineqb zmm4,zmm12,ZMMWORD PTR [rcx+0x180],0x1
vgf2p8mulb zmm30,zmm13,zmm4
vgf2p8affineqb zmm3,zmm12,ZMMWORD PTR [rcx+0x40],0x1
vgf2p8mulb zmm25,zmm0,zmm3
vgf2p8affineqb zmm6,zmm12,ZMMWORD PTR [rcx+0x100],0x1
vgf2p8mulb zmm28,zmm1,zmm6
vgf2p8affineqb zmm7,zmm12,ZMMWORD PTR [rcx+0x140],0x1
vgf2p8mulb zmm29,zmm11,zmm7
vgf2p8affineqb zmm9,zmm12,ZMMWORD PTR [rcx+0x80],0x1
vgf2p8mulb zmm26,zmm10,zmm9
vgf2p8affineqb zmm13,zmm12,ZMMWORD PTR [rcx+0xc0],0x1
vgf2p8mulb zmm27,zmm5,zmm13
vgf2p8affineqb zmm4,zmm12,ZMMWORD PTR [rcx],0x1
vgf2p8mulb zmm24,zmm2,zmm4
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rcx+0x1c0],0x1
vgf2p8mulb zmm31,zmm8,zmm12
ret
.size flock_partial_gpr_free14_first,.-flock_partial_gpr_free14_first

.p2align 6
.globl flock_partial_gpr_free14_next
.hidden flock_partial_gpr_free14_next
.type flock_partial_gpr_free14_next,@function
flock_partial_gpr_free14_next:
vpbroadcastq zmm0,QWORD PTR [rdi+0x18]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x580]
vpbroadcastq zmm2,QWORD PTR [rdi]
vpbroadcastq zmm3,QWORD PTR [rdi+0x38]
vgf2p8affineqb zmm3,zmm3,zmm1,0x0
vgf2p8affineqb zmm4,zmm2,ZMMWORD PTR [rdx+0x480],0x0
vgf2p8affineqb zmm5,zmm0,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm4,zmm3,zmm5,0x96
vpbroadcastq zmm6,QWORD PTR [rdi+0x20]
vpbroadcastq zmm7,QWORD PTR [rdi+0x28]
vgf2p8affineqb zmm8,zmm6,zmm1,0x0
vpbroadcastq zmm9,QWORD PTR [rdi+0x8]
vpternlogq zmm6,zmm0,zmm7,0x96
vgf2p8affineqb zmm1,zmm7,zmm1,0x0
vpbroadcastq zmm10,QWORD PTR [rdi+0x10]
vgf2p8affineqb zmm11,zmm10,ZMMWORD PTR [rdx+0x700],0x0
vpternlogq zmm10,zmm2,zmm9,0x96
vpbroadcastq zmm12,QWORD PTR [rdi+0x30]
vpternlogq zmm7,zmm12,zmm10,0x96
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x440],0x0
vgf2p8affineqb zmm10,zmm10,ZMMWORD PTR [rdx+0x7c0],0x0
vpxorq zmm13,zmm9,zmm6
vgf2p8affineqb zmm3,zmm13,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm3,zmm7,zmm4,0x96
vgf2p8affineqb zmm5,zmm12,ZMMWORD PTR [rdx+0x780],0x0
vpternlogq zmm12,zmm2,zmm0,0x96
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rdx+0x5c0],0x0
vgf2p8affineqb zmm7,zmm9,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm7,zmm5,zmm3,0x96
vgf2p8affineqb zmm4,zmm6,ZMMWORD PTR [rdx+0x600],0x0
vpternlogq zmm12,zmm4,zmm3,0x96
vgf2p8affineqb zmm5,zmm6,ZMMWORD PTR [rdx+0x800],0x0
vpternlogq zmm6,zmm2,zmm9,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x840],0x0
vpternlogq zmm2,zmm11,zmm7,0x96
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x4c0],0x0
vpternlogq zmm6,zmm10,zmm12,0x96
vpternlogq zmm10,zmm5,zmm7,0x96
vgf2p8affineqb zmm0,zmm0,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm4,zmm13,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm11,zmm4,zmm12,0x96
vgf2p8affineqb zmm9,zmm9,ZMMWORD PTR [rdx+0x680],0x0
vgf2p8affineqb zmm3,zmm13,ZMMWORD PTR [rdx+0x480],0x0
vpternlogq zmm3,zmm9,zmm11,0x96
vpternlogq zmm11,zmm0,zmm1,0x96
vpternlogq zmm9,zmm0,zmm10,0x96
vgf2p8affineqb zmm7,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm0,zmm7,zmm5,0x96
vpternlogq zmm7,zmm8,zmm10,0x96
vgf2p8affineqb zmm13,zmm13,ZMMWORD PTR [rdx+0x740],0x0
vpternlogq zmm8,zmm13,zmm2,0x96
vpternlogq zmm4,zmm2,zmm0,0x96
vpternlogq zmm1,zmm0,zmm6,0x96
mov rax,QWORD PTR [rsi]
not rax
vpbroadcastq zmm12,rax
vgf2p8affineqb zmm5,zmm12,ZMMWORD PTR [rcx+0x180],0x1
vgf2p8mulb zmm3,zmm3,zmm5
vpxorq zmm30,zmm30,zmm3
vgf2p8affineqb zmm10,zmm12,ZMMWORD PTR [rcx+0x40],0x1
vgf2p8mulb zmm7,zmm7,zmm10
vpxorq zmm25,zmm25,zmm7
vgf2p8affineqb zmm13,zmm12,ZMMWORD PTR [rcx+0x100],0x1
vgf2p8mulb zmm1,zmm1,zmm13
vpxorq zmm28,zmm28,zmm1
vgf2p8affineqb zmm2,zmm12,ZMMWORD PTR [rcx+0x140],0x1
vgf2p8mulb zmm8,zmm8,zmm2
vpxorq zmm29,zmm29,zmm8
vgf2p8affineqb zmm0,zmm12,ZMMWORD PTR [rcx+0x80],0x1
vgf2p8mulb zmm6,zmm6,zmm0
vpxorq zmm26,zmm26,zmm6
vgf2p8affineqb zmm5,zmm12,ZMMWORD PTR [rcx+0xc0],0x1
vgf2p8mulb zmm4,zmm4,zmm5
vpxorq zmm27,zmm27,zmm4
vgf2p8affineqb zmm3,zmm12,ZMMWORD PTR [rcx],0x1
vgf2p8mulb zmm11,zmm11,zmm3
vpxorq zmm24,zmm24,zmm11
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rcx+0x1c0],0x1
vgf2p8mulb zmm9,zmm9,zmm12
vpxorq zmm31,zmm31,zmm9
ret
.size flock_partial_gpr_free14_next,.-flock_partial_gpr_free14_next

.section .note.GNU-stack,"",@progbits
