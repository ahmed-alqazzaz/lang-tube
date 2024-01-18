import 'dart:async';
import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:unique_key_mutex/unique_key_mutex.dart';
import 'package:youtube_subtitles_scraper/src/utils/cache_expiration_manager.dart';
import 'package:youtube_subtitles_scraper/src/utils/cache_redundancy_manager.dart';
import 'package:youtube_subtitles_scraper/src/youtube_explode_manager.dart';
import 'utils/language_filter.dart';
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
    required List<Language> mainLanguages,
    Language? translatedLanguage,
    void Function(double)? onProgressUpdated,
  }) async {
    final progressList = <double>[];
    Future<ScrapedSubtitles> scrape(SourceCaptions captions,
        [int recusrsionCount = 0]) async {
      try {
        final progressIndex = progressList.length;
        progressList.add(0.25);
        return await _scrapeAndCacheSubtitles(
          youtubeVideoId: youtubeVideoId,
          sourceCaptions: translatedLanguage == null
              ? captions
              : captions.autoTranslate(translatedLanguage),
          language: translatedLanguage ?? captions.language!,
          onProgressUpdated: (progress) {
            progressList[progressIndex] = 0.25 + progress * 0.75;
            onProgressUpdated?.call(progressList.average);
          },
        );
      } on SubtitlesScraperBlockedRequestException {
        printRed('recursively scraping subs');
        if (recusrsionCount == 0) {
          return scrape(captions, recusrsionCount + 1);
        }
        rethrow;
      }
    }

    onProgressUpdated?.call(0);
    // check if cache exists
    final cacheSubtitles = <ScrapedSubtitles>[];
    for (var i = 0;
        i < (translatedLanguage != null ? 1 : mainLanguages.length);
        i++) {
      cacheSubtitles.addAll(await _cacheManager.retrieveSubtitles(
        videoId: youtubeVideoId,
        language: (translatedLanguage ?? mainLanguages[i]).name,
      ));
    }

    if (cacheSubtitles.isNotEmpty) {
      onProgressUpdated?.call(1.0);
      return cacheSubtitles;
    }

    // in case no cache found
    final sourceCaptions = await _youtubeExplodeManager
        .fetchAllCaptions(youtubeVideoId: youtubeVideoId)
        .then((captions) => captions.filteredByLanguage(mainLanguages));
    onProgressUpdated?.call(0.25);
    final subtitles = await Future.wait(sourceCaptions.map(scrape));
    onProgressUpdated?.call(1.0);
    return subtitles.isEmpty ? null : subtitles;
  }

  Future<ScrapedSubtitles> _scrapeAndCacheSubtitles({
    required String youtubeVideoId,
    required SourceCaptions sourceCaptions,
    required Language language,
    void Function(double)? onProgressUpdated,
  }) async {
    printRed("fetching lang ${language}");
    final rawSubtitles = await _apiClient.fetchSubtitles(
        url: sourceCaptions.uri, onProgressUpdated: onProgressUpdated);
    final parsedSubtitles = await parseSubtitles(rawSubtitles);
    final scrapedSubtitles = ScrapedSubtitles(
      subtitles: parsedSubtitles,
      isAutoGenerated: sourceCaptions.isAutoGenerated,
      language: language.name,
      videoId: youtubeVideoId,
    );
    //await _cacheManager.cacheSubtitles(scrapedSubtitles);
    return scrapedSubtitles;
  }

  Future<void> _onSourcesDeleted(String videoId) async {
    final mutex = UniqueKeyMutex(key: "Source Deletion Mutex");
    try {
      await mutex.acquire();
      await _youtubeExplodeManager.fetchAllCaptions(youtubeVideoId: videoId);
    } finally {
      mutex.release();
    }
  }

  Future<void> dispose() async => _youtubeExplodeManager.close();
}
