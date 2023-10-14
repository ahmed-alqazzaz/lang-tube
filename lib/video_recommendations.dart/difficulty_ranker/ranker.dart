import 'package:lang_tube/video_recommendations.dart/data/recommended_video.dart';

extension VideosDifficultyRankerr on List<RecommendedVideo> {
  Future<void> insertNewVideo({required RecommendedVideo newVideo}) async =>
      insert(await _determineVideoIndex(newVideo: newVideo), newVideo);

  Future<int> _determineVideoIndex({required RecommendedVideo newVideo}) async {
    var low = 0;
    var high = length;
    while (low < high) {
      final mid = low + ((high - low) ~/ 2);
      if (await _compareDifficulty(video1: newVideo, video2: this[mid])) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  // returns true if video1 is more difficult than video2
  static Future<bool> _compareDifficulty({
    required RecommendedVideo video1,
    required RecommendedVideo video2,
  }) async {
    double score = 0.0;
    // in case text complexity of current video is less than the other
    if (await video1.subtitlesComplexity
        .compareTo(other: video2.subtitlesComplexity)) {
      score += readabilityWeight;
    }
    // in case current video is slower than the other video
    if (video1.syllablesPerMillisecond > video2.syllablesPerMillisecond) {
      score += speedWeight;
    }

    // in case current video cefr level is lower than the other
    if (video1.cefr.index < video2.cefr.index) {
      score += cefrWeight;
    }
    return score >= 0.4;
  }

  static const double readabilityWeight = 0.2;
  static const double speedWeight = 0.4;
  static const double cefrWeight = 0.4;
}

class VideosDifficultyRanker {
  // binary search to find the suitable
  // index of the new added video
  static Future<int> determineVideoIndex({
    required List<RecommendedVideo> videos,
    required RecommendedVideo newVideo,
  }) async {
    var low = 0;
    var high = videos.length;
    while (low < high) {
      final mid = low + ((high - low) ~/ 2);
      if (await _compareDifficulty(video1: newVideo, video2: videos[mid])) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  static RecommendedVideo findMostRelevantVideo(List<RecommendedVideo> videos) {
    throw UnimplementedError();
  }

  // returns true if video1 is more difficult than video2
  static Future<bool> _compareDifficulty({
    required RecommendedVideo video1,
    required RecommendedVideo video2,
  }) async {
    double score = 0.0;
    // in case text complexity of current video is less than the other
    if (await video1.subtitlesComplexity
        .compareTo(other: video2.subtitlesComplexity)) {
      score += readabilityWeight;
    }
    // in case current video is slower than the other video
    if (video1.syllablesPerMillisecond > video2.syllablesPerMillisecond) {
      score += speedWeight;
    }

    // in case current video cefr level is lower than the other
    if (video1.cefr.index < video2.cefr.index) {
      score += cefrWeight;
    }
    return score >= 0.4;
  }

  static const double readabilityWeight = 0.2;
  static const double speedWeight = 0.4;
  static const double cefrWeight = 0.4;
}
