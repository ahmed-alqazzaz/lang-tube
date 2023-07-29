import 'package:html/parser.dart';

import '../data/subtitle.dart';

// ensure that the end duration of any subtitle
// is lower than or equal to the start duration
// of the consecutive subtitle
Iterable<Subtitle> santitizeDurations(List<Subtitle> subtitles) sync* {
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

Subtitle convertRawLineToSubtitle(String line) {
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

  return Subtitle(
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
