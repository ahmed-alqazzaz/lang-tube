import 'dart:ffi';
import 'dart:io';

// Re-export the bridge so it is only necessary to import this file.

import 'dart:io' as io;

import 'package:subtitles_parser/src/rust_bridge/bridge.g.dart';

const _base = 'subtitles_parser';

final _dylibPath = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';

final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(_dylibPath);

final rustApi = SubtitlesParserImpl(dylib);
