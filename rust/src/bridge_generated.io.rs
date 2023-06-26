use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_calculate_subtitle_complexity(port_: i64, text: *mut wire_uint_8_list) {
    wire_calculate_subtitle_complexity_impl(port_, text)
}

#[no_mangle]
pub extern "C" fn wire_count_syllables(port_: i64, text: *mut wire_uint_8_list) {
    wire_count_syllables_impl(port_, text)
}

#[no_mangle]
pub extern "C" fn wire_indices_list__method__SubtitleComplexity(
    port_: i64,
    that: *mut wire_SubtitleComplexity,
) {
    wire_indices_list__method__SubtitleComplexity_impl(port_, that)
}

#[no_mangle]
pub extern "C" fn wire_compare_to__method__SubtitleComplexity(
    port_: i64,
    that: *mut wire_SubtitleComplexity,
    other: *mut wire_SubtitleComplexity,
) {
    wire_compare_to__method__SubtitleComplexity_impl(port_, that, other)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_subtitle_complexity_0() -> *mut wire_SubtitleComplexity {
    support::new_leak_box_ptr(wire_SubtitleComplexity::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<SubtitleComplexity> for *mut wire_SubtitleComplexity {
    fn wire2api(self) -> SubtitleComplexity {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SubtitleComplexity>::wire2api(*wrap).into()
    }
}

impl Wire2Api<SubtitleComplexity> for wire_SubtitleComplexity {
    fn wire2api(self) -> SubtitleComplexity {
        SubtitleComplexity {
            lix_index: self.lix_index.wire2api(),
            rix_index: self.rix_index.wire2api(),
            flesch_reading_ease: self.flesch_reading_ease.wire2api(),
            automated_readability_index: self.automated_readability_index.wire2api(),
            coleman_liau_index: self.coleman_liau_index.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_SubtitleComplexity {
    lix_index: f64,
    rix_index: f64,
    flesch_reading_ease: f64,
    automated_readability_index: f64,
    coleman_liau_index: f64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_SubtitleComplexity {
    fn new_with_null_ptr() -> Self {
        Self {
            lix_index: Default::default(),
            rix_index: Default::default(),
            flesch_reading_ease: Default::default(),
            automated_readability_index: Default::default(),
            coleman_liau_index: Default::default(),
        }
    }
}

impl Default for wire_SubtitleComplexity {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
