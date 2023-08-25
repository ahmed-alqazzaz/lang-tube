import 'dart:async';
import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/providers/youtube_scraper_provider/provider.dart';
import 'package:lang_tube/video_recommendations.dart/views/videos_list/videos_carousel/videos_carousel.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import '../../router/routes.dart';
import '../../youtube_scraper/data/youtube_video_item.dart';
import '../../youtube_scraper/youtube_player_scraper.dart';
import '../data/video_recommendations.dart';
import '../providers/recommendations_provider/provider.dart';
import '../providers/tabs_explorer_provider/provider.dart';
import 'videos_list/videos_carousel/carousel_video_item.dart';

class VideoRecommendationsView extends ConsumerStatefulWidget {
  const VideoRecommendationsView({super.key});

  @override
  ConsumerState<VideoRecommendationsView> createState() =>
      _VideoRecommendationsViewState();
}

class _VideoRecommendationsViewState
    extends ConsumerState<VideoRecommendationsView> {
  _VideoRecommendationsViewState() {
    Timer(
      const Duration(seconds: 40),
      () {
        printGreen("exploring tabs");
        //ref.read(tabsExplorerProvider.notifier).exploreInitialTabs();
      },
    );
  }
  Iterable<CarouselVideoItem> carouselItemsBuilder({
    required List<ObservedVideo> videoItems,
    required BuildContext context,
  }) =>
      videoItems.map(
        (video) => CarouselVideoItem(
          title: video.title,
          thumbnailUrl: video.thumbnailUrl,
          badges: video.badges..remove("•"), // remove first dot
          onPressed: () => YoutubePlayerRoute(id: video.id).push(context),
          onActionsMenuPressed: () {},
        ),
      );
  late final webview = ref.read(youtubeScraperProvider).webview;
  @override
  Widget build(BuildContext context) {
    final recommendationsNotifier = ref.watch(videoRecommendationsProvider);
    final recommendationsList = recommendationsNotifier.recommendationsList;
    log("length ${recommendationsList.firstOrNull?.videos.length}");
    Timer(const Duration(seconds: 5), () {
      ref.read(videoRecommendationsProvider.notifier).notifyListeners();
    });

    return Stack(
      children: [
        Scaffold(
            body: SafeArea(
          child: webview,
        )),
        if (false)
          Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.arrow_back_outlined),
              title: const Text("Explore"),
              actions: [
                CircularInkWell(
                  child: const Icon(Icons.search_outlined),
                  onTap: () {},
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return CustomScrollView(
                  slivers: [
                    if (recommendationsList.hasCustom)
                      SliverToBoxAdapter(
                        child: VideosCarousel(
                          topic: recommendationsList.first.sourceTab,
                          videoItems: carouselItemsBuilder(
                            videoItems: recommendationsList.first.videos,
                            context: context,
                          ).toList(),
                          useLargeLoadMoreButton: true,
                          onActionsMenuPressed: () {},
                          onLoadMore: () {},
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: constraints.maxHeight * 0.02),
                    ),
                    SliverList.separated(
                      itemCount: recommendationsList.length -
                          (recommendationsList.hasCustom ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: constraints.maxHeight * 0.015),
                      itemBuilder: (context, index) {
                        final recommendation = recommendationsList[
                            index + (recommendationsList.hasCustom ? 1 : 0)];
                        return VideosCarousel(
                          topic: recommendation.sourceTab,
                          videoItems: carouselItemsBuilder(
                            videoItems: recommendation.videos,
                            context: context,
                          ).toList(),
                          onActionsMenuPressed: () {},
                          onLoadMore: () {},
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

extension CustomFeedAvailabilty on List<VideoRecommendations> {
  bool get hasCustom {
    for (var element in this) {
      if (element.sourceTab == "All") return true;
    }
    return false;
  }
}
