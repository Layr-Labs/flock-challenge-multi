//! Diagnostic deep-pass scheduling: keep hot blocks on their producer's core.
//!
//! One producer, multiple consumers. Tokens are unique canonical codeword rows
//! for the lifetime of this queue, never reusable buffer identifiers. Producers
//! finish rows in increasing order; greatest row is therefore newest. Claiming
//! a token does not imply its callback has completed.

use std::sync::atomic::{AtomicUsize, Ordering};

const EMPTY: usize = usize::MAX;

pub(super) struct HotQueue {
    slots: Box<[AtomicUsize]>,
}

impl HotQueue {
    pub(super) fn new(depth: usize) -> Self {
        assert!((1..=64).contains(&depth));
        Self {
            slots: (0..depth).map(|_| AtomicUsize::new(EMPTY)).collect(),
        }
    }

    /// Only the single producer may call this. A release publishes both the
    /// token and all prior writes to its immutable canonical codeword block.
    pub(super) fn try_push(&self, row: usize) -> bool {
        debug_assert_ne!(row, EMPTY);
        for slot in &self.slots {
            if slot.load(Ordering::Relaxed) == EMPTY {
                // Consumers only clear slots; no other producer can fill it.
                slot.store(row, Ordering::Release);
                return true;
            }
        }
        false
    }

    /// Prefer newest for the sibling, oldest for helpers on other cores.
    pub(super) fn try_pop(&self, newest: bool) -> Option<usize> {
        loop {
            let mut chosen: Option<(&AtomicUsize, usize)> = None;
            for slot in &self.slots {
                let row = slot.load(Ordering::Relaxed);
                if row != EMPTY
                    && chosen.is_none_or(|(_, prev)| {
                        if newest { row > prev } else { row < prev }
                    })
                {
                    chosen = Some((slot, row));
                }
            }
            let (slot, row) = chosen?;
            // Unique row tokens rule out ABA even if the producer recycles
            // this slot while a losing consumer is descheduled. The acquire
            // synchronizes with the successful token's publication, not the
            // speculative loads above. Clearing only releases the queue slot:
            // the codeword block remains immutable until every worker joins.
            if slot.compare_exchange(row, EMPTY, Ordering::AcqRel, Ordering::Relaxed).is_ok() {
                return Some(row);
            }
        }
    }

    pub(super) fn is_empty(&self) -> bool {
        self.slots.iter().all(|slot| slot.load(Ordering::Acquire) == EMPTY)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::AtomicBool;

    #[test]
    fn newest_local_oldest_remote_and_bounded() {
        let q = HotQueue::new(3);
        assert!(q.is_empty());
        assert_eq!(q.try_pop(true), None);
        for row in [0, 128, 256] { assert!(q.try_push(row)); }
        assert!(!q.try_push(384));
        assert_eq!(q.try_pop(true), Some(256));
        assert!(q.try_push(384));
        assert_eq!(q.try_pop(false), Some(0));
        assert_eq!(q.try_pop(true), Some(384));
        assert_eq!(q.try_pop(false), Some(128));
        assert!(q.is_empty());
    }

    #[test]
    fn unique_claims_and_published_payload_under_slot_reuse() {
        const N: usize = 50_000;
        for depth in [1, 2, 8, 64] {
            let q = HotQueue::new(depth);
            let done = AtomicBool::new(false);
            let payload: Vec<_> = (0..N).map(|_| AtomicUsize::new(0)).collect();
            let seen: Vec<_> = (0..N).map(|_| AtomicUsize::new(0)).collect();
            std::thread::scope(|s| {
                for worker in 0..4 {
                    let q = &q;
                    let done = &done;
                    let payload = &payload;
                    let seen = &seen;
                    s.spawn(move || loop {
                        if let Some(row) = q.try_pop(worker == 0) {
                            assert_eq!(payload[row].load(Ordering::Relaxed), row + 1);
                            assert_eq!(seen[row].fetch_add(1, Ordering::Relaxed), 0);
                        } else if done.load(Ordering::Acquire) && q.is_empty() {
                            break;
                        } else {
                            std::hint::spin_loop();
                        }
                    });
                }
                for row in 0..N {
                    payload[row].store(row + 1, Ordering::Relaxed);
                    while !q.try_push(row) { std::hint::spin_loop(); }
                }
                done.store(true, Ordering::Release);
            });
            assert!(q.is_empty());
            assert!(seen.iter().all(|n| n.load(Ordering::Relaxed) == 1));
        }
    }
}
