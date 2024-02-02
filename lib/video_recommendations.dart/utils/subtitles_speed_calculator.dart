import 'package:readability/readability.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

extension SubtitlesSpeed on ScrapedSubtitles {
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
}

extension SubtitleSpeed on ParsedSubtitle {
  Duration get duration => end - start;
  Future<double> get syllablesPerMillisecond async =>
      Readability.getInstance(Language.english).then(
        (instance) async =>
            await instance.calculateSyllables(text) / duration.inMilliseconds,
      );
}
