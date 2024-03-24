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
  Stream<CachedCaptions> retrieveSubtitles({InfoFilter? filter}) async* {
    await _mutex.acquire();
    yield* _cacheManager.retrieveSubtitles(filter: filter).doOnFinished(
          _mutex.release,
        );
  }

  @override
  Stream<CachedSourceCaptions> retrieveSources({InfoFilter? filter}) async* {
    await _mutex.acquire();
    yield* _cacheManager.retrieveSources(filter: filter).doOnFinished(
          _mutex.release,
        );
  }

  @override
  Future<void> clearCaptions({InfoFilter? filter}) async {
    await _mutex.acquire();
    return _cacheManager.clearCaptions(filter: filter).whenComplete(
          _mutex.release,
        );
  }

  @override
  Future<void> clearSources({InfoFilter? filter}) async {
    await _mutex.acquire();
    return _cacheManager.clearSources(filter: filter).whenComplete(
          _mutex.release,
        );
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
    void _callback() {
      if (isCalled) return;
      isCalled = true;
      callback();
    }

    return doOnDone(_callback).doOnCancel(_callback).doOnError((p0, p1) {
      _callback();
    });
  }
}
