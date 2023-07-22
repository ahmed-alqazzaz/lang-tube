import 'package:html/parser.dart';
import 'data/subtitle.dart';
export 'data/subtitle.dart';

// supports only srv1 subtitles
class SubtitlesParser {
  SubtitlesParser._({required this.subtitles});
  static const _helper = _SubtitleParsingHelper();
  final List<Subtitle> subtitles;
  factory SubtitlesParser(String subtitles) {
    return SubtitlesParser._(
      subtitles: _helper
          .santitizeDurations(subtitles
              .replaceFirst(
                  '<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
              .replaceFirst('</transcript>', '')
              .split('</text>')
              .where((line) => line.trim().isNotEmpty)
              .map(_helper.convertRawLineToSubtitle)
              .toList())
          .toList(),
    );
  }

  // average speed in syllables per milliseconds
  // add individual subtitle speeds and divied by length
  Future<double> get avgerageSyllablesPerMillisecond async {
    final length = subtitles.length;
    List<double> individualSyllablesPerMillisecond = [
      for (final subtitle in subtitles) await subtitle.syllablesPerMillisecond
    ]..sort();

    // create a sublist of the middle
    // %80 of subtitles to remove outliers
    // and merge all values then divide by length
    final margin = (subtitles.length * 0.1).toInt();
    return individualSyllablesPerMillisecond
            .sublist(margin, length - margin)
            .fold<double>(0.0, (aggregate, element) => aggregate + element) /
        (length - margin * 2);
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
}
