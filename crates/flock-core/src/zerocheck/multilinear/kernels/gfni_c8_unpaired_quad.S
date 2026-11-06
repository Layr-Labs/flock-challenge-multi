// SPDX-License-Identifier: Apache-2.0 OR MIT
// Four-span C8 leaf: RDI=A1024B, RDX=B1024B, RSI=unpaired matrix8192B.
// Returns final lane-major A ZMM8..11 and B ZMM12..15, without extra shuffles.
// Clobbers RAX, flags, ZMM0..15; preserves other GPRs and ZMM16..31.
// Scratch: 2048 initialized bytes on a private 64-byte aligned stack frame.
// The gathers and byte masks extend the public C4 register-return method.

.text
.p2align 6
.globl flock_gfni_c8_unpaired_quad
.hidden flock_gfni_c8_unpaired_quad
.type flock_gfni_c8_unpaired_quad,@function
flock_gfni_c8_unpaired_quad:
mov rax,rsp
and rsp,-64
sub rsp,2048
vmovdqu64 zmm0,[rdi+0]
vmovdqu64 zmm1,[rdi+64]
vmovdqu64 zmm2,[rdi+256]
vmovdqu64 zmm3,[rdi+320]
vmovdqu64 zmm4,[rdi+512]
vmovdqu64 zmm5,[rdi+576]
vmovdqu64 zmm6,[rdi+768]
vmovdqu64 zmm7,[rdi+832]
vshufi64x2 zmm8,zmm0,zmm1,0x44
vshufi64x2 zmm9,zmm2,zmm3,0x44
vshufi64x2 zmm10,zmm4,zmm5,0x44
vshufi64x2 zmm11,zmm6,zmm7,0x44
vshufi64x2 zmm0,zmm0,zmm1,0xee
vshufi64x2 zmm1,zmm2,zmm3,0xee
vshufi64x2 zmm2,zmm4,zmm5,0xee
vshufi64x2 zmm3,zmm6,zmm7,0xee
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 256], zmm6
    vmovdqa64 [rsp + 320], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 384], zmm6
    vmovdqa64 [rsp + 448], zmm0
vmovdqa64 zmm0,zmm8
vmovdqa64 zmm1,zmm9
vmovdqa64 zmm2,zmm10
vmovdqa64 zmm3,zmm11
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 0], zmm6
    vmovdqa64 [rsp + 64], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 128], zmm6
    vmovdqa64 [rsp + 192], zmm0
vmovdqu64 zmm0,[rdi+128]
vmovdqu64 zmm1,[rdi+192]
vmovdqu64 zmm2,[rdi+384]
vmovdqu64 zmm3,[rdi+448]
vmovdqu64 zmm4,[rdi+640]
vmovdqu64 zmm5,[rdi+704]
vmovdqu64 zmm6,[rdi+896]
vmovdqu64 zmm7,[rdi+960]
vshufi64x2 zmm8,zmm0,zmm1,0x44
vshufi64x2 zmm9,zmm2,zmm3,0x44
vshufi64x2 zmm10,zmm4,zmm5,0x44
vshufi64x2 zmm11,zmm6,zmm7,0x44
vshufi64x2 zmm0,zmm0,zmm1,0xee
vshufi64x2 zmm1,zmm2,zmm3,0xee
vshufi64x2 zmm2,zmm4,zmm5,0xee
vshufi64x2 zmm3,zmm6,zmm7,0xee
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 768], zmm6
    vmovdqa64 [rsp + 832], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 896], zmm6
    vmovdqa64 [rsp + 960], zmm0
vmovdqa64 zmm0,zmm8
vmovdqa64 zmm1,zmm9
vmovdqa64 zmm2,zmm10
vmovdqa64 zmm3,zmm11
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 512], zmm6
    vmovdqa64 [rsp + 576], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 640], zmm6
    vmovdqa64 [rsp + 704], zmm0
vmovdqu64 zmm0,[rdx+0]
vmovdqu64 zmm1,[rdx+64]
vmovdqu64 zmm2,[rdx+256]
vmovdqu64 zmm3,[rdx+320]
vmovdqu64 zmm4,[rdx+512]
vmovdqu64 zmm5,[rdx+576]
vmovdqu64 zmm6,[rdx+768]
vmovdqu64 zmm7,[rdx+832]
vshufi64x2 zmm8,zmm0,zmm1,0x44
vshufi64x2 zmm9,zmm2,zmm3,0x44
vshufi64x2 zmm10,zmm4,zmm5,0x44
vshufi64x2 zmm11,zmm6,zmm7,0x44
vshufi64x2 zmm0,zmm0,zmm1,0xee
vshufi64x2 zmm1,zmm2,zmm3,0xee
vshufi64x2 zmm2,zmm4,zmm5,0xee
vshufi64x2 zmm3,zmm6,zmm7,0xee
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 1280], zmm6
    vmovdqa64 [rsp + 1344], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 1408], zmm6
    vmovdqa64 [rsp + 1472], zmm0
vmovdqa64 zmm0,zmm8
vmovdqa64 zmm1,zmm9
vmovdqa64 zmm2,zmm10
vmovdqa64 zmm3,zmm11
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 1024], zmm6
    vmovdqa64 [rsp + 1088], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 1152], zmm6
    vmovdqa64 [rsp + 1216], zmm0
vmovdqu64 zmm0,[rdx+128]
vmovdqu64 zmm1,[rdx+192]
vmovdqu64 zmm2,[rdx+384]
vmovdqu64 zmm3,[rdx+448]
vmovdqu64 zmm4,[rdx+640]
vmovdqu64 zmm5,[rdx+704]
vmovdqu64 zmm6,[rdx+896]
vmovdqu64 zmm7,[rdx+960]
vshufi64x2 zmm8,zmm0,zmm1,0x44
vshufi64x2 zmm9,zmm2,zmm3,0x44
vshufi64x2 zmm10,zmm4,zmm5,0x44
vshufi64x2 zmm11,zmm6,zmm7,0x44
vshufi64x2 zmm0,zmm0,zmm1,0xee
vshufi64x2 zmm1,zmm2,zmm3,0xee
vshufi64x2 zmm2,zmm4,zmm5,0xee
vshufi64x2 zmm3,zmm6,zmm7,0xee
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 1792], zmm6
    vmovdqa64 [rsp + 1856], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 1920], zmm6
    vmovdqa64 [rsp + 1984], zmm0
vmovdqa64 zmm0,zmm8
vmovdqa64 zmm1,zmm9
vmovdqa64 zmm2,zmm10
vmovdqa64 zmm3,zmm11
    vshufi64x2 zmm4, zmm0, zmm1, 0x88
    vshufi64x2 zmm0, zmm0, zmm1, 0xdd
    vshufi64x2 zmm5, zmm2, zmm3, 0x88
    vshufi64x2 zmm2, zmm2, zmm3, 0xdd
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm4, zmm5
    vmovdqa64 zmm7, [rip + .Lflock_c8_uq_oct_odd]
    vpermt2b zmm4, zmm7, zmm5
    vmovdqa64 [rsp + 1536], zmm6
    vmovdqa64 [rsp + 1600], zmm4
    vmovdqa64 zmm6, [rip + .Lflock_c8_uq_oct_even]
    vpermi2b zmm6, zmm0, zmm2
    vpermt2b zmm0, zmm7, zmm2
    vmovdqa64 [rsp + 1664], zmm6
    vmovdqa64 [rsp + 1728], zmm0
vmovdqu64 zmm4,[rsi+0]
vmovdqu64 zmm5,[rsi+4096]
vmovdqu64 zmm6,[rsi+64]
vmovdqu64 zmm7,[rsi+4160]
vpbroadcastq zmm0,[rsp+0]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+8]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpxorq zmm8,zmm1,zmm3
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpxorq zmm9,zmm2,zmm3
vpbroadcastq zmm0,[rsp+512]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+520]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpxorq zmm10,zmm1,zmm3
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpxorq zmm11,zmm2,zmm3
vpbroadcastq zmm0,[rsp+1024]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1032]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpxorq zmm12,zmm1,zmm3
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpxorq zmm13,zmm2,zmm3
vpbroadcastq zmm0,[rsp+1536]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1544]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpxorq zmm14,zmm1,zmm3
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpxorq zmm15,zmm2,zmm3
vmovdqu64 zmm4,[rsi+128]
vmovdqu64 zmm5,[rsi+4224]
vmovdqu64 zmm6,[rsi+192]
vmovdqu64 zmm7,[rsi+4288]
vpbroadcastq zmm0,[rsp+16]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+24]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+528]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+536]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1040]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1048]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1552]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1560]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+256]
vmovdqu64 zmm5,[rsi+4352]
vmovdqu64 zmm6,[rsi+320]
vmovdqu64 zmm7,[rsi+4416]
vpbroadcastq zmm0,[rsp+32]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+40]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+544]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+552]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1056]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1064]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1568]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1576]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+384]
vmovdqu64 zmm5,[rsi+4480]
vmovdqu64 zmm6,[rsi+448]
vmovdqu64 zmm7,[rsi+4544]
vpbroadcastq zmm0,[rsp+48]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+56]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+560]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+568]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1072]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1080]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1584]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1592]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+512]
vmovdqu64 zmm5,[rsi+4608]
vmovdqu64 zmm6,[rsi+576]
vmovdqu64 zmm7,[rsi+4672]
vpbroadcastq zmm0,[rsp+64]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+72]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+576]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+584]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1088]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1096]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1600]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1608]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+640]
vmovdqu64 zmm5,[rsi+4736]
vmovdqu64 zmm6,[rsi+704]
vmovdqu64 zmm7,[rsi+4800]
vpbroadcastq zmm0,[rsp+80]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+88]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+592]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+600]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1104]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1112]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1616]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1624]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+768]
vmovdqu64 zmm5,[rsi+4864]
vmovdqu64 zmm6,[rsi+832]
vmovdqu64 zmm7,[rsi+4928]
vpbroadcastq zmm0,[rsp+96]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+104]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+608]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+616]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1120]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1128]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1632]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1640]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+896]
vmovdqu64 zmm5,[rsi+4992]
vmovdqu64 zmm6,[rsi+960]
vmovdqu64 zmm7,[rsi+5056]
vpbroadcastq zmm0,[rsp+112]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+120]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+624]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+632]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1136]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1144]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1648]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1656]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1024]
vmovdqu64 zmm5,[rsi+5120]
vmovdqu64 zmm6,[rsi+1088]
vmovdqu64 zmm7,[rsi+5184]
vpbroadcastq zmm0,[rsp+128]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+136]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+640]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+648]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1152]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1160]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1664]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1672]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1152]
vmovdqu64 zmm5,[rsi+5248]
vmovdqu64 zmm6,[rsi+1216]
vmovdqu64 zmm7,[rsi+5312]
vpbroadcastq zmm0,[rsp+144]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+152]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+656]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+664]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1168]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1176]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1680]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1688]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1280]
vmovdqu64 zmm5,[rsi+5376]
vmovdqu64 zmm6,[rsi+1344]
vmovdqu64 zmm7,[rsi+5440]
vpbroadcastq zmm0,[rsp+160]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+168]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+672]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+680]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1184]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1192]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1696]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1704]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1408]
vmovdqu64 zmm5,[rsi+5504]
vmovdqu64 zmm6,[rsi+1472]
vmovdqu64 zmm7,[rsi+5568]
vpbroadcastq zmm0,[rsp+176]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+184]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+688]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+696]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1200]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1208]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1712]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1720]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1536]
vmovdqu64 zmm5,[rsi+5632]
vmovdqu64 zmm6,[rsi+1600]
vmovdqu64 zmm7,[rsi+5696]
vpbroadcastq zmm0,[rsp+192]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+200]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+704]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+712]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1216]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1224]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1728]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1736]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1664]
vmovdqu64 zmm5,[rsi+5760]
vmovdqu64 zmm6,[rsi+1728]
vmovdqu64 zmm7,[rsi+5824]
vpbroadcastq zmm0,[rsp+208]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+216]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+720]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+728]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1232]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1240]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1744]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1752]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1792]
vmovdqu64 zmm5,[rsi+5888]
vmovdqu64 zmm6,[rsi+1856]
vmovdqu64 zmm7,[rsi+5952]
vpbroadcastq zmm0,[rsp+224]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+232]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+736]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+744]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1248]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1256]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1760]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1768]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+1920]
vmovdqu64 zmm5,[rsi+6016]
vmovdqu64 zmm6,[rsi+1984]
vmovdqu64 zmm7,[rsi+6080]
vpbroadcastq zmm0,[rsp+240]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+248]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+752]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+760]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1264]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1272]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1776]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1784]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2048]
vmovdqu64 zmm5,[rsi+6144]
vmovdqu64 zmm6,[rsi+2112]
vmovdqu64 zmm7,[rsi+6208]
vpbroadcastq zmm0,[rsp+256]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+264]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+768]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+776]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1280]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1288]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1792]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1800]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2176]
vmovdqu64 zmm5,[rsi+6272]
vmovdqu64 zmm6,[rsi+2240]
vmovdqu64 zmm7,[rsi+6336]
vpbroadcastq zmm0,[rsp+272]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+280]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+784]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+792]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1296]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1304]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1808]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1816]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2304]
vmovdqu64 zmm5,[rsi+6400]
vmovdqu64 zmm6,[rsi+2368]
vmovdqu64 zmm7,[rsi+6464]
vpbroadcastq zmm0,[rsp+288]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+296]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+800]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+808]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1312]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1320]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1824]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1832]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2432]
vmovdqu64 zmm5,[rsi+6528]
vmovdqu64 zmm6,[rsi+2496]
vmovdqu64 zmm7,[rsi+6592]
vpbroadcastq zmm0,[rsp+304]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+312]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+816]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+824]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1328]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1336]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1840]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1848]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2560]
vmovdqu64 zmm5,[rsi+6656]
vmovdqu64 zmm6,[rsi+2624]
vmovdqu64 zmm7,[rsi+6720]
vpbroadcastq zmm0,[rsp+320]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+328]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+832]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+840]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1344]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1352]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1856]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1864]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2688]
vmovdqu64 zmm5,[rsi+6784]
vmovdqu64 zmm6,[rsi+2752]
vmovdqu64 zmm7,[rsi+6848]
vpbroadcastq zmm0,[rsp+336]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+344]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+848]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+856]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1360]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1368]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1872]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1880]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2816]
vmovdqu64 zmm5,[rsi+6912]
vmovdqu64 zmm6,[rsi+2880]
vmovdqu64 zmm7,[rsi+6976]
vpbroadcastq zmm0,[rsp+352]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+360]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+864]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+872]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1376]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1384]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1888]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1896]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+2944]
vmovdqu64 zmm5,[rsi+7040]
vmovdqu64 zmm6,[rsi+3008]
vmovdqu64 zmm7,[rsi+7104]
vpbroadcastq zmm0,[rsp+368]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+376]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+880]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+888]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1392]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1400]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1904]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1912]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3072]
vmovdqu64 zmm5,[rsi+7168]
vmovdqu64 zmm6,[rsi+3136]
vmovdqu64 zmm7,[rsi+7232]
vpbroadcastq zmm0,[rsp+384]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+392]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+896]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+904]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1408]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1416]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1920]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1928]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3200]
vmovdqu64 zmm5,[rsi+7296]
vmovdqu64 zmm6,[rsi+3264]
vmovdqu64 zmm7,[rsi+7360]
vpbroadcastq zmm0,[rsp+400]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+408]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+912]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+920]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1424]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1432]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1936]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1944]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3328]
vmovdqu64 zmm5,[rsi+7424]
vmovdqu64 zmm6,[rsi+3392]
vmovdqu64 zmm7,[rsi+7488]
vpbroadcastq zmm0,[rsp+416]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+424]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+928]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+936]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1440]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1448]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1952]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1960]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3456]
vmovdqu64 zmm5,[rsi+7552]
vmovdqu64 zmm6,[rsi+3520]
vmovdqu64 zmm7,[rsi+7616]
vpbroadcastq zmm0,[rsp+432]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+440]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+944]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+952]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1456]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1464]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1968]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1976]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3584]
vmovdqu64 zmm5,[rsi+7680]
vmovdqu64 zmm6,[rsi+3648]
vmovdqu64 zmm7,[rsi+7744]
vpbroadcastq zmm0,[rsp+448]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+456]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+960]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+968]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1472]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1480]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1984]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1992]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3712]
vmovdqu64 zmm5,[rsi+7808]
vmovdqu64 zmm6,[rsi+3776]
vmovdqu64 zmm7,[rsi+7872]
vpbroadcastq zmm0,[rsp+464]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+472]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+976]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+984]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1488]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1496]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+2000]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+2008]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3840]
vmovdqu64 zmm5,[rsi+7936]
vmovdqu64 zmm6,[rsi+3904]
vmovdqu64 zmm7,[rsi+8000]
vpbroadcastq zmm0,[rsp+480]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+488]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+992]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1000]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1504]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1512]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+2016]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+2024]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqu64 zmm4,[rsi+3968]
vmovdqu64 zmm5,[rsi+8064]
vmovdqu64 zmm6,[rsi+4032]
vmovdqu64 zmm7,[rsi+8128]
vpbroadcastq zmm0,[rsp+496]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+504]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm8,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm9,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1008]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1016]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm10,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm11,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+1520]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+1528]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm12,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm13,zmm2,zmm3,0x96
vpbroadcastq zmm0,[rsp+2032]
vgf2p8affineqb zmm1,zmm0,zmm4,0
vgf2p8affineqb zmm2,zmm0,zmm5,0
vpbroadcastq zmm0,[rsp+2040]
vgf2p8affineqb zmm3,zmm0,zmm6,0
vpternlogq zmm14,zmm1,zmm3,0x96
vgf2p8affineqb zmm3,zmm0,zmm7,0
vpternlogq zmm15,zmm2,zmm3,0x96
vmovdqa64 zmm0,[rip+.Lflock_c8_uq_out_even]
vmovdqa64 zmm1,[rip+.Lflock_c8_uq_out_odd]
vpermi2b zmm0,zmm8,zmm9
vpermi2b zmm1,zmm8,zmm9
vmovdqa64 zmm8,zmm0
vmovdqa64 zmm9,zmm1
vmovdqa64 zmm0,[rip+.Lflock_c8_uq_out_even]
vmovdqa64 zmm1,[rip+.Lflock_c8_uq_out_odd]
vpermi2b zmm0,zmm10,zmm11
vpermi2b zmm1,zmm10,zmm11
vmovdqa64 zmm10,zmm0
vmovdqa64 zmm11,zmm1
vmovdqa64 zmm0,[rip+.Lflock_c8_uq_out_even]
vmovdqa64 zmm1,[rip+.Lflock_c8_uq_out_odd]
vpermi2b zmm0,zmm12,zmm13
vpermi2b zmm1,zmm12,zmm13
vmovdqa64 zmm12,zmm0
vmovdqa64 zmm13,zmm1
vmovdqa64 zmm0,[rip+.Lflock_c8_uq_out_even]
vmovdqa64 zmm1,[rip+.Lflock_c8_uq_out_odd]
vpermi2b zmm0,zmm14,zmm15
vpermi2b zmm1,zmm14,zmm15
vmovdqa64 zmm14,zmm0
vmovdqa64 zmm15,zmm1
mov rsp,rax
ret
.size flock_gfni_c8_unpaired_quad,.-flock_gfni_c8_unpaired_quad
.section .rodata

.p2align 6
.Lflock_c8_uq_oct_even:
    .byte 0, 16, 32, 48, 64, 80, 96, 112, 1, 17, 33, 49, 65, 81, 97, 113, 2, 18, 34, 50, 66, 82, 98, 114, 3, 19, 35, 51, 67, 83, 99, 115, 4, 20, 36, 52, 68, 84, 100, 116, 5, 21, 37, 53, 69, 85, 101, 117, 6, 22, 38, 54, 70, 86, 102, 118, 7, 23, 39, 55, 71, 87, 103, 119

.p2align 6
.Lflock_c8_uq_oct_odd:
    .byte 8, 24, 40, 56, 72, 88, 104, 120, 9, 25, 41, 57, 73, 89, 105, 121, 10, 26, 42, 58, 74, 90, 106, 122, 11, 27, 43, 59, 75, 91, 107, 123, 12, 28, 44, 60, 76, 92, 108, 124, 13, 29, 45, 61, 77, 93, 109, 125, 14, 30, 46, 62, 78, 94, 110, 126, 15, 31, 47, 63, 79, 95, 111, 127

.p2align 6
.Lflock_c8_uq_out_even:
    .byte 0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82, 90, 98, 106, 114, 122, 4, 12, 20, 28, 36, 44, 52, 60, 68, 76, 84, 92, 100, 108, 116, 124, 6, 14, 22, 30, 38, 46, 54, 62, 70, 78, 86, 94, 102, 110, 118, 126

.p2align 6
.Lflock_c8_uq_out_odd:
    .byte 1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 3, 11, 19, 27, 35, 43, 51, 59, 67, 75, 83, 91, 99, 107, 115, 123, 5, 13, 21, 29, 37, 45, 53, 61, 69, 77, 85, 93, 101, 109, 117, 125, 7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87, 95, 103, 111, 119, 127
