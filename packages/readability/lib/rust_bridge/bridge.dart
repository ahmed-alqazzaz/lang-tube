// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.78.0.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:readability/rust_bridge/readability_score.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;

abstract class Readability {
  Future<ReadbilityScore> calculateSubtitleComplexity(
      {required String text, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCalculateSubtitleComplexityConstMeta;

  Future<int> countSyllables({required String text, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCountSyllablesConstMeta;

  Future<Float64List> indicesListMethodReadbilityScore(
      {required ReadbilityScore that, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIndicesListMethodReadbilityScoreConstMeta;

  Future<bool> compareToMethodReadbilityScore({
    required ReadbilityScore that,
    required ReadbilityScore other,
    dynamic hint,
  });

  FlutterRustBridgeTaskConstMeta get kCompareToMethodReadbilityScoreConstMeta;
}

class ReadabilityImpl implements Readability {
  final ReadabilityPlatform _platform;
  factory ReadabilityImpl(ExternalLibrary dylib) =>
      ReadabilityImpl.raw(ReadabilityPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory ReadabilityImpl.wasm(FutureOr<WasmModule> module) =>
      ReadabilityImpl(module as ExternalLibrary);
  ReadabilityImpl.raw(this._platform);
  Future<ReadbilityScore> calculateSubtitleComplexity(
      {required String text, dynamic hint}) {
    var arg0 = _platform.api2wire_String(text);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_calculate_subtitle_complexity(port_, arg0),
      parseSuccessData: (d) => _wire2api_readbility_score(d),
      constMeta: kCalculateSubtitleComplexityConstMeta,
      argValues: [text],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCalculateSubtitleComplexityConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "calculate_subtitle_complexity",
        argNames: ["text"],
      );

  Future<int> countSyllables({required String text, dynamic hint}) {
    var arg0 = _platform.api2wire_String(text);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_count_syllables(port_, arg0),
      parseSuccessData: _wire2api_i64,
      constMeta: kCountSyllablesConstMeta,
      argValues: [text],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCountSyllablesConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "count_syllables",
        argNames: ["text"],
      );

  Future<Float64List> indicesListMethodReadbilityScore(
      {required ReadbilityScore that, dynamic hint}) {
    var arg0 = _platform.api2wire_box_autoadd_readbility_score(that);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_indices_list__method__ReadbilityScore(port_, arg0),
      parseSuccessData: _wire2api_float_64_list,
      constMeta: kIndicesListMethodReadbilityScoreConstMeta,
      argValues: [that],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta
      get kIndicesListMethodReadbilityScoreConstMeta =>
          const FlutterRustBridgeTaskConstMeta(
            debugName: "indices_list__method__ReadbilityScore",
            argNames: ["that"],
          );

  Future<bool> compareToMethodReadbilityScore(
      {required ReadbilityScore that,
      required ReadbilityScore other,
      dynamic hint}) {
    var arg0 = _platform.api2wire_box_autoadd_readbility_score(that);
    var arg1 = _platform.api2wire_box_autoadd_readbility_score(other);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_compare_to__method__ReadbilityScore(port_, arg0, arg1),
      parseSuccessData: _wire2api_bool,
      constMeta: kCompareToMethodReadbilityScoreConstMeta,
      argValues: [that, other],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCompareToMethodReadbilityScoreConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "compare_to__method__ReadbilityScore",
        argNames: ["that", "other"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  double _wire2api_f64(dynamic raw) {
    return raw as double;
  }

  Float64List _wire2api_float_64_list(dynamic raw) {
    return raw as Float64List;
  }

  int _wire2api_i64(dynamic raw) {
    return castInt(raw);
  }

  ReadbilityScore _wire2api_readbility_score(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return ReadbilityScore(
      lixIndex: _wire2api_f64(arr[0]),
      rixIndex: _wire2api_f64(arr[1]),
      fleschReadingEase: _wire2api_f64(arr[2]),
      automatedReadabilityIndex: _wire2api_f64(arr[3]),
      colemanLiauIndex: _wire2api_f64(arr[4]),
    );
  }
}

// Section: api2wire

@protected
double api2wire_f64(double raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class ReadabilityPlatform extends FlutterRustBridgeBase<ReadabilityWire> {
  ReadabilityPlatform(ffi.DynamicLibrary dylib) : super(ReadabilityWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_ReadbilityScore> api2wire_box_autoadd_readbility_score(
      ReadbilityScore raw) {
    final ptr = inner.new_box_autoadd_readbility_score_0();
    _api_fill_to_wire_readbility_score(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_readbility_score(
      ReadbilityScore apiObj, ffi.Pointer<wire_ReadbilityScore> wireObj) {
    _api_fill_to_wire_readbility_score(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_readbility_score(
      ReadbilityScore apiObj, wire_ReadbilityScore wireObj) {
    wireObj.lix_index = api2wire_f64(apiObj.lixIndex);
    wireObj.rix_index = api2wire_f64(apiObj.rixIndex);
    wireObj.flesch_reading_ease = api2wire_f64(apiObj.fleschReadingEase);
    wireObj.automated_readability_index =
        api2wire_f64(apiObj.automatedReadabilityIndex);
    wireObj.coleman_liau_index = api2wire_f64(apiObj.colemanLiauIndex);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class ReadabilityWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  ReadabilityWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  ReadabilityWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_calculate_subtitle_complexity(
    int port_,
    ffi.Pointer<wire_uint_8_list> text,
  ) {
    return _wire_calculate_subtitle_complexity(
      port_,
      text,
    );
  }

  late final _wire_calculate_subtitle_complexityPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_calculate_subtitle_complexity');
  late final _wire_calculate_subtitle_complexity =
      _wire_calculate_subtitle_complexityPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_count_syllables(
    int port_,
    ffi.Pointer<wire_uint_8_list> text,
  ) {
    return _wire_count_syllables(
      port_,
      text,
    );
  }

  late final _wire_count_syllablesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_count_syllables');
  late final _wire_count_syllables = _wire_count_syllablesPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_indices_list__method__ReadbilityScore(
    int port_,
    ffi.Pointer<wire_ReadbilityScore> that,
  ) {
    return _wire_indices_list__method__ReadbilityScore(
      port_,
      that,
    );
  }

  late final _wire_indices_list__method__ReadbilityScorePtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_ReadbilityScore>)>>(
      'wire_indices_list__method__ReadbilityScore');
  late final _wire_indices_list__method__ReadbilityScore =
      _wire_indices_list__method__ReadbilityScorePtr
          .asFunction<void Function(int, ffi.Pointer<wire_ReadbilityScore>)>();

  void wire_compare_to__method__ReadbilityScore(
    int port_,
    ffi.Pointer<wire_ReadbilityScore> that,
    ffi.Pointer<wire_ReadbilityScore> other,
  ) {
    return _wire_compare_to__method__ReadbilityScore(
      port_,
      that,
      other,
    );
  }

  late final _wire_compare_to__method__ReadbilityScorePtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_ReadbilityScore>,
                  ffi.Pointer<wire_ReadbilityScore>)>>(
      'wire_compare_to__method__ReadbilityScore');
  late final _wire_compare_to__method__ReadbilityScore =
      _wire_compare_to__method__ReadbilityScorePtr.asFunction<
          void Function(int, ffi.Pointer<wire_ReadbilityScore>,
              ffi.Pointer<wire_ReadbilityScore>)>();

  ffi.Pointer<wire_ReadbilityScore> new_box_autoadd_readbility_score_0() {
    return _new_box_autoadd_readbility_score_0();
  }

  late final _new_box_autoadd_readbility_score_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_ReadbilityScore> Function()>>(
          'new_box_autoadd_readbility_score_0');
  late final _new_box_autoadd_readbility_score_0 =
      _new_box_autoadd_readbility_score_0Ptr
          .asFunction<ffi.Pointer<wire_ReadbilityScore> Function()>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_ReadbilityScore extends ffi.Struct {
  @ffi.Double()
  external double lix_index;

  @ffi.Double()
  external double rix_index;

  @ffi.Double()
  external double flesch_reading_ease;

  @ffi.Double()
  external double automated_readability_index;

  @ffi.Double()
  external double coleman_liau_index;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
