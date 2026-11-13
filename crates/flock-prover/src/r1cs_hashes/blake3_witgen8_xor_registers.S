.text
.p2align 6
.globl flock_family19_scheduled_first
.hidden flock_family19_scheduled_first
.type flock_family19_scheduled_first,@function
flock_family19_scheduled_first:
vpbroadcastq zmm0,QWORD PTR [rdi+0x38]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x740]
vgf2p8affineqb zmm0,zmm0,zmm1,0x0
vpbroadcastq zmm2,QWORD PTR [rdi+0x10]
vpbroadcastq zmm3,QWORD PTR [rdi+0x30]
vpbroadcastq zmm4,QWORD PTR [rdi+0x28]
vpbroadcastq zmm5,QWORD PTR [rdi+0x20]
vpbroadcastq zmm6,QWORD PTR [rdi]
vpbroadcastq zmm7,QWORD PTR [rdi+0x8]
vgf2p8affineqb zmm8,zmm6,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm9,zmm7,ZMMWORD PTR [rdx+0x800],0x0
vgf2p8affineqb zmm10,zmm4,zmm1,0x0
vpbroadcastq zmm11,QWORD PTR [rdi+0x18]
vpternlogq zmm4,zmm11,zmm3,0x96
vgf2p8affineqb zmm4,zmm4,ZMMWORD PTR [rdx+0x440],0x0
vgf2p8affineqb zmm12,zmm2,ZMMWORD PTR [rdx+0x480],0x0
vmovdqa64 zmm13,zmm7
vpternlogq zmm13,zmm2,zmm5,0x96
vpxorq zmm14,zmm5,zmm6
vgf2p8affineqb zmm14,zmm14,ZMMWORD PTR [rdx+0x700],0x0
vgf2p8affineqb zmm15,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm9,zmm0,zmm15,0x96
vpternlogq zmm9,zmm8,zmm4,0x96
vgf2p8affineqb zmm13,zmm13,zmm1,0x0
vgf2p8affineqb zmm1,zmm6,zmm1,0x0
vgf2p8affineqb zmm0,zmm3,ZMMWORD PTR [rdx+0x680],0x0
vpternlogq zmm3,zmm7,zmm5,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x840],0x0
vgf2p8affineqb zmm5,zmm5,ZMMWORD PTR [rdx+0x580],0x0
vgf2p8affineqb zmm4,zmm6,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm4,zmm10,zmm9,0x96
vpxorq zmm8,zmm2,zmm6
vgf2p8affineqb zmm8,zmm8,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm2,zmm7,zmm11,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm8,zmm9,zmm11,0x96
vpternlogq zmm4,zmm11,zmm12,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x5c0],0x0
vpternlogq zmm2,zmm12,zmm9,0x96
vgf2p8affineqb zmm9,zmm6,ZMMWORD PTR [rdx+0x600],0x0
vgf2p8affineqb zmm10,zmm6,ZMMWORD PTR [rdx+0x7c0],0x0
vpxorq zmm6,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x880],0x0
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x4c0],0x0
vmovdqa64 zmm11,zmm5
vpternlogq zmm11,zmm9,zmm10,0x96
vpternlogq zmm6,zmm3,zmm11,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpternlogq zmm6,zmm14,zmm2,0x96
vpternlogq zmm14,zmm13,zmm0,0x96
vpternlogq zmm5,zmm14,zmm4,0x96
vpternlogq zmm11,zmm7,zmm0,0x96
vpternlogq zmm13,zmm3,zmm8,0x96
vpxorq zmm11,zmm11,zmm8
vpternlogq zmm9,zmm14,zmm2,0x96
vpternlogq zmm8,zmm2,zmm5,0x96
vpternlogq zmm3,zmm8,zmm14,0x96
vpternlogq zmm7,zmm10,zmm8,0x96
vpbroadcastq zmm0,QWORD PTR [rsi+0x28]
vpbroadcastq zmm2,QWORD PTR [rsi+0x8]
vpbroadcastq zmm4,QWORD PTR [rsi+0x10]
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x740]
vgf2p8affineqb zmm10,zmm2,ZMMWORD PTR [rcx+0x800],0x0
vpbroadcastq zmm12,QWORD PTR [rsi+0x20]
vmovdqa64 zmm14,zmm2
vpternlogq zmm14,zmm4,zmm12,0x96
vgf2p8affineqb zmm15,zmm14,ZMMWORD PTR [rcx+0x500],0x0
vgf2p8affineqb zmm14,zmm14,zmm8,0x0
vpbroadcastq zmm16,QWORD PTR [rsi+0x18]
vpbroadcastq zmm17,QWORD PTR [rsi]
vpbroadcastq zmm18,QWORD PTR [rsi+0x38]
vgf2p8affineqb zmm18,zmm18,zmm8,0x0
vpternlogq zmm10,zmm18,zmm15,0x96
vgf2p8affineqb zmm15,zmm17,ZMMWORD PTR [rcx+0x540],0x0
vpxorq zmm18,zmm12,zmm17
vgf2p8affineqb zmm18,zmm18,ZMMWORD PTR [rcx+0x700],0x0
vgf2p8affineqb zmm19,zmm16,ZMMWORD PTR [rcx+0x640],0x0
vpbroadcastq zmm20,QWORD PTR [rsi+0x30]
vgf2p8affineqb zmm21,zmm17,ZMMWORD PTR [rcx+0x6c0],0x0
vgf2p8affineqb zmm22,zmm0,zmm8,0x0
vpternlogq zmm0,zmm16,zmm20,0x96
vgf2p8affineqb zmm0,zmm0,ZMMWORD PTR [rcx+0x440],0x0
vpternlogq zmm10,zmm15,zmm0,0x96
vpternlogq zmm21,zmm22,zmm10,0x96
vpternlogq zmm16,zmm2,zmm4,0x96
vgf2p8affineqb zmm8,zmm17,zmm8,0x0
vgf2p8affineqb zmm16,zmm16,ZMMWORD PTR [rcx+0x5c0],0x0
vgf2p8affineqb zmm0,zmm4,ZMMWORD PTR [rcx+0x480],0x0
vpternlogq zmm16,zmm0,zmm10,0x96
vpternlogq zmm21,zmm19,zmm0,0x96
vpxorq zmm4,zmm4,zmm17
vgf2p8affineqb zmm4,zmm4,ZMMWORD PTR [rcx+0x400],0x0
vpternlogq zmm10,zmm19,zmm4,0x96
vgf2p8affineqb zmm0,zmm12,ZMMWORD PTR [rcx+0x580],0x0
vpternlogq zmm12,zmm2,zmm20,0x96
vgf2p8affineqb zmm20,zmm20,ZMMWORD PTR [rcx+0x680],0x0
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rcx+0x840],0x0
vgf2p8affineqb zmm4,zmm17,ZMMWORD PTR [rcx+0x7c0],0x0
vmovdqa64 zmm15,zmm14
vpternlogq zmm15,zmm20,zmm18,0x96
vpternlogq zmm14,zmm12,zmm10,0x96
vgf2p8mulb zmm30,zmm13,zmm14
vgf2p8affineqb zmm13,zmm2,ZMMWORD PTR [rcx+0x4c0],0x0
vpxorq zmm2,zmm2,zmm17
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rcx+0x880],0x0
vgf2p8affineqb zmm17,zmm17,ZMMWORD PTR [rcx+0x600],0x0
vmovdqa64 zmm14,zmm0
vpternlogq zmm14,zmm15,zmm21,0x96
vpternlogq zmm0,zmm17,zmm4,0x96
vpternlogq zmm2,zmm12,zmm0,0x96
vpternlogq zmm0,zmm13,zmm20,0x96
vpternlogq zmm21,zmm8,zmm2,0x96
vgf2p8mulb zmm28,zmm1,zmm21
vpternlogq zmm18,zmm2,zmm16,0x96
vgf2p8mulb zmm26,zmm6,zmm18
vgf2p8mulb zmm25,zmm5,zmm14
vpternlogq zmm14,zmm10,zmm16,0x96
vpternlogq zmm17,zmm15,zmm16,0x96
vpxorq zmm0,zmm0,zmm10
vgf2p8mulb zmm31,zmm9,zmm17
vpternlogq zmm13,zmm4,zmm14,0x96
vpternlogq zmm14,zmm12,zmm15,0x96
vgf2p8mulb zmm29,zmm7,zmm13
vgf2p8mulb zmm24,zmm3,zmm14
vgf2p8mulb zmm27,zmm11,zmm0
ret
.size flock_family19_scheduled_first, .-flock_family19_scheduled_first

.p2align 6
.globl flock_family19_scheduled_next
.hidden flock_family19_scheduled_next
.type flock_family19_scheduled_next,@function
flock_family19_scheduled_next:
vpbroadcastq zmm0,QWORD PTR [rdi+0x38]
vmovdqu64 zmm1,ZMMWORD PTR [rdx+0x740]
vgf2p8affineqb zmm0,zmm0,zmm1,0x0
vpbroadcastq zmm2,QWORD PTR [rdi+0x10]
vpbroadcastq zmm3,QWORD PTR [rdi+0x30]
vpbroadcastq zmm4,QWORD PTR [rdi+0x28]
vpbroadcastq zmm5,QWORD PTR [rdi+0x20]
vpbroadcastq zmm6,QWORD PTR [rdi]
vpbroadcastq zmm7,QWORD PTR [rdi+0x8]
vgf2p8affineqb zmm8,zmm6,ZMMWORD PTR [rdx+0x540],0x0
vgf2p8affineqb zmm9,zmm7,ZMMWORD PTR [rdx+0x800],0x0
vgf2p8affineqb zmm10,zmm4,zmm1,0x0
vpbroadcastq zmm11,QWORD PTR [rdi+0x18]
vpternlogq zmm4,zmm11,zmm3,0x96
vgf2p8affineqb zmm4,zmm4,ZMMWORD PTR [rdx+0x440],0x0
vgf2p8affineqb zmm12,zmm2,ZMMWORD PTR [rdx+0x480],0x0
vmovdqa64 zmm13,zmm7
vpternlogq zmm13,zmm2,zmm5,0x96
vpxorq zmm14,zmm5,zmm6
vgf2p8affineqb zmm14,zmm14,ZMMWORD PTR [rdx+0x700],0x0
vgf2p8affineqb zmm15,zmm13,ZMMWORD PTR [rdx+0x500],0x0
vpternlogq zmm9,zmm0,zmm15,0x96
vpternlogq zmm9,zmm8,zmm4,0x96
vgf2p8affineqb zmm13,zmm13,zmm1,0x0
vgf2p8affineqb zmm1,zmm6,zmm1,0x0
vgf2p8affineqb zmm0,zmm3,ZMMWORD PTR [rdx+0x680],0x0
vpternlogq zmm3,zmm7,zmm5,0x96
vgf2p8affineqb zmm3,zmm3,ZMMWORD PTR [rdx+0x840],0x0
vgf2p8affineqb zmm5,zmm5,ZMMWORD PTR [rdx+0x580],0x0
vgf2p8affineqb zmm4,zmm6,ZMMWORD PTR [rdx+0x6c0],0x0
vpternlogq zmm4,zmm10,zmm9,0x96
vpxorq zmm8,zmm2,zmm6
vgf2p8affineqb zmm8,zmm8,ZMMWORD PTR [rdx+0x400],0x0
vpternlogq zmm2,zmm7,zmm11,0x96
vgf2p8affineqb zmm11,zmm11,ZMMWORD PTR [rdx+0x640],0x0
vpternlogq zmm8,zmm9,zmm11,0x96
vpternlogq zmm4,zmm11,zmm12,0x96
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rdx+0x5c0],0x0
vpternlogq zmm2,zmm12,zmm9,0x96
vgf2p8affineqb zmm9,zmm6,ZMMWORD PTR [rdx+0x600],0x0
vgf2p8affineqb zmm10,zmm6,ZMMWORD PTR [rdx+0x7c0],0x0
vpxorq zmm6,zmm7,zmm6
vgf2p8affineqb zmm6,zmm6,ZMMWORD PTR [rdx+0x880],0x0
vgf2p8affineqb zmm7,zmm7,ZMMWORD PTR [rdx+0x4c0],0x0
vmovdqa64 zmm11,zmm5
vpternlogq zmm11,zmm9,zmm10,0x96
vpternlogq zmm6,zmm3,zmm11,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpternlogq zmm6,zmm14,zmm2,0x96
vpternlogq zmm14,zmm13,zmm0,0x96
vpternlogq zmm5,zmm14,zmm4,0x96
vpternlogq zmm11,zmm7,zmm0,0x96
vpternlogq zmm13,zmm3,zmm8,0x96
vpxorq zmm11,zmm11,zmm8
vpternlogq zmm9,zmm14,zmm2,0x96
vpternlogq zmm8,zmm2,zmm5,0x96
vpternlogq zmm3,zmm8,zmm14,0x96
vpternlogq zmm7,zmm10,zmm8,0x96
vpbroadcastq zmm0,QWORD PTR [rsi+0x28]
vpbroadcastq zmm2,QWORD PTR [rsi+0x8]
vpbroadcastq zmm4,QWORD PTR [rsi+0x10]
vmovdqu64 zmm8,ZMMWORD PTR [rcx+0x740]
vgf2p8affineqb zmm10,zmm2,ZMMWORD PTR [rcx+0x800],0x0
vpbroadcastq zmm12,QWORD PTR [rsi+0x20]
vmovdqa64 zmm14,zmm2
vpternlogq zmm14,zmm4,zmm12,0x96
vgf2p8affineqb zmm15,zmm14,ZMMWORD PTR [rcx+0x500],0x0
vgf2p8affineqb zmm14,zmm14,zmm8,0x0
vpbroadcastq zmm16,QWORD PTR [rsi+0x18]
vpbroadcastq zmm17,QWORD PTR [rsi]
vpbroadcastq zmm18,QWORD PTR [rsi+0x38]
vgf2p8affineqb zmm18,zmm18,zmm8,0x0
vpternlogq zmm10,zmm18,zmm15,0x96
vgf2p8affineqb zmm15,zmm17,ZMMWORD PTR [rcx+0x540],0x0
vpxorq zmm18,zmm12,zmm17
vgf2p8affineqb zmm18,zmm18,ZMMWORD PTR [rcx+0x700],0x0
vgf2p8affineqb zmm19,zmm16,ZMMWORD PTR [rcx+0x640],0x0
vpbroadcastq zmm20,QWORD PTR [rsi+0x30]
vgf2p8affineqb zmm21,zmm17,ZMMWORD PTR [rcx+0x6c0],0x0
vgf2p8affineqb zmm22,zmm0,zmm8,0x0
vpternlogq zmm0,zmm16,zmm20,0x96
vgf2p8affineqb zmm0,zmm0,ZMMWORD PTR [rcx+0x440],0x0
vpternlogq zmm10,zmm15,zmm0,0x96
vpternlogq zmm21,zmm22,zmm10,0x96
vpternlogq zmm16,zmm2,zmm4,0x96
vgf2p8affineqb zmm8,zmm17,zmm8,0x0
vgf2p8affineqb zmm16,zmm16,ZMMWORD PTR [rcx+0x5c0],0x0
vgf2p8affineqb zmm0,zmm4,ZMMWORD PTR [rcx+0x480],0x0
vpternlogq zmm16,zmm0,zmm10,0x96
vpternlogq zmm21,zmm19,zmm0,0x96
vpxorq zmm4,zmm4,zmm17
vgf2p8affineqb zmm4,zmm4,ZMMWORD PTR [rcx+0x400],0x0
vpternlogq zmm10,zmm19,zmm4,0x96
vgf2p8affineqb zmm0,zmm12,ZMMWORD PTR [rcx+0x580],0x0
vpternlogq zmm12,zmm2,zmm20,0x96
vgf2p8affineqb zmm20,zmm20,ZMMWORD PTR [rcx+0x680],0x0
vgf2p8affineqb zmm12,zmm12,ZMMWORD PTR [rcx+0x840],0x0
vgf2p8affineqb zmm4,zmm17,ZMMWORD PTR [rcx+0x7c0],0x0
vmovdqa64 zmm15,zmm14
vpternlogq zmm15,zmm20,zmm18,0x96
vpternlogq zmm14,zmm12,zmm10,0x96
vgf2p8mulb zmm13,zmm13,zmm14
vpxorq zmm30,zmm30,zmm13
vgf2p8affineqb zmm13,zmm2,ZMMWORD PTR [rcx+0x4c0],0x0
vpxorq zmm2,zmm2,zmm17
vgf2p8affineqb zmm2,zmm2,ZMMWORD PTR [rcx+0x880],0x0
vgf2p8affineqb zmm17,zmm17,ZMMWORD PTR [rcx+0x600],0x0
vmovdqa64 zmm14,zmm0
vpternlogq zmm14,zmm15,zmm21,0x96
vpternlogq zmm0,zmm17,zmm4,0x96
vpternlogq zmm2,zmm12,zmm0,0x96
vpternlogq zmm0,zmm13,zmm20,0x96
vpternlogq zmm21,zmm8,zmm2,0x96
vgf2p8mulb zmm1,zmm1,zmm21
vpxorq zmm28,zmm28,zmm1
vpternlogq zmm18,zmm2,zmm16,0x96
vgf2p8mulb zmm6,zmm6,zmm18
vpxorq zmm26,zmm26,zmm6
vgf2p8mulb zmm5,zmm5,zmm14
vpxorq zmm25,zmm25,zmm5
vpternlogq zmm14,zmm10,zmm16,0x96
vpternlogq zmm17,zmm15,zmm16,0x96
vpxorq zmm0,zmm0,zmm10
vgf2p8mulb zmm9,zmm9,zmm17
vpxorq zmm31,zmm31,zmm9
vpternlogq zmm13,zmm4,zmm14,0x96
vpternlogq zmm14,zmm12,zmm15,0x96
vgf2p8mulb zmm7,zmm7,zmm13
vpxorq zmm29,zmm29,zmm7
vgf2p8mulb zmm3,zmm3,zmm14
vpxorq zmm24,zmm24,zmm3
vgf2p8mulb zmm11,zmm11,zmm0
vpxorq zmm27,zmm27,zmm11
ret
.size flock_family19_scheduled_next, .-flock_family19_scheduled_next

.section .note.GNU-stack,"",@progbits
