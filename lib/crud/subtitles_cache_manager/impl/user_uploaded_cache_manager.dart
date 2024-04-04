import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../../models/subtitles/captions_type.dart';
import '../utils/db_info_matcher.dart';

import '../../../models/subtitles/cached_captions.dart';
import 'cache_manager_impl.dart';

/// Manages the cache for user-uploaded captions.
final class UserUploadedCaptionsCacheManager {
  UserUploadedCaptionsCacheManager(CaptionsCacheManagerImpl cacheManager)
      : _cacheManager = cacheManager;
  final CaptionsCacheManagerImpl _cacheManager;

  Future<void> cacheCaptions(CachedCaptions subtitles) =>
      _cacheManager.cacheCaptions(subtitles);

  Future<List<CachedCaptions>> retrieveSubtitles(
          {required String videoId, Language? language}) =>
      _cacheManager
          .retrieveSubtitles(
            videoId: videoId,
            filter: (dbInfo) =>
                dbInfo.captionsType == CaptionsType.userUploaded,
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

  Future<void> close() async => await _cacheManager.close();
}
