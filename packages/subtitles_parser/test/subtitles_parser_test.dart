import 'package:flutter_test/flutter_test.dart';
import 'package:subtitles_parser/src/duration_sanitizer.dart';
import 'package:subtitles_parser/subtitles_parser.dart';

import 'subtitles.dart';
import 'test_rust_bridge/api.dart';

Future<void> main() async {
  final rawSubtitlesList = [
    fireshipSubtitles,
    lucySubtitles,
    marinaSubtitles,
    rachelSubtitles,
    germanSubtitles,
    unnamedSubtitles,
  ];

  // final timer = Stopwatch()..start();
  // await Future.wait(List.generate(1000, (index) => index).map((e) async => [
  //       for (String rawSubtitles in rawSubtitlesList)
  //         await rustApi.parseSubtitles(rawSubtitles: rawSubtitles).then(
  //               (subtitles) => subtitles.santitizeDurations().toList(),
  //             )
  //     ]));
  // print('finnished within ${timer.elapsedMilliseconds}');
  final parsedSubtitlesList = [
    for (String rawSubtitles in rawSubtitlesList)
      await rustApi.parseSubtitles(rawSubtitles: rawSubtitles).then(
            (subtitles) => subtitles.santitizeDurations().toList(),
          )
  ];

  test('Parsing subtitles should return a non-empty list', () {
    for (List<ParsedSubtitle> parsedSubtitles in parsedSubtitlesList) {
      expect(parsedSubtitles, isNotEmpty);
    }
  });

  test('Parsed subtitles should have correct start and end durations', () {
    for (List<ParsedSubtitle> parsedSubtitles in parsedSubtitlesList) {
      for (int i = 0; i < parsedSubtitles.length - 1; i++) {
        expect(
          parsedSubtitles[i].start,
          lessThanOrEqualTo(
              parsedSubtitles[i].end + Duration(milliseconds: 200)),
        );
        expect(
          parsedSubtitles[i].end,
          lessThanOrEqualTo(
            parsedSubtitles[i + 1].start,
          ),
        );
      }
    }
  });

  test('Parsed subtitles should have non-empty text', () {
    for (List<ParsedSubtitle> parsedSubtitles in parsedSubtitlesList) {
      expect(
        parsedSubtitles.every((subtitle) => subtitle.text.isNotEmpty),
        isTrue,
      );
    }
  });
}

Iterable<ParsedSubtitle> santitizeDurations(
    List<ParsedSubtitle> subtitles) sync* {
  for (int index = 0; index < subtitles.length - 1; index++) {
    final subtitle = subtitles[index];
    final consecutiveSubtitle = subtitles[index + 1];
    if (subtitle.end <= consecutiveSubtitle.start) {
      yield subtitle;
    } else {
      yield subtitle.copyWith(end: consecutiveSubtitle.start);
    }
  }
}
