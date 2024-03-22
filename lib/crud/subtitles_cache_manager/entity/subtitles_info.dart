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
      entity: Video,
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
final class SubtitlesInfo {
  @PrimaryKey(autoGenerate: true)
  final int? infoId;

  final String videoId;
  final String language;
  final CaptionsType captionsType;
  final DateTime? createdAt;
  const SubtitlesInfo({
    this.infoId,
    required this.videoId,
    required this.language,
    required this.captionsType,
    this.createdAt,
  });

  SubtitlesInfo copyWith({
    int? infoId,
    String? videoId,
    String? language,
    CaptionsType? captionsType,
    DateTime? createdAt,
  }) {
    return SubtitlesInfo(
      infoId: infoId ?? this.infoId,
      videoId: videoId ?? this.videoId,
      language: language ?? this.language,
      captionsType: captionsType ?? this.captionsType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SubtitlesInfo(infoId: $infoId, videoId: $videoId, language: $language, captionsType: $captionsType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant SubtitlesInfo other) {
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
