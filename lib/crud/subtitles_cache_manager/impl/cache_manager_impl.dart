import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/utils/model_mapper.dart';

import '../../../models/subtitles/cached_captions_info.dart';
import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_captions.dart';
import '../cache_manager.dart';
import '../database/database.dart';
import '../entity/subtitles.dart';
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
    final insertedInfoId = await _database.subtitlesInfoDao.addIfNotPresent(
      DatabaseSubtitlesInfo(
        videoId: subtitles.info.videoId,
        language: subtitles.info.language?.name ?? 'unknown',
        captionsType: subtitles.info.type,
      ),
    );
    printRed('insertedInfoId: $insertedInfoId');
    await _database.subtitlesDao.add(
      DatabaseSubtitles(
        infoId: insertedInfoId,
        subtitles: subtitles.subtitles.toJson(),
      ),
    );
  }

  Future<void> cacheSourceCaptions(CachedSourceCaptions captions) async {
    await _database.videoDao
        .addIfNotPresent(DatabaseVideo(captions.info.videoId));
    final insertedInfoId = await _database.subtitlesInfoDao.addIfNotPresent(
      DatabaseSubtitlesInfo(
        videoId: captions.info.videoId,
        language: captions.info.language?.name ?? 'unknown',
        captionsType: captions.info.type,
      ),
    );
    await _database.subtitlesSourceDao.add(
      DatebaseSubtitlesSource(
        infoId: insertedInfoId,
        subtitlesSource: captions.uri.toString(),
      ),
    );
  }

  Stream<CachedCaptions> retrieveSubtitles({InfoFilter? filter}) async* {
    for (var captions in await _database.subtitlesDao.retrieveAll()) {
      final sourceInfo =
          await _database.subtitlesInfoDao.retrieveByInfoId(captions.infoId);
      if (filter?.call(sourceInfo!) != true) continue;
      yield CachedCaptions(
        subtitles: ParsedSubtitlesJsonifier.fromJson(captions.subtitles),
        info: CachedCaptionsInfo.fromDatabaseSourceInfo(sourceInfo!),
      );
    }
  }

  Stream<CachedSourceCaptions> retrieveSources({InfoFilter? filter}) async* {
    for (var source in await _database.subtitlesSourceDao.retrieveAll()) {
      final sourceInfo =
          await _database.subtitlesInfoDao.retrieveByInfoId(source.infoId);
      if (filter?.call(sourceInfo!) != true) continue;
      yield CachedSourceCaptions(
        uri: Uri.parse(source.subtitlesSource),
        cacheCreationDate: sourceInfo!.createdAt,
        info: CachedCaptionsInfo.fromDatabaseSourceInfo(sourceInfo),
      );
    }
  }

  Future<void> clearSources({InfoFilter? filter}) async {
    for (var source in await _database.subtitlesSourceDao.retrieveAll()) {
      final sourceInfo =
          await _database.subtitlesInfoDao.retrieveByInfoId(source.infoId);
      if (filter?.call(sourceInfo!) != true) continue;
      await _database.subtitlesSourceDao.deleteByInfoId(source.infoId);
    }
  }

  Future<void> clearCaptions({InfoFilter? filter}) async {
    for (var captions in await _database.subtitlesDao.retrieveAll()) {
      final sourceInfo =
          await _database.subtitlesInfoDao.retrieveByInfoId(captions.infoId);
      if (filter?.call(sourceInfo!) != true) continue;
      await _database.subtitlesDao.deleteByInfoId(captions.infoId);
    }
  }

  Future<void> close() async => await _database.close();
}
