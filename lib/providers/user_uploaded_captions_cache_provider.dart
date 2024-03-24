import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../crud/subtitles_cache_manager/cache_manager.dart';
import 'captions_cache_dir_provider.dart';

final userUploadedCaptionsCacheManagerProvider = FutureProvider(
  (ref) async => await CaptionsCacheManager.openUserUploadedInstance(
    storageDir: await ref.watch(captionsCacheDirProvider.future),
  ),
);
