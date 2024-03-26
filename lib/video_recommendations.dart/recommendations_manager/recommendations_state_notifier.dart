import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/diversity_score.dart';
import '../utils/language_filter.dart';
import '../utils/ranker.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../models/video_recommendations/recommended_video.dart';
import 'recommendations_state.dart';

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
