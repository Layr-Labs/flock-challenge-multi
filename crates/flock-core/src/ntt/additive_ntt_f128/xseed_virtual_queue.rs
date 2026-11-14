//! Reusable private deep groups with completion (not claim) acknowledgements.
use super::F128;
use std::sync::atomic::{AtomicBool,AtomicU64,AtomicUsize,Ordering};

const BLOCKS:usize=16;
const ROWS:usize=BLOCKS*128;
const MASK:u64=(1<<BLOCKS)-1;

struct Slot {
    storage:std::cell::UnsafeCell<Vec<F128>>,
    ptr:usize,
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
        let mut storage=crate::scratch::take_f128(ROWS*64);
        let ptr=storage.as_mut_ptr() as usize;
        Self{storage:std::cell::UnsafeCell::new(storage),ptr,word:AtomicU64::new(0),completed:AtomicUsize::new(0)}
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
impl Drop for Slot {
    fn drop(&mut self) {crate::scratch::give_f128(std::mem::take(self.storage.get_mut()));}
}

/// The callback passed to `produce` publishes exactly sixteen completed128-row
/// blocks. `produce` must never modify a published block. Storage remains live
/// until the broadcast joins, including every panic path.
pub(super) struct Session {
    slots:Vec<Slot>, next:AtomicUsize, finished:AtomicUsize, aborted:AtomicBool, groups:usize,
}
impl Session {
    pub(super) fn new(groups:usize,pairs:&[(usize,usize)])->Self {
        assert!(!pairs.is_empty());
        assert!(groups<(1usize<<32)-1);
        assert_eq!(pairs.len()*2,rayon::current_num_threads());
        Self{slots:(0..pairs.len()).map(|_|Slot::new()).collect(),next:AtomicUsize::new(0),
            finished:AtomicUsize::new(0),aborted:AtomicBool::new(false),groups}
    }
    /// Called once by each pool worker after all top stores are published.
    /// The owning session outlives the enclosing broadcast, including unwind.
    pub(super) fn worker(&self,idx:usize,pairs:&[(usize,usize)],
        produce:&(dyn Fn(usize,*mut F128,&dyn Fn(usize))+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,&[F128])+Sync)) {
        let Self{slots,next,finished,aborted,groups}=self;
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
                if let Some((group,b))=slot.claim() {
                    let lo=group*ROWS+b*128;
                    // Release-ready/acquire-claim orders all block writes.
                    // A claimed reader retains ownership until completed RMW.
                    let block=unsafe {std::slice::from_raw_parts((slot.ptr as *const F128).add(b*128*64),128*64)};
                    consume(lo..lo+128,block);
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
                slot.completed.store(0,Ordering::Relaxed);
                slot.word.store(((group as u64)+1)<<(2*BLOCKS),Ordering::Release);
                let publish=|b:usize| {
                    assert!(b<BLOCKS);
                    let old=slot.word.fetch_or(1<<(BLOCKS+b),Ordering::Release);
                    assert_eq!(old&(1<<(BLOCKS+b)),0,"private block published twice");
                };
                produce(group,slot.ptr as *mut F128,&publish);
                assert_eq!((slot.word.load(Ordering::Acquire)>>BLOCKS)&MASK,MASK,"private group incomplete");
                while slot.completed.load(Ordering::Acquire)!=BLOCKS {
                    if aborted.load(Ordering::Acquire){return;}
                    if !help(){std::hint::spin_loop();}
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
        produce:&(dyn Fn(usize,*mut F128,&dyn Fn(usize))+Sync),
        consume:&(dyn Fn(core::ops::Range<usize>,&[F128])+Sync)) {
        rayon::broadcast(|ctx|self.worker(ctx.index(),pairs,produce,consume));
        assert!(!self.aborted.load(Ordering::Acquire));
    }
}

#[cfg(test)]
pub(super) fn run(groups:usize,pairs:&[(usize,usize)],
    produce:&(dyn Fn(usize,*mut F128,&dyn Fn(usize))+Sync),
    consume:&(dyn Fn(core::ops::Range<usize>,&[F128])+Sync)) {
    Session::new(groups,pairs).run(pairs,produce,consume);
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn private_group_reuse_waits_for_hash_completion_and_joins_panics() {
        let mut normal=0;let mut panics=0;
        for threads in [2,4,8] {for injection in 0..3 {
            let pool=rayon::ThreadPoolBuilder::new().num_threads(threads).build().unwrap();
            let pairs:Vec<_>=(0..threads/2).map(|i|(2*i,2*i+1)).collect();
            let seen:Vec<_>=(0..97*BLOCKS).map(|_|AtomicUsize::new(0)).collect();
            let live=AtomicUsize::new(0);let injected=AtomicBool::new(false);
            struct Live<'a>(&'a AtomicUsize);
            impl Drop for Live<'_>{fn drop(&mut self){self.0.fetch_sub(1,Ordering::AcqRel);}}
            let produce=|group:usize,p:*mut F128,publish:&dyn Fn(usize)| {
                for b in (0..BLOCKS).rev() {
                    if injection==1 && group==5 && b==3 {
                        injected.store(true,Ordering::Release);panic!("injected private producer");
                    }
                    unsafe {for i in 0..128*64 {*p.add(b*128*64+i)=F128{lo:group as u64,hi:(b*128*64+i) as u64};}}
                    publish(b);
                    if (group+b)%7==0 {std::thread::yield_now();}
                }
            };
            let consume=|range:core::ops::Range<usize>,data:&[F128]| {
                live.fetch_add(1,Ordering::AcqRel);let _guard=Live(&live);
                let group=range.start/ROWS;let b=range.start%ROWS/128;
                assert_eq!(seen[group*BLOCKS+b].fetch_add(1,Ordering::AcqRel),0);
                if injection==2 && group==5 && b==3 {
                    injected.store(true,Ordering::Release);panic!("injected private consumer");
                }
                for repeat in 0..3 {
                    for i in [0,1,31,127*64,128*64-1] {
                        assert_eq!(data[i],F128{lo:group as u64,hi:(b*128*64+i) as u64});
                    }
                    if repeat!=2 {std::thread::yield_now();}
                }
            };
            let result=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||pool.install(||run(97,&pairs,&produce,&consume))));
            assert_eq!(live.load(Ordering::Acquire),0);
            if injection==0 {result.unwrap();assert!(seen.iter().all(|v|v.load(Ordering::Acquire)==1));normal+=1;}
            else {assert!(result.is_err());assert!(injected.load(Ordering::Acquire));panics+=1;}
        }}
        println!("X9 private ownership PASS: {normal} normal runs, {panics} joined producer/consumer panics; 97 generations each, 2/4/8 threads, delayed readers");
    }
}
