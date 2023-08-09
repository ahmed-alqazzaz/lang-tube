import 'dart:async';
import 'dart:developer';

import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/videos_difficulty_ranker/ranker.dart';

class VideosRecommendationsManager {
  VideosRecommendationsManager(Stream<YoutubeVideo> observedVideos) {
    observedVideosSubscription = observedVideos.listen(
      (video) {
        log('title ${video.item.title}');

        //_addVideo(video);
      },
      onError: (error) => log(error.toString()),
      onDone: () => log("stream is finnished"),
    );
  }

  final _recommendationsRanker = VideosDifficultyRanker();
  late final StreamSubscription<YoutubeVideo> observedVideosSubscription;
  void _addVideo(YoutubeVideo video) => _recommendationsRanker.addVideo(video);
  List<YoutubeVideo> get recommendations {
    // TODO: choose based on level
    return _recommendationsRanker.recommendations;
  }

  static YoutubeVideo findMostRelevantVideo(List<YoutubeVideo> videos) {
    throw UnimplementedError();
    // new instance of recommendations manager
    // final recommendationsManager =
    //     VideosRecommendationsManager(Stream.fromIterable(videos));

    //return recommendationsManager.recommendations.first;
  }
}
