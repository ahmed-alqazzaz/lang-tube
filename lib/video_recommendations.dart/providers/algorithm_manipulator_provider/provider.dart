import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_complexity.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_speed.dart';
import 'package:lang_tube/video_recommendations.dart/providers/youtube_scraper_provider.dart';
import 'package:languages/languages.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/data/exceptions.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import '../../../utils/cefr.dart';
import '../../data/recommended_videos.dart';
import '../../difficulty_ranker/difficulty_ranker.dart';
import '../../managers/youtube_algorithm_manipulator/webview_actions_handle.dart';
import '../../provider/video_recommendation_provider.dart';
import 'manipulator.dart';
import 'state.dart';

final youtubeAlgorithmManipulatorProvider = StateNotifierProvider<
    YoutubeAlgorithmMinpulator, YoutubeAlgorithmManipulatorState>((ref) {
  final youtubeScraper = ref.read(youtubeScraperProvider);
  final subtitlesScraperCallback = ref.read(subtitlesScraperProvider.future);

  return YoutubeAlgorithmMinpulator(
    observedVideos: youtubeScraper.observedVideos,
    actionsHandle: WebviewActionsHandle(
      scrollToBottom: youtubeScraper.interactions.scrollToBottom,
      getCurrentUrl: () => youtubeScraper.interactions.currentUrl,
      navigateHome: () async => youtubeScraper.interactions.naviagteHome(),
      getClickDepth: () async => youtubeScraper.interactions.videoClickDepth,
    ),
    historyManager: AlgorithmManipulatorHistoryManager(),
    getUserWatchHistory: () => [],
    findMostRelevantItem: (videoItems) async =>
        VideosDifficultyRanker.findMostRelevantVideo(
      [
        for (final item in videoItems) ...[
          () async {
            final subtitlesScraper = await subtitlesScraperCallback;
            try {
              final subtitlesData = await subtitlesScraper
                  .scrapeSubtitles(
                    youtubeVideoId: item.videoId,
                    language: Language.english(),
                  )
                  .then((value) => value.first);

              return RecommendedVideo.fromVideoItem(
                item: item,
                subtitlesComplexity: await subtitlesData.subtitlesComplexity,
                syllablesPerMillisecond:
                    await subtitlesData.avgerageSyllablesPerMillisecond,
                cefr: CEFR.a1,
              );
            } on SubtitlesScraperNoCaptionsFoundException catch (_) {
              log("${item.title} has no subtitles");
            }
          }()
        ]
      ].whereType<RecommendedVideo>().toList(),
    ),
  );
});
