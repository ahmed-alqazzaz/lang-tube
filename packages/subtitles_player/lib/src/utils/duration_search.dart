import 'dart:developer';

import 'package:subtitles_player/src/models/subtitle.dart';
import 'dart:math' as math;

extension DurationSearch on List<Subtitle> {
  int getClosestIndexByDuration(Duration duration) {
    final index = getIndexByDuration(duration);
    if (index != null) return index;
    int closestIndex = 0;
    Duration closestDistance = const Duration(days: 1);

    for (int i = 0; i < length; i++) {
      final distance = math.min(
        (this[i].start - duration).abs().inMicroseconds,
        (this[i].end - duration).abs().inMicroseconds,
      );
      if (distance < closestDistance.inMicroseconds) {
        closestDistance = Duration(microseconds: distance);
        closestIndex = i;
      }
    }
    print("closest $closestIndex $closestDistance");
    return closestIndex;
  }

  int? getIndexByDuration(Duration duration) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);
      Subtitle currentSubtitle = this[mid];
      if (currentSubtitle.end > duration && currentSubtitle.start <= duration) {
        return mid;
      } else if (currentSubtitle.end <= duration) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return null;
  }

  Subtitle? getSubtitleByDuration(Duration duration) {
    final index = getIndexByDuration(duration);
    return index != null ? this[index] : null;
  }
}
