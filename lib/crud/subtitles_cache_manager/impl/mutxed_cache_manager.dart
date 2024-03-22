import 'package:mutex/mutex.dart';

import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_subtitles.dart';
import '../../../models/subtitles/captions_type.dart';
import 'cache_manager_impl.dart';

class MutexedCacheManager implements CaptionsCacheManagerImpl {
  static final _mutex = Mutex();
  final CaptionsCacheManagerImpl _cacheManager;
  const MutexedCacheManager(this._cacheManager);

  @override
  Future<void> cacheCaptions(CachedSubtitles subtitles) async {
    await _mutex.acquire();
    return _cacheManager.cacheCaptions(subtitles).whenComplete(
          _mutex.release,
        );
  }

  @override
  Future<void> cacheSourceCaptions(CachedSourceCaptions captions) async {
    await _mutex.acquire();
    return _cacheManager.cacheSourceCaptions(captions).whenComplete(
          _mutex.release,
        );
  }

  @override
  Future<Iterable<CachedSubtitles>> retrieveSubtitles(
      {String? videoId, String? language, CaptionsType? type}) async {
    await _mutex.acquire();
    return _cacheManager
        .retrieveSubtitles(videoId: videoId, language: language, type: type)
        .whenComplete(_mutex.release);
  }

  @override
  Future<Iterable<CachedSourceCaptions>> retrieveSources(
      {String? videoId, String? language, CaptionsType? type}) async {
    await _mutex.acquire();
    return _cacheManager
        .retrieveSources(videoId: videoId, language: language, type: type)
        .whenComplete(_mutex.release);
  }

  @override
  Future<void> clearCaptions(
      {String? videoId, String? language, CaptionsType? type}) async {
    await _mutex.acquire();
    return _cacheManager
        .clearCaptions(videoId: videoId, language: language, type: type)
        .whenComplete(_mutex.release);
  }

  @override
  Future<void> clearSources(
      {String? videoId, String? language, CaptionsType? type}) async {
    await _mutex.acquire();
    return _cacheManager
        .clearSources(videoId: videoId, language: language, type: type)
        .whenComplete(_mutex.release);
  }

  @override
  Future<void> close() async {
    await _mutex.acquire();
    return _cacheManager.close().whenComplete(_mutex.release);
  }
}
