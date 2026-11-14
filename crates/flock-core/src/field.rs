//! Binary field arithmetic.
//!
//! - [`F8`]   — GF(2^8) with AES polynomial x^8 + x^4 + x^3 + x + 1
//! - [`F128`] — GF(2^128) in GHASH form, polynomial x^128 + x^7 + x^2 + x + 1
//! - [`F256Unreduced`] — 256-bit unreduced GHASH products, for deferred reduction
//!
//! This module is a facade only: it declares the `gf2_8`, `gf2_128` and
//! `phi8` submodules plus the crate-internal `f128_slice` helpers and
//! re-exports their public items, so it defines no field types, tables or
//! kernels of its own and adds no runtime work to the measured path.
//!
//! `PHI_8_TABLE` / `phi8` re-export the GF(2^8) -> GF(2^128)-GHASH subfield
//! embedding, and `mul_by_x` comes from the GHASH field, so downstream code
//! reaches every field operation through this one facade.

pub mod gf2_128;
pub mod gf2_8;
pub mod phi8;

pub(crate) mod f128_slice;

pub use gf2_8::F8;
pub use gf2_128::{F128, F256Unreduced, mul_by_x};
pub use phi8::{PHI_8_TABLE, phi8};
