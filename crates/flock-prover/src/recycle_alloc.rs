//! Recycling global allocator for the prover process.
//!
//! Blocks at least 32 KiB are parked on exact-size freelists rather than
//! returned to the system allocator. The ranked worker performs an untimed warm proof
//! with the same allocation pattern, so the timed proof reuses resident pages
//! for large allocations not already handled by the typed scratch pools.

use std::alloc::{GlobalAlloc, Layout, System};
use std::sync::{Mutex, OnceLock};
use std::sync::atomic::{
    AtomicUsize,
    Ordering::{AcqRel, Acquire, Release},
};

const RECYCLE_MIN: usize = 32 * 1024;
const MAX_ALIGN: usize = 16;
const MAX_CLASSES: usize = 512;

struct Class {
    size: AtomicUsize,
    head: Mutex<usize>,
}

#[allow(clippy::declare_interior_mutable_const)]
const EMPTY: Class = Class {
    size: AtomicUsize::new(0),
    head: Mutex::new(0),
};
static CLASSES: [Class; MAX_CLASSES] = [EMPTY; MAX_CLASSES];

// Class keys only transition from zero to their final size. Once all slots
// have been reserved, an immutable index can answer both hits and misses
// without walking the full open-addressed table. Freelist ownership stays
// with the original slot; the index never stores allocation pointers.
static REGISTERED_CLASSES: AtomicUsize = AtomicUsize::new(0);
static FULL_CLASS_INDEX: OnceLock<[(usize, usize); MAX_CLASSES]> = OnceLock::new();

#[cold]
#[inline(never)]
fn class_registered() {
    // This runs exactly once for each successful zero-to-size CAS. The RMW
    // chain orders all reservations before the final snapshot, and every
    // key is loaded with Acquire as on the original lookup path.
    if REGISTERED_CLASSES.fetch_add(1, AcqRel) + 1 == MAX_CLASSES {
        let mut index = core::array::from_fn(|i| (CLASSES[i].size.load(Acquire), i));
        index.sort_unstable_by_key(|&(size, _)| size);
        // Sorting a fixed array allocates nothing. Keeping its stack frame
        // in this cold function also keeps it out of pop/dealloc.
        let _ = FULL_CLASS_INDEX.set(index);
    }
}


#[inline]
fn class_slot(size: usize) -> usize {
    (size.wrapping_mul(0x9E37_79B9_7F4A_7C15) >> 55) % MAX_CLASSES
}

#[inline]
fn find_class(size: usize, insert: bool) -> Option<usize> {
    if let Some(index) = FULL_CLASS_INDEX.get() {
        return index.binary_search_by_key(&size, |&(key, _)| key)
            .ok().map(|i| index[i].1);
    }
    let start = class_slot(size);
    for probe in 0..MAX_CLASSES {
        let i = (start + probe) % MAX_CLASSES;
        let s = CLASSES[i].size.load(Acquire);
        if s == size {
            return Some(i);
        }
        if s == 0 {
            if !insert {
                return None;
            }
            if CLASSES[i]
                .size
                .compare_exchange(0, size, Release, Acquire)
                .is_ok()
            {
                class_registered();
                return Some(i);
            }
            if CLASSES[i].size.load(Acquire) == size {
                return Some(i);
            }
        }
    }
    None
}

#[inline]
fn recyclable(layout: &Layout) -> bool {
    layout.size() >= RECYCLE_MIN && layout.align() <= MAX_ALIGN
}

/// `FLOCK_NO_ALIGN64=1` restores raw System pointers for the recyclable
/// class (exact same-binary A/B). Latched once, and only ever initialized
/// from a RECYCLABLE allocation — `var_os`'s own small allocations take the
/// non-recyclable branch straight to System, so initialization cannot
/// re-enter this latch.
#[inline]
fn align64_enabled() -> bool {
    static ON: std::sync::OnceLock<bool> = std::sync::OnceLock::new();
    *ON.get_or_init(|| std::env::var_os("FLOCK_NO_ALIGN64").is_none())
}

/// Every large prover buffer historically landed `16 mod 64` (glibc mmap
/// chunk header), which the hot kernels pay for three ways: every wide
/// load/store on these buffers is a cache-line split, non-temporal 64-byte
/// writes straddle two lines (partial write-combining flushes are DRAM
/// read-modify-writes), and single-uop ZMM streaming stores are illegal.
/// For the recyclable class, over-allocate by `ALIGN_SLACK` and return
/// `round_up(base + 8, 64)`: a 64-aligned pointer with room for the
/// back-offset word stored at `aligned - 8` — BEFORE the block, so it can
/// never collide with the freelist link word at `aligned + 0`.
const ALIGN_SLACK: usize = 64;

#[inline]
fn adjusted(layout: &Layout) -> Layout {
    // SAFETY of unwrap: size + 64 cannot overflow isize for any layout the
    // caller could have constructed, and 16 is a power of two.
    Layout::from_size_align(layout.size() + ALIGN_SLACK, MAX_ALIGN).unwrap()
}

#[inline]
unsafe fn align_up(base: *mut u8) -> *mut u8 {
    if base.is_null() {
        return base;
    }
    let aligned = ((base as usize + 8 + 63) & !63) as *mut u8;
    // SAFETY: aligned - base is in [8, 64] ⊂ the ALIGN_SLACK the caller
    // over-allocated, and aligned - 8 >= base.
    unsafe { *(aligned.sub(8) as *mut usize) = aligned as usize - base as usize };
    aligned
}

#[inline]
unsafe fn align_base(ptr: *mut u8) -> *mut u8 {
    // SAFETY: ptr was produced by align_up, so the offset word at ptr - 8 is
    // intact (freelist links live at ptr + 0 and never touch it).
    let off = unsafe { *(ptr.sub(8) as *const usize) };
    debug_assert!((8..=ALIGN_SLACK).contains(&off));
    unsafe { ptr.sub(off) }
}

#[inline]
fn pop(size: usize) -> *mut u8 {
    let Some(i) = find_class(size, false) else {
        return core::ptr::null_mut();
    };
    let mut head = CLASSES[i].head.lock().unwrap();
    let top = *head;
    if top == 0 {
        return core::ptr::null_mut();
    }
    *head = unsafe { *(top as *const usize) };
    top as *mut u8
}

#[inline]
fn push(ptr: *mut u8, size: usize) -> bool {
    let Some(i) = find_class(size, true) else {
        return false;
    };
    let mut head = CLASSES[i].head.lock().unwrap();
    unsafe { *(ptr as *mut usize) = *head };
    *head = ptr as usize;
    true
}

pub struct RecycleAlloc;

// SAFETY: every recycled block came from this allocator with the exact same
// size class. With align64 on, every recyclable-class block System sees uses
// the `adjusted` layout on both alloc and dealloc, and the user pointer is
// recovered to its System base via the offset word `align_up` stored.
// glibc/mimalloc and the macOS allocator provide at least 16-byte alignment
// at these sizes; layouts requiring larger alignment bypass the recycler.
unsafe impl GlobalAlloc for RecycleAlloc {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        if recyclable(&layout) {
            let p = pop(layout.size());
            // Provenance for `flock_core::alloc_uninit_vec`, which skips its
            // `MADV_HUGEPAGE` re-advise on a block that came off a freelist.
            let _ = flock_core::LAST_ALLOC_RECYCLED.try_with(|c| c.set(!p.is_null()));
            if !p.is_null() {
                return p;
            }
            if align64_enabled() {
                // SAFETY: adjusted() reserves the slack align_up consumes.
                return unsafe { align_up(System.alloc(adjusted(&layout))) };
            }
        }
        unsafe { System.alloc(layout) }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        if recyclable(&layout) {
            let p = pop(layout.size());
            let _ = flock_core::LAST_ALLOC_RECYCLED.try_with(|c| c.set(!p.is_null()));
            if !p.is_null() {
                unsafe { core::ptr::write_bytes(p, 0, layout.size()) };
                return p;
            }
            if align64_enabled() {
                // The user range [aligned, aligned + size) is inside the
                // zeroed System block; the offset word sits before it.
                // SAFETY: as for alloc.
                return unsafe { align_up(System.alloc_zeroed(adjusted(&layout))) };
            }
        }
        unsafe { System.alloc_zeroed(layout) }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        if recyclable(&layout) {
            if push(ptr, layout.size()) {
                return;
            }
            if align64_enabled() {
                // SAFETY: every recyclable-class pointer this allocator
                // handed out with align64 on came from align_up; recover the
                // System base and the adjusted layout it was allocated with.
                unsafe {
                    return System.dealloc(align_base(ptr), adjusted(&layout));
                }
            }
        }
        unsafe { System.dealloc(ptr, layout) }
    }
}

#[cfg(test)]
mod tests {

    #[test]
    fn full_class_index_preserves_concurrent_registration_and_freelists() {
        use super::*;
        use std::sync::Barrier;

        // Check original probing while the table is still being populated.
        for j in 0..32 {
            let size = RECYCLE_MIN + 128 * j + 11;
            if let Some(slot) = find_class(size, true) {
                assert_eq!(CLASSES[slot].size.load(Acquire), size);
                assert_eq!(find_class(size, false), Some(slot));
            }
        }
        let barrier = Barrier::new(8);
        std::thread::scope(|scope| {
            for lane in 0..8 {
                let barrier = &barrier;
                scope.spawn(move || {
                    barrier.wait();
                    // Duplicate keys race with distinct colliding keys.
                    for j in 0..2048 {
                        let size = RECYCLE_MIN + 128 * ((j * 37 + lane * 19) % 2048) + 11;
                        if let Some(slot) = find_class(size, true) {
                            assert_eq!(CLASSES[slot].size.load(Acquire), size);
                            assert_eq!(find_class(size, false), Some(slot));
                            assert_eq!(find_class(size, true), Some(slot));
                        }
                    }
                });
            }
        });
        assert_eq!(REGISTERED_CLASSES.load(Acquire), MAX_CLASSES);
        let index = FULL_CLASS_INDEX.get().expect("full table publishes its index");
        assert!(index.windows(2).all(|w| w[0].0 < w[1].0));
        // Physical slots are an independent oracle for the sorted lookup.
        for (slot, class) in CLASSES.iter().enumerate() {
            let size = class.size.load(Acquire);
            assert_ne!(size, 0);
            assert_eq!(find_class(size, false), Some(slot));
            assert_eq!(find_class(size, true), Some(slot));
        }
        let absent = (RECYCLE_MIN..RECYCLE_MIN + MAX_CLASSES + 1)
            .find(|size| CLASSES.iter().all(|class| class.size.load(Acquire) != *size))
            .unwrap();
        assert_eq!(find_class(absent, false), None);
        assert_eq!(find_class(absent, true), None);

        let cached = index.iter().find(|&&(size, _)|
            (RECYCLE_MIN..RECYCLE_MIN + 128 * 2048 + 12).contains(&size)).unwrap().0;
        // Exercise both an indexed freelist and the full-table System
        // fallback, including alignment and zeroing of reused contents.
        for size in [cached, absent] {
            let layout = Layout::from_size_align(size, 8).unwrap();
            unsafe {
                let first = RecycleAlloc.alloc(layout);
                assert!(!first.is_null());
                assert_eq!(first as usize % 64, 0);
                core::ptr::write_bytes(first, 0xa5, size);
                RecycleAlloc.dealloc(first, layout);
                let zeroed = RecycleAlloc.alloc_zeroed(layout);
                assert!(!zeroed.is_null());
                assert_eq!(zeroed as usize % 64, 0);
                assert!(core::slice::from_raw_parts(zeroed, size).iter().all(|&x| x == 0));
                RecycleAlloc.dealloc(zeroed, layout);
            }
        }
    }
    /// With `FLOCK_NO_ALIGN64` unset (the ranked worker's cleared env), every
    /// recyclable-class allocation — fresh from System, recycled off the
    /// freelist, and grown through realloc — returns a 64-aligned pointer
    /// with intact contents. (The switch-off arm can't be covered in the
    /// same process: the latch resolves once.)
    #[test]
    fn recyclable_class_is_64_aligned_and_roundtrips() {
        for i in 0..4usize {
            let n = 32 * 1024 + 4096 * i + 128;
            let v = vec![7u8; n];
            assert_eq!(v.as_ptr() as usize % 64, 0, "fresh alloc n={n}");
            drop(v);
            let v2 = vec![9u8; n];
            assert_eq!(v2.as_ptr() as usize % 64, 0, "recycled alloc n={n}");
            assert!(v2.iter().all(|&b| b == 9), "contents survive recycle n={n}");
            let z = vec![0u8; n + 64];
            assert_eq!(z.as_ptr() as usize % 64, 0, "alloc_zeroed n={}", n + 64);
            assert!(z.iter().all(|&b| b == 0), "zeroed contents n={}", n + 64);
        }
        // Growth path: realloc = alloc + copy + dealloc through this
        // allocator; contents must survive the move between size classes.
        let mut g: Vec<u8> = Vec::with_capacity(48 * 1024);
        g.extend(std::iter::repeat_n(0xA5u8, 48 * 1024));
        g.extend(std::iter::repeat_n(0x5Au8, 128 * 1024));
        assert_eq!(g.as_ptr() as usize % 64, 0, "grown alloc");
        assert!(g[..48 * 1024].iter().all(|&b| b == 0xA5));
        assert!(g[48 * 1024..].iter().all(|&b| b == 0x5A));
    }
}
