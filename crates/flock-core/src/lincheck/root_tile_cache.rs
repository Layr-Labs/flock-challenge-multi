//! Proof-local root matrices shared by folds at distinct challenge points.
//! The cache contains witness bits only; each consumer builds fresh GFNI
//! matrices from its own challenge weights. The logical cache is proof-local;
//! its backing allocation returns to the existing untagged scratch pool.
//! Every live byte is overwritten before the next cache can read it.
use super::*;
use core::arch::x86_64::*;
use rayon::prelude::*;

#[repr(C, align(64))]
pub(super) struct Block([u8; 512]);

// Only allocation capacity is recycled. take_f128 invalidates previous
// provenance, and prepare overwrites every cache block before publication.
struct PooledStorage(Vec<F128>);

impl Drop for PooledStorage {
    fn drop(&mut self) {
        crate::scratch::give_f128(std::mem::take(&mut self.0));
    }
}

pub(super) struct RootTileCache {
    storage: PooledStorage,
    offset: usize,
    tiles: usize,
    blocks: usize,
}

#[derive(Clone, Copy)]
pub(super) struct Capture {
    ptr: *mut Block,
    tiles: usize,
    blocks: usize,
}

// SAFETY: capture is confined to prepare(). Each producer claims a distinct
// tile through the existing static partition or atomic tile allocator. A
// checked RootSplicePlan emits each block in that tile exactly once. No read
// reference to the allocation exists until all producers join and fence.
unsafe impl Send for Capture {}
unsafe impl Sync for Capture {}

impl Capture {
    #[inline]
    pub(super) unsafe fn publish(&self, tile: usize, block: usize, rows: &[__m512i; 8]) {
        debug_assert!(tile < self.tiles && block < self.blocks);
        // SAFETY: each (tile, block) is exclusive to this producer; Block's
        // alignment and its 512-byte stride satisfy every streaming store.
        unsafe {
            let dst = self.ptr.add(tile * self.blocks + block).cast::<__m512i>();
            for (i, value) in rows.iter().enumerate() {
                _mm512_stream_si512(dst.add(i), *value);
            }
        }
    }
}

fn prepare(
    splice: &RootSplicePlan,
    z: &[F128],
    k: usize,
    eq8_at: &(impl Fn(usize) -> [F128; 8] + Sync),
) -> (RootTileCache, Vec<F128>) {
    let tiles = z.len() / (k / 128) / (DIRECT_FOLD_TILE_STRIPES * 8);
    let blocks = splice.root_bits.div_ceil(64);
    assert!(tiles > 0 && blocks > 0);
    assert_eq!(z.len(), tiles * (k / 128) * DIRECT_FOLD_TILE_STRIPES * 8);
    // The shared pool's F128 allocation guarantees16-byte alignment. Three
    // spare elements let us align the live span to64 without changing the
    // allocation's original pointer or its deallocation layout.
    let fields = tiles.checked_mul(blocks).unwrap().checked_mul(32).unwrap();
    let mut storage = PooledStorage(crate::scratch::take_f128(fields.checked_add(3).unwrap()));
    let offset = storage.0.as_ptr().align_offset(64);
    assert!(offset <= 3);
    // SAFETY: fields+3 elements were reserved; offset is at most3, so all
    // live blocks fit. F128 and Block both contain only plain integer bytes.
    let aligned = unsafe { storage.0.as_mut_ptr().add(offset).cast::<Block>() };
    let mut writer = splice.clone();
    writer.capture = Some(Capture {
        ptr: aligned,
        tiles,
        blocks,
    });
    let folded = writer.fold(z, k, eq8_at);
    // Every live block, including the tail's zero padding, is initialized.
    // All producer joins and their SFENCEs completed before this readable
    // cache is constructed. Padding outside the aligned live span is never
    // read. On unwind, PooledStorage returns stale capacity under the same
    // write-before-read contract as any other global scratch buffer.
    (
        RootTileCache {
            storage,
            offset,
            tiles,
            blocks,
        },
        folded,
    )
}

pub(super) fn fold(
    source: &RootFoldSource,
    splice: &RootSplicePlan,
    z: &[F128],
    k: usize,
    eq8_at: &(impl Fn(usize) -> [F128; 8] + Sync),
) -> Vec<F128> {
    let mut first_fold = None;
    let cache = source.cached_tiles.get_or_init(|| {
        let (cache, folded) = prepare(splice, z, k, eq8_at);
        first_fold = Some(folded);
        cache
    });
    if let Some(folded) = first_fold {
        folded
    } else {
        cache.fold(eq8_at)
    }
}

impl RootTileCache {
    #[inline(always)]
    fn block(&self, index: usize) -> &Block {
        assert!(index < self.tiles * self.blocks);
        // SAFETY: prepare initialized every block before publishing Self;
        // the live span is64-byte aligned and fits within the owned vector.
        unsafe {
            &*self
                .storage
                .0
                .as_ptr()
                .add(self.offset)
                .cast::<Block>()
                .add(index)
        }
    }

    fn fold(&self, eq8_at: &(impl Fn(usize) -> [F128; 8] + Sync)) -> Vec<F128> {
        let tiles_per_worker = self.tiles.div_ceil(rayon::current_num_threads().max(1));
        let workers = self.tiles.div_ceil(tiles_per_worker);
        let stride = self.blocks * 1024;
        let mut planes = crate::alloc_uninit_vec::<core::mem::MaybeUninit<u8>>(workers * stride);
        let mut active = vec![0u8; workers];
        let next = std::sync::atomic::AtomicUsize::new(0);
        let dynamic = dynamic_tiles_enabled();
        planes
            .par_chunks_mut(stride)
            .zip(active.par_iter_mut())
            .enumerate()
            .for_each(|(worker, (dst, active))| {
                // Four matrices fit in 4KiB. Fold each block across this batch
                // before moving on, keeping its 1KiB accumulator hot in L1.
                let mut mats = [[0u64; 128]; 4];
                let mut first = true;
                let (mut lo, mut hi) = if dynamic {
                    (0, 0)
                } else {
                    (
                        worker * tiles_per_worker,
                        ((worker + 1) * tiles_per_worker).min(self.tiles),
                    )
                };
                loop {
                    if lo == hi {
                        if !dynamic {
                            break;
                        }
                        lo = next.fetch_add(4, std::sync::atomic::Ordering::Relaxed);
                        if lo >= self.tiles {
                            break;
                        }
                        hi = (lo + 4).min(self.tiles);
                    }
                    let batch_end = (lo + 4).min(hi);
                    for tile in lo..batch_end {
                        for t in 0..DIRECT_FOLD_TILE_STRIPES {
                            let eq8 = eq8_at(8 * (tile * DIRECT_FOLD_TILE_STRIPES + t));
                            kernels::fold_mats_from_basis(
                                &eq8, &mut mats[tile - lo][t * 16..(t + 1) * 16],
                            );
                        }
                    }
                    for block in 0..self.blocks {
                        for tile in lo..batch_end {
                            // SAFETY: cache is immutable and initialized; this
                            // worker exclusively owns dst. The first tile of
                            // the first batch initializes every output block.
                            unsafe {
                                let src = self.block(tile * self.blocks + block)
                                    .0.as_ptr().cast::<__m512i>();
                                let rows = core::array::from_fn(|i| _mm512_load_si512(src.add(i)));
                                kernels::gfni_fold_rows(
                                    &rows, &mats[tile - lo],
                                    dst.as_mut_ptr().cast::<u8>().add(block * 1024),
                                    first && tile == lo,
                                );
                            }
                        }
                    }
                    lo = batch_end;
                    first = false;
                }
                *active = u8::from(!first);
            });
        let active_workers: Vec<usize> = active
            .into_iter()
            .enumerate()
            .filter_map(|(i, v)| (v != 0).then_some(i))
            .collect();
        let mut out = vec![F128::ZERO; self.blocks * 64];
        out.par_chunks_mut(64).enumerate().for_each(|(block, dst)| {
            // SAFETY: every active worker initialized this live block and
            // the Rayon producer join completed before reduction starts.
            unsafe {
                reduce_worker_plane_block(&planes, stride, &active_workers, block, dst);
            }
        });
        out
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn root_tile_cache_reweights_and_masks_tail() {
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(8)
            .build()
            .unwrap();
        pool.install(|| {
            let roots: Vec<usize> = (0..64)
                .chain((0..64).map(|i| 64 + i + if i >= 17 { 64 } else { 0 }))
                .chain(192..256)
                .chain(256..305)
                .collect();
            let plan = RootSplicePlan {
                actions: vec![
                    RootSpliceAction::Full(0),
                    RootSpliceAction::Start,
                    RootSpliceAction::End {
                        out: 1,
                        low_mask: (1 << 17) - 1,
                    },
                    RootSpliceAction::Full(2),
                    RootSpliceAction::Tail {
                        out: 3,
                        mask: (1 << 49) - 1,
                    },
                    RootSpliceAction::Skip,
                ]
                .into_boxed_slice(),
                source_bits: 305,
                root_bits: 241,
                capture: None,
            };
            plan.check_columns(&roots);
            let mut seed = 0x6182ab49u64;
            let mut rng = || {
                seed ^= seed << 13;
                seed ^= seed >> 7;
                seed ^= seed << 17;
                seed
            };
            let z: Vec<F128> = (0..9 * 64 * 3)
                .map(|_| F128 {
                    lo: rng(),
                    hi: rng(),
                })
                .collect();
            let eq1 = |i: usize| {
                core::array::from_fn(|j| F128 {
                    lo: (i + j + 1) as u64 * 0x21931,
                    hi: ((i + j + 5) as u64).rotate_left(29),
                })
            };
            let eq2 = |i: usize| {
                core::array::from_fn(|j| F128 {
                    lo: ((i + j + 13) as u64).rotate_left(37),
                    hi: (i + j + 1) as u64 * 0x821117,
                })
            };
            let reference1 = plan.fold(&z, 384, &eq1);
            let reference2 = plan.fold(&z, 384, &eq2);
            assert_ne!(reference1, reference2);
            let (cache, produced) = prepare(&plan, &z, 384, &eq1);
            assert_eq!(produced, reference1);
            assert_eq!(cache.fold(&eq1), reference1);
            assert_eq!(cache.fold(&eq2), reference2);
            let (a, b) = rayon::join(|| cache.fold(&eq1), || cache.fold(&eq2));
            assert_eq!(a, reference1);
            assert_eq!(b, reference2);
            for tile in 0..cache.tiles {
                let tail = &cache.block(tile * cache.blocks + 3).0;
                for row in 0..8 {
                    assert!(tail[row * 64 + 49..row * 64 + 64].iter().all(|&v| v == 0));
                }
            }
            assert_eq!(cache.block(0) as *const Block as usize % 64, 0);
            drop(cache);
            let mut fresh_z = z.clone();
            fresh_z[0].lo ^= 1;
            let fresh_reference = plan.fold(&fresh_z, 384, &eq1);
            assert_ne!(fresh_reference, reference1);
            let (fresh_cache, fresh_first) = prepare(&plan, &fresh_z, 384, &eq1);
            assert_eq!(fresh_cache.block(0) as *const Block as usize % 64, 0);
            assert_eq!(fresh_first, fresh_reference);
            assert_eq!(fresh_cache.fold(&eq1), fresh_reference);
            assert_eq!(fresh_cache.fold(&eq2), plan.fold(&fresh_z, 384, &eq2));
        });
    }
    #[test]
    fn root_tile_cache_batch_scalar_oracle() {
        let mut calls = 0;
        let mut comparisons = 0;
        for threads in [1, 3, 8] {
            let pool = rayon::ThreadPoolBuilder::new().num_threads(threads).build().unwrap();
            for tiles in [1usize, 3, 4, 5, 9, 17, 33] {
                for blocks in [1usize, 2, 5] {
                    let fields = tiles * blocks * 32;
                    let mut storage = PooledStorage(crate::scratch::take_f128(fields + 3));
                    let offset = storage.0.as_ptr().align_offset(64);
                    assert!(offset <= 3);
                    let ptr = unsafe { storage.0.as_mut_ptr().add(offset).cast::<Block>() };
                    let mut seed = 0x718293ab91233451u64;
                    for tile in 0..tiles {
                        for block in 0..blocks {
                            let mut bytes = [0u8; 512];
                            for byte in &mut bytes {
                                seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17;
                                *byte = seed as u8;
                            }
                            unsafe { ptr.add(tile * blocks + block).write(Block(bytes)); }
                        }
                    }
                    let cache = RootTileCache { storage, offset, tiles, blocks };
                    for challenge in [0u64, 0x8192ab] {
                        let eq = |i: usize| core::array::from_fn(|j| {
                            let n = (i + j + 1) as u64;
                            F128 { lo: n.wrapping_mul(0xa2d92d73829).rotate_left(17) ^ challenge,
                                   hi: n.wrapping_mul(0x7a39823b5).rotate_left(39) ^ challenge.rotate_left(23) }
                        });
                        let mut expected = vec![F128::ZERO; blocks * 64];
                        for tile in 0..tiles {
                            for block in 0..blocks {
                                let bytes = &cache.block(tile * blocks + block).0;
                                for t in 0..8 {
                                    let basis = eq(8 * (tile * 8 + t));
                                    for col in 0..64 {
                                        for j in 0..8 {
                                            if bytes[t * 64 + col] & (1 << j) != 0 {
                                                expected[block * 64 + col].lo ^= basis[j].lo;
                                                expected[block * 64 + col].hi ^= basis[j].hi;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        let actual = pool.install(|| cache.fold(&eq));
                        assert_eq!(actual, expected, "threads={threads} tiles={tiles} blocks={blocks} challenge={challenge}");
                        calls += 1; comparisons += actual.len();
                    }
                }
            }
        }
        println!("SCALAR_CACHE_ORACLE calls={calls} field_comparisons={comparisons}");
        assert_eq!(calls, 126);
        assert_eq!(comparisons, 21504);
    }

}
