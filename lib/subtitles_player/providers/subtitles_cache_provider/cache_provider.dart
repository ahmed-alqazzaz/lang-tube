import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/cache_manager.dart';

final subtitlesCacheProvider =
    FutureProvider((ref) async => await SubtitlesCacheManager.open());
