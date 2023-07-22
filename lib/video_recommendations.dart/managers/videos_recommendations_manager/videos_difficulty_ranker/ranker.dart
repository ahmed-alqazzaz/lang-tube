import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/extensions/subtitles_complexity.dart';
import 'package:lang_tube/video_recommendations.dart/managers/videos_recommendations_manager/extensions/subtitles_speed.dart';

import 'constants.dart';
import '../data/youtube_video.dart';
export '../data/youtube_video.dart';

// sorts recommendations acording to difficulty (from easiest to hardest)
// dificulty criteria includes (subtitles complexity, syllables per second and CEFR level)
class VideosDifficultyRanker {
  VideosDifficultyRanker();

  final _recommendations = <YoutubeVideo>[];
  List<YoutubeVideo> get recommendations => List.unmodifiable(_recommendations);

  Future<void> addVideo(YoutubeVideo video) async {
    if (!recommendations.contains(video)) return;
    final index = await _determineVideoIndex(video);
    _recommendations.insert(index, video);
  }

  // binary search to find the suitable
  // index of the new added video
  Future<int> _determineVideoIndex(YoutubeVideo newVideo) async {
    var low = 0;
    var high = _recommendations.length;
    while (low < high) {
      final mid = low + ((high - low) ~/ 2);
      if (await _compareDifficulty(
          video1: newVideo, video2: recommendations[mid])) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  // returns true if video1 is more difficult than video2
  Future<bool> _compareDifficulty({
    required YoutubeVideo video1,
    required YoutubeVideo video2,
  }) async {
    double score = 0.0;
    // in case text complexity of current video is less than the other
    if (await (await video1.subtitlesComplexity)
        .compareTo(other: await video2.subtitlesComplexity)) {
      score += readabilityWeight;
    }
    // in case current video is slower than the other video
    if (await video1.syllablesPerMillisecond >
        await video2.syllablesPerMillisecond) {
      score += speedWeight;
    }

    // in case current video cefr level is lower than the other
    if (video1.cefrLevel.index < video2.cefrLevel.index) {
      score += cefrWeight;
    }
    return score >= 0.4;
  }
}
