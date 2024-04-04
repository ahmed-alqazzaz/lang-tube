import 'package:floor/floor.dart';

import '../../../models/subtitles/captions_type.dart';
import '../database/database.dart';
import 'subtitles.dart';
import 'subtitles_info.dart';

@DatabaseView('''
  SELECT 
    ${SubtitlesDatabase.subtitlesTable}.${SubtitlesDatabase.infoIdColumn} AS subtitlesInfoId, 
    ${SubtitlesDatabase.subtitlesTable}.${SubtitlesDatabase.subtitlesColumn} AS subtitles, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.infoIdColumn} AS infoId, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.videoIdColumn} AS videoId, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.languageColumn} AS language, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.captionsTypeColumn} AS captionsType, 
    ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.sourceCreatedAtColumn} AS createdAt 
  FROM ${SubtitlesDatabase.subtitlesTable} 
  INNER JOIN ${SubtitlesDatabase.subtitlesInfoTable} 
  ON ${SubtitlesDatabase.subtitlesTable}.${SubtitlesDatabase.infoIdColumn} = ${SubtitlesDatabase.subtitlesInfoTable}.${SubtitlesDatabase.infoIdColumn}
''', viewName: 'SubtitlesAndInfoView')
class DatabaseSubtitlesAndInfoCombo
    implements DatabaseSubtitlesInfo, DatabaseSubtitles {
  final int subtitlesInfoId;

  @override
  final String subtitles;

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

  DatabaseSubtitlesAndInfoCombo({
    required this.subtitlesInfoId,
    required this.subtitles,
    required this.infoId,
    required this.videoId,
    required this.language,
    required this.captionsType,
    this.createdAt,
  });

  @override
  int? get id => throw 'Views have no ids';
}
