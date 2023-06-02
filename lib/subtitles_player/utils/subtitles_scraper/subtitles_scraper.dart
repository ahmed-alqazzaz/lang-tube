import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_player/utils/api_client/dio_api_client.dart';

import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/data/extensions.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_cache_manager/subtitles_cache_manager.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'data/exceptions.dart';
import 'data/data.dart';

typedef SubtitlesBundle = ({
  SubtitlesEntry mainLanguageSubtitles,
  SubtitlesEntry translatedSubtitles,
});

@immutable
class SubtitlesScraper {
  const SubtitlesScraper._({
    required DioApiClient client,
    required SubtitlesCacheManager cacheManager,
    required YoutubeExplode yt,
  })  : _client = client,
        _cacheManager = cacheManager,
        _yt = yt;

  final SubtitlesCacheManager _cacheManager;
  final DioApiClient _client;
  final YoutubeExplode _yt;

  static Future<SubtitlesScraper> withRandomUserAgent() async =>
      SubtitlesScraper._(
        client: await DioApiClient.withRandomUserAgent(),
        cacheManager: await SubtitlesCacheManager.open(),
        yt: YoutubeExplode(),
      );

  static Future<SubtitlesScraper> withUserAgent(String userAgent) async =>
      SubtitlesScraper._(
        client: await DioApiClient.withUserAgent(userAgent),
        cacheManager: await SubtitlesCacheManager.open(),
        yt: YoutubeExplode(),
      );

  // returns a stream of manually generated subtitles if they exist
  //  otherwise return autoGenerated
  Future<SubtitlesBundle> getSubtitle({
    required String youtubeVideoId,
    required ({String mainLanguage, String translatedLanguage}) languages,
  }) async {
    return await _cacheManager.retrieveSubtitlesIfExists(
          videoId: youtubeVideoId,
          languages: languages,
        ) ??
        await _scrapeSubtitles(
          youtubeVideoId: youtubeVideoId,
          languages: languages,
        );
  }

  Future<SubtitlesBundle> _scrapeSubtitles({
    required String youtubeVideoId,
    required ({String mainLanguage, String translatedLanguage}) languages,
  }) async {
    final manifest = await _yt.videos.closedCaptions
        .getManifest(youtubeVideoId, formats: [ClosedCaptionFormat.srv1]);
    final caption = (manifest.containsManuallyGenerated
            ? manifest.manuallyGeneratedCaptions
            : manifest.autoGeneratedCaptions)
        .where(
          (element) => element.language.name.toLowerCase().contains(
                languages.mainLanguage.toLowerCase(),
              ),
        )
        .firstOrNull;
    final translatedCaption =
        manifest.getByLanguage(languages.translatedLanguage).firstOrNull;
    final isAutoGenerated = !manifest.containsManuallyGenerated;

    if (caption != null) {
      return (
        mainLanguageSubtitles: await _subtitlesEntryGenerator(
          caption: caption,
          isAutoGenerated: isAutoGenerated,
          videoId: youtubeVideoId,
          language: languages.mainLanguage,
        ),
        // change en
        translatedSubtitles: await _subtitlesEntryGenerator(
          caption: translatedCaption ?? caption.autoTranslate('en'),
          isAutoGenerated: translatedCaption == null,
          videoId: youtubeVideoId,
          language: languages.translatedLanguage,
        ),
      );
    }
    throw SubtitlesScraperNoCaptionsFoundExceptions();
  }

  Future<SubtitlesEntry> _subtitlesEntryGenerator({
    required ClosedCaptionTrackInfo caption,
    required String videoId,
    required bool isAutoGenerated,
    required String language,
  }) async {
    return SubtitlesEntry(
      isAutoGenerated: isAutoGenerated,
      language: caption.language.name,
      videoId: videoId,
      subtitles: await _fetchUri<String>(caption.url).then(
        (subtitlesString) async {
          await _cacheManager.cacheSubtitles(
              subtitleEntryy: SubtitlesEntry(
            language: language,
            videoId: videoId,
            subtitles: subtitlesString,
            isAutoGenerated: isAutoGenerated,
          ));
          return subtitlesString;
        },
      ),
    );
  }

  Future<T> _fetchUri<T>(Uri uri) async {
    try {
      return await _client.fetchUri(uri).then((response) {
        if (response.statusCode != 200) {
          throw SubtitlesScraperBlockedRequestException();
        }
        return response.data!;
      });
    } on DioError catch (e) {
      if (e.error == DioErrorType.sendTimeout ||
          e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw SubtitlesScraperNetworkException();
      } else if (e.error == DioErrorType.badResponse) {
        throw SubtitlesScraperBlockedRequestException();
      } else {
        throw SubtitlesScraperUnknownException();
      }
    }
  }
}
