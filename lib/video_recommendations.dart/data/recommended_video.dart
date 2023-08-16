// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../utils/cefr.dart';
import '../difficulty_ranker/rust_api/rust_bridge.dart';

@immutable
class RecommendedVideo extends ObservedVideo {
  const RecommendedVideo({
    required super.onClick,
    required super.id,
    required super.title,
    required super.channelIconUrl,
    required super.thumbnailUrl,
    required super.badges,
    required super.sourceTab,
    required this.subtitlesComplexity,
    required this.syllablesPerMillisecond,
    required this.cefr,
  });
  final SubtitleComplexity subtitlesComplexity;
  final double syllablesPerMillisecond;
  final CEFR cefr;

  factory RecommendedVideo.fromObservedVideo({
    required ObservedVideo video,
    required SubtitleComplexity subtitlesComplexity,
    required double syllablesPerMillisecond,
    required CEFR cefr,
  }) =>
      RecommendedVideo(
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
      subtitlesComplexity: SubtitleComplexity.fromMap(
        map['subtitlesComplexity'] as Map<String, dynamic>,
      ),
      syllablesPerMillisecond: map['syllablesPerMillisecond'] as double,
      cefr: CEFR.a1,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecommendedVideo.fromJson(
          {required String source, required VideoClicker clicker}) =>
      RecommendedVideo.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
        clicker: clicker,
      );
}
