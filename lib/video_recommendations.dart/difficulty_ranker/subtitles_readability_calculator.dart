import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/rust_api/api.dart';
import 'package:readability/readability.dart';

extension SubtitleComplexityCalculator on SubtitlesData {
  Future<ReadabilityScore> get subtitlesComplexity async =>
      await calculateTextReadability(
        text: subtitles.map((e) => e.text).join(),
      );
}
