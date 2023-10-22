import 'package:subtitles_player/src/data/subtitle.dart';

extension DurationSearch on List<Subtitle> {
  Subtitle? getSubtitleByDuration(Duration duration) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);
      Subtitle currentSubtitle = this[mid];
      if (currentSubtitle.end > duration && currentSubtitle.start <= duration) {
        return currentSubtitle;
      } else if (currentSubtitle.end <= duration) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return null;
  }
}
