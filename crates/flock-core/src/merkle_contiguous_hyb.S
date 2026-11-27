// Hybrid AVX-512 + scalar-GPR BLAKE3 leaf kernel (generated; see the
// generator description in the submission note). The vector part is
// flock_blake3_contiguous_1024 / planes_leaf_1024 from merkle_contiguous.S,
// itself derived from BLAKE3 1.8.6 c/blake3_avx512_x86-64_unix.S (CC0-1.0),
// with the assembly hoists of e-man07's c84cbde1.
.text
.p2align 6
.global flock_blake3_planes_leaf_1024_hyb
.hidden flock_blake3_planes_leaf_1024_hyb
.type flock_blake3_planes_leaf_1024_hyb, @function
flock_blake3_planes_leaf_1024_hyb:
        push    r15
        push    r14
        push    r13
        push    r12
        push    rbx
        push    rbp
        mov     rbp, rsp
        sub     rsp, 0x2C0
        and     rsp, 0xFFFFFFFFFFFFFFC0
        lea     r11, [rdi+114688]
        mov     rax, qword ptr [rbp+0x50]
        add     rax, 3584
        mov     qword ptr [rsp+0x208], rax
        mov     esi, 112
2:
        mov     r8d, dword ptr [rcx+0x0]
        mov     dword ptr [rsp+0x180], r8d
        mov     dword ptr [rsp+0x1a0], r8d
        mov     r8d, dword ptr [rcx+0x4]
        mov     dword ptr [rsp+0x184], r8d
        mov     dword ptr [rsp+0x1a4], r8d
        mov     r8d, dword ptr [rcx+0x8]
        mov     dword ptr [rsp+0x188], r8d
        mov     dword ptr [rsp+0x1a8], r8d
        mov     r8d, dword ptr [rcx+0xc]
        mov     dword ptr [rsp+0x18c], r8d
        mov     dword ptr [rsp+0x1ac], r8d
        mov     r8d, dword ptr [rcx+0x10]
        mov     dword ptr [rsp+0x190], r8d
        mov     dword ptr [rsp+0x1b0], r8d
        mov     r8d, dword ptr [rcx+0x14]
        mov     dword ptr [rsp+0x194], r8d
        mov     dword ptr [rsp+0x1b4], r8d
        mov     r8d, dword ptr [rcx+0x18]
        mov     dword ptr [rsp+0x198], r8d
        mov     dword ptr [rsp+0x1b8], r8d
        mov     r8d, dword ptr [rcx+0x1c]
        mov     dword ptr [rsp+0x19c], r8d
        mov     dword ptr [rsp+0x1bc], r8d
        vpbroadcastd zmm0, dword ptr [rcx]
        vpbroadcastd zmm1, dword ptr [rcx+0x1*0x4]
        vpbroadcastd zmm2, dword ptr [rcx+0x2*0x4]
        vpbroadcastd zmm3, dword ptr [rcx+0x3*0x4]
        vpbroadcastd zmm4, dword ptr [rcx+0x4*0x4]
        vpbroadcastd zmm5, dword ptr [rcx+0x5*0x4]
        vpbroadcastd zmm6, dword ptr [rcx+0x6*0x4]
        vpbroadcastd zmm7, dword ptr [rcx+0x7*0x4]
        movzx   eax, byte ptr [rbp+0x38]
        movzx   ebx, byte ptr [rbp+0x40]
        or      eax, ebx
        xor     edx, edx
        .p2align 5
        .p2align 5
9:
        movzx   ebx, byte ptr [rbp+0x48]
        or      ebx, eax
        add     rdx, 64
        cmp     rdx, 1024
        cmove   eax, ebx
        mov     dword ptr [rsp+0x88], eax
        vmovdqu32 zmm16, zmmword ptr [r11]
        vmovdqu32 zmmword ptr [rsp+0x100], zmm16
        vmovdqu32 zmm16, zmmword ptr [r11+1024]
        vmovdqu32 zmmword ptr [rsp+0x140], zmm16
        add     r11, 64
        vmovdqu32 ymm16, ymmword ptr [rdi+rdx+-64]
        vinserti64x4 zmm16, zmm16, ymmword ptr [rdi+rdx+4032], 0x01
        vmovdqu32 ymm17, ymmword ptr [rdi+rdx+960]
        vinserti64x4 zmm17, zmm17, ymmword ptr [rdi+rdx+5056], 0x01
        vpunpcklqdq zmm8, zmm16, zmm17
        vpunpckhqdq zmm9, zmm16, zmm17
        vmovdqu32 ymm18, ymmword ptr [rdi+rdx+1984]
        vinserti64x4 zmm18, zmm18, ymmword ptr [rdi+rdx+6080], 0x01
        vmovdqu32 ymm19, ymmword ptr [rdi+rdx+3008]
        vinserti64x4 zmm19, zmm19, ymmword ptr [rdi+rdx+7104], 0x01
        vpunpcklqdq zmm10, zmm18, zmm19
        vpunpckhqdq zmm11, zmm18, zmm19
        vmovdqu32 ymm16, ymmword ptr [rdi+rdx+8128]
        vinserti64x4 zmm16, zmm16, ymmword ptr [rdi+rdx+12224], 0x01
        vmovdqu32 ymm17, ymmword ptr [rdi+rdx+9152]
        vinserti64x4 zmm17, zmm17, ymmword ptr [rdi+rdx+13248], 0x01
        vpunpcklqdq zmm12, zmm16, zmm17
        vpunpckhqdq zmm13, zmm16, zmm17
        vmovdqu32 ymm18, ymmword ptr [rdi+rdx+10176]
        vinserti64x4 zmm18, zmm18, ymmword ptr [rdi+rdx+14272], 0x01
        vmovdqu32 ymm19, ymmword ptr [rdi+rdx+11200]
        vinserti64x4 zmm19, zmm19, ymmword ptr [rdi+rdx+15296], 0x01
        vpunpcklqdq zmm14, zmm18, zmm19
        vpunpckhqdq zmm15, zmm18, zmm19
        vshufps zmm16, zmm8, zmm10, 136
        vshufps zmm17, zmm12, zmm14, 136
        vshufi32x4 zmm20, zmm16, zmm17, 0xdd
        vshufi32x4 zmm16, zmm16, zmm17, 0x88
        vshufps zmm17, zmm8, zmm10, 221
        vshufps zmm30, zmm12, zmm14, 221
        vshufi32x4 zmm21, zmm17, zmm30, 0xdd
        vshufi32x4 zmm17, zmm17, zmm30, 0x88
        vshufps zmm18, zmm9, zmm11, 136
        vshufps zmm8, zmm13, zmm15, 136
        vshufi32x4 zmm22, zmm18, zmm8, 0xdd
        vshufi32x4 zmm18, zmm18, zmm8, 0x88
        vshufps zmm19, zmm9, zmm11, 221
        vshufps zmm8, zmm13, zmm15, 221
        vshufi32x4 zmm23, zmm19, zmm8, 0xdd
        vshufi32x4 zmm19, zmm19, zmm8, 0x88
        vmovdqu32 ymm24, ymmword ptr [rdi+rdx+-32]
        vinserti64x4 zmm24, zmm24, ymmword ptr [rdi+rdx+4064], 0x01
        vmovdqu32 ymm25, ymmword ptr [rdi+rdx+992]
        vinserti64x4 zmm25, zmm25, ymmword ptr [rdi+rdx+5088], 0x01
        vpunpcklqdq zmm8, zmm24, zmm25
        vpunpckhqdq zmm9, zmm24, zmm25
        vmovdqu32 ymm24, ymmword ptr [rdi+rdx+2016]
        vinserti64x4 zmm24, zmm24, ymmword ptr [rdi+rdx+6112], 0x01
        vmovdqu32 ymm25, ymmword ptr [rdi+rdx+3040]
        vinserti64x4 zmm25, zmm25, ymmword ptr [rdi+rdx+7136], 0x01
        vpunpcklqdq zmm10, zmm24, zmm25
        vpunpckhqdq zmm11, zmm24, zmm25
        // RDX already advanced by 64: hint the next compression block.
        prefetcht0 [rdi+rdx+0]
        prefetcht0 [rdi+rdx+8192]
        prefetcht0 [rdi+rdx+1024]
        prefetcht0 [rdi+rdx+9216]
        prefetcht0 [rdi+rdx+2048]
        prefetcht0 [rdi+rdx+10240]
        prefetcht0 [rdi+rdx+3072]
        prefetcht0 [rdi+rdx+11264]
        vmovdqu32 ymm24, ymmword ptr [rdi+rdx+8160]
        vinserti64x4 zmm24, zmm24, ymmword ptr [rdi+rdx+12256], 0x01
        vmovdqu32 ymm25, ymmword ptr [rdi+rdx+9184]
        vinserti64x4 zmm25, zmm25, ymmword ptr [rdi+rdx+13280], 0x01
        vpunpcklqdq zmm12, zmm24, zmm25
        vpunpckhqdq zmm13, zmm24, zmm25
        vmovdqu32 ymm24, ymmword ptr [rdi+rdx+10208]
        vinserti64x4 zmm24, zmm24, ymmword ptr [rdi+rdx+14304], 0x01
        vmovdqu32 ymm25, ymmword ptr [rdi+rdx+11232]
        vinserti64x4 zmm25, zmm25, ymmword ptr [rdi+rdx+15328], 0x01
        vpunpcklqdq zmm14, zmm24, zmm25
        vpunpckhqdq zmm15, zmm24, zmm25
        prefetcht0 [rdi+rdx+4096]
        prefetcht0 [rdi+rdx+12288]
        prefetcht0 [rdi+rdx+5120]
        prefetcht0 [rdi+rdx+13312]
        prefetcht0 [rdi+rdx+6144]
        prefetcht0 [rdi+rdx+14336]
        prefetcht0 [rdi+rdx+7168]
        prefetcht0 [rdi+rdx+15360]
        vshufps zmm24, zmm8, zmm10, 136
        vshufps zmm30, zmm12, zmm14, 136
        vshufi32x4 zmm28, zmm24, zmm30, 0xdd
        vshufi32x4 zmm24, zmm24, zmm30, 0x88
        vshufps zmm25, zmm8, zmm10, 221
        vshufps zmm30, zmm12, zmm14, 221
        vshufi32x4 zmm29, zmm25, zmm30, 0xdd
        vshufi32x4 zmm25, zmm25, zmm30, 0x88
        vshufps zmm26, zmm9, zmm11, 136
        vshufps zmm8, zmm13, zmm15, 136
        vshufi32x4 zmm30, zmm26, zmm8, 0xdd
        vshufi32x4 zmm26, zmm26, zmm8, 0x88
        vshufps zmm8, zmm9, zmm11, 221
        vshufps zmm10, zmm13, zmm15, 221
        vshufi32x4 zmm27, zmm8, zmm10, 0x88
        vshufi32x4 zmm31, zmm8, zmm10, 0xdd
        mov     qword ptr [rsp+0x1c0], rdi
        mov     qword ptr [rsp+0x1c8], rdx
        vpbroadcastd zmm8, dword ptr [.Lflock_hyb_BLAKE3_IV_0+rip]
        mov     qword ptr [rsp+0x1d0], rsi
        mov     qword ptr [rsp+0x1d8], rcx
        vpbroadcastd zmm9, dword ptr [.Lflock_hyb_BLAKE3_IV_1+rip]
        mov     qword ptr [rsp+0x1e0], rbp
        mov     qword ptr [rsp+0x1e8], r11
        vpbroadcastd zmm10, dword ptr [.Lflock_hyb_BLAKE3_IV_2+rip]
        mov     eax, dword ptr [rsp+0x180]
        mov     ebx, dword ptr [rsp+0x184]
        vpbroadcastd zmm11, dword ptr [.Lflock_hyb_BLAKE3_IV_3+rip]
        mov     ecx, dword ptr [rsp+0x188]
        mov     edx, dword ptr [rsp+0x18c]
        vpbroadcastd zmm14, dword ptr [.Lflock_hyb_BLAKE3_BLOCK_LEN+rip]
        mov     esi, dword ptr [rsp+0x190]
        mov     edi, dword ptr [rsp+0x194]
        vpbroadcastd zmm15, dword ptr [rsp+0x22*0x4]
        mov     ebp, dword ptr [rsp+0x198]
        mov     r8d, dword ptr [rsp+0x19c]
        vpaddd  zmm0, zmm0, zmm16
        mov     r9d, 0x6a09e667
        mov     r10d, 0xbb67ae85
        vpaddd  zmm1, zmm1, zmm18
        mov     dword ptr [rsp+0x200], 0x3c6ef372
        mov     r11d, 0xa54ff53a
        vpaddd  zmm2, zmm2, zmm20
        xor     r12d, r12d
        xor     r13d, r13d
        vpaddd  zmm3, zmm3, zmm22
        mov     r14d, 64
        mov     r15d, dword ptr [rsp+0x88]
        vpaddd  zmm0, zmm0, zmm4
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm1, zmm1, zmm5
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm2, zmm2, zmm6
        add     eax, dword ptr [rsp+0x100]
        add     ebx, dword ptr [rsp+0x108]
        vpaddd  zmm3, zmm3, zmm7
        add     ecx, dword ptr [rsp+0x110]
        add     edx, dword ptr [rsp+0x118]
        vpxord  zmm14, zmm14, zmm2
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        vpxord  zmm15, zmm15, zmm3
        xor     r15d, edx
        ror     r12d, 16
        vprord  zmm12, zmm0, 16
        ror     r13d, 16
        ror     r14d, 16
        vprord  zmm13, zmm1, 16
        ror     r15d, 16
        add     r9d, r12d
        vprord  zmm14, zmm14, 16
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vprord  zmm15, zmm15, 16
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm8, zmm8, zmm12
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm9, zmm9, zmm13
        xor     r8d, r11d
        ror     esi, 12
        vpaddd  zmm10, zmm10, zmm14
        ror     edi, 12
        ror     ebp, 12
        vpaddd  zmm11, zmm11, zmm15
        ror     r8d, 12
        add     eax, esi
        vpxord  zmm4, zmm4, zmm8
        add     ebx, edi
        add     ecx, ebp
        vpxord  zmm5, zmm5, zmm9
        add     edx, r8d
        add     eax, dword ptr [rsp+0x104]
        vpxord  zmm6, zmm6, zmm10
        add     ebx, dword ptr [rsp+0x10c]
        add     ecx, dword ptr [rsp+0x114]
        vpxord  zmm7, zmm7, zmm11
        add     edx, dword ptr [rsp+0x11c]
        xor     r12d, eax
        vprord  zmm4, zmm4, 12
        xor     r13d, ebx
        xor     r14d, ecx
        vprord  zmm5, zmm5, 12
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm6, zmm6, 12
        ror     r14d, 8
        ror     r15d, 8
        vprord  zmm7, zmm7, 12
        add     r9d, r12d
        add     r10d, r13d
        vpaddd  zmm0, zmm0, zmm17
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpaddd  zmm1, zmm1, zmm19
        xor     esi, r9d
        xor     edi, r10d
        vpaddd  zmm2, zmm2, zmm21
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpaddd  zmm3, zmm3, zmm23
        ror     esi, 7
        ror     edi, 7
        vpaddd  zmm0, zmm0, zmm4
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm1, zmm1, zmm5
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm2, zmm2, zmm6
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm3, zmm3, zmm7
        add     eax, dword ptr [rsp+0x120]
        add     ebx, dword ptr [rsp+0x128]
        vpxord  zmm12, zmm12, zmm0
        add     ecx, dword ptr [rsp+0x130]
        add     edx, dword ptr [rsp+0x138]
        vpxord  zmm13, zmm13, zmm1
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm14, zmm14, zmm2
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm15, zmm15, zmm3
        ror     r15d, 16
        ror     r12d, 16
        vprord  zmm12, zmm12, 8
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vprord  zmm13, zmm13, 8
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm14, zmm14, 8
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vprord  zmm15, zmm15, 8
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm8, zmm8, zmm12
        xor     esi, r10d
        ror     edi, 12
        vpaddd  zmm9, zmm9, zmm13
        ror     ebp, 12
        ror     r8d, 12
        vpaddd  zmm10, zmm10, zmm14
        ror     esi, 12
        add     eax, edi
        vpaddd  zmm11, zmm11, zmm15
        add     ebx, ebp
        add     ecx, r8d
        vpxord  zmm4, zmm4, zmm8
        add     edx, esi
        add     eax, dword ptr [rsp+0x124]
        vpxord  zmm5, zmm5, zmm9
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x134]
        vpxord  zmm6, zmm6, zmm10
        add     edx, dword ptr [rsp+0x13c]
        xor     r15d, eax
        vpxord  zmm7, zmm7, zmm11
        xor     r12d, ebx
        xor     r13d, ecx
        vprord  zmm4, zmm4, 7
        xor     r14d, edx
        ror     r15d, 8
        vprord  zmm5, zmm5, 7
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm6, zmm6, 7
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vprord  zmm7, zmm7, 7
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        vpaddd  zmm0, zmm0, zmm24
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpaddd  zmm1, zmm1, zmm26
        xor     r8d, r9d
        xor     esi, r10d
        vpaddd  zmm2, zmm2, zmm28
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm3, zmm3, zmm30
        ror     r8d, 7
        ror     esi, 7
        vpaddd  zmm0, zmm0, zmm5
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm1, zmm1, zmm6
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm2, zmm2, zmm7
        add     eax, dword ptr [rsp+0x108]
        add     ebx, dword ptr [rsp+0x10c]
        vpaddd  zmm3, zmm3, zmm4
        add     ecx, dword ptr [rsp+0x11c]
        add     edx, dword ptr [rsp+0x110]
        vpxord  zmm15, zmm15, zmm0
        xor     r12d, eax
        xor     r13d, ebx
        vpxord  zmm12, zmm12, zmm1
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm13, zmm13, zmm2
        ror     r12d, 16
        ror     r13d, 16
        vpxord  zmm14, zmm14, zmm3
        ror     r14d, 16
        ror     r15d, 16
        vprord  zmm15, zmm15, 16
        add     r9d, r12d
        add     r10d, r13d
        vprord  zmm12, zmm12, 16
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vprord  zmm13, zmm13, 16
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vprord  zmm14, zmm14, 16
        xor     r8d, r11d
        ror     esi, 12
        vpaddd  zmm10, zmm10, zmm15
        ror     edi, 12
        ror     ebp, 12
        vpaddd  zmm11, zmm11, zmm12
        ror     r8d, 12
        add     eax, esi
        vpaddd  zmm8, zmm8, zmm13
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm9, zmm9, zmm14
        add     edx, r8d
        add     eax, dword ptr [rsp+0x118]
        vpxord  zmm5, zmm5, zmm10
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x100]
        vpxord  zmm6, zmm6, zmm11
        add     edx, dword ptr [rsp+0x134]
        xor     r12d, eax
        vpxord  zmm7, zmm7, zmm8
        xor     r13d, ebx
        xor     r14d, ecx
        vpxord  zmm4, zmm4, zmm9
        xor     r15d, edx
        ror     r12d, 8
        vprord  zmm5, zmm5, 12
        ror     r13d, 8
        ror     r14d, 8
        vprord  zmm6, zmm6, 12
        ror     r15d, 8
        add     r9d, r12d
        vprord  zmm7, zmm7, 12
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vprord  zmm4, zmm4, 12
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm0, zmm0, zmm25
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm1, zmm1, zmm27
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        vpaddd  zmm2, zmm2, zmm29
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm3, zmm3, zmm31
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm0, zmm0, zmm5
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm1, zmm1, zmm6
        add     eax, dword ptr [rsp+0x104]
        add     ebx, dword ptr [rsp+0x130]
        vpaddd  zmm2, zmm2, zmm7
        add     ecx, dword ptr [rsp+0x124]
        add     edx, dword ptr [rsp+0x13c]
        vpaddd  zmm3, zmm3, zmm4
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm15, zmm15, zmm0
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm12, zmm12, zmm1
        ror     r15d, 16
        ror     r12d, 16
        vpxord  zmm13, zmm13, zmm2
        ror     r13d, 16
        ror     r14d, 16
        vpxord  zmm14, zmm14, zmm3
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vprord  zmm15, zmm15, 8
        add     r9d, r13d
        add     r10d, r14d
        vprord  zmm12, zmm12, 8
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm13, zmm13, 8
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm14, zmm14, 8
        ror     edi, 12
        ror     ebp, 12
        vpaddd  zmm10, zmm10, zmm15
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        vpaddd  zmm11, zmm11, zmm12
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm8, zmm8, zmm13
        add     edx, esi
        add     eax, dword ptr [rsp+0x12c]
        vpaddd  zmm9, zmm9, zmm14
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x138]
        vpxord  zmm5, zmm5, zmm10
        add     edx, dword ptr [rsp+0x120]
        xor     r15d, eax
        vpxord  zmm6, zmm6, zmm11
        xor     r12d, ebx
        xor     r13d, ecx
        vpxord  zmm7, zmm7, zmm8
        xor     r14d, edx
        ror     r15d, 8
        vpxord  zmm4, zmm4, zmm9
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm5, zmm5, 7
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vprord  zmm6, zmm6, 7
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm7, zmm7, 7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vprord  zmm4, zmm4, 7
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm0, zmm0, zmm18
        xor     esi, r10d
        ror     edi, 7
        vpaddd  zmm1, zmm1, zmm19
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm2, zmm2, zmm23
        ror     esi, 7
        add     eax, esi
        vpaddd  zmm3, zmm3, zmm20
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm0, zmm0, zmm4
        add     eax, dword ptr [rsp+0x10c]
        add     ebx, dword ptr [rsp+0x128]
        vpaddd  zmm1, zmm1, zmm5
        add     ecx, dword ptr [rsp+0x134]
        add     edx, dword ptr [rsp+0x11c]
        vpaddd  zmm2, zmm2, zmm6
        xor     r12d, eax
        xor     r13d, ebx
        vpaddd  zmm3, zmm3, zmm7
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm12, zmm12, zmm0
        ror     r12d, 16
        ror     r13d, 16
        vpxord  zmm13, zmm13, zmm1
        ror     r14d, 16
        ror     r15d, 16
        vpxord  zmm14, zmm14, zmm2
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm15, zmm15, zmm3
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vprord  zmm12, zmm12, 16
        xor     esi, r9d
        xor     edi, r10d
        vprord  zmm13, zmm13, 16
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm14, zmm14, 16
        ror     esi, 12
        ror     edi, 12
        vprord  zmm15, zmm15, 16
        ror     ebp, 12
        ror     r8d, 12
        vpaddd  zmm8, zmm8, zmm12
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm9, zmm9, zmm13
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm10, zmm10, zmm14
        add     eax, dword ptr [rsp+0x110]
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x108]
        vpaddd  zmm11, zmm11, zmm15
        add     edx, dword ptr [rsp+0x138]
        xor     r12d, eax
        vpxord  zmm4, zmm4, zmm8
        xor     r13d, ebx
        xor     r14d, ecx
        vpxord  zmm5, zmm5, zmm9
        xor     r15d, edx
        ror     r12d, 8
        vpxord  zmm6, zmm6, zmm10
        ror     r13d, 8
        ror     r14d, 8
        vpxord  zmm7, zmm7, zmm11
        ror     r15d, 8
        add     r9d, r12d
        vprord  zmm4, zmm4, 12
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vprord  zmm5, zmm5, 12
        add     r11d, r15d
        xor     esi, r9d
        vprord  zmm6, zmm6, 12
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vprord  zmm7, zmm7, 12
        xor     r8d, r11d
        ror     esi, 7
        vpaddd  zmm0, zmm0, zmm22
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm1, zmm1, zmm26
        ror     r8d, 7
        add     eax, edi
        vpaddd  zmm2, zmm2, zmm16
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm3, zmm3, zmm29
        add     edx, esi
        add     eax, dword ptr [rsp+0x118]
        vpaddd  zmm0, zmm0, zmm4
        add     ebx, dword ptr [rsp+0x124]
        add     ecx, dword ptr [rsp+0x12c]
        vpaddd  zmm1, zmm1, zmm5
        add     edx, dword ptr [rsp+0x120]
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm2, zmm2, zmm6
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm3, zmm3, zmm7
        ror     r15d, 16
        ror     r12d, 16
        vpxord  zmm12, zmm12, zmm0
        ror     r13d, 16
        ror     r14d, 16
        vpxord  zmm13, zmm13, zmm1
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm14, zmm14, zmm2
        add     r9d, r13d
        add     r10d, r14d
        vpxord  zmm15, zmm15, zmm3
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm12, zmm12, 8
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm13, zmm13, 8
        ror     edi, 12
        ror     ebp, 12
        vprord  zmm14, zmm14, 8
        ror     r8d, 12
        ror     esi, 12
        vprord  zmm15, zmm15, 8
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm8, zmm8, zmm12
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm9, zmm9, zmm13
        add     eax, dword ptr [rsp+0x114]
        add     ebx, dword ptr [rsp+0x100]
        vpaddd  zmm10, zmm10, zmm14
        add     ecx, dword ptr [rsp+0x13c]
        add     edx, dword ptr [rsp+0x104]
        vpaddd  zmm11, zmm11, zmm15
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm4, zmm4, zmm8
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        vpxord  zmm5, zmm5, zmm9
        ror     r12d, 8
        ror     r13d, 8
        vpxord  zmm6, zmm6, zmm10
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vpxord  zmm7, zmm7, zmm11
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm4, zmm4, 7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vprord  zmm5, zmm5, 7
        xor     ebp, r11d
        xor     r8d, r9d
        vprord  zmm6, zmm6, 7
        xor     esi, r10d
        ror     edi, 7
        vprord  zmm7, zmm7, 7
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm0, zmm0, zmm17
        ror     esi, 7
        add     eax, esi
        vpaddd  zmm1, zmm1, zmm28
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm2, zmm2, zmm25
        add     edx, r8d
        add     eax, dword ptr [rsp+0x128]
        vpaddd  zmm3, zmm3, zmm31
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x138]
        vpaddd  zmm0, zmm0, zmm5
        add     edx, dword ptr [rsp+0x134]
        xor     r12d, eax
        vpaddd  zmm1, zmm1, zmm6
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm2, zmm2, zmm7
        xor     r15d, edx
        ror     r12d, 16
        vpaddd  zmm3, zmm3, zmm4
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        vpxord  zmm15, zmm15, zmm0
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm12, zmm12, zmm1
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm13, zmm13, zmm2
        xor     esi, r9d
        xor     edi, r10d
        vpxord  zmm14, zmm14, zmm3
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm15, zmm15, 16
        ror     esi, 12
        ror     edi, 12
        vprord  zmm12, zmm12, 16
        ror     ebp, 12
        ror     r8d, 12
        vprord  zmm13, zmm13, 16
        add     eax, esi
        add     ebx, edi
        vprord  zmm14, zmm14, 16
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm10, zmm10, zmm15
        add     eax, dword ptr [rsp+0x11c]
        add     ebx, dword ptr [rsp+0x124]
        vpaddd  zmm11, zmm11, zmm12
        add     ecx, dword ptr [rsp+0x10c]
        add     edx, dword ptr [rsp+0x13c]
        vpaddd  zmm8, zmm8, zmm13
        xor     r12d, eax
        xor     r13d, ebx
        vpaddd  zmm9, zmm9, zmm14
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm5, zmm5, zmm10
        ror     r12d, 8
        ror     r13d, 8
        vpxord  zmm6, zmm6, zmm11
        ror     r14d, 8
        ror     r15d, 8
        vpxord  zmm7, zmm7, zmm8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpxord  zmm4, zmm4, zmm9
        add     r11d, r15d
        xor     esi, r9d
        vprord  zmm5, zmm5, 12
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vprord  zmm6, zmm6, 12
        xor     r8d, r11d
        ror     esi, 7
        vprord  zmm7, zmm7, 12
        ror     edi, 7
        ror     ebp, 7
        vprord  zmm4, zmm4, 12
        ror     r8d, 7
        add     eax, edi
        vpaddd  zmm0, zmm0, zmm27
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm1, zmm1, zmm21
        add     edx, esi
        add     eax, dword ptr [rsp+0x110]
        vpaddd  zmm2, zmm2, zmm30
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x114]
        vpaddd  zmm3, zmm3, zmm24
        add     edx, dword ptr [rsp+0x104]
        xor     r15d, eax
        vpaddd  zmm0, zmm0, zmm5
        xor     r12d, ebx
        xor     r13d, ecx
        vpaddd  zmm1, zmm1, zmm6
        xor     r14d, edx
        ror     r15d, 16
        vpaddd  zmm2, zmm2, zmm7
        ror     r12d, 16
        ror     r13d, 16
        vpaddd  zmm3, zmm3, zmm4
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpxord  zmm15, zmm15, zmm0
        add     r11d, r12d
        add     r9d, r13d
        vpxord  zmm12, zmm12, zmm1
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpxord  zmm13, zmm13, zmm2
        xor     r8d, r9d
        xor     esi, r10d
        vpxord  zmm14, zmm14, zmm3
        ror     edi, 12
        ror     ebp, 12
        vprord  zmm15, zmm15, 8
        ror     r8d, 12
        ror     esi, 12
        vprord  zmm12, zmm12, 8
        add     eax, edi
        add     ebx, ebp
        vprord  zmm13, zmm13, 8
        add     ecx, r8d
        add     edx, esi
        vprord  zmm14, zmm14, 8
        add     eax, dword ptr [rsp+0x100]
        add     ebx, dword ptr [rsp+0x108]
        vpaddd  zmm10, zmm10, zmm15
        add     ecx, dword ptr [rsp+0x120]
        add     edx, dword ptr [rsp+0x118]
        vpaddd  zmm11, zmm11, zmm12
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm8, zmm8, zmm13
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm9, zmm9, zmm14
        ror     r15d, 8
        ror     r12d, 8
        vpxord  zmm5, zmm5, zmm10
        ror     r13d, 8
        ror     r14d, 8
        vpxord  zmm6, zmm6, zmm11
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm7, zmm7, zmm8
        add     r9d, r13d
        add     r10d, r14d
        vpxord  zmm4, zmm4, zmm9
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm5, zmm5, 7
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        vprord  zmm6, zmm6, 7
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm7, zmm7, 7
        ror     esi, 7
        add     eax, esi
        vprord  zmm4, zmm4, 7
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm0, zmm0, zmm19
        add     edx, r8d
        add     eax, dword ptr [rsp+0x130]
        vpaddd  zmm1, zmm1, zmm26
        add     ebx, dword ptr [rsp+0x124]
        add     ecx, dword ptr [rsp+0x13c]
        vpaddd  zmm2, zmm2, zmm29
        add     edx, dword ptr [rsp+0x138]
        xor     r12d, eax
        vpaddd  zmm3, zmm3, zmm23
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm0, zmm0, zmm4
        xor     r15d, edx
        ror     r12d, 16
        vpaddd  zmm1, zmm1, zmm5
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm2, zmm2, zmm6
        ror     r15d, 16
        add     r9d, r12d
        vpaddd  zmm3, zmm3, zmm7
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpxord  zmm12, zmm12, zmm0
        add     r11d, r15d
        xor     esi, r9d
        vpxord  zmm13, zmm13, zmm1
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpxord  zmm14, zmm14, zmm2
        xor     r8d, r11d
        ror     esi, 12
        vpxord  zmm15, zmm15, zmm3
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        vprord  zmm12, zmm12, 16
        add     eax, esi
        add     ebx, edi
        vprord  zmm13, zmm13, 16
        add     ecx, ebp
        add     edx, r8d
        vprord  zmm14, zmm14, 16
        add     eax, dword ptr [rsp+0x134]
        add     ebx, dword ptr [rsp+0x12c]
        vprord  zmm15, zmm15, 16
        add     ecx, dword ptr [rsp+0x128]
        add     edx, dword ptr [rsp+0x120]
        vpaddd  zmm8, zmm8, zmm12
        xor     r12d, eax
        xor     r13d, ebx
        vpaddd  zmm9, zmm9, zmm13
        xor     r14d, ecx
        xor     r15d, edx
        vpaddd  zmm10, zmm10, zmm14
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm11, zmm11, zmm15
        ror     r14d, 8
        ror     r15d, 8
        vpxord  zmm4, zmm4, zmm8
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm5, zmm5, zmm9
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm6, zmm6, zmm10
        xor     esi, r9d
        xor     edi, r10d
        vpxord  zmm7, zmm7, zmm11
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm4, zmm4, 12
        ror     esi, 7
        ror     edi, 7
        vprord  zmm5, zmm5, 12
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm6, zmm6, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        vprord  zmm7, zmm7, 12
        add     edx, esi
        add     eax, dword ptr [rsp+0x11c]
        vpaddd  zmm0, zmm0, zmm20
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x100]
        vpaddd  zmm1, zmm1, zmm28
        add     edx, dword ptr [rsp+0x118]
        xor     r15d, eax
        vpaddd  zmm2, zmm2, zmm18
        xor     r12d, ebx
        xor     r13d, ecx
        vpaddd  zmm3, zmm3, zmm30
        xor     r14d, edx
        ror     r15d, 16
        vpaddd  zmm0, zmm0, zmm4
        ror     r12d, 16
        ror     r13d, 16
        vpaddd  zmm1, zmm1, zmm5
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm2, zmm2, zmm6
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm3, zmm3, zmm7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpxord  zmm12, zmm12, zmm0
        xor     ebp, r11d
        xor     r8d, r9d
        vpxord  zmm13, zmm13, zmm1
        xor     esi, r10d
        ror     edi, 12
        vpxord  zmm14, zmm14, zmm2
        ror     ebp, 12
        ror     r8d, 12
        vpxord  zmm15, zmm15, zmm3
        ror     esi, 12
        add     eax, edi
        vprord  zmm12, zmm12, 8
        add     ebx, ebp
        add     ecx, r8d
        vprord  zmm13, zmm13, 8
        add     edx, esi
        add     eax, dword ptr [rsp+0x108]
        add     ebx, dword ptr [rsp+0x10c]
        vprord  zmm14, zmm14, 8
        add     ecx, dword ptr [rsp+0x104]
        add     edx, dword ptr [rsp+0x110]
        vprord  zmm15, zmm15, 8
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm8, zmm8, zmm12
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm9, zmm9, zmm13
        ror     r15d, 8
        ror     r12d, 8
        vpaddd  zmm10, zmm10, zmm14
        ror     r13d, 8
        ror     r14d, 8
        vpaddd  zmm11, zmm11, zmm15
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm4, zmm4, zmm8
        add     r9d, r13d
        add     r10d, r14d
        vpxord  zmm5, zmm5, zmm9
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpxord  zmm6, zmm6, zmm10
        xor     r8d, r9d
        xor     esi, r10d
        vpxord  zmm7, zmm7, zmm11
        ror     edi, 7
        ror     ebp, 7
        vprord  zmm4, zmm4, 7
        ror     r8d, 7
        ror     esi, 7
        vprord  zmm5, zmm5, 7
        add     eax, esi
        add     ebx, edi
        vprord  zmm6, zmm6, 7
        add     ecx, ebp
        add     edx, r8d
        vprord  zmm7, zmm7, 7
        add     eax, dword ptr [rsp+0x124]
        add     ebx, dword ptr [rsp+0x12c]
        vpaddd  zmm0, zmm0, zmm22
        add     ecx, dword ptr [rsp+0x120]
        add     edx, dword ptr [rsp+0x13c]
        xor     r12d, eax
        vpaddd  zmm1, zmm1, zmm25
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm2, zmm2, zmm27
        xor     r15d, edx
        ror     r12d, 16
        vpaddd  zmm3, zmm3, zmm24
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm0, zmm0, zmm5
        ror     r15d, 16
        add     r9d, r12d
        vpaddd  zmm1, zmm1, zmm6
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm2, zmm2, zmm7
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm3, zmm3, zmm4
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpxord  zmm15, zmm15, zmm0
        xor     r8d, r11d
        ror     esi, 12
        vpxord  zmm12, zmm12, zmm1
        ror     edi, 12
        ror     ebp, 12
        vpxord  zmm13, zmm13, zmm2
        ror     r8d, 12
        add     eax, esi
        vpxord  zmm14, zmm14, zmm3
        add     ebx, edi
        add     ecx, ebp
        vprord  zmm15, zmm15, 16
        add     edx, r8d
        add     eax, dword ptr [rsp+0x138]
        vprord  zmm12, zmm12, 16
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x130]
        vprord  zmm13, zmm13, 16
        add     edx, dword ptr [rsp+0x104]
        xor     r12d, eax
        vprord  zmm14, zmm14, 16
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        vpaddd  zmm10, zmm10, zmm15
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm11, zmm11, zmm12
        ror     r14d, 8
        ror     r15d, 8
        vpaddd  zmm8, zmm8, zmm13
        add     r9d, r12d
        add     r10d, r13d
        vpaddd  zmm9, zmm9, zmm14
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm5, zmm5, zmm10
        xor     esi, r9d
        xor     edi, r10d
        vpxord  zmm6, zmm6, zmm11
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpxord  zmm7, zmm7, zmm8
        ror     esi, 7
        ror     edi, 7
        vpxord  zmm4, zmm4, zmm9
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm5, zmm5, 12
        add     eax, edi
        add     ebx, ebp
        vprord  zmm6, zmm6, 12
        add     ecx, r8d
        add     edx, esi
        vprord  zmm7, zmm7, 12
        add     eax, dword ptr [rsp+0x134]
        add     ebx, dword ptr [rsp+0x100]
        vprord  zmm4, zmm4, 12
        add     ecx, dword ptr [rsp+0x108]
        add     edx, dword ptr [rsp+0x110]
        vpaddd  zmm0, zmm0, zmm21
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm1, zmm1, zmm16
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm2, zmm2, zmm31
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        vpaddd  zmm3, zmm3, zmm17
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm0, zmm0, zmm5
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm1, zmm1, zmm6
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm2, zmm2, zmm7
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm3, zmm3, zmm4
        xor     esi, r10d
        ror     edi, 12
        vpxord  zmm15, zmm15, zmm0
        ror     ebp, 12
        ror     r8d, 12
        vpxord  zmm12, zmm12, zmm1
        ror     esi, 12
        add     eax, edi
        vpxord  zmm13, zmm13, zmm2
        add     ebx, ebp
        add     ecx, r8d
        vpxord  zmm14, zmm14, zmm3
        add     edx, esi
        add     eax, dword ptr [rsp+0x10c]
        vprord  zmm15, zmm15, 8
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x118]
        vprord  zmm12, zmm12, 8
        add     edx, dword ptr [rsp+0x11c]
        xor     r15d, eax
        vprord  zmm13, zmm13, 8
        xor     r12d, ebx
        xor     r13d, ecx
        vprord  zmm14, zmm14, 8
        xor     r14d, edx
        ror     r15d, 8
        vpaddd  zmm10, zmm10, zmm15
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm11, zmm11, zmm12
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpaddd  zmm8, zmm8, zmm13
        add     r9d, r13d
        add     r10d, r14d
        vpaddd  zmm9, zmm9, zmm14
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpxord  zmm5, zmm5, zmm10
        xor     r8d, r9d
        xor     esi, r10d
        vpxord  zmm6, zmm6, zmm11
        ror     edi, 7
        ror     ebp, 7
        vpxord  zmm7, zmm7, zmm8
        ror     r8d, 7
        ror     esi, 7
        vpxord  zmm4, zmm4, zmm9
        add     eax, esi
        add     ebx, edi
        vprord  zmm5, zmm5, 7
        add     ecx, ebp
        add     edx, r8d
        vprord  zmm6, zmm6, 7
        add     eax, dword ptr [rsp+0x12c]
        add     ebx, dword ptr [rsp+0x114]
        vprord  zmm7, zmm7, 7
        add     ecx, dword ptr [rsp+0x104]
        add     edx, dword ptr [rsp+0x120]
        vprord  zmm4, zmm4, 7
        xor     r12d, eax
        xor     r13d, ebx
        vpaddd  zmm0, zmm0, zmm26
        xor     r14d, ecx
        xor     r15d, edx
        vpaddd  zmm1, zmm1, zmm28
        ror     r12d, 16
        ror     r13d, 16
        vpaddd  zmm2, zmm2, zmm30
        ror     r14d, 16
        ror     r15d, 16
        vpaddd  zmm3, zmm3, zmm29
        add     r9d, r12d
        add     r10d, r13d
        vpaddd  zmm0, zmm0, zmm4
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm1, zmm1, zmm5
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm2, zmm2, zmm6
        xor     r8d, r11d
        ror     esi, 12
        vpaddd  zmm3, zmm3, zmm7
        ror     edi, 12
        ror     ebp, 12
        vpxord  zmm12, zmm12, zmm0
        ror     r8d, 12
        add     eax, esi
        vpxord  zmm13, zmm13, zmm1
        add     ebx, edi
        add     ecx, ebp
        vpxord  zmm14, zmm14, zmm2
        add     edx, r8d
        add     eax, dword ptr [rsp+0x13c]
        vpxord  zmm15, zmm15, zmm3
        add     ebx, dword ptr [rsp+0x100]
        add     ecx, dword ptr [rsp+0x124]
        vprord  zmm12, zmm12, 16
        add     edx, dword ptr [rsp+0x118]
        xor     r12d, eax
        vprord  zmm13, zmm13, 16
        xor     r13d, ebx
        xor     r14d, ecx
        vprord  zmm14, zmm14, 16
        xor     r15d, edx
        ror     r12d, 8
        vprord  zmm15, zmm15, 16
        ror     r13d, 8
        ror     r14d, 8
        vpaddd  zmm8, zmm8, zmm12
        ror     r15d, 8
        add     r9d, r12d
        vpaddd  zmm9, zmm9, zmm13
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm10, zmm10, zmm14
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm11, zmm11, zmm15
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpxord  zmm4, zmm4, zmm8
        ror     esi, 7
        ror     edi, 7
        vpxord  zmm5, zmm5, zmm9
        ror     ebp, 7
        ror     r8d, 7
        vpxord  zmm6, zmm6, zmm10
        add     eax, edi
        add     ebx, ebp
        vpxord  zmm7, zmm7, zmm11
        add     ecx, r8d
        add     edx, esi
        vprord  zmm4, zmm4, 12
        add     eax, dword ptr [rsp+0x138]
        add     ebx, dword ptr [rsp+0x108]
        vprord  zmm5, zmm5, 12
        add     ecx, dword ptr [rsp+0x10c]
        add     edx, dword ptr [rsp+0x11c]
        vprord  zmm6, zmm6, 12
        xor     r15d, eax
        xor     r12d, ebx
        vprord  zmm7, zmm7, 12
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm0, zmm0, zmm23
        ror     r15d, 16
        ror     r12d, 16
        vpaddd  zmm1, zmm1, zmm25
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm2, zmm2, zmm19
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpaddd  zmm3, zmm3, zmm31
        add     r9d, r13d
        add     r10d, r14d
        vpaddd  zmm0, zmm0, zmm4
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpaddd  zmm1, zmm1, zmm5
        xor     r8d, r9d
        xor     esi, r10d
        vpaddd  zmm2, zmm2, zmm6
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        vpaddd  zmm3, zmm3, zmm7
        ror     esi, 12
        add     eax, edi
        vpxord  zmm12, zmm12, zmm0
        add     ebx, ebp
        add     ecx, r8d
        vpxord  zmm13, zmm13, zmm1
        add     edx, esi
        add     eax, dword ptr [rsp+0x128]
        vpxord  zmm14, zmm14, zmm2
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x110]
        vpxord  zmm15, zmm15, zmm3
        add     edx, dword ptr [rsp+0x134]
        xor     r15d, eax
        vprord  zmm12, zmm12, 8
        xor     r12d, ebx
        xor     r13d, ecx
        vprord  zmm13, zmm13, 8
        xor     r14d, edx
        ror     r15d, 8
        vprord  zmm14, zmm14, 8
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm15, zmm15, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm8, zmm8, zmm12
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm9, zmm9, zmm13
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm10, zmm10, zmm14
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm11, zmm11, zmm15
        xor     esi, r10d
        ror     edi, 7
        vpxord  zmm4, zmm4, zmm8
        ror     ebp, 7
        ror     r8d, 7
        vpxord  zmm5, zmm5, zmm9
        ror     esi, 7
        xor     eax, r9d
        xor     ebx, r10d
        vpxord  zmm6, zmm6, zmm10
        xor     ecx, dword ptr [rsp+0x200]
        xor     edx, r11d
        vpxord  zmm7, zmm7, zmm11
        xor     esi, r12d
        xor     edi, r13d
        vprord  zmm4, zmm4, 7
        xor     ebp, r14d
        xor     r8d, r15d
        vprord  zmm5, zmm5, 7
        mov     dword ptr [rsp+0x180], eax
        mov     dword ptr [rsp+0x184], ebx
        vprord  zmm6, zmm6, 7
        mov     dword ptr [rsp+0x188], ecx
        mov     dword ptr [rsp+0x18c], edx
        vprord  zmm7, zmm7, 7
        mov     dword ptr [rsp+0x190], esi
        mov     dword ptr [rsp+0x194], edi
        vpaddd  zmm0, zmm0, zmm20
        mov     dword ptr [rsp+0x198], ebp
        mov     dword ptr [rsp+0x19c], r8d
        vpaddd  zmm1, zmm1, zmm27
        mov     eax, dword ptr [rsp+0x1a0]
        mov     ebx, dword ptr [rsp+0x1a4]
        vpaddd  zmm2, zmm2, zmm21
        mov     ecx, dword ptr [rsp+0x1a8]
        mov     edx, dword ptr [rsp+0x1ac]
        vpaddd  zmm3, zmm3, zmm17
        mov     esi, dword ptr [rsp+0x1b0]
        mov     edi, dword ptr [rsp+0x1b4]
        vpaddd  zmm0, zmm0, zmm5
        mov     ebp, dword ptr [rsp+0x1b8]
        mov     r8d, dword ptr [rsp+0x1bc]
        vpaddd  zmm1, zmm1, zmm6
        mov     r9d, 0x6a09e667
        mov     r10d, 0xbb67ae85
        vpaddd  zmm2, zmm2, zmm7
        mov     dword ptr [rsp+0x200], 0x3c6ef372
        mov     r11d, 0xa54ff53a
        vpaddd  zmm3, zmm3, zmm4
        xor     r12d, r12d
        xor     r13d, r13d
        vpxord  zmm15, zmm15, zmm0
        mov     r14d, 64
        mov     r15d, dword ptr [rsp+0x88]
        add     eax, esi
        vpxord  zmm12, zmm12, zmm1
        add     ebx, edi
        add     ecx, ebp
        vpxord  zmm13, zmm13, zmm2
        add     edx, r8d
        add     eax, dword ptr [rsp+0x140]
        vpxord  zmm14, zmm14, zmm3
        add     ebx, dword ptr [rsp+0x148]
        add     ecx, dword ptr [rsp+0x150]
        vprord  zmm15, zmm15, 16
        add     edx, dword ptr [rsp+0x158]
        xor     r12d, eax
        vprord  zmm12, zmm12, 16
        xor     r13d, ebx
        xor     r14d, ecx
        vprord  zmm13, zmm13, 16
        xor     r15d, edx
        ror     r12d, 16
        vprord  zmm14, zmm14, 16
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm10, zmm10, zmm15
        ror     r15d, 16
        add     r9d, r12d
        vpaddd  zmm11, zmm11, zmm12
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm8, zmm8, zmm13
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm9, zmm9, zmm14
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpxord  zmm5, zmm5, zmm10
        xor     r8d, r11d
        ror     esi, 12
        vpxord  zmm6, zmm6, zmm11
        ror     edi, 12
        ror     ebp, 12
        vpxord  zmm7, zmm7, zmm8
        ror     r8d, 12
        add     eax, esi
        vpxord  zmm4, zmm4, zmm9
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        vprord  zmm5, zmm5, 12
        add     eax, dword ptr [rsp+0x144]
        add     ebx, dword ptr [rsp+0x14c]
        vprord  zmm6, zmm6, 12
        add     ecx, dword ptr [rsp+0x154]
        add     edx, dword ptr [rsp+0x15c]
        vprord  zmm7, zmm7, 12
        xor     r12d, eax
        xor     r13d, ebx
        vprord  zmm4, zmm4, 12
        xor     r14d, ecx
        xor     r15d, edx
        vpaddd  zmm0, zmm0, zmm16
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm1, zmm1, zmm18
        ror     r14d, 8
        ror     r15d, 8
        vpaddd  zmm2, zmm2, zmm24
        add     r9d, r12d
        add     r10d, r13d
        vpaddd  zmm3, zmm3, zmm22
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpaddd  zmm0, zmm0, zmm5
        xor     esi, r9d
        xor     edi, r10d
        vpaddd  zmm1, zmm1, zmm6
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpaddd  zmm2, zmm2, zmm7
        ror     esi, 7
        ror     edi, 7
        vpaddd  zmm3, zmm3, zmm4
        ror     ebp, 7
        ror     r8d, 7
        vpxord  zmm15, zmm15, zmm0
        add     eax, edi
        add     ebx, ebp
        vpxord  zmm12, zmm12, zmm1
        add     ecx, r8d
        add     edx, esi
        vpxord  zmm13, zmm13, zmm2
        add     eax, dword ptr [rsp+0x160]
        add     ebx, dword ptr [rsp+0x168]
        add     ecx, dword ptr [rsp+0x170]
        vpxord  zmm14, zmm14, zmm3
        add     edx, dword ptr [rsp+0x178]
        xor     r15d, eax
        vprord  zmm15, zmm15, 8
        xor     r12d, ebx
        xor     r13d, ecx
        vprord  zmm12, zmm12, 8
        xor     r14d, edx
        ror     r15d, 16
        vprord  zmm13, zmm13, 8
        ror     r12d, 16
        ror     r13d, 16
        vprord  zmm14, zmm14, 8
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm10, zmm10, zmm15
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm11, zmm11, zmm12
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm8, zmm8, zmm13
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm9, zmm9, zmm14
        xor     esi, r10d
        ror     edi, 12
        vpxord  zmm5, zmm5, zmm10
        ror     ebp, 12
        ror     r8d, 12
        vpxord  zmm6, zmm6, zmm11
        ror     esi, 12
        add     eax, edi
        vpxord  zmm7, zmm7, zmm8
        add     ebx, ebp
        add     ecx, r8d
        vpxord  zmm4, zmm4, zmm9
        add     edx, esi
        add     eax, dword ptr [rsp+0x164]
        vprord  zmm5, zmm5, 7
        add     ebx, dword ptr [rsp+0x16c]
        add     ecx, dword ptr [rsp+0x174]
        vprord  zmm6, zmm6, 7
        add     edx, dword ptr [rsp+0x17c]
        xor     r15d, eax
        xor     r12d, ebx
        vprord  zmm7, zmm7, 7
        xor     r13d, ecx
        xor     r14d, edx
        vprord  zmm4, zmm4, 7
        ror     r15d, 8
        ror     r12d, 8
        vpaddd  zmm0, zmm0, zmm28
        ror     r13d, 8
        ror     r14d, 8
        vpaddd  zmm1, zmm1, zmm25
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpaddd  zmm2, zmm2, zmm31
        add     r9d, r13d
        add     r10d, r14d
        vpaddd  zmm3, zmm3, zmm30
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpaddd  zmm0, zmm0, zmm4
        xor     r8d, r9d
        xor     esi, r10d
        vpaddd  zmm1, zmm1, zmm5
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm2, zmm2, zmm6
        ror     r8d, 7
        ror     esi, 7
        vpaddd  zmm3, zmm3, zmm7
        add     eax, esi
        add     ebx, edi
        vpxord  zmm12, zmm12, zmm0
        add     ecx, ebp
        add     edx, r8d
        vpxord  zmm13, zmm13, zmm1
        add     eax, dword ptr [rsp+0x148]
        add     ebx, dword ptr [rsp+0x14c]
        vpxord  zmm14, zmm14, zmm2
        add     ecx, dword ptr [rsp+0x15c]
        add     edx, dword ptr [rsp+0x150]
        vpxord  zmm15, zmm15, zmm3
        xor     r12d, eax
        xor     r13d, ebx
        vprord  zmm12, zmm12, 16
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        vprord  zmm13, zmm13, 16
        ror     r13d, 16
        ror     r14d, 16
        vprord  zmm14, zmm14, 16
        ror     r15d, 16
        add     r9d, r12d
        vprord  zmm15, zmm15, 16
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm8, zmm8, zmm12
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm9, zmm9, zmm13
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm10, zmm10, zmm14
        xor     r8d, r11d
        ror     esi, 12
        vpaddd  zmm11, zmm11, zmm15
        ror     edi, 12
        ror     ebp, 12
        vpxord  zmm4, zmm4, zmm8
        ror     r8d, 12
        add     eax, esi
        vpxord  zmm5, zmm5, zmm9
        add     ebx, edi
        add     ecx, ebp
        vpxord  zmm6, zmm6, zmm10
        add     edx, r8d
        add     eax, dword ptr [rsp+0x158]
        vpxord  zmm7, zmm7, zmm11
        add     ebx, dword ptr [rsp+0x168]
        add     ecx, dword ptr [rsp+0x140]
        vprord  zmm4, zmm4, 12
        add     edx, dword ptr [rsp+0x174]
        xor     r12d, eax
        vprord  zmm5, zmm5, 12
        xor     r13d, ebx
        xor     r14d, ecx
        vprord  zmm6, zmm6, 12
        xor     r15d, edx
        ror     r12d, 8
        vprord  zmm7, zmm7, 12
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        vpaddd  zmm0, zmm0, zmm29
        add     r9d, r12d
        add     r10d, r13d
        vpaddd  zmm1, zmm1, zmm27
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpaddd  zmm2, zmm2, zmm26
        xor     esi, r9d
        xor     edi, r10d
        vpaddd  zmm3, zmm3, zmm24
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpaddd  zmm0, zmm0, zmm4
        ror     esi, 7
        ror     edi, 7
        vpaddd  zmm1, zmm1, zmm5
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm2, zmm2, zmm6
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm3, zmm3, zmm7
        add     ecx, r8d
        add     edx, esi
        vpxord  zmm12, zmm12, zmm0
        add     eax, dword ptr [rsp+0x144]
        add     ebx, dword ptr [rsp+0x170]
        vpxord  zmm13, zmm13, zmm1
        add     ecx, dword ptr [rsp+0x164]
        add     edx, dword ptr [rsp+0x17c]
        vpxord  zmm14, zmm14, zmm2
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm15, zmm15, zmm3
        xor     r13d, ecx
        xor     r14d, edx
        vprord  zmm12, zmm12, 8
        ror     r15d, 16
        ror     r12d, 16
        vprord  zmm13, zmm13, 8
        ror     r13d, 16
        ror     r14d, 16
        vprord  zmm14, zmm14, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm15, zmm15, 8
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm8, zmm8, zmm12
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm9, zmm9, zmm13
        xor     esi, r10d
        ror     edi, 12
        vpaddd  zmm10, zmm10, zmm14
        ror     ebp, 12
        ror     r8d, 12
        vpaddd  zmm11, zmm11, zmm15
        ror     esi, 12
        add     eax, edi
        vpxord  zmm4, zmm4, zmm8
        add     ebx, ebp
        add     ecx, r8d
        vpxord  zmm5, zmm5, zmm9
        add     edx, esi
        add     eax, dword ptr [rsp+0x16c]
        vpxord  zmm6, zmm6, zmm10
        add     ebx, dword ptr [rsp+0x154]
        add     ecx, dword ptr [rsp+0x178]
        vpxord  zmm7, zmm7, zmm11
        add     edx, dword ptr [rsp+0x160]
        xor     r15d, eax
        vprord  zmm4, zmm4, 7
        xor     r12d, ebx
        xor     r13d, ecx
        vprord  zmm5, zmm5, 7
        xor     r14d, edx
        ror     r15d, 8
        vprord  zmm6, zmm6, 7
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm7, zmm7, 7
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm0, zmm0, zmm23
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm1, zmm1, zmm21
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpaddd  zmm2, zmm2, zmm16
        xor     r8d, r9d
        xor     esi, r10d
        vpaddd  zmm3, zmm3, zmm22
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm0, zmm0, zmm5
        ror     r8d, 7
        ror     esi, 7
        vpaddd  zmm1, zmm1, zmm6
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm2, zmm2, zmm7
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm3, zmm3, zmm4
        add     eax, dword ptr [rsp+0x14c]
        add     ebx, dword ptr [rsp+0x168]
        vpxord  zmm15, zmm15, zmm0
        add     ecx, dword ptr [rsp+0x174]
        add     edx, dword ptr [rsp+0x15c]
        vpxord  zmm12, zmm12, zmm1
        xor     r12d, eax
        xor     r13d, ebx
        vpxord  zmm13, zmm13, zmm2
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm14, zmm14, zmm3
        ror     r12d, 16
        ror     r13d, 16
        vprord  zmm15, zmm15, 16
        ror     r14d, 16
        ror     r15d, 16
        vprord  zmm12, zmm12, 16
        add     r9d, r12d
        add     r10d, r13d
        vprord  zmm13, zmm13, 16
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vprord  zmm14, zmm14, 16
        xor     esi, r9d
        xor     edi, r10d
        vpaddd  zmm10, zmm10, zmm15
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        vpaddd  zmm11, zmm11, zmm12
        ror     edi, 12
        ror     ebp, 12
        vpaddd  zmm8, zmm8, zmm13
        ror     r8d, 12
        add     eax, esi
        vpaddd  zmm9, zmm9, zmm14
        add     ebx, edi
        add     ecx, ebp
        vpxord  zmm5, zmm5, zmm10
        add     edx, r8d
        add     eax, dword ptr [rsp+0x150]
        vpxord  zmm6, zmm6, zmm11
        add     ebx, dword ptr [rsp+0x170]
        add     ecx, dword ptr [rsp+0x148]
        vpxord  zmm7, zmm7, zmm8
        add     edx, dword ptr [rsp+0x178]
        xor     r12d, eax
        vpxord  zmm4, zmm4, zmm9
        xor     r13d, ebx
        xor     r14d, ecx
        vprord  zmm5, zmm5, 12
        xor     r15d, edx
        ror     r12d, 8
        vprord  zmm6, zmm6, 12
        ror     r13d, 8
        ror     r14d, 8
        vprord  zmm7, zmm7, 12
        ror     r15d, 8
        add     r9d, r12d
        vprord  zmm4, zmm4, 12
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm0, zmm0, zmm18
        add     r11d, r15d
        xor     esi, r9d
        vpaddd  zmm1, zmm1, zmm19
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm2, zmm2, zmm17
        xor     r8d, r11d
        ror     esi, 7
        vpaddd  zmm3, zmm3, zmm20
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm0, zmm0, zmm5
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm1, zmm1, zmm6
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm2, zmm2, zmm7
        add     eax, dword ptr [rsp+0x158]
        add     ebx, dword ptr [rsp+0x164]
        vpaddd  zmm3, zmm3, zmm4
        add     ecx, dword ptr [rsp+0x16c]
        add     edx, dword ptr [rsp+0x160]
        vpxord  zmm15, zmm15, zmm0
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm12, zmm12, zmm1
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm13, zmm13, zmm2
        ror     r15d, 16
        ror     r12d, 16
        vpxord  zmm14, zmm14, zmm3
        ror     r13d, 16
        ror     r14d, 16
        vprord  zmm15, zmm15, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vprord  zmm12, zmm12, 8
        add     r9d, r13d
        add     r10d, r14d
        vprord  zmm13, zmm13, 8
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm14, zmm14, 8
        xor     r8d, r9d
        xor     esi, r10d
        vpaddd  zmm10, zmm10, zmm15
        ror     edi, 12
        ror     ebp, 12
        vpaddd  zmm11, zmm11, zmm12
        ror     r8d, 12
        ror     esi, 12
        vpaddd  zmm8, zmm8, zmm13
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm9, zmm9, zmm14
        add     edx, esi
        add     eax, dword ptr [rsp+0x154]
        vpxord  zmm5, zmm5, zmm10
        add     ebx, dword ptr [rsp+0x140]
        add     ecx, dword ptr [rsp+0x17c]
        vpxord  zmm6, zmm6, zmm11
        add     edx, dword ptr [rsp+0x144]
        xor     r15d, eax
        vpxord  zmm7, zmm7, zmm8
        xor     r12d, ebx
        xor     r13d, ecx
        vpxord  zmm4, zmm4, zmm9
        xor     r14d, edx
        ror     r15d, 8
        vprord  zmm5, zmm5, 7
        ror     r12d, 8
        ror     r13d, 8
        vprord  zmm6, zmm6, 7
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vprord  zmm7, zmm7, 7
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm4, zmm4, 7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm0, zmm0, zmm25
        xor     ebp, r11d
        xor     r8d, r9d
        vpaddd  zmm1, zmm1, zmm27
        xor     esi, r10d
        ror     edi, 7
        vpaddd  zmm2, zmm2, zmm24
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm3, zmm3, zmm31
        ror     esi, 7
        add     eax, esi
        vpaddd  zmm0, zmm0, zmm4
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm1, zmm1, zmm5
        add     edx, r8d
        add     eax, dword ptr [rsp+0x168]
        add     ebx, dword ptr [rsp+0x170]
        vpaddd  zmm2, zmm2, zmm6
        add     ecx, dword ptr [rsp+0x178]
        add     edx, dword ptr [rsp+0x174]
        vpaddd  zmm3, zmm3, zmm7
        xor     r12d, eax
        xor     r13d, ebx
        vpxord  zmm12, zmm12, zmm0
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm13, zmm13, zmm1
        ror     r12d, 16
        ror     r13d, 16
        vpxord  zmm14, zmm14, zmm2
        ror     r14d, 16
        ror     r15d, 16
        vpxord  zmm15, zmm15, zmm3
        add     r9d, r12d
        add     r10d, r13d
        vprord  zmm12, zmm12, 16
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vprord  zmm13, zmm13, 16
        xor     esi, r9d
        xor     edi, r10d
        vprord  zmm14, zmm14, 16
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm15, zmm15, 16
        ror     esi, 12
        ror     edi, 12
        vpaddd  zmm8, zmm8, zmm12
        ror     ebp, 12
        ror     r8d, 12
        vpaddd  zmm9, zmm9, zmm13
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm10, zmm10, zmm14
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm11, zmm11, zmm15
        add     eax, dword ptr [rsp+0x15c]
        add     ebx, dword ptr [rsp+0x164]
        vpxord  zmm4, zmm4, zmm8
        add     ecx, dword ptr [rsp+0x14c]
        add     edx, dword ptr [rsp+0x17c]
        xor     r12d, eax
        vpxord  zmm5, zmm5, zmm9
        xor     r13d, ebx
        xor     r14d, ecx
        vpxord  zmm6, zmm6, zmm10
        xor     r15d, edx
        ror     r12d, 8
        vpxord  zmm7, zmm7, zmm11
        ror     r13d, 8
        ror     r14d, 8
        vprord  zmm4, zmm4, 12
        ror     r15d, 8
        add     r9d, r12d
        vprord  zmm5, zmm5, 12
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vprord  zmm6, zmm6, 12
        add     r11d, r15d
        xor     esi, r9d
        vprord  zmm7, zmm7, 12
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpaddd  zmm0, zmm0, zmm30
        xor     r8d, r11d
        ror     esi, 7
        vpaddd  zmm1, zmm1, zmm21
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm2, zmm2, zmm28
        ror     r8d, 7
        add     eax, edi
        vpaddd  zmm3, zmm3, zmm17
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm0, zmm0, zmm4
        add     edx, esi
        add     eax, dword ptr [rsp+0x150]
        vpaddd  zmm1, zmm1, zmm5
        add     ebx, dword ptr [rsp+0x16c]
        add     ecx, dword ptr [rsp+0x154]
        vpaddd  zmm2, zmm2, zmm6
        add     edx, dword ptr [rsp+0x144]
        xor     r15d, eax
        vpaddd  zmm3, zmm3, zmm7
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm12, zmm12, zmm0
        ror     r15d, 16
        ror     r12d, 16
        vpxord  zmm13, zmm13, zmm1
        ror     r13d, 16
        ror     r14d, 16
        vpxord  zmm14, zmm14, zmm2
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm15, zmm15, zmm3
        add     r9d, r13d
        add     r10d, r14d
        vprord  zmm12, zmm12, 8
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm13, zmm13, 8
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm14, zmm14, 8
        ror     edi, 12
        ror     ebp, 12
        vprord  zmm15, zmm15, 8
        ror     r8d, 12
        ror     esi, 12
        vpaddd  zmm8, zmm8, zmm12
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm9, zmm9, zmm13
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm10, zmm10, zmm14
        add     eax, dword ptr [rsp+0x140]
        add     ebx, dword ptr [rsp+0x148]
        vpaddd  zmm11, zmm11, zmm15
        add     ecx, dword ptr [rsp+0x160]
        add     edx, dword ptr [rsp+0x158]
        vpxord  zmm4, zmm4, zmm8
        xor     r15d, eax
        xor     r12d, ebx
        vpxord  zmm5, zmm5, zmm9
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm6, zmm6, zmm10
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        vpxord  zmm7, zmm7, zmm11
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vprord  zmm4, zmm4, 7
        add     r11d, r12d
        add     r9d, r13d
        vprord  zmm5, zmm5, 7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vprord  zmm6, zmm6, 7
        xor     ebp, r11d
        xor     r8d, r9d
        vprord  zmm7, zmm7, 7
        xor     esi, r10d
        ror     edi, 7
        vpaddd  zmm0, zmm0, zmm29
        ror     ebp, 7
        ror     r8d, 7
        vpaddd  zmm1, zmm1, zmm16
        ror     esi, 7
        add     eax, esi
        vpaddd  zmm2, zmm2, zmm18
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm3, zmm3, zmm20
        add     edx, r8d
        add     eax, dword ptr [rsp+0x170]
        vpaddd  zmm0, zmm0, zmm5
        add     ebx, dword ptr [rsp+0x164]
        add     ecx, dword ptr [rsp+0x17c]
        vpaddd  zmm1, zmm1, zmm6
        add     edx, dword ptr [rsp+0x178]
        xor     r12d, eax
        vpaddd  zmm2, zmm2, zmm7
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm3, zmm3, zmm4
        xor     r15d, edx
        ror     r12d, 16
        vpxord  zmm15, zmm15, zmm0
        ror     r13d, 16
        ror     r14d, 16
        vpxord  zmm12, zmm12, zmm1
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm13, zmm13, zmm2
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm14, zmm14, zmm3
        xor     esi, r9d
        xor     edi, r10d
        vprord  zmm15, zmm15, 16
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm12, zmm12, 16
        ror     esi, 12
        ror     edi, 12
        vprord  zmm13, zmm13, 16
        ror     ebp, 12
        ror     r8d, 12
        vprord  zmm14, zmm14, 16
        add     eax, esi
        add     ebx, edi
        vpaddd  zmm10, zmm10, zmm15
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm11, zmm11, zmm12
        add     eax, dword ptr [rsp+0x174]
        add     ebx, dword ptr [rsp+0x16c]
        vpaddd  zmm8, zmm8, zmm13
        add     ecx, dword ptr [rsp+0x168]
        add     edx, dword ptr [rsp+0x160]
        vpaddd  zmm9, zmm9, zmm14
        xor     r12d, eax
        xor     r13d, ebx
        vpxord  zmm5, zmm5, zmm10
        xor     r14d, ecx
        xor     r15d, edx
        vpxord  zmm6, zmm6, zmm11
        ror     r12d, 8
        ror     r13d, 8
        vpxord  zmm7, zmm7, zmm8
        ror     r14d, 8
        ror     r15d, 8
        vpxord  zmm4, zmm4, zmm9
        add     r9d, r12d
        add     r10d, r13d
        vprord  zmm5, zmm5, 12
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        vprord  zmm6, zmm6, 12
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vprord  zmm7, zmm7, 12
        xor     r8d, r11d
        ror     esi, 7
        vprord  zmm4, zmm4, 12
        ror     edi, 7
        ror     ebp, 7
        vpaddd  zmm0, zmm0, zmm19
        ror     r8d, 7
        add     eax, edi
        vpaddd  zmm1, zmm1, zmm26
        add     ebx, ebp
        add     ecx, r8d
        vpaddd  zmm2, zmm2, zmm22
        add     edx, esi
        add     eax, dword ptr [rsp+0x15c]
        vpaddd  zmm3, zmm3, zmm23
        add     ebx, dword ptr [rsp+0x154]
        add     ecx, dword ptr [rsp+0x140]
        vpaddd  zmm0, zmm0, zmm5
        add     edx, dword ptr [rsp+0x158]
        xor     r15d, eax
        vpaddd  zmm1, zmm1, zmm6
        xor     r12d, ebx
        xor     r13d, ecx
        vpaddd  zmm2, zmm2, zmm7
        xor     r14d, edx
        ror     r15d, 16
        vpaddd  zmm3, zmm3, zmm4
        ror     r12d, 16
        ror     r13d, 16
        vpxord  zmm15, zmm15, zmm0
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpxord  zmm12, zmm12, zmm1
        add     r11d, r12d
        add     r9d, r13d
        vpxord  zmm13, zmm13, zmm2
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpxord  zmm14, zmm14, zmm3
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm15, zmm15, 8
        ror     edi, 12
        ror     ebp, 12
        vprord  zmm12, zmm12, 8
        ror     r8d, 12
        ror     esi, 12
        vprord  zmm13, zmm13, 8
        add     eax, edi
        add     ebx, ebp
        vprord  zmm14, zmm14, 8
        add     ecx, r8d
        add     edx, esi
        vpaddd  zmm10, zmm10, zmm15
        add     eax, dword ptr [rsp+0x148]
        add     ebx, dword ptr [rsp+0x14c]
        vpaddd  zmm11, zmm11, zmm12
        add     ecx, dword ptr [rsp+0x144]
        add     edx, dword ptr [rsp+0x150]
        vpaddd  zmm8, zmm8, zmm13
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm9, zmm9, zmm14
        xor     r13d, ecx
        xor     r14d, edx
        vpxord  zmm5, zmm5, zmm10
        ror     r15d, 8
        ror     r12d, 8
        vpxord  zmm6, zmm6, zmm11
        ror     r13d, 8
        ror     r14d, 8
        vpxord  zmm7, zmm7, zmm8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm4, zmm4, zmm9
        add     r9d, r13d
        add     r10d, r14d
        vprord  zmm5, zmm5, 7
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vprord  zmm6, zmm6, 7
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm7, zmm7, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm4, zmm4, 7
        ror     esi, 7
        add     eax, esi
        vpaddd  zmm0, zmm0, zmm27
        add     ebx, edi
        add     ecx, ebp
        vpaddd  zmm1, zmm1, zmm21
        add     edx, r8d
        add     eax, dword ptr [rsp+0x164]
        vpaddd  zmm2, zmm2, zmm17
        add     ebx, dword ptr [rsp+0x16c]
        add     ecx, dword ptr [rsp+0x160]
        vpaddd  zmm3, zmm3, zmm24
        add     edx, dword ptr [rsp+0x17c]
        xor     r12d, eax
        vpaddd  zmm0, zmm0, zmm4
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm1, zmm1, zmm5
        xor     r15d, edx
        ror     r12d, 16
        vpaddd  zmm2, zmm2, zmm6
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm3, zmm3, zmm7
        ror     r15d, 16
        add     r9d, r12d
        vpxord  zmm12, zmm12, zmm0
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpxord  zmm13, zmm13, zmm1
        add     r11d, r15d
        xor     esi, r9d
        vpxord  zmm14, zmm14, zmm2
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpxord  zmm15, zmm15, zmm3
        xor     r8d, r11d
        ror     esi, 12
        vprord  zmm12, zmm12, 16
        ror     edi, 12
        ror     ebp, 12
        vprord  zmm13, zmm13, 16
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        vprord  zmm14, zmm14, 16
        add     ecx, ebp
        add     edx, r8d
        vprord  zmm15, zmm15, 16
        add     eax, dword ptr [rsp+0x178]
        add     ebx, dword ptr [rsp+0x154]
        vpaddd  zmm8, zmm8, zmm12
        add     ecx, dword ptr [rsp+0x170]
        add     edx, dword ptr [rsp+0x144]
        vpaddd  zmm9, zmm9, zmm13
        xor     r12d, eax
        xor     r13d, ebx
        vpaddd  zmm10, zmm10, zmm14
        xor     r14d, ecx
        xor     r15d, edx
        vpaddd  zmm11, zmm11, zmm15
        ror     r12d, 8
        ror     r13d, 8
        vpxord  zmm4, zmm4, zmm8
        ror     r14d, 8
        ror     r15d, 8
        vpxord  zmm5, zmm5, zmm9
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm6, zmm6, zmm10
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm7, zmm7, zmm11
        xor     esi, r9d
        xor     edi, r10d
        vprord  zmm4, zmm4, 12
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vprord  zmm5, zmm5, 12
        ror     esi, 7
        ror     edi, 7
        vprord  zmm6, zmm6, 12
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm7, zmm7, 12
        add     eax, edi
        add     ebx, ebp
        vpaddd  zmm0, zmm0, zmm31
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x174]
        vpaddd  zmm1, zmm1, zmm16
        add     ebx, dword ptr [rsp+0x140]
        add     ecx, dword ptr [rsp+0x148]
        vpaddd  zmm2, zmm2, zmm25
        add     edx, dword ptr [rsp+0x150]
        xor     r15d, eax
        vpaddd  zmm3, zmm3, zmm22
        xor     r12d, ebx
        xor     r13d, ecx
        vpaddd  zmm0, zmm0, zmm4
        xor     r14d, edx
        ror     r15d, 16
        vpaddd  zmm1, zmm1, zmm5
        ror     r12d, 16
        ror     r13d, 16
        vpaddd  zmm2, zmm2, zmm6
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm3, zmm3, zmm7
        add     r11d, r12d
        add     r9d, r13d
        vpxord  zmm12, zmm12, zmm0
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpxord  zmm13, zmm13, zmm1
        xor     ebp, r11d
        xor     r8d, r9d
        vpxord  zmm14, zmm14, zmm2
        xor     esi, r10d
        ror     edi, 12
        vpxord  zmm15, zmm15, zmm3
        ror     ebp, 12
        ror     r8d, 12
        vprord  zmm12, zmm12, 8
        ror     esi, 12
        add     eax, edi
        vprord  zmm13, zmm13, 8
        add     ebx, ebp
        add     ecx, r8d
        vprord  zmm14, zmm14, 8
        add     edx, esi
        add     eax, dword ptr [rsp+0x14c]
        vprord  zmm15, zmm15, 8
        add     ebx, dword ptr [rsp+0x168]
        add     ecx, dword ptr [rsp+0x158]
        add     edx, dword ptr [rsp+0x15c]
        vpaddd  zmm8, zmm8, zmm12
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm9, zmm9, zmm13
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm10, zmm10, zmm14
        ror     r15d, 8
        ror     r12d, 8
        vpaddd  zmm11, zmm11, zmm15
        ror     r13d, 8
        ror     r14d, 8
        vpxord  zmm4, zmm4, zmm8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        vpxord  zmm5, zmm5, zmm9
        add     r9d, r13d
        add     r10d, r14d
        vpxord  zmm6, zmm6, zmm10
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpxord  zmm7, zmm7, zmm11
        xor     r8d, r9d
        xor     esi, r10d
        vprord  zmm4, zmm4, 7
        ror     edi, 7
        ror     ebp, 7
        vprord  zmm5, zmm5, 7
        ror     r8d, 7
        ror     esi, 7
        vprord  zmm6, zmm6, 7
        add     eax, esi
        add     ebx, edi
        vprord  zmm7, zmm7, 7
        add     ecx, ebp
        add     edx, r8d
        vpaddd  zmm0, zmm0, zmm30
        add     eax, dword ptr [rsp+0x16c]
        add     ebx, dword ptr [rsp+0x154]
        vpaddd  zmm1, zmm1, zmm18
        add     ecx, dword ptr [rsp+0x144]
        add     edx, dword ptr [rsp+0x160]
        vpaddd  zmm2, zmm2, zmm19
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm3, zmm3, zmm23
        xor     r15d, edx
        ror     r12d, 16
        vpaddd  zmm0, zmm0, zmm5
        ror     r13d, 16
        ror     r14d, 16
        vpaddd  zmm1, zmm1, zmm6
        ror     r15d, 16
        add     r9d, r12d
        vpaddd  zmm2, zmm2, zmm7
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        vpaddd  zmm3, zmm3, zmm4
        add     r11d, r15d
        xor     esi, r9d
        vpxord  zmm15, zmm15, zmm0
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        vpxord  zmm12, zmm12, zmm1
        xor     r8d, r11d
        ror     esi, 12
        vpxord  zmm13, zmm13, zmm2
        ror     edi, 12
        ror     ebp, 12
        vpxord  zmm14, zmm14, zmm3
        ror     r8d, 12
        add     eax, esi
        vprord  zmm15, zmm15, 16
        add     ebx, edi
        add     ecx, ebp
        vprord  zmm12, zmm12, 16
        add     edx, r8d
        add     eax, dword ptr [rsp+0x17c]
        vprord  zmm13, zmm13, 16
        add     ebx, dword ptr [rsp+0x140]
        add     ecx, dword ptr [rsp+0x164]
        vprord  zmm14, zmm14, 16
        add     edx, dword ptr [rsp+0x158]
        xor     r12d, eax
        vpaddd  zmm10, zmm10, zmm15
        xor     r13d, ebx
        xor     r14d, ecx
        vpaddd  zmm11, zmm11, zmm12
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm8, zmm8, zmm13
        ror     r14d, 8
        ror     r15d, 8
        vpaddd  zmm9, zmm9, zmm14
        add     r9d, r12d
        add     r10d, r13d
        vpxord  zmm5, zmm5, zmm10
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        vpxord  zmm6, zmm6, zmm11
        xor     esi, r9d
        xor     edi, r10d
        vpxord  zmm7, zmm7, zmm8
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        vpxord  zmm4, zmm4, zmm9
        ror     esi, 7
        ror     edi, 7
        vprord  zmm5, zmm5, 12
        ror     ebp, 7
        ror     r8d, 7
        vprord  zmm6, zmm6, 12
        add     eax, edi
        add     ebx, ebp
        vprord  zmm7, zmm7, 12
        add     ecx, r8d
        add     edx, esi
        vprord  zmm4, zmm4, 12
        add     eax, dword ptr [rsp+0x178]
        add     ebx, dword ptr [rsp+0x148]
        vpaddd  zmm0, zmm0, zmm26
        add     ecx, dword ptr [rsp+0x14c]
        add     edx, dword ptr [rsp+0x15c]
        vpaddd  zmm1, zmm1, zmm28
        xor     r15d, eax
        xor     r12d, ebx
        vpaddd  zmm2, zmm2, zmm20
        xor     r13d, ecx
        xor     r14d, edx
        vpaddd  zmm3, zmm3, zmm29
        ror     r15d, 16
        ror     r12d, 16
        vpaddd  zmm0, zmm0, zmm5
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm1, zmm1, zmm6
        add     r11d, r12d
        add     r9d, r13d
        vpaddd  zmm2, zmm2, zmm7
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        vpaddd  zmm3, zmm3, zmm4
        xor     ebp, r11d
        xor     r8d, r9d
        vpxord  zmm15, zmm15, zmm0
        xor     esi, r10d
        ror     edi, 12
        vpxord  zmm12, zmm12, zmm1
        ror     ebp, 12
        ror     r8d, 12
        vpxord  zmm13, zmm13, zmm2
        ror     esi, 12
        add     eax, edi
        vpxord  zmm14, zmm14, zmm3
        add     ebx, ebp
        add     ecx, r8d
        vprord  zmm15, zmm15, 8
        add     edx, esi
        add     eax, dword ptr [rsp+0x168]
        vprord  zmm12, zmm12, 8
        add     ebx, dword ptr [rsp+0x170]
        add     ecx, dword ptr [rsp+0x150]
        vprord  zmm13, zmm13, 8
        add     edx, dword ptr [rsp+0x174]
        xor     r15d, eax
        vprord  zmm14, zmm14, 8
        xor     r12d, ebx
        xor     r13d, ecx
        vpaddd  zmm10, zmm10, zmm15
        xor     r14d, edx
        ror     r15d, 8
        vpaddd  zmm11, zmm11, zmm12
        ror     r12d, 8
        ror     r13d, 8
        vpaddd  zmm8, zmm8, zmm13
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        vpaddd  zmm9, zmm9, zmm14
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        vpxord  zmm5, zmm5, zmm10
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        vpxord  zmm6, zmm6, zmm11
        xor     r8d, r9d
        xor     esi, r10d
        vpxord  zmm7, zmm7, zmm8
        ror     edi, 7
        ror     ebp, 7
        vpxord  zmm4, zmm4, zmm9
        ror     r8d, 7
        ror     esi, 7
        vprord  zmm5, zmm5, 7
        xor     eax, r9d
        xor     ebx, r10d
        vprord  zmm6, zmm6, 7
        xor     ecx, dword ptr [rsp+0x200]
        xor     edx, r11d
        vprord  zmm7, zmm7, 7
        xor     esi, r12d
        xor     edi, r13d
        vprord  zmm4, zmm4, 7
        xor     ebp, r14d
        xor     r8d, r15d
        vpxord  zmm0, zmm0, zmm8
        mov     dword ptr [rsp+0x1a0], eax
        mov     dword ptr [rsp+0x1a4], ebx
        vpxord  zmm1, zmm1, zmm9
        mov     dword ptr [rsp+0x1a8], ecx
        mov     dword ptr [rsp+0x1ac], edx
        vpxord  zmm2, zmm2, zmm10
        mov     dword ptr [rsp+0x1b0], esi
        mov     dword ptr [rsp+0x1b4], edi
        vpxord  zmm3, zmm3, zmm11
        mov     dword ptr [rsp+0x1b8], ebp
        mov     dword ptr [rsp+0x1bc], r8d
        vpxord  zmm4, zmm4, zmm12
        mov     rdi, qword ptr [rsp+0x1c0]
        mov     rdx, qword ptr [rsp+0x1c8]
        vpxord  zmm5, zmm5, zmm13
        mov     rsi, qword ptr [rsp+0x1d0]
        mov     rcx, qword ptr [rsp+0x1d8]
        vpxord  zmm6, zmm6, zmm14
        mov     rbp, qword ptr [rsp+0x1e0]
        mov     r11, qword ptr [rsp+0x1e8]
        vpxord  zmm7, zmm7, zmm15
        cmp     rdx, 1024
        movzx   eax, byte ptr [rbp+0x38]
        jne     9b
        mov     rbx, qword ptr [rbp+0x50]
        vmovdqu32 zmmword ptr [rbx], zmm0
        vmovdqu32 zmmword ptr [rbx+0x1*0x40], zmm1
        vmovdqu32 zmmword ptr [rbx+0x2*0x40], zmm2
        vmovdqu32 zmmword ptr [rbx+0x3*0x40], zmm3
        vmovdqu32 zmmword ptr [rbx+0x4*0x40], zmm4
        vmovdqu32 zmmword ptr [rbx+0x5*0x40], zmm5
        vmovdqu32 zmmword ptr [rbx+0x6*0x40], zmm6
        vmovdqu32 zmmword ptr [rbx+0x7*0x40], zmm7
        mov     r8, qword ptr [rsp+0x208]
        mov     eax, dword ptr [rsp+0x180]
        mov     dword ptr [r8+0x0], eax
        mov     eax, dword ptr [rsp+0x1a0]
        mov     dword ptr [r8+0x4], eax
        mov     eax, dword ptr [rsp+0x184]
        mov     dword ptr [r8+0x40], eax
        mov     eax, dword ptr [rsp+0x1a4]
        mov     dword ptr [r8+0x44], eax
        mov     eax, dword ptr [rsp+0x188]
        mov     dword ptr [r8+0x80], eax
        mov     eax, dword ptr [rsp+0x1a8]
        mov     dword ptr [r8+0x84], eax
        mov     eax, dword ptr [rsp+0x18c]
        mov     dword ptr [r8+0xc0], eax
        mov     eax, dword ptr [rsp+0x1ac]
        mov     dword ptr [r8+0xc4], eax
        mov     eax, dword ptr [rsp+0x190]
        mov     dword ptr [r8+0x100], eax
        mov     eax, dword ptr [rsp+0x1b0]
        mov     dword ptr [r8+0x104], eax
        mov     eax, dword ptr [rsp+0x194]
        mov     dword ptr [r8+0x140], eax
        mov     eax, dword ptr [rsp+0x1b4]
        mov     dword ptr [r8+0x144], eax
        mov     eax, dword ptr [rsp+0x198]
        mov     dword ptr [r8+0x180], eax
        mov     eax, dword ptr [rsp+0x1b8]
        mov     dword ptr [r8+0x184], eax
        mov     eax, dword ptr [rsp+0x19c]
        mov     dword ptr [r8+0x1c0], eax
        mov     eax, dword ptr [rsp+0x1bc]
        mov     dword ptr [r8+0x1c4], eax
        add     r8, 8
        mov     qword ptr [rsp+0x208], r8
        add     r11, 1024
        add     rdi, 16384
        add     rbx, 512
        mov     qword ptr [rbp+0x50], rbx
        sub     rsi, 16
        cmp     rsi, 16
        jnc     2b
        mov     qword ptr [rsp+0x1F0], rcx
        mov     qword ptr [rsp+0x1E8], r11
        mov     qword ptr [rsp+0x210], 0
5:
        mov     rax, qword ptr [rsp+0x210]
        test    eax, 15
        jnz     6f
        mov     rcx, qword ptr [rsp+0x1F0]
        mov     r8d, dword ptr [rcx+0x0]
        mov     dword ptr [rsp+0x180], r8d
        mov     r8d, dword ptr [rcx+0x4]
        mov     dword ptr [rsp+0x184], r8d
        mov     r8d, dword ptr [rcx+0x8]
        mov     dword ptr [rsp+0x188], r8d
        mov     r8d, dword ptr [rcx+0xc]
        mov     dword ptr [rsp+0x18c], r8d
        mov     r8d, dword ptr [rcx+0x10]
        mov     dword ptr [rsp+0x190], r8d
        mov     r8d, dword ptr [rcx+0x14]
        mov     dword ptr [rsp+0x194], r8d
        mov     r8d, dword ptr [rcx+0x18]
        mov     dword ptr [rsp+0x198], r8d
        mov     r8d, dword ptr [rcx+0x1c]
        mov     dword ptr [rsp+0x19c], r8d
6:
        movzx   ebx, byte ptr [rbp+0x38]
        movzx   ecx, byte ptr [rbp+0x40]
        movzx   edx, byte ptr [rbp+0x48]
        mov     r8d, eax
        and     r8d, 15
        mov     r9d, ebx
        or      r9d, ecx
        test    r8d, r8d
        cmovz   ebx, r9d
        mov     r9d, ebx
        or      r9d, edx
        cmp     r8d, 15
        cmove   ebx, r9d
        mov     dword ptr [rsp+0x88], ebx
        mov     r11, qword ptr [rsp+0x1E8]
        vmovdqu32 zmm16, zmmword ptr [r11]
        vmovdqu32 zmmword ptr [rsp+0x100], zmm16
        add     r11, 64
        mov     qword ptr [rsp+0x1E8], r11
        mov     qword ptr [rsp+0x1C0+0x20], rbp
        mov     eax, dword ptr [rsp+0x180]
        mov     ebx, dword ptr [rsp+0x184]
        mov     ecx, dword ptr [rsp+0x188]
        mov     edx, dword ptr [rsp+0x18c]
        mov     esi, dword ptr [rsp+0x190]
        mov     edi, dword ptr [rsp+0x194]
        mov     ebp, dword ptr [rsp+0x198]
        mov     r8d, dword ptr [rsp+0x19c]
        mov     r9d, 0x6a09e667
        mov     r10d, 0xbb67ae85
        mov     dword ptr [rsp+0x200], 0x3c6ef372
        mov     r11d, 0xa54ff53a
        xor     r12d, r12d
        xor     r13d, r13d
        mov     r14d, 64
        mov     r15d, dword ptr [rsp+0x88]
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x100]
        add     ebx, dword ptr [rsp+0x108]
        add     ecx, dword ptr [rsp+0x110]
        add     edx, dword ptr [rsp+0x118]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x104]
        add     ebx, dword ptr [rsp+0x10c]
        add     ecx, dword ptr [rsp+0x114]
        add     edx, dword ptr [rsp+0x11c]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x120]
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x130]
        add     edx, dword ptr [rsp+0x138]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x124]
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x134]
        add     edx, dword ptr [rsp+0x13c]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x108]
        add     ebx, dword ptr [rsp+0x10c]
        add     ecx, dword ptr [rsp+0x11c]
        add     edx, dword ptr [rsp+0x110]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x118]
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x100]
        add     edx, dword ptr [rsp+0x134]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x104]
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x124]
        add     edx, dword ptr [rsp+0x13c]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x12c]
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x138]
        add     edx, dword ptr [rsp+0x120]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x10c]
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x134]
        add     edx, dword ptr [rsp+0x11c]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x110]
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x108]
        add     edx, dword ptr [rsp+0x138]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x118]
        add     ebx, dword ptr [rsp+0x124]
        add     ecx, dword ptr [rsp+0x12c]
        add     edx, dword ptr [rsp+0x120]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x114]
        add     ebx, dword ptr [rsp+0x100]
        add     ecx, dword ptr [rsp+0x13c]
        add     edx, dword ptr [rsp+0x104]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x128]
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x138]
        add     edx, dword ptr [rsp+0x134]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x11c]
        add     ebx, dword ptr [rsp+0x124]
        add     ecx, dword ptr [rsp+0x10c]
        add     edx, dword ptr [rsp+0x13c]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x110]
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x114]
        add     edx, dword ptr [rsp+0x104]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x100]
        add     ebx, dword ptr [rsp+0x108]
        add     ecx, dword ptr [rsp+0x120]
        add     edx, dword ptr [rsp+0x118]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x130]
        add     ebx, dword ptr [rsp+0x124]
        add     ecx, dword ptr [rsp+0x13c]
        add     edx, dword ptr [rsp+0x138]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x134]
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x128]
        add     edx, dword ptr [rsp+0x120]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x11c]
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x100]
        add     edx, dword ptr [rsp+0x118]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x108]
        add     ebx, dword ptr [rsp+0x10c]
        add     ecx, dword ptr [rsp+0x104]
        add     edx, dword ptr [rsp+0x110]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x124]
        add     ebx, dword ptr [rsp+0x12c]
        add     ecx, dword ptr [rsp+0x120]
        add     edx, dword ptr [rsp+0x13c]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x138]
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x130]
        add     edx, dword ptr [rsp+0x104]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x134]
        add     ebx, dword ptr [rsp+0x100]
        add     ecx, dword ptr [rsp+0x108]
        add     edx, dword ptr [rsp+0x110]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x10c]
        add     ebx, dword ptr [rsp+0x128]
        add     ecx, dword ptr [rsp+0x118]
        add     edx, dword ptr [rsp+0x11c]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x12c]
        add     ebx, dword ptr [rsp+0x114]
        add     ecx, dword ptr [rsp+0x104]
        add     edx, dword ptr [rsp+0x120]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        ror     r15d, 16
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 12
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        add     eax, esi
        add     ebx, edi
        add     ecx, ebp
        add     edx, r8d
        add     eax, dword ptr [rsp+0x13c]
        add     ebx, dword ptr [rsp+0x100]
        add     ecx, dword ptr [rsp+0x124]
        add     edx, dword ptr [rsp+0x118]
        xor     r12d, eax
        xor     r13d, ebx
        xor     r14d, ecx
        xor     r15d, edx
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        ror     r15d, 8
        add     r9d, r12d
        add     r10d, r13d
        add     dword ptr [rsp+0x200], r14d
        add     r11d, r15d
        xor     esi, r9d
        xor     edi, r10d
        xor     ebp, dword ptr [rsp+0x200]
        xor     r8d, r11d
        ror     esi, 7
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x138]
        add     ebx, dword ptr [rsp+0x108]
        add     ecx, dword ptr [rsp+0x10c]
        add     edx, dword ptr [rsp+0x11c]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 16
        ror     r12d, 16
        ror     r13d, 16
        ror     r14d, 16
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 12
        ror     ebp, 12
        ror     r8d, 12
        ror     esi, 12
        add     eax, edi
        add     ebx, ebp
        add     ecx, r8d
        add     edx, esi
        add     eax, dword ptr [rsp+0x128]
        add     ebx, dword ptr [rsp+0x130]
        add     ecx, dword ptr [rsp+0x110]
        add     edx, dword ptr [rsp+0x134]
        xor     r15d, eax
        xor     r12d, ebx
        xor     r13d, ecx
        xor     r14d, edx
        ror     r15d, 8
        ror     r12d, 8
        ror     r13d, 8
        ror     r14d, 8
        add     dword ptr [rsp+0x200], r15d
        add     r11d, r12d
        add     r9d, r13d
        add     r10d, r14d
        xor     edi, dword ptr [rsp+0x200]
        xor     ebp, r11d
        xor     r8d, r9d
        xor     esi, r10d
        ror     edi, 7
        ror     ebp, 7
        ror     r8d, 7
        ror     esi, 7
        xor     eax, r9d
        xor     ebx, r10d
        xor     ecx, dword ptr [rsp+0x200]
        xor     edx, r11d
        xor     esi, r12d
        xor     edi, r13d
        xor     ebp, r14d
        xor     r8d, r15d
        mov     dword ptr [rsp+0x180], eax
        mov     dword ptr [rsp+0x184], ebx
        mov     dword ptr [rsp+0x188], ecx
        mov     dword ptr [rsp+0x18c], edx
        mov     dword ptr [rsp+0x190], esi
        mov     dword ptr [rsp+0x194], edi
        mov     dword ptr [rsp+0x198], ebp
        mov     dword ptr [rsp+0x19c], r8d
        mov     rbp, qword ptr [rsp+0x1C0+0x20]
        mov     rax, qword ptr [rsp+0x210]
        add     rax, 1
        mov     qword ptr [rsp+0x210], rax
        test    eax, 15
        jnz     5b
        mov     r8, qword ptr [rsp+0x208]
        mov     r9d, dword ptr [rsp+0x180]
        mov     dword ptr [r8+0x0], r9d
        mov     r9d, dword ptr [rsp+0x184]
        mov     dword ptr [r8+0x40], r9d
        mov     r9d, dword ptr [rsp+0x188]
        mov     dword ptr [r8+0x80], r9d
        mov     r9d, dword ptr [rsp+0x18c]
        mov     dword ptr [r8+0xc0], r9d
        mov     r9d, dword ptr [rsp+0x190]
        mov     dword ptr [r8+0x100], r9d
        mov     r9d, dword ptr [rsp+0x194]
        mov     dword ptr [r8+0x140], r9d
        mov     r9d, dword ptr [rsp+0x198]
        mov     dword ptr [r8+0x180], r9d
        mov     r9d, dword ptr [rsp+0x19c]
        mov     dword ptr [r8+0x1c0], r9d
        add     r8, 4
        mov     qword ptr [rsp+0x208], r8
        cmp     rax, 32
        jb      5b
4:
        vzeroupper
        mov     rsp, rbp
        pop     rbp
        pop     rbx
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        ret
.size flock_blake3_planes_leaf_1024_hyb, .-flock_blake3_planes_leaf_1024_hyb

.section .rodata
.p2align 6
.Lflock_hyb_BLAKE3_BLOCK_LEN: .long 0x40
.Lflock_hyb_BLAKE3_IV_0: .long 0x6a09e667
.Lflock_hyb_BLAKE3_IV_1: .long 0xbb67ae85
.Lflock_hyb_BLAKE3_IV_2: .long 0x3c6ef372
.Lflock_hyb_BLAKE3_IV_3: .long 0xa54ff53a
.section .note.GNU-stack,"",@progbits
