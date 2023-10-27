import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';
import 'package:subtitles_parser/duration_sanitizer.dart';
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

List<ParsedSubtitle> parseSubtitless(String rawSubtitles) {
  final parsedSubtitles = rawSubtitles
      .replaceFirst('<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
      .replaceFirst('</transcript>', '')
      .split('</text>')
      .where((line) => line.trim().isNotEmpty)
      .map(convertRawLineToSubtitle)
      .toList();
  return santitizeDurations(parsedSubtitles).toList();
}

ParsedSubtitle convertRawLineToSubtitle(String line) {
  final startRegex = RegExp(r'start="([\d.]+)"');
  final durationRegex = RegExp(r'dur="([\d.]+)"');

  /// Force unwrapping because [startString] and [durationString] should
  /// always be there.
  final startString = startRegex.firstMatch(line)!.group(1)!;
  final durationString = durationRegex.firstMatch(line)!.group(1)!;

  final start = _parseDuration(startString);
  final duration = _parseDuration(durationString);

  final htmlText = line
      .replaceAll(r'<text.+>', '')
      .replaceAll(r'/&amp;/gi', '&')
      .replaceAll(r'/<\/?[^>]+(>|$)/g', '');

  final text = _stripHtmlTags(htmlText);

  return ParsedSubtitle(
    start: start,
    end: start + duration,
    text: text,
  );
}

Duration _parseDuration(String rawDuration) {
  final parts = rawDuration.split('.');
  final seconds = int.parse(parts[0]);
  final milliseconds = parts.length < 2 ? 0 : int.parse(parts[1]);

  return Duration(seconds: seconds, milliseconds: milliseconds);
}

String _stripHtmlTags(String html) {
  final document = parse(html);
  final bodyText = document.body!.text;
  final strippedText = parse(bodyText).documentElement!.text;

  return strippedText;
}
