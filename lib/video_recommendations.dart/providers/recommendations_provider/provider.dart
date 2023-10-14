import 'dart:developer';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_readability_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/difficulty_ranker/subtitles_speed_calculator.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_provider/notifier.dart';
import 'package:lang_tube/video_recommendations.dart/utils/target_language_videos.dart';
import 'package:languages/languages.dart';
import '../../../subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import '../../../utils/cefr.dart';
import '../../data/recommended_video.dart';
import '../youtube_scraper_provider/provider.dart';

final videoRecommendationsProvider = ChangeNotifierProvider((ref) {
  final youtubeScraper = ref.read(youtubeScraperProvider);
  final subtitlesScraperCallback = ref.read(subtitlesScraperProvider.future);
  return RecommendationsNotifier(
    clicker: (videoId) => youtubeScraper.interactionsController.clickVideoById(
      videoId: videoId,
    ),
    observedVideos: youtubeScraper.observedVideos.asyncExpand(
      (videos) async* {
        final subtitlesScraper = await subtitlesScraperCallback;
        final targetLanguageVideos =
            videos.getTargetLanguageVideos(Language.english().pattern);
        for (final video in targetLanguageVideos) {
          log("scraping subtitles");

          final subtitlesData = await subtitlesScraper
              .scrapeSubtitles(
                youtubeVideoId: video.id,
                language: Language.english(),
              )
              .then((value) => value?.first);

          if (subtitlesData != null) {
            yield RecommendedVideo.fromObservedVideo(
              video: video,
              subtitlesComplexity: await subtitlesData.subtitlesComplexity,
              syllablesPerMillisecond:
                  await subtitlesData.avgerageSyllablesPerMillisecond,
              cefr: CEFR.a1,
            );
          } else {
            printRed("${video.title} has no subtitles");
          }
        }
      },
    ),
  );
});
