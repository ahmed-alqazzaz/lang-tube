import 'rust_bridge/parsed_subtitle.dart';

extension DurationSanitizer on List<ParsedSubtitle> {
  Iterable<ParsedSubtitle> santitizeDurations() sync* {
    for (int index = 0; index < length - 1; index++) {
      final subtitle = this[index];
      final consecutiveSubtitle = this[index + 1];

      yield subtitle.end > consecutiveSubtitle.start ||
              subtitle.end <= subtitle.start
          ? subtitle.copyWith(end: consecutiveSubtitle.start)
          : subtitle;
    }
  }
}
