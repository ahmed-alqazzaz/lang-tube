import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/data/youtube_video.dart';
import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/rust_api/api.dart';

extension SubtitleComplexityCalculator on YoutubeVideo {
  Future<SubtitleComplexity> get subtitlesComplexity async =>
      await rustApi.calculateSubtitleComplexity(
        text: subtitles.mainSubtitles.subtitles,
      );
}
