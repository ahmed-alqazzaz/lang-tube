import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rxdart/rxdart.dart';
import 'package:throttler/throttler.dart';

import 'interactions_controller.dart';

final tbrm = GlobalKey();

@immutable
class YoutubeWebViewManager {
  factory YoutubeWebViewManager({
    required String userAgent,
    required Uri initialRequest,
    required Function(InAppWebViewController controller,
            YoutubeInteractionsController interactionsManager)
        onViewportUpdated,
  }) {
    // check if js file has been injected into the viewer
    late final jsInjectionController = BehaviorSubject<bool>()..add(false);
    late final inAppWebViewController =
        BehaviorSubject<InAppWebViewController>();
    late final interactionManager =
        YoutubeInteractionsController(inAppWebViewController);
    late final throttler = Throttler.privateInstance();

    return YoutubeWebViewManager._(
      interactionManager: interactionManager,
      webView: InAppWebView(
        key: tbrm,
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
        onLoadStop: (controller, url) {
          log('headless web view load stopped');
          interactionManager.scrollToBottom();
        },
        onLoadError: (controller, url, code, message) =>
            log('load error: $message error code :$code'),
        onScrollChanged: (controller, x, y) => throttler.throttle(
          const Duration(milliseconds: 1500),
          () => onViewportUpdated(controller, interactionManager),
        ),
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {
          throttler.throttle(const Duration(milliseconds: 1200),
              () => interactionManager.scrollToBottom());
          final hasJsBeenInjected = jsInjectionController.value;
          if (!hasJsBeenInjected) {
            YoutubeInteractionsController.injectJs(controller);
            jsInjectionController.add(true);
          }
          onViewportUpdated(controller, interactionManager);
        },
      ),
    );
  }

  const YoutubeWebViewManager._({
    required this.interactionManager,
    required this.webView,
  });

  final InAppWebView webView;
  final YoutubeInteractionsController interactionManager;

  // Future<void> run() async => await _webView.run();
  // Future<void> dispose() async {
  //   await _webView.dispose();
  //   await _disposeJsInjectionChecker?.call();
  // }
}
