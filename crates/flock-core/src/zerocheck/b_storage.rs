//! Owned and borrowed forms of the prover's packed B stream.
//!
//! Residual storage has a real physical extent distinct from its logical
//! Boolean-vector extent. It never dereferences to a fictitious dense slice.

use super::b_residual::{ResidualB, ResidualView};
use crate::field::F128;

pub enum BStorage {
    Dense(Vec<F128>),
    Residual(ResidualB),
}

#[derive(Clone, Copy)]
pub enum PackedB<'a> {
    Dense(&'a [u8]),
    Residual(ResidualView<'a>),
}

impl BStorage {
    pub fn view(&self) -> PackedB<'_> {
        match self {
            Self::Dense(v) => PackedB::Dense(unsafe {
                core::slice::from_raw_parts(v.as_ptr().cast(), core::mem::size_of_val(&v[..]))
            }),
            Self::Residual(v) => PackedB::Residual(v.view()),
        }
    }

    pub fn dense_f128(&self) -> Option<&[F128]> {
        match self {
            Self::Dense(v) => Some(v),
            Self::Residual(_) => None,
        }
    }

    pub fn recycle(self) {
        match self {
            Self::Dense(v) => crate::scratch::give_f128(v),
            Self::Residual(v) => v.recycle(),
        }
    }

    /// Explicit, fully allocated fallback for a dense-only prover route.
    pub fn into_dense(self) -> Self {
        match self {
            Self::Dense(_) => self,
            Self::Residual(v) => {
                let bytes = v.view().to_dense_bytes();
                let mut dense = crate::scratch::take_f128(bytes.len() / 16);
                // Both allocations have their actual initialized extent.
                // Every u128 bit pattern is a valid polynomial field element.
                unsafe {
                    core::ptr::copy_nonoverlapping(
                        bytes.as_ptr(),
                        dense.as_mut_ptr().cast(),
                        bytes.len(),
                    );
                }
                Self::Dense(dense)
            }
        }
    }
}

impl<'a> PackedB<'a> {
    #[inline]
    pub fn logical_bytes(self) -> usize {
        match self {
            Self::Dense(v) => v.len(),
            Self::Residual(v) => v.logical_bytes(),
        }
    }

    #[inline]
    pub fn dense(self) -> Option<&'a [u8]> {
        match self {
            Self::Dense(v) => Some(v),
            Self::Residual(_) => None,
        }
    }

    #[inline]
    pub fn residual(self) -> Option<ResidualView<'a>> {
        match self {
            Self::Dense(_) => None,
            Self::Residual(v) => Some(v),
        }
    }

    pub fn to_dense_bytes(self) -> Vec<u8> {
        match self {
            Self::Dense(v) => v.to_vec(),
            Self::Residual(v) => v.to_dense_bytes(),
        }
    }
}
