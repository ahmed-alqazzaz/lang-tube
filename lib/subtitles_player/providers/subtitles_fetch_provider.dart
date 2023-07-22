import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider.dart';
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
    final subtitlesScraper = await ref.read(subtitlesScraperProvider.future);
    final subtitles = await subtitlesScraper.getSubtitle(
      youtubeVideoId: args.videoId,
      languages: (
        mainLanguage: args.mainLanguage,
        translatedLanguage: args.translatedLanguage,
      ),
    );
    log("$subtitles");
    subtitlesFetchProviderKeepAliveLink = ref.keepAlive();
    return subtitles;
  },
);
