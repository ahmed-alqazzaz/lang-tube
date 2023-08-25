import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
final class LexiconEntry {
  final String linguisticElement;
  final String term;
  final String cefr;
  final String definition;
  final List<String> examples;
  final Widget media;

  const LexiconEntry({
    required this.linguisticElement,
    required this.term,
    required this.cefr,
    required this.definition,
    required this.examples,
    required this.media,
  });

  @override
  bool operator ==(covariant LexiconEntry other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.linguisticElement == linguisticElement &&
        other.term == term &&
        other.cefr == cefr &&
        other.definition == definition &&
        listEquals(other.examples, examples) &&
        other.media == media;
  }

  @override
  int get hashCode {
    return linguisticElement.hashCode ^
        term.hashCode ^
        cefr.hashCode ^
        definition.hashCode ^
        examples.hashCode ^
        media.hashCode;
  }

  LexiconEntry copyWith({
    String? linguisticElement,
    String? term,
    String? cefr,
    String? definition,
    List<String>? examples,
    Widget? media,
  }) {
    return LexiconEntry(
      linguisticElement: linguisticElement ?? this.linguisticElement,
      term: term ?? this.term,
      cefr: cefr ?? this.cefr,
      definition: definition ?? this.definition,
      examples: examples ?? this.examples,
      media: media ?? this.media,
    );
  }

  @override
  String toString() {
    return 'LexiconEntry(linguisticElement: $linguisticElement, term: $term, cefr: $cefr, definition: $definition, examples: $examples, media: $media)';
  }
}
