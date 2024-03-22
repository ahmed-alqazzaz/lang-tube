import 'package:floor/floor.dart';

import '../database/database.dart';
import '../entity/subtitles_info.dart';

@dao
abstract class SubtitlesInfoDao {
  @insert
  Future<void> add(SubtitlesInfo subtitlesInfo);

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesInfoTable} ORDER BY ${SubtitlesDatabase.sourceCreatedAtColumn} ASC')
  Future<List<SubtitlesInfo>> retrieveAll();

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesInfoTable} WHERE ${SubtitlesDatabase.videoIdColumn} = :videoId ORDER BY ${SubtitlesDatabase.sourceCreatedAtColumn} ASC')
  Future<List<SubtitlesInfo>> retrieveByVideoId(String videoId);

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesInfoTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId ORDER BY ${SubtitlesDatabase.sourceCreatedAtColumn} ASC')
  Future<SubtitlesInfo?> retrieveByInfoId(int infoId);

  @Query('DELETE FROM ${SubtitlesDatabase.subtitlesInfoTable}')
  Future<void> deleteAll();

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesInfoTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<void> deleteByInfoId(int infoId);

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesInfoTable} WHERE ${SubtitlesDatabase.videoIdColumn} = :videoId')
  Future<void> deleteByVideoId(String videoId);

  Future<int> addIfNotPresent(SubtitlesInfo subtitlesInfo) async {
    final subtitlesInfoList = await retrieveByVideoId(subtitlesInfo.videoId);
    if (!subtitlesInfoList.contains(subtitlesInfo)) await add(subtitlesInfo);
    return retrieveByVideoId(subtitlesInfo.videoId).then(
      (value) => value
          .where(
              (insertedSubtitlesInfo) => insertedSubtitlesInfo == subtitlesInfo)
          .first
          .infoId!,
    );
  }
}
