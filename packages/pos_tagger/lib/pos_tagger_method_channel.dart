import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'pos_tagger_platform_interface.dart';
import 'package:http/http.dart' as http;

/// An implementation of [PosTaggerPlatform] that uses method channels.
class MethodChannelPosTagger extends PosTaggerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pos_tagger');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> posTag(String input) async {
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/en.bin';
    final modelUrl = Uri.parse(
        "https://opennlp.sourceforge.net/models-1.5/en-pos-maxent.bin");

    var response = await http.get(modelUrl);
    var file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    print("file: ${file.path}");
    await methodChannel.invokeMethod('posTag', {
      'text': "hello world",
      'modelPath': file.path,
    }).then((value) => log(value.toString()));
  }
}
