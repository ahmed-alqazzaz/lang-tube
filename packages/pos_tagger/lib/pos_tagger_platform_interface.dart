import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pos_tagger_method_channel.dart';

abstract class PosTaggerPlatform extends PlatformInterface {
  /// Constructs a PosTaggerPlatform.
  PosTaggerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PosTaggerPlatform _instance = MethodChannelPosTagger();

  /// The default instance of [PosTaggerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPosTagger].
  static PosTaggerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PosTaggerPlatform] when
  /// they register themselves.
  static set instance(PosTaggerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
