import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../data/recommended_videos.dart';
import '../../data/video_recommendations.dart';

class RecommendationsNotifier extends ChangeNotifier {
  RecommendationsNotifier({required Stream<RecommendedVideo> observedVideos}) {
    _observedVideosSubscription = observedVideos.listen(
      (video) {
        log("adding video $video");
        _addVideo(video);
      },
      onError: (error) => log("observedVideosError ${error.toString()}"),
      onDone: () => log("observed videos stream is finnished"),
    );
  }
  late final StreamSubscription<RecommendedVideo> _observedVideosSubscription;

  final _recommendationsList = <VideoRecommendations>[];
  List<VideoRecommendations> get recommendationsList =>
      List.unmodifiable(_recommendationsList);

  void fetchMore() {
    notifyListeners();
  }

  Future<void> _addVideo(RecommendedVideo video) async {
    // fetch the Video recommendations whose source tab is
    // the same as the video's source tab
    final tabRecommendations = _recommendationsList.firstWhereOrNull(
      (recommendation) => recommendation.sourceTab == video.sourceTab,
    );

    // in case recommendation eixts for video tab
    if (tabRecommendations != null) {
      tabRecommendations.addVideo(video);
    } else {
      // create new VideoRecommendation for the tab
      _recommendationsList.add(
        VideoRecommendations(sourceTab: video.sourceTab)..addVideo(video),
      );
    }
  }

  @override
  void dispose() {
    _observedVideosSubscription.cancel();
    super.dispose();
  }
}
