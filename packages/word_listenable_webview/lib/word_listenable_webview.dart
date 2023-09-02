library word_listenable_webview;

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:word_listenable_webview/clicked_word.dart';
import 'package:word_listenable_webview/extensions.dart';

class WordListenableWebview extends StatefulWidget {
  const WordListenableWebview({
    super.key,
    required this.userAgent,
    required this.initialRequest,
    required this.onWordTapped,
  });

  final String userAgent;
  final Uri initialRequest;
  final void Function(String) onWordTapped;
  @override
  State<WordListenableWebview> createState() => WordListenableWebviewState();
}

class WordListenableWebviewState extends State<WordListenableWebview> {
  late final InAppWebViewController _controller;
  late final StreamController<Uri> _currentUrlController;
  bool _isJsInjected = false;

  @override
  void initState() {
    _currentUrlController = StreamController()..add(widget.initialRequest);
    super.initState();
  }

  @override
  void dispose() {
    _currentUrlController.close();
    super.dispose();
  }

  void loadUrl(Uri request) =>
      _controller.loadUrl(urlRequest: URLRequest(url: request));
  Stream<Uri> get currentUrl => _currentUrlController.stream;

  Future<void> _highlightWord({
    required String id,
    required Color backgroundColor,
    required Color textColor,
  }) async =>
      await _controller.evaluateJavascript(
        source: """
        highglightWord(
         '$id',
         '${backgroundColor.toRgbaString()}', 
         '${textColor.toRgbaString()}', 
     ) """,
      );
  Future<void> _removeHighlight(String id) async =>
      await _controller.evaluateJavascript(
        source: "removeHighlight('$id')",
      );
  Future<void> removeAllHighlights() async =>
      await _controller.evaluateJavascript(source: 'removeAllHighlights()');

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
      child: InAppWebView(
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
            print(consoleMessage.message),
        onWebViewCreated: (controller) {
          _controller = controller;
          controller.addJavaScriptHandler(
            handlerName: 'clickedWordHandler',
            callback: (args) {
              final map = args[0];
              final clickedWord = ClickedWord.fromMap(
                map: map,
                highlight: ({required backgroundColor, required textColor}) =>
                    _highlightWord(
                        id: map['id'],
                        backgroundColor: backgroundColor,
                        textColor: textColor),
                removeHighlight: () => _removeHighlight(map['id']),
              );

              clickedWord.highlight(
                backgroundColor: Colors.white,
                textColor: Colors.amber.shade600,
              );
              Timer(Duration(seconds: 5), () {
                clickedWord.removeHighlight();
              });
            },
          );
        },
        onLoadStart: (controller, url) {
          _isJsInjected = false;
          if (url != null) _currentUrlController.add(url);
        },
        onUpdateVisitedHistory: (controller, url, __) {
          if (!_isJsInjected) _injectJs();
        },
      ),
    );
  }

  void _injectJs() {
    _isJsInjected = true;
    _controller.injectJavascriptFileFromAsset(
      assetFilePath:
          'packages/word_listenable_webview/web_assets/word_clickifier.js',
    );
  }
}
