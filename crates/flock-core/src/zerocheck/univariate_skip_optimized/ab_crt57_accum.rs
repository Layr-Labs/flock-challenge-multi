// Exact degree13-by-degree15 convolution over AES GF256, via finite CRT
// of degree26 and the top three coefficients (the infinity residue).
// Finite factors: x^3,(x+1)^3,x^2+x+1,0xb,0xd,0x13,0x19,0x1f.
// All evaluation and reconstruction maps have binary coefficients. The
// physical gamma=2 / phi8 encoding and the parent's matrix guard are unchanged.
// The 29 residue planes are converted with constant maps that compose CRT
// reconstruction with the original canonical BASIS_MATRICES.
use core::arch::global_asm;
global_asm!(include_str!("ab_crt57_accum.S"), options(raw));
const FORMS: [u16; 57] = [21140,12684,25368,38053,50737,35939,19026,10570,48623,44819,35247,9916,39665,13794,19832,30874,61749,27588,25722,31432,7858,46811,44175,51445,28086,56173,62865,15716,60195,18348,8192,16384,4,2,1,32768,3,5,49152,40960,13107,29413,59859,29929,40250,14964,42830,20125,58827,38702,47474,11868,23737,65535,52428,21845,43690];
const RECONSTRUCTION: [u32; 29] = [38044809, 42272010, 50726412, 55834968, 66586608, 33817608, 24080232, 48160464, 45876600, 57935592, 14942664, 64227240, 27525960, 55051920, 7017352, 14034704, 28069408, 56138816, 49315624, 65860168, 30795912, 61591824, 59473096, 18544008, 37088016, 40360504, 304358472, 169088040, 101452824];
pub(super) fn enabled() -> bool {
    static ON: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
        std::env::var_os("FLOCK_NO_AB_CRT57").is_none()
    });
    *ON
}
pub(super) fn push_row(coefficients: &[u8; 16], out: &mut Vec<u64>) {
    for form in FORMS {
        let mut mask = form;
        let mut coefficient = 0u8;
        while mask != 0 {
            coefficient ^= coefficients[mask.trailing_zeros() as usize];
            mask &= mask - 1;
        }
        out.push(super::GF8_MATRICES[coefficient as usize]);
    }
}
pub(super) fn pack(windows: Vec<u64>) -> Vec<u64> {
    assert_eq!(windows.len(), 32 * 57);
    let mut packed = Vec::with_capacity(windows.len());
    let mut first = 0;
    for count in [30, 27] {
        for window in 0..32 {
            packed.extend_from_slice(&windows[window * 57 + first..window * 57 + first + count]);
        }
        first += count;
    }
    packed
}
const fn basis_maps() -> [[u64; 464]; 2] {
    let mut result = [[0u64; 464]; 2];
    let mut bank = 0;
    while bank < 2 {
        let mut residue = 0;
        while residue < 29 {
            let mut byte = 0;
            while byte < 16 {
                let mut bit = 0;
                while bit < 29 {
                    if (RECONSTRUCTION[residue] >> bit) & 1 != 0 {
                        result[bank][residue * 16 + byte] ^=
                            super::BASIS_MATRICES[(bit + bank * 2) * 16 + byte];
                    }
                    bit += 1;
                }
                byte += 1;
            }
            residue += 1;
        }
        bank += 1;
    }
    result
}
const BASIS: [[u64; 464]; 2] = basis_maps();
type Bank = unsafe extern "C" fn(*const u8, *const u64, *mut u8);
unsafe extern "C" {
    fn flock_ab_crt57_bank_m0(source: *const u8, matrices: *const u64, residues: *mut u8);
    fn flock_ab_crt57_bank_m1(source: *const u8, matrices: *const u64, residues: *mut u8);
    fn flock_ab_crt57_bank_m2(source: *const u8, matrices: *const u64, residues: *mut u8);
    fn flock_ab_crt57_finalize(residues: *const u8, matrices: *const u64, out: *mut u8);
}
// SAFETY: caller validates the complete NS32p band, 32*57 matrices, mode,
// aligned scratch (at least29*64bytes), and all128KiB output bytes. Every
// residue starts from zero in a register and is stored before conversion.
pub(super) unsafe fn run(
    rows: *const u8, matrices: *const u64, scratch: *mut u8,
    out: *mut u8, mode: usize,
) {
    unsafe {
        let bank: Bank = match mode {
            0 => flock_ab_crt57_bank_m0,
            1 => flock_ab_crt57_bank_m1,
            2 => flock_ab_crt57_bank_m2,
            _ => unreachable!(),
        };
        for pair in 0..64 {
            let source = rows.add(pair * 1792);
            bank(source, matrices, scratch);
            flock_ab_crt57_finalize(scratch, BASIS[1].as_ptr(), out.add(2 * pair * 1024));
            bank(source.add(896), matrices, scratch);
            flock_ab_crt57_finalize(scratch, BASIS[0].as_ptr(), out.add((2 * pair + 1) * 1024));
        }
    }
}
