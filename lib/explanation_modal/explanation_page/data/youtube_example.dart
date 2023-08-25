// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

@immutable
class YoutubeExample {
  final String videoId;
  final Duration start;
  final Duration end;
  final String mainSubtitle;
  final String translatedSubtitle;
  const YoutubeExample({
    required this.videoId,
    required this.start,
    required this.end,
    required this.mainSubtitle,
    required this.translatedSubtitle,
  });
  YoutubeExample copyWith({
    String? videoId,
    Duration? start,
    Duration? end,
    String? mainSubtitle,
    String? translatedSubtitle,
  }) {
    return YoutubeExample(
      videoId: videoId ?? this.videoId,
      start: start ?? this.start,
      end: end ?? this.end,
      mainSubtitle: mainSubtitle ?? this.mainSubtitle,
      translatedSubtitle: translatedSubtitle ?? this.translatedSubtitle,
    );
  }

  @override
  String toString() {
    return 'YoutubeExample(videoId: $videoId, start: $start, end: $end, mainSubtitle: $mainSubtitle, translatedSubtitle: $translatedSubtitle)';
  }

  @override
  bool operator ==(covariant YoutubeExample other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId &&
        other.start == start &&
        other.end == end &&
        other.mainSubtitle == mainSubtitle &&
        other.translatedSubtitle == translatedSubtitle;
  }

  @override
  int get hashCode {
    return videoId.hashCode ^
        start.hashCode ^
        end.hashCode ^
        mainSubtitle.hashCode ^
        translatedSubtitle.hashCode;
  }
}
