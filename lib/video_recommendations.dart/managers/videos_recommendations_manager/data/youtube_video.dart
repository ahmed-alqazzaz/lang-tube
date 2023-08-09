// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';
import 'package:lang_tube/youtube_scraper/data/youtube_video_item.dart';

import '../../../../utils/cefr.dart';

class YoutubeVideo {
  final YoutubeVideoItem item;
  final SubtitlesData subtitles;
  final CEFR cefrLevel;

  YoutubeVideo({
    required this.item,
    required this.subtitles,
    required this.cefrLevel,
  });

  YoutubeVideo copyWith({
    YoutubeVideoItem? item,
    SubtitlesData? subtitles,
    CEFR? cefrLevel,
  }) {
    return YoutubeVideo(
      item: item ?? this.item,
      subtitles: subtitles ?? this.subtitles,
      cefrLevel: cefrLevel ?? this.cefrLevel,
    );
  }

  @override
  String toString() =>
      'YoutubeVideo(item: $item, subtitles: $subtitles, cefrLevel: $cefrLevel)';

  @override
  bool operator ==(covariant YoutubeVideo other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.subtitles == subtitles &&
        other.cefrLevel == cefrLevel;
  }

  @override
  int get hashCode => item.hashCode ^ subtitles.hashCode ^ cefrLevel.hashCode;
}
