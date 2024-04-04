import '../utils/db_info_matcher.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_captions.dart';
import '../../../models/subtitles/captions_type.dart';
import 'cache_manager_impl.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart'
    as youtube_subtitles_scraper;

class YouTubeCaptionsCacheManager
    implements youtube_subtitles_scraper.CacheManager {
  const YouTubeCaptionsCacheManager(CaptionsCacheManagerImpl cacheManager)
      : _cacheManager = cacheManager;
  final CaptionsCacheManagerImpl _cacheManager;

  Future<void> cacheCaptions(ScrapedCaptions subtitles) => _cacheManager
      .cacheCaptions(CachedCaptions.fromScrapedCaptions(subtitles));

  Future<Iterable<CachedCaptions>> retrieveSubtitles(
          {required String videoId}) =>
      _cacheManager
          .retrieveSubtitles(
            videoId: videoId,
            filter: (dbInfo) =>
                (dbInfo.captionsType == CaptionsType.youTubeAutoGenerated ||
                    dbInfo.captionsType == CaptionsType.youTubeUserGenerated),
          )
          .toList();

  Future<void> clearCaptions({required String videoId, String? language}) =>
      _cacheManager.clearCaptions(
        videoId: videoId,
        filter: (dbInfo) => dbInfo.matches(
          language: language,
          type: CaptionsType.userUploaded,
        ),
      );

  @override
  Future<void> cacheSourceCaptions(SourceCaptions sourceCaptions) =>
      _cacheManager.cacheSourceCaptions(
          CachedSourceCaptions.fromSourceCaptions(sourceCaptions));

  @override
  Future<void> clearSources(
      {String? videoId, bool? isAutoGenerated, String? language}) {
    if (isAutoGenerated != null) assert(videoId != null);
    return _cacheManager.clearSources(
      filter: (dbInfo) => dbInfo.matches(
        videoId: videoId,
        language: language,
        type: isAutoGenerated != null
            ? isAutoGenerated
                ? CaptionsType.youTubeAutoGenerated
                : CaptionsType.youTubeUserGenerated
            : null,
      ),
    );
  }

  @override
  Future<Iterable<SourceCaptions>> retrieveSources(
          {String? videoId, String? language, bool? isAutoGenerated}) =>
      _cacheManager
          .retrieveSources(
            filter: (dbInfo) => dbInfo.matches(
              videoId: videoId,
              language: language,
              type: isAutoGenerated != null
                  ? isAutoGenerated
                      ? CaptionsType.youTubeAutoGenerated
                      : CaptionsType.youTubeUserGenerated
                  : null,
            ),
          )
          .toList();

  Future<void> close() async => await _cacheManager.close();
}
