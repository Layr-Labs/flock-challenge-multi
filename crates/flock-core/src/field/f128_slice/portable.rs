use crate::field::F128;

#[inline]
pub(super) fn fold_pairs(src: &[F128], base: usize, dst: &mut [F128], r: F128) {
    // Char-2: even*(1+r) + odd*r = even + r*(even+odd). One mul per pair.
    for (t, value) in dst.iter_mut().enumerate() {
        let s = 2 * (base + t);
        let even = src[s];
        *value = even + r * (even + src[s + 1]);
    }
}

#[inline]
pub(super) fn fold_two_and_msg(
    f: &[F128],
    b: &[F128],
    base: usize,
    fc: &mut [F128],
    bc: &mut [F128],
    r: F128,
) -> (F128, F128) {
    let len = fc.len();
    assert_eq!(bc.len(), len);
    let mut u0 = F128::ZERO;
    let mut u2 = F128::ZERO;
    let mut t = 0;
    while t + 1 < len {
        let s = 2 * (base + t);
        let f0 = f[s] + r * (f[s] + f[s + 1]);
        let f1 = f[s + 2] + r * (f[s + 2] + f[s + 3]);
        let b0 = b[s] + r * (b[s] + b[s + 1]);
        let b1 = b[s + 2] + r * (b[s + 2] + b[s + 3]);
        fc[t] = f0;
        fc[t + 1] = f1;
        bc[t] = b0;
        bc[t + 1] = b1;
        u0 += f0 * b0;
        u2 += (f0 + f1) * (b0 + b1);
        t += 2;
    }
    if t < len {
        let s = 2 * (base + t);
        let f0 = f[s] + r * (f[s] + f[s + 1]);
        let b0 = b[s] + r * (b[s] + b[s + 1]);
        fc[t] = f0;
        bc[t] = b0;
    }
    (u0, u2)
}

#[inline]
pub(super) fn fold4_nested(src: &[F128], dst: &mut [F128], r0: F128, r1: F128) {
    // Nested pair-fold: r0 on (a0,a1) and (a2,a3), then r1 on (low, high).
    for (t, value) in dst.iter_mut().enumerate() {
        let a0 = src[4 * t];
        let a1 = src[4 * t + 1];
        let a2 = src[4 * t + 2];
        let a3 = src[4 * t + 3];
        let low = a0 + r0 * (a0 + a1);
        let high = a2 + r0 * (a2 + a3);
        *value = low + r1 * (low + high);
    }
}
