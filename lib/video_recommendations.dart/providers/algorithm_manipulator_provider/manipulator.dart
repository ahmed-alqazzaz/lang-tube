import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/utils/diversity_score.dart';
import 'package:lang_tube/video_recommendations.dart/utils/target_language_videos.dart';
import 'package:languages/languages.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../../youtube_scraper/data/youtube_video_item.dart';
import 'history_manager.dart';
import 'webview_actions_handle.dart';
import 'state.dart';

class YoutubeAlgorithmMinpulator
    extends StateNotifier<YoutubeAlgorithmManipulatorState> {
  YoutubeAlgorithmMinpulator({
    required Stream<Iterable<ObservedVideo>> observedVideos,
    required WebviewActionsHandle actionsHandle,
    required ManipulatorHistoryManager historyManager,
    required List<ObservedVideo> Function() getUserWatchHistory,
    required Future<ObservedVideo> Function(List<ObservedVideo> items)
        findMostRelevantItem,
  })  : _videosObserverSubscription = observedVideos.listen(
          (videoItems) => videosObserver(
            videoItems: videoItems,
            actionsHandle: actionsHandle,
            historyManager: historyManager,
            findMostRelevantItem: findMostRelevantItem,
            getUserWatchHistory: getUserWatchHistory,
          ),
        ),
        super(YoutubeAlgorithmManipulatorState.inactive);

  final StreamSubscription<Iterable<ObservedVideo>> _videosObserverSubscription;

  static Future<void> videosObserver({
    required Iterable<ObservedVideo> videoItems,
    required WebviewActionsHandle actionsHandle,
    required ManipulatorHistoryManager historyManager,
    required List<ObservedVideo> Function() getUserWatchHistory,
    required Future<ObservedVideo> Function(List<ObservedVideo> items)
        findMostRelevantItem,
  }) async {
    return;
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

  @override
  void dispose() {
    _videosObserverSubscription.cancel();
    super.dispose();
  }

  static const Duration _videoClickDelay = Duration(seconds: 2);
  static const Duration _navigateHomeDelay = Duration(seconds: 3);
  static const int _maxClickDepth = 3;
}
