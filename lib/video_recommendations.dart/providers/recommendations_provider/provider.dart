import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_complexity.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_speed.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_provider/notifier.dart';
import 'package:lang_tube/video_recommendations.dart/providers/youtube_scraper_provider.dart';
import 'package:languages/languages.dart';

import '../../../subtitles_player/providers/subtitles_scraper_provider/data/exceptions.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import '../../../utils/cefr.dart';
import '../../data/recommended_videos.dart';

final videoRecommendationsProvider = ChangeNotifierProvider((ref) {
  final youtubeScraper = ref.read(youtubeScraperProvider);
  final subtitlesScraperCallback = ref.read(subtitlesScraperProvider.future);
  return RecommendationsNotifier(
    observedVideos: youtubeScraper.observedVideos.asyncExpand(
      (videoItems) async* {
        final subtitlesScraper = await subtitlesScraperCallback;
        for (final item in videoItems) {
          try {
            final subtitlesData = await subtitlesScraper
                .scrapeSubtitles(
                  youtubeVideoId: item.videoId,
                  language: Language.english(),
                )
                .then((value) => value.first);

            yield RecommendedVideo.fromVideoItem(
              item: item,
              subtitlesComplexity: await subtitlesData.subtitlesComplexity,
              syllablesPerMillisecond:
                  await subtitlesData.avgerageSyllablesPerMillisecond,
              cefr: CEFR.a1,
            );
          } on SubtitlesScraperNoCaptionsFoundException catch (_) {
            log("${item.title} has no subtitles");
          }
        }
      },
    ),
  );
});
