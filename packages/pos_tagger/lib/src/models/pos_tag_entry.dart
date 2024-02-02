// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'pos_tag.dart';

@immutable
class PosTagEntry {
  final double probability;
  final PosTag tag;
  final String word;
  const PosTagEntry({
    required this.probability,
    required this.tag,
    required this.word,
  });

  PosTagEntry copyWith({
    double? probability,
    PosTag? tag,
    String? word,
  }) {
    return PosTagEntry(
      probability: probability ?? this.probability,
      tag: tag ?? this.tag,
      word: word ?? this.word,
    );
  }

  @override
  String toString() =>
      'PosTagEntry(probability: $probability, tag: $tag, word: $word)';

  @override
  bool operator ==(covariant PosTagEntry other) {
    if (identical(this, other)) return true;

    return other.probability == probability &&
        other.tag == tag &&
        other.word == word;
  }

  @override
  int get hashCode => probability.hashCode ^ tag.hashCode ^ word.hashCode;
}
