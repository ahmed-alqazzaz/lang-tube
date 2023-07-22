import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/video_recommendations_provider/video_recommendations_notifer.dart';
import 'package:lang_tube/video_recommendations.dart/video_recommendations_provider/video_recommendations_state.dart';
import 'package:lang_tube/youtube_scraper/data/youtube_video_item.dart';

import '../../subtitles_player/providers/subtitles_fetch_provider.dart';
import '../../subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';
import '../../utils/cefr.dart';
import '../../youtube_scraper/youtube_player_scraper.dart';
import '../managers/videos_recommendations_manager/data/youtube_video.dart';
import '../managers/videos_recommendations_manager/videos_recommendations_manager.dart';
import '../managers/youtube_algorithm_manipulator/algorithm_manipulator.dart';
import '../managers/youtube_algorithm_manipulator/history_manager.dart';
import '../managers/youtube_algorithm_manipulator/webview_actions_handle.dart';

final videoRecommendationsProvider =
    StateNotifierProvider<VideoRecommendationsNotifier, VideoRecommendations>(
        (ref) {
  final helper = RecommendationsProviderHelper(
    ref: ref,
    youtubeScraper: YoutubePlayerScraper.sharedInstance(),
  );
  ref.onDispose(() async => await helper.dispose());
  return VideoRecommendationsNotifier(
    recommendationsManager: helper.recommendationsManager,
  );
});

@immutable
class RecommendationsProviderHelper {
  RecommendationsProviderHelper({
    required StateNotifierProviderRef ref,
    required YoutubePlayerScraper youtubeScraper,
  })  : algorithmManipulator = YoutubeAlgorithmManipulator(
            observedVideos: youtubeScraper.observedVideos,
            actionsHandle: WebviewActionsHandle(
              scrollToBottom: youtubeScraper.interactions.scrollToBottom,
              getCurrentUrl: () => youtubeScraper.interactions.currentUrl,
              navigateHome: () async =>
                  youtubeScraper.interactions.naviagteHome(),
              getClickDepth: () async =>
                  youtubeScraper.interactions.videoClickDepth,
            ),
            historyManager: AlgorithmManipulatorHistoryManager(),
            getUserWatchHistory: () => [],
            findMostRelevantItem: (videoItems) async {
              return VideosRecommendationsManager.findMostRelevantVideo([
                for (final item in videoItems)
                  YoutubeVideo(
                    item: item,
                    subtitles: await fetchSubtitles(
                      ref: ref,
                      videoId: item.videoId,
                      mainLanguage: 'english',
                      targetLanguage: 'german',
                    ),
                    cefrLevel: CEFR.a1,
                  )
              ]).item;
            }),
        recommendationsManager = VideosRecommendationsManager(
          youtubeScraper.observedVideos.asyncExpand(
            (videoItems) async* {
              for (final item in videoItems) {
                yield YoutubeVideo(
                  item: item,
                  subtitles: await fetchSubtitles(
                    ref: ref,
                    videoId: item.videoId,
                    mainLanguage: 'english',
                    targetLanguage: 'german',
                  ),
                  cefrLevel: CEFR.a1,
                );
              }
            },
          ),
        );
  final YoutubeAlgorithmManipulator algorithmManipulator;
  final VideosRecommendationsManager recommendationsManager;

  Future<void> dispose() async {
    await algorithmManipulator.close();
  }

  static Future<SubtitlesBundle> fetchSubtitles({
    required StateNotifierProviderRef ref,
    required String videoId,
    required String mainLanguage,
    required String targetLanguage,
  }) async {
    return await ref.read(
      subtitlesFetchProviderFamily((
        videoId: videoId,
        mainLanguage: mainLanguage,
        translatedLanguage: targetLanguage,
      )).future,
    );
  }
}

class AlgorithmManipulatorHistoryManager implements ManipulatorHistoryManager {
  @override
  Future<void> addToHistory() async {}
  @override
  Future<List<YoutubeVideoItem>> getHistory() async => [];
}
