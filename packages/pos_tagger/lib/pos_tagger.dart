import 'pos_tagger_platform_interface.dart';

class PosTagger {
  Future<String?> getPlatformVersion() {
    return PosTaggerPlatform.instance.getPlatformVersion();
  }

  Future<void> evaluate(String text) async {
    return await PosTaggerPlatform.instance.posTag(text);
  }
}
