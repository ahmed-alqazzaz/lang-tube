import 'package:mutex/mutex.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/subtitles/cached_source_captions.dart';
import '../../../models/subtitles/cached_captions.dart';
import '../utils/db_info_matcher.dart';
import 'cache_manager_impl.dart';

class MutexedCacheManager implements CaptionsCacheManagerImpl {
  static final _mutex = Mutex();
  final CaptionsCacheManagerImpl _cacheManager;
  const MutexedCacheManager(this._cacheManager);

  @override
  Future<void> cacheCaptions(CachedCaptions subtitles) async {
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
  Stream<CachedCaptions> retrieveSubtitles(
      {required String videoId, InfoFilter? filter}) async* {
    await _mutex.acquire();
    yield* _cacheManager
        .retrieveSubtitles(videoId: videoId, filter: filter)
        .doOnFinished(_mutex.release);
  }

  @override
  Stream<CachedSourceCaptions> retrieveSources(
      {String? videoId, InfoFilter? filter}) async* {
    await _mutex.acquire();
    yield* _cacheManager
        .retrieveSources(videoId: videoId, filter: filter)
        .doOnFinished(_mutex.release);
  }

  @override
  Future<void> clearCaptions(
      {required String videoId, InfoFilter? filter}) async {
    await _mutex.acquire();
    return _cacheManager
        .clearCaptions(videoId: videoId, filter: filter)
        .whenComplete(_mutex.release);
  }

  @override
  Future<void> clearSources({String? videoId, InfoFilter? filter}) async {
    await _mutex.acquire();
    return _cacheManager
        .clearSources(videoId: videoId, filter: filter)
        .whenComplete(_mutex.release);
  }

  @override
  Future<void> close() async {
    await _mutex.acquire();
    return _cacheManager.close().whenComplete(_mutex.release);
  }
}

extension _StreamExtension<T> on Stream<T> {
  Stream<T> doOnFinished(void Function() callback) {
    bool isCalled = false;
    void callback0() {
      if (isCalled) return;
      isCalled = true;
      callback();
    }

    return doOnDone(callback0).doOnCancel(callback0).doOnError((p0, p1) {
      callback0();
    });
  }
}
