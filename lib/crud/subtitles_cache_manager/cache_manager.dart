import 'dart:async';

import 'package:lang_tube/crud/subtitles_cache_manager/impl/user_uploaded_cache_manager.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/impl/youtube_cache_manager.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/utils/decorator.dart';
import 'package:path_provider/path_provider.dart';

import 'database/database.dart';
import 'impl/cache_manager_impl.dart';

abstract class CaptionsCacheManager {
  static CaptionsCacheManagerImpl? _impl;

  static FutureOr<UserUploadedCaptionsCacheManager> get userUploaded async =>
      (await _open()).mutexed.userUploaded;

  static FutureOr<YouTubeCaptionsCacheManager> get youtube async =>
      (await _open()).youtube;

  static FutureOr<CaptionsCacheManagerImpl> _open() async =>
      _impl ??
      (_impl = CaptionsCacheManagerImpl(
        await SubtitlesDatabase.open(storageDir: await _storageDir),
      ))
          .mutexed;

  static FutureOr<void> close() async {
    await _impl?.close();
    _impl = null;
  }

  static Future<String> get _storageDir async =>
      await getTemporaryDirectory().then((dir) => dir.path);
}
