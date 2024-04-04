import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'package:lang_tube/models/subtitles/captions_type.dart';

import '../database/database.dart';
import 'video.dart';

@immutable
@Entity(
  tableName: SubtitlesDatabase.subtitlesInfoTable,
  foreignKeys: [
    ForeignKey(
      childColumns: [SubtitlesDatabase.videoIdColumn],
      parentColumns: [SubtitlesDatabase.videoIdColumn],
      entity: DatabaseVideo,
    ),
  ],
  indices: [
    Index(
      value: [
        SubtitlesDatabase.videoIdColumn,
        SubtitlesDatabase.languageColumn,
        SubtitlesDatabase.captionsTypeColumn
      ],
      unique: true,
    ),
  ],
)
class DatabaseSubtitlesInfo {
  @PrimaryKey(autoGenerate: true)
  final int? infoId;

  final String videoId;
  final String language;
  final CaptionsType captionsType;
  final DateTime? createdAt;
  const DatabaseSubtitlesInfo({
    this.infoId,
    required this.videoId,
    required this.language,
    required this.captionsType,
    this.createdAt,
  });

  @override
  bool operator ==(covariant DatabaseSubtitlesInfo other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId &&
        other.language == language &&
        other.captionsType == captionsType;
  }

  @override
  int get hashCode {
    return infoId.hashCode ^
        videoId.hashCode ^
        language.hashCode ^
        captionsType.hashCode ^
        createdAt.hashCode;
  }
}
