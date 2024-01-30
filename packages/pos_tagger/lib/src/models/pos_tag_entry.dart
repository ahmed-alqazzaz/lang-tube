import 'package:flutter/foundation.dart';
import 'pos_tag.dart';

@immutable
class PosTagEntry {
  final PosTag tag;
  final String word;
  const PosTagEntry({required this.tag, required this.word});

  @override
  String toString() => 'PosTagEntry(tag: $tag, word: $word)';

  PosTagEntry copyWith({
    PosTag? tag,
    String? word,
  }) {
    return PosTagEntry(
      tag: tag ?? this.tag,
      word: word ?? this.word,
    );
  }

  @override
  bool operator ==(covariant PosTagEntry other) {
    if (identical(this, other)) return true;

    return other.tag == tag && other.word == word;
  }

  @override
  int get hashCode => tag.hashCode ^ word.hashCode;
}
