import 'package:colourful_print/colourful_print.dart';
import 'package:youtube_subtitles_scraper/src/abstract/cache_manager.dart';

extension CacheExpirationManager on CacheManager {
  Future<void> clearExpiredSources(
      {required void Function(String videoId) onSourceDeleted}) async {
    final sources = await retrieveAllSources();
    if (sources == null) return;
    for (var source in sources) {
      if (source.isExpired == true) {
        printRed('clearing cache');
        clearSourcesById(videoId: source.videoId).whenComplete(
          () => onSourceDeleted(source.videoId),
        );
      }
    }
  }
}
