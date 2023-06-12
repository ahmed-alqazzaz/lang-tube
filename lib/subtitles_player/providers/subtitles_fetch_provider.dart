import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/data/data_classes.dart';

import '../utils/subtitles_scraper/subtitles_scraper.dart';

KeepAliveLink? subtitlesFetchProviderKeepAliveLink;
final subtitlesFetchProviderFamily = FutureProvider.family.autoDispose<
    SubtitlesBundle,
    ({
      String videoId,
      String mainLanguage,
      String translatedLanguage,
    })>(
  (ref, args) async {
    const userAgent = null;
    // await FkUserAgent.getPropertyAsync("userAgent");
    final subtitlesScraper = userAgent != null
        ? await SubtitlesScraper.withUserAgent(userAgent)
        : await SubtitlesScraper.withRandomUserAgent();
    final subtitles = await subtitlesScraper.getSubtitle(
      youtubeVideoId: args.videoId,
      languages: (
        mainLanguage: 'german',
        translatedLanguage: 'English',
      ),
    );
    subtitlesFetchProviderKeepAliveLink = ref.keepAlive();
    return subtitles;
  },
);
