import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/video_recommendations_provider/video_recommendation_provider.dart';

import '../youtube_scraper/youtube_player_scraper.dart';

class YoutubeVideoRecommendationsView extends ConsumerWidget {
  const YoutubeVideoRecommendationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer.periodic(const Duration(seconds: 5),
        (timer) => ref.read(videoRecommendationsProvider.notifier).refresh());
    final recommendations = ref.watch(videoRecommendationsProvider);
    log("subtitles ${recommendations.forYou.map((e) => e.item.title).firstOrNull}");
    return Scaffold(
        body: SizedBox(
      child: YoutubePlayerScraper.sharedInstance().webview,
    ));
  }
}
