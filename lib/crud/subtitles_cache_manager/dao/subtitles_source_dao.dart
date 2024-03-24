import 'package:floor/floor.dart';

import '../database/database.dart';
import '../entity/subtitles_source.dart';

@dao
abstract class SubtitlesSourceDao {
  @insert
  Future<void> add(DatebaseSubtitlesSource subtitlesSource);

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesSourceTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<List<DatebaseSubtitlesSource>> retrieveByInfoId(int infoId);
  @Query('SELECT * FROM ${SubtitlesDatabase.subtitlesSourceTable}')
  Future<List<DatebaseSubtitlesSource>> retrieveAll();

  @Query('DELETE FROM ${SubtitlesDatabase.subtitlesSourceTable}')
  Future<void> deleteAll();

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesSourceTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<void> deleteByInfoId(int infoId);

  Future<void> addIfNotPresent(DatebaseSubtitlesSource subtitlesSource) async {
    final existingSubtitlesSource =
        await retrieveByInfoId(subtitlesSource.infoId);
    if (!existingSubtitlesSource.contains(subtitlesSource)) {
      await add(subtitlesSource);
    }
  }
}
