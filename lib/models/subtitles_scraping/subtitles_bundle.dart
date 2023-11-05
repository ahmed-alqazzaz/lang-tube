// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

@immutable
final class SubtitlesBundle {
  final ScrapedSubtitles mainSubtitlesData;
  final ScrapedSubtitles translatedSubtitlesData;
  const SubtitlesBundle({
    required this.mainSubtitlesData,
    required this.translatedSubtitlesData,
  });

  @override
  String toString() =>
      'SubtitlesBundle(mainSubtitles: $mainSubtitlesData, translatedSubtitles: $translatedSubtitlesData)';

  @override
  bool operator ==(covariant SubtitlesBundle other) {
    if (identical(this, other)) return true;

    return other.mainSubtitlesData == mainSubtitlesData &&
        other.translatedSubtitlesData == translatedSubtitlesData;
  }

  @override
  int get hashCode =>
      mainSubtitlesData.hashCode ^ translatedSubtitlesData.hashCode;

  SubtitlesBundle copyWith({
    ScrapedSubtitles? mainSubtitles,
    ScrapedSubtitles? translatedSubtitles,
  }) {
    return SubtitlesBundle(
      mainSubtitlesData: mainSubtitles ?? mainSubtitlesData,
      translatedSubtitlesData: translatedSubtitles ?? translatedSubtitlesData,
    );
  }
}
