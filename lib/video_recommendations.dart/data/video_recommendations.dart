// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:youtube_scraper/youtube_scraper.dart';
import 'recommended_video.dart';

class VideoRecommendationsPackage {
  final String sourceTab;
  final List<RecommendedVideo> videos;

  VideoRecommendationsPackage({
    required this.sourceTab,
    required List<RecommendedVideo>? videos,
  }) : videos = videos ?? [];

  @override
  String toString() =>
      'VideoRecommendations(sourceTab: $sourceTab, _videos: $videos)';

  @override
  bool operator ==(covariant VideoRecommendationsPackage other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.sourceTab == sourceTab && listEquals(other.videos, videos);
  }

  @override
  int get hashCode => sourceTab.hashCode ^ videos.hashCode;

  VideoRecommendationsPackage copyWith({
    String? sourceTab,
    List<RecommendedVideo>? videos,
  }) {
    return VideoRecommendationsPackage(
      sourceTab: sourceTab ?? this.sourceTab,
      videos: videos ?? videos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceTab': sourceTab,
      'videos': videos.map((x) => x.toMap()).toList(),
    };
  }

  factory VideoRecommendationsPackage.fromMap(
      {required Map<String, dynamic> map, required VideoClicker clicker}) {
    return VideoRecommendationsPackage(
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
