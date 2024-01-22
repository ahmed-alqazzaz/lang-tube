import 'package:readability/rust_bridge/api.dart';
import 'rust_bridge/readability_score.dart';
export 'rust_bridge/readability_score.dart';

Future<int> calculateTextReadability({required String text}) async =>
    rustApi.calculateTextComplexity(text: text);

Future<String> countSyllables({required String text}) async =>
    rustApi.countSyllables(text: text);
