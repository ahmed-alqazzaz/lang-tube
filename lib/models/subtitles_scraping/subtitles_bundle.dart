// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';

@immutable
final class SubtitlesBundle {
  final SubtitlesData mainSubtitlesData;
  final SubtitlesData translatedSubtitlesData;
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
    SubtitlesData? mainSubtitles,
    SubtitlesData? translatedSubtitles,
  }) {
    return SubtitlesBundle(
      mainSubtitlesData: mainSubtitles ?? this.mainSubtitlesData,
      translatedSubtitlesData:
          translatedSubtitles ?? this.translatedSubtitlesData,
    );
  }
}
