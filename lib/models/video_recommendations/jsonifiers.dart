import 'dart:convert';

import 'package:lang_tube/data/video_recommendations/video_recommendations.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import 'recommended_video.dart';

// it's important to ensure that order of the elements stays the same
extension VideoRecommendationsListJsonifier
    on List<VideoRecommendationsPackage> {
  String toJson() {
    final List<Map<String, dynamic>> listMap =
        map((videoRec) => videoRec.toMap()).toList();
    return json.encode(listMap);
  }

  static Iterable<VideoRecommendationsPackage> fromJson(
          {required String source, required VideoClicker clicker}) =>
      (json.decode(source) as List<dynamic>).map(
        (map) => VideoRecommendationsPackage.fromMap(
          map: map as Map<String, dynamic>,
          clicker: clicker,
        ),
      );
}

extension VideoRecommendationsJsonifier on VideoRecommendationsPackage {
  String toJson() => json.encode(toMap());

  static VideoRecommendationsPackage fromJson(
          {required String source, required VideoClicker clicker}) =>
      VideoRecommendationsPackage.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
        clicker: clicker,
      );
}

extension RecommendedVideoJsonifier on RecommendedVideo {
  String toJson() => json.encode(toMap());

  static RecommendedVideo fromJson(
          {required String source, required VideoClicker clicker}) =>
      RecommendedVideo.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
        clicker: clicker,
      );
}
