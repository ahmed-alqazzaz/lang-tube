import 'package:floor/floor.dart';

import '../database/database.dart';
import '../entity/info_source_combo.dart';
import '../entity/subtitles_info.dart';
import '../entity/subtitles_source.dart';

@dao
abstract class SubtitlesSourceDao {
  // Insert methods
  @insert
  Future<void> add(DatabaseSubtitlesSource subtitlesSource);

  @insert
  Future<void> addInfo(DatabaseSubtitlesInfo subtitlesInfo);

  @transaction
  Future<void> addSourceAndInfo(
      String source, DatabaseSubtitlesInfo subtitlesInfo) async {
    final infoId = await addInfoIfNotPresent(subtitlesInfo);
    await add(DatabaseSubtitlesSource(infoId: infoId, subtitlesSource: source));
  }

  Future<void> addIfNotPresent(DatabaseSubtitlesSource subtitlesSource) async {
    final existingSubtitlesSource =
        await retrieveByInfoId(subtitlesSource.infoId);
    if (!existingSubtitlesSource.contains(subtitlesSource)) {
      await add(subtitlesSource);
    }
  }

  Future<int> addInfoIfNotPresent(DatabaseSubtitlesInfo subtitlesInfo) async {
    final subtitlesInfoList =
        await retrieveInfoByVideoId(subtitlesInfo.videoId);
    if (!subtitlesInfoList.contains(subtitlesInfo)) {
      await addInfo(subtitlesInfo);
    }
    // check equality if returns empty list
    return retrieveInfoByVideoId(subtitlesInfo.videoId).then(
      (value) => value
          .where(
              (insertedSubtitlesInfo) => insertedSubtitlesInfo == subtitlesInfo)
          .first
          .infoId!,
    );
  }

  // Retrieve methods
  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesInfoTable} WHERE ${SubtitlesDatabase.videoIdColumn} = :videoId ORDER BY ${SubtitlesDatabase.sourceCreatedAtColumn} ASC')
  Future<List<DatabaseSubtitlesInfo>> retrieveInfoByVideoId(String videoId);

  @Query('SELECT * FROM SubtitlesSourceAndInfoView  WHERE videoId = :videoId')
  Future<List<DatabaseSubtitlesSourceInfoCombo>>
      retrieveSubtitlesSourceAndInfoByVideoId(String videoId);

  @Query('SELECT * FROM SubtitlesSourceAndInfoView')
  Future<List<DatabaseSubtitlesSourceInfoCombo>>
      retrieveSubtitlesSourceAndInfo();

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesSourceTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<List<DatabaseSubtitlesSource>> retrieveByInfoId(int infoId);

  @Query('SELECT * FROM ${SubtitlesDatabase.subtitlesSourceTable}')
  Future<List<DatabaseSubtitlesSource>> retrieveAll();

  // Delete methods
  @Query('DELETE FROM ${SubtitlesDatabase.subtitlesSourceTable}')
  Future<void> deleteAll();

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesSourceTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<void> deleteByInfoId(int infoId);
}
