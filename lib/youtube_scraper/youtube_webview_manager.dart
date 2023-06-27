import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class YoutubeWebViewManager {
  factory YoutubeWebViewManager({
    required String userAgent,
    required Uri initialRequest,
    required Function(InAppWebViewController controller) onUrlUpdated,
  }) {
    // check if js file has been injected into the viewer
    final jsInjectionController = BehaviorSubject<bool>();
    late final inAppWebViewController =
        BehaviorSubject<InAppWebViewController>();
    return YoutubeWebViewManager._(
      inAppWebViewController: inAppWebViewController,
      webView: InAppWebView(
        initialUrlRequest: URLRequest(url: initialRequest),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            userAgent: userAgent,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            supportZoom: false,
            disableHorizontalScroll: false,
            disableVerticalScroll: false,
            useShouldOverrideUrlLoading: true,
          ),
        ),
        onConsoleMessage: (controller, consoleMessage) {
          log(consoleMessage.message);
        },
        onWebViewCreated: (controller) {
          inAppWebViewController.add(controller);
          log('web view created');
        },
        onLoadStart: (controller, url) async {
          log('headless web view load started');
          jsInjectionController.add(false);
        },
        onLoadError: (controller, url, code, message) {
          log('load error: $message error code :$code');
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {
          log(url!.path);
          final hasJsbeenInjected = jsInjectionController.value;
          if (!hasJsbeenInjected) {
            injectJs(controller);
            jsInjectionController.add(true);
          }
          onUrlUpdated(controller);
        },
      ),
    );
  }

  const YoutubeWebViewManager._({
    required InAppWebView webView,
    required this.inAppWebViewController,
    Future<void> Function()? disposeJsInjectionChecker,
  })  : webView = webView,
        _disposeJsInjectionChecker = disposeJsInjectionChecker;

  final InAppWebView webView;
  final Future<void> Function()? _disposeJsInjectionChecker;
  final BehaviorSubject<InAppWebViewController> inAppWebViewController;
  InAppWebViewController? get _controller => inAppWebViewController.valueOrNull;

  // Future<void> run() async => await _webView.run();
  // Future<void> dispose() async {
  //   await _webView.dispose();
  //   await _disposeJsInjectionChecker?.call();
  // }

  Future<String> currentUrl() async =>
      await _controller!.evaluateJavascript(source: 'currentUrl()').then(
            (value) => value as String,
          );
  Future<void> navigateBack() async =>
      await _controller!.evaluateJavascript(source: 'navigateBack()');

  Future<void> scrollToBottom() async =>
      await _controller!.evaluateJavascript(source: 'scrollToBottom()');

  Future<bool> get isDocumentLoaded async =>
      await isDocumentFullyLoaded(_controller!);

  Future<void> clearCache() async => await _controller!.clearCache();

  Future<void> reload() async => await _controller!.reload();

  static Future<bool> isDocumentFullyLoaded(
          InAppWebViewController controller) async =>
      await controller.evaluateJavascript(source: 'isDocumentFullyLoaded()') ??
      false;

  static Future<List> fetchRecommendedVideoData(
      InAppWebViewController controller) async {
    final data = await controller.evaluateJavascript(
      source: 'fetchRecommendedVideosData()',
    );
    assert(data != null, 'fetchRecommendedVideosData() is returning null');
    return jsonDecode(data) as List<dynamic>;
  }

  static Future<void> injectJs(InAppWebViewController controller) async {
    return await controller.injectJavascriptFileFromAsset(
      assetFilePath: 'javascript/youtube_scraper.js',
    );
  }
}
