import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_cache_manager/database_manager.dart/data/constants.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_cache_manager/database_manager.dart/database_manager.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/data/data_classes.dart';
import 'package:path_provider/path_provider.dart';

@immutable
class SubtitlesCacheManager {
  const SubtitlesCacheManager._(this._dbManager);
  final SubtitlesDbManager _dbManager;

  static Future<SubtitlesCacheManager> open() async {
    final cacheDirectory = await getTemporaryDirectory();
    return SubtitlesCacheManager._(
      await SubtitlesDbManager.open('${cacheDirectory.path}$subtitlesDbName'),
    );
  }

  Future<void> cacheSubtitles({
    required SubtitlesEntry subtitleEntryy,
  }) async {
    await _dbManager.addSubtitles(subtitleEntryy);
  }

  Future<SubtitlesBundle?> retrieveSubtitlesIfExists({
    required String videoId,
    required ({String mainLanguage, String translatedLanguage}) languages,
  }) async {
    return await _dbManager.retrieveSubtitles(
      videoId: videoId,
      languages: languages,
    );
  }
}
