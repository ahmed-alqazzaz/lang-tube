import 'dart:developer';
import 'package:readability/readability.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../models/subtitles/subtitles_data.dart';

extension SubtitleReadbilityCalculator on ScrapedSubtitles {
  Future<ReadabilityScore> get subtitlesComplexity async =>
      await calculateTextReadability(
        text: subtitles.map((e) => e.text).join(),
      ).onError((error, stackTrace) {
        log(subtitles.map((e) => e.text).join());
        throw stackTrace;
      });
}
