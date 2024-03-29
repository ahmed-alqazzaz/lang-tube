// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.6.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;
import 'parsed_subtitle.dart';

abstract class SubtitlesParser {
  Future<List<ParsedSubtitle>> parseSrv1StaticMethodSubtitlesParser(
      {required String rawSubtitles, dynamic hint});

  FlutterRustBridgeTaskConstMeta
      get kParseSrv1StaticMethodSubtitlesParserConstMeta;

  Future<List<ParsedSubtitle>> parseYoutubeTimedTextStaticMethodSubtitlesParser(
      {required String rawSubtitles, dynamic hint});

  FlutterRustBridgeTaskConstMeta
      get kParseYoutubeTimedTextStaticMethodSubtitlesParserConstMeta;
}

class RustDuration {
  final int secs;
  final int millis;

  const RustDuration({
    required this.secs,
    required this.millis,
  });
}

class SubtitlesParserImpl implements SubtitlesParser {
  final SubtitlesParserPlatform _platform;
  factory SubtitlesParserImpl(ExternalLibrary dylib) =>
      SubtitlesParserImpl.raw(SubtitlesParserPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory SubtitlesParserImpl.wasm(FutureOr<WasmModule> module) =>
      SubtitlesParserImpl(module as ExternalLibrary);
  SubtitlesParserImpl.raw(this._platform);
  Future<List<ParsedSubtitle>> parseSrv1StaticMethodSubtitlesParser(
      {required String rawSubtitles, dynamic hint}) {
    var arg0 = _platform.api2wire_String(rawSubtitles);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_parse_srv1__static_method__SubtitlesParser(port_, arg0),
      parseSuccessData: _wire2api_list_parsed_subtitle,
      parseErrorData: null,
      constMeta: kParseSrv1StaticMethodSubtitlesParserConstMeta,
      argValues: [rawSubtitles],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta
      get kParseSrv1StaticMethodSubtitlesParserConstMeta =>
          const FlutterRustBridgeTaskConstMeta(
            debugName: "parse_srv1__static_method__SubtitlesParser",
            argNames: ["rawSubtitles"],
          );

  Future<List<ParsedSubtitle>> parseYoutubeTimedTextStaticMethodSubtitlesParser(
      {required String rawSubtitles, dynamic hint}) {
    var arg0 = _platform.api2wire_String(rawSubtitles);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_parse_youtube_timed_text__static_method__SubtitlesParser(
              port_, arg0),
      parseSuccessData: _wire2api_list_parsed_subtitle,
      parseErrorData: null,
      constMeta: kParseYoutubeTimedTextStaticMethodSubtitlesParserConstMeta,
      argValues: [rawSubtitles],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta
      get kParseYoutubeTimedTextStaticMethodSubtitlesParserConstMeta =>
          const FlutterRustBridgeTaskConstMeta(
            debugName:
                "parse_youtube_timed_text__static_method__SubtitlesParser",
            argNames: ["rawSubtitles"],
          );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  List<ParsedSubtitle> _wire2api_list_parsed_subtitle(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api_parsed_subtitle).toList();
  }

  ParsedSubtitle _wire2api_parsed_subtitle(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return ParsedSubtitle(
      start: _wire2api_rust_duration(arr[0]),
      end: _wire2api_rust_duration(arr[1]),
      text: _wire2api_String(arr[2]),
    );
  }

  RustDuration _wire2api_rust_duration(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return RustDuration(
      secs: _wire2api_u64(arr[0]),
      millis: _wire2api_u64(arr[1]),
    );
  }

  int _wire2api_u64(dynamic raw) {
    return castInt(raw);
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }
}

// Section: api2wire

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class SubtitlesParserPlatform
    extends FlutterRustBridgeBase<SubtitlesParserWire> {
  SubtitlesParserPlatform(ffi.DynamicLibrary dylib)
      : super(SubtitlesParserWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class SubtitlesParserWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  SubtitlesParserWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  SubtitlesParserWire.fromLookup(
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

  void wire_parse_srv1__static_method__SubtitlesParser(
    int port_,
    ffi.Pointer<wire_uint_8_list> raw_subtitles,
  ) {
    return _wire_parse_srv1__static_method__SubtitlesParser(
      port_,
      raw_subtitles,
    );
  }

  late final _wire_parse_srv1__static_method__SubtitlesParserPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_parse_srv1__static_method__SubtitlesParser');
  late final _wire_parse_srv1__static_method__SubtitlesParser =
      _wire_parse_srv1__static_method__SubtitlesParserPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_parse_youtube_timed_text__static_method__SubtitlesParser(
    int port_,
    ffi.Pointer<wire_uint_8_list> raw_subtitles,
  ) {
    return _wire_parse_youtube_timed_text__static_method__SubtitlesParser(
      port_,
      raw_subtitles,
    );
  }

  late final _wire_parse_youtube_timed_text__static_method__SubtitlesParserPtr =
      _lookup<
              ffi.NativeFunction<
                  ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
          'wire_parse_youtube_timed_text__static_method__SubtitlesParser');
  late final _wire_parse_youtube_timed_text__static_method__SubtitlesParser =
      _wire_parse_youtube_timed_text__static_method__SubtitlesParserPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
          ffi
          .NativeFunction<ffi.Pointer<wire_uint_8_list> Function(ffi.Int32)>>(
      'new_uint_8_list_0');
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

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;

const int MILLIS_PER_SEC = 1000;
