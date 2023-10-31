import 'dart:async';

import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

extension CacheExpirationManager on CacheManager {
  Future<void> clearExpiredSources(
      {required FutureOr<void> Function(String videoId)
          onSourcesDeleted}) async {
    final sources = await retrieveAllSources();

    if (sources == null) return;
    for (var source in sources.unique) {
      if (source.isExpired == true) {
        clearSourcesById(videoId: source.videoId).whenComplete(
          () => onSourcesDeleted(source.videoId),
        );
      }
    }
  }
}

extension on Iterable<SourceCaptions> {
  Iterable<SourceCaptions> get unique sync* {
    String prevId = "";
    for (SourceCaptions source in this) {
      if (source.videoId == prevId) continue;
      prevId = source.videoId;
      yield source;
    }
  }
}
