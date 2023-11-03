import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/video_recommendations/recommended_video.dart';
import 'package:lang_tube/video_recommendations.dart/utils/language_filter.dart';
import 'package:lang_tube/video_recommendations.dart/utils/ranker.dart';
import 'package:lang_tube/video_recommendations.dart/recommendations_manager/recommendations_state.dart';
import 'package:lang_tube/video_recommendations.dart/utils/diversity_score.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

typedef NavigationDepthCallback = int Function();
typedef RecommendationsCallback = Iterable<RecommendedVideo> Function();

class YoutubeRecommendationsStateNotifier
    extends StateNotifier<YoutubeRecommendationsState> {
  late final StreamSubscription<Iterable<ObservedVideo>>
      _videosObserverSubscription;

  YoutubeRecommendationsStateNotifier({
    required Stream<Iterable<ObservedVideo>> observedVideos,
    required RecommendationsCallback recommendationsCallback,
    required NavigationDepthCallback navigationDepthCallback,
  }) : super(YoutubeRecommendationsState.optimal()) {
    _videosObserverSubscription = observedVideos.listen(
      (videos) {
        final recommendations = recommendationsCallback().toList()
          ..sortByDifficulty();
        final targetLangaugeVideos = videos.toList().filteredByTargetLanguage;

        if (videos.isEmpty) {
          state = YoutubeRecommendationsState.emptyFeed();
        } else if (navigationDepthCallback() > _maxClickDepth) {
          state = YoutubeRecommendationsState.navigationOutOfControl();
        } else if (targetLangaugeVideos.length < videos.length) {
          state = YoutubeRecommendationsState.languageMismatch(
            mostRelevantVideo: recommendations.first,
          );
        } else if (targetLangaugeVideos.diversityScore < 0.5) {
          state = YoutubeRecommendationsState.lowDiversity();
        } else {
          state = YoutubeRecommendationsState.optimal();
        }
      },
    );
  }

  @override
  void dispose() {
    _videosObserverSubscription.cancel();
    super.dispose();
  }

  static const int _maxClickDepth = 3;
}
