import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/videos_recommendations_manager.dart';
import 'package:lang_tube/video_recommendations.dart/video_recommendations_provider/video_recommendations_state.dart';

class VideoRecommendationsNotifier extends StateNotifier<VideoRecommendations> {
  VideoRecommendationsNotifier({required this.recommendationsManager})
      : super(VideoRecommendations.empty());

  final VideosRecommendationsManager recommendationsManager;
  void refresh() {
    state = VideoRecommendations(
      forYou: recommendationsManager.recommendations,
      entertainment: const [],
      gaming: const [],
    );
  }

  void fetchMore() {}
}
