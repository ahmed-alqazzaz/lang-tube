// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';
import 'subtitles_info.dart';

@immutable
@Entity(
  tableName: SubtitlesDatabase.subtitlesSourceTable,
  foreignKeys: [
    ForeignKey(
      childColumns: [SubtitlesDatabase.infoIdColumn],
      parentColumns: [SubtitlesDatabase.infoIdColumn],
      entity: DatabaseSubtitlesInfo,
    ),
  ],
)
final class DatebaseSubtitlesSource {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: SubtitlesDatabase.infoIdColumn)
  final int infoId;

  @ColumnInfo(name: SubtitlesDatabase.subtitlesSourceColumn)
  final String subtitlesSource;

  const DatebaseSubtitlesSource(
      {this.id, required this.infoId, required this.subtitlesSource});

  DatebaseSubtitlesSource copyWith({
    int? id,
    int? infoId,
    String? subtitlesSource,
  }) {
    return DatebaseSubtitlesSource(
      id: id ?? this.id,
      infoId: infoId ?? this.infoId,
      subtitlesSource: subtitlesSource ?? this.subtitlesSource,
    );
  }

  @override
  String toString() =>
      'SubtitlesSource(id: $id, infoId: $infoId, subtitlesSource: $subtitlesSource)';

  @override
  bool operator ==(covariant DatebaseSubtitlesSource other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.infoId == infoId &&
        other.subtitlesSource == subtitlesSource;
  }

  @override
  int get hashCode => id.hashCode ^ infoId.hashCode ^ subtitlesSource.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'infoId': infoId,
      'subtitlesSource': subtitlesSource,
    };
  }

  factory DatebaseSubtitlesSource.fromMap(Map<String, dynamic> map) {
    return DatebaseSubtitlesSource(
      id: map['id'] != null ? map['id'] as int : null,
      infoId: map['infoId'] as int,
      subtitlesSource: map['subtitlesSource'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DatebaseSubtitlesSource.fromJson(String source) =>
      DatebaseSubtitlesSource.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
