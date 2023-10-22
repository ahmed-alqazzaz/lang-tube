import 'package:lang_tube/data/video_recommendations/recommended_video.dart';

extension VideosDifficultyRankerr on List<RecommendedVideo> {
  void sortByDifficulty() => sort(
        (video1, video2) =>
            _compareDifficulty(video1: video1, video2: video2) ? 1 : -1,
      );

  void insertNewVideo({required RecommendedVideo newVideo}) =>
      insert(_determineVideoIndex(newVideo: newVideo), newVideo);

  int _determineVideoIndex({required RecommendedVideo newVideo}) {
    var low = 0;
    var high = length;
    while (low < high) {
      final mid = low + ((high - low) ~/ 2);
      if (_compareDifficulty(video1: newVideo, video2: this[mid])) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  // returns true if video1 is more difficult than video2
  static bool _compareDifficulty(
      {required RecommendedVideo video1, required RecommendedVideo video2}) {
    double score = 0.0;
    // in case text complexity of current video is less than the other
    if (video1.subtitlesComplexity
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
