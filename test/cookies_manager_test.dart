import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ffi';

void main() {
  group('Youtube Cookies Manager test', () {
    setUp(() async {
      return WidgetsFlutterBinding.ensureInitialized();
    });
    test('x', () async {
      DynamicLibrary.open(
          'C:\\Users\\acer\\workspace1\\langtube\\rust\\target\\debug\\deps\\readability.dll');
      expect("", "");
    });
  });
}
