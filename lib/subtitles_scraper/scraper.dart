// import 'dart:async';

// import 'package:collection/collection.dart';
// import 'package:colourful_print/colourful_print.dart';
// import 'package:flutter/material.dart';
// import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
// import 'package:languages/languages.dart';
// import 'package:user_agent/user_agent.dart';
// import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
// import '../crud/subtitles_cache_manager/cache_manager.dart';
// import '../crud/subtitles_cache_manager/impl/cache_manager_impl.dart';
// import '../crud/subtitles_cache_manager/impl/youtube_cache_manager.dart';
// import 'api_client.dart';
// import 'package:quiver/iterables.dart';

// Future<void> main(List<String> args) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await UserAgent.instance.initilize();
//   await SubtitlesScraper.ensureInitalized();

//   await SubtitlesScraper.instance
//       .fetchSubtitlesBundle(
//     youtubeVideoId: '8fEEbKJoNbU',
//     mainLanguages: [Language.english],
//     translatedLanguage: Language.german,
//     onProgressUpdated: print,
//   )
//       .then((value) {
//     for (var element in value) {
//       print(element.mainSubtitles.info.language);
//     }
//     return null;
//   });
// }

// @immutable
// final class SubtitlesScraper {
//   static YouTubeCaptionsCacheManager? _cacheManager;
//   static Future<void> ensureInitalized() async =>
//       _cacheManager ??= await CaptionsCacheManager.openYoutubeInstance;

//   static SubtitlesScraper get instance => _instance;
//   static final _instance = SubtitlesScraper._();
//   SubtitlesScraper._()
//       : assert(_cacheManager != null,
//             'subtitles scraper has not been initialized'),
//         _scraper = YoutubeSubtitlesScraper(
//           cacheManager: _cacheManager!,
//           apiClient: ScraperApiClient(),
//         );

//   final YoutubeSubtitlesScraper _scraper;

//   // Function to fetch and process subtitles for a YouTube video in different languages.
//   Future<Iterable<CaptionsBundle>> fetchSubtitlesBundle({
//     required String youtubeVideoId,
//     required List<Language> mainLanguages,
//     required Language translatedLanguage,
//     void Function(double)? onProgressUpdated,
//   }) async {
//     final progressList = <double>[0.0, 0.0];
//     return await Future.wait<Iterable<ScrapedCaptions>>(
//       [
//         scrapeAndCacheSubtitles(
//           youtubeVideoId: youtubeVideoId,
//           mainLanguages: mainLanguages,
//           onProgressUpdated: (p0) {
//             progressList[0] = p0;
//             onProgressUpdated?.call(progressList.average);
//           },
//         ),
//         scrapeAndCacheSubtitles(
//           youtubeVideoId: youtubeVideoId,
//           mainLanguages: mainLanguages,
//           translatedLanguage: translatedLanguage,
//           onProgressUpdated: (p0) {
//             progressList[1] = p0;
//             onProgressUpdated?.call(progressList.average);
//           },
//         ),
//       ],
//       eagerError: true,
//     ).then(
//       (subtitlesPair) {
//         // zip the list(of two) returned by future.wait
//         return zip(subtitlesPair).map(
//           (pair) => CaptionsBundle(
//             mainSubtitles: pair.first,
//             translatedSubtitles: pair.last,
//           ),
//         );
//       },
//     );
//   }

//   Future<List<ScrapedCaptions>> scrapeAndCacheSubtitles({
//     required String youtubeVideoId,
//     required List<Language> mainLanguages,
//     Language? translatedLanguage,
//     void Function(double)? onProgressUpdated,
//   }) async {
//     final languages =
//         translatedLanguage != null ? [translatedLanguage] : [...mainLanguages];
//     final userUploadedCaptions = await Future.wait(
//       languages.map(
//         (language) async =>
//             (await CaptionsCacheManager.openUserUploadedInstance)
//                 .retrieveSubtitles(
//           videoId: youtubeVideoId,
//           language: language.name,
//         ),
//       ),
//     ).then((value) => value.expand((captions) => captions).toList());
//     final cachedCaptions = await Future.wait(
//       languages.map(
//         (language) async =>
//             (await CaptionsCacheManager.openYoutubeInstance).retrieveSubtitles(
//           videoId: youtubeVideoId,
//           language: language.name,
//         ),
//       ),
//     ).then((value) => value.expand((captions) => captions).toList());
//     if (cachedCaptions.isNotEmpty) {
//       return [...cachedCaptions, ...userUploadedCaptions];
//     }
//     final scrapedSubtitles = await _scraper.scrapeSubtitles(
//       youtubeVideoId: youtubeVideoId,
//       mainLanguages: mainLanguages,
//       translatedLanguage: translatedLanguage,
//       onProgressUpdated: onProgressUpdated,
//     );
//     Future.wait(scrapedSubtitles.map(_cacheManager!.cacheCaptions));
//     if (scrapedSubtitles.isEmpty) return [];
//     return [...scrapedSubtitles, ...userUploadedCaptions];
//   }
// }
