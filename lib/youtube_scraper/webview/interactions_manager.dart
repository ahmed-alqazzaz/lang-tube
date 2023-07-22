import 'dart:async';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/debouncer.dart';

class WebViewInteractionsManager {
  static const _homeNavigationReloadDelay = Duration(milliseconds: 1500);
  WebViewInteractionsManager(this.inAppWebViewController);
  int videoClickDepth = 0;
  // replace with controller
  final BehaviorSubject<InAppWebViewController> inAppWebViewController;
  InAppWebViewController? get _controller => inAppWebViewController.valueOrNull;

  Future<String> get currentUrl async =>
      await _controller!.evaluateJavascript(source: 'currentUrl()').then(
            (value) => value as String,
          );

  Future<bool> get isDocumentLoaded async =>
      await _controller!
          .evaluateJavascript(source: 'isDocumentFullyLoaded()') ??
      false;

  Future<void> navigateBack() async {
    videoClickDepth--;
    return await _controller!.evaluateJavascript(source: 'navigateBack()');
  }

  Future<void> naviagteHome() async {
    videoClickDepth = 0;
    Timer(_homeNavigationReloadDelay, reload);
    return await _controller!.evaluateJavascript(source: 'navigateHome()');
  }

  Future<void> scrollToBottom() async =>
      await _controller!.evaluateJavascript(source: 'scrollToBottom()');

  Future<void> clearCache() async => await _controller!.clearCache();

  Future<void> reload() async => await _controller!.reload();

  Future<void> clickVideoById(
      {required InAppWebViewController controller,
      required String videoId}) async {
    debouncer(const Duration(milliseconds: 1500), () async {
      videoClickDepth++;
      await controller.evaluateJavascript(
        source: "clickVideoById('$videoId')",
      );
    });
  }

  Future<List> fetchObservedVideos() async {
    final data = await _controller?.evaluateJavascript(
      source: 'fetchRecommendedVideosData()',
    );
    if (data == null) {
      printError('fetchRecommendedVideosData is returning null');
      return Future.delayed(
          const Duration(milliseconds: 500), fetchObservedVideos);
    }
    return jsonDecode(data) as List<dynamic>;
  }

  static Future<void> injectJs(InAppWebViewController controller) async {
    return await controller.injectJavascriptFileFromAsset(
      assetFilePath: 'javascript/youtube_scraper.js',
    );
  }
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}
