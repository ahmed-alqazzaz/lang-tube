import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import '../../models/video_recommendations/video_recommendations.dart';
import 'recommendations_actions_handler.dart';
import 'recommendations_collector.dart';
import 'recommendations_state_notifier.dart';
import 'youtube_scraper_cookies_storage_manager.dart';

class YoutubeRecommendationsManager {
  static YoutubeRecommendationsManager get instance => _instance;
  static final _instance = YoutubeRecommendationsManager._();
  YoutubeRecommendationsManager._()
      : _scraper = YoutubeScraper(
          cookieStorageManager: YoutubeScraperCookiesStorageManager(),
        ) {
    _recommendationsCollector = YoutubeRecommendationsCollector(
      observedVideos: _scraper.observedVideos,
    );
    _recommendationStateNotifier = YoutubeRecommendationsStateNotifier(
      observedVideos: _scraper.observedVideos,
      recommendationsCallback: () =>
          _recommendationsCollector.recommendations.expand(
        (element) => element.videos,
      ),
      navigationDepthCallback: () =>
          _scraper.interactionsController.videoClickDepth,
    );
    _actionsHandler = YoutubeRecommendationsActionsHandler(
      interactionsController: _scraper.interactionsController,
      recommendationsState: _recommendationStateNotifier.stream,
    );
  }
  final YoutubeScraper _scraper;
  late final YoutubeRecommendationsStateNotifier _recommendationStateNotifier;
  late final YoutubeRecommendationsActionsHandler _actionsHandler;
  late final YoutubeRecommendationsCollector _recommendationsCollector;

  Future<void> exploreInitialTabs({int tabsCount = 3}) async =>
      await _actionsHandler.exploreInitialTabs(tabsCount: tabsCount);

  Stream<List<VideoRecommendationsPackage>> get recommendations =>
      _recommendationsCollector.toStream().asyncMap(
            (recommendationsCollector) =>
                recommendationsCollector.recommendations,
          );

  InAppWebView get webView => _scraper.webview;

  Future<void> dispose() async {
    _recommendationStateNotifier.dispose();
    _recommendationsCollector.dispose();
    await _actionsHandler.dispose();
    await _scraper.dispose();
  }
}
