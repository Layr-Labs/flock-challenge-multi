//! Structurally branded packed-B residual storage for ranked BLAKE3.
//! A block has 2048 logical bytes, 1358 variable bytes and 1408 physical bytes.
//! Constants follow only from the packed writer's prefix, G linear-one fields,
//! output-high fields and zero padding. No witness census is trusted here.
use core::mem::{ManuallyDrop, MaybeUninit};

pub const LOGICAL_BYTES: usize = 2048;
pub const PAYLOAD_BYTES: usize = 1358;
pub const PHYSICAL_BYTES: usize = 1408;
pub const LINES: usize = 32;
pub const STORED_LINES: usize = 22;

#[derive(Clone, Copy)]
pub struct LinePlan {
    pub variable_mask: u64,
    pub offset: usize,
    pub count: usize,
    pub constants: [u8; 64],
}

const fn fixed_bit(i: usize) -> Option<u8> {
    if i < 1153 {
        return Some(1);
    }
    if i < 15153 {
        if (i - 1153) % 250 >= 186 {
            return Some(1);
        }
        return None;
    }
    if i < 15409 { Some(1) } else { Some(0) }
}

const fn plans() -> [LinePlan; LINES] {
    let mut p = [LinePlan {
        variable_mask: 0,
        offset: 0,
        count: 0,
        constants: [0; 64],
    }; LINES];
    let mut offset = 0;
    let mut line = 0;
    while line < LINES {
        p[line].offset = offset;
        let mut byte = 0;
        while byte < 64 {
            let mut constant = true;
            let mut value = 0;
            let mut bit = 0;
            while bit < 8 {
                match fixed_bit(line * 512 + byte * 8 + bit) {
                    Some(v) => value |= v << bit,
                    None => constant = false,
                }
                bit += 1;
            }
            if constant {
                p[line].constants[byte] = value;
            } else {
                p[line].variable_mask |= 1u64 << byte;
                p[line].count += 1;
            }
            byte += 1;
        }
        offset += p[line].count;
        line += 1;
    }
    assert!(offset == PAYLOAD_BYTES);
    p
}
pub const PLAN: [LinePlan; LINES] = plans();

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    Shape,
    Bounds,
    ConstantMismatch,
    Order,
    Incomplete,
    AlreadyComplete,
}

/// Allocation alignment and deallocation layout remain identical throughout.
#[repr(C, align(64))]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CacheLine(pub [u8; 64]);

/// One allocation only, with no readable-owner or contents provenance. The
/// dense scratch allocator's alignment class does not cover these cache lines.
struct RawAllocation {
    lines: Vec<MaybeUninit<CacheLine>>,
    blocks: usize,
}
struct AllocationPool(std::sync::Mutex<Option<RawAllocation>>);
impl AllocationPool {
    const fn new() -> Self {
        Self(std::sync::Mutex::new(None))
    }
    fn take(&self, blocks: usize, len: usize) -> Option<Vec<MaybeUninit<CacheLine>>> {
        // Release the mutex before disposing of a mismatched large allocation.
        let allocation = self.0.lock().unwrap_or_else(|e| e.into_inner()).take();
        match allocation {
            Some(a) if a.blocks == blocks && a.lines.len() == len => Some(a.lines),
            _ => None,
        }
    }
    fn put(&self, allocation: RawAllocation) {
        // Keep at most one physical allocation. A shape change replaces the
        // retained capacity; deallocation never runs while the pool is locked.
        let previous = self
            .0
            .lock()
            .unwrap_or_else(|e| e.into_inner())
            .replace(allocation);
        drop(previous);
    }
}
static ALLOCATION_POOL: AllocationPool = AllocationPool::new();

fn forget_contents(lines: Vec<CacheLine>) -> Vec<MaybeUninit<CacheLine>> {
    let mut lines = ManuallyDrop::new(lines);
    // The two element types have identical size/alignment and allocator layout.
    // Changing to MaybeUninit forgets readable provenance, not allocation size.
    unsafe { Vec::from_raw_parts(lines.as_mut_ptr().cast(), lines.len(), lines.capacity()) }
}

/// Owned dense representation. It is never an alias of compact storage.
pub struct DenseB {
    lines: Vec<CacheLine>,
    blocks: usize,
}
impl DenseB {
    pub fn from_lines(lines: Vec<CacheLine>) -> Result<Self, Error> {
        if lines.is_empty() || lines.len() % LINES != 0 {
            return Err(Error::Shape);
        }
        let blocks = lines.len() / LINES;
        Ok(Self { lines, blocks })
    }
    pub fn blocks(&self) -> usize {
        self.blocks
    }
    pub fn lines(&self) -> &[CacheLine] {
        &self.lines
    }
    pub fn into_lines(self) -> Vec<CacheLine> {
        self.lines
    }
}

/// Fully initialized physical records. Fields are private to prevent forgery.
pub struct ResidualB {
    lines: Vec<CacheLine>,
    blocks: usize,
}
impl ResidualB {
    pub fn blocks(&self) -> usize {
        self.blocks
    }
    pub fn physical_bytes(&self) -> usize {
        self.lines.len() * 64
    }
    pub fn view(&self) -> ResidualView<'_> {
        ResidualView {
            lines: &self.lines,
            blocks: self.blocks,
        }
    }
    pub fn decode_line(&self, block: usize, line: usize) -> Result<[u8; 64], Error> {
        self.view().decode_line(block, line)
    }
    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi2")]
    pub unsafe fn decode_line_native(&self, block: usize, line: usize) -> Result<[u8; 64], Error> {
        unsafe { self.view().decode_line_native(block, line) }
    }
    pub fn copy_dense_into(&self, out: &mut [u8]) -> Result<(), Error> {
        if out.len() != self.blocks.checked_mul(LOGICAL_BYTES).ok_or(Error::Shape)? {
            return Err(Error::Shape);
        }
        for block in 0..self.blocks {
            for line in 0..LINES {
                out[block * LOGICAL_BYTES + line * 64..block * LOGICAL_BYTES + (line + 1) * 64]
                    .copy_from_slice(&self.decode_line(block, line)?);
            }
        }
        Ok(())
    }
    pub fn into_dense(self) -> DenseB {
        let lines = (0..self.blocks)
            .flat_map(|b| (0..LINES).map(move |l| (b, l)))
            .map(|(b, l)| CacheLine(self.decode_line(b, l).expect("bounded indices")))
            .collect();
        DenseB {
            lines,
            blocks: self.blocks,
        }
    }
    /// Recycle only the allocation. Builder overwrites all records and padding.
    pub fn into_allocation(self) -> Vec<CacheLine> {
        self.lines
    }
    /// Retain capacity only. The next builder starts with no completed block
    /// and must overwrite every payload byte and every padding byte again.
    pub fn recycle(self) {
        self.recycle_into_pool(&ALLOCATION_POOL);
    }
    fn recycle_into_pool(self, pool: &AllocationPool) {
        pool.put(RawAllocation {
            lines: forget_contents(self.lines),
            blocks: self.blocks,
        });
    }
}

#[derive(Clone, Copy)]
pub struct ResidualView<'a> {
    lines: &'a [CacheLine],
    blocks: usize,
}
impl ResidualView<'_> {
    #[inline]
    pub fn num_blocks(&self) -> usize {
        self.blocks
    }
    #[inline]
    pub fn logical_bytes(&self) -> usize {
        self.blocks * LOGICAL_BYTES
    }
    #[inline]
    pub fn physical_bytes(&self) -> usize {
        self.lines.len() * 64
    }
    #[inline]
    fn record(&self, block: usize) -> Result<&[u8], Error> {
        if block >= self.blocks {
            return Err(Error::Bounds);
        }
        let first = self.lines.as_ptr();
        // Every CacheLine is initialized, the Vec is contiguous and aligned.
        Ok(unsafe {
            core::slice::from_raw_parts(first.add(block * STORED_LINES).cast(), PHYSICAL_BYTES)
        })
    }
    #[inline]
    pub fn decode_line(&self, block: usize, line: usize) -> Result<[u8; 64], Error> {
        if line >= LINES {
            return Err(Error::Bounds);
        }
        let source = self.record(block)?;
        let p = &PLAN[line];
        let mut out = p.constants;
        let mut at = p.offset;
        for (i, byte) in out.iter_mut().enumerate() {
            if p.variable_mask & (1u64 << i) != 0 {
                *byte = source[at];
                at += 1;
            }
        }
        Ok(out)
    }
    #[cfg(target_arch = "x86_64")]
    #[inline]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi2")]
    pub unsafe fn decode_line_native(&self, block: usize, line: usize) -> Result<[u8; 64], Error> {
        use core::arch::x86_64::*;
        if line >= LINES {
            return Err(Error::Bounds);
        }
        let source = self.record(block)?;
        let p = &PLAN[line];
        let mut out = [0u8; 64];
        unsafe {
            let constants = _mm512_loadu_si512(p.constants.as_ptr().cast());
            let value = _mm512_mask_expandloadu_epi8(
                constants,
                p.variable_mask,
                source.as_ptr().add(p.offset).cast(),
            );
            _mm512_storeu_si512(out.as_mut_ptr().cast(), value);
        }
        Ok(out)
    }
    /// Expand one64-row packed-reader chunk (8 bytes per logical row).
    #[inline]
    pub fn expand64_rows(&self, first_row: usize, out: &mut [CacheLine; 8]) -> Result<(), Error> {
        if first_row % 64 != 0
            || first_row
                .checked_add(64)
                .is_none_or(|end| end > self.blocks * 256)
        {
            return Err(Error::Bounds);
        }
        let block = first_row / 256;
        let first_line = (first_row % 256) / 8;
        for (i, line) in out.iter_mut().enumerate() {
            line.0 = self.decode_line(block, first_line + i)?;
        }
        Ok(())
    }
    /// # Safety
    /// The current CPU must support AVX512F, AVX512BW and AVX512VBMI2.
    #[cfg(target_arch = "x86_64")]
    #[cfg_attr(
        all(
            target_feature = "avx512f",
            target_feature = "avx512bw",
            target_feature = "avx512vbmi2"
        ),
        inline(always)
    )]
    #[cfg_attr(
        not(all(
            target_feature = "avx512f",
            target_feature = "avx512bw",
            target_feature = "avx512vbmi2"
        )),
        inline
    )]
    #[cfg_attr(
        not(all(
            target_feature = "avx512f",
            target_feature = "avx512bw",
            target_feature = "avx512vbmi2"
        )),
        target_feature(enable = "avx512f,avx512bw,avx512vbmi2")
    )]
    pub unsafe fn expand64_rows_native(
        &self,
        first_row: usize,
        out: &mut [CacheLine; 8],
    ) -> Result<(), Error> {
        if first_row % 64 != 0
            || first_row
                .checked_add(64)
                .is_none_or(|end| end > self.blocks * 256)
        {
            return Err(Error::Bounds);
        }
        use core::arch::x86_64::*;
        let block = first_row / 256;
        let first_line = (first_row % 256) / 8;
        let source = self.record(block)?;
        for (i, line) in out.iter_mut().enumerate() {
            let p = &PLAN[first_line + i];
            unsafe {
                let constants = _mm512_loadu_si512(p.constants.as_ptr().cast());
                let value = _mm512_mask_expandloadu_epi8(
                    constants,
                    p.variable_mask,
                    source.as_ptr().add(p.offset).cast(),
                );
                _mm512_store_si512(line.0.as_mut_ptr().cast(), value);
            }
        }
        Ok(())
    }
    /// Public fallback materializes a new real dense allocation.
    pub fn to_dense_bytes(&self) -> Vec<u8> {
        let mut out = vec![0; self.logical_bytes()];
        for block in 0..self.blocks {
            for line in 0..LINES {
                out[block * LOGICAL_BYTES + line * 64..block * LOGICAL_BYTES + (line + 1) * 64]
                    .copy_from_slice(
                        &self
                            .decode_line(block, line)
                            .expect("branded bounded record"),
                    );
            }
        }
        out
    }
    /// A legal address inside the physical record, never a dense-stride cast.
    #[inline]
    pub fn prefetch_ptr(&self, first_row: usize) -> Option<*const u8> {
        if first_row % 64 != 0
            || first_row
                .checked_add(64)
                .is_none_or(|end| end > self.blocks * 256)
        {
            return None;
        }
        let block = first_row / 256;
        let line = (first_row % 256) / 8;
        Some(unsafe {
            self.lines
                .as_ptr()
                .add(block * STORED_LINES)
                .cast::<u8>()
                .add(PLAN[line].offset)
        })
    }
}

/// Initialize just the bytes that are reconstructed from the structural plan.
/// The producer must overwrite every other byte before encoding a block.
pub fn fill_dense_constants(dense: &mut [u8; LOGICAL_BYTES]) {
    for (line, p) in PLAN.iter().enumerate() {
        for byte in 0..64 {
            if p.variable_mask & (1u64 << byte) == 0 {
                dense[line * 64 + byte] = p.constants[byte];
            }
        }
    }
}

/// Until all records are published only MaybeUninit storage exists. This avoids
/// a full-sized initialization pass without constructing an invalid typed Vec.
pub struct Builder {
    lines: Vec<MaybeUninit<CacheLine>>,
    complete: Vec<bool>,
    blocks: usize,
}
impl Builder {
    pub fn new(blocks: usize) -> Result<Self, Error> {
        Self::new_with_pool(blocks, &ALLOCATION_POOL)
    }
    fn new_with_pool(blocks: usize, pool: &AllocationPool) -> Result<Self, Error> {
        let n = blocks.checked_mul(STORED_LINES).ok_or(Error::Shape)?;
        if n == 0 {
            return Err(Error::Shape);
        }
        let lines = pool.take(blocks, n).unwrap_or_else(|| {
            let mut lines = Vec::with_capacity(n);
            // MaybeUninit permits uninitialized bytes; no clear pass is needed.
            unsafe {
                lines.set_len(n);
            }
            lines
        });
        Ok(Self {
            lines,
            complete: vec![false; blocks],
            blocks,
        })
    }
    /// Stale allocation bytes convey no proof/layout provenance.
    pub fn from_allocation(lines: Vec<CacheLine>, blocks: usize) -> Result<Self, Error> {
        if blocks == 0 || blocks.checked_mul(STORED_LINES) != Some(lines.len()) {
            return Err(Error::Shape);
        }
        let lines = forget_contents(lines);
        Ok(Self {
            lines,
            complete: vec![false; blocks],
            blocks,
        })
    }
    pub fn block(&mut self, block: usize) -> Result<BlockWriter<'_>, Error> {
        if block >= self.blocks {
            return Err(Error::Bounds);
        }
        if self.complete[block] {
            return Err(Error::AlreadyComplete);
        }
        Ok(BlockWriter {
            destination: &mut self.lines[block * STORED_LINES..(block + 1) * STORED_LINES],
            complete: &mut self.complete[block],
            pending: Pending([MaybeUninit::uninit(); PHYSICAL_BYTES]),
            next: 2,
            nt_pending: false,
        })
    }
    /// Disjoint chunks can be moved to parallel workers. No unbranded writable
    /// residual byte slice is exposed to a caller.
    pub fn chunks_mut(&mut self, blocks: usize) -> impl Iterator<Item = ChunkWriter<'_>> {
        assert!(blocks > 0, "nonempty producer chunks");
        self.lines
            .chunks_mut(blocks.checked_mul(STORED_LINES).expect("chunk size"))
            .zip(self.complete.chunks_mut(blocks))
            .map(|(lines, complete)| ChunkWriter { lines, complete })
    }
    pub fn finish(self) -> Result<ResidualB, Error> {
        if !self.complete.iter().all(|x| *x) {
            return Err(Error::Incomplete);
        }
        let mut lines = ManuallyDrop::new(self.lines);
        // Every payload byte and all padding was initialized before its block's
        // completion flag was set. The Vec has the actual physical length.
        let lines = unsafe {
            Vec::from_raw_parts(lines.as_mut_ptr().cast(), lines.len(), lines.capacity())
        };
        Ok(ResidualB {
            lines,
            blocks: self.blocks,
        })
    }
}

pub struct ChunkWriter<'a> {
    lines: &'a mut [MaybeUninit<CacheLine>],
    complete: &'a mut [bool],
}
impl ChunkWriter<'_> {
    pub fn blocks(&self) -> usize {
        self.complete.len()
    }
    pub fn block(&mut self, block: usize) -> Result<BlockWriter<'_>, Error> {
        if block >= self.blocks() {
            return Err(Error::Bounds);
        }
        if self.complete[block] {
            return Err(Error::AlreadyComplete);
        }
        Ok(BlockWriter {
            destination: &mut self.lines[block * STORED_LINES..(block + 1) * STORED_LINES],
            complete: &mut self.complete[block],
            pending: Pending([MaybeUninit::uninit(); PHYSICAL_BYTES]),
            next: 2,
            nt_pending: false,
        })
    }
    pub fn encode_dense_block(
        &mut self,
        block: usize,
        dense: &[u8; LOGICAL_BYTES],
    ) -> Result<(), Error> {
        let mut w = self.block(block)?;
        for line in [1].into_iter().chain(2..30).chain([30, 0, 31]) {
            w.record_line(
                line,
                dense[line * 64..(line + 1) * 64]
                    .try_into()
                    .expect("fixed line"),
            )?;
        }
        w.finish()
    }
    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi2")]
    pub unsafe fn encode_dense_block_native(
        &mut self,
        block: usize,
        dense: &[u8; LOGICAL_BYTES],
        nt: bool,
    ) -> Result<(), Error> {
        let mut w = self.block(block)?;
        for line in [1].into_iter().chain(2..30).chain([30, 0, 31]) {
            unsafe {
                w.record_line_native(
                    line,
                    dense[line * 64..(line + 1) * 64]
                        .try_into()
                        .expect("fixed line"),
                    nt,
                )?;
            }
        }
        w.finish()
    }
    /// Encode eight blocks under one thread-local publication fence. Completed
    /// records cannot escape this mutable borrow until the guard has drained
    /// every streaming store, including on error or unwind.
    ///
    /// # Safety
    /// The current CPU must support AVX512F, AVX512BW and AVX512VBMI2.
    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi2")]
    pub unsafe fn encode_dense_octa_native(
        &mut self,
        first: usize,
        dense: &[u8; 8 * LOGICAL_BYTES],
        nt: bool,
    ) -> Result<(), Error> {
        if first.checked_add(8).is_none_or(|end| end > self.blocks()) {
            return Err(Error::Bounds);
        }
        let mut fence = NtBatchFence::new();
        for block in 0..8 {
            let mut w = self.block(first + block)?;
            for line in [1].into_iter().chain(2..30).chain([30, 0, 31]) {
                let offset = block * LOGICAL_BYTES + line * 64;
                unsafe {
                    w.record_line_native(
                        line,
                        dense[offset..offset + 64].try_into().expect("fixed line"),
                        nt,
                    )?;
                }
            }
            // Only this method may defer completion fencing to its local guard.
            w.finish_deferred(&mut fence)?;
        }
        Ok(())
    }
}

#[cfg(target_arch = "x86_64")]
struct NtBatchFence {
    pending: bool,
    // Deliberately neither Send nor Sync: streaming stores must be fenced on
    // the producer thread, not after moving a deferred writer to another one.
    _same_thread: core::marker::PhantomData<*mut ()>,
}
#[cfg(target_arch = "x86_64")]
impl NtBatchFence {
    fn new() -> Self {
        Self {
            pending: false,
            _same_thread: core::marker::PhantomData,
        }
    }
}
#[cfg(target_arch = "x86_64")]
impl Drop for NtBatchFence {
    fn drop(&mut self) {
        if self.pending {
            unsafe {
                core::arch::x86_64::_mm_sfence();
            }
        }
    }
}

#[repr(C, align(64))]
struct Pending([MaybeUninit<u8>; PHYSICAL_BYTES]);
pub struct BlockWriter<'a> {
    destination: &'a mut [MaybeUninit<CacheLine>],
    complete: &'a mut bool,
    pending: Pending,
    next: usize,
    nt_pending: bool,
}
impl BlockWriter<'_> {
    fn check(&self, line: usize, input: &[u8; 64]) -> Result<(), Error> {
        if line >= LINES {
            return Err(Error::Bounds);
        }
        let p = &PLAN[line];
        for (i, &v) in input.iter().enumerate() {
            if p.variable_mask & (1u64 << i) == 0 && v != p.constants[i] {
                return Err(Error::ConstantMismatch);
            }
        }
        if p.count != 0 && line != self.next {
            return Err(Error::Order);
        }
        Ok(())
    }
    pub fn record_line(&mut self, line: usize, input: &[u8; 64]) -> Result<(), Error> {
        self.check(line, input)?;
        let p = &PLAN[line];
        let mut at = p.offset;
        for (i, &v) in input.iter().enumerate() {
            if p.variable_mask & (1u64 << i) != 0 {
                self.pending.0[at].write(v);
                at += 1;
            }
        }
        self.publish_completed(line, false)
    }
    #[cfg(target_arch = "x86_64")]
    #[target_feature(enable = "avx512f,avx512bw,avx512vbmi2")]
    pub unsafe fn record_line_native(
        &mut self,
        line: usize,
        input: &[u8; 64],
        nt: bool,
    ) -> Result<(), Error> {
        use core::arch::x86_64::*;
        if line >= LINES {
            return Err(Error::Bounds);
        }
        let p = &PLAN[line];
        if p.count != 0 && line != self.next {
            return Err(Error::Order);
        }
        unsafe {
            let v = _mm512_loadu_si512(input.as_ptr().cast());
            let constants = _mm512_loadu_si512(p.constants.as_ptr().cast());
            if _mm512_cmpeq_epi8_mask(v, constants) | p.variable_mask != u64::MAX {
                return Err(Error::ConstantMismatch);
            }
            _mm512_mask_compressstoreu_epi8(
                self.pending.0.as_mut_ptr().add(p.offset).cast(),
                p.variable_mask,
                v,
            );
        }
        self.publish_completed(line, nt)
    }
    fn publish_completed(&mut self, line: usize, nt: bool) -> Result<(), Error> {
        let p = &PLAN[line];
        if p.count == 0 {
            return Ok(());
        }
        let old = p.offset / 64;
        let end = (p.offset + p.count) / 64;
        if end > old {
            self.publish(old, nt);
        }
        self.next = line + 1;
        Ok(())
    }
    fn publish(&mut self, line: usize, nt: bool) {
        // Cursor order proves the entire source line has been initialized.
        let source = unsafe { self.pending.0.as_ptr().add(line * 64).cast::<u8>() };
        let dest = self.destination[line].as_mut_ptr().cast::<u8>();
        #[cfg(target_arch = "x86_64")]
        if nt {
            unsafe { stream_line(source, dest) };
            self.nt_pending = true;
            return;
        }
        let _ = nt;
        unsafe {
            core::ptr::copy_nonoverlapping(source, dest, 64);
        }
    }
    pub fn finish(mut self) -> Result<(), Error> {
        self.finish_payload()?;
        self.fence();
        *self.complete = true;
        Ok(())
    }
    #[cfg(target_arch = "x86_64")]
    fn finish_deferred(mut self, fence: &mut NtBatchFence) -> Result<(), Error> {
        self.finish_payload()?;
        // An explicit guard receives responsibility for this thread's stores.
        // There is no public method that can leak a deferred writer or guard.
        fence.pending |= self.nt_pending;
        self.nt_pending = false;
        *self.complete = true;
        Ok(())
    }
    fn finish_payload(&mut self) -> Result<(), Error> {
        if self.next != 30 {
            return Err(Error::Incomplete);
        }
        for i in PAYLOAD_BYTES..PHYSICAL_BYTES {
            self.pending.0[i].write(0);
        }
        self.publish(STORED_LINES - 1, false);
        Ok(())
    }
    fn fence(&mut self) {
        if self.nt_pending {
            #[cfg(target_arch = "x86_64")]
            unsafe {
                core::arch::x86_64::_mm_sfence();
            }
            self.nt_pending = false;
        }
    }
}
impl Drop for BlockWriter<'_> {
    fn drop(&mut self) {
        // A rejected or abandoned partial block can free its allocation too.
        // Drain outstanding streaming stores before its borrow is released.
        self.fence();
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx512f")]
unsafe fn stream_line(source: *const u8, dest: *mut u8) {
    unsafe {
        core::arch::x86_64::_mm512_stream_si512(
            dest.cast(),
            core::arch::x86_64::_mm512_load_si512(source.cast()),
        );
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn dense(seed: u64) -> [[u8; 64]; 32] {
        let mut x = seed;
        std::array::from_fn(|l| {
            std::array::from_fn(|b| {
                if PLAN[l].variable_mask & (1 << b) == 0 {
                    PLAN[l].constants[b]
                } else {
                    x ^= x << 13;
                    x ^= x >> 7;
                    x ^= x << 17;
                    x as u8
                }
            })
        })
    }
    fn publish_builder(mut builder: Builder, seed: u64) -> ResidualB {
        for block in 0..builder.blocks {
            let input = dense(seed + block as u64);
            let mut writer = builder.block(block).unwrap();
            for line in 2..30 {
                writer.record_line(line, &input[line]).unwrap();
            }
            writer.finish().unwrap();
        }
        builder.finish().unwrap()
    }
    #[test]
    fn capacity_only_pool_reuses_pointer_but_never_completion_or_payload() {
        // Local pool avoids relying on exclusive access to the process-global
        // slot while the complete crate's other tests run concurrently.
        let pool = AllocationPool::new();
        let first = publish_builder(Builder::new_with_pool(8, &pool).unwrap(), 0x1234);
        let pointer = first.lines.as_ptr() as usize;
        first.recycle_into_pool(&pool);
        let next = Builder::new_with_pool(8, &pool).unwrap();
        assert_eq!(next.lines.as_ptr() as usize, pointer);
        assert_eq!(next.complete, [false; 8]);
        assert!(matches!(next.finish(), Err(Error::Incomplete)));
        for seed in 1..33 {
            let first = publish_builder(Builder::new_with_pool(8, &pool).unwrap(), seed);
            let pointer = first.lines.as_ptr() as usize;
            first.recycle_into_pool(&pool);
            {
                let mut slot = pool.0.lock().unwrap();
                for line in &mut slot.as_mut().unwrap().lines {
                    line.write(CacheLine([0xa5; 64]));
                }
            }
            let builder = Builder::new_with_pool(8, &pool).unwrap();
            assert_eq!(builder.lines.as_ptr() as usize, pointer);
            assert!(builder.complete.iter().all(|v| !*v));
            let owner = publish_builder(builder, seed + 0x5678);
            for block in 0..8 {
                assert_eq!(
                    owner.view().to_dense_bytes()[block * 2048..(block + 1) * 2048],
                    dense(seed + 0x5678 + block as u64).concat()
                );
                assert_eq!(
                    owner.view().record(block).unwrap()[PAYLOAD_BYTES..],
                    [0; 50]
                );
            }
            owner.recycle_into_pool(&pool);
        }
    }
    #[test]
    fn pool_shape_bounds_and_parallel_capacity_are_isolated() {
        let pool = AllocationPool::new();
        publish_builder(Builder::new_with_pool(2, &pool).unwrap(), 1).recycle_into_pool(&pool);
        assert!(matches!(
            Builder::new_with_pool(0, &pool),
            Err(Error::Shape)
        ));
        assert!(matches!(
            Builder::new_with_pool(usize::MAX, &pool),
            Err(Error::Shape)
        ));
        assert_eq!(pool.0.lock().unwrap().as_ref().unwrap().blocks, 2);
        // Exact physical length is checked separately from block metadata.
        assert!(pool.take(2, STORED_LINES * 2 + 1).is_none());
        assert!(pool.0.lock().unwrap().is_none());
        for blocks in [1, 17, 3, 8, 2] {
            let builder = Builder::new_with_pool(blocks, &pool).unwrap();
            assert_eq!(builder.lines.len(), blocks * STORED_LINES);
            let owner = publish_builder(builder, blocks as u64);
            assert_eq!(owner.physical_bytes(), blocks * PHYSICAL_BYTES);
            owner.recycle_into_pool(&pool);
        }
        std::thread::scope(|scope| {
            for worker in 0..8usize {
                let pool = &pool;
                scope.spawn(move || {
                    for iteration in 0..16 {
                        let blocks = 1 + (worker + iteration) % 9;
                        let seed = (worker * 100 + iteration + 1) as u64;
                        let builder = Builder::new_with_pool(blocks, pool).unwrap();
                        assert_eq!(builder.lines.len(), blocks * STORED_LINES);
                        assert!(builder.complete.iter().all(|v| !*v));
                        let owner = publish_builder(builder, seed);
                        for block in 0..blocks {
                            for line in 0..32 {
                                assert_eq!(
                                    owner.decode_line(block, line).unwrap(),
                                    dense(seed + block as u64)[line]
                                );
                            }
                        }
                        owner.recycle_into_pool(pool);
                    }
                });
            }
        });
        let slot = pool.0.lock().unwrap();
        let one = slot.as_ref().unwrap();
        assert_eq!(one.lines.len(), one.blocks * STORED_LINES);
        assert!((1..=9).contains(&one.blocks));
    }
    #[test]
    fn public_recycle_routing_still_requires_fresh_witness() {
        publish_builder(Builder::new(3).unwrap(), 0xabc).recycle();
        // Another thread may take the global slot. Correctness must hold with
        // either a recycled or a newly allocated buffer; no pointer assumption.
        let builder = Builder::new(3).unwrap();
        assert_eq!(builder.complete, [false; 3]);
        assert!(matches!(builder.finish(), Err(Error::Incomplete)));
        let owner = publish_builder(Builder::new(3).unwrap(), 0xdef);
        for block in 0..3 {
            for line in 0..32 {
                assert_eq!(
                    owner.decode_line(block, line).unwrap(),
                    dense(0xdef + block as u64)[line]
                );
            }
        }
        owner.recycle();
    }
    fn encode(input: &[[u8; 64]; 32], native: bool, nt: bool) -> ResidualB {
        let mut builder = Builder::new(1).unwrap();
        let mut w = builder.block(0).unwrap();
        // Actual producer epoch: line1, live2..29, tail30, then deferred0.
        for l in [1].into_iter().chain(2..30).chain([30, 0, 31]) {
            #[cfg(target_arch = "x86_64")]
            if native {
                unsafe { w.record_line_native(l, &input[l], nt).unwrap() };
                continue;
            }
            w.record_line(l, &input[l]).unwrap();
        }
        w.finish().unwrap();
        builder.finish().unwrap()
    }
    #[test]
    fn structural_plan_size_and_known_boundaries() {
        assert_eq!(PLAN.iter().map(|p| p.count).sum::<usize>(), 1358);
        assert_eq!(
            [PLAN[0].count, PLAN[1].count, PLAN[30].count, PLAN[31].count],
            [0; 4]
        );
        assert_eq!(PLAN[30].constants[6], 1);
        assert_eq!(PLAN[31].constants, [0; 64]);
    }
    #[test]
    fn all_variable_basis_and_random_scalar_roundtrip() {
        let base = dense(0);
        for line in 0..32 {
            for byte in 0..64 {
                if PLAN[line].variable_mask & (1 << byte) != 0 {
                    for bit in 0..8 {
                        let mut x = base;
                        x[line][byte] ^= 1 << bit;
                        let got = encode(&x, false, false);
                        for l in 0..32 {
                            assert_eq!(got.decode_line(0, l).unwrap(), x[l]);
                        }
                    }
                }
            }
        }
        for seed in 1..33 {
            let x = dense(seed);
            let got = encode(&x, false, false);
            assert_eq!(got.physical_bytes(), 1408);
            let mut out = vec![0; 2048];
            got.copy_dense_into(&mut out).unwrap();
            assert_eq!(out, x.concat());
            assert_eq!(got.view().record(0).unwrap()[1358..], [0; 50]);
            let fallback = got.into_dense();
            assert_eq!(
                fallback
                    .lines()
                    .iter()
                    .flat_map(|l| l.0)
                    .collect::<Vec<_>>(),
                x.concat()
            );
        }
    }
    #[test]
    fn malformed_input_order_and_allocation_are_rejected() {
        assert!(matches!(Builder::new(0), Err(Error::Shape)));
        assert!(matches!(
            Builder::from_allocation(vec![CacheLine([0; 64]); 23], 1),
            Err(Error::Shape)
        ));
        let mut b = Builder::new(1).unwrap();
        {
            let mut w = b.block(0).unwrap();
            let x = dense(1);
            assert_eq!(w.record_line(3, &x[3]), Err(Error::Order));
            let mut bad = x[2];
            let i = PLAN[2].variable_mask.trailing_ones() as usize;
            // Pick a truly constant byte explicitly.
            let i = (0..64)
                .find(|i| PLAN[2].variable_mask & (1 << i) == 0)
                .unwrap_or(i);
            bad[i] ^= 1;
            assert_eq!(w.record_line(2, &bad), Err(Error::ConstantMismatch));
            w.record_line(2, &x[2]).unwrap();
            assert_eq!(w.record_line(2, &x[2]), Err(Error::Order));
            assert_eq!(w.finish(), Err(Error::Incomplete));
        }
        assert!(matches!(b.finish(), Err(Error::Incomplete)));
    }
    #[test]
    fn constant_fill_and_disjoint_parallel_chunks() {
        let mut template = [0xa5; LOGICAL_BYTES];
        fill_dense_constants(&mut template);
        for (line, p) in PLAN.iter().enumerate() {
            for byte in 0..64 {
                assert_eq!(
                    template[line * 64 + byte],
                    if p.variable_mask & (1u64 << byte) == 0 {
                        p.constants[byte]
                    } else {
                        0xa5
                    }
                );
            }
        }
        for native in [false, true] {
            #[cfg(target_arch = "x86_64")]
            if native
                && (!std::is_x86_feature_detected!("avx512f")
                    || !std::is_x86_feature_detected!("avx512bw")
                    || !std::is_x86_feature_detected!("avx512vbmi2"))
            {
                continue;
            }
            #[cfg(not(target_arch = "x86_64"))]
            if native {
                continue;
            }
            let mut builder = Builder::new(19).unwrap();
            std::thread::scope(|scope| {
                for (chunk_index, mut chunk) in builder.chunks_mut(8).enumerate() {
                    scope.spawn(move || {
                        assert_eq!(chunk.blocks(), if chunk_index == 2 { 3 } else { 8 });
                        // Exercise nonmonotonic block scheduling independently of
                        // the strictly ordered line epochs inside each block.
                        for block in (0..chunk.blocks()).rev() {
                            let input = dense((chunk_index * 8 + block + 1) as u64).concat();
                            let input: &[u8; LOGICAL_BYTES] = input.as_slice().try_into().unwrap();
                            #[cfg(target_arch = "x86_64")]
                            if native {
                                unsafe {
                                    chunk.encode_dense_block_native(block, input, true).unwrap()
                                };
                                continue;
                            }
                            chunk.encode_dense_block(block, input).unwrap();
                        }
                    });
                }
            });
            assert!(matches!(builder.block(0), Err(Error::AlreadyComplete)));
            let owner = builder.finish().unwrap();
            assert_eq!(owner.physical_bytes(), 19 * PHYSICAL_BYTES);
            assert_eq!(owner.view().num_blocks(), 19);
            let full = owner.view().to_dense_bytes();
            for block in 0..19 {
                assert_eq!(
                    full[block * LOGICAL_BYTES..(block + 1) * LOGICAL_BYTES],
                    dense((block + 1) as u64).concat()
                );
                for row in [0, 64, 128, 192] {
                    let mut out = std::array::from_fn(|_| CacheLine([0; 64]));
                    owner
                        .view()
                        .expand64_rows(block * 256 + row, &mut out)
                        .unwrap();
                    assert_eq!(
                        out.iter().flat_map(|line| line.0).collect::<Vec<_>>(),
                        full[block * 2048 + row * 8..block * 2048 + (row + 64) * 8]
                    );
                    let ptr = owner.view().prefetch_ptr(block * 256 + row).unwrap() as usize;
                    let base = owner.lines.as_ptr() as usize;
                    assert!((base + block * 1408..base + (block + 1) * 1408).contains(&ptr));
                }
            }
            assert!(owner.view().prefetch_ptr(19 * 256).is_none());
            assert!(owner.view().prefetch_ptr(1).is_none());
        }
    }
    #[cfg(target_arch = "x86_64")]
    #[test]
    fn native_compress_expand_nt_and_recycled_allocation() {
        if !std::is_x86_feature_detected!("avx512vbmi2")
            || !std::is_x86_feature_detected!("avx512bw")
        {
            return;
        }
        for nt in [false, true] {
            for seed in 1..65 {
                let x = dense(seed);
                let got = encode(&x, true, nt);
                for l in 0..32 {
                    assert_eq!(unsafe { got.decode_line_native(0, l).unwrap() }, x[l]);
                }
                let allocation = got.into_allocation();
                let mut builder = Builder::from_allocation(allocation, 1).unwrap();
                let y = dense(seed + 77);
                {
                    let mut w = builder.block(0).unwrap();
                    for l in 2..30 {
                        unsafe { w.record_line_native(l, &y[l], nt).unwrap() };
                    }
                    w.finish().unwrap();
                }
                let restored = builder.finish().unwrap();
                for l in 0..32 {
                    assert_eq!(restored.decode_line(0, l).unwrap(), y[l]);
                }
            }
        }
        let input = dense(0x1234);
        let mut builder = Builder::new(2).unwrap();
        {
            let mut partial = builder.block(0).unwrap();
            for line in 2..18 {
                unsafe {
                    partial
                        .record_line_native(line, &input[line], true)
                        .unwrap()
                };
            }
            // Dropping a partially NT-published block must drain stores before
            // its allocation or byte positions can be reused.
        }
        for block in [1, 0] {
            let mut writer = builder.block(block).unwrap();
            for line in 2..30 {
                unsafe { writer.record_line_native(line, &input[line], true).unwrap() };
            }
            writer.finish().unwrap();
        }
        let owner = builder.finish().unwrap();
        assert_eq!(owner.view().to_dense_bytes(), input.concat().repeat(2));
    }
    #[cfg(target_arch = "x86_64")]
    #[test]
    fn all_variable_basis_native() {
        if !std::is_x86_feature_detected!("avx512vbmi2")
            || !std::is_x86_feature_detected!("avx512bw")
        {
            return;
        }
        let base = dense(0);
        for l in 0..32 {
            for j in 0..64 {
                if PLAN[l].variable_mask & (1 << j) != 0 {
                    for bit in 0..8 {
                        let mut x = base;
                        x[l][j] ^= 1 << bit;
                        let got = encode(&x, true, false);
                        for row in 0..32 {
                            assert_eq!(unsafe { got.decode_line_native(0, row).unwrap() }, x[row]);
                        }
                    }
                }
            }
        }
    }
    #[cfg(target_arch = "x86_64")]
    #[test]
    fn every_constant_byte_is_checked_before_owner_publication() {
        if !std::is_x86_feature_detected!("avx512f")
            || !std::is_x86_feature_detected!("avx512bw")
            || !std::is_x86_feature_detected!("avx512vbmi2")
        {
            return;
        }
        let input = dense(0x12345678).concat();
        for (line, p) in PLAN.iter().enumerate() {
            for byte in 0..64 {
                if p.variable_mask & (1u64 << byte) == 0 {
                    let mut corrupt = input.clone();
                    corrupt[line * 64 + byte] ^= 1;
                    let corrupt: &[u8; LOGICAL_BYTES] = corrupt.as_slice().try_into().unwrap();
                    let mut builder = Builder::new(1).unwrap();
                    {
                        let mut chunks = builder.chunks_mut(1);
                        let mut chunk = chunks.next().unwrap();
                        assert_eq!(
                            unsafe { chunk.encode_dense_block_native(0, corrupt, true) },
                            Err(Error::ConstantMismatch)
                        );
                    }
                    assert!(matches!(builder.finish(), Err(Error::Incomplete)));
                }
            }
        }
    }
    #[cfg(target_arch = "x86_64")]
    #[test]
    fn octa_batch_fences_success_error_and_unwind_before_publication() {
        if !std::is_x86_feature_detected!("avx512f")
            || !std::is_x86_feature_detected!("avx512bw")
            || !std::is_x86_feature_detected!("avx512vbmi2")
        {
            return;
        }
        let octa = (0..8)
            .flat_map(|i| dense(i + 100).concat())
            .collect::<Vec<_>>();
        let octa: &[u8; 8 * LOGICAL_BYTES] = octa.as_slice().try_into().unwrap();
        for nt in [false, true] {
            let mut builder = Builder::new(16).unwrap();
            {
                let mut chunk = builder.chunks_mut(16).next().unwrap();
                assert_eq!(
                    unsafe { chunk.encode_dense_octa_native(9, octa, nt) },
                    Err(Error::Bounds)
                );
                unsafe {
                    chunk.encode_dense_octa_native(8, octa, nt).unwrap();
                    chunk.encode_dense_octa_native(0, octa, nt).unwrap();
                }
                assert_eq!(
                    unsafe { chunk.encode_dense_octa_native(0, octa, nt) },
                    Err(Error::AlreadyComplete)
                );
            }
            let owner = builder.finish().unwrap();
            let output = std::thread::spawn(move || owner.view().to_dense_bytes())
                .join()
                .unwrap();
            assert_eq!(output, octa.repeat(2));
        }
        let mut bad = *octa;
        bad[4 * LOGICAL_BYTES] ^= 1;
        let mut builder = Builder::new(8).unwrap();
        {
            let mut chunk = builder.chunks_mut(8).next().unwrap();
            assert_eq!(
                unsafe { chunk.encode_dense_octa_native(0, &bad, true) },
                Err(Error::ConstantMismatch)
            );
        }
        // Four completed blocks preceded the corrupt fifth block. Only after
        // the batch has returned (and its RAII guard fenced) can they be seen.
        assert_eq!(
            &builder.complete[..],
            [true, true, true, true, false, false, false, false]
        );
        for block in 4..8 {
            let mut chunk = builder.chunks_mut(8).next().unwrap();
            unsafe {
                chunk
                    .encode_dense_block_native(
                        block,
                        octa[block * 2048..(block + 1) * 2048].try_into().unwrap(),
                        true,
                    )
                    .unwrap();
            }
        }
        assert_eq!(
            builder.finish().unwrap().view().to_dense_bytes(),
            octa.as_slice()
        );
        let mut builder = Builder::new(1).unwrap();
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let mut fence = NtBatchFence::new();
            let mut writer = builder.block(0).unwrap();
            for line in 2..30 {
                unsafe {
                    writer
                        .record_line_native(
                            line,
                            octa[line * 64..(line + 1) * 64].try_into().unwrap(),
                            true,
                        )
                        .unwrap()
                };
            }
            writer.finish_deferred(&mut fence).unwrap();
            panic!("injected unwind after deferred block completion");
        }));
        assert!(result.is_err());
        assert_eq!(
            builder.finish().unwrap().view().to_dense_bytes(),
            octa[..2048]
        );
    }
    #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
    #[test]
    fn guarded_physical_record_and_chunk_bounds() {
        use core::ffi::c_void;
        unsafe extern "C" {
            fn mmap(a: *mut c_void, n: usize, p: i32, f: i32, fd: i32, off: isize) -> *mut c_void;
            fn mprotect(a: *mut c_void, n: usize, p: i32) -> i32;
            fn munmap(a: *mut c_void, n: usize) -> i32;
        }
        struct Guard(*mut c_void);
        impl Drop for Guard {
            fn drop(&mut self) {
                unsafe { assert_eq!(munmap(self.0, 3 * 4096), 0) }
            }
        }
        if !std::is_x86_feature_detected!("avx512vbmi2")
            || !std::is_x86_feature_detected!("avx512bw")
        {
            return;
        }
        unsafe {
            let g = Guard(mmap(core::ptr::null_mut(), 3 * 4096, 0, 2 | 32, -1, 0));
            assert_ne!(g.0 as isize, -1);
            let middle = g.0.cast::<u8>().add(4096);
            assert_eq!(mprotect(middle.cast(), 4096, 3), 0);
            core::ptr::write_bytes(middle, 0xa5, 4096);
            let start = middle.add(4096 - PHYSICAL_BYTES);
            let mut complete = false;
            let x = dense(99);
            let dst = core::slice::from_raw_parts_mut(start.cast::<MaybeUninit<CacheLine>>(), 22);
            let mut w = BlockWriter {
                destination: dst,
                complete: &mut complete,
                pending: Pending([MaybeUninit::uninit(); PHYSICAL_BYTES]),
                next: 2,
                nt_pending: false,
            };
            for l in 2..30 {
                w.record_line_native(l, &x[l], true).unwrap();
            }
            w.finish().unwrap();
            assert!(complete);
            let view = ResidualView {
                lines: core::slice::from_raw_parts(start.cast(), 22),
                blocks: 1,
            };
            for l in 0..32 {
                assert_eq!(view.decode_line_native(0, l).unwrap(), x[l]);
            }
            for row in [0, 64, 128, 192] {
                let mut out = std::array::from_fn(|_| CacheLine([0; 64]));
                view.expand64_rows_native(row, &mut out).unwrap();
                assert_eq!(
                    out.iter().flat_map(|l| l.0).collect::<Vec<_>>(),
                    x[row / 8..row / 8 + 8].concat()
                );
            }
            let mut out = std::array::from_fn(|_| CacheLine([0; 64]));
            assert_eq!(view.expand64_rows(256, &mut out), Err(Error::Bounds));
            assert_eq!(view.expand64_rows(1, &mut out), Err(Error::Bounds));
            assert!(
                core::slice::from_raw_parts(middle, 4096 - PHYSICAL_BYTES)
                    .iter()
                    .all(|v| *v == 0xa5)
            );
            assert_eq!(
                core::slice::from_raw_parts(start.add(PAYLOAD_BYTES), 50),
                [0; 50]
            );
        }
    }
}
