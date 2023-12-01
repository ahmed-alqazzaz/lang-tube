// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

@immutable
final class SubtitlesBundle {
  final ScrapedSubtitles mainSubtitles;
  final ScrapedSubtitles translatedSubtitles;
  const SubtitlesBundle({
    required this.mainSubtitles,
    required this.translatedSubtitles,
  });

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

  SubtitlesBundle copyWith({
    ScrapedSubtitles? mainSubtitles,
    ScrapedSubtitles? translatedSubtitles,
  }) {
    return SubtitlesBundle(
      mainSubtitles: mainSubtitles ?? this.mainSubtitles,
      translatedSubtitles: translatedSubtitles ?? this.translatedSubtitles,
    );
  }
}
