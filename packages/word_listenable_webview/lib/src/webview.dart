// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:word_listenable_webview/src/controller.dart';

import 'clicked_word.dart';

class WordListenableWebview extends StatefulWidget {
  const WordListenableWebview({
    super.key,
    required this.userAgent,
    required this.initialRequest,
    required this.onWebViewCreated,
    required this.onWordTapped,
    required this.onProgressUpdated,
    required this.onUrlUpdated,
  });

  final String userAgent;
  final Uri initialRequest;
  final void Function(String url) onUrlUpdated;
  final void Function(int progress) onProgressUpdated;
  final void Function(ClickedWord word) onWordTapped;
  final void Function(WordListenableWebViewController controller)
      onWebViewCreated;
  @override
  State<WordListenableWebview> createState() => WordListenableWebviewState();
}

class WordListenableWebviewState extends State<WordListenableWebview> {
  late final WordListenableWebViewController _controller;
  bool _isJsInjected = false;
  bool _allowPointers = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async => await _controller.reload(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: constraints,
              child: InAppWebView(
                gestureRecognizers: {
                  Factory(
                    () => WordListenableWebViewGestureRecognizer(
                      shouldAllowPointer: () {
                        return _allowPointers;
                      },
                      onVertcalDragUpdates: (double deltaY) async {
                        if (deltaY < 0 && _allowPointers == false) {
                          _allowPointers = true;
                          //  _controller.enableScroll();
                        }
                        if (deltaY > 0 &&
                            _allowPointers == true &&
                            await _controller.scrollOffset == 0) {
                          _allowPointers = false;
                          //  _controller.disableScroll();
                        }
                      },
                    ),
                  ),
                },
                initialUrlRequest: URLRequest(url: widget.initialRequest),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    userAgent: widget.userAgent,
                    mediaPlaybackRequiresUserGesture: false,
                    transparentBackground: true,
                    supportZoom: true,
                    disableHorizontalScroll: false,
                    disableVerticalScroll: false,
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onConsoleMessage: (controller, consoleMessage) =>
                    print("s" + consoleMessage.message),
                onWebViewCreated: (controller) {
                  _controller = WordListenableWebViewController(controller);
                  widget.onWebViewCreated(_controller);
                  _controller.addJavaScriptHandler(
                    handlerName: 'clickedWordHandler',
                    callback: (args) async => _wordClickHandler(args[0]),
                  );
                },
                onProgressChanged: (controller, progress) =>
                    widget.onProgressUpdated(progress),
                onLoadStart: (controller, url) => _isJsInjected = false,
                onUpdateVisitedHistory: (controller, url, __) {
                  if (!_isJsInjected) _injectJs();
                  widget.onUrlUpdated(url.toString());
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  void _injectJs() {
    _isJsInjected = true;
    _controller.injectJavascriptFileFromAsset(
      assetFilePath:
          'packages/word_listenable_webview/web_assets/word_clickifier.js',
    );
  }

  void _wordClickHandler(Map<String, dynamic> args) {
    widget.onWordTapped(
      ClickedWord.fromMap(
        map: args,
        highlight: ({required backgroundColor, required textColor}) =>
            _controller.highlightWord(
          id: args['id'],
          backgroundColor: backgroundColor,
          textColor: textColor,
        ),
        removeHighlight: () => _controller.removeHighlight(args['id']),
      ),
    );
  }
}

class WordListenableWebViewGestureRecognizer extends EagerGestureRecognizer {
  bool Function() shouldAllowPointer;
  void Function(double verticalDelta) onVertcalDragUpdates;
  WordListenableWebViewGestureRecognizer({
    required this.shouldAllowPointer,
    required this.onVertcalDragUpdates,
  });
  bool x = false;
  @override
  bool isPointerAllowed(PointerEvent event) {
    x = shouldAllowPointer();
    return x;
  }

  @override
  void addPointer(PointerEvent event) {
    if (event is PointerDownEvent) {
      super.addPointer(event);
      startTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      if (x != shouldAllowPointer()) {
        stopTrackingPointer(event.pointer);
        addPointer(event);
      }
      onVertcalDragUpdates(event.delta.dy);
    }
  }
}
