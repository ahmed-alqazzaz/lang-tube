// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class DioApiClient {
  final Dio _dio;
  DioApiClient({String? userAgent, bool useCache = false})
      : _dio = Dio()..options.headers['User-Agent'] = userAgent {
    if (useCache) {
      _hiveCacheStore.then(
        (cacheStore) => _dio.interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: cacheStore)),
        ),
      );
    }
  }
  Future<T?> fetchUri<T>(Uri uri,
          {void Function(int, int)? onReceiveProgress}) async =>
      await _dio
          .getUri<T>(uri, onReceiveProgress: onReceiveProgress)
          .then((res) => res.data);

  static Future<String> get _cacheDirectory async =>
      await getApplicationDocumentsDirectory().then(
        (dir) => dir.path,
      );
  static const _cacheBoxName = "dio_hive_cache";
  static Future<HiveCacheStore> get _hiveCacheStore async => HiveCacheStore(
        await _cacheDirectory,
        hiveBoxName: _cacheBoxName,
      );
  static Future<void> clearCache() async {
    final cacheDirectory = await _cacheDirectory;
    File('$cacheDirectory/$_cacheBoxName.hive').delete();
  }
}
