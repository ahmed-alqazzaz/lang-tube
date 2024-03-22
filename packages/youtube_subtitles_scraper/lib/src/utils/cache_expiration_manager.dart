import 'dart:async';

import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

extension CacheExpirationManager on CacheManager {
  Future<void> clearExpiredSources(
      {required FutureOr<void> Function(String videoId)
          onSourcesDeleted}) async {
    final sources = await retrieveSources();

    for (var source in sources.unique) {
      if (source.isExpired == true) {
        clearSources(videoId: source.info.videoId).whenComplete(
          () => onSourcesDeleted(source.info.videoId),
        );
      }
    }
  }
}

extension on Iterable<SourceCaptions> {
  Iterable<SourceCaptions> get unique sync* {
    String prevId = "";
    for (SourceCaptions source in this) {
      if (source.info.videoId == prevId) continue;
      prevId = source.info.videoId;
      yield source;
    }
  }
}
