// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/web_example.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/youtube_example.dart';

import 'lexicon_entry.dart';

@immutable
final class Lexicon {
  final List<LexiconEntry> entries;
  final List<WebExample> webExamples;
  final List<YoutubeExample> youtubeExamples;
  const Lexicon({
    required this.entries,
    required this.webExamples,
    required this.youtubeExamples,
  });

  Lexicon copyWith({
    List<LexiconEntry>? entries,
    List<WebExample>? webExamples,
    List<YoutubeExample>? youtubeExamples,
  }) {
    return Lexicon(
      entries: entries ?? this.entries,
      webExamples: webExamples ?? this.webExamples,
      youtubeExamples: youtubeExamples ?? this.youtubeExamples,
    );
  }

  @override
  String toString() =>
      'Lexicon(entries: $entries, webExamples: $webExamples, youtubeExamples: $youtubeExamples)';

  @override
  bool operator ==(covariant Lexicon other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.entries, entries) &&
        listEquals(other.webExamples, webExamples) &&
        listEquals(other.youtubeExamples, youtubeExamples);
  }

  @override
  int get hashCode =>
      entries.hashCode ^ webExamples.hashCode ^ youtubeExamples.hashCode;
}
