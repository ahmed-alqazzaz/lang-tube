import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:lang_tube/subtitles_player/utils/api_client/popular_user_agents.dart';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';

class DioApiClient {
  final Dio _dio;

  DioApiClient._({required String userAgent, CacheStore? cacheStore})
      : _dio = Dio()..options.headers['User-Agent'] = userAgent {
    if (cacheStore != null) {
      _dio.interceptors.add(
        DioCacheInterceptor(options: CacheOptions(store: cacheStore)),
      );
    }
  }

  static Future<DioApiClient> withRandomUserAgent(
          [bool enableCacheStore = false]) async =>
      DioApiClient._(
        userAgent: _randomUserAgent,
        cacheStore: enableCacheStore ? await _hiveCacheStore : null,
      );
  static Future<DioApiClient> withUserAgent(String userAgent,
          [bool enableCacheStore = false]) async =>
      DioApiClient._(
        userAgent: userAgent,
        cacheStore: enableCacheStore ? await _hiveCacheStore : null,
      );

  Future<Response<T>> fetchUri<T>(Uri uri) async {
    return await _dio.getUri<T>(uri);
  }

  static Future<HiveCacheStore> get _hiveCacheStore async => HiveCacheStore(
        await getTemporaryDirectory().then((dir) => dir.path),
      );
  static String get _randomUserAgent => popularUserAgents.elementAt(
        math.Random().nextInt(popularUserAgents.length),
      );
}
