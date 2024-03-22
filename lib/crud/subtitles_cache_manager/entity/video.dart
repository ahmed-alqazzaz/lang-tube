// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

@immutable
@Entity(tableName: SubtitlesDatabase.videosTable)
final class Video {
  @ColumnInfo(name: SubtitlesDatabase.videoIdColumn)
  @PrimaryKey()
  final String videoId;

  const Video(this.videoId);

  @override
  bool operator ==(covariant Video other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId;
  }

  @override
  int get hashCode => videoId.hashCode;

  @override
  String toString() => 'Video(videoId: $videoId)';

  Video copyWith({
    String? videoId,
  }) {
    return Video(
      videoId ?? this.videoId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoId': videoId,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      map['videoId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);
}
