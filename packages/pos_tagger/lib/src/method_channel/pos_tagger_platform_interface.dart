import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

part 'pos_tagger_method_channel.dart';

abstract class PosTaggerPlatform extends PlatformInterface {
  PosTaggerPlatform._() : super(token: _token);

  static final Object _token = Object();

  static final Map<String, PosTaggerPlatform> _instances = HashMap();

  static PosTaggerPlatform getInstance(String modelPath) {
    if (!_instances.containsKey(modelPath)) {
      _instances[modelPath] = MethodChannelPosTagger(modelPath: modelPath);
    }
    return _instances[modelPath]!;
  }

  Future<String?> posTag(String text);
}
