import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pos_tagger_platform_interface.dart';

/// An implementation of [PosTaggerPlatform] that uses method channels.
class MethodChannelPosTagger extends PosTaggerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pos_tagger');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
