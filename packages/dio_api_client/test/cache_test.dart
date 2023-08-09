
import 'package:dio_api_client/dio_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = DioApiClient(useCache: true);
  test('initial request lasts longer than the rest', () async {
    final timer = Stopwatch()..start();
    final request = Uri.parse(
      "https://dart.dev/assets/dash/2x/paint-your-ui.png",
    );
    await client.fetchUri(request);
    final initialRequestElapse = timer.elapsed;
    timer.reset();

    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      timer.reset();
      await client.fetchUri(request);
      final newRequestElapse = timer.elapsed;
      expect(initialRequestElapse, greaterThan(newRequestElapse));
    }
  });
}
