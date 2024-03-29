import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';
import 'package:throttler/throttler.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import 'recommendations_state.dart';

@immutable
final class YoutubeRecommendationsActionsHandler {
  static final _mutex = Mutex();
  static final _reloadThrottler = Throttler.privateInstance();

  YoutubeRecommendationsActionsHandler({
    required YoutubeInteractionsController interactionsController,
    required Stream<YoutubeRecommendationsState> recommendationsState,
  }) : _interactionsController = interactionsController {
    _recommendationsStateSubscription =
        recommendationsState.distinct().listen(_listener);
  }

  final YoutubeInteractionsController _interactionsController;
  late final StreamSubscription<YoutubeRecommendationsState>
      _recommendationsStateSubscription;
  late final _exploredTabs = <String>[];

  void _listener(YoutubeRecommendationsState state) {
    _mutex.acquire().whenComplete(() {
      log(state.toString());
      try {
        switch (state) {
          case YoutubeRecommendationsState.navigationOutOfControl:
            //_interactionsController.naviagteHome();
            Timer(_homeNavigationDelay, _mutex.release);
          case YoutubeRecommendationsState.languageMismatch:
            // TODO: click most apropriate video
            Timer(_videoClickDelay, _mutex.release);
          case YoutubeRecommendationsState.emptyFeed:
            // _reloadThrottler.throttle(
            //   _emptyFeedUltimatum,
            //   _interactionsController.reload,
            // );
            _mutex.release();
          default:
            _mutex.release();
        }
      } catch (_) {
        if (_mutex.isLocked) _mutex.release();

        rethrow;
      }
    });
  }

  Future<void> exploreInitialTabs({int tabsCount = 3}) async {
    try {
      await _mutex.acquire();
      final tabs = await _interactionsController.tabs;
      assert(tabsCount < tabs.length);
      if (_exploredTabs.length < tabsCount) {
        final unexploredTabs =
            tabs.whereNot((tab) => _exploredTabs.contains(tab));
        await _interactionsController.clickTab(tabName: unexploredTabs.first);
        _exploredTabs.add(unexploredTabs.first);
        await Future.delayed(const Duration(seconds: 5));
        await _interactionsController.scrollToBottom();
        await Future.delayed(const Duration(seconds: 5));
        await _interactionsController.scrollToBottom();
        await Future.delayed(const Duration(seconds: 2));
        return await exploreInitialTabs(tabsCount: tabsCount);
      }
    } finally {
      _mutex.release();
    }
  }

  Future<void> dispose() async =>
      await _recommendationsStateSubscription.cancel();

  static const Duration _homeNavigationDelay = Duration(seconds: 3);
  static const Duration _videoClickDelay = Duration(seconds: 4);
  static const Duration _emptyFeedUltimatum = Duration(seconds: 10);
}
