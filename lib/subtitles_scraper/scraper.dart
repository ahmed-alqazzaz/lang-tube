import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/models/subtitles_scraping/subtitles_bundle.dart';
import 'package:languages/languages.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import '../crud/subtitles_cache_manager/cache_manager.dart';
import '../models/subtitles_scraping/subtitles_data.dart';
import 'api_client.dart';
import 'package:quiver/iterables.dart';

@immutable
final class SubtitlesScraper {
  static SubtitlesCacheManager? _cacheManager;
  static Future<void> ensureInitalized() async =>
      _cacheManager ??= await SubtitlesCacheManager.open();

  static SubtitlesScraper get instance => _instance;
  static final _instance = SubtitlesScraper._();
  SubtitlesScraper._()
      : assert(_cacheManager != null,
            'subtitles scraper has not been initialized'),
        _scraper = YoutubeSubtitlesScraper(
          cacheManager: _cacheManager!,
          apiClient: ScraperApiClient(),
        );

  final YoutubeSubtitlesScraper _scraper;

  // Function to fetch and process subtitles for a YouTube video in different languages.
  Future<Iterable<SubtitlesBundle>> fetchSubtitlesBundle(
      {required String youtubeVideoId,
      required Language mainLanguage,
      required Language translatedLanguage,
      void Function(double)? onProgressUpdated}) async {
    final progressList = <double>[0.0, 0.0];
    return await Future.wait<Iterable<ScrapedSubtitles>>(
      [
        scrapeSubtitles(
          youtubeVideoId: youtubeVideoId,
          language: mainLanguage,
          onProgressUpdated: (p0) {
            progressList[0] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        ).then((value) =>
            value ?? (throw SubtitlesScraperNoCaptionsFoundException)),
        scrapeSubtitles(
          youtubeVideoId: youtubeVideoId,
          language: mainLanguage,
          translatedLanguage: translatedLanguage,
          onProgressUpdated: (p0) {
            progressList[1] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        ).then((value) =>
            value ?? (throw SubtitlesScraperNoCaptionsFoundException)),
      ],
      eagerError: true,
    ).then(
      (subtitlesPair) {
        // zip the list(of two) returned by future.wait
        return zip(subtitlesPair).map(
          (pair) => SubtitlesBundle(
            mainSubtitlesData: pair.first,
            translatedSubtitlesData: pair.last,
          ),
        );
      },
    );
  }

  // in case translated language is provided,
  // the function will return a translated version
  // the main language subtitle
  Future<List<ScrapedSubtitles>?> scrapeSubtitles({
    required String youtubeVideoId,
    required Language language,
    Language? translatedLanguage,
    void Function(double)? onProgressUpdated,
  }) async =>
      await _scraper.scrapeSubtitles(
        youtubeVideoId: youtubeVideoId,
        language: language,
        translatedLanguage: translatedLanguage,
        onProgressUpdated: onProgressUpdated,
      );

  Future<void> close() async => await _cacheManager!.close();
}
