import 'package:html/parser.dart';
import 'data/subtitle.dart';
export 'data/subtitle.dart';

// supports only srv1 subtitles
class SubtitlesParser {
  SubtitlesParser._({required this.subtitles});

  final List<Subtitle> subtitles;
  factory SubtitlesParser(String subtitles) {
    return SubtitlesParser._(
      subtitles: subtitles
          .replaceFirst(
              '<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
          .replaceFirst('</transcript>', '')
          .split('</text>')
          .where((line) => line.trim().isNotEmpty)
          .map(const _SubtitleParsingHelper().convertRawLineToSubtitle)
          .toList(),
    );
  }

  // return subtitle index
  int? searchDuration(Duration duration) {
    int low = 0;
    int high = subtitles.length - 1;

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);

      Subtitle currentSubtitle = subtitles[mid];
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
}

class _SubtitleParsingHelper {
  const _SubtitleParsingHelper();
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
      duration: duration,
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
}
