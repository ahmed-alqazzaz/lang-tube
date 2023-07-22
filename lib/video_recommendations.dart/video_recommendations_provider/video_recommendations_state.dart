import 'package:flutter/foundation.dart';

import '../managers/videos_recommendations_manager/data/youtube_video.dart';

@immutable
class VideoRecommendations {
  const VideoRecommendations({
    required this.forYou,
    required this.entertainment,
    required this.gaming,
  });
  factory VideoRecommendations.empty() =>
      const VideoRecommendations(forYou: [], entertainment: [], gaming: []);

  final List<YoutubeVideo> forYou;
  final List<YoutubeVideo> entertainment;
  final List<YoutubeVideo> gaming;
}
