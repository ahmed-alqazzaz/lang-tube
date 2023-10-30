import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart'
    as subtitles_scraper;
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import 'database_manager/data/cached_subtitle.dart';
import 'database_manager/data/cached_source_captions.dart';
import 'database_manager/data/constants.dart';
import 'database_manager/manager.dart';

@immutable
final class SubtitlesCacheManager implements subtitles_scraper.CacheManager {
  const SubtitlesCacheManager._(this._dbManager);
  final SubtitlesDbManager _dbManager;

  static Future<SubtitlesCacheManager> open() async {
    final cacheDirectory = await getTemporaryDirectory();

    return SubtitlesCacheManager._(
      await SubtitlesDbManager.open('${cacheDirectory.path}$subtitlesDbName'),
    );
  }

  @override
  Future<Iterable<CachedSubtitles>?> retrieveSubtitles(
          {required String videoId, required String language}) async =>
      await _dbManager
          .retrieveSubtitles(videoId: videoId, language: language)
          .then((subtitles) => subtitles.isNotEmpty ? subtitles : null);

  @override
  Future<void> cacheSubtitles({
    required String subtitles,
    required String videoId,
    required String language,
    required bool isSubtitlesAutoGenerated,
  }) async {
    await _dbManager.addVideoIdIfNotPresent(videoId);
    final subtitlesInfoId = await _dbManager.insertSubtitlesInfoIfNotPresent(
      videoId: videoId,
      language: language,
      isAutoGenerated: isSubtitlesAutoGenerated,
    );
    await _dbManager.insertSubtitles(
      subtitles: subtitles,
      subtitlesInfoId: subtitlesInfoId,
    );
  }

  @override
  Future<void> clearSubtitlesCache() => _dbManager.deleteAllSubtitles();

  Future<void> close() async => await _dbManager.close();

  @override
  Future<void> cacheSources(
      {required String videoId,
      required List<SourceCaptions> sourceCaptions}) async {
    await _dbManager.addVideoIdIfNotPresent(videoId);
    for (final caption in sourceCaptions) {
      final subtitlesInfoId = await _dbManager.insertSubtitlesInfoIfNotPresent(
        videoId: videoId,
        language: caption.language?.name ?? 'unknown',
        isAutoGenerated: caption.isAutoGenerated,
      );
      await _dbManager.insertSubtitlesSource(
        subtitlesSource: caption.uri.toString(),
        subtitlesInfoId: subtitlesInfoId,
      );
    }
  }

  @override
  Future<Iterable<CachedSourceCaptions>?> retrieveSources(
          {required String videoId}) async =>
      await retrieveAllSources().then(
        (subtitlesSources) async {
          subtitlesSources =
              subtitlesSources?.where((source) => source.videoId == videoId);
          return subtitlesSources?.isNotEmpty == true
              ? subtitlesSources!
              : null;
        },
      );

  @override
  Future<void> clearSourcesById({required String videoId}) async =>
      await _dbManager.deleteSubtitlesSources(videoId: videoId);

  @override
  Future<Iterable<CachedSourceCaptions>?> retrieveAllSources() {
    return _dbManager.retrieveAllSources().then(
          (sources) => sources.isEmpty ? null : sources,
        );
  }
}
