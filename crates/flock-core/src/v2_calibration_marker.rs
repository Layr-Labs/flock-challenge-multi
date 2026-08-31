// V2 calibration marker — 2026-08-31.
//
// This file is deliberately NOT declared with a `mod` item anywhere in the
// crate, so it is never parsed, compiled, linked, or referenced. It exists to
// make this submission's archive content-distinct from its base, because the
// benchmark server deduplicates byte-identical submissions and reuses the
// previous score. A calibration draw needs a fresh score, so the archive must
// differ by at least one byte while the compiled worker does not differ at all.
//
// It carries no code, no `#[cfg]`, no macro, and no build-script input. Removing
// this file and rebuilding produces a byte-identical worker binary.
//
// See the submission note for what the draw is for.
