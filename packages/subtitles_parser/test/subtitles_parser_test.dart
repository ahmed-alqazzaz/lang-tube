import 'package:flutter_test/flutter_test.dart';
import 'package:subtitles_parser/subtitles_parser.dart';

import 'subtitles.dart';

void main() {
  final rawSubtitlesList = [
    fireshipSubtitles,
    lucySubtitles,
    marinaSubtitles,
    rachelSubtitles,
    germanSubtitles
  ];
  final timer = Stopwatch()..start();
  final parsedSubtitlesList = [
    for (String rawSubtitles in rawSubtitlesList) parseSubtitles(rawSubtitles)
  ];
  print("lasted ${timer.elapsedMilliseconds}");
  test('Parsing subtitles should return a non-empty list', () {
    for (List<Subtitle> parsedSubtitles in parsedSubtitlesList) {
      expect(parsedSubtitles, isNotEmpty);
    }
  });

  test('Parsed subtitles should have correct start and end durations', () {
    for (List<Subtitle> parsedSubtitles in parsedSubtitlesList) {
      for (int i = 0; i < parsedSubtitles.length - 1; i++) {
        expect(parsedSubtitles[i].start,
            lessThanOrEqualTo(parsedSubtitles[i].end));
        expect(parsedSubtitles[i].end,
            lessThanOrEqualTo(parsedSubtitles[i + 1].start));
      }
    }
  });

  test('Parsed subtitles should have non-empty text', () {
    for (List<Subtitle> parsedSubtitles in parsedSubtitlesList) {
      expect(
        parsedSubtitles.every((subtitle) => subtitle.text.isNotEmpty),
        isTrue,
      );
    }
  });
}
