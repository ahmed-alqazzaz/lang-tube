import 'package:collection/collection.dart';
import 'package:youtube_subtitles_scraper/src/abstract/cache_manager.dart';

extension CacheRedundancyManager on CacheManager {
  Future<void> deleteUnnecessarySources() async {
    final subtitlesList = await retrieveSubtitles() ?? [];
    final groupedSubtitles =
        subtitlesList.groupListsBy((subtitles) => subtitles.info.videoId);
    await Future.wait(
      groupedSubtitles.entries.map(
        (entry) async {
          final videoId = entry.key;
          final subtitlesList = entry.value;
          final languages =
              subtitlesList.map((subtitles) => subtitles.info.language).toSet();

          // in case there are two languages for same subtitles,
          // it means we won't need the source anymore
          if (languages.length > 1) await clearSources(videoId: videoId);
        },
      ),
    );
  }
}
