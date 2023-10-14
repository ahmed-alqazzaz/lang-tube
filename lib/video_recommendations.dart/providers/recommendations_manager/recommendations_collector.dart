import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import 'package:lang_tube/utils/cefr.dart';
import 'package:lang_tube/video_recommendations.dart/data/recommended_video.dart';
import 'package:lang_tube/video_recommendations.dart/data/video_recommendations.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/ranker.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_readability_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_speed_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/utils/target_language_videos.dart';
import 'package:languages/languages.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

class YoutubeRecommendationsCollector extends ChangeNotifier {
  YoutubeRecommendationsCollector({
    required Stream<Iterable<ObservedVideo>> observedVideos,
  }) {
    observedVideos.asyncExpand(_recommendedVideosMapper).listen(
          _observedVideosListener,
        );
  }
  final _recommendations = <VideoRecommendationsPackage>[];
  List<VideoRecommendationsPackage> get recommendations => _recommendations;
  Future<void> _observedVideosListener(RecommendedVideo video) async {
    if (video.thumbnailUrl.isEmpty) return;
    if (_isVideoPresent(video)) return;
    final tabRecommendationsIndex = _recommendations.indexWhere(
      (recommendation) => recommendation.sourceTab == video.sourceTab,
    );
    if (tabRecommendationsIndex != -1) {
      final tabRecommendations = _recommendations[tabRecommendationsIndex];
      await tabRecommendations.videos.insertNewVideo(newVideo: video);
    } else {
      _recommendations.add(
        VideoRecommendationsPackage(
          sourceTab: video.sourceTab,
          videos: [video],
        ),
      );
    }
    notifyListeners();
  }

  Stream<RecommendedVideo> _recommendedVideosMapper(
    Iterable<ObservedVideo> videos,
  ) async* {
    final subtitlesScraper =
        await ProviderContainer().read(subtitlesScraperProvider.future);

    final targetLanguageVideos =
        videos.getTargetLanguageVideos(Language.english().pattern);
    for (final video in targetLanguageVideos) {
      final subtitlesData = await subtitlesScraper
          .scrapeSubtitles(
            youtubeVideoId: video.id,
            language: Language.english(),
          )
          .then((value) => value?.first);

      if (subtitlesData != null) {
        yield RecommendedVideo.fromObservedVideo(
          video: video,
          subtitlesComplexity: await subtitlesData.subtitlesComplexity,
          syllablesPerMillisecond:
              await subtitlesData.avgerageSyllablesPerMillisecond,
          cefr: CEFR.a1,
        );
      } else {
        printRed("${video.title} has no subtitles");
      }
    }
  }

  bool _isVideoPresent(ObservedVideo video) {
    for (VideoRecommendationsPackage recommendationsPackage
        in _recommendations) {
      for (RecommendedVideo recommendation in recommendationsPackage.videos) {
        if (video == recommendation) {
          return true;
        }
      }
    }
    return false;
  }
}
