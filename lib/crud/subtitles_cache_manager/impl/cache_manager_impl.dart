import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import '../utils/model_mapper.dart';
import '../../../models/subtitles/cached_captions_info.dart';
import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_captions.dart';
import '../cache_manager.dart';
import '../database/database.dart';
import '../entity/subtitles_info.dart';
import '../entity/subtitles_source.dart';
import '../entity/video.dart';
import '../utils/db_info_matcher.dart';

@immutable
class CaptionsCacheManagerImpl implements CaptionsCacheManager {
  const CaptionsCacheManagerImpl(this._database);
  final SubtitlesDatabase _database;

  Future<void> cacheCaptions(CachedCaptions subtitles) async {
    await _database.videoDao
        .addIfNotPresent(DatabaseVideo(subtitles.info.videoId));
    await _database.subtitlesDao.addSubtitlesAndInfo(
      subtitles.subtitles.toJson(),
      DatabaseSubtitlesInfo(
        videoId: subtitles.info.videoId,
        language: subtitles.info.language?.name ?? 'unknown',
        captionsType: subtitles.info.type,
      ),
    );
  }

  Future<void> cacheSourceCaptions(CachedSourceCaptions captions) async {
    await _database.videoDao
        .addIfNotPresent(DatabaseVideo(captions.info.videoId));
    await _database.subtitlesSourceDao.addSourceAndInfo(
      captions.uri.toString(),
      DatabaseSubtitlesInfo(
        videoId: captions.info.videoId,
        language: captions.info.language?.name ?? 'unknown',
        captionsType: captions.info.type,
      ),
    );
  }

  Stream<CachedCaptions> retrieveSubtitles(
      {required String videoId, InfoFilter? filter}) async* {
    for (var captionsInfoCombo in await _database.subtitlesDao
        .retrieveSubtitlesAndInfoByVideoId(videoId)) {
      if (filter?.call(captionsInfoCombo) != true) continue;
      yield CachedCaptions(
        subtitles:
            ParsedSubtitlesJsonifier.fromJson(captionsInfoCombo.subtitles),
        info: CachedCaptionsInfo.fromDatabaseSourceInfo(captionsInfoCombo),
      );
    }
  }

  Stream<CachedSourceCaptions> retrieveSources(
      {String? videoId, InfoFilter? filter}) async* {
    final sourceInfoComboList = videoId != null
        ? await _database.subtitlesSourceDao
            .retrieveSubtitlesSourceAndInfoByVideoId(videoId)
        : await _database.subtitlesSourceDao.retrieveSubtitlesSourceAndInfo();
    for (var sourceInfoCombo in sourceInfoComboList) {
      if (filter?.call(sourceInfoCombo) != true) continue;
      yield CachedSourceCaptions(
        uri: Uri.parse(sourceInfoCombo.subtitlesSource),
        cacheCreationDate: sourceInfoCombo.createdAt,
        info: CachedCaptionsInfo.fromDatabaseSourceInfo(sourceInfoCombo),
      );
    }
  }

  Future<void> clearSources({String? videoId, InfoFilter? filter}) async {
    final sourceInfoComboList = videoId != null
        ? await _database.subtitlesSourceDao
            .retrieveSubtitlesSourceAndInfoByVideoId(videoId)
        : await _database.subtitlesSourceDao.retrieveSubtitlesSourceAndInfo();
    for (var sourceInfoCombo in sourceInfoComboList) {
      if (filter?.call(sourceInfoCombo) != true) continue;
      await _database.subtitlesSourceDao.deleteByInfoId(sourceInfoCombo.infoId);
    }
  }

  Future<void> clearCaptions(
      {required String videoId, InfoFilter? filter}) async {
    for (var captionsInfoCombo in await _database.subtitlesDao
        .retrieveSubtitlesAndInfoByVideoId(videoId)) {
      if (filter?.call(captionsInfoCombo) != true) continue;
      await _database.subtitlesDao.deleteByInfoId(captionsInfoCombo.infoId);
    }
  }

  Future<void> close() async => await _database.close();
}
