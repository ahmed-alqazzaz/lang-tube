import 'package:youtube_scraper/youtube_scraper.dart';

extension TargetLanguageVideos on Iterable<ObservedVideo> {
  Iterable<ObservedVideo> getTargetLanguageVideos(String languagePattern) =>
      where((item) => RegExp(languagePattern).hasMatch(item.title));
}
