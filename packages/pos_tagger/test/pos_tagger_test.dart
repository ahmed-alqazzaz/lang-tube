import 'package:flutter_test/flutter_test.dart';
import 'package:pos_tagger/pos_tagger.dart';
import 'package:pos_tagger/src/method_channel/pos_tagger_platform_interface.dart';
import 'package:pos_tagger/pos_tagger_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPosTaggerPlatform
    with MockPlatformInterfaceMixin
    implements PosTaggerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PosTaggerPlatform initialPlatform = PosTaggerPlatform.instance;

  test('$MethodChannelPosTagger is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPosTagger>());
  });

  test('getPlatformVersion', () async {
    PosTagger posTaggerPlugin = PosTagger();
    MockPosTaggerPlatform fakePlatform = MockPosTaggerPlatform();
    PosTaggerPlatform.instance = fakePlatform;

    expect(await posTaggerPlugin.getPlatformVersion(), '42');
  });
}
