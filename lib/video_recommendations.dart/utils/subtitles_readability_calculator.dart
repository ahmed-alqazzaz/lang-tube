import 'package:readability/readability.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

extension SubtitleReadbilityCalculator on ScrapedSubtitles {
  Future<ReadabilityScore> get subtitlesComplexity async {
    return Readability.getInstance(Language.english).then(
      (instance) => instance.calculateScore(
        subtitles.map((e) => e.text).join(),
      ),
    );
  }
}
