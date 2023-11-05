import 'dart:async';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:unique_key_mutex/unique_key_mutex.dart';
import 'package:youtube_subtitles_scraper/src/utils/cache_expiration_manager.dart';
import 'package:youtube_subtitles_scraper/src/utils/cache_redundancy_manager.dart';
import 'package:youtube_subtitles_scraper/src/utils/sources_count_manager.dart';
import 'package:youtube_subtitles_scraper/src/youtube_explode_manager.dart';

import '../youtube_subtitles_scraper.dart';

@immutable
final class YoutubeSubtitlesScraper {
  YoutubeSubtitlesScraper({
    required CacheManager cacheManager,
    required SubtitlesScraperApiClient apiClient,
  })  : _apiClient = apiClient,
        _youtubeExplodeManager = YoutubeExplodeManager(
          cacheManager: cacheManager,
        ),
        _cacheManager = cacheManager {
    _cacheManager
        .deleteUnnecessarySources()
        .whenComplete(() => _cacheManager.clearExpiredSources(
              onSourcesDeleted: _onSourcesDeleted,
            ))
        .whenComplete(_cacheManager.deleteUnnecessarySources);
  }
  final CacheManager _cacheManager;
  final SubtitlesScraperApiClient _apiClient;
  final YoutubeExplodeManager _youtubeExplodeManager;

  // in case translated language is provided,
  // the function will return a translated version
  // the main language subtitle
  Future<List<ScrapedSubtitles>?> scrapeSubtitles({
    required String youtubeVideoId,
    required Language language,
    Language? translatedLanguage,
  }) async {
    Future<ScrapedSubtitles> scrape(SourceCaptions captions,
        [int recusrsionCount = 0]) async {
      try {
        return await _scrapeAndCacheSubtitles(
          youtubeVideoId: youtubeVideoId,
          sourceCaptions: translatedLanguage == null
              ? captions
              : captions.autoTranslate(translatedLanguage),
          language: translatedLanguage ?? language,
        );
      } on SubtitlesScraperBlockedRequestException {
        printRed('recursively scraping subs');
        if (recusrsionCount == 0) {
          return scrape(captions, recusrsionCount = recusrsionCount + 1);
        }
        rethrow;
      }
    }

    // check if cache exists
    final cacheSubtitles = await _cacheManager.retrieveSubtitles(
      videoId: youtubeVideoId,
      language: language.name,
    );
    if (cacheSubtitles != null) return cacheSubtitles.toList();

    // in case no cache found
    final sourceCaptions = await _youtubeExplodeManager.fetchSourceCaptions(
        youtubeVideoId: youtubeVideoId, language: language);
    final subtitles = await Future.wait(sourceCaptions.map(scrape));
    return subtitles.isEmpty ? null : subtitles;
  }

  // stream of the progress of the currently scraped subtitles where 0.0 < value < 1.0
  Stream<double> get activeProgress => _apiClient.activeProgress;

  Future<ScrapedSubtitles> _scrapeAndCacheSubtitles({
    required String youtubeVideoId,
    required SourceCaptions sourceCaptions,
    required Language language,
  }) async {
    final rawSubtitles =
        await _apiClient.fetchSubtitles(url: sourceCaptions.uri);
    final parsedSubtitles = await parseSubtitles(rawSubtitles);
    final scrapedSubtitles = ScrapedSubtitles(
      subtitles: parsedSubtitles,
      isAutoGenerated: sourceCaptions.isAutoGenerated,
      language: language.name,
      videoId: youtubeVideoId,
    );
    // await _cacheManager.cacheSubtitles(scrapedSubtitles);
    return scrapedSubtitles;
  }

  Future<void> _onSourcesDeleted(String videoId) async {
    final mutex = UniqueKeyMutex(key: "Source Deletion Mutex");
    try {
      await mutex.acquire();
      await Future.delayed(const Duration(seconds: 2));
      printPurple("text");
      await _youtubeExplodeManager.fetchAllCaptions(youtubeVideoId: videoId);
    } finally {
      mutex.release();
    }
  }

  Future<void> dispose() async {
    await _apiClient.close();
    _youtubeExplodeManager.close();
  }
}
