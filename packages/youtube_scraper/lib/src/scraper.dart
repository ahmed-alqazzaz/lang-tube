import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_scraper/src/cookies_storage_manager.dart';
import 'cookies_manager.dart';
import 'interactions_controller.dart';
import 'webview_manager.dart';
import 'observed_video.dart';

export 'observed_video.dart';
export 'interactions_controller.dart';
export 'cookies_storage_manager.dart';

@immutable
class YoutubeScraper {
  factory YoutubeScraper(
      {required CookiesStorageManager cookieStorageManager}) {
    const mockUserAgent =
        'Mozilla/5.0 (Linux; Android 9; SKW-H0 Build/SKYW2003090OS00MP6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/114.0.5735.60 Mobile Safari/537.36';
    final videosObserver =
        StreamController<Iterable<ObservedVideo>>.broadcast();
    return YoutubeScraper._(
      videosObserver: videosObserver,
      cookieStorageManager: cookieStorageManager,
      webViewManager: YoutubeWebViewManager(
        initialRequest: _youtubeUrl,
        userAgent: mockUserAgent,
        onViewportUpdated: (controller, interactionManager) {
          _onViewportUpdated(
            controller: controller,
            interactionsManager: interactionManager,
            onItemsObserved: ({required observedVideos}) =>
                videosObserver.sink.add(observedVideos),
          );
        },
      ),
    );
  }

  YoutubeScraper._(
      {required YoutubeWebViewManager webViewManager,
      required StreamController<Iterable<ObservedVideo>> videosObserver,
      required CookiesStorageManager cookieStorageManager})
      : _webViewManager = webViewManager,
        interactions = webViewManager.interactionManager,
        _videosObserver = videosObserver {
    // TODO: remove the timer, when migrating back to healdess webview
    Timer(const Duration(seconds: 5), () {
      _webViewManager.interactionManager.clearCache().then((_) {
        _cookiesManager = YoutubeCookiesManager(
          storageManager: cookieStorageManager,
          youtubeUrl: _youtubeUrl,
          onCookiesInjected: () async {
            return await interactions.reload();
          },
        );
      });
    });
  }

  final YoutubeWebViewManager _webViewManager;
  final YoutubeInteractionsController interactions;

  final StreamController<Iterable<ObservedVideo>> _videosObserver;
  Stream<Iterable<ObservedVideo>> get observedVideos => _videosObserver.stream;

  late final YoutubeCookiesManager _cookiesManager;

  static void _onViewportUpdated({
    required InAppWebViewController controller,
    required YoutubeInteractionsController interactionsManager,
    required void Function({required Iterable<ObservedVideo> observedVideos})
        onItemsObserved,
  }) async {
    // in case document is not loaded yet or video aren't present
    // recursively wait for the DOM to be fully loaded
    if (!(await interactionsManager.isDocumentLoaded)) {
      return Future.delayed(const Duration(milliseconds: 150)).then(
        (value) async {
          return _onViewportUpdated(
            controller: controller,
            interactionsManager: interactionsManager,
            onItemsObserved: onItemsObserved,
          );
        },
      );
    }

    return onItemsObserved(
      observedVideos: await interactionsManager.fetchObservedVideos().then(
        (observedItems) async {
          final sourceTab = await interactionsManager.selectedTab;
          return observedItems.map(
            (videoItem) => ObservedVideo(
              id: videoItem['id'],
              channelIconUrl: videoItem['channel_icon_url'],
              thumbnailUrl: videoItem['thumbnail_url'],
              title: videoItem['title'] as String,
              sourceTab: sourceTab,
              badges: (videoItem['badges'] as List)
                  .map((e) => e as String)
                  .toList(),
              onClick: () async => interactionsManager.clickVideoById(
                videoId: videoItem['id'],
              ),
            ),
          );
        },
      ),
    );
  }

  InAppWebView get webview => _webViewManager.webView;
  // Future<void> run() async => await _webViewManager.run();

  Future<void> dispose() async {
    await _cookiesManager.close();
    await _videosObserver.close();
    //await _webViewManager.dispose();
  }

  // Future<List> fetchRecommendedVideos() async =>
  //     await _webViewManager.fetchRecommendedVideos();

  // it's critical that youtube doesn't redirect to any other urls
  // for instance if(https://www.youtube.com) it will redirect to
  // to a different url and cause errors with cookies management
  static Uri get _youtubeUrl => Uri.parse('https://m.youtube.com/');
}
