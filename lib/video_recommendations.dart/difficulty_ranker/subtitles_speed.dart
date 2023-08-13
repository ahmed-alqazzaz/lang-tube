import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/data/subtitles_data.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;
import 'rust_api/api.dart';

extension SubtitlesSpeed on SubtitlesData {
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

extension SubtitleSpeed on subtitles_player.Subtitle {
  Future<double> get syllablesPerMillisecond async {
    return (await rustApi.countSyllables(text: text)) / duration.inMilliseconds;
  }
}
