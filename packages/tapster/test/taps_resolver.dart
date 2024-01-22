import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapster/src/tap_priority.dart';
import 'package:tapster/src/tapster.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  test('Taps Resolver favours inside taps', () async {
    final resolver = TestTapsResolver(tapPriority: TapPriority.insideEvents);
    resolver.resolveOutsideTap();
    resolver.resolveInsideTap();
    resolver.resolveInsideTap();
    resolver.resolveInsideTap();
    resolver.resolveOutsideTap();
    resolver.resolveInsideTap();
    await Future.delayed(const Duration(milliseconds: 500));
    resolver.resolveOutsideTap();
    await Future.delayed(const Duration(milliseconds: 500));
    expect(resolver.insideTaps, 4);
    expect(resolver.outsideTaps, 1);
  });
}

class TestTapsResolver extends TapsResolver {
  TestTapsResolver({required TapPriority tapPriority}) {
    initialize(tapPriority: tapPriority);
  }
  int insideTaps = 0;
  int outsideTaps = 0;
  @override
  void tapInside() => insideTaps++;

  @override
  void tapOutside() => outsideTaps++;
}
