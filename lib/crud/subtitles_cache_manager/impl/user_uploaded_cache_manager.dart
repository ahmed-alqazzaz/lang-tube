import 'package:lang_tube/models/subtitles/captions_type.dart';
import '../../../models/subtitles/cached_subtitles.dart';
import 'cache_manager_impl.dart';

/// Manages the cache for user-uploaded captions.
final class UserUploadedCaptionsCacheManager {
  UserUploadedCaptionsCacheManager(CaptionsCacheManagerImpl cacheManager)
      : _cacheManager = cacheManager;
  final CaptionsCacheManagerImpl _cacheManager;

  Future<void> cacheCaptions(CachedSubtitles subtitles) =>
      _cacheManager.cacheCaptions(subtitles);

  Future<Iterable<CachedSubtitles>> retrieveSubtitles(
          {String? videoId, String? language}) =>
      _cacheManager.retrieveSubtitles(
        videoId: videoId,
        language: language,
        type: CaptionsType.userUploaded,
      );

  Future<void> clearCaptions({String? videoId, String? language}) =>
      _cacheManager.clearCaptions(
        videoId: videoId,
        language: language,
        type: CaptionsType.userUploaded,
      );
}
