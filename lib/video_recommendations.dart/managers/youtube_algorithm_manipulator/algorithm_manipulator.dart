import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lang_tube/video_recommendations.dart/managers/helpers/diversity_score.dart';
import 'package:lang_tube/video_recommendations.dart/managers/helpers/target_language_videos.dart';
import 'package:lang_tube/video_recommendations.dart/managers/youtube_algorithm_manipulator/webview_actions_handle.dart';
import 'package:lang_tube/youtube_scraper/data/youtube_video_item.dart';
import 'package:languages/languages.dart';
import 'history_manager.dart';

// @immutable
// class YoutubeAlgorithmManipulator {
//   const YoutubeAlgorithmManipulator._();
//   static const Duration _videoClickDelay = Duration(seconds: 3);

//   // this method should be triggered when there are
//   // videos in languages other than target language
//   static Future<void> steerTowardsRelevantVideos(
//       List<YoutubeVideo> videos) async {
//     assert(videos.isNotEmpty);

//     final ranker = VideosDifficultyRanker.newInstance();
//     for (final video in videos) {
//       await ranker.addVideo(video);
//     }

//     // todo: choose based on level
//     await Future.delayed(
//       _videoClickDelay,
//       ranker.recommendations.first.item.click,
//     );
//   }
// }

@immutable
class YoutubeAlgorithmManipulator {
  static const Duration _videoClickDelay = Duration(seconds: 2);
  static const Duration _navigateHomeDelay = Duration(seconds: 3);
  static const int _maxClickDepth = 3;

  YoutubeAlgorithmManipulator({
    required Stream<Iterable<YoutubeVideoItem>> observedVideos,
    required WebviewActionsHandle actionsHandle,
    required ManipulatorHistoryManager historyManager,
    required List<YoutubeVideoItem> Function() getUserWatchHistory,
    required Future<YoutubeVideoItem> Function(List<YoutubeVideoItem> items)
        findMostRelevantItem,
  }) : _videosObserverSubscription = observedVideos.listen(
          (videoItems) => videosObserver(
            videoItems: videoItems,
            actionsHandle: actionsHandle,
            historyManager: historyManager,
            findMostRelevantItem: findMostRelevantItem,
            getUserWatchHistory: getUserWatchHistory,
          ),
        );
  final StreamSubscription<Iterable<YoutubeVideoItem>>
      _videosObserverSubscription;

  static Future<void> videosObserver({
    required Iterable<YoutubeVideoItem> videoItems,
    required WebviewActionsHandle actionsHandle,
    required ManipulatorHistoryManager historyManager,
    required List<YoutubeVideoItem> Function() getUserWatchHistory,
    required Future<YoutubeVideoItem> Function(List<YoutubeVideoItem> items)
        findMostRelevantItem,
  }) async {
    if (videoItems.isEmpty) return;

    // TODO: add MUTEX
    final targetLangaugeVideos =
        videoItems.getTargetLanguageVideos(Language.english().pattern).toList();
    final watchHistory = getUserWatchHistory();

    if (await actionsHandle.getClickDepth() > _maxClickDepth) {
      actionsHandle.navigateHome();
      return Future.delayed(
        _navigateHomeDelay,
        () => videosObserver(
          videoItems: videoItems,
          actionsHandle: actionsHandle,
          historyManager: historyManager,
          getUserWatchHistory: getUserWatchHistory,
          findMostRelevantItem: findMostRelevantItem,
        ),
      );
    }
    // in case a video in a language other than the target was discovered
    if (targetLangaugeVideos.length < videoItems.length) {
      log('hh ${targetLangaugeVideos.length}');
      if (targetLangaugeVideos.isNotEmpty) {
        // click most relevant item from target language videos
        return Future.delayed(
          _videoClickDelay,
          () {
            log("clicking ${targetLangaugeVideos.first.title}");
            targetLangaugeVideos.first.click();
            //   return findMostRelevantItem(targetLangaugeVideos).then(
            //   (item) => item.click(),
            // );
          },
        );
      }
      log("no videos found");
      return;
    }
    if (targetLangaugeVideos.diversityScore <= 0.5) {
      final uniqueWatchedVideos = watchHistory;
      uniqueWatchedVideos.isNotEmpty ? null : null;
    }
    if (watchHistory.length < 20) {}
  }

  Future<void> close() async {
    await _videosObserverSubscription.cancel();
  }
}
