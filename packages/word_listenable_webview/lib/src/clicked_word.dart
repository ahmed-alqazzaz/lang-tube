// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:word_listenable_webview/src/extensions.dart';

typedef SpanHighlighter = void Function({
  required Color backgroundColor,
  required Color textColor,
});

@immutable
class ClickedWord {
  final String word;
  final Rect boundingRect;
  final SpanHighlighter highlight;
  final VoidCallback removeHighlight;
  const ClickedWord({
    required this.word,
    required this.boundingRect,
    required this.highlight,
    required this.removeHighlight,
  });

  @override
  String toString() =>
      'ClickedWord(clickedWord: $word, boundingRect: $boundingRect, highlight: $highlight)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
      'boundingRect': boundingRect.toMap(),
    };
  }

  factory ClickedWord.fromMap({
    required Map<String, dynamic> map,
    required SpanHighlighter highlight,
    required VoidCallback removeHighlight,
  }) {
    return ClickedWord(
      word: map['word'] as String,
      boundingRect:
          RectMapper.fromMap(map['boundingRect'] as Map<String, dynamic>),
      highlight: highlight,
      removeHighlight: removeHighlight,
    );
  }

  @override
  bool operator ==(covariant ClickedWord other) {
    if (identical(this, other)) return true;

    return other.word == word &&
        other.boundingRect == boundingRect &&
        other.highlight == highlight &&
        other.removeHighlight == removeHighlight;
  }

  @override
  int get hashCode {
    return word.hashCode ^
        boundingRect.hashCode ^
        highlight.hashCode ^
        removeHighlight.hashCode;
  }

  ClickedWord copyWith({
    String? word,
    Rect? boundingRect,
    SpanHighlighter? highlight,
    VoidCallback? removeHighlight,
  }) {
    return ClickedWord(
      word: word ?? this.word,
      boundingRect: boundingRect ?? this.boundingRect,
      highlight: highlight ?? this.highlight,
      removeHighlight: removeHighlight ?? this.removeHighlight,
    );
  }
}
