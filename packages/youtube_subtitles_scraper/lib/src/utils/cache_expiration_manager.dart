import 'dart:async';

import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

extension CacheExpirationManager on CacheManager {
  Future<void> clearExpiredSources(
      {FutureOr<void> Function(CaptionsInfo)? onSourcesDeleted}) async {
    final sources = await retrieveSources();

    for (var source in sources.unique) {
      if (source.isExpired == true) {
        clearSources(videoId: source.info.videoId).whenComplete(
          () => onSourcesDeleted?.call(source.info),
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
