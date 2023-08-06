import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/cache_provider.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/scraper.dart';

final subtitlesScraperProvider = FutureProvider(
  (ref) async => SubtitlesScraper(
    cacheManager: await ref.read(subtitlesCacheProvider.future),
  ),
);
