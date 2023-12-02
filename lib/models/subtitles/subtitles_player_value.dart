// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'consumable_subtitles.dart';

@immutable
final class SubtitlesPlayerValue {
  final int index;
  final ConsumableSubtitles currentSubtitles;
  final List<ConsumableSubtitles> subtitles;

  const SubtitlesPlayerValue({
    required this.currentSubtitles,
    required this.subtitles,
    required this.index,
  });

  SubtitlesPlayerValue copyWith({
    ConsumableSubtitles? currentSubtitles,
    List<ConsumableSubtitles>? subtitles,
    int? index,
  }) =>
      SubtitlesPlayerValue(
        currentSubtitles: currentSubtitles ?? this.currentSubtitles,
        subtitles: subtitles ?? this.subtitles,
        index: index ?? this.index,
      );

  @override
  bool operator ==(covariant SubtitlesPlayerValue other) {
    if (identical(this, other)) return true;

    return other.currentSubtitles == currentSubtitles &&
        listEquals(other.subtitles, subtitles);
  }

  @override
  int get hashCode => currentSubtitles.hashCode ^ subtitles.hashCode;

  @override
  String toString() =>
      'SubtitlesPlayerValue(currentSubtitles: $currentSubtitles, subtitles: $subtitles)';
}
