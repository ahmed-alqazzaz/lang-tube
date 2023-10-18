import 'package:readability/rust_bridge/api.dart';
import 'package:readability/rust_bridge/bridge.dart';
import 'rust_bridge/readability_score.dart';
export 'rust_bridge/readability_score.dart';

Future<ReadabilityScore> calculateTextReadability(
        {required String text}) async =>
    rustApi.calculateSubtitleComplexity(text: text);

Future<int> countSyllables({required String text}) async =>
    rustApi.countSyllables(text: text);
