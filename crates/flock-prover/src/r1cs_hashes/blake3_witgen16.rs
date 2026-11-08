//! Sixteen-lane ranked witness arithmetic feeding two unchanged octa drains.
use super::*;

#[repr(C, align(64))]
struct OctaRing([V8; RING_WORDS]);

struct PairWriter<'a, const FLUSH: bool> {
    pending: V16,
    paired_word: V16,
    first: W8<'a, FLUSH, true>,
    second: W8<'a, FLUSH, true>,
}
impl<const FLUSH: bool> PairWriter<'_, FLUSH> {
    #[inline(always)]
    unsafe fn write_word<const WORD: usize>(&mut self, v: V16) {
        unsafe {
            // The two octas keep their original rings. Adjacent logical
            // words become one complete cache-line store in each ring.
            let static_b=FLUSH && (WORD<RANKED_STATIC_B_PREFIX_END || WORD>=RANKED_STATIC_B_TAIL_START);
            if !static_b {
                if WORD%2==0 {self.paired_word=v;} else {
                    let o=(WORD-1)&(RING_WORDS-1);
                    let first=_mm512_shuffle_i64x2::<0x44>(self.paired_word,v);
                    let second=_mm512_shuffle_i64x2::<0xee>(self.paired_word,v);
                    _mm512_storeu_si512(self.first.stage.add(o).cast(),first);
                    _mm512_storeu_si512(self.second.stage.add(o).cast(),second);
                }
            }
            // Every ring-ending word is odd, so its complete word pair is
            // initialized before either drain may read the epoch.
            if FLUSH && WORD%RING_WORDS==RING_WORDS-1 {
                if WORD+1==RING_WORDS {
                    (*self.first.drain).drain_range_gen::<true>(16,16,RING_WORDS-16);
                    (*self.second.drain).drain_range_gen::<true>(16,16,RING_WORDS-16);
                } else {
                    (*self.first.drain).drain_range_gen::<true>(WORD+1-RING_WORDS,0,RING_WORDS);
                    (*self.second.drain).drain_range_gen::<true>(WORD+1-RING_WORDS,0,RING_WORDS);
                }
            }
        }
    }
    #[inline(always)]
    unsafe fn push<const USED:i32,const WIDTH:i32,const BACK:i32,const WORD:usize>(&mut self,v:V16) {
        unsafe {
            if USED==0 {
                if WIDTH==32 { self.write_word::<WORD>(v);self.pending=dup16(0); }
                else {self.pending=shl16::<1>(v);}
            } else {
                self.write_word::<WORD>(_mm512_shldi_epi32::<USED>(v,self.pending));
                self.pending=if WIDTH==31 {shl16::<1>(v)} else {v};
            }
        }
    }
    #[inline(always)]
    unsafe fn finish(&mut self) {unsafe {self.write_word::<LAST_WORD>(shr16::<15>(self.pending));}}
}
#[inline(always)]
fn add_parts16(x:V16,y:V16)->(V16,V16,V16) {
    unsafe {let s=_mm512_add_epi32(x,y);(s,xor16(s,y),xor16(s,x))}
}
#[inline(always)]
unsafe fn store_pair(first:*mut V8,second:*mut V8,v:V16) {
    unsafe {
        store_v8(first.cast(),_mm512_castsi512_si256(v));
        store_v8(second.cast(),_mm512_extracti64x4_epi64::<1>(v));
    }
}

/// # Safety
/// Each element describes the same disjoint, aligned octa outputs as the
/// eight-lane ranked producer. Both compact copies and stages remain live
/// until this function returns. Root output is handled by the inherited
/// proof-local root generator on this guarded pipeline route.
#[allow(clippy::too_many_arguments)]
pub(crate) unsafe fn build_pair<'a>(
    init:u64,bases:[usize;2],z:[*mut u32;2],a:[*mut u32;2],b:[*mut u32;2],
    projs:[StreamProj<'a>;2],preps:&'a RankedClosedWindowPreps,
) {
    unsafe {
        let [proj0,proj1]=projs;
        let p=prepare_closed_inputs_ordered(init,bases[0],proj0.cross_quarter);
        let q=prepare_closed_inputs_ordered(init,bases[1],proj1.cross_quarter);
        let join=|x:V8,y:V8|_mm512_inserti64x4::<1>(_mm512_castsi256_si512(x),y);
        let cv_v:[V16;8]=core::array::from_fn(|i|join(p.cv[i],q.cv[i]));
        let m:[V16;16]=core::array::from_fn(|i|join(p.message[i],q.message[i]));
        let tlo=join(p.counter_lo,q.counter_lo);
        let thi=join(p.counter_hi,q.counter_hi);
        let blen=join(p.block_len,q.block_len);
        let flags=join(p.flags,q.flags);
        let mut state:[V16;16]=[
            cv_v[0],cv_v[1],cv_v[2],cv_v[3],cv_v[4],cv_v[5],cv_v[6],cv_v[7],
            dup16(BLAKE3_IV[0]),dup16(BLAKE3_IV[1]),dup16(BLAKE3_IV[2]),dup16(BLAKE3_IV[3]),
            tlo,thi,blen,flags,
        ];
        let mut ast0=core::mem::MaybeUninit::<OctaRing>::uninit();
        let mut ast1=core::mem::MaybeUninit::<OctaRing>::uninit();
        let mut bs0=core::mem::MaybeUninit::<OctaRing>::uninit();
        let mut bs1=core::mem::MaybeUninit::<OctaRing>::uninit();
        let ast=[ast0.as_mut_ptr().cast::<V8>(),ast1.as_mut_ptr().cast::<V8>()];
        let bs=[bs0.as_mut_ptr().cast::<V8>(),bs1.as_mut_ptr().cast::<V8>()];
        let make_drain=|i:usize,proj:StreamProj<'a>| Drain8 {
            ast:ast[i],bs:bs[i],z:z[i],a:a[i],b:b[i],
            ranked_fast:proj.w30_elided && ranked_static01_direct_enabled() && ranked_b_constwin_enabled(),
            proj,elide:[true;3],ranked_static:true,cached_z:false,ranked_preps:Some(preps),roots:None,
        };
        let mut drains=[make_drain(0,proj0),make_drain(1,proj1)];
        let maxv=dup16(u32::MAX);let one=dup16(1);
        let chain:[V16;20]=[m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9],m[10],m[11],m[12],m[13],m[14],m[15],tlo,thi,blen,flags];
        for k in 0..20 {
            let v=if k==0 {or16(one,shl16::<1>(chain[0]))} else {or16(shr16::<31>(chain[k-1]),shl16::<1>(chain[k]))};
            let w=(16+k)&(RING_WORDS-1);store_pair(ast[0].add(w),ast[1].add(w),v);
        }
        for w in RANKED_STATIC_B_PREFIX_END..16+PROLOGUE_WORDS {
            store_pair(bs[0].add(w&(RING_WORDS-1)),bs[1].add(w&(RING_WORDS-1)),maxv);
        }
        if RING_WORDS <= PROLOGUE_WORDS + 16 {
            drains[0].drain_range_gen::<true>(16,16,RING_WORDS-16);
            drains[1].drain_range_gen::<true>(16,16,RING_WORDS-16);
        }
        let d0=&mut drains[0] as *mut Drain8;
        let d1=&mut drains[1] as *mut Drain8;
        let mut wa=PairWriter {
            pending:initial16(shr16::<31>(flags)),paired_word:dup16(0),
            first:W8::<false,true>::at(ast[0],dup_u32(0),d0,false),
            second:W8::<false,true>::at(ast[1],dup_u32(0),d1,false),
        };
        let mut wb=PairWriter {
            pending:initial16(one),paired_word:dup16(0),
            first:W8::<true,true>::at(bs[0],dup_u32(0),d0,true),
            second:W8::<true,true>::at(bs[1],dup_u32(0),d1,true),
        };
        macro_rules! g {
            ($g:expr, $la:literal, $lb:literal, $lc:literal, $ld:literal,
             $mx:literal, $my:literal) => {{
                let (t0, l0, r0) = add_parts16(state[$la], state[$lb]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C0, 31, l0);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C0, 31, r0);
                let (a1, l1, r1) = add_parts16(t0, m[$mx]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C1, 31, l1);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C1, 31, r1);
                let d1 = xor_rotr16::<16, 16>(state[$ld], a1);
                let (c1s, l2, r2) = add_parts16(state[$lc], d1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C2, 31, l2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C2, 31, r2);
                let b1 = xor_rotr16::<12, 20>(state[$lb], c1s);
                let (t1, l3, r3) = add_parts16(a1, b1);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C3, 31, l3);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C3, 31, r3);
                let (a2, l4, r4) = add_parts16(t1, m[$my]);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C4, 31, l4);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C4, 31, r4);
                let d2 = xor_rotr16::<8, 24>(d1, a2);
                let (c2s, l5, r5) = add_parts16(c1s, d2);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_C5, 31, l5);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_C5, 31, r5);
                let bn = xor_rotr16::<7, 25>(b1, c2s);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, bn);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN0, 32, maxv);
                pushf8!(wa, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, d2);
                pushf8!(wb, GS_BASE + G_STRIDE * $g + REC_LIN1, 32, maxv);
                state[$la] = a2;
                state[$lb] = bn;
                state[$lc] = c2s;
                state[$ld] = d2;
            }};
        }
        macro_rules! round {
            ($gb:literal, $m0:literal, $m1:literal, $m2:literal, $m3:literal,
             $m4:literal, $m5:literal, $m6:literal, $m7:literal,
             $m8:literal, $m9:literal, $m10:literal, $m11:literal,
             $m12:literal, $m13:literal, $m14:literal, $m15:literal) => {{
                g!($gb, 0, 4, 8, 12, $m0, $m1);
                g!($gb + 1, 1, 5, 9, 13, $m2, $m3);
                g!($gb + 2, 2, 6, 10, 14, $m4, $m5);
                g!($gb + 3, 3, 7, 11, 15, $m6, $m7);
                g!($gb + 4, 0, 5, 10, 15, $m8, $m9);
                g!($gb + 5, 1, 6, 11, 12, $m10, $m11);
                g!($gb + 6, 2, 7, 8, 13, $m12, $m13);
                g!($gb + 7, 3, 4, 9, 14, $m14, $m15);
            }};
        }
        round!(0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        round!(8, 2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8);
        round!(16, 3, 4, 10, 12, 13, 2, 7, 14, 6, 5, 9, 0, 11, 15, 8, 1);
        round!(24, 10, 7, 12, 9, 14, 3, 13, 15, 4, 0, 11, 2, 5, 8, 1, 6);
        round!(32, 12, 13, 9, 11, 15, 10, 14, 8, 7, 2, 5, 3, 0, 1, 6, 4);
        round!(40, 9, 14, 11, 5, 8, 12, 15, 1, 13, 3, 0, 10, 2, 6, 4, 7);
        round!(48, 11, 15, 5, 0, 1, 9, 8, 6, 14, 10, 2, 12, 3, 4, 7, 13);

        const {
            assert!(OUT_HI_BASE % 32 == 17);
        }
        macro_rules! oh {
            ($w:literal) => {{
                let hv = xor16(state[$w + 8], cv_v[$w]);
                pushf8!(wa, OUT_HI_BASE + 32 * $w, 32, hv);
                pushf8!(wb, OUT_HI_BASE + 32 * $w, 32, maxv);
            }};
        }
        oh!(0);
        oh!(1);
        oh!(2);
        oh!(3);
        oh!(4);
        oh!(5);
        oh!(6);
        oh!(7);
        wa.finish();
        wb.finish();


        drains[0].drain_range_gen::<true>(U32_PER_BLOCK-RING_WORDS,0,RING_WORDS);
        drains[1].drain_range_gen::<true>(U32_PER_BLOCK-RING_WORDS,0,RING_WORDS);
        for w in 0..8 {
            store_pair(ast[0].add(w),ast[1].add(w),cv_v[w]);
            store_pair(ast[0].add(8+w),ast[1].add(8+w),xor16(state[w],state[w+8]));
        }
        drains[0].drain_range_gen::<true>(0,0,16);
        drains[1].drain_range_gen::<true>(0,0,16);
    }
}
pub(crate) fn enabled()->bool {
    static ON:std::sync::LazyLock<bool>=std::sync::LazyLock::new(||std::env::var_os("FLOCK_NO_WITGEN16").is_none());*ON
}

#[cfg(test)]
mod tests {
    use super::*;
    #[repr(align(64))]
    #[derive(Clone,Debug,PartialEq,Eq)]
    struct Words([u32;8*U32_PER_BLOCK]);
    #[repr(align(64))]
    #[derive(Clone,Debug,PartialEq,Eq)]
    struct Inner([u8;8*29*64]);
    #[repr(align(64))]
    #[derive(Clone)]
    struct Stage([u32;STREAM_STAGE_WORDS]);
    #[derive(Clone)]
    struct Buffers { z:Box<Words>,a:Box<Words>,b:Box<Words>,compact:Box<Words>,inner:Box<Inner>,stage:Box<Stage> }
    impl Buffers {
        fn new()->Self { Self {
            z:Box::new(Words([0xa5a5a5a5;8*U32_PER_BLOCK])),
            a:Box::new(Words([0xa5a5a5a5;8*U32_PER_BLOCK])),
            b:Box::new(Words([0xa5a5a5a5;8*U32_PER_BLOCK])),
            compact:Box::new(Words([0;8*U32_PER_BLOCK])),
            inner:Box::new(Inner([0xa5;8*29*64])),
            stage:Box::new(Stage([0;STREAM_STAGE_WORDS])),
        }}
    }
    fn proj<'a>(buf:&mut Buffers,table:&'a InvNttTableByteSingleGf8,plan:Round1AbWindowPlan,elide:bool)->StreamProj<'a> {
        StreamProj {
            stage:buf.stage.0.as_mut_ptr(),out:buf.inner.0.as_mut_ptr(),out_stride:29*64,
            cross_quarter:false,compact_z:buf.compact.0.as_mut_ptr(),elide_z:elide,out_bias:2*64,
            inv_table:table,plan,one_rows_elided:true,w30_elided:true,
        }
    }
    #[test]
    fn paired_witness_matches_two_octas() {
        let small=flock_core::ntt::AdditiveNttGf8::new(6,flock_core::field::F8::ZERO);
        let large=flock_core::ntt::AdditiveNttGf8::new(6,flock_core::field::F8(64));
        let table=InvNttTableByteSingleGf8::new(&small,&large);
        let dummy=Box::new(Inner([0;8*29*64]));
        let plan=flock_core::zerocheck::univariate_skip_optimized::prepare_round1_ab_window_plan(&table,&dummy.0,true);
        assert!(plan.offsets_eligible(2));
        let preps=prepare_ranked_closed_window_preps(&table,plan);
        for init in [0,0x13579bdf2468ace0,u64::MAX] {
            for bases in [[0,8],[512,1024],[65520,131000]] {
                for elide in [false,true] {
                    let mut reference:[Buffers;2]=core::array::from_fn(|_|Buffers::new());
                    let mut candidate=reference.clone();
                    unsafe {
                        for i in 0..2 {
                            let p=proj(&mut reference[i],&table,plan,elide);
                            build_octa_witness_ab_stream_ranked_closed(init,bases[i],
                                reference[i].z.0.as_mut_ptr(),reference[i].a.0.as_mut_ptr(),reference[i].b.0.as_mut_ptr(),
                                p,&preps,[true;3],None,false);
                        }
                        let z=core::array::from_fn(|i|candidate[i].z.0.as_mut_ptr());
                        let a=core::array::from_fn(|i|candidate[i].a.0.as_mut_ptr());
                        let b=core::array::from_fn(|i|candidate[i].b.0.as_mut_ptr());
                        let p=core::array::from_fn(|i|proj(&mut candidate[i],&table,plan,elide));
                        build_pair(init,bases,z,a,b,p,&preps);
                        _mm_sfence();
                    }
                    for i in 0..2 {
                        assert_eq!(candidate[i].z,reference[i].z,"z init={init:x} bases={bases:?} elide={elide}");
                        assert_eq!(candidate[i].a,reference[i].a,"a init={init:x} bases={bases:?} elide={elide}");
                        assert_eq!(candidate[i].b,reference[i].b,"b init={init:x} bases={bases:?} elide={elide}");
                        assert_eq!(candidate[i].compact,reference[i].compact,"compact init={init:x} bases={bases:?} elide={elide}");
                        assert_eq!(candidate[i].inner,reference[i].inner,"inner init={init:x} bases={bases:?} elide={elide}");
                    }
                }
            }
        }
    }
}
