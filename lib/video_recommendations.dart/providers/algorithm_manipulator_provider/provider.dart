import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_readability_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_speed_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/providers/youtube_scraper_provider.dart';
import 'package:languages/languages.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/data/exceptions.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import '../../../utils/cefr.dart';
import '../../../youtube_scraper/data/youtube_video_item.dart';
import '../../data/recommended_video.dart';
import '../../difficulty_ranker/ranker.dart';
import '../youtube_scraper_provider/provider.dart';
import 'history_manager.dart';
import 'webview_actions_handle.dart';
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
    findMostRelevantItem: (videos) async =>
        VideosDifficultyRanker.findMostRelevantVideo(
      [
        for (final video in videos) ...[
          () async {
            final subtitlesScraper = await subtitlesScraperCallback;
            final subtitlesData = await subtitlesScraper
                .scrapeSubtitles(
                  youtubeVideoId: video.id,
                  language: Language.english(),
                )
                .then((value) => value?.first);
            if (subtitlesData != null) {
              return RecommendedVideo.fromObservedVideo(
                video: video,
                subtitlesComplexity: await subtitlesData.subtitlesComplexity,
                syllablesPerMillisecond:
                    await subtitlesData.avgerageSyllablesPerMillisecond,
                cefr: CEFR.a1,
              );
            }
          }()
        ]
      ].whereType<RecommendedVideo>().toList(),
    ),
  );
});

class AlgorithmManipulatorHistoryManager implements ManipulatorHistoryManager {
  @override
  Future<void> addToHistory() async {}
  @override
  Future<List<ObservedVideo>> getHistory() async => [];
}
