import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/iterables.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../crud/subtitles_cache_manager/impl/user_uploaded_cache_manager.dart';
import '../../crud/subtitles_cache_manager/impl/youtube_cache_manager.dart';
import '../../models/subtitles/subtitles_bundle.dart';
import 'captions_scraper_client_provider.dart';
import '../shared/language_config_provider.dart';
import '../captions_cache/user_captions_cache_provider.dart';
import '../captions_cache/youtube_cache_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ProviderContainer container = ProviderContainer();
  print('acquiring scraper');

  await Future.delayed(const Duration(seconds: 1));
  final scraper = await container.read(captionsScraperProvider.future);
  container.read(languageConfigProvider.notifier)
    ..setTargetLanguage(Language.english)
    ..setTranslationLanguage(Language.german);
  final x = Stopwatch()..start();
  print('acquired scraper');
  await scraper.fetchSubtitlesBundle(
    youtubeVideoId: '8fEEbKJoNbU',
    onProgressUpdated: (p0) {
      print('1: $p0');
    },
  );

  printRed('finnished in ${x.elapsedMilliseconds}');
}

final captionsScraperProvider = FutureProvider((ref) async {
  final langConfig = await ref.watch(languageConfigProvider.future);
  return CaptionsScraper(
    rawScraper: YoutubeSubtitlesScraper(
      cacheManager: await ref.watch(youtubeCaptionsCacheManagerProvider.future),
      apiClient: await ref.watch(captionsScraperApiClientProvider.future),
    ),
    targetLanguages: [
      langConfig.targetLanguage!,
      ...langConfig.targetLanguage!.variants
    ],
    translatedLanguage: langConfig.translationLanguage!,
    userCacheManager:
        await ref.watch(userUploadedCaptionsCacheManagerProvider.future),
    youtubeCacheManager:
        await ref.watch(youtubeCaptionsCacheManagerProvider.future),
  );
});

@immutable
final class CaptionsScraper {
  const CaptionsScraper({
    required YoutubeSubtitlesScraper rawScraper,
    required List<Language> targetLanguages,
    required Language translatedLanguage,
    required UserUploadedCaptionsCacheManager userCacheManager,
    required YouTubeCaptionsCacheManager youtubeCacheManager,
  })  : _rawScraper = rawScraper,
        _targetLanguages = targetLanguages,
        _translatedLanguage = translatedLanguage,
        _userCacheManager = userCacheManager,
        _youtubeCacheManager = youtubeCacheManager;

  final List<Language> _targetLanguages;
  final Language _translatedLanguage;
  final YouTubeCaptionsCacheManager _youtubeCacheManager;
  final UserUploadedCaptionsCacheManager _userCacheManager;
  final YoutubeSubtitlesScraper _rawScraper;

  // Function to fetch and process subtitles for a YouTube video in different languages.
  Future<Iterable<CaptionsBundle>> fetchSubtitlesBundle({
    required String youtubeVideoId,
    void Function(double)? onProgressUpdated,
  }) async {
    final progressList = <double>[0.0, 0.0];
    final captionsPair = await Future.wait<Iterable<ScrapedCaptions>>(
      [
        scrapeTargetLanguages(
          youtubeVideoId: youtubeVideoId,
          onProgressUpdated: (p0) {
            progressList[0] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        ),
        scrapeTranslatedLanguage(
          youtubeVideoId: youtubeVideoId,
          onProgressUpdated: (p0) {
            progressList[1] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        ),
      ],
      eagerError: true,
    );
    return zip(captionsPair).map(
      (pair) => CaptionsBundle(
        mainSubtitles: pair.first,
        translatedSubtitles: pair.last,
      ),
    );
  }

  Future<List<ScrapedCaptions>> scrapeTargetLanguages({
    required String youtubeVideoId,
    void Function(double)? onProgressUpdated,
  }) =>
      _scrape(
        youtubeVideoId: youtubeVideoId,
        onProgressUpdated: onProgressUpdated,
        target: _ScrapeTarget.target,
      );

  Future<List<ScrapedCaptions>> scrapeTranslatedLanguage({
    required String youtubeVideoId,
    void Function(double)? onProgressUpdated,
  }) =>
      _scrape(
        youtubeVideoId: youtubeVideoId,
        onProgressUpdated: onProgressUpdated,
        target: _ScrapeTarget.translated,
      );

  Future<List<ScrapedCaptions>> _scrape({
    required String youtubeVideoId,
    void Function(double)? onProgressUpdated,
    _ScrapeTarget target = _ScrapeTarget.target,
  }) async {
    final languages = target == _ScrapeTarget.target
        ? [..._targetLanguages]
        : [_translatedLanguage];
    final userUploadedCaptions =
        _userCacheManager.retrieveSubtitles(videoId: youtubeVideoId).then(
              (captionsList) => captionsList.where(
                  (captions) => languages.contains(captions.info.language)),
            );

    final youtubeCachedCaption =
        await _youtubeCacheManager.retrieveSubtitles(videoId: youtubeVideoId);

    final youtubeCachedCaptions = youtubeCachedCaption
        .where((captions) => languages.contains(captions.info.language));
    // if (youtubeCachedCaptions.isNotEmpty) {
    //   return [...youtubeCachedCaptions, ...await userUploadedCaptions];
    // }

    final scrapedSubtitles = await _rawScraper.scrapeSubtitles(
      youtubeVideoId: youtubeVideoId,
      mainLanguages: _targetLanguages,
      translatedLanguage:
          target == _ScrapeTarget.target ? null : _translatedLanguage,
      onProgressUpdated: onProgressUpdated,
    );

    // Future.wait(scrapedSubtitles.map(_youtubeCacheManager.cacheCaptions));
    if (scrapedSubtitles.isEmpty) return [];
    return [...scrapedSubtitles, ...await userUploadedCaptions];
  }
}

enum _ScrapeTarget {
  target,
  translated,
}
