// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:lang_tube/youtube_scraper/data/youtube_video_item.dart';

import '../../utils/cefr.dart';
import '../difficulty_ranker/rust_api/rust_bridge.dart';

@immutable
final class RecommendedVideo extends YoutubeVideoItem {
  const RecommendedVideo({
    required super.onClick,
    required super.videoId,
    required super.title,
    required super.channelIconUrl,
    required super.thumbnailUrl,
    required super.badges,
    required this.subtitlesComplexity,
    required this.syllablesPerMillisecond,
    required this.cefr,
    required super.sourceTab,
  });
  final SubtitleComplexity subtitlesComplexity;
  final double syllablesPerMillisecond;
  final CEFR cefr;

  factory RecommendedVideo.fromVideoItem({
    required YoutubeVideoItem item,
    required SubtitleComplexity subtitlesComplexity,
    required double syllablesPerMillisecond,
    required CEFR cefr,
  }) =>
      RecommendedVideo(
        title: item.title,
        videoId: item.videoId,
        badges: item.badges,
        cefr: cefr,
        channelIconUrl: item.channelIconUrl,
        onClick: item.click,
        subtitlesComplexity: subtitlesComplexity,
        syllablesPerMillisecond: syllablesPerMillisecond,
        thumbnailUrl: item.thumbnailUrl,
        sourceTab: item.sourceTab,
      );

  @override
  String toString() =>
      'RecommendedVideo(subtitlesComplexity: $subtitlesComplexity, syllablesPerMillisecond: $syllablesPerMillisecond, cefr: $cefr)';

  @override
  bool operator ==(covariant RecommendedVideo other) {
    if (identical(this, other)) return true;

    return other.subtitlesComplexity == subtitlesComplexity &&
        other.syllablesPerMillisecond == syllablesPerMillisecond &&
        other.cefr == cefr;
  }

  @override
  int get hashCode =>
      subtitlesComplexity.hashCode ^
      syllablesPerMillisecond.hashCode ^
      cefr.hashCode;
}
