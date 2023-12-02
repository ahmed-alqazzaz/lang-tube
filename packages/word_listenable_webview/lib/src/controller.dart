
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:word_listenable_webview/src/extensions.dart';

@immutable
final class WordListenableWebViewController {
  const WordListenableWebViewController(this._controller);
  final InAppWebViewController _controller;

  Future<void> removeAllHighlights() async =>
      await _controller.evaluateJavascript(source: 'removeAllHighlights()');

  Future<void> highlightWord({
    required String id,
    required Color backgroundColor,
    required Color textColor,
  }) async {
    await _controller.evaluateJavascript(
      source: """
        highglightWord(
         '$id',
         '${backgroundColor.toRgbaString()}', 
         '${textColor.toRgbaString()}', 
     ) """,
    );
  }

  Future<void> removeHighlight(String id) async =>
      await _controller.evaluateJavascript(source: "removeHighlight('$id')");

  Future<void> injectSpaceAtBottom({required int height}) async =>
      await _controller.evaluateJavascript(
          source: 'injectSpaceAtBottom($height)');

  Future<void> removeInjectedSpace() async =>
      await _controller.evaluateJavascript(source: 'removeInjectedSpace()');

  Future<num> get windowHeight async =>
      await _controller.evaluateJavascript(source: 'window.innerHeight');

  Future<num> get scrollHeight async => await _controller.evaluateJavascript(
        source: 'document.body.scrollHeight',
      );

  Future<num> get scrollOffset async =>
      ((await _controller.evaluateJavascript(source: 'window.scrollY')) as num)
          .ceil();

  Future<void> scroll(int scrollOffset) async =>
      await _controller.evaluateJavascript(
        source: 'scroll($scrollOffset)',
      );

  Future<bool> canGoBack() async => await _controller.canGoBack();

  Future<void> goBack() async => await _controller.goBack();

  Future<void> loadUrl(Uri url) async {
    await _controller.loadUrl(urlRequest: URLRequest(url: url));
  }

  Future<void> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) async {
    await _controller.injectJavascriptFileFromAsset(
      assetFilePath: assetFilePath,
    );
  }

  void disableScroll() {
    _controller.evaluateJavascript(source: """
            document.body.style.overflow = 'hidden';
            document.body.style.position = 'fixed';
        """);
  }

  void enableScroll() {
    _controller.evaluateJavascript(source: """
            document.body.style.overflow = 'auto';
            document.body.style.position = 'static';
        """);
  }

  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    _controller.addJavaScriptHandler(
      handlerName: handlerName,
      callback: callback,
    );
  }

  Future<void> reload() async => await _controller.reload();
}
