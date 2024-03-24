// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

@immutable
@Entity(tableName: SubtitlesDatabase.videosTable)
final class DatabaseVideo {
  @ColumnInfo(name: SubtitlesDatabase.videoIdColumn)
  @PrimaryKey()
  final String videoId;

  const DatabaseVideo(this.videoId);

  @override
  bool operator ==(covariant DatabaseVideo other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId;
  }

  @override
  int get hashCode => videoId.hashCode;

  @override
  String toString() => 'Video(videoId: $videoId)';

  DatabaseVideo copyWith({
    String? videoId,
  }) {
    return DatabaseVideo(
      videoId ?? this.videoId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoId': videoId,
    };
  }

  factory DatabaseVideo.fromMap(Map<String, dynamic> map) {
    return DatabaseVideo(
      map['videoId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DatabaseVideo.fromJson(String source) =>
      DatabaseVideo.fromMap(json.decode(source) as Map<String, dynamic>);
}
