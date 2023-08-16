// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

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

  Future<VideoRecommendations> addVideo(RecommendedVideo video) async {
    if (video.thumbnailUrl.isEmpty) {
      log("${video.title} discarded no thumbnail");
      return VideoRecommendations(
        sourceTab: sourceTab,
        videos: List.from(_videos),
      );
    }
    if (_videos.isVideoPresent(video)) {
      log("${video.title} already present");
      return VideoRecommendations(
        sourceTab: sourceTab,
        videos: List.from(_videos),
      );
    }
    //final index = await _determineVideoIndex(video);
    return VideoRecommendations(
      sourceTab: sourceTab,
      videos: List.from(_videos)..add(video),
    );
  }

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
  String toJson() => json.encode(toMap());

  factory VideoRecommendations.fromJson(
          {required String source, required VideoClicker clicker}) =>
      VideoRecommendations.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
        clicker: clicker,
      );
}

extension VideoRecommendationsListExtension on List<VideoRecommendations> {
  String toJson() {
    final List<Map<String, dynamic>> listMap =
        map((videoRec) => videoRec.toMap()).toList();
    return json.encode(listMap);
  }

  static Iterable<VideoRecommendations> fromJson(
          {required String source, required VideoClicker clicker}) =>
      (json.decode(source) as List<dynamic>).map(
        (map) => VideoRecommendations.fromMap(
          map: map as Map<String, dynamic>,
          clicker: clicker,
        ),
      );
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
