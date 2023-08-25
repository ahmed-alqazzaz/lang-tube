// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:readability/readability.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../utils/cefr.dart';

@immutable
class RecommendedVideo extends ObservedVideo {
  const RecommendedVideo({
    required super.onClick,
    required super.id,
    required super.duration,
    required super.title,
    required super.channelIconUrl,
    required super.thumbnailUrl,
    required super.badges,
    required super.sourceTab,
    required this.subtitlesComplexity,
    required this.syllablesPerMillisecond,
    required this.cefr,
  });
  final ReadabilityScore subtitlesComplexity;
  final double syllablesPerMillisecond;
  final CEFR cefr;

  factory RecommendedVideo.fromObservedVideo({
    required ObservedVideo video,
    required ReadabilityScore subtitlesComplexity,
    required double syllablesPerMillisecond,
    required CEFR cefr,
  }) =>
      RecommendedVideo(
        duration: video.duration,
        title: video.title,
        id: video.id,
        badges: video.badges,
        cefr: cefr,
        channelIconUrl: video.channelIconUrl,
        onClick: video.click,
        subtitlesComplexity: subtitlesComplexity,
        syllablesPerMillisecond: syllablesPerMillisecond,
        thumbnailUrl: video.thumbnailUrl,
        sourceTab: video.sourceTab,
      );

  @override
  String toString() =>
      'RecommendedVideo(videoId: $id, title: $title, channelIconUrl: $channelIconUrl, thumbnailUrl: $thumbnailUrl, sourceTab: $sourceTab, badges: $badges,  subtitlesComplexity: $subtitlesComplexity, syllablesPerMillisecond: $syllablesPerMillisecond, cefr: $cefr, duration: $duration)';

  @override
  bool operator ==(covariant RecommendedVideo other) {
    if (identical(this, other)) return true;

    return other.subtitlesComplexity == subtitlesComplexity &&
        other.syllablesPerMillisecond == syllablesPerMillisecond &&
        other.cefr == cefr &&
        other.id == id &&
        other.title == title &&
        other.channelIconUrl == channelIconUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.sourceTab == sourceTab &&
        other.duration == duration &&
        listEquals(other.badges, badges);
  }

  @override
  int get hashCode =>
      subtitlesComplexity.hashCode ^
      syllablesPerMillisecond.hashCode ^
      cefr.hashCode ^
      id.hashCode ^
      title.hashCode ^
      channelIconUrl.hashCode ^
      thumbnailUrl.hashCode ^
      sourceTab.hashCode ^
      badges.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subtitlesComplexity': subtitlesComplexity.toMap(),
      'syllablesPerMillisecond': syllablesPerMillisecond,
      'cefr': cefr.toString(),
    }..addAll(super.toMap());
  }

  factory RecommendedVideo.fromMap(
      {required Map<String, dynamic> map, required VideoClicker clicker}) {
    return RecommendedVideo.fromObservedVideo(
      video: ObservedVideo.fromMap(map: map, videoClicker: clicker),
      subtitlesComplexity: ReadabilityScore.fromMap(
        map['subtitlesComplexity'] as Map<String, dynamic>,
      ),
      syllablesPerMillisecond: map['syllablesPerMillisecond'] as double,
      cefr: CEFR.a1,
    );
  }
}
