import 'rust_bridge/rust_api.dart';
import 'texts.dart';

Future<void> main() async {
  final timer = Stopwatch()..start();
  final firstScore =
      await rustTestApi.calculateSubtitleComplexity(text: texts[0]);
  final secondScore =
      await rustTestApi.calculateSubtitleComplexity(text: texts[1]);
  print(timer.elapsedMilliseconds);
  print(await firstScore.compareTo(other: secondScore));
}
