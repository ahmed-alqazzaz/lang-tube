import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_manager/recommendations_state_notifier.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_manager/state.dart';
import 'package:mutex/mutex.dart';
import 'package:throttler/throttler.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

@immutable
final class YoutubeRecommendationsActionsHandler {
  static final _mutex = Mutex();
  static final _reloadThrottler = Throttler.privateInstance();

  YoutubeRecommendationsActionsHandler({
    required YoutubeInteractionsController interactionsController,
    required Stream<Iterable<ObservedVideo>> observedVideos,
  })  : _interactionsController = interactionsController,
        _recommendationsStateNotifier = YoutubeRecommendationsStateNotifier(
          observedVideos: observedVideos,
          navigationDepthCallback: () => interactionsController.videoClickDepth,
        ) {
    _removeListenerCallback = _recommendationsStateNotifier
        .addListener(_listener, fireImmediately: false);
  }

  final YoutubeInteractionsController _interactionsController;
  final YoutubeRecommendationsStateNotifier _recommendationsStateNotifier;
  late final VoidCallback _removeListenerCallback;
  late final _exploredTabs = <String>[];

  void _listener(YoutubeRecommendationsState state) {
    _mutex.acquire().whenComplete(() {
      switch (state) {
        case YoutubeRecommendationsState.navigationOutOfControl:
          _interactionsController.naviagteHome();
          Timer(_homeNavigationDelay, _mutex.release);
        case YoutubeRecommendationsState.languageMismatch:
          // TODO: click most apropriate video
          Timer(_videoClickDelay, _mutex.release);
        case YoutubeRecommendationsState.emptyFeed:
          _reloadThrottler.throttle(
            _emptyFeedUltimatum,
            _interactionsController.reload,
          );
          _mutex.release();
        default:
          _mutex.release();
      }
    });
  }

  Future<void> exploreInitialTabs({int tabsCount = 3}) async {
    try {
      final tabs = await _interactionsController.tabs;
      assert(tabsCount < tabs.length);
      if (_exploredTabs.length < tabsCount) {
        final unexploredTabs =
            tabs.whereNot((tab) => _exploredTabs.contains(tab));
        await _interactionsController.clickTab(tabName: unexploredTabs.first);
        _exploredTabs.add(unexploredTabs.first);
        await Future.delayed(const Duration(seconds: 3));
        await _interactionsController.scrollToBottom();
        await Future.delayed(const Duration(seconds: 5));
        await _interactionsController.scrollToBottom();
        await Future.delayed(const Duration(seconds: 5));
        return await exploreInitialTabs(tabsCount: tabsCount);
      }
    } finally {}
  }

  VoidCallback addListener(
          void Function(YoutubeRecommendationsState) listener) =>
      _recommendationsStateNotifier.addListener(listener);

  void dispose() => _removeListenerCallback();

  static const Duration _homeNavigationDelay = Duration(seconds: 3);
  static const Duration _videoClickDelay = Duration(seconds: 4);
  static const Duration _emptyFeedUltimatum = Duration(seconds: 10);
}
