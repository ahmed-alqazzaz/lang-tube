import 'package:floor/floor.dart';

import '../database/database.dart';
import '../entity/info_subtitles_combo.dart';
import '../entity/subtitles.dart';
import '../entity/subtitles_info.dart';

@dao
abstract class SubtitlesDao {
  // Insert methods
  @insert
  Future<void> add(DatabaseSubtitles subtitles);

  @insert
  Future<void> addInfo(DatabaseSubtitlesInfo subtitlesInfo);

  Future<void> addSubtitlesAndInfo(
      String subtitles, DatabaseSubtitlesInfo subtitlesInfo) async {
    final infoId = await addInfoIfNotPresent(subtitlesInfo);
    await add(DatabaseSubtitles(infoId: infoId, subtitles: subtitles));
  }

  Future<void> addIfNotPresent(DatabaseSubtitles subtitles) async {
    final existingSubtitles = await retrieveByInfoId(subtitles.infoId);
    if (!existingSubtitles.contains(subtitles)) {
      await add(subtitles);
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

  @Query('SELECT * FROM SubtitlesAndInfoView WHERE videoId = :videoId')
  Future<List<DatabaseSubtitlesAndInfoCombo>> retrieveSubtitlesAndInfoByVideoId(
    String videoId,
  );

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<List<DatabaseSubtitles>> retrieveByInfoId(int infoId);

  @Query('SELECT * FROM ${SubtitlesDatabase.subtitlesTable}')
  Future<List<DatabaseSubtitles>> retrieveAll();

  // Delete methods
  @Query('DELETE FROM ${SubtitlesDatabase.subtitlesTable}')
  Future<void> deleteAll();

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<void> deleteByInfoId(int infoId);
}
