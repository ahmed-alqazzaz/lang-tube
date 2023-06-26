import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lang_tube/youtube_scraper/youtube_cookies_manager.dart';
import 'package:lang_tube/youtube_scraper/youtube_video_item.dart';
import 'package:lang_tube/youtube_scraper/youtube_webview_manager.dart';

@immutable
class YoutubePlayerScraper {
  YoutubePlayerScraper({required String userAgent}) {
    _webViewManager = YoutubeWebViewManager(
      initialRequest: _youtubeUrl,
      userAgent: userAgent,
      onUrlUpdated: onUrlUpdated,
    )..clearCache().then((_) {
        _cookiesManager = YoutubeCookiesManager(
            uri: _youtubeUrl,
            cookiesUpdateCallBack: () async {
              await Future.delayed(cookieReloadDuration, () async {
                return await _webViewManager.reload();
              });
            });
      });
  }

  final _videoItems = <YoutubeVideoItem>[];
  late final YoutubeWebViewManager _webViewManager;
  late final YoutubeCookiesManager _cookiesManager;

  List<YoutubeVideoItem> get videoItems => List.unmodifiable(_videoItems);

  void onUrlUpdated(InAppWebViewController controller) async {
    // recursively wait for the DOM to be fully loaded
    if (!(await YoutubeWebViewManager.isDocumentFullyLoaded(controller))) {
      return await Future.delayed(const Duration(milliseconds: 150))
          .then((value) async {
        return onUrlUpdated(controller);
      });
    }
    // add each present video item from the webview into the items list
    final videoItems =
        await YoutubeWebViewManager.fetchRecommendedVideoData(controller);
    for (final videoItem in videoItems) {
      _videoItems.add(
        YoutubeVideoItem(
          videoId: videoItem['id'],
          channelIconUri: Uri.parse(videoItem['channel_icon_url']),
          thumbnailUri: Uri.parse(videoItem['thumbnail_url']),
          title: videoItem['title'] as String,
          badges:
              (videoItem['badges'] as List).map((e) => e as String).toList(),
          onClick: () async => await controller.evaluateJavascript(
            source: "clickVideoById('${videoItem['id']}')",
          ),
        ),
      );
    }
  }

  Future<void> run() async => await _webViewManager.run();

  Future<void> dispose() async {
    await _cookiesManager.close();
    await _webViewManager.dispose();
  }

  // keep navigating back until we're not watching a video
  Future<void> navigateHome() async {
    if ((await currentUrl()).contains('watch?')) {
      await navigateBack();
      Timer(const Duration(milliseconds: 500), () async {
        await navigateHome();
      });
    }
  }

  Future<void> navigateBack() async => await _webViewManager.navigateBack();

  Future<String> currentUrl() async => await _webViewManager.currentUrl();

  // it's critical that youtube doesn't redirect to any other urls
  // for instance if(https://www.youtube.com) it will redirect to
  // to a different url and cause errors with cookies management
  static Uri get _youtubeUrl => Uri.parse('https://m.youtube.com/');
}
