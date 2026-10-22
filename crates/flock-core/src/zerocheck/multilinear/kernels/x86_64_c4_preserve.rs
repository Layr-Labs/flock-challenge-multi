use super::{CFoldMats, F128};
core::arch::global_asm!(
    r#".text
.p2align 5
.global flock_core_c4_preserved24_leaf
.hidden flock_core_c4_preserved24_leaf
.type flock_core_c4_preserved24_leaf,@function
flock_core_c4_preserved24_leaf:
vmovdqu64 zmm0, [rdi+0]
vmovdqu64 zmm1, [rdi+128]
vmovdqu64 zmm2, [rdi+256]
vmovdqu64 zmm3, [rdi+384]
vmovdqa64 zmm4, [rip+.Lflock_c4_glo]
vmovdqa64 zmm5, [rip+.Lflock_c4_ghi]
vmovdqa64 zmm6,zmm0
vpermt2q zmm0,zmm4,zmm1
vpermt2q zmm6,zmm5,zmm1
vmovdqa64 zmm7,zmm2
vpermt2q zmm2,zmm4,zmm3
vpermt2q zmm7,zmm5,zmm3
vmovdqa64 zmm4,[rip+.Lflock_c4_octeven]
vmovdqa64 zmm5,[rip+.Lflock_c4_octodd]
vmovdqa64 zmm1,zmm0
vpermt2b zmm0,zmm4,zmm2
vpermt2b zmm1,zmm5,zmm2
vmovdqa64 zmm3,zmm6
vpermt2b zmm6,zmm4,zmm7
vpermt2b zmm3,zmm5,zmm7
vmovdqu64 [rcx+0],zmm0
vmovdqu64 [rcx+64],zmm1
vmovdqu64 [rcx+128],zmm6
vmovdqu64 [rcx+192],zmm3
vmovdqu64 zmm0, [rdi+64]
vmovdqu64 zmm1, [rdi+192]
vmovdqu64 zmm2, [rdi+320]
vmovdqu64 zmm3, [rdi+448]
vmovdqa64 zmm4, [rip+.Lflock_c4_glo]
vmovdqa64 zmm5, [rip+.Lflock_c4_ghi]
vmovdqa64 zmm6,zmm0
vpermt2q zmm0,zmm4,zmm1
vpermt2q zmm6,zmm5,zmm1
vmovdqa64 zmm7,zmm2
vpermt2q zmm2,zmm4,zmm3
vpermt2q zmm7,zmm5,zmm3
vmovdqa64 zmm4,[rip+.Lflock_c4_octeven]
vmovdqa64 zmm5,[rip+.Lflock_c4_octodd]
vmovdqa64 zmm1,zmm0
vpermt2b zmm0,zmm4,zmm2
vpermt2b zmm1,zmm5,zmm2
vmovdqa64 zmm3,zmm6
vpermt2b zmm6,zmm4,zmm7
vpermt2b zmm3,zmm5,zmm7
vmovdqu64 [rcx+256],zmm0
vmovdqu64 [rcx+320],zmm1
vmovdqu64 [rcx+384],zmm6
vmovdqu64 [rcx+448],zmm3
vpbroadcastq zmm2,qword ptr [rcx+0]
vgf2p8affineqb zmm0,zmm2,[rsi],0
vgf2p8affineqb zmm1,zmm2,[rsi+2048],0
vpbroadcastq zmm2,qword ptr [rcx+8]
vgf2p8affineqb zmm3,zmm2,[rsi+64],0
vgf2p8affineqb zmm4,zmm2,[rsi+2112],0
vpbroadcastq zmm2,qword ptr [rcx+16]
vgf2p8affineqb zmm5,zmm2,[rsi+128],0
vgf2p8affineqb zmm6,zmm2,[rsi+2176],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+24]
vgf2p8affineqb zmm3,zmm2,[rsi+192],0
vgf2p8affineqb zmm4,zmm2,[rsi+2240],0
vpbroadcastq zmm2,qword ptr [rcx+32]
vgf2p8affineqb zmm5,zmm2,[rsi+256],0
vgf2p8affineqb zmm6,zmm2,[rsi+2304],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+40]
vgf2p8affineqb zmm3,zmm2,[rsi+320],0
vgf2p8affineqb zmm4,zmm2,[rsi+2368],0
vpbroadcastq zmm2,qword ptr [rcx+48]
vgf2p8affineqb zmm5,zmm2,[rsi+384],0
vgf2p8affineqb zmm6,zmm2,[rsi+2432],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+56]
vgf2p8affineqb zmm3,zmm2,[rsi+448],0
vgf2p8affineqb zmm4,zmm2,[rsi+2496],0
vpbroadcastq zmm2,qword ptr [rcx+64]
vgf2p8affineqb zmm5,zmm2,[rsi+512],0
vgf2p8affineqb zmm6,zmm2,[rsi+2560],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+72]
vgf2p8affineqb zmm3,zmm2,[rsi+576],0
vgf2p8affineqb zmm4,zmm2,[rsi+2624],0
vpbroadcastq zmm2,qword ptr [rcx+80]
vgf2p8affineqb zmm5,zmm2,[rsi+640],0
vgf2p8affineqb zmm6,zmm2,[rsi+2688],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+88]
vgf2p8affineqb zmm3,zmm2,[rsi+704],0
vgf2p8affineqb zmm4,zmm2,[rsi+2752],0
vpbroadcastq zmm2,qword ptr [rcx+96]
vgf2p8affineqb zmm5,zmm2,[rsi+768],0
vgf2p8affineqb zmm6,zmm2,[rsi+2816],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+104]
vgf2p8affineqb zmm3,zmm2,[rsi+832],0
vgf2p8affineqb zmm4,zmm2,[rsi+2880],0
vpbroadcastq zmm2,qword ptr [rcx+112]
vgf2p8affineqb zmm5,zmm2,[rsi+896],0
vgf2p8affineqb zmm6,zmm2,[rsi+2944],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+120]
vgf2p8affineqb zmm3,zmm2,[rsi+960],0
vgf2p8affineqb zmm4,zmm2,[rsi+3008],0
vpbroadcastq zmm2,qword ptr [rcx+128]
vgf2p8affineqb zmm5,zmm2,[rsi+1024],0
vgf2p8affineqb zmm6,zmm2,[rsi+3072],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+136]
vgf2p8affineqb zmm3,zmm2,[rsi+1088],0
vgf2p8affineqb zmm4,zmm2,[rsi+3136],0
vpbroadcastq zmm2,qword ptr [rcx+144]
vgf2p8affineqb zmm5,zmm2,[rsi+1152],0
vgf2p8affineqb zmm6,zmm2,[rsi+3200],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+152]
vgf2p8affineqb zmm3,zmm2,[rsi+1216],0
vgf2p8affineqb zmm4,zmm2,[rsi+3264],0
vpbroadcastq zmm2,qword ptr [rcx+160]
vgf2p8affineqb zmm5,zmm2,[rsi+1280],0
vgf2p8affineqb zmm6,zmm2,[rsi+3328],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+168]
vgf2p8affineqb zmm3,zmm2,[rsi+1344],0
vgf2p8affineqb zmm4,zmm2,[rsi+3392],0
vpbroadcastq zmm2,qword ptr [rcx+176]
vgf2p8affineqb zmm5,zmm2,[rsi+1408],0
vgf2p8affineqb zmm6,zmm2,[rsi+3456],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+184]
vgf2p8affineqb zmm3,zmm2,[rsi+1472],0
vgf2p8affineqb zmm4,zmm2,[rsi+3520],0
vpbroadcastq zmm2,qword ptr [rcx+192]
vgf2p8affineqb zmm5,zmm2,[rsi+1536],0
vgf2p8affineqb zmm6,zmm2,[rsi+3584],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+200]
vgf2p8affineqb zmm3,zmm2,[rsi+1600],0
vgf2p8affineqb zmm4,zmm2,[rsi+3648],0
vpbroadcastq zmm2,qword ptr [rcx+208]
vgf2p8affineqb zmm5,zmm2,[rsi+1664],0
vgf2p8affineqb zmm6,zmm2,[rsi+3712],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+216]
vgf2p8affineqb zmm3,zmm2,[rsi+1728],0
vgf2p8affineqb zmm4,zmm2,[rsi+3776],0
vpbroadcastq zmm2,qword ptr [rcx+224]
vgf2p8affineqb zmm5,zmm2,[rsi+1792],0
vgf2p8affineqb zmm6,zmm2,[rsi+3840],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+232]
vgf2p8affineqb zmm3,zmm2,[rsi+1856],0
vgf2p8affineqb zmm4,zmm2,[rsi+3904],0
vpbroadcastq zmm2,qword ptr [rcx+240]
vgf2p8affineqb zmm5,zmm2,[rsi+1920],0
vgf2p8affineqb zmm6,zmm2,[rsi+3968],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+248]
vgf2p8affineqb zmm3,zmm2,[rsi+1984],0
vgf2p8affineqb zmm4,zmm2,[rsi+4032],0
vpxorq zmm0,zmm0,zmm3
vpxorq zmm1,zmm1,zmm4
vmovdqa64 zmm2,[rip+.Lflock_c4_outeven]
vmovdqa64 zmm3,[rip+.Lflock_c4_outodd]
vmovdqa64 zmm4,zmm0
vpermt2b zmm0,zmm2,zmm1
vpermt2b zmm4,zmm3,zmm1
vmovdqu64 [rdx+0],zmm0
vmovdqu64 [rdx+64],zmm4
vpbroadcastq zmm2,qword ptr [rcx+256]
vgf2p8affineqb zmm0,zmm2,[rsi],0
vgf2p8affineqb zmm1,zmm2,[rsi+2048],0
vpbroadcastq zmm2,qword ptr [rcx+264]
vgf2p8affineqb zmm3,zmm2,[rsi+64],0
vgf2p8affineqb zmm4,zmm2,[rsi+2112],0
vpbroadcastq zmm2,qword ptr [rcx+272]
vgf2p8affineqb zmm5,zmm2,[rsi+128],0
vgf2p8affineqb zmm6,zmm2,[rsi+2176],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+280]
vgf2p8affineqb zmm3,zmm2,[rsi+192],0
vgf2p8affineqb zmm4,zmm2,[rsi+2240],0
vpbroadcastq zmm2,qword ptr [rcx+288]
vgf2p8affineqb zmm5,zmm2,[rsi+256],0
vgf2p8affineqb zmm6,zmm2,[rsi+2304],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+296]
vgf2p8affineqb zmm3,zmm2,[rsi+320],0
vgf2p8affineqb zmm4,zmm2,[rsi+2368],0
vpbroadcastq zmm2,qword ptr [rcx+304]
vgf2p8affineqb zmm5,zmm2,[rsi+384],0
vgf2p8affineqb zmm6,zmm2,[rsi+2432],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+312]
vgf2p8affineqb zmm3,zmm2,[rsi+448],0
vgf2p8affineqb zmm4,zmm2,[rsi+2496],0
vpbroadcastq zmm2,qword ptr [rcx+320]
vgf2p8affineqb zmm5,zmm2,[rsi+512],0
vgf2p8affineqb zmm6,zmm2,[rsi+2560],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+328]
vgf2p8affineqb zmm3,zmm2,[rsi+576],0
vgf2p8affineqb zmm4,zmm2,[rsi+2624],0
vpbroadcastq zmm2,qword ptr [rcx+336]
vgf2p8affineqb zmm5,zmm2,[rsi+640],0
vgf2p8affineqb zmm6,zmm2,[rsi+2688],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+344]
vgf2p8affineqb zmm3,zmm2,[rsi+704],0
vgf2p8affineqb zmm4,zmm2,[rsi+2752],0
vpbroadcastq zmm2,qword ptr [rcx+352]
vgf2p8affineqb zmm5,zmm2,[rsi+768],0
vgf2p8affineqb zmm6,zmm2,[rsi+2816],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+360]
vgf2p8affineqb zmm3,zmm2,[rsi+832],0
vgf2p8affineqb zmm4,zmm2,[rsi+2880],0
vpbroadcastq zmm2,qword ptr [rcx+368]
vgf2p8affineqb zmm5,zmm2,[rsi+896],0
vgf2p8affineqb zmm6,zmm2,[rsi+2944],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+376]
vgf2p8affineqb zmm3,zmm2,[rsi+960],0
vgf2p8affineqb zmm4,zmm2,[rsi+3008],0
vpbroadcastq zmm2,qword ptr [rcx+384]
vgf2p8affineqb zmm5,zmm2,[rsi+1024],0
vgf2p8affineqb zmm6,zmm2,[rsi+3072],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+392]
vgf2p8affineqb zmm3,zmm2,[rsi+1088],0
vgf2p8affineqb zmm4,zmm2,[rsi+3136],0
vpbroadcastq zmm2,qword ptr [rcx+400]
vgf2p8affineqb zmm5,zmm2,[rsi+1152],0
vgf2p8affineqb zmm6,zmm2,[rsi+3200],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+408]
vgf2p8affineqb zmm3,zmm2,[rsi+1216],0
vgf2p8affineqb zmm4,zmm2,[rsi+3264],0
vpbroadcastq zmm2,qword ptr [rcx+416]
vgf2p8affineqb zmm5,zmm2,[rsi+1280],0
vgf2p8affineqb zmm6,zmm2,[rsi+3328],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+424]
vgf2p8affineqb zmm3,zmm2,[rsi+1344],0
vgf2p8affineqb zmm4,zmm2,[rsi+3392],0
vpbroadcastq zmm2,qword ptr [rcx+432]
vgf2p8affineqb zmm5,zmm2,[rsi+1408],0
vgf2p8affineqb zmm6,zmm2,[rsi+3456],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+440]
vgf2p8affineqb zmm3,zmm2,[rsi+1472],0
vgf2p8affineqb zmm4,zmm2,[rsi+3520],0
vpbroadcastq zmm2,qword ptr [rcx+448]
vgf2p8affineqb zmm5,zmm2,[rsi+1536],0
vgf2p8affineqb zmm6,zmm2,[rsi+3584],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+456]
vgf2p8affineqb zmm3,zmm2,[rsi+1600],0
vgf2p8affineqb zmm4,zmm2,[rsi+3648],0
vpbroadcastq zmm2,qword ptr [rcx+464]
vgf2p8affineqb zmm5,zmm2,[rsi+1664],0
vgf2p8affineqb zmm6,zmm2,[rsi+3712],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+472]
vgf2p8affineqb zmm3,zmm2,[rsi+1728],0
vgf2p8affineqb zmm4,zmm2,[rsi+3776],0
vpbroadcastq zmm2,qword ptr [rcx+480]
vgf2p8affineqb zmm5,zmm2,[rsi+1792],0
vgf2p8affineqb zmm6,zmm2,[rsi+3840],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+488]
vgf2p8affineqb zmm3,zmm2,[rsi+1856],0
vgf2p8affineqb zmm4,zmm2,[rsi+3904],0
vpbroadcastq zmm2,qword ptr [rcx+496]
vgf2p8affineqb zmm5,zmm2,[rsi+1920],0
vgf2p8affineqb zmm6,zmm2,[rsi+3968],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+504]
vgf2p8affineqb zmm3,zmm2,[rsi+1984],0
vgf2p8affineqb zmm4,zmm2,[rsi+4032],0
vpxorq zmm0,zmm0,zmm3
vpxorq zmm1,zmm1,zmm4
vmovdqa64 zmm2,[rip+.Lflock_c4_outeven]
vmovdqa64 zmm3,[rip+.Lflock_c4_outodd]
vmovdqa64 zmm4,zmm0
vpermt2b zmm0,zmm2,zmm1
vpermt2b zmm4,zmm3,zmm1
vmovdqu64 [rdx+128],zmm0
vmovdqu64 [rdx+192],zmm4
ret
.size flock_core_c4_preserved24_leaf,.-flock_core_c4_preserved24_leaf
.section .rodata
.p2align 6
.Lflock_c4_glo:
.quad 0,4,8,12,1,5,9,13
.Lflock_c4_ghi:
.quad 2,6,10,14,3,7,11,15
.Lflock_c4_octeven:
.byte 0,8,16,24,64,72,80,88,1,9,17,25,65,73,81,89,2,10,18,26,66,74,82,90,3,11,19,27,67,75,83,91,4,12,20,28,68,76,84,92,5,13,21,29,69,77,85,93,6,14,22,30,70,78,86,94,7,15,23,31,71,79,87,95
.Lflock_c4_octodd:
.byte 32,40,48,56,96,104,112,120,33,41,49,57,97,105,113,121,34,42,50,58,98,106,114,122,35,43,51,59,99,107,115,123,36,44,52,60,100,108,116,124,37,45,53,61,101,109,117,125,38,46,54,62,102,110,118,126,39,47,55,63,103,111,119,127
.Lflock_c4_outeven:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126
.Lflock_c4_outodd:
.byte 1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
"#
);
unsafe extern "C" {
    fn flock_core_c4_preserved24_leaf();
}
#[repr(align(64))]
struct Octs([u8; 512]);

#[inline(always)]
pub(super) unsafe fn fold(rows: *const u8, m: &CFoldMats, out: *mut F128) {
    let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
    unsafe {
        core::arch::asm!(
            "sub rsp,128", "call {leaf}", "add rsp,128",
            leaf=sym flock_core_c4_preserved24_leaf,
            in("rdi")rows, in("rsi")m.1.as_ptr(), in("rdx")out,
            in("rcx")octs.as_mut_ptr(),
            out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,
            out("zmm4")_,out("zmm5")_,out("zmm6")_,out("zmm7")_,
        );
    }
}

core::arch::global_asm!(
    r#".text
.p2align 5
.global flock_core_c4_boundary_pair_leaf
.hidden flock_core_c4_boundary_pair_leaf
.type flock_core_c4_boundary_pair_leaf,@function
flock_core_c4_boundary_pair_leaf:
vmovdqu64 zmm0, [rdi+128]
vmovdqu64 zmm1, [rdi+192]
vmovdqu64 zmm2, [rdi+256]
vmovdqu64 zmm3, [rdi+320]
vmovdqa64 zmm4, [rip+.Lflock_boundary_glo]
vmovdqa64 zmm5, [rip+.Lflock_boundary_ghi]
vmovdqa64 zmm6,zmm0
vpermt2q zmm0,zmm4,zmm1
vpermt2q zmm6,zmm5,zmm1
vmovdqa64 zmm7,zmm2
vpermt2q zmm2,zmm4,zmm3
vpermt2q zmm7,zmm5,zmm3
vmovdqa64 zmm4,[rip+.Lflock_boundary_octeven]
vmovdqa64 zmm5,[rip+.Lflock_boundary_octodd]
vmovdqa64 zmm1,zmm0
vpermt2b zmm0,zmm4,zmm2
vpermt2b zmm1,zmm5,zmm2
vmovdqa64 zmm3,zmm6
vpermt2b zmm6,zmm4,zmm7
vpermt2b zmm3,zmm5,zmm7
vmovdqu64 [rcx+0],zmm0
vmovdqu64 [rcx+64],zmm1
vmovdqu64 [rcx+128],zmm6
vmovdqu64 [rcx+192],zmm3

vpbroadcastq zmm2,qword ptr [rcx+0]
vgf2p8affineqb zmm0,zmm2,[rsi],0
vgf2p8affineqb zmm1,zmm2,[rsi+2048],0
vpbroadcastq zmm2,qword ptr [rcx+8]
vgf2p8affineqb zmm3,zmm2,[rsi+64],0
vgf2p8affineqb zmm4,zmm2,[rsi+2112],0
vpbroadcastq zmm2,qword ptr [rcx+16]
vgf2p8affineqb zmm5,zmm2,[rsi+128],0
vgf2p8affineqb zmm6,zmm2,[rsi+2176],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+24]
vgf2p8affineqb zmm3,zmm2,[rsi+192],0
vgf2p8affineqb zmm4,zmm2,[rsi+2240],0
vpbroadcastq zmm2,qword ptr [rcx+32]
vgf2p8affineqb zmm5,zmm2,[rsi+256],0
vgf2p8affineqb zmm6,zmm2,[rsi+2304],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+40]
vgf2p8affineqb zmm3,zmm2,[rsi+320],0
vgf2p8affineqb zmm4,zmm2,[rsi+2368],0
vpbroadcastq zmm2,qword ptr [rcx+48]
vgf2p8affineqb zmm5,zmm2,[rsi+384],0
vgf2p8affineqb zmm6,zmm2,[rsi+2432],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+56]
vgf2p8affineqb zmm3,zmm2,[rsi+448],0
vgf2p8affineqb zmm4,zmm2,[rsi+2496],0
vpbroadcastq zmm2,qword ptr [rcx+64]
vgf2p8affineqb zmm5,zmm2,[rsi+512],0
vgf2p8affineqb zmm6,zmm2,[rsi+2560],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+72]
vgf2p8affineqb zmm3,zmm2,[rsi+576],0
vgf2p8affineqb zmm4,zmm2,[rsi+2624],0
vpbroadcastq zmm2,qword ptr [rcx+80]
vgf2p8affineqb zmm5,zmm2,[rsi+640],0
vgf2p8affineqb zmm6,zmm2,[rsi+2688],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+88]
vgf2p8affineqb zmm3,zmm2,[rsi+704],0
vgf2p8affineqb zmm4,zmm2,[rsi+2752],0
vpbroadcastq zmm2,qword ptr [rcx+96]
vgf2p8affineqb zmm5,zmm2,[rsi+768],0
vgf2p8affineqb zmm6,zmm2,[rsi+2816],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+104]
vgf2p8affineqb zmm3,zmm2,[rsi+832],0
vgf2p8affineqb zmm4,zmm2,[rsi+2880],0
vpbroadcastq zmm2,qword ptr [rcx+112]
vgf2p8affineqb zmm5,zmm2,[rsi+896],0
vgf2p8affineqb zmm6,zmm2,[rsi+2944],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+120]
vgf2p8affineqb zmm3,zmm2,[rsi+960],0
vgf2p8affineqb zmm4,zmm2,[rsi+3008],0
vpbroadcastq zmm2,qword ptr [rcx+128]
vgf2p8affineqb zmm5,zmm2,[rsi+1024],0
vgf2p8affineqb zmm6,zmm2,[rsi+3072],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+136]
vgf2p8affineqb zmm3,zmm2,[rsi+1088],0
vgf2p8affineqb zmm4,zmm2,[rsi+3136],0
vpbroadcastq zmm2,qword ptr [rcx+144]
vgf2p8affineqb zmm5,zmm2,[rsi+1152],0
vgf2p8affineqb zmm6,zmm2,[rsi+3200],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+152]
vgf2p8affineqb zmm3,zmm2,[rsi+1216],0
vgf2p8affineqb zmm4,zmm2,[rsi+3264],0
vpbroadcastq zmm2,qword ptr [rcx+160]
vgf2p8affineqb zmm5,zmm2,[rsi+1280],0
vgf2p8affineqb zmm6,zmm2,[rsi+3328],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+168]
vgf2p8affineqb zmm3,zmm2,[rsi+1344],0
vgf2p8affineqb zmm4,zmm2,[rsi+3392],0
vpbroadcastq zmm2,qword ptr [rcx+176]
vgf2p8affineqb zmm5,zmm2,[rsi+1408],0
vgf2p8affineqb zmm6,zmm2,[rsi+3456],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+184]
vgf2p8affineqb zmm3,zmm2,[rsi+1472],0
vgf2p8affineqb zmm4,zmm2,[rsi+3520],0
vpbroadcastq zmm2,qword ptr [rcx+192]
vgf2p8affineqb zmm5,zmm2,[rsi+1536],0
vgf2p8affineqb zmm6,zmm2,[rsi+3584],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+200]
vgf2p8affineqb zmm3,zmm2,[rsi+1600],0
vgf2p8affineqb zmm4,zmm2,[rsi+3648],0
vpbroadcastq zmm2,qword ptr [rcx+208]
vgf2p8affineqb zmm5,zmm2,[rsi+1664],0
vgf2p8affineqb zmm6,zmm2,[rsi+3712],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+216]
vgf2p8affineqb zmm3,zmm2,[rsi+1728],0
vgf2p8affineqb zmm4,zmm2,[rsi+3776],0
vpbroadcastq zmm2,qword ptr [rcx+224]
vgf2p8affineqb zmm5,zmm2,[rsi+1792],0
vgf2p8affineqb zmm6,zmm2,[rsi+3840],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+232]
vgf2p8affineqb zmm3,zmm2,[rsi+1856],0
vgf2p8affineqb zmm4,zmm2,[rsi+3904],0
vpbroadcastq zmm2,qword ptr [rcx+240]
vgf2p8affineqb zmm5,zmm2,[rsi+1920],0
vgf2p8affineqb zmm6,zmm2,[rsi+3968],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+248]
vgf2p8affineqb zmm3,zmm2,[rsi+1984],0
vgf2p8affineqb zmm4,zmm2,[rsi+4032],0
vpxorq zmm0,zmm0,zmm3
vpxorq zmm1,zmm1,zmm4

vmovdqa64 zmm2,[rip+.Lflock_boundary_outlo]
vmovdqa64 zmm3,[rip+.Lflock_boundary_outhi]
vmovdqa64 zmm8,zmm0
vmovdqa64 zmm9,zmm0
vpermt2b zmm8,zmm2,zmm1
vpermt2b zmm9,zmm3,zmm1
vmovdqu64 zmm0, [rdi+384]
vmovdqu64 zmm1, [rdi+448]
vmovdqu64 zmm2, [rdi+1536]
vmovdqu64 zmm3, [rdi+1600]
vmovdqa64 zmm4, [rip+.Lflock_boundary_glo]
vmovdqa64 zmm5, [rip+.Lflock_boundary_ghi]
vmovdqa64 zmm6,zmm0
vpermt2q zmm0,zmm4,zmm1
vpermt2q zmm6,zmm5,zmm1
vmovdqa64 zmm7,zmm2
vpermt2q zmm2,zmm4,zmm3
vpermt2q zmm7,zmm5,zmm3
vmovdqa64 zmm4,[rip+.Lflock_boundary_octeven]
vmovdqa64 zmm5,[rip+.Lflock_boundary_octodd]
vmovdqa64 zmm1,zmm0
vpermt2b zmm0,zmm4,zmm2
vpermt2b zmm1,zmm5,zmm2
vmovdqa64 zmm3,zmm6
vpermt2b zmm6,zmm4,zmm7
vpermt2b zmm3,zmm5,zmm7
vmovdqu64 [rcx+0],zmm0
vmovdqu64 [rcx+64],zmm1
vmovdqu64 [rcx+128],zmm6
vmovdqu64 [rcx+192],zmm3

vpbroadcastq zmm2,qword ptr [rcx+0]
vgf2p8affineqb zmm0,zmm2,[rsi],0
vgf2p8affineqb zmm1,zmm2,[rsi+2048],0
vpbroadcastq zmm2,qword ptr [rcx+8]
vgf2p8affineqb zmm3,zmm2,[rsi+64],0
vgf2p8affineqb zmm4,zmm2,[rsi+2112],0
vpbroadcastq zmm2,qword ptr [rcx+16]
vgf2p8affineqb zmm5,zmm2,[rsi+128],0
vgf2p8affineqb zmm6,zmm2,[rsi+2176],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+24]
vgf2p8affineqb zmm3,zmm2,[rsi+192],0
vgf2p8affineqb zmm4,zmm2,[rsi+2240],0
vpbroadcastq zmm2,qword ptr [rcx+32]
vgf2p8affineqb zmm5,zmm2,[rsi+256],0
vgf2p8affineqb zmm6,zmm2,[rsi+2304],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+40]
vgf2p8affineqb zmm3,zmm2,[rsi+320],0
vgf2p8affineqb zmm4,zmm2,[rsi+2368],0
vpbroadcastq zmm2,qword ptr [rcx+48]
vgf2p8affineqb zmm5,zmm2,[rsi+384],0
vgf2p8affineqb zmm6,zmm2,[rsi+2432],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+56]
vgf2p8affineqb zmm3,zmm2,[rsi+448],0
vgf2p8affineqb zmm4,zmm2,[rsi+2496],0
vpbroadcastq zmm2,qword ptr [rcx+64]
vgf2p8affineqb zmm5,zmm2,[rsi+512],0
vgf2p8affineqb zmm6,zmm2,[rsi+2560],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+72]
vgf2p8affineqb zmm3,zmm2,[rsi+576],0
vgf2p8affineqb zmm4,zmm2,[rsi+2624],0
vpbroadcastq zmm2,qword ptr [rcx+80]
vgf2p8affineqb zmm5,zmm2,[rsi+640],0
vgf2p8affineqb zmm6,zmm2,[rsi+2688],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+88]
vgf2p8affineqb zmm3,zmm2,[rsi+704],0
vgf2p8affineqb zmm4,zmm2,[rsi+2752],0
vpbroadcastq zmm2,qword ptr [rcx+96]
vgf2p8affineqb zmm5,zmm2,[rsi+768],0
vgf2p8affineqb zmm6,zmm2,[rsi+2816],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+104]
vgf2p8affineqb zmm3,zmm2,[rsi+832],0
vgf2p8affineqb zmm4,zmm2,[rsi+2880],0
vpbroadcastq zmm2,qword ptr [rcx+112]
vgf2p8affineqb zmm5,zmm2,[rsi+896],0
vgf2p8affineqb zmm6,zmm2,[rsi+2944],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+120]
vgf2p8affineqb zmm3,zmm2,[rsi+960],0
vgf2p8affineqb zmm4,zmm2,[rsi+3008],0
vpbroadcastq zmm2,qword ptr [rcx+128]
vgf2p8affineqb zmm5,zmm2,[rsi+1024],0
vgf2p8affineqb zmm6,zmm2,[rsi+3072],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+136]
vgf2p8affineqb zmm3,zmm2,[rsi+1088],0
vgf2p8affineqb zmm4,zmm2,[rsi+3136],0
vpbroadcastq zmm2,qword ptr [rcx+144]
vgf2p8affineqb zmm5,zmm2,[rsi+1152],0
vgf2p8affineqb zmm6,zmm2,[rsi+3200],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+152]
vgf2p8affineqb zmm3,zmm2,[rsi+1216],0
vgf2p8affineqb zmm4,zmm2,[rsi+3264],0
vpbroadcastq zmm2,qword ptr [rcx+160]
vgf2p8affineqb zmm5,zmm2,[rsi+1280],0
vgf2p8affineqb zmm6,zmm2,[rsi+3328],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+168]
vgf2p8affineqb zmm3,zmm2,[rsi+1344],0
vgf2p8affineqb zmm4,zmm2,[rsi+3392],0
vpbroadcastq zmm2,qword ptr [rcx+176]
vgf2p8affineqb zmm5,zmm2,[rsi+1408],0
vgf2p8affineqb zmm6,zmm2,[rsi+3456],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+184]
vgf2p8affineqb zmm3,zmm2,[rsi+1472],0
vgf2p8affineqb zmm4,zmm2,[rsi+3520],0
vpbroadcastq zmm2,qword ptr [rcx+192]
vgf2p8affineqb zmm5,zmm2,[rsi+1536],0
vgf2p8affineqb zmm6,zmm2,[rsi+3584],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+200]
vgf2p8affineqb zmm3,zmm2,[rsi+1600],0
vgf2p8affineqb zmm4,zmm2,[rsi+3648],0
vpbroadcastq zmm2,qword ptr [rcx+208]
vgf2p8affineqb zmm5,zmm2,[rsi+1664],0
vgf2p8affineqb zmm6,zmm2,[rsi+3712],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+216]
vgf2p8affineqb zmm3,zmm2,[rsi+1728],0
vgf2p8affineqb zmm4,zmm2,[rsi+3776],0
vpbroadcastq zmm2,qword ptr [rcx+224]
vgf2p8affineqb zmm5,zmm2,[rsi+1792],0
vgf2p8affineqb zmm6,zmm2,[rsi+3840],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+232]
vgf2p8affineqb zmm3,zmm2,[rsi+1856],0
vgf2p8affineqb zmm4,zmm2,[rsi+3904],0
vpbroadcastq zmm2,qword ptr [rcx+240]
vgf2p8affineqb zmm5,zmm2,[rsi+1920],0
vgf2p8affineqb zmm6,zmm2,[rsi+3968],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+248]
vgf2p8affineqb zmm3,zmm2,[rsi+1984],0
vgf2p8affineqb zmm4,zmm2,[rsi+4032],0
vpxorq zmm0,zmm0,zmm3
vpxorq zmm1,zmm1,zmm4

vmovdqa64 zmm2,[rip+.Lflock_boundary_outlo]
vmovdqa64 zmm3,[rip+.Lflock_boundary_outhi]
vmovdqa64 zmm10,zmm0
vmovdqa64 zmm11,zmm0
vpermt2b zmm10,zmm2,zmm1
vpermt2b zmm11,zmm3,zmm1
vmovdqu64 zmm0, [rdi+1664]
vmovdqu64 zmm1, [rdi+1728]
vmovdqu64 zmm2, [rdi+1792]
vmovdqu64 zmm3, [rdi+1856]
vmovdqa64 zmm4, [rip+.Lflock_boundary_glo]
vmovdqa64 zmm5, [rip+.Lflock_boundary_ghi]
vmovdqa64 zmm6,zmm0
vpermt2q zmm0,zmm4,zmm1
vpermt2q zmm6,zmm5,zmm1
vmovdqa64 zmm7,zmm2
vpermt2q zmm2,zmm4,zmm3
vpermt2q zmm7,zmm5,zmm3
vmovdqa64 zmm4,[rip+.Lflock_boundary_octeven]
vmovdqa64 zmm5,[rip+.Lflock_boundary_octodd]
vmovdqa64 zmm1,zmm0
vpermt2b zmm0,zmm4,zmm2
vpermt2b zmm1,zmm5,zmm2
vmovdqa64 zmm3,zmm6
vpermt2b zmm6,zmm4,zmm7
vpermt2b zmm3,zmm5,zmm7
vmovdqu64 [rcx+0],zmm0
vmovdqu64 [rcx+64],zmm1
vmovdqu64 [rcx+128],zmm6
vmovdqu64 [rcx+192],zmm3

vpbroadcastq zmm2,qword ptr [rcx+0]
vgf2p8affineqb zmm0,zmm2,[rsi],0
vgf2p8affineqb zmm1,zmm2,[rsi+2048],0
vpbroadcastq zmm2,qword ptr [rcx+8]
vgf2p8affineqb zmm3,zmm2,[rsi+64],0
vgf2p8affineqb zmm4,zmm2,[rsi+2112],0
vpbroadcastq zmm2,qword ptr [rcx+16]
vgf2p8affineqb zmm5,zmm2,[rsi+128],0
vgf2p8affineqb zmm6,zmm2,[rsi+2176],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+24]
vgf2p8affineqb zmm3,zmm2,[rsi+192],0
vgf2p8affineqb zmm4,zmm2,[rsi+2240],0
vpbroadcastq zmm2,qword ptr [rcx+32]
vgf2p8affineqb zmm5,zmm2,[rsi+256],0
vgf2p8affineqb zmm6,zmm2,[rsi+2304],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+40]
vgf2p8affineqb zmm3,zmm2,[rsi+320],0
vgf2p8affineqb zmm4,zmm2,[rsi+2368],0
vpbroadcastq zmm2,qword ptr [rcx+48]
vgf2p8affineqb zmm5,zmm2,[rsi+384],0
vgf2p8affineqb zmm6,zmm2,[rsi+2432],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+56]
vgf2p8affineqb zmm3,zmm2,[rsi+448],0
vgf2p8affineqb zmm4,zmm2,[rsi+2496],0
vpbroadcastq zmm2,qword ptr [rcx+64]
vgf2p8affineqb zmm5,zmm2,[rsi+512],0
vgf2p8affineqb zmm6,zmm2,[rsi+2560],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+72]
vgf2p8affineqb zmm3,zmm2,[rsi+576],0
vgf2p8affineqb zmm4,zmm2,[rsi+2624],0
vpbroadcastq zmm2,qword ptr [rcx+80]
vgf2p8affineqb zmm5,zmm2,[rsi+640],0
vgf2p8affineqb zmm6,zmm2,[rsi+2688],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+88]
vgf2p8affineqb zmm3,zmm2,[rsi+704],0
vgf2p8affineqb zmm4,zmm2,[rsi+2752],0
vpbroadcastq zmm2,qword ptr [rcx+96]
vgf2p8affineqb zmm5,zmm2,[rsi+768],0
vgf2p8affineqb zmm6,zmm2,[rsi+2816],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+104]
vgf2p8affineqb zmm3,zmm2,[rsi+832],0
vgf2p8affineqb zmm4,zmm2,[rsi+2880],0
vpbroadcastq zmm2,qword ptr [rcx+112]
vgf2p8affineqb zmm5,zmm2,[rsi+896],0
vgf2p8affineqb zmm6,zmm2,[rsi+2944],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+120]
vgf2p8affineqb zmm3,zmm2,[rsi+960],0
vgf2p8affineqb zmm4,zmm2,[rsi+3008],0
vpbroadcastq zmm2,qword ptr [rcx+128]
vgf2p8affineqb zmm5,zmm2,[rsi+1024],0
vgf2p8affineqb zmm6,zmm2,[rsi+3072],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+136]
vgf2p8affineqb zmm3,zmm2,[rsi+1088],0
vgf2p8affineqb zmm4,zmm2,[rsi+3136],0
vpbroadcastq zmm2,qword ptr [rcx+144]
vgf2p8affineqb zmm5,zmm2,[rsi+1152],0
vgf2p8affineqb zmm6,zmm2,[rsi+3200],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+152]
vgf2p8affineqb zmm3,zmm2,[rsi+1216],0
vgf2p8affineqb zmm4,zmm2,[rsi+3264],0
vpbroadcastq zmm2,qword ptr [rcx+160]
vgf2p8affineqb zmm5,zmm2,[rsi+1280],0
vgf2p8affineqb zmm6,zmm2,[rsi+3328],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+168]
vgf2p8affineqb zmm3,zmm2,[rsi+1344],0
vgf2p8affineqb zmm4,zmm2,[rsi+3392],0
vpbroadcastq zmm2,qword ptr [rcx+176]
vgf2p8affineqb zmm5,zmm2,[rsi+1408],0
vgf2p8affineqb zmm6,zmm2,[rsi+3456],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+184]
vgf2p8affineqb zmm3,zmm2,[rsi+1472],0
vgf2p8affineqb zmm4,zmm2,[rsi+3520],0
vpbroadcastq zmm2,qword ptr [rcx+192]
vgf2p8affineqb zmm5,zmm2,[rsi+1536],0
vgf2p8affineqb zmm6,zmm2,[rsi+3584],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+200]
vgf2p8affineqb zmm3,zmm2,[rsi+1600],0
vgf2p8affineqb zmm4,zmm2,[rsi+3648],0
vpbroadcastq zmm2,qword ptr [rcx+208]
vgf2p8affineqb zmm5,zmm2,[rsi+1664],0
vgf2p8affineqb zmm6,zmm2,[rsi+3712],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+216]
vgf2p8affineqb zmm3,zmm2,[rsi+1728],0
vgf2p8affineqb zmm4,zmm2,[rsi+3776],0
vpbroadcastq zmm2,qword ptr [rcx+224]
vgf2p8affineqb zmm5,zmm2,[rsi+1792],0
vgf2p8affineqb zmm6,zmm2,[rsi+3840],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+232]
vgf2p8affineqb zmm3,zmm2,[rsi+1856],0
vgf2p8affineqb zmm4,zmm2,[rsi+3904],0
vpbroadcastq zmm2,qword ptr [rcx+240]
vgf2p8affineqb zmm5,zmm2,[rsi+1920],0
vgf2p8affineqb zmm6,zmm2,[rsi+3968],0
vpternlogq zmm0,zmm3,zmm5,0x96
vpternlogq zmm1,zmm4,zmm6,0x96
vpbroadcastq zmm2,qword ptr [rcx+248]
vgf2p8affineqb zmm3,zmm2,[rsi+1984],0
vgf2p8affineqb zmm4,zmm2,[rsi+4032],0
vpxorq zmm0,zmm0,zmm3
vpxorq zmm1,zmm1,zmm4

vmovdqa64 zmm2,[rip+.Lflock_boundary_outlo]
vmovdqa64 zmm3,[rip+.Lflock_boundary_outhi]
vmovdqa64 zmm12,zmm0
vmovdqa64 zmm13,zmm0
vpermt2b zmm12,zmm2,zmm1
vpermt2b zmm13,zmm3,zmm1
vmovdqu64 zmm0,[r8+0]
vshufi64x2 zmm1,zmm0,zmm8,0x44
vshufi64x2 zmm2,zmm0,zmm8,0xee
vshufi64x2 zmm3,zmm9,zmm10,0x44
vshufi64x2 zmm4,zmm9,zmm10,0xee
vshufi64x2 zmm5,zmm1,zmm3,0x88
vmovdqu64 [rdx+0],zmm5
vshufi64x2 zmm5,zmm1,zmm3,0xdd
vmovdqu64 [rdx+64],zmm5
vshufi64x2 zmm5,zmm2,zmm4,0x88
vmovdqu64 [rdx+128],zmm5
vshufi64x2 zmm5,zmm2,zmm4,0xdd
vmovdqu64 [rdx+192],zmm5
vmovdqu64 zmm0,[r8+64]
vshufi64x2 zmm1,zmm11,zmm12,0x44
vshufi64x2 zmm2,zmm11,zmm12,0xee
vshufi64x2 zmm3,zmm13,zmm0,0x44
vshufi64x2 zmm4,zmm13,zmm0,0xee
vshufi64x2 zmm5,zmm1,zmm3,0x88
vmovdqu64 [rdx+256],zmm5
vshufi64x2 zmm5,zmm1,zmm3,0xdd
vmovdqu64 [rdx+320],zmm5
vshufi64x2 zmm5,zmm2,zmm4,0x88
vmovdqu64 [rdx+384],zmm5
vshufi64x2 zmm5,zmm2,zmm4,0xdd
vmovdqu64 [rdx+448],zmm5
ret
.size flock_core_c4_boundary_pair_leaf,.-flock_core_c4_boundary_pair_leaf
.section .rodata
.p2align 6
.Lflock_boundary_glo:
.quad 0,4,8,12,1,5,9,13
.Lflock_boundary_ghi:
.quad 2,6,10,14,3,7,11,15
.Lflock_boundary_octeven:
.byte 0,8,16,24,64,72,80,88,1,9,17,25,65,73,81,89,2,10,18,26,66,74,82,90,3,11,19,27,67,75,83,91,4,12,20,28,68,76,84,92,5,13,21,29,69,77,85,93,6,14,22,30,70,78,86,94,7,15,23,31,71,79,87,95
.Lflock_boundary_octodd:
.byte 32,40,48,56,96,104,112,120,33,41,49,57,97,105,113,121,34,42,50,58,98,106,114,122,35,43,51,59,99,107,115,123,36,44,52,60,100,108,116,124,37,45,53,61,101,109,117,125,38,46,54,62,102,110,118,126,39,47,55,63,103,111,119,127
.Lflock_boundary_outeven:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126
.Lflock_boundary_outodd:
.byte 1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127

.p2align 6
.Lflock_boundary_outlo:
.byte 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,2,10,18,26,34,42,50,58,66,74,82,90,98,106,114,122,3,11,19,27,35,43,51,59,67,75,83,91,99,107,115,123

.p2align 6
.Lflock_boundary_outhi:
.byte 4,12,20,28,36,44,52,60,68,76,84,92,100,108,116,124,5,13,21,29,37,45,53,61,69,77,85,93,101,109,117,125,6,14,22,30,38,46,54,62,70,78,86,94,102,110,118,126,7,15,23,31,39,47,55,63,71,79,87,95,103,111,119,127
"#
);
unsafe extern "C" {
    fn flock_core_c4_boundary_pair_leaf();
}
#[inline(always)]
pub(super) unsafe fn boundary_pair(
    rows: *const u8,
    m: &CFoldMats,
    out: *mut F128,
    known: &[F128; 8],
) {
    let mut octs = core::mem::MaybeUninit::<Octs>::uninit();
    unsafe {
        core::arch::asm!("sub rsp,128","call {leaf}","add rsp,128",leaf=sym flock_core_c4_boundary_pair_leaf,
 in("rdi")rows,in("rsi")m.1.as_ptr(),in("rdx")out,in("rcx")octs.as_mut_ptr(),in("r8")known.as_ptr(),
out("zmm0")_,out("zmm1")_,out("zmm2")_,out("zmm3")_,out("zmm4")_,out("zmm5")_,out("zmm6")_,out("zmm7")_,out("zmm8")_,out("zmm9")_,out("zmm10")_,out("zmm11")_,out("zmm12")_,out("zmm13")_);
    }
}
