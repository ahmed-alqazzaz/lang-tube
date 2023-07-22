import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/subtitles_scraper/subtitles_scraper.dart';

final subtitlesScraperProvider = FutureProvider(
  (ref) async {
    final userAgent = await FkUserAgent.getPropertyAsync("userAgent");
    return userAgent != null
        ? SubtitlesScraper.withUserAgent(userAgent)
        : SubtitlesScraper.withRandomUserAgent();
  },
);
