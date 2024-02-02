import 'package:languages/languages.dart';
import 'package:readability/readability.dart';

import 'texts.dart';

Future<void> main() async {
  final timer = Stopwatch()..start();
  final instance = await Readability.getInstance(Language.english);
  final firstScore = await instance.calculateScore(texts[0]);
  final secondScore = await instance.calculateScore(texts[1]);
  print(timer.elapsedMilliseconds);
  print(await firstScore.compareTo(other: secondScore));
}
