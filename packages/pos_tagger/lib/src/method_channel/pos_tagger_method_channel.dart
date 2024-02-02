part of 'pos_tagger_platform_interface.dart';

/// An implementation of [PosTaggerPlatform] that uses method channels.
class MethodChannelPosTagger extends PosTaggerPlatform {
  MethodChannelPosTagger({required this.modelPath}) : super._();
  final String modelPath;

  @visibleForTesting
  final methodChannel = const MethodChannel('pos_tagger');

  @override
  Future<String?> posTag(String text) async {
    return await methodChannel.invokeMethod<String>(
      'posTag',
      {
        'text': text,
        'modelPath': modelPath,
      },
    );
  }
}
