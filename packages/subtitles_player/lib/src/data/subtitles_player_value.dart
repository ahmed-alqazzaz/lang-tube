import 'dart:convert';

import 'package:flutter/material.dart';

import 'subtitle.dart';

@immutable
class SubtitlesPlayerValue {
  final Subtitle? currentSubtitle;
  final Subtitle? previousSubtitle;
  final Subtitle? followingSubtitle;
  const SubtitlesPlayerValue({
    this.currentSubtitle,
    this.previousSubtitle,
    this.followingSubtitle,
  });

  SubtitlesPlayerValue copyWith({
    Subtitle? currentSubtitle,
    Subtitle? previousSubtitle,
    Subtitle? followingSubtitle,
  }) {
    return SubtitlesPlayerValue(
      currentSubtitle: currentSubtitle ?? this.currentSubtitle,
      previousSubtitle: previousSubtitle ?? this.previousSubtitle,
      followingSubtitle: followingSubtitle ?? this.followingSubtitle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentSubtitle': currentSubtitle?.toMap(),
      'previousSubtitle': previousSubtitle?.toMap(),
      'followingSubtitle': followingSubtitle?.toMap(),
    };
  }

  factory SubtitlesPlayerValue.fromMap(Map<String, dynamic> map) {
    return SubtitlesPlayerValue(
      currentSubtitle: map['currentSubtitle'] != null
          ? Subtitle.fromMap(map['currentSubtitle'] as Map<String, dynamic>)
          : null,
      previousSubtitle: map['previousSubtitle'] != null
          ? Subtitle.fromMap(map['previousSubtitle'] as Map<String, dynamic>)
          : null,
      followingSubtitle: map['followingSubtitle'] != null
          ? Subtitle.fromMap(map['followingSubtitle'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubtitlesPlayerValue.fromJson(String source) =>
      SubtitlesPlayerValue.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SubtitlesPlayerValue(currentSubtitle: $currentSubtitle, previousSubtitle: $previousSubtitle, followingSubtitle: $followingSubtitle)';

  @override
  bool operator ==(covariant SubtitlesPlayerValue other) {
    if (identical(this, other)) return true;

    return other.currentSubtitle == currentSubtitle &&
        other.previousSubtitle == previousSubtitle &&
        other.followingSubtitle == followingSubtitle;
  }

  @override
  int get hashCode =>
      currentSubtitle.hashCode ^
      previousSubtitle.hashCode ^
      followingSubtitle.hashCode;
}
