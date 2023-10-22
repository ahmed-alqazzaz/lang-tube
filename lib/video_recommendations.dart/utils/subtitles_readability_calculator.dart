import 'dart:developer';

import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';
import 'package:readability/readability.dart';

extension SubtitleReadbilityCalculator on SubtitlesData {
  Future<ReadabilityScore> get subtitlesComplexity async =>
      await calculateTextReadability(
        text: subtitles.map((e) => e.text).join(),
      ).onError((error, stackTrace) {
        log(subtitles.map((e) => e.text).join());
        throw stackTrace;
      });
}
