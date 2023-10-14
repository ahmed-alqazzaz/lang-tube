// if you forget where the dynamic library is located in the apk,
// look at the build warnings

import 'dart:ffi';
import 'dart:io';

import 'bridge.dart';

const _dylibPath =
    'C:\\Users\\acer\\workspace1\\langtube\\packages\\readability\\rust\\target\\release\\deps\\readability.dll';
final _dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(_dylibPath);

final rustTestApi = ReadabilityImpl(_dylib);
