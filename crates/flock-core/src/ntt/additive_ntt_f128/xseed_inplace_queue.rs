//! X16 canonical in-place half rows; every published block is read-only until ACK.
use super::F128;
use std::sync::atomic::{AtomicBool,AtomicU64,AtomicUsize,Ordering};

const BLOCKS:usize=16;
const ROWS:usize=BLOCKS*128;
const MASK:u64=(1<<BLOCKS)-1;

struct Slot {
    cvs:std::cell::UnsafeCell<Vec<u8>>,
    cv_ptr:usize,
    // High32 bits identify a unique subgroup generation; low16 are claimed,
    // next16 are ready. CAS includes the generation, preventing stale claims.
    word:AtomicU64,
    completed:AtomicUsize,
}
// The producer owns writes until ready publication, then readers own disjoint
// immutable blocks. All sixteen callbacks complete before any buffer reuse.
unsafe impl Sync for Slot {}
impl Slot {
    fn new()->Self {
        let mut cvs=vec![0u8;ROWS*32];let cv_ptr=cvs.as_mut_ptr() as usize;
        Self{cvs:std::cell::UnsafeCell::new(cvs),cv_ptr,word:AtomicU64::new(0),completed:AtomicUsize::new(0)}
    }
    fn claim(&self)->Option<(usize,usize)> {
        let mut word=self.word.load(Ordering::Acquire);
        loop {
            let ready=(word>>BLOCKS)&MASK;
            let free=ready&!(word&MASK);
            if free==0 {return None;}
            let b=free.trailing_zeros() as usize;
            match self.word.compare_exchange_weak(word,word|(1<<b),Ordering::AcqRel,Ordering::Acquire) {
                Ok(_)=>return Some(((word>>(2*BLOCKS)) as usize-1,b)),
                Err(next)=>word=next,
            }
        }
    }
}
// cvs owns its stable allocation for the entire joined session.
impl Drop for Slot {
    fn drop(&mut self) {debug_assert_eq!(self.cvs.get_mut().len(),ROWS*32);}
}

/// The callback passed to `produce` publishes exactly sixteen completed128-row
/// blocks. `produce` must never modify a published block. Storage remains live
/// until the broadcast joins, including every panic path.
pub(super) struct Session {
    slots:Vec<Slot>, next:AtomicUsize, finished:AtomicUsize, aborted:AtomicBool, groups:usize, base:usize,
}
impl Session {
    /// SAFETY: base owns groups*2048*64 initialized fields after the top barrier.
    /// No outside views may coexist with worker writes; caller joins all workers.
    pub(super) unsafe fn new(groups:usize,pairs:&[(usize,usize)],base:*mut F128)->Self {
        assert!(!pairs.is_empty());
        assert!(groups<((1usize<<32)-1)/4);
        assert_eq!(pairs.len()*2,rayon::current_num_threads());
        Self{slots:(0..pairs.len()).map(|_|Slot::new()).collect(),next:AtomicUsize::new(0),
            finished:AtomicUsize::new(0),aborted:AtomicBool::new(false),groups,base:base as usize}
    }
    /// Called once by each pool worker after all top stores are published.
    /// The owning session outlives the enclosing broadcast, including unwind.
    pub(super) fn worker(&self,idx:usize,pairs:&[(usize,usize)],
        produce:&(dyn Fn(usize,usize,*mut F128,&dyn Fn(usize))+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,usize,&[F128],&mut [u8])+Sync)) {
        let Self{slots,next,finished,aborted,groups,base}=self;
        let groups=*groups;
        let producer=idx<pairs.len();let own=idx%pairs.len();
        struct Guard<'a>{saved:super::affinity::Mask,aborted:&'a AtomicBool}
        impl Drop for Guard<'_> {
            fn drop(&mut self) {
                if std::thread::panicking(){self.aborted.store(true,Ordering::Release);}
                super::affinity::set(&self.saved);
            }
        }
        let _guard=Guard{saved:super::affinity::get(),aborted:&aborted};
        super::affinity::pin(if producer{pairs[own].0}else{pairs[own].1});
        let help=|| {
            for offset in 0..slots.len() {
                let slot=&slots[(own+offset)%slots.len()];
                if let Some((generation,b))=slot.claim() {
                    let group=generation/2;let stripe=generation%2;
                    let lo=group*ROWS+b*128;
                    // Release-ready/acquire-claim orders all block writes.
                    // A claimed reader retains ownership until completed RMW.
                    let block=unsafe {std::slice::from_raw_parts((*base as *const F128).add(lo*64),128*64)};
                    // Only this claim owns this block's CVs; all claims finish
                    // before advancing the stripe or reusing the subgroup.
                    let cvs=unsafe {std::slice::from_raw_parts_mut((slot.cv_ptr as *mut u8).add(b*128*32),128*32)};
                    consume(lo..lo+128,stripe,block,cvs);
                    slot.completed.fetch_add(1,Ordering::Release);
                    return true;
                }
            }
            false
        };
        if producer {
            let slot=&slots[own];
            loop {
                if aborted.load(Ordering::Acquire){return;}
                let group=next.fetch_add(1,Ordering::Relaxed);
                if group>=groups {break;}
                for stripe in 0..2 {
                let generation=group*2+stripe;
                slot.completed.store(0,Ordering::Relaxed);
                slot.word.store(((generation as u64)+1)<<(2*BLOCKS),Ordering::Release);
                let publish=|b:usize| {
                    assert!(b<BLOCKS);
                    let old=slot.word.fetch_or(1<<(BLOCKS+b),Ordering::Release);
                    assert_eq!(old&(1<<(BLOCKS+b)),0,"private block published twice");
                };
                produce(group,stripe,unsafe{(*base as *mut F128).add(group*ROWS*64)},&publish);
                assert_eq!((slot.word.load(Ordering::Acquire)>>BLOCKS)&MASK,MASK,"private group incomplete");
                while slot.completed.load(Ordering::Acquire)!=BLOCKS {
                    if aborted.load(Ordering::Acquire){return;}
                    if !help(){std::hint::spin_loop();}
                }
            }
            }
            finished.fetch_add(1,Ordering::Release);
        }
        loop {
            if aborted.load(Ordering::Acquire){return;}
            if help(){continue;}
            if finished.load(Ordering::Acquire)==pairs.len(){return;}
            std::hint::spin_loop();
        }
    }
    pub(super) fn run(&self,pairs:&[(usize,usize)],
        produce:&(dyn Fn(usize,usize,*mut F128,&dyn Fn(usize))+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,usize,&[F128],&mut [u8])+Sync)) {
        rayon::broadcast(|ctx|self.worker(ctx.index(),pairs,produce,consume));
        assert!(!self.aborted.load(Ordering::Acquire));
    }
}
