import 'dart:async';
import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readability/readability.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import '../models/miscellaneous/cefr.dart';
import '../models/video_recommendations/recommended_video.dart';
import '../router/routes.dart';
import '../models/video_recommendations/video_recommendations.dart';
import '../video_widgets/display_video_item.dart';
import '../video_widgets/videos_carousel.dart';
import 'recommendations_manager/manager.dart';

class VideoRecommendationsView extends ConsumerStatefulWidget {
  const VideoRecommendationsView({super.key});

  @override
  ConsumerState<VideoRecommendationsView> createState() =>
      _VideoRecommendationsViewState();
}

class _VideoRecommendationsViewState
    extends ConsumerState<VideoRecommendationsView> {
  final recommendationsProvider = StreamProvider((ref) async* {
    await for (final recommendation
        in YoutubeRecommendationsManager.instance.recommendations) {
      yield recommendation;
    }
  });
  _VideoRecommendationsViewState();
  @override
  void initState() {
    // ReceiveSharingIntent.getInitialText().then((value) => value != null
    //     ? YoutubePlayerRoute(id: YoutubePlayer.convertUrlToId(value)!)
    //         .push(context)
    //     : null);
    // ReceiveSharingIntent.getTextStream().listen((url) {
    //   log(url.toString() + "9");
    //   YoutubePlayerRoute(id: YoutubePlayer.convertUrlToId(url)!).push(context);
    // });

    super.initState();
  }

  Iterable<DisplayVideoItem> carouselItemsBuilder({
    required List<ObservedVideo> videoItems,
    required BuildContext context,
  }) =>
      videoItems.map(
        (video) => DisplayVideoItem(
          id: video.id,
          title: video.title,
          thumbnailUrl: video.thumbnailUrl,
          lastWatched: DateTime.now(),
          duration: video.duration,
          badges: List.from(video.badges)..remove('•'), // remove first dot
          onPressed: () => YoutubePlayerRoute(id: video.id).push(context),
          onActionsMenuPressed: () {},
        ),
      );
  //late final webview = ref.read(youtubeScraperProvider).webview;
  @override
  Widget build(BuildContext context) {
    final recommendationsList = videoRecommendationsList;

    return Stack(
      children: [
        // Scaffold(
        //     body: SafeArea(
        //   child: YoutubeRecommendationsManager.instance.webView,
        // )),
        Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.arrow_back_outlined),
            title: const Text('Explore'),
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

extension CustomFeedAvailabilty on List<VideoRecommendationsPackage> {
  bool get hasCustom {
    for (var element in this) {
      if (element.sourceTab == 'All') return true;
    }
    return false;
  }
}

final subComplexity = ReadabilityScore(
  lixIndex: 1.3821138211382114,
  rixIndex: 235.0,
  automatedReadabilityIndex: 311.0521463414634,
  colemanLiauIndex: 15.378828251409427,
  rawMetrics: TextMetrics(
    wordsCount: 1,
    sentencesCount: 1,
    longWordsCount: 1,
    longWordsPercentage: 1,
    charsCount: 5,
    avgSylCount: 1,
    sentenceAvgWordcount: 1,
    polysyllableCount: 1,
  ),
  fleschKincaidGrade: 1,
  gunningFoxIndex: 1,
  smogIndex: 1,
);
final videoRecommendationsList = [
  VideoRecommendationsPackage(
    sourceTab: 'All',
    videos: [
      RecommendedVideo(
        duration: '1.12',
        id: 'QYlVJlmjLEc',
        title: "Fantastic Features We Don't Have In The English Language",
        channelIconUrl:
            'https://yt3.ggpht.com/ytc/AOPolaR9zi_hlH8MQ80WIyB3qcDsqGvcJY2f-HoPcS_gtg=s68-c-k-c0x00ffffff-no-rj',
        thumbnailUrl:
            'https://i.ytimg.com/vi/QYlVJlmjLEc/hq720.jpg?sqp=-oaymwEcCK4FEIIDSEbyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD9oJICxee6Sdw_0m2-zRkor27inQ',
        sourceTab: 'All',
        badges: const ['Tom Scott', '6.7M views', '10 years ago'],
        subtitlesComplexity: subComplexity,
        syllablesPerMillisecond: 0.005446734798853308,
        cefr: CEFR.a1,
        onClick: () {},
      ),
      RecommendedVideo(
          duration: '1.12',
          id: 'JprFkj55dPA',
          title: 'Speedrunning Duolingo Chinese (and then it escalates)',
          channelIconUrl: '',
          thumbnailUrl:
              'https://i.ytimg.com/vi/JprFkj55dPA/hq720.jpg?sqp=-oaymwEcCK4FEIIDSEbyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBXkkkD2GErvX_uybYEBcyFuG5kCA',
          sourceTab: 'All',
          badges: const ['Ying - 莺', '6.1M views', '2 years ago'],
          subtitlesComplexity: subComplexity,
          syllablesPerMillisecond: 0.004752283210484457,
          cefr: CEFR.a1,
          onClick: () {}),
      RecommendedVideo(
        duration: '1.12',
        id: 'JnB376DCLXo',
        title:
            'Homophones/ Homographs/ Homonyms #english #englishlearning #englishspeaking #iloveenglish',
        channelIconUrl:
            'https://yt3.ggpht.com/6Zka8keJ0OC8u7OIPpelBqRCv8EVVgLX2auwfz5Irq-IyPVwOsv1FuPVZMVh8z4QeMYB_tuVHf0=s68-c-k-c0x00ffffff-no-rj',
        thumbnailUrl:
            'https://i.ytimg.com/vi/JnB376DCLXo/hq720.jpg?sqp=-oaymwE2CK4FEIIDSEbyq4qpAygIARUAAIhCGAFwAcABBvABAfgBzgWAAoAKigIMCAAQARhyIEIoOzAP&rs=AOn4CLAh6R__vnPbKTbjXw8Y0HisKMcosA',
        sourceTab: 'All',
        badges: const ['English idioms with YY', '9 views', '1 day ago'],
        subtitlesComplexity: subComplexity,
        syllablesPerMillisecond: 0.003484301961865772,
        cefr: CEFR.a1,
        onClick: () {},
      ),
    ],
  ),
  for (int i = 0; i < 2; i++)
    VideoRecommendationsPackage(
      sourceTab: 'Kurzgesagt – In a Nutshell',
      videos: [
        RecommendedVideo(
          duration: '1.12',
          onClick: () {},
          id: 'xAUJYP8tnRE',
          title: 'Why We Should NOT Look For Aliens - The Dark Forest',
          channelIconUrl:
              'https://yt3.ggpht.com/ytc/AOPolaRZ9DHwcU8O9Z7p5yH6KvKHKwpU7ZHlWCXLkKN62A=s68-c-k-c0x00ffffff-no-rj',
          thumbnailUrl:
              'https://i.ytimg.com/vi/xAUJYP8tnRE/hq720.jpg?sqp=-oaymwEcCK4FEIIDSEbyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCZebi5hnWeq6h9pLMpzHcTx9RplA',
          sourceTab: 'Kurzgesagt – In a Nutshell',
          badges: const [
            'Kurzgesagt – In a Nutshell',
            '14M views',
            '1 year ago'
          ],
          subtitlesComplexity: subComplexity,
          syllablesPerMillisecond: 0.004332567306538956,
          cefr: CEFR.a1,
        ),
        RecommendedVideo(
          duration: '1.12',
          onClick: () {},
          id: 'LxgMdjyw8uw',
          title: 'We WILL Fix Climate Change!',
          channelIconUrl:
              'https://yt3.ggpht.com/ytc/AOPolaRZ9DHwcU8O9Z7p5yH6KvKHKwpU7ZHlWCXLkKN62A=s68-c-k-c0x00ffffff-no-rj',
          thumbnailUrl:
              'https://i.ytimg.com/vi/LxgMdjyw8uw/hq720.jpg?sqp=-oaymwEcCK4FEIIDSEbyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBcxbCjj5U0c0z8RJwHoBii2gw_qg',
          sourceTab: 'Kurzgesagt – In a Nutshell',
          badges: const [
            'Kurzgesagt – In a Nutshell',
            '10M views',
            '1 year ago'
          ],
          subtitlesComplexity: subComplexity,
          syllablesPerMillisecond: 0.00459516601227723,
          cefr: CEFR.a1,
        ),
      ],
    ),
  // Add more VideoRecommendations instances for other source tabs
];
