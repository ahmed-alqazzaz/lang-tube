// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';
import 'subtitles_info.dart';

@immutable
@Entity(
  tableName: SubtitlesDatabase.subtitlesTable,
  foreignKeys: [
    ForeignKey(
      childColumns: [SubtitlesDatabase.infoIdColumn],
      parentColumns: [SubtitlesDatabase.infoIdColumn],
      entity: DatabaseSubtitlesInfo,
    ),
  ],
)
final class DatabaseSubtitles {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: SubtitlesDatabase.infoIdColumn)
  final int infoId;

  @ColumnInfo(name: SubtitlesDatabase.subtitlesColumn)
  final String subtitles;

  const DatabaseSubtitles(
      {this.id, required this.infoId, required this.subtitles});

  @override
  bool operator ==(covariant DatabaseSubtitles other) {
    if (identical(this, other)) return true;

    return other.infoId == infoId && other.subtitles == subtitles;
  }

  @override
  int get hashCode => infoId.hashCode ^ subtitles.hashCode;

  @override
  String toString() => 'Subtitles(infoId: $infoId, subtitles: $subtitles)';

  DatabaseSubtitles copyWith({
    int? infoId,
    String? subtitles,
  }) {
    return DatabaseSubtitles(
      infoId: infoId ?? this.infoId,
      subtitles: subtitles ?? this.subtitles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'infoId': infoId,
      'subtitles': subtitles,
    };
  }

  factory DatabaseSubtitles.fromMap(Map<String, dynamic> map) {
    return DatabaseSubtitles(
      infoId: map['infoId'] as int,
      subtitles: map['subtitles'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DatabaseSubtitles.fromJson(String source) =>
      DatabaseSubtitles.fromMap(json.decode(source) as Map<String, dynamic>);
}
