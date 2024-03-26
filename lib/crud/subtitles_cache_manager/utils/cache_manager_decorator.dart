import '../impl/cache_manager_impl.dart';
import '../impl/mutxed_cache_manager.dart';
import '../impl/user_uploaded_cache_manager.dart';
import '../impl/youtube_cache_manager.dart';

extension Decorator on CaptionsCacheManagerImpl {
  CaptionsCacheManagerImpl get mutexed => MutexedCacheManager(this);
  YouTubeCaptionsCacheManager get youtube => YouTubeCaptionsCacheManager(this);
  UserUploadedCaptionsCacheManager get userUploaded =>
      UserUploadedCaptionsCacheManager(this);
}
