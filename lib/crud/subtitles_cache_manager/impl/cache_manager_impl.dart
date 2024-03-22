import 'package:flutter/foundation.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/utils/model_mapper.dart';

import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../../models/subtitles/cached_captions_info.dart';
import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_subtitles.dart';
import '../../../models/subtitles/captions_type.dart';
import '../cache_manager.dart';
import '../database/database.dart';
import '../entity/subtitles.dart';
import '../entity/subtitles_info.dart';
import '../entity/subtitles_source.dart';
import '../entity/video.dart';

@immutable
class CaptionsCacheManagerImpl implements CaptionsCacheManager {
  const CaptionsCacheManagerImpl(this._database);
  final SubtitlesDatabase _database;

  Future<void> cacheCaptions(CachedSubtitles subtitles) async {
    await _database.videoDao.addIfNotPresent(Video(subtitles.info.videoId));
    final insertedInfoId = await _database.subtitlesInfoDao.addIfNotPresent(
      SubtitlesInfo(
        videoId: subtitles.info.videoId,
        language: subtitles.info.language?.name ?? 'unknown',
        captionsType: subtitles.info.type,
      ),
    );
    await _database.subtitlesDao.add(
      Subtitles(
        infoId: insertedInfoId,
        subtitles: subtitles.subtitles.toJson(),
      ),
    );
  }

  Future<void> cacheSourceCaptions(CachedSourceCaptions captions) async {
    await _database.videoDao.addIfNotPresent(Video(captions.info.videoId));
    final insertedInfoId = await _database.subtitlesInfoDao.addIfNotPresent(
      SubtitlesInfo(
        videoId: captions.info.videoId,
        language: captions.info.language?.name ?? 'unknown',
        captionsType: captions.info.type,
      ),
    );
    await _database.subtitlesSourceDao.add(
      SubtitlesSource(
        infoId: insertedInfoId,
        subtitlesSource: captions.uri.toString(),
      ),
    );
  }

  Future<Iterable<CachedSubtitles>> retrieveSubtitles(
      {String? videoId, String? language, CaptionsType? type}) async {
    List<CachedSubtitles> subtitlesList = [];
    for (var subtitles in await _database.subtitlesDao.retrieveAll()) {
      final subtitlesInfo =
          await _database.subtitlesInfoDao.retrieveByInfoId(subtitles.infoId);
      if ((videoId != null ? subtitlesInfo?.videoId == videoId : true) &&
          (language != null ? subtitlesInfo?.language == language : true) &&
          (type != null ? subtitlesInfo?.captionsType == type : true)) {
        subtitlesList.add(
          CachedSubtitles(
            subtitles: ParsedSubtitlesJsonifier.fromJson(subtitles.subtitles),
            info: CachedCaptionsInfo(
              videoId: subtitlesInfo!.videoId,
              type: subtitlesInfo.captionsType,
              language: LanguageFactory.fromName(subtitlesInfo.language),
            ),
          ),
        );
      }
    }
    return subtitlesList;
  }

  Future<Iterable<CachedSourceCaptions>> retrieveSources(
      {String? videoId, String? language, CaptionsType? type}) async {
    List<CachedSourceCaptions> sourceCaptionaList = [];
    for (var subtitlesSource
        in await _database.subtitlesSourceDao.retrieveAll()) {
      final sourceInfo = await _database.subtitlesInfoDao
          .retrieveByInfoId(subtitlesSource.infoId);
      if ((videoId != null ? sourceInfo?.videoId == videoId : true) &&
          (language != null ? sourceInfo?.language == language : true) &&
          (type != null ? sourceInfo?.captionsType == type : true)) {
        sourceCaptionaList.add(
          CachedSourceCaptions(
            uri: Uri.parse(subtitlesSource.subtitlesSource),
            info: CachedCaptionsInfo(
              videoId: sourceInfo!.videoId,
              type: sourceInfo.captionsType,
              language: LanguageFactory.fromName(sourceInfo.language),
            ),
            cacheCreationDate: sourceInfo.createdAt,
          ),
        );
      }
    }
    return sourceCaptionaList;
  }

  Future<void> clearSources(
      {String? videoId, String? language, CaptionsType? type}) async {
    if (type != null || language != null) assert(videoId != null);
    final subtitlesInfoList = await _database.subtitlesInfoDao
        .retrieveAll()
        .then(
          (subtitlesInfoList) => subtitlesInfoList.where(
            (subtitlesInfo) =>
                (videoId != null ? subtitlesInfo.videoId == videoId : true) &&
                (type != null ? subtitlesInfo.captionsType == type : true) &&
                (language != null ? subtitlesInfo.language == language : true),
          ),
        );
    for (var info in subtitlesInfoList) {
      await _database.subtitlesSourceDao.deleteByInfoId(info.infoId!);
    }
  }

  Future<void> clearCaptions(
      {String? videoId, String? language, CaptionsType? type}) async {
    if (type != null || language != null) assert(videoId != null);
    final subtitlesInfoList = await _database.subtitlesInfoDao
        .retrieveAll()
        .then(
          (subtitlesInfoList) => subtitlesInfoList.where(
            (subtitlesInfo) =>
                (videoId != null ? subtitlesInfo.videoId == videoId : true) &&
                (type != null ? subtitlesInfo.captionsType == type : true) &&
                (language != null ? subtitlesInfo.language == language : true),
          ),
        );
    for (var info in subtitlesInfoList) {
      await _database.subtitlesDao.deleteByInfoId(info.infoId!);
    }
  }

  Future<void> close() async => await _database.close();
}
