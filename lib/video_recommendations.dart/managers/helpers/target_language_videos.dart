import '../../../../../youtube_scraper/data/youtube_video_item.dart';

extension TargetLanguageVideos on Iterable<YoutubeVideoItem> {
  Iterable<YoutubeVideoItem> getTargetLanguageVideos(String languagePattern) =>
      where((item) => RegExp(languagePattern).hasMatch(item.title));
}
