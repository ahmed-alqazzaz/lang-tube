import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:once/once.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:youtube_subtitles_scraper/src/utils/cache_expiration_manager.dart';
import 'package:youtube_subtitles_scraper/src/utils/language_filter.dart';
import 'package:youtube_subtitles_scraper/src/utils/sources_count_manager.dart';
import 'package:youtube_subtitles_scraper/src/youtube_explode_manager.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

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
    Once.runDaily(
      "YoutubeScraperMaintainanceKey",
      callback: () => cacheManager
        ..clearExpiredSources()
        ..limitSourcesCount(),
    );
  }

  final CacheManager _cacheManager;
  final SubtitlesScraperApiClient _apiClient;
  final YoutubeExplodeManager _youtubeExplodeManager;

  // in case translated language is provided,
  // the function will return a translated version
  // the main language subtitle
  Future<List<ScrapedCaptions>> scrapeSubtitles({
    required String youtubeVideoId,
    required List<Language> mainLanguages,
    Language? translatedLanguage,
    void Function(double)? onProgressUpdated,
  }) async {
    final progressList = <double>[];
    onProgressUpdated?.call(0.125);
    final sourceCaptions = await _youtubeExplodeManager
        .fetchAllCaptions(youtubeVideoId: youtubeVideoId)
        .then((captions) => captions.filteredByLanguage(mainLanguages));
    onProgressUpdated?.call(0.25);
    return await Future.wait(
      sourceCaptions.map(
        (captions) async {
          final progressIndex = progressList.length;
          progressList.add(0.25);
          return await _scrapeFromSourceCaptions(
            youtubeVideoId: youtubeVideoId,
            sourceCaptions: translatedLanguage == null
                ? captions
                : captions.autoTranslate(translatedLanguage),
            language: translatedLanguage ?? captions.info.language!,
            onProgressUpdated: (progress) {
              progressList[progressIndex] = 0.25 + progress * 0.75;
              onProgressUpdated?.call(progressList.average);
            },
          );
        },
      ),
    ).whenComplete(() => onProgressUpdated?.call(1.0));
  }

  Future<ScrapedCaptions> _scrapeFromSourceCaptions({
    required String youtubeVideoId,
    required SourceCaptions sourceCaptions,
    required Language language,
    void Function(double)? onProgressUpdated,
  }) async {
    final parsedSubtitles = await SubtitlesParser.parseSrv1(
      await _apiClient
          .fetchSubtitles(
            url: sourceCaptions.uri,
            onProgressUpdated: onProgressUpdated,
          )
          .whenComplete(
            () => _cacheManager.clearSources(
                videoId: youtubeVideoId, language: language.name),
          ),
    );
    if (parsedSubtitles
        .every((subtitle) => subtitle.text.replaceAll(" ", "").isEmpty)) {
      printRed("recursively fetching captions");
      try {
        return await Future.delayed(
          const Duration(seconds: 3),
          () async => await _scrapeFromSourceCaptions(
            youtubeVideoId: youtubeVideoId,
            sourceCaptions: sourceCaptions,
            language: language,
          ),
        );
      } catch (e, stackTrace) {
        print('An error occurred: $e');
        print(stackTrace);
        rethrow;
      }
    }
    onProgressUpdated?.call(1.0);
    printRed("returning parsedSubtitles");
    return ScrapedCaptions(
      subtitles: parsedSubtitles,
      info: CaptionsInfo(
        videoId: youtubeVideoId,
        isAutoGenerated: sourceCaptions.info.isAutoGenerated,
        language: language,
      ),
    );
  }

  Future<void> dispose() async => _youtubeExplodeManager.close();
}
