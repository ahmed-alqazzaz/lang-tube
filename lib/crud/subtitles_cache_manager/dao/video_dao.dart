import 'package:floor/floor.dart';
import '../database/database.dart';
import '../entity/video.dart';

@dao
abstract class VideoDao {
  @insert
  Future<void> add(DatabaseVideo video);

  @Query(
      'SELECT * FROM ${SubtitlesDatabase.videosTable} WHERE ${SubtitlesDatabase.videoIdColumn} = :videoId')
  Future<DatabaseVideo?> retrieveById(String videoId);

  @Query(
      'DELETE FROM ${SubtitlesDatabase.videosTable} WHERE ${SubtitlesDatabase.videoIdColumn} = :videoId')
  Future<void> deleteByIdd(String videoId);

  Future<void> addIfNotPresent(DatabaseVideo video) async {
    final existingVideo = await retrieveById(video.videoId);
    if (existingVideo == null) await add(video);
  }
}
