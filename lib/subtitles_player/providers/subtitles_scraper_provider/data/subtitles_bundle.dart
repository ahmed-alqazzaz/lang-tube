// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';

@immutable
final class SubtitlesBundle {
  final Iterable<SubtitlesData> mainSubtitles;
  final Iterable<SubtitlesData> translatedSubtitles;
  const SubtitlesBundle({
    required this.mainSubtitles,
    required this.translatedSubtitles,
  });

  SubtitlesBundle copyWith({
    Iterable<SubtitlesData>? mainSubtitles,
    Iterable<SubtitlesData>? translatedSubtitles,
  }) {
    return SubtitlesBundle(
      mainSubtitles: mainSubtitles ?? this.mainSubtitles,
      translatedSubtitles: translatedSubtitles ?? this.translatedSubtitles,
    );
  }

  @override
  String toString() =>
      'SubtitlesBundle(mainSubtitles: $mainSubtitles, translatedSubtitles: $translatedSubtitles)';

  @override
  bool operator ==(covariant SubtitlesBundle other) {
    if (identical(this, other)) return true;

    return other.mainSubtitles == mainSubtitles &&
        other.translatedSubtitles == translatedSubtitles;
  }

  @override
  int get hashCode => mainSubtitles.hashCode ^ translatedSubtitles.hashCode;
}
