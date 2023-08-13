// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:collection/collection.dart';

import 'recommended_videos.dart';

class VideoRecommendations {
  final String sourceTab;
  final _videos = <RecommendedVideo>[];
  List<RecommendedVideo> get videos => List.unmodifiable(_videos);
  VideoRecommendations({required this.sourceTab});

  Future<void> addVideo(RecommendedVideo video) async {
    if (video.thumbnailUrl.isEmpty || _videos.isVideoPresent(video)) {
      log("${video.title} discarded");
      return;
    }
    //final index = await _determineVideoIndex(video);
    _videos.add(video);
  }

  @override
  String toString() =>
      'VideoRecommendation(topic: $sourceTab, videos: $_videos)';

  @override
  bool operator ==(covariant VideoRecommendations other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.sourceTab == sourceTab && listEquals(other._videos, _videos);
  }

  @override
  int get hashCode => sourceTab.hashCode ^ _videos.hashCode;
}

extension on List<RecommendedVideo> {
  bool isVideoPresent(RecommendedVideo video) {
    for (var element in this) {
      if (element.title == video.title) {
        return true;
      }
    }
    return false;
  }
}
