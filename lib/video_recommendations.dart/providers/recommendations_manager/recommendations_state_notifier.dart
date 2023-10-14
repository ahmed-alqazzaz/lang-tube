import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_manager/recommendations_state.dart';
import 'package:lang_tube/video_recommendations.dart/utils/diversity_score.dart';
import 'package:lang_tube/video_recommendations.dart/utils/target_language_videos.dart';
import 'package:languages/languages.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

typedef NavigationDepthCallback = int Function();

class YoutubeRecommendationsStateNotifier
    extends StateNotifier<YoutubeRecommendationsState> {
  late final StreamSubscription<Iterable<ObservedVideo>>
      _videosObserverSubscription;

  YoutubeRecommendationsStateNotifier({
    required Stream<Iterable<ObservedVideo>> observedVideos,
    required NavigationDepthCallback navigationDepthCallback,
  }) : super(YoutubeRecommendationsState.optimal) {
    _videosObserverSubscription = observedVideos.listen(
      (videos) {
        final targetLangaugeVideos =
            videos.getTargetLanguageVideos(Language.english().pattern).toList();
        if (videos.isEmpty) {
          state = YoutubeRecommendationsState.emptyFeed;
        } else if (navigationDepthCallback() > _maxClickDepth) {
          state = YoutubeRecommendationsState.navigationOutOfControl;
        } else if (targetLangaugeVideos.length < videos.length) {
          state = YoutubeRecommendationsState.languageMismatch;
        } else if (targetLangaugeVideos.diversityScore < 0.5) {
          state = YoutubeRecommendationsState.lowDiversity;
        } else {
          state = YoutubeRecommendationsState.optimal;
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
