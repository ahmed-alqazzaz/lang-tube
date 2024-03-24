import 'package:floor/floor.dart';

import '../database/database.dart';
import '../entity/subtitles.dart';

@dao
abstract class SubtitlesDao {
  @insert
  Future<void> add(DatabaseSubtitles subtitles);

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.subtitlesTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<List<DatabaseSubtitles>> retrieveByInfoId(int infoId);

  @Query('SELECT * FROM ${SubtitlesDatabase.subtitlesTable}')
  Future<List<DatabaseSubtitles>> retrieveAll();

  @Query('DELETE FROM ${SubtitlesDatabase.subtitlesTable}')
  Future<void> deleteAll();

  @Query(
      'DELETE FROM ${SubtitlesDatabase.subtitlesTable} WHERE ${SubtitlesDatabase.infoIdColumn} = :infoId')
  Future<void> deleteByInfoId(int infoId);

  Future<void> addIfNotPresent(DatabaseSubtitles subtitles) async {
    final existingSubtitles = await retrieveByInfoId(subtitles.infoId);
    if (!existingSubtitles.contains(subtitles)) {
      await add(subtitles);
    }
  }
}
