// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

@immutable
final class HistoryWordItem {
  final String word;
  final String translation;
  final Widget media;

  const HistoryWordItem({
    required this.word,
    required this.translation,
    required this.media,
  });

  HistoryWordItem copyWith({
    String? word,
    String? translation,
    Widget? media,
  }) {
    return HistoryWordItem(
      word: word ?? this.word,
      translation: translation ?? this.translation,
      media: media ?? this.media,
    );
  }

  @override
  String toString() =>
      'HistoryWordItem(word: $word, translation: $translation, media: $media)';

  @override
  bool operator ==(covariant HistoryWordItem other) {
    if (identical(this, other)) return true;

    return other.word == word &&
        other.translation == translation &&
        other.media == media;
  }

  @override
  int get hashCode => word.hashCode ^ translation.hashCode ^ media.hashCode;
}
