import 'dart:ffi';

import 'package:subtitles_parser/src/rust_bridge/bridge_generated.dart';

const _testPath =
    'C:\\Users\\acer\\workspace1\\langtube\\packages\\subtitles_parser\\rust\\target\\release\\deps\\subtitles_parser.dll';

final dylib = DynamicLibrary.open(_testPath);

final rustApi = SubtitlesParserImpl(dylib);
