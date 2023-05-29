import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/api_client/popular_user_agents.dart';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';

class DioApiClient {
  final Dio _dio;

  DioApiClient._({required String userAgent, required CacheStore cacheStore})
      : _dio = Dio()
          ..options.headers['User-Agent'] = userAgent
          ..interceptors.add(
            DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())),
          );

  static Future<DioApiClient> withRandomUserAgent() async => DioApiClient._(
        userAgent: _randomUserAgent,
        cacheStore: await _hiveCacheStore,
      );
  static Future<DioApiClient> withUserAgent(String userAgent) async =>
      DioApiClient._(
        userAgent: userAgent,
        cacheStore: await _hiveCacheStore,
      );
  Future<Response<T>> fetchUri<T>(Uri uri) async {
    return await _dio.getUri<T>(uri).then((value) {
      log('hhh ${uri}');
      log('cache source ${value.requestOptions.extra['cacheSource']}');
      return value;
    });
  }

  static Future<HiveCacheStore> get _hiveCacheStore async => HiveCacheStore(
        await getTemporaryDirectory().then((dir) => dir.path),
      );
  static String get _randomUserAgent => popularUserAgents.elementAt(
        math.Random().nextInt(popularUserAgents.length),
      );
}
