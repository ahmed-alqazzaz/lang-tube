// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

@immutable
class YoutubeRecommendationsState {
  const YoutubeRecommendationsState._();

  factory YoutubeRecommendationsState.optimal() => const Optimal();
  factory YoutubeRecommendationsState.emptyFeed() => const EmptyFeed();
  factory YoutubeRecommendationsState.lowDiversity() => const LowDiversity();
  factory YoutubeRecommendationsState.navigationOutOfControl() =>
      const NavigationOutOfControl();
  factory YoutubeRecommendationsState.languageMismatch(
          {required ObservedVideo mostRelevantVideo}) =>
      LanguageMismatch(mostRelevantVideo);
}

class Optimal extends YoutubeRecommendationsState {
  const Optimal() : super._();
}

class EmptyFeed extends YoutubeRecommendationsState {
  const EmptyFeed() : super._();
}

class LowDiversity extends YoutubeRecommendationsState {
  const LowDiversity() : super._();
}

class ShortHistory extends YoutubeRecommendationsState {
  const ShortHistory() : super._();
}

class NavigationOutOfControl extends YoutubeRecommendationsState {
  const NavigationOutOfControl() : super._();
}

class LanguageMismatch extends YoutubeRecommendationsState {
  final ObservedVideo mostRelevantVideo;
  const LanguageMismatch(this.mostRelevantVideo) : super._();
}
