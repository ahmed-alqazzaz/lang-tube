import 'dart:async';

import 'package:lang_tube/crud/subtitles_cache_manager/impl/user_uploaded_cache_manager.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/impl/youtube_cache_manager.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/utils/cache_manager_decorator.dart';
import 'package:path_provider/path_provider.dart';

import 'database/database.dart';
import 'impl/cache_manager_impl.dart';

abstract class CaptionsCacheManager {
  static Future<UserUploadedCaptionsCacheManager> openUserUploadedInstance(
          {String? storageDir}) async =>
      (await _open(storageDir: storageDir)).mutexed.userUploaded;

  static Future<YouTubeCaptionsCacheManager> openYoutubeInstance(
          {String? storageDir}) async =>
      (await _open(storageDir: storageDir)).mutexed.youtube;

  static Future<CaptionsCacheManagerImpl> _open({String? storageDir}) async =>
      CaptionsCacheManagerImpl(
        await SubtitlesDatabase.open(
          storageDir: storageDir ?? await _defaultStorageDir,
        ),
      );

  static Future<String> get _defaultStorageDir async =>
      await getTemporaryDirectory().then((dir) => dir.path);
}
