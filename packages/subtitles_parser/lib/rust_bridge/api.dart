import 'dart:ffi';
import 'dart:io';

import 'bridge.dart';

// Re-export the bridge so it is only necessary to import this file.
export 'bridge.dart';
export 'parsed_subtitle.dart';
import 'dart:io' as io;

const _base = 'subtitles_parser';

// On MacOS, the dynamic library is not bundled with the binary,
// but rather directly **linked** against the binary.
//final _dylibPath = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';
const _testPath =
    'C:\\Users\\acer\\workspace1\\langtube\\packages\\subtitles_parserr\\rust\\target\\release\\deps\\subtitles_parser.dll';

final _dylibPath = io.Platform.isWindows ? '$_base.dll' : 'lib$_base.so';

final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(_dylibPath);

final rustApi = SubtitlesParserImpl(dylib);
