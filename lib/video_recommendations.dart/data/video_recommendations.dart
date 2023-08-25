// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import 'recommended_video.dart';

class VideoRecommendations {
  final String sourceTab;
  final List<RecommendedVideo> _videos;
  List<RecommendedVideo> get videos => List.unmodifiable(_videos);

  VideoRecommendations({
    required this.sourceTab,
    required List<RecommendedVideo>? videos,
  }) : _videos = videos ?? [];

  @override
  String toString() =>
      'VideoRecommendations(sourceTab: $sourceTab, _videos: $_videos)';

  @override
  bool operator ==(covariant VideoRecommendations other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.sourceTab == sourceTab && listEquals(other._videos, _videos);
  }

  @override
  int get hashCode => sourceTab.hashCode ^ _videos.hashCode;

  VideoRecommendations copyWith({
    String? sourceTab,
    List<RecommendedVideo>? videos,
  }) {
    return VideoRecommendations(
      sourceTab: sourceTab ?? this.sourceTab,
      videos: videos ?? _videos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceTab': sourceTab,
      'videos': _videos.map((x) => x.toMap()).toList(),
    };
  }

  factory VideoRecommendations.fromMap(
      {required Map<String, dynamic> map, required VideoClicker clicker}) {
    return VideoRecommendations(
      sourceTab: map['sourceTab'] as String,
      videos: (map['videos'] as List<dynamic>)
          .map(
            (videoMap) => RecommendedVideo.fromMap(
              map: videoMap as Map<String, dynamic>,
              clicker: clicker,
            ),
          )
          .toList(),
    );
  }
}
