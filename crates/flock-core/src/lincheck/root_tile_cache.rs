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
// provenance; prepare or witness generation overwrites every live block
// before publication.
struct PooledStorage(Vec<F128>);

impl Drop for PooledStorage {
    fn drop(&mut self) {
        crate::scratch::give_f128(std::mem::take(&mut self.0));
    }
}

pub struct RootTileCache {
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

// Fold two independently weighted cache tiles into each output plane before
// publication. Inputs are immutable and the caller exclusively owns dst.
// FIRST initializes every plane without reading its prior bytes.
#[inline(always)] unsafe fn fold_paired_rows<const FIRST:bool>(a:&[__m512i;8], b:&[__m512i;8], ma:&[u64;128], mb:&[u64;128], dst:*mut u8){
unsafe {

    for k in 0..16 {
        let out=dst.add(k*64).cast::<__m512i>();
        let prior=if FIRST{_mm512_setzero_si512()}else{_mm512_loadu_si512(out)};
let mut acc=prior;
        for t in (0..8).step_by(2) {
            let g0=_mm512_gf2p8affine_epi64_epi8::<0>(a[t],_mm512_set1_epi64(ma[t*16+k] as i64));
            let g1=_mm512_gf2p8affine_epi64_epi8::<0>(a[t+1],_mm512_set1_epi64(ma[(t+1)*16+k] as i64));
            acc=_mm512_ternarylogic_epi64::<0x96>(acc,g0,g1);
        }
        for t in (0..8).step_by(2) {
            let g0=_mm512_gf2p8affine_epi64_epi8::<0>(b[t],_mm512_set1_epi64(mb[t*16+k] as i64));
            let g1=_mm512_gf2p8affine_epi64_epi8::<0>(b[t+1],_mm512_set1_epi64(mb[(t+1)*16+k] as i64));
            acc=_mm512_ternarylogic_epi64::<0x96>(acc,g0,g1);
        }
        _mm512_storeu_si512(out,acc);
}
}
}

impl RootTileCache {
    #[inline(always)]
    unsafe fn fold_tile_pair<const FIRST: bool>(
        &self, tile: usize, ma: &[u64; 128], mb: &[u64; 128], dst: *mut u8,
    ) {
        unsafe {
            for block in 0..self.blocks {
                let a = self.block(tile * self.blocks + block).0.as_ptr().cast::<__m512i>();
                let b = self.block((tile + 1) * self.blocks + block).0.as_ptr().cast::<__m512i>();
                let aa = core::array::from_fn(|i| _mm512_load_si512(a.add(i)));
                let bb = core::array::from_fn(|i| _mm512_load_si512(b.add(i)));
                fold_paired_rows::<FIRST>(&aa, &bb, ma, mb, dst.add(block * 1024));
            }
        }
    }


    /// Adopt fully initialized witness-produced BLAKE3 root tiles.
    ///
    /// # Safety
    /// The aligned live span must contain this proof's canonical root bits
    /// in tile / root group / octa stripe / root column order: 64-compression
    /// tiles, 177 groups, eight 64-byte stripes. The last 15 columns are zero.
    /// Every producer must have joined and executed SFENCE before this call.
    /// The later RootFoldSource must use the same witness and root ordering.
    pub unsafe fn from_witness_storage(storage: Vec<F128>, compressions: usize) -> Self {
        let storage = PooledStorage(storage);
        assert!(compressions > 0 && compressions.is_multiple_of(64));
        let tiles = compressions / 64;
        let blocks = 177;
        let fields = tiles.checked_mul(blocks).unwrap().checked_mul(32).unwrap();
        let offset = storage.0.as_ptr().align_offset(64);
        assert!(offset <= 3 && offset.checked_add(fields).unwrap() <= storage.0.len());
        Self { storage, offset, tiles, blocks }
    }

    pub(super) fn matches_geometry(&self, compressions: usize, root_bits: usize) -> bool {
        root_bits == 11313 && self.blocks == 177 && self.tiles.checked_mul(64) == Some(compressions)
    }

    /// Expensive diagnostic oracle: compare every cache byte, including tail
    /// padding, with canonical-witness capture at the same root geometry.
    pub fn assert_matches_witness(&self, z: &[F128], k_log: usize, plan: &LinearFoldPlan) {
        let splice = RootSplicePlan::new(plan, 1 << k_log).expect("root splice geometry");
        let (reference, _) = prepare(&splice, z, 1 << k_log, &|_| [F128::ZERO; 8]);
        assert_eq!(self.tiles, reference.tiles);
        assert_eq!(self.blocks, reference.blocks);
        for block in 0..self.tiles * self.blocks {
            assert_eq!(self.block(block).0, reference.block(block).0, "root cache block {block}");
        }
    }

    #[inline(always)]
    fn block(&self, index: usize) -> &Block {
        assert!(index < self.tiles * self.blocks);
        // SAFETY: prepare initializes every block, and from_witness_storage
        // requires the same initialization before publication. The live
        // span is 64-byte aligned and fits within the owned vector.
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
                let mut mats = [0u64; 128];
                let mut next_mats = [0u64; 128];
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
                    let tile = lo;
                    // Consume only this worker's already claimed range. Odd
                    // tails retain the original one-tile path.
                    let paired = hi - lo >= 2;
                    lo += if paired { 2 } else { 1 };
                    for t in 0..DIRECT_FOLD_TILE_STRIPES {
                        let eq8 = eq8_at(8 * (tile * DIRECT_FOLD_TILE_STRIPES + t));
                        kernels::fold_mats_from_basis(&eq8, &mut mats[t * 16..(t + 1) * 16]);
                    }
                    if paired {
                        for t in 0..DIRECT_FOLD_TILE_STRIPES {
                            let eq8 = eq8_at(8 * ((tile + 1) * DIRECT_FOLD_TILE_STRIPES + t));
                            kernels::fold_mats_from_basis(&eq8, &mut next_mats[t * 16..(t + 1) * 16]);
                        }
                        // Both tiles are fully initialized, immutable and
                        // inside this worker's claimed [lo, hi) range.
                        // FIRST writes every live output plane before use.
                        unsafe {
                            if first {
                                self.fold_tile_pair::<true>(tile, &mats, &next_mats, dst.as_mut_ptr().cast());
                            } else {
                                self.fold_tile_pair::<false>(tile, &mats, &next_mats, dst.as_mut_ptr().cast());
                            }
                        }
                    } else {
                        for block in 0..self.blocks {
                            // SAFETY: the fully initialized immutable cache is
                            // 64-byte aligned; this worker owns every dst plane.
                            // Its first tile initializes all live planes before
                            // subsequent tiles load their accumulators.
                            unsafe {
                                let src = self
                                    .block(tile * self.blocks + block)
                                    .0
                                    .as_ptr()
                                    .cast::<__m512i>();
                                let rows = core::array::from_fn(|i| _mm512_load_si512(src.add(i)));
                                kernels::gfni_fold_rows(
                                    &rows,
                                    &mats,
                                    dst.as_mut_ptr().cast::<u8>().add(block * 1024),
                                    first,
                                );
                            }
                        }
                    }
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
    fn root_cache_tile_pair_matches_scalar_and_odd_ranges() {
        fn basis(index: usize, salt: u64) -> [F128; 8] {
            core::array::from_fn(|j| {
                let mut x = (index + j + 1) as u64 ^ salt;
                x ^= x << 13; x ^= x >> 7; x ^= x << 17;
                F128 { lo: x, hi: x.rotate_left(31).wrapping_mul(0x219315711) }
            })
        }
        fn oracle(cache: &RootTileCache, salt: u64) -> Vec<F128> {
            let mut out = vec![F128::ZERO; cache.blocks * 64];
            for tile in 0..cache.tiles {
                for t in 0..8 {
                    let eq = basis(8 * (tile * 8 + t), salt);
                    for block in 0..cache.blocks {
                        for col in 0..64 {
                            let bits = cache.block(tile * cache.blocks + block).0[t * 64 + col];
                            for bit in 0..8 {
                                if bits & (1 << bit) != 0 {
                                    out[block * 64 + col].lo ^= eq[bit].lo;
                                    out[block * 64 + col].hi ^= eq[bit].hi;
                                }
                            }
                        }
                    }
                }
            }
            out
        }
        let mut cases = 0usize;
        for threads in [1, 3, 8] {
            let pool = rayon::ThreadPoolBuilder::new().num_threads(threads).build().unwrap();
            pool.install(|| {
                for tiles in [1usize, 2, 3, 4, 5, 7, 8, 9, 17] {
                    for blocks in [1usize, 3, 177] {
                        let fields = tiles * blocks * 32;
                        let mut storage = PooledStorage(vec![F128::ZERO; fields + 3]);
                        let offset = storage.0.as_ptr().align_offset(64);
                        assert!(offset <= 3);
                        let bytes = unsafe { core::slice::from_raw_parts_mut(storage.0.as_mut_ptr().add(offset).cast::<u8>(), fields * 16) };
                        let mut state = (tiles as u64) * 0x12345 + blocks as u64 + 0x912354;
                        for value in bytes {
                            state ^= state << 13; state ^= state >> 7; state ^= state << 17;
                            *value = state as u8;
                        }
                        let cache = RootTileCache { storage, offset, tiles, blocks };
                        let first = oracle(&cache, 0x351ac);
                        let second = oracle(&cache, 0x17a98);
                        assert_ne!(first, second);
                        assert_eq!(cache.fold(&|i| basis(i, 0x351ac)), first, "threads={threads} tiles={tiles} blocks={blocks}");
                        let (a, b) = rayon::join(|| cache.fold(&|i| basis(i, 0x351ac)), || cache.fold(&|i| basis(i, 0x17a98)));
                        assert_eq!(a, first);
                        assert_eq!(b, second);
                        cases += 1;
                    }
                }
            });
        }
        assert_eq!(cases, 81);
        println!("PASS {cases} root-cache geometries, 243 folds, dynamic={}", dynamic_tiles_enabled());
    }
}
