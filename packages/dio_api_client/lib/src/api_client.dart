import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class DioApiClient {
  final Dio _dio;
  DioApiClient({String? userAgent, cache = false})
      : _dio = Dio()..options.headers['User-Agent'] = userAgent {
    if (cache) {
      _hiveCacheStore.then(
        (cacheStore) => _dio.interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: cacheStore)),
        ),
      );
    }
  }
  Future<Response<T>> fetchUri<T>(Uri uri) async {
    return await _dio.getUri<T>(uri);
  }

  static Future<HiveCacheStore> get _hiveCacheStore async => HiveCacheStore(
        await getTemporaryDirectory().then((dir) => dir.path),
      );
}
