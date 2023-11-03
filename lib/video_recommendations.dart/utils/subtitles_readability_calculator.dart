import 'dart:developer';
import 'package:readability/readability.dart';

import '../../models/subtitles_scraping/subtitles_data.dart';

extension SubtitleReadbilityCalculator on SubtitlesData {
  Future<ReadabilityScore> get subtitlesComplexity async =>
      await calculateTextReadability(
        text: subtitles.map((e) => e.text).join(),
      ).onError((error, stackTrace) {
        log(subtitles.map((e) => e.text).join());
        throw stackTrace;
      });
}
