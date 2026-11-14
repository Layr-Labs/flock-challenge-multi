//! Experimental output-owned root fold. Same leaf algebra and source bytes;
//! trades shared matrix reads for a smaller, worker-private plane working set.
use super::*;

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct OwnedPlane([core::mem::MaybeUninit<u8>; 1024]);

impl RootTileCache {
    pub(super) fn fold_block_owned(
        &self,
        logical_eq8: &(impl Fn(usize) -> [F128; 8] + Sync),
    ) -> Vec<F128> {
        assert!(self.word_major && self.fixed_roots && self.generator.is_none());
        assert!(self.tiles > 0 && self.blocks > 0);
        static PREFETCH: std::sync::LazyLock<bool> = std::sync::LazyLock::new(|| {
            std::env::var_os("FLOCK_NO_ROOT_CACHE_PREFETCH").is_none()
        });
        static WORD_BATCH: std::sync::LazyLock<usize> = std::sync::LazyLock::new(|| {
            std::env::var("FLOCK_ROOT_FOLD_BATCH")
                .ok().and_then(|s| s.parse().ok())
                .filter(|n| (1..=4).contains(n)).unwrap_or(3)
        });
        let batch = *WORD_BATCH;
        // Unlike the tile-owned route, these matrices serve all block owners.
        // Build each one once from this invocation's challenge, never reuse
        // across proofs or between the R1 C-arm and lincheck.
        crate::rstrace::ev("rf:bo_m0", 0);
        let mut matrices = vec![[0u64; 128]; self.tiles];
        matrices.par_iter_mut().enumerate().for_each(|(tile, matrix)| {
            for stripe in 0..DIRECT_FOLD_TILE_STRIPES {
                let eq8 = logical_eq8(8 * (tile * DIRECT_FOLD_TILE_STRIPES + stripe));
                kernels::fold_mats_from_basis(&eq8, &mut matrix[stripe * 16..(stripe + 1) * 16]);
            }
        });
        crate::rstrace::ev("rf:bo_m1", 0);
        let mut planes = vec![OwnedPlane([core::mem::MaybeUninit::uninit(); 1024]); self.blocks];
        let chunk = self.blocks.div_ceil(rayon::current_num_threads().max(1));
        let source = unsafe { self.storage.0.as_ptr().add(self.offset).cast::<u8>() } as usize;
        let tile_stride = self.blocks * 512;
        crate::rstrace::ev("rf:par0", self.blocks.div_ceil(chunk) as u32);
        planes.par_chunks_mut(chunk).enumerate().for_each(|(owner, owned)| {
            crate::rstrace::evd("rf:w0", owner as u32);
            let block_base = owner * chunk;
            let owned_len = owned.len();
            for tile in (0..self.tiles).step_by(batch) {
                let count = (self.tiles - tile).min(batch);
                for (local, plane) in owned.iter_mut().enumerate() {
                    let block = block_base + local;
                    // SAFETY: the cache's materialized live span contains all
                    // tiles and blocks. Each owner exclusively borrows these
                    // complete aligned planes; tile zero initializes every
                    // byte before later batches read it. Matrix arrays are
                    // contiguous and count never crosses their end.
                    unsafe {
                        kernels::gfni_fold_word_tiles4(
                            (source as *const u8).add(tile * tile_stride + block * 512),
                            matrices[tile..].as_ptr().cast::<u64>(),
                            plane.0.as_mut_ptr().cast::<u8>(),
                            tile_stride,
                            count,
                            tile == 0,
                            WORD_TO_COLUMNS.as_ptr(),
                            *PREFETCH && local + 1 < owned_len,
                        );
                    }
                }
            }
            crate::rstrace::evd("rf:w1", owner as u32);
        });
        crate::rstrace::ev("rf:red0", 0);
        let mut out = vec![F128::ZERO; (self.blocks + 1) * 64];
        out.par_chunks_mut(64).enumerate().for_each(|(block, dst)| {
            if block == 14 { return; }
            let source = block - usize::from(block > 14);
            // Every block has a single complete accumulator, so the existing
            // plane-to-field converter performs no cross-worker XORs.
            unsafe {
                reduce_worker_plane_block(&planes[source].0, 1024, &[0], 0, dst);
            }
        });
        crate::rstrace::ev("lcf:reduced", 0);
        // Preserve the exact fixed-root reinsertion and constant-pin rules.
        out.copy_within(833..896, 897);
        out[833..897].fill(F128::ZERO);
        let one = out[256];
        for column in [839, 865, 866, 868] { out[column] = one; }
        crate::rstrace::ev("rf:red1", 0);
        out
    }
}
