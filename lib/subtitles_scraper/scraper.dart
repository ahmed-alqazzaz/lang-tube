import 'dart:async';

import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:languages/languages.dart';
import 'package:user_agent/user_agent.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import '../crud/subtitles_cache_manager/cache_manager.dart';
import 'api_client.dart';
import 'package:quiver/iterables.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager.instance.initilize();
  await SubtitlesScraper.ensureInitalized();
  try {
    await SubtitlesScraper.instance
        .fetchSubtitlesBundle(
      youtubeVideoId: '8fEEbKJoNbU',
      mainLanguages: [Language.english],
      translatedLanguage: Language.germanVariants.first,
      onProgressUpdated: print,
    )
        .then((value) {
      for (var element in value) {
        print(element.mainSubtitles.language);
      }
      return null;
    });
  } catch (e) {
    printRed(e.toString());
  }
}

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
  Future<Iterable<SubtitlesBundle>> fetchSubtitlesBundle({
    required String youtubeVideoId,
    required List<Language> mainLanguages,
    required Language translatedLanguage,
    void Function(double)? onProgressUpdated,
  }) async {
    final progressList = <double>[0.0, 0.0];
    return await Future.wait<Iterable<ScrapedSubtitles>>(
      [
        _scraper
            .scrapeSubtitles(
          youtubeVideoId: youtubeVideoId,
          mainLanguages: mainLanguages,
          onProgressUpdated: (p0) {
            progressList[0] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        )
            .then((value) {
          print("1 ${value == null}");
          return value ?? (throw SubtitlesScraperNoCaptionsFoundException);
        }),
        _scraper
            .scrapeSubtitles(
          youtubeVideoId: youtubeVideoId,
          mainLanguages: mainLanguages,
          translatedLanguage: translatedLanguage,
          onProgressUpdated: (p0) {
            progressList[1] = p0;
            onProgressUpdated?.call(progressList.average);
          },
        )
            .then((value) {
          print("2 ${value == null}");
          return value ?? (throw SubtitlesScraperNoCaptionsFoundException);
        }),
      ],
      eagerError: true,
    ).then(
      (subtitlesPair) {
        // zip the list(of two) returned by future.wait
        return zip(subtitlesPair).map(
          (pair) => SubtitlesBundle(
            mainSubtitles: pair.first,
            translatedSubtitles: pair.last,
          ),
        );
      },
    );
  }

  Future<List<ScrapedSubtitles>?> Function({
    required String youtubeVideoId,
    required List<Language> mainLanguages,
    Language? translatedLanguage,
    void Function(double)? onProgressUpdated,
  }) get scrapeSubtitles => _scraper.scrapeSubtitles;

  Future<void> close() async => await _cacheManager!.close();
}
