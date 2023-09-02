import 'package:flutter/material.dart';
import 'package:word_listenable_webview/extensions.dart';

typedef SpanHighlighter = void Function({
  required Color backgroundColor,
  required Color textColor,
});

@immutable
class ClickedWord {
  final String clickedWord;
  final Rect boundingRect;
  final SpanHighlighter highlight;
  final VoidCallback removeHighlight;
  const ClickedWord(
      {required this.clickedWord,
      required this.boundingRect,
      required this.highlight,
      required this.removeHighlight});

  @override
  String toString() =>
      'ClickedWord(clickedWord: $clickedWord, boundingRect: $boundingRect, highlight: $highlight)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clickedWord': clickedWord,
      'boundingRect': boundingRect.toMap(),
    };
  }

  factory ClickedWord.fromMap({
    required Map<String, dynamic> map,
    required SpanHighlighter highlight,
    required VoidCallback removeHighlight,
  }) {
    return ClickedWord(
      clickedWord: map['clickedWord'] as String,
      boundingRect:
          RectMapper.fromMap(map['boundingRect'] as Map<String, dynamic>),
      highlight: highlight,
      removeHighlight: removeHighlight,
    );
  }
}
