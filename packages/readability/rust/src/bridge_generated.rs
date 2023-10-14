#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.3.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::rust2dart::IntoIntoDart;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

// Section: wire functions

fn wire_calculate_subtitle_complexity_impl(
    port_: MessagePort,
    text: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, ReadabilityScore, _>(
        WrapInfo {
            debug_name: "calculate_subtitle_complexity",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_text = text.wire2api();
            move |task_callback| Result::<_, ()>::Ok(calculate_subtitle_complexity(api_text))
        },
    )
}
fn wire_count_syllables_impl(port_: MessagePort, text: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, i64, _>(
        WrapInfo {
            debug_name: "count_syllables",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_text = text.wire2api();
            move |task_callback| Result::<_, ()>::Ok(count_syllables(api_text))
        },
    )
}
fn wire_indices_list__method__ReadabilityScore_impl(
    port_: MessagePort,
    that: impl Wire2Api<ReadabilityScore> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Vec<f64>, _>(
        WrapInfo {
            debug_name: "indices_list__method__ReadabilityScore",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_that = that.wire2api();
            move |task_callback| Result::<_, ()>::Ok(ReadabilityScore::indices_list(&api_that))
        },
    )
}
fn wire_compare_to__method__ReadabilityScore_impl(
    port_: MessagePort,
    that: impl Wire2Api<ReadabilityScore> + UnwindSafe,
    other: impl Wire2Api<ReadabilityScore> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, bool, _>(
        WrapInfo {
            debug_name: "compare_to__method__ReadabilityScore",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_that = that.wire2api();
            let api_other = other.wire2api();
            move |task_callback| {
                Result::<_, ()>::Ok(ReadabilityScore::compare_to(&api_that, api_other))
            }
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<f64> for f64 {
    fn wire2api(self) -> f64 {
        self
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for ReadabilityScore {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.lix_index.into_into_dart().into_dart(),
            self.rix_index.into_into_dart().into_dart(),
            self.flesch_reading_ease.into_into_dart().into_dart(),
            self.automated_readability_index
                .into_into_dart()
                .into_dart(),
            self.coleman_liau_index.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for ReadabilityScore {}
impl rust2dart::IntoIntoDart<ReadabilityScore> for ReadabilityScore {
    fn into_into_dart(self) -> Self {
        self
    }
}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
