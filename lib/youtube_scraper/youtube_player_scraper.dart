// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:lang_tube/youtube_scraper/webview/cookies_manager.dart';
// import 'package:lang_tube/youtube_scraper/webview/interactions_manager.dart';
// import 'package:lang_tube/youtube_scraper/webview/webview_manager.dart';

// import 'data/youtube_video_item.dart';

// @immutable
// class YoutubePlayerScraper {
//   // create a singleton
//   static final _instance = YoutubePlayerScraper._internal();
//   factory YoutubePlayerScraper.sharedInstance() => _instance;

//   YoutubePlayerScraper._({
//     required YoutubeWebViewManager webViewManager,
//     required StreamController<Iterable<YoutubeVideoItem>> videosObserver,
//   })  : _webViewManager = webViewManager,
//         interactions = webViewManager.interactionManager,
//         _videosObserver = videosObserver {
//     log("instantiated scraper");
//     // TODO: remove the timer, when migrating back to healdess webview
//     Timer(const Duration(seconds: 5), () {
//       _webViewManager.interactionManager.clearCache().then((_) {
//         _cookiesManager = YoutubeCookiesManager(
//           uri: _youtubeUrl,
//           cookiesUpdateCallBack: () async {
//             await Future.delayed(cookieReloadDuration, () async {
//               return await interactions.reload();
//             });
//           },
//         );
//       });
//     });
//   }

//   factory YoutubePlayerScraper._internal() {
//     const mockUserAgent =
//         'Mozilla/5.0 (Linux; Android 9; SKW-H0 Build/SKYW2003090OS00MP6; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/114.0.5735.60 Mobile Safari/537.36';
//     final videosObserver =
//         StreamController<Iterable<YoutubeVideoItem>>.broadcast();
//     return YoutubePlayerScraper._(
//       videosObserver: videosObserver,
//       webViewManager: YoutubeWebViewManager(
//         initialRequest: _youtubeUrl,
//         userAgent: mockUserAgent,
//         onViewportUpdated: (controller, interactionManager) {
//           _onViewportUpdated(
//             controller: controller,
//             interactionsManager: interactionManager,
//             onItemsObserved: ({required observedVideos}) =>
//                 videosObserver.sink.add(observedVideos),
//           );
//         },
//       ),
//     );
//   }
//   final YoutubeWebViewManager _webViewManager;
//   final WebViewInteractionsManager interactions;
//   final StreamController<Iterable<YoutubeVideoItem>> _videosObserver;

//   late final YoutubeCookiesManager _cookiesManager;

//   Stream<Iterable<YoutubeVideoItem>> get observedVideos =>
//       _videosObserver.stream;

//   static void _onViewportUpdated({
//     required InAppWebViewController controller,
//     required WebViewInteractionsManager interactionsManager,
//     required void Function({required Iterable<YoutubeVideoItem> observedVideos})
//         onItemsObserved,
//   }) async {
//     // in case document is not loaded yet or video aren't present
//     // recursively wait for the DOM to be fully loaded
//     if (!(await interactionsManager.isDocumentLoaded)) {
//       return Future.delayed(const Duration(milliseconds: 150)).then(
//         (value) async {
//           return _onViewportUpdated(
//             controller: controller,
//             interactionsManager: interactionsManager,
//             onItemsObserved: onItemsObserved,
//           );
//         },
//       );
//     }

//     return onItemsObserved(
//       observedVideos: await interactionsManager.fetchObservedVideos().then(
//         (observedItems) async {
//           final sourceTab = await interactionsManager.selectedTab;
//           printError("scraper observed ${observedItems.length}");
//           return observedItems.map(
//             (videoItem) => YoutubeVideoItem(
//               videoId: videoItem['id'],
//               channelIconUrl: videoItem['channel_icon_url'],
//               thumbnailUrl: videoItem['thumbnail_url'],
//               title: videoItem['title'] as String,
//               sourceTab: sourceTab,
//               badges: (videoItem['badges'] as List)
//                   .map((e) => e as String)
//                   .toList(),
//               onClick: () async => interactionsManager.clickVideoById(
//                 videoId: videoItem['id'],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   InAppWebView get webview => _webViewManager.webView;
//   // Future<void> run() async => await _webViewManager.run();

//   // Future<void> dispose() async {
//   //   await _cookiesManager.close();
//   //   await _webViewManager.dispose();
//   // }

//   // Future<List> fetchRecommendedVideos() async =>
//   //     await _webViewManager.fetchRecommendedVideos();

//   // it's critical that youtube doesn't redirect to any other urls
//   // for instance if(https://www.youtube.com) it will redirect to
//   // to a different url and cause errors with cookies management
//   static Uri get _youtubeUrl => Uri.parse('https://m.youtube.com/');
// }
