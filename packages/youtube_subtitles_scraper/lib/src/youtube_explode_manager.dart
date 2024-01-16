import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';
import 'package:unique_key_mutex/unique_key_mutex.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

@immutable
final class YoutubeExplodeManager {
  YoutubeExplodeManager({required CacheManager cacheManager})
      : _youtubeExplode = YoutubeExplode(),
        _cacheManager = cacheManager;
  final YoutubeExplode _youtubeExplode;
  final CacheManager _cacheManager;

  Future<Iterable<SourceCaptions>> fetchAllCaptions(
      {required String youtubeVideoId}) async {
    try {
      await UniqueKeyMutex(key: youtubeVideoId).acquire();
      final cache =
          await _cacheManager.retrieveSources(videoId: youtubeVideoId);
      // if (cache.isNotEmpty) return cache;
      final captions = await _scrapeAllCaptions(youtubeVideoId: youtubeVideoId);
      // await Future.wait(
      //   captions.where((element) => element.language != null).map(
      //         _cacheManager.cacheSourceCaptions,
      //       ),
      // );
      return captions;
    } finally {
      UniqueKeyMutex(key: youtubeVideoId).release();
    }
  }

  Future<Iterable<SourceCaptions>> _scrapeAllCaptions(
          {required String youtubeVideoId}) =>
      _youtubeExplode.videos.closedCaptions.getManifest(youtubeVideoId,
          formats: [ClosedCaptionFormat.srv1]).then(
        (manifest) => manifest.tracks.map(
          (track) => SourceCaptions(
            uri: track.url,
            videoId: youtubeVideoId,
            isAutoGenerated: track.isAutoGenerated,
          ),
        ),
      );

  void close() => _youtubeExplode.close();
}
