// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:floor/floor.dart';

import '../../../models/subtitles/captions_type.dart';
import '../database/database.dart';
import 'subtitles_info.dart';
import 'subtitles_source.dart';

@DatabaseView('''
  SELECT 
    ${SubtitlesDatabase.subtitlesSourceTable}.${SubtitlesDatabase.infoIdColumn} AS subtitlesSourceInfoId, 
    ${SubtitlesDatabase.subtitlesSourceTable}.${SubtitlesDatabase.subtitlesSourceColumn} AS subtitlesSource, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.infoIdColumn} AS infoId, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.videoIdColumn} AS videoId, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.languageColumn} AS language, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.captionsTypeColumn} AS captionsType, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.sourceCreatedAtColumn} AS createdAt 
  FROM ${SubtitlesDatabase.subtitlesSourceTable} 
  INNER JOIN ${SubtitlesDatabase.subtitlesInfoTable} 
  ON ${SubtitlesDatabase.subtitlesSourceTable}.${SubtitlesDatabase.infoIdColumn} = ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.infoIdColumn}
''', viewName: 'SubtitlesSourceAndInfoView')
class DatabaseSubtitlesSourceInfoCombo
    implements DatabaseSubtitlesInfo, DatabaseSubtitlesSource {
  final int subtitlesSourceInfoId;
  @override
  final String subtitlesSource;

  @override
  final int infoId;
  @override
  final String videoId;
  @override
  final String language;
  @override
  final CaptionsType captionsType;

  @override
  final DateTime? createdAt;

  DatabaseSubtitlesSourceInfoCombo({
    required this.subtitlesSourceInfoId,
    required this.subtitlesSource,
    required this.infoId,
    required this.videoId,
    required this.language,
    required this.captionsType,
    this.createdAt,
  });

  @override
  int? get id => throw 'Views have no ids';

  @override
  bool operator ==(covariant DatabaseSubtitlesSourceInfoCombo other) {
    if (identical(this, other)) return true;

    return other.subtitlesSourceInfoId == subtitlesSourceInfoId &&
        other.subtitlesSource == subtitlesSource &&
        other.infoId == infoId &&
        other.videoId == videoId &&
        other.language == language &&
        other.captionsType == captionsType &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return subtitlesSourceInfoId.hashCode ^
        subtitlesSource.hashCode ^
        infoId.hashCode ^
        videoId.hashCode ^
        language.hashCode ^
        captionsType.hashCode ^
        createdAt.hashCode;
  }
}
