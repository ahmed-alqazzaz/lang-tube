import '../../../../../youtube_scraper/data/youtube_video_item.dart';

extension DiversityScore on List<YoutubeVideoItem> {
  // score between 0.0 and 1.0
  // unique channels to video count ratio
  double get diversityScore =>
      isNotEmpty ? map((item) => item.channelName).toSet().length / length : 0;
}
