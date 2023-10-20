import 'rust_bridge/api.dart';

extension DurationSanitizer on List<ParsedSubtitle> {
  Iterable<ParsedSubtitle> santitizeDurations() sync* {
    for (int index = 0; index < length - 1; index++) {
      final subtitle = this[index];
      final consecutiveSubtitle = this[index + 1];
      if (subtitle.end <= consecutiveSubtitle.start) {
        yield subtitle;
      } else {
        yield subtitle.copyWith(end: consecutiveSubtitle.start);
      }
    }
  }
}
