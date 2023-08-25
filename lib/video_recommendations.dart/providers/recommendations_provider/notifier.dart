import 'dart:async';
import 'dart:developer';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:lang_tube/video_recommendations.dart/providers/recommendations_provider/storage_manager.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../data/recommended_video.dart';
import '../../data/video_recommendations.dart';
import '../../difficulty_ranker/ranker.dart';

class RecommendationsNotifier extends ChangeNotifier {
  RecommendationsNotifier({
    required Stream<RecommendedVideo> observedVideos,
    required VideoClicker clicker,
  }) : _storageManager = RecommendationsStorageManager(clicker: clicker) {
    Timer.periodic(const Duration(seconds: 20), (_) async {
      assert((await _storageManager.retrieveRecommendations())
              .first
              .videos
              .length <=
          recommendationsList.first.videos.length);
      await _storageManager.saveRecommendations(
        recommendationsList: recommendationsList,
      );
    });
    _storageManager.retrieveRecommendations().then((recommendations) {
      _recommendationsList.addAll(recommendations);
      notifyListeners();
    });

    _observedVideosSubscription = observedVideos.listen(
      (video) {
        log("adding video ${video.title}");
        _addVideo(video);
      },
      onDone: () => log("observed videos stream is finnished"),
    );
  }
  final RecommendationsStorageManager _storageManager;
  late final StreamSubscription<RecommendedVideo> _observedVideosSubscription;

  final _recommendationsList = <VideoRecommendations>[];
  List<VideoRecommendations> get recommendationsList =>
      List.unmodifiable(_recommendationsList);

  void fetchMore() {
    notifyListeners();
  }

  Future<void> _addVideo(RecommendedVideo video) async {
    if (video.thumbnailUrl.isEmpty) {
      return log("${video.title} discarded no thumbnail");
    }
    if (_recommendationsList.containsVideo(video)) {
      return log("${video.title} already present");
    }

    // fetch the Video recommendations whose source tab is
    // the same as the video's source tab
    final tabRecommendationsIndex = _recommendationsList.indexWhere(
      (recommendation) => recommendation.sourceTab == video.sourceTab,
    );
    // in case recommendation eixts for video tab
    if (tabRecommendationsIndex != -1) {
      final tabRecommendations = _recommendationsList[tabRecommendationsIndex];
      final index = await VideosDifficultyRanker.determineVideoIndex(
        videos: tabRecommendations.videos,
        newVideo: video,
      );
      _recommendationsList[tabRecommendationsIndex] =
          tabRecommendations.copyWith(
        videos: List.from(tabRecommendations.videos)..insert(index, video),
      );
    } else {
      // create new VideoRecommendation for the tab
      _recommendationsList.add(
        VideoRecommendations(sourceTab: video.sourceTab, videos: [video]),
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _observedVideosSubscription.cancel();
    _recommendationsList.addAll(_recommendationsList);
    super.dispose();
  }
}

extension on List<VideoRecommendations> {
  bool containsVideo(RecommendedVideo video) {
    for (var recommendations in this) {
      for (var recommendedVideo in recommendations.videos) {
        if (recommendedVideo.title == video.title) {
          return true;
        }
      }
    }
    return false;
  }
}
