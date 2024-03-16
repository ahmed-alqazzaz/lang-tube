import 'dart:ffi';
import 'dart:io';

import 'bridge.g.dart';

// Re-export the bridge so it is only necessary to import this file.
export 'bridge.g.dart';
import 'dart:io' as io;

const _base = 'subtitles_parser';

final _dylibPath = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';

final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(_dylibPath);

final rustApi = SubtitlesParserImpl(dylib);
