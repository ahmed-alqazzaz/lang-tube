import 'dart:ffi';

import 'package:subtitles_parser/rust_bridge/bridge.dart';

const _testPath = '..\\rust\\target\\release\\deps\\subtitles_parser.dll';

final dylib = DynamicLibrary.open(_testPath);

final rustApi = SubtitlesParserImpl(dylib);
