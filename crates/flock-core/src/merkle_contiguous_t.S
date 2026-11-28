// GENERATED from merkle_contiguous.S (flock_blake3_planes_leaf_1024); do not edit by hand.
// Same compression schedule and outputs. The 16x16 message-word transpose is performed by
// scalar dword moves (load/store ports only) into a stack scratch ahead of the compression,
// instead of 64 vector-port insert/unpack/shuffle uops per sixteen-lane compression.
.text
.p2align 6
.global flock_blake3_planes_leaf_1024_t
.hidden flock_blake3_planes_leaf_1024_t
.type flock_blake3_planes_leaf_1024_t, @function
flock_blake3_planes_leaf_1024_t:
        mov     r10d, 1
        push    r15
        push    r14
        push    r13
        push    r12
        push    rbx
        push    rbp
        mov     rbp, rsp
        sub     rsp, 1232
        and     rsp, 0xFFFFFFFFFFFFFFC0
        xor     r9d, r9d
        xor     r11d, r11d
.p2align 4
1:
        mov     eax, dword ptr [rdi+r9+0]
        mov     dword ptr [rsp+r11+192], eax
        mov     eax, dword ptr [rdi+r9+4]
        mov     dword ptr [rsp+r11+256], eax
        mov     eax, dword ptr [rdi+r9+8]
        mov     dword ptr [rsp+r11+320], eax
        mov     eax, dword ptr [rdi+r9+12]
        mov     dword ptr [rsp+r11+384], eax
        mov     eax, dword ptr [rdi+r9+16]
        mov     dword ptr [rsp+r11+448], eax
        mov     eax, dword ptr [rdi+r9+20]
        mov     dword ptr [rsp+r11+512], eax
        mov     eax, dword ptr [rdi+r9+24]
        mov     dword ptr [rsp+r11+576], eax
        mov     eax, dword ptr [rdi+r9+28]
        mov     dword ptr [rsp+r11+640], eax
        mov     eax, dword ptr [rdi+r9+32]
        mov     dword ptr [rsp+r11+704], eax
        mov     eax, dword ptr [rdi+r9+36]
        mov     dword ptr [rsp+r11+768], eax
        mov     eax, dword ptr [rdi+r9+40]
        mov     dword ptr [rsp+r11+832], eax
        mov     eax, dword ptr [rdi+r9+44]
        mov     dword ptr [rsp+r11+896], eax
        mov     eax, dword ptr [rdi+r9+48]
        mov     dword ptr [rsp+r11+960], eax
        mov     eax, dword ptr [rdi+r9+52]
        mov     dword ptr [rsp+r11+1024], eax
        mov     eax, dword ptr [rdi+r9+56]
        mov     dword ptr [rsp+r11+1088], eax
        mov     eax, dword ptr [rdi+r9+60]
        mov     dword ptr [rsp+r11+1152], eax
        add     r9, 1024
        add     r11, 4
        cmp     r11, 64
        jne     1b
2:
        lea     r12, [rdi+16384]
        cmp     rsi, 32
        cmovb   r12, rdi
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
9:
        movzx   ebx, byte ptr [rbp+0x48]
        or      ebx, eax
        add     rdx, 64
        cmp     rdx, 1024
        cmove   eax, ebx
        mov     dword ptr [rsp+0x88], eax
        lea     r8, [rdi+rdx]
        cmove   r8, r12
        vmovdqa64 zmm16, zmmword ptr [rsp+192]
        vmovdqa64 zmm17, zmmword ptr [rsp+256]
        vmovdqa64 zmm18, zmmword ptr [rsp+320]
        vmovdqa64 zmm19, zmmword ptr [rsp+384]
        vmovdqa64 zmm20, zmmword ptr [rsp+448]
        vmovdqa64 zmm21, zmmword ptr [rsp+512]
        vmovdqa64 zmm22, zmmword ptr [rsp+576]
        vmovdqa64 zmm23, zmmword ptr [rsp+640]
        vmovdqa64 zmm24, zmmword ptr [rsp+704]
        vmovdqa64 zmm25, zmmword ptr [rsp+768]
        vmovdqa64 zmm26, zmmword ptr [rsp+832]
        vmovdqa64 zmm27, zmmword ptr [rsp+896]
        vmovdqa64 zmm28, zmmword ptr [rsp+960]
        vmovdqa64 zmm29, zmmword ptr [rsp+1024]
        vmovdqa64 zmm30, zmmword ptr [rsp+1088]
        vmovdqa64 zmm31, zmmword ptr [rsp+1152]
        prefetcht0 [rdi+rdx+64]
        prefetcht0 [rdi+rdx+1088]
        prefetcht0 [rdi+rdx+2112]
        prefetcht0 [rdi+rdx+3136]
        prefetcht0 [rdi+rdx+4160]
        prefetcht0 [rdi+rdx+5184]
        prefetcht0 [rdi+rdx+6208]
        prefetcht0 [rdi+rdx+7232]
        prefetcht0 [rdi+rdx+8256]
        prefetcht0 [rdi+rdx+9280]
        prefetcht0 [rdi+rdx+10304]
        prefetcht0 [rdi+rdx+11328]
        prefetcht0 [rdi+rdx+12352]
        prefetcht0 [rdi+rdx+13376]
        prefetcht0 [rdi+rdx+14400]
        prefetcht0 [rdi+rdx+15424]
        vpbroadcastd zmm8, dword ptr [.Lflock_contiguous_BLAKE3_IV_0+rip]
        vpbroadcastd zmm9, dword ptr [.Lflock_contiguous_BLAKE3_IV_1+rip]
        vpbroadcastd zmm10, dword ptr [.Lflock_contiguous_BLAKE3_IV_2+rip]
        vpbroadcastd zmm11, dword ptr [.Lflock_contiguous_BLAKE3_IV_3+rip]
        vpbroadcastd zmm14, dword ptr [.Lflock_contiguous_BLAKE3_BLOCK_LEN+rip]
        vpbroadcastd zmm15, dword ptr [rsp+0x22*0x4]
        vpaddd  zmm0, zmm0, zmm16
        mov     r9d, dword ptr [r8+0]
        mov     dword ptr [rsp+192], r9d
        vpaddd  zmm1, zmm1, zmm18
        mov     r11d, dword ptr [r8+4]
        mov     dword ptr [rsp+256], r11d
        vpaddd  zmm2, zmm2, zmm20
        mov     r13d, dword ptr [r8+8]
        mov     dword ptr [rsp+320], r13d
        vpaddd  zmm3, zmm3, zmm22
        mov     r14d, dword ptr [r8+12]
        mov     dword ptr [rsp+384], r14d
        vpaddd  zmm0, zmm0, zmm4
        mov     r9d, dword ptr [r8+16]
        mov     dword ptr [rsp+448], r9d
        vpaddd  zmm1, zmm1, zmm5
        mov     r11d, dword ptr [r8+20]
        mov     dword ptr [rsp+512], r11d
        vpaddd  zmm2, zmm2, zmm6
        mov     r13d, dword ptr [r8+24]
        mov     dword ptr [rsp+576], r13d
        vpaddd  zmm3, zmm3, zmm7
        mov     r14d, dword ptr [r8+28]
        mov     dword ptr [rsp+640], r14d
        vpxord  zmm14, zmm14, zmm2
        mov     r9d, dword ptr [r8+32]
        mov     dword ptr [rsp+704], r9d
        vpxord  zmm15, zmm15, zmm3
        mov     r11d, dword ptr [r8+36]
        mov     dword ptr [rsp+768], r11d
        vprord  zmm12, zmm0, 16
        mov     r13d, dword ptr [r8+40]
        mov     dword ptr [rsp+832], r13d
        vprord  zmm13, zmm1, 16
        mov     r14d, dword ptr [r8+44]
        mov     dword ptr [rsp+896], r14d
        vprord  zmm14, zmm14, 16
        mov     r9d, dword ptr [r8+48]
        mov     dword ptr [rsp+960], r9d
        vprord  zmm15, zmm15, 16
        mov     r11d, dword ptr [r8+52]
        mov     dword ptr [rsp+1024], r11d
        vpaddd  zmm8, zmm8, zmm12
        mov     r13d, dword ptr [r8+56]
        mov     dword ptr [rsp+1088], r13d
        vpaddd  zmm9, zmm9, zmm13
        mov     r14d, dword ptr [r8+60]
        mov     dword ptr [rsp+1152], r14d
        vpaddd  zmm10, zmm10, zmm14
        mov     r9d, dword ptr [r8+1024]
        mov     dword ptr [rsp+196], r9d
        vpaddd  zmm11, zmm11, zmm15
        mov     r11d, dword ptr [r8+1028]
        mov     dword ptr [rsp+260], r11d
        vpxord  zmm4, zmm4, zmm8
        mov     r13d, dword ptr [r8+1032]
        mov     dword ptr [rsp+324], r13d
        vpxord  zmm5, zmm5, zmm9
        mov     r14d, dword ptr [r8+1036]
        mov     dword ptr [rsp+388], r14d
        vpxord  zmm6, zmm6, zmm10
        mov     r9d, dword ptr [r8+1040]
        mov     dword ptr [rsp+452], r9d
        vpxord  zmm7, zmm7, zmm11
        mov     r11d, dword ptr [r8+1044]
        mov     dword ptr [rsp+516], r11d
        vprord  zmm4, zmm4, 12
        mov     r13d, dword ptr [r8+1048]
        mov     dword ptr [rsp+580], r13d
        vprord  zmm5, zmm5, 12
        mov     r14d, dword ptr [r8+1052]
        mov     dword ptr [rsp+644], r14d
        vprord  zmm6, zmm6, 12
        mov     r9d, dword ptr [r8+1056]
        mov     dword ptr [rsp+708], r9d
        vprord  zmm7, zmm7, 12
        mov     r11d, dword ptr [r8+1060]
        mov     dword ptr [rsp+772], r11d
        vpaddd  zmm0, zmm0, zmm17
        mov     r13d, dword ptr [r8+1064]
        mov     dword ptr [rsp+836], r13d
        vpaddd  zmm1, zmm1, zmm19
        mov     r14d, dword ptr [r8+1068]
        mov     dword ptr [rsp+900], r14d
        vpaddd  zmm2, zmm2, zmm21
        mov     r9d, dword ptr [r8+1072]
        mov     dword ptr [rsp+964], r9d
        vpaddd  zmm3, zmm3, zmm23
        mov     r11d, dword ptr [r8+1076]
        mov     dword ptr [rsp+1028], r11d
        vpaddd  zmm0, zmm0, zmm4
        mov     r13d, dword ptr [r8+1080]
        mov     dword ptr [rsp+1092], r13d
        vpaddd  zmm1, zmm1, zmm5
        mov     r14d, dword ptr [r8+1084]
        mov     dword ptr [rsp+1156], r14d
        vpaddd  zmm2, zmm2, zmm6
        mov     r9d, dword ptr [r8+2048]
        mov     dword ptr [rsp+200], r9d
        vpaddd  zmm3, zmm3, zmm7
        mov     r11d, dword ptr [r8+2052]
        mov     dword ptr [rsp+264], r11d
        vpxord  zmm12, zmm12, zmm0
        mov     r13d, dword ptr [r8+2056]
        mov     dword ptr [rsp+328], r13d
        vpxord  zmm13, zmm13, zmm1
        mov     r14d, dword ptr [r8+2060]
        mov     dword ptr [rsp+392], r14d
        vpxord  zmm14, zmm14, zmm2
        mov     r9d, dword ptr [r8+2064]
        mov     dword ptr [rsp+456], r9d
        vpxord  zmm15, zmm15, zmm3
        mov     r11d, dword ptr [r8+2068]
        mov     dword ptr [rsp+520], r11d
        vprord  zmm12, zmm12, 8
        mov     r13d, dword ptr [r8+2072]
        mov     dword ptr [rsp+584], r13d
        vprord  zmm13, zmm13, 8
        mov     r14d, dword ptr [r8+2076]
        mov     dword ptr [rsp+648], r14d
        vprord  zmm14, zmm14, 8
        mov     r9d, dword ptr [r8+2080]
        mov     dword ptr [rsp+712], r9d
        vprord  zmm15, zmm15, 8
        mov     r11d, dword ptr [r8+2084]
        mov     dword ptr [rsp+776], r11d
        vpaddd  zmm8, zmm8, zmm12
        mov     r13d, dword ptr [r8+2088]
        mov     dword ptr [rsp+840], r13d
        vpaddd  zmm9, zmm9, zmm13
        mov     r14d, dword ptr [r8+2092]
        mov     dword ptr [rsp+904], r14d
        vpaddd  zmm10, zmm10, zmm14
        mov     r9d, dword ptr [r8+2096]
        mov     dword ptr [rsp+968], r9d
        vpaddd  zmm11, zmm11, zmm15
        mov     r11d, dword ptr [r8+2100]
        mov     dword ptr [rsp+1032], r11d
        vpxord  zmm4, zmm4, zmm8
        mov     r13d, dword ptr [r8+2104]
        mov     dword ptr [rsp+1096], r13d
        vpxord  zmm5, zmm5, zmm9
        mov     r14d, dword ptr [r8+2108]
        mov     dword ptr [rsp+1160], r14d
        vpxord  zmm6, zmm6, zmm10
        mov     r9d, dword ptr [r8+3072]
        mov     dword ptr [rsp+204], r9d
        vpxord  zmm7, zmm7, zmm11
        mov     r11d, dword ptr [r8+3076]
        mov     dword ptr [rsp+268], r11d
        vprord  zmm4, zmm4, 7
        mov     r13d, dword ptr [r8+3080]
        mov     dword ptr [rsp+332], r13d
        vprord  zmm5, zmm5, 7
        mov     r14d, dword ptr [r8+3084]
        mov     dword ptr [rsp+396], r14d
        vprord  zmm6, zmm6, 7
        mov     r9d, dword ptr [r8+3088]
        mov     dword ptr [rsp+460], r9d
        vprord  zmm7, zmm7, 7
        mov     r11d, dword ptr [r8+3092]
        mov     dword ptr [rsp+524], r11d
        vpaddd  zmm0, zmm0, zmm24
        mov     r13d, dword ptr [r8+3096]
        mov     dword ptr [rsp+588], r13d
        vpaddd  zmm1, zmm1, zmm26
        mov     r14d, dword ptr [r8+3100]
        mov     dword ptr [rsp+652], r14d
        vpaddd  zmm2, zmm2, zmm28
        mov     r9d, dword ptr [r8+3104]
        mov     dword ptr [rsp+716], r9d
        vpaddd  zmm3, zmm3, zmm30
        mov     r11d, dword ptr [r8+3108]
        mov     dword ptr [rsp+780], r11d
        vpaddd  zmm0, zmm0, zmm5
        mov     r13d, dword ptr [r8+3112]
        mov     dword ptr [rsp+844], r13d
        vpaddd  zmm1, zmm1, zmm6
        mov     r14d, dword ptr [r8+3116]
        mov     dword ptr [rsp+908], r14d
        vpaddd  zmm2, zmm2, zmm7
        mov     r9d, dword ptr [r8+3120]
        mov     dword ptr [rsp+972], r9d
        vpaddd  zmm3, zmm3, zmm4
        mov     r11d, dword ptr [r8+3124]
        mov     dword ptr [rsp+1036], r11d
        vpxord  zmm15, zmm15, zmm0
        mov     r13d, dword ptr [r8+3128]
        mov     dword ptr [rsp+1100], r13d
        vpxord  zmm12, zmm12, zmm1
        mov     r14d, dword ptr [r8+3132]
        mov     dword ptr [rsp+1164], r14d
        vpxord  zmm13, zmm13, zmm2
        mov     r9d, dword ptr [r8+4096]
        mov     dword ptr [rsp+208], r9d
        vpxord  zmm14, zmm14, zmm3
        mov     r11d, dword ptr [r8+4100]
        mov     dword ptr [rsp+272], r11d
        vprord  zmm15, zmm15, 16
        mov     r13d, dword ptr [r8+4104]
        mov     dword ptr [rsp+336], r13d
        vprord  zmm12, zmm12, 16
        mov     r14d, dword ptr [r8+4108]
        mov     dword ptr [rsp+400], r14d
        vprord  zmm13, zmm13, 16
        mov     r9d, dword ptr [r8+4112]
        mov     dword ptr [rsp+464], r9d
        vprord  zmm14, zmm14, 16
        mov     r11d, dword ptr [r8+4116]
        mov     dword ptr [rsp+528], r11d
        vpaddd  zmm10, zmm10, zmm15
        mov     r13d, dword ptr [r8+4120]
        mov     dword ptr [rsp+592], r13d
        vpaddd  zmm11, zmm11, zmm12
        mov     r14d, dword ptr [r8+4124]
        mov     dword ptr [rsp+656], r14d
        vpaddd  zmm8, zmm8, zmm13
        mov     r9d, dword ptr [r8+4128]
        mov     dword ptr [rsp+720], r9d
        vpaddd  zmm9, zmm9, zmm14
        mov     r11d, dword ptr [r8+4132]
        mov     dword ptr [rsp+784], r11d
        vpxord  zmm5, zmm5, zmm10
        mov     r13d, dword ptr [r8+4136]
        mov     dword ptr [rsp+848], r13d
        vpxord  zmm6, zmm6, zmm11
        mov     r14d, dword ptr [r8+4140]
        mov     dword ptr [rsp+912], r14d
        vpxord  zmm7, zmm7, zmm8
        mov     r9d, dword ptr [r8+4144]
        mov     dword ptr [rsp+976], r9d
        vpxord  zmm4, zmm4, zmm9
        mov     r11d, dword ptr [r8+4148]
        mov     dword ptr [rsp+1040], r11d
        vprord  zmm5, zmm5, 12
        mov     r13d, dword ptr [r8+4152]
        mov     dword ptr [rsp+1104], r13d
        vprord  zmm6, zmm6, 12
        mov     r14d, dword ptr [r8+4156]
        mov     dword ptr [rsp+1168], r14d
        vprord  zmm7, zmm7, 12
        mov     r9d, dword ptr [r8+5120]
        mov     dword ptr [rsp+212], r9d
        vprord  zmm4, zmm4, 12
        mov     r11d, dword ptr [r8+5124]
        mov     dword ptr [rsp+276], r11d
        vpaddd  zmm0, zmm0, zmm25
        mov     r13d, dword ptr [r8+5128]
        mov     dword ptr [rsp+340], r13d
        vpaddd  zmm1, zmm1, zmm27
        mov     r14d, dword ptr [r8+5132]
        mov     dword ptr [rsp+404], r14d
        vpaddd  zmm2, zmm2, zmm29
        mov     r9d, dword ptr [r8+5136]
        mov     dword ptr [rsp+468], r9d
        vpaddd  zmm3, zmm3, zmm31
        mov     r11d, dword ptr [r8+5140]
        mov     dword ptr [rsp+532], r11d
        vpaddd  zmm0, zmm0, zmm5
        mov     r13d, dword ptr [r8+5144]
        mov     dword ptr [rsp+596], r13d
        vpaddd  zmm1, zmm1, zmm6
        mov     r14d, dword ptr [r8+5148]
        mov     dword ptr [rsp+660], r14d
        vpaddd  zmm2, zmm2, zmm7
        mov     r9d, dword ptr [r8+5152]
        mov     dword ptr [rsp+724], r9d
        vpaddd  zmm3, zmm3, zmm4
        mov     r11d, dword ptr [r8+5156]
        mov     dword ptr [rsp+788], r11d
        vpxord  zmm15, zmm15, zmm0
        mov     r13d, dword ptr [r8+5160]
        mov     dword ptr [rsp+852], r13d
        vpxord  zmm12, zmm12, zmm1
        mov     r14d, dword ptr [r8+5164]
        mov     dword ptr [rsp+916], r14d
        vpxord  zmm13, zmm13, zmm2
        mov     r9d, dword ptr [r8+5168]
        mov     dword ptr [rsp+980], r9d
        vpxord  zmm14, zmm14, zmm3
        mov     r11d, dword ptr [r8+5172]
        mov     dword ptr [rsp+1044], r11d
        vprord  zmm15, zmm15, 8
        mov     r13d, dword ptr [r8+5176]
        mov     dword ptr [rsp+1108], r13d
        vprord  zmm12, zmm12, 8
        mov     r14d, dword ptr [r8+5180]
        mov     dword ptr [rsp+1172], r14d
        vprord  zmm13, zmm13, 8
        mov     r9d, dword ptr [r8+6144]
        mov     dword ptr [rsp+216], r9d
        vprord  zmm14, zmm14, 8
        mov     r11d, dword ptr [r8+6148]
        mov     dword ptr [rsp+280], r11d
        vpaddd  zmm10, zmm10, zmm15
        mov     r13d, dword ptr [r8+6152]
        mov     dword ptr [rsp+344], r13d
        vpaddd  zmm11, zmm11, zmm12
        mov     r14d, dword ptr [r8+6156]
        mov     dword ptr [rsp+408], r14d
        vpaddd  zmm8, zmm8, zmm13
        mov     r9d, dword ptr [r8+6160]
        mov     dword ptr [rsp+472], r9d
        vpaddd  zmm9, zmm9, zmm14
        mov     r11d, dword ptr [r8+6164]
        mov     dword ptr [rsp+536], r11d
        vpxord  zmm5, zmm5, zmm10
        mov     r13d, dword ptr [r8+6168]
        mov     dword ptr [rsp+600], r13d
        vpxord  zmm6, zmm6, zmm11
        mov     r14d, dword ptr [r8+6172]
        mov     dword ptr [rsp+664], r14d
        vpxord  zmm7, zmm7, zmm8
        mov     r9d, dword ptr [r8+6176]
        mov     dword ptr [rsp+728], r9d
        vpxord  zmm4, zmm4, zmm9
        mov     r11d, dword ptr [r8+6180]
        mov     dword ptr [rsp+792], r11d
        vprord  zmm5, zmm5, 7
        mov     r13d, dword ptr [r8+6184]
        mov     dword ptr [rsp+856], r13d
        vprord  zmm6, zmm6, 7
        mov     r14d, dword ptr [r8+6188]
        mov     dword ptr [rsp+920], r14d
        vprord  zmm7, zmm7, 7
        mov     r9d, dword ptr [r8+6192]
        mov     dword ptr [rsp+984], r9d
        vprord  zmm4, zmm4, 7
        mov     r11d, dword ptr [r8+6196]
        mov     dword ptr [rsp+1048], r11d
        vpaddd  zmm0, zmm0, zmm18
        mov     r13d, dword ptr [r8+6200]
        mov     dword ptr [rsp+1112], r13d
        vpaddd  zmm1, zmm1, zmm19
        mov     r14d, dword ptr [r8+6204]
        mov     dword ptr [rsp+1176], r14d
        vpaddd  zmm2, zmm2, zmm23
        mov     r9d, dword ptr [r8+7168]
        mov     dword ptr [rsp+220], r9d
        vpaddd  zmm3, zmm3, zmm20
        mov     r11d, dword ptr [r8+7172]
        mov     dword ptr [rsp+284], r11d
        vpaddd  zmm0, zmm0, zmm4
        mov     r13d, dword ptr [r8+7176]
        mov     dword ptr [rsp+348], r13d
        vpaddd  zmm1, zmm1, zmm5
        mov     r14d, dword ptr [r8+7180]
        mov     dword ptr [rsp+412], r14d
        vpaddd  zmm2, zmm2, zmm6
        mov     r9d, dword ptr [r8+7184]
        mov     dword ptr [rsp+476], r9d
        vpaddd  zmm3, zmm3, zmm7
        mov     r11d, dword ptr [r8+7188]
        mov     dword ptr [rsp+540], r11d
        vpxord  zmm12, zmm12, zmm0
        mov     r13d, dword ptr [r8+7192]
        mov     dword ptr [rsp+604], r13d
        vpxord  zmm13, zmm13, zmm1
        mov     r14d, dword ptr [r8+7196]
        mov     dword ptr [rsp+668], r14d
        vpxord  zmm14, zmm14, zmm2
        mov     r9d, dword ptr [r8+7200]
        mov     dword ptr [rsp+732], r9d
        vpxord  zmm15, zmm15, zmm3
        mov     r11d, dword ptr [r8+7204]
        mov     dword ptr [rsp+796], r11d
        vprord  zmm12, zmm12, 16
        mov     r13d, dword ptr [r8+7208]
        mov     dword ptr [rsp+860], r13d
        vprord  zmm13, zmm13, 16
        mov     r14d, dword ptr [r8+7212]
        mov     dword ptr [rsp+924], r14d
        vprord  zmm14, zmm14, 16
        mov     r9d, dword ptr [r8+7216]
        mov     dword ptr [rsp+988], r9d
        vprord  zmm15, zmm15, 16
        mov     r11d, dword ptr [r8+7220]
        mov     dword ptr [rsp+1052], r11d
        vpaddd  zmm8, zmm8, zmm12
        mov     r13d, dword ptr [r8+7224]
        mov     dword ptr [rsp+1116], r13d
        vpaddd  zmm9, zmm9, zmm13
        mov     r14d, dword ptr [r8+7228]
        mov     dword ptr [rsp+1180], r14d
        vpaddd  zmm10, zmm10, zmm14
        mov     r9d, dword ptr [r8+8192]
        mov     dword ptr [rsp+224], r9d
        vpaddd  zmm11, zmm11, zmm15
        mov     r11d, dword ptr [r8+8196]
        mov     dword ptr [rsp+288], r11d
        vpxord  zmm4, zmm4, zmm8
        mov     r13d, dword ptr [r8+8200]
        mov     dword ptr [rsp+352], r13d
        vpxord  zmm5, zmm5, zmm9
        mov     r14d, dword ptr [r8+8204]
        mov     dword ptr [rsp+416], r14d
        vpxord  zmm6, zmm6, zmm10
        mov     r9d, dword ptr [r8+8208]
        mov     dword ptr [rsp+480], r9d
        vpxord  zmm7, zmm7, zmm11
        mov     r11d, dword ptr [r8+8212]
        mov     dword ptr [rsp+544], r11d
        vprord  zmm4, zmm4, 12
        mov     r13d, dword ptr [r8+8216]
        mov     dword ptr [rsp+608], r13d
        vprord  zmm5, zmm5, 12
        mov     r14d, dword ptr [r8+8220]
        mov     dword ptr [rsp+672], r14d
        vprord  zmm6, zmm6, 12
        mov     r9d, dword ptr [r8+8224]
        mov     dword ptr [rsp+736], r9d
        vprord  zmm7, zmm7, 12
        mov     r11d, dword ptr [r8+8228]
        mov     dword ptr [rsp+800], r11d
        vpaddd  zmm0, zmm0, zmm22
        mov     r13d, dword ptr [r8+8232]
        mov     dword ptr [rsp+864], r13d
        vpaddd  zmm1, zmm1, zmm26
        mov     r14d, dword ptr [r8+8236]
        mov     dword ptr [rsp+928], r14d
        vpaddd  zmm2, zmm2, zmm16
        mov     r9d, dword ptr [r8+8240]
        mov     dword ptr [rsp+992], r9d
        vpaddd  zmm3, zmm3, zmm29
        mov     r11d, dword ptr [r8+8244]
        mov     dword ptr [rsp+1056], r11d
        vpaddd  zmm0, zmm0, zmm4
        mov     r13d, dword ptr [r8+8248]
        mov     dword ptr [rsp+1120], r13d
        vpaddd  zmm1, zmm1, zmm5
        mov     r14d, dword ptr [r8+8252]
        mov     dword ptr [rsp+1184], r14d
        vpaddd  zmm2, zmm2, zmm6
        mov     r9d, dword ptr [r8+9216]
        mov     dword ptr [rsp+228], r9d
        vpaddd  zmm3, zmm3, zmm7
        mov     r11d, dword ptr [r8+9220]
        mov     dword ptr [rsp+292], r11d
        vpxord  zmm12, zmm12, zmm0
        mov     r13d, dword ptr [r8+9224]
        mov     dword ptr [rsp+356], r13d
        vpxord  zmm13, zmm13, zmm1
        mov     r14d, dword ptr [r8+9228]
        mov     dword ptr [rsp+420], r14d
        vpxord  zmm14, zmm14, zmm2
        mov     r9d, dword ptr [r8+9232]
        mov     dword ptr [rsp+484], r9d
        vpxord  zmm15, zmm15, zmm3
        mov     r11d, dword ptr [r8+9236]
        mov     dword ptr [rsp+548], r11d
        vprord  zmm12, zmm12, 8
        mov     r13d, dword ptr [r8+9240]
        mov     dword ptr [rsp+612], r13d
        vprord  zmm13, zmm13, 8
        mov     r14d, dword ptr [r8+9244]
        mov     dword ptr [rsp+676], r14d
        vprord  zmm14, zmm14, 8
        mov     r9d, dword ptr [r8+9248]
        mov     dword ptr [rsp+740], r9d
        vprord  zmm15, zmm15, 8
        mov     r11d, dword ptr [r8+9252]
        mov     dword ptr [rsp+804], r11d
        vpaddd  zmm8, zmm8, zmm12
        mov     r13d, dword ptr [r8+9256]
        mov     dword ptr [rsp+868], r13d
        vpaddd  zmm9, zmm9, zmm13
        mov     r14d, dword ptr [r8+9260]
        mov     dword ptr [rsp+932], r14d
        vpaddd  zmm10, zmm10, zmm14
        mov     r9d, dword ptr [r8+9264]
        mov     dword ptr [rsp+996], r9d
        vpaddd  zmm11, zmm11, zmm15
        mov     r11d, dword ptr [r8+9268]
        mov     dword ptr [rsp+1060], r11d
        vpxord  zmm4, zmm4, zmm8
        mov     r13d, dword ptr [r8+9272]
        mov     dword ptr [rsp+1124], r13d
        vpxord  zmm5, zmm5, zmm9
        mov     r14d, dword ptr [r8+9276]
        mov     dword ptr [rsp+1188], r14d
        vpxord  zmm6, zmm6, zmm10
        mov     r9d, dword ptr [r8+10240]
        mov     dword ptr [rsp+232], r9d
        vpxord  zmm7, zmm7, zmm11
        mov     r11d, dword ptr [r8+10244]
        mov     dword ptr [rsp+296], r11d
        vprord  zmm4, zmm4, 7
        mov     r13d, dword ptr [r8+10248]
        mov     dword ptr [rsp+360], r13d
        vprord  zmm5, zmm5, 7
        mov     r14d, dword ptr [r8+10252]
        mov     dword ptr [rsp+424], r14d
        vprord  zmm6, zmm6, 7
        mov     r9d, dword ptr [r8+10256]
        mov     dword ptr [rsp+488], r9d
        vprord  zmm7, zmm7, 7
        mov     r11d, dword ptr [r8+10260]
        mov     dword ptr [rsp+552], r11d
        vpaddd  zmm0, zmm0, zmm17
        mov     r13d, dword ptr [r8+10264]
        mov     dword ptr [rsp+616], r13d
        vpaddd  zmm1, zmm1, zmm28
        mov     r14d, dword ptr [r8+10268]
        mov     dword ptr [rsp+680], r14d
        vpaddd  zmm2, zmm2, zmm25
        mov     r9d, dword ptr [r8+10272]
        mov     dword ptr [rsp+744], r9d
        vpaddd  zmm3, zmm3, zmm31
        mov     r11d, dword ptr [r8+10276]
        mov     dword ptr [rsp+808], r11d
        vpaddd  zmm0, zmm0, zmm5
        mov     r13d, dword ptr [r8+10280]
        mov     dword ptr [rsp+872], r13d
        vpaddd  zmm1, zmm1, zmm6
        mov     r14d, dword ptr [r8+10284]
        mov     dword ptr [rsp+936], r14d
        vpaddd  zmm2, zmm2, zmm7
        mov     r9d, dword ptr [r8+10288]
        mov     dword ptr [rsp+1000], r9d
        vpaddd  zmm3, zmm3, zmm4
        mov     r11d, dword ptr [r8+10292]
        mov     dword ptr [rsp+1064], r11d
        vpxord  zmm15, zmm15, zmm0
        mov     r13d, dword ptr [r8+10296]
        mov     dword ptr [rsp+1128], r13d
        vpxord  zmm12, zmm12, zmm1
        mov     r14d, dword ptr [r8+10300]
        mov     dword ptr [rsp+1192], r14d
        vpxord  zmm13, zmm13, zmm2
        mov     r9d, dword ptr [r8+11264]
        mov     dword ptr [rsp+236], r9d
        vpxord  zmm14, zmm14, zmm3
        mov     r11d, dword ptr [r8+11268]
        mov     dword ptr [rsp+300], r11d
        vprord  zmm15, zmm15, 16
        mov     r13d, dword ptr [r8+11272]
        mov     dword ptr [rsp+364], r13d
        vprord  zmm12, zmm12, 16
        mov     r14d, dword ptr [r8+11276]
        mov     dword ptr [rsp+428], r14d
        vprord  zmm13, zmm13, 16
        mov     r9d, dword ptr [r8+11280]
        mov     dword ptr [rsp+492], r9d
        vprord  zmm14, zmm14, 16
        mov     r11d, dword ptr [r8+11284]
        mov     dword ptr [rsp+556], r11d
        vpaddd  zmm10, zmm10, zmm15
        mov     r13d, dword ptr [r8+11288]
        mov     dword ptr [rsp+620], r13d
        vpaddd  zmm11, zmm11, zmm12
        mov     r14d, dword ptr [r8+11292]
        mov     dword ptr [rsp+684], r14d
        vpaddd  zmm8, zmm8, zmm13
        mov     r9d, dword ptr [r8+11296]
        mov     dword ptr [rsp+748], r9d
        vpaddd  zmm9, zmm9, zmm14
        mov     r11d, dword ptr [r8+11300]
        mov     dword ptr [rsp+812], r11d
        vpxord  zmm5, zmm5, zmm10
        mov     r13d, dword ptr [r8+11304]
        mov     dword ptr [rsp+876], r13d
        vpxord  zmm6, zmm6, zmm11
        mov     r14d, dword ptr [r8+11308]
        mov     dword ptr [rsp+940], r14d
        vpxord  zmm7, zmm7, zmm8
        mov     r9d, dword ptr [r8+11312]
        mov     dword ptr [rsp+1004], r9d
        vpxord  zmm4, zmm4, zmm9
        mov     r11d, dword ptr [r8+11316]
        mov     dword ptr [rsp+1068], r11d
        vprord  zmm5, zmm5, 12
        mov     r13d, dword ptr [r8+11320]
        mov     dword ptr [rsp+1132], r13d
        vprord  zmm6, zmm6, 12
        mov     r14d, dword ptr [r8+11324]
        mov     dword ptr [rsp+1196], r14d
        vprord  zmm7, zmm7, 12
        mov     r9d, dword ptr [r8+12288]
        mov     dword ptr [rsp+240], r9d
        vprord  zmm4, zmm4, 12
        mov     r11d, dword ptr [r8+12292]
        mov     dword ptr [rsp+304], r11d
        vpaddd  zmm0, zmm0, zmm27
        mov     r13d, dword ptr [r8+12296]
        mov     dword ptr [rsp+368], r13d
        vpaddd  zmm1, zmm1, zmm21
        mov     r14d, dword ptr [r8+12300]
        mov     dword ptr [rsp+432], r14d
        vpaddd  zmm2, zmm2, zmm30
        mov     r9d, dword ptr [r8+12304]
        mov     dword ptr [rsp+496], r9d
        vpaddd  zmm3, zmm3, zmm24
        mov     r11d, dword ptr [r8+12308]
        mov     dword ptr [rsp+560], r11d
        vpaddd  zmm0, zmm0, zmm5
        mov     r13d, dword ptr [r8+12312]
        mov     dword ptr [rsp+624], r13d
        vpaddd  zmm1, zmm1, zmm6
        mov     r14d, dword ptr [r8+12316]
        mov     dword ptr [rsp+688], r14d
        vpaddd  zmm2, zmm2, zmm7
        mov     r9d, dword ptr [r8+12320]
        mov     dword ptr [rsp+752], r9d
        vpaddd  zmm3, zmm3, zmm4
        mov     r11d, dword ptr [r8+12324]
        mov     dword ptr [rsp+816], r11d
        vpxord  zmm15, zmm15, zmm0
        mov     r13d, dword ptr [r8+12328]
        mov     dword ptr [rsp+880], r13d
        vpxord  zmm12, zmm12, zmm1
        mov     r14d, dword ptr [r8+12332]
        mov     dword ptr [rsp+944], r14d
        vpxord  zmm13, zmm13, zmm2
        mov     r9d, dword ptr [r8+12336]
        mov     dword ptr [rsp+1008], r9d
        vpxord  zmm14, zmm14, zmm3
        mov     r11d, dword ptr [r8+12340]
        mov     dword ptr [rsp+1072], r11d
        vprord  zmm15, zmm15, 8
        mov     r13d, dword ptr [r8+12344]
        mov     dword ptr [rsp+1136], r13d
        vprord  zmm12, zmm12, 8
        mov     r14d, dword ptr [r8+12348]
        mov     dword ptr [rsp+1200], r14d
        vprord  zmm13, zmm13, 8
        mov     r9d, dword ptr [r8+13312]
        mov     dword ptr [rsp+244], r9d
        vprord  zmm14, zmm14, 8
        mov     r11d, dword ptr [r8+13316]
        mov     dword ptr [rsp+308], r11d
        vpaddd  zmm10, zmm10, zmm15
        mov     r13d, dword ptr [r8+13320]
        mov     dword ptr [rsp+372], r13d
        vpaddd  zmm11, zmm11, zmm12
        mov     r14d, dword ptr [r8+13324]
        mov     dword ptr [rsp+436], r14d
        vpaddd  zmm8, zmm8, zmm13
        mov     r9d, dword ptr [r8+13328]
        mov     dword ptr [rsp+500], r9d
        vpaddd  zmm9, zmm9, zmm14
        mov     r11d, dword ptr [r8+13332]
        mov     dword ptr [rsp+564], r11d
        vpxord  zmm5, zmm5, zmm10
        mov     r13d, dword ptr [r8+13336]
        mov     dword ptr [rsp+628], r13d
        vpxord  zmm6, zmm6, zmm11
        mov     r14d, dword ptr [r8+13340]
        mov     dword ptr [rsp+692], r14d
        vpxord  zmm7, zmm7, zmm8
        mov     r9d, dword ptr [r8+13344]
        mov     dword ptr [rsp+756], r9d
        vpxord  zmm4, zmm4, zmm9
        mov     r11d, dword ptr [r8+13348]
        mov     dword ptr [rsp+820], r11d
        vprord  zmm5, zmm5, 7
        mov     r13d, dword ptr [r8+13352]
        mov     dword ptr [rsp+884], r13d
        vprord  zmm6, zmm6, 7
        mov     r14d, dword ptr [r8+13356]
        mov     dword ptr [rsp+948], r14d
        vprord  zmm7, zmm7, 7
        mov     r9d, dword ptr [r8+13360]
        mov     dword ptr [rsp+1012], r9d
        vprord  zmm4, zmm4, 7
        mov     r11d, dword ptr [r8+13364]
        mov     dword ptr [rsp+1076], r11d
        vpaddd  zmm0, zmm0, zmm19
        mov     r13d, dword ptr [r8+13368]
        mov     dword ptr [rsp+1140], r13d
        vpaddd  zmm1, zmm1, zmm26
        mov     r14d, dword ptr [r8+13372]
        mov     dword ptr [rsp+1204], r14d
        vpaddd  zmm2, zmm2, zmm29
        mov     r9d, dword ptr [r8+14336]
        mov     dword ptr [rsp+248], r9d
        vpaddd  zmm3, zmm3, zmm23
        mov     r11d, dword ptr [r8+14340]
        mov     dword ptr [rsp+312], r11d
        vpaddd  zmm0, zmm0, zmm4
        mov     r13d, dword ptr [r8+14344]
        mov     dword ptr [rsp+376], r13d
        vpaddd  zmm1, zmm1, zmm5
        mov     r14d, dword ptr [r8+14348]
        mov     dword ptr [rsp+440], r14d
        vpaddd  zmm2, zmm2, zmm6
        mov     r9d, dword ptr [r8+14352]
        mov     dword ptr [rsp+504], r9d
        vpaddd  zmm3, zmm3, zmm7
        mov     r11d, dword ptr [r8+14356]
        mov     dword ptr [rsp+568], r11d
        vpxord  zmm12, zmm12, zmm0
        mov     r13d, dword ptr [r8+14360]
        mov     dword ptr [rsp+632], r13d
        vpxord  zmm13, zmm13, zmm1
        mov     r14d, dword ptr [r8+14364]
        mov     dword ptr [rsp+696], r14d
        vpxord  zmm14, zmm14, zmm2
        mov     r9d, dword ptr [r8+14368]
        mov     dword ptr [rsp+760], r9d
        vpxord  zmm15, zmm15, zmm3
        mov     r11d, dword ptr [r8+14372]
        mov     dword ptr [rsp+824], r11d
        vprord  zmm12, zmm12, 16
        mov     r13d, dword ptr [r8+14376]
        mov     dword ptr [rsp+888], r13d
        vprord  zmm13, zmm13, 16
        mov     r14d, dword ptr [r8+14380]
        mov     dword ptr [rsp+952], r14d
        vprord  zmm14, zmm14, 16
        mov     r9d, dword ptr [r8+14384]
        mov     dword ptr [rsp+1016], r9d
        vprord  zmm15, zmm15, 16
        mov     r11d, dword ptr [r8+14388]
        mov     dword ptr [rsp+1080], r11d
        vpaddd  zmm8, zmm8, zmm12
        mov     r13d, dword ptr [r8+14392]
        mov     dword ptr [rsp+1144], r13d
        vpaddd  zmm9, zmm9, zmm13
        mov     r14d, dword ptr [r8+14396]
        mov     dword ptr [rsp+1208], r14d
        vpaddd  zmm10, zmm10, zmm14
        mov     r9d, dword ptr [r8+15360]
        mov     dword ptr [rsp+252], r9d
        vpaddd  zmm11, zmm11, zmm15
        mov     r11d, dword ptr [r8+15364]
        mov     dword ptr [rsp+316], r11d
        vpxord  zmm4, zmm4, zmm8
        mov     r13d, dword ptr [r8+15368]
        mov     dword ptr [rsp+380], r13d
        vpxord  zmm5, zmm5, zmm9
        mov     r14d, dword ptr [r8+15372]
        mov     dword ptr [rsp+444], r14d
        vpxord  zmm6, zmm6, zmm10
        mov     r9d, dword ptr [r8+15376]
        mov     dword ptr [rsp+508], r9d
        vpxord  zmm7, zmm7, zmm11
        mov     r11d, dword ptr [r8+15380]
        mov     dword ptr [rsp+572], r11d
        vprord  zmm4, zmm4, 12
        mov     r13d, dword ptr [r8+15384]
        mov     dword ptr [rsp+636], r13d
        vprord  zmm5, zmm5, 12
        mov     r14d, dword ptr [r8+15388]
        mov     dword ptr [rsp+700], r14d
        vprord  zmm6, zmm6, 12
        mov     r9d, dword ptr [r8+15392]
        mov     dword ptr [rsp+764], r9d
        vprord  zmm7, zmm7, 12
        mov     r11d, dword ptr [r8+15396]
        mov     dword ptr [rsp+828], r11d
        vpaddd  zmm0, zmm0, zmm20
        mov     r13d, dword ptr [r8+15400]
        mov     dword ptr [rsp+892], r13d
        vpaddd  zmm1, zmm1, zmm28
        mov     r14d, dword ptr [r8+15404]
        mov     dword ptr [rsp+956], r14d
        vpaddd  zmm2, zmm2, zmm18
        mov     r9d, dword ptr [r8+15408]
        mov     dword ptr [rsp+1020], r9d
        vpaddd  zmm3, zmm3, zmm30
        mov     r11d, dword ptr [r8+15412]
        mov     dword ptr [rsp+1084], r11d
        vpaddd  zmm0, zmm0, zmm4
        mov     r13d, dword ptr [r8+15416]
        mov     dword ptr [rsp+1148], r13d
        vpaddd  zmm1, zmm1, zmm5
        mov     r14d, dword ptr [r8+15420]
        mov     dword ptr [rsp+1212], r14d
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vprord  zmm15, zmm15, 8
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 7
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vpaddd  zmm0, zmm0, zmm22
        vpaddd  zmm1, zmm1, zmm25
        vpaddd  zmm2, zmm2, zmm27
        vpaddd  zmm3, zmm3, zmm24
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 16
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vprord  zmm4, zmm4, 12
        vpaddd  zmm0, zmm0, zmm21
        vpaddd  zmm1, zmm1, zmm16
        vpaddd  zmm2, zmm2, zmm31
        vpaddd  zmm3, zmm3, zmm17
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 8
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vprord  zmm4, zmm4, 7
        vpaddd  zmm0, zmm0, zmm26
        vpaddd  zmm1, zmm1, zmm28
        vpaddd  zmm2, zmm2, zmm30
        vpaddd  zmm3, zmm3, zmm29
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vprord  zmm15, zmm15, 16
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 12
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vpaddd  zmm0, zmm0, zmm23
        vpaddd  zmm1, zmm1, zmm25
        vpaddd  zmm2, zmm2, zmm19
        vpaddd  zmm3, zmm3, zmm31
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vprord  zmm15, zmm15, 8
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 7
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vpaddd  zmm0, zmm0, zmm20
        vpaddd  zmm1, zmm1, zmm27
        vpaddd  zmm2, zmm2, zmm21
        vpaddd  zmm3, zmm3, zmm17
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 16
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vprord  zmm4, zmm4, 12
        vpaddd  zmm0, zmm0, zmm16
        vpaddd  zmm1, zmm1, zmm18
        vpaddd  zmm2, zmm2, zmm24
        vpaddd  zmm3, zmm3, zmm22
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 8
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vprord  zmm4, zmm4, 7
        vpaddd  zmm0, zmm0, zmm28
        vpaddd  zmm1, zmm1, zmm25
        vpaddd  zmm2, zmm2, zmm31
        vpaddd  zmm3, zmm3, zmm30
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vprord  zmm15, zmm15, 16
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 12
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vpaddd  zmm0, zmm0, zmm29
        vpaddd  zmm1, zmm1, zmm27
        vpaddd  zmm2, zmm2, zmm26
        vpaddd  zmm3, zmm3, zmm24
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vprord  zmm15, zmm15, 8
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 7
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vpaddd  zmm0, zmm0, zmm23
        vpaddd  zmm1, zmm1, zmm21
        vpaddd  zmm2, zmm2, zmm16
        vpaddd  zmm3, zmm3, zmm22
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 16
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vprord  zmm4, zmm4, 12
        vpaddd  zmm0, zmm0, zmm18
        vpaddd  zmm1, zmm1, zmm19
        vpaddd  zmm2, zmm2, zmm17
        vpaddd  zmm3, zmm3, zmm20
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 8
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vprord  zmm4, zmm4, 7
        vpaddd  zmm0, zmm0, zmm25
        vpaddd  zmm1, zmm1, zmm27
        vpaddd  zmm2, zmm2, zmm24
        vpaddd  zmm3, zmm3, zmm31
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vprord  zmm15, zmm15, 16
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 12
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vpaddd  zmm0, zmm0, zmm30
        vpaddd  zmm1, zmm1, zmm21
        vpaddd  zmm2, zmm2, zmm28
        vpaddd  zmm3, zmm3, zmm17
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vprord  zmm15, zmm15, 8
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 7
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vpaddd  zmm0, zmm0, zmm29
        vpaddd  zmm1, zmm1, zmm16
        vpaddd  zmm2, zmm2, zmm18
        vpaddd  zmm3, zmm3, zmm20
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 16
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vprord  zmm4, zmm4, 12
        vpaddd  zmm0, zmm0, zmm19
        vpaddd  zmm1, zmm1, zmm26
        vpaddd  zmm2, zmm2, zmm22
        vpaddd  zmm3, zmm3, zmm23
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 8
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vprord  zmm4, zmm4, 7
        vpaddd  zmm0, zmm0, zmm27
        vpaddd  zmm1, zmm1, zmm21
        vpaddd  zmm2, zmm2, zmm17
        vpaddd  zmm3, zmm3, zmm24
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vprord  zmm15, zmm15, 16
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 12
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vpaddd  zmm0, zmm0, zmm31
        vpaddd  zmm1, zmm1, zmm16
        vpaddd  zmm2, zmm2, zmm25
        vpaddd  zmm3, zmm3, zmm22
        vpaddd  zmm0, zmm0, zmm4
        vpaddd  zmm1, zmm1, zmm5
        vpaddd  zmm2, zmm2, zmm6
        vpaddd  zmm3, zmm3, zmm7
        vpxord  zmm12, zmm12, zmm0
        vpxord  zmm13, zmm13, zmm1
        vpxord  zmm14, zmm14, zmm2
        vpxord  zmm15, zmm15, zmm3
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vprord  zmm15, zmm15, 8
        vpaddd  zmm8, zmm8, zmm12
        vpaddd  zmm9, zmm9, zmm13
        vpaddd  zmm10, zmm10, zmm14
        vpaddd  zmm11, zmm11, zmm15
        vpxord  zmm4, zmm4, zmm8
        vpxord  zmm5, zmm5, zmm9
        vpxord  zmm6, zmm6, zmm10
        vpxord  zmm7, zmm7, zmm11
        vprord  zmm4, zmm4, 7
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vpaddd  zmm0, zmm0, zmm30
        vpaddd  zmm1, zmm1, zmm18
        vpaddd  zmm2, zmm2, zmm19
        vpaddd  zmm3, zmm3, zmm23
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 16
        vprord  zmm12, zmm12, 16
        vprord  zmm13, zmm13, 16
        vprord  zmm14, zmm14, 16
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 12
        vprord  zmm6, zmm6, 12
        vprord  zmm7, zmm7, 12
        vprord  zmm4, zmm4, 12
        vpaddd  zmm0, zmm0, zmm26
        vpaddd  zmm1, zmm1, zmm28
        vpaddd  zmm2, zmm2, zmm20
        vpaddd  zmm3, zmm3, zmm29
        vpaddd  zmm0, zmm0, zmm5
        vpaddd  zmm1, zmm1, zmm6
        vpaddd  zmm2, zmm2, zmm7
        vpaddd  zmm3, zmm3, zmm4
        vpxord  zmm15, zmm15, zmm0
        vpxord  zmm12, zmm12, zmm1
        vpxord  zmm13, zmm13, zmm2
        vpxord  zmm14, zmm14, zmm3
        vprord  zmm15, zmm15, 8
        vprord  zmm12, zmm12, 8
        vprord  zmm13, zmm13, 8
        vprord  zmm14, zmm14, 8
        vpaddd  zmm10, zmm10, zmm15
        vpaddd  zmm11, zmm11, zmm12
        vpaddd  zmm8, zmm8, zmm13
        vpaddd  zmm9, zmm9, zmm14
        vpxord  zmm5, zmm5, zmm10
        vpxord  zmm6, zmm6, zmm11
        vpxord  zmm7, zmm7, zmm8
        vpxord  zmm4, zmm4, zmm9
        vprord  zmm5, zmm5, 7
        vprord  zmm6, zmm6, 7
        vprord  zmm7, zmm7, 7
        vprord  zmm4, zmm4, 7
        vpxord  zmm0, zmm0, zmm8
        vpxord  zmm1, zmm1, zmm9
        vpxord  zmm2, zmm2, zmm10
        vpxord  zmm3, zmm3, zmm11
        vpxord  zmm4, zmm4, zmm12
        vpxord  zmm5, zmm5, zmm13
        vpxord  zmm6, zmm6, zmm14
        vpxord  zmm7, zmm7, zmm15
        movzx   eax, byte ptr [rbp+0x38]
        jne     9b
        mov     rbx, qword ptr [rbp+0x50]
        test    r10d, r10d
        jnz     .Lflock_leaf_store_1024_t
        vpunpckldq zmm16, zmm0, zmm1
        vpunpckhdq zmm17, zmm0, zmm1
        vpunpckldq zmm18, zmm2, zmm3
        vpunpckhdq zmm19, zmm2, zmm3
        vpunpckldq zmm20, zmm4, zmm5
        vpunpckhdq zmm21, zmm4, zmm5
        vpunpckldq zmm22, zmm6, zmm7
        vpunpckhdq zmm23, zmm6, zmm7
        vpunpcklqdq zmm0, zmm16, zmm18
        vpunpckhqdq zmm1, zmm16, zmm18
        vpunpcklqdq zmm2, zmm17, zmm19
        vpunpckhqdq zmm3, zmm17, zmm19
        vpunpcklqdq zmm4, zmm20, zmm22
        vpunpckhqdq zmm5, zmm20, zmm22
        vpunpcklqdq zmm6, zmm21, zmm23
        vpunpckhqdq zmm7, zmm21, zmm23
        vshufi32x4 zmm16, zmm0, zmm4, 0x88
        vshufi32x4 zmm17, zmm1, zmm5, 0x88
        vshufi32x4 zmm18, zmm2, zmm6, 0x88
        vshufi32x4 zmm19, zmm3, zmm7, 0x88
        vshufi32x4 zmm20, zmm0, zmm4, 0xDD
        vshufi32x4 zmm21, zmm1, zmm5, 0xDD
        vshufi32x4 zmm22, zmm2, zmm6, 0xDD
        vshufi32x4 zmm23, zmm3, zmm7, 0xDD
        vshufi32x4 zmm0, zmm16, zmm17, 0x88
        vshufi32x4 zmm1, zmm18, zmm19, 0x88
        vshufi32x4 zmm2, zmm20, zmm21, 0x88
        vshufi32x4 zmm3, zmm22, zmm23, 0x88
        vshufi32x4 zmm4, zmm16, zmm17, 0xDD
        vshufi32x4 zmm5, zmm18, zmm19, 0xDD
        vshufi32x4 zmm6, zmm20, zmm21, 0xDD
        vshufi32x4 zmm7, zmm22, zmm23, 0xDD
.Lflock_leaf_store_1024_t:
        vmovdqu32 zmmword ptr [rbx], zmm0
        vmovdqu32 zmmword ptr [rbx+0x1*0x40], zmm1
        vmovdqu32 zmmword ptr [rbx+0x2*0x40], zmm2
        vmovdqu32 zmmword ptr [rbx+0x3*0x40], zmm3
        vmovdqu32 zmmword ptr [rbx+0x4*0x40], zmm4
        vmovdqu32 zmmword ptr [rbx+0x5*0x40], zmm5
        vmovdqu32 zmmword ptr [rbx+0x6*0x40], zmm6
        vmovdqu32 zmmword ptr [rbx+0x7*0x40], zmm7
        add     rdi, 16384
        add     rbx, 512
        mov     qword ptr [rbp+0x50], rbx
        sub     rsi, 16
        cmp     rsi, 16
        jnc     2b
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
.size flock_blake3_planes_leaf_1024_t, .-flock_blake3_planes_leaf_1024_t
