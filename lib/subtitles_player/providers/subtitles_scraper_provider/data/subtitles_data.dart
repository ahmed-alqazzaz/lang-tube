// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;

@immutable
final class SubtitlesData {
  final Iterable<subtitles_player.Subtitle> subtitles;
  final bool isAutoGenerated;
  const SubtitlesData({
    required this.subtitles,
    required this.isAutoGenerated,
  });

  SubtitlesData copyWith({
    List<subtitles_player.Subtitle>? subtitles,
    bool? isAutoGenerated,
  }) {
    return SubtitlesData(
      subtitles: subtitles ?? this.subtitles,
      isAutoGenerated: isAutoGenerated ?? this.isAutoGenerated,
    );
  }

  @override
  String toString() =>
      'Subtitlex(subtitles: $subtitles, isAutoGenerated: $isAutoGenerated)';

  @override
  bool operator ==(covariant SubtitlesData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.subtitles, subtitles) &&
        other.isAutoGenerated == isAutoGenerated;
  }

  @override
  int get hashCode => subtitles.hashCode ^ isAutoGenerated.hashCode;
}
