import 'package:youtube_scraper/youtube_scraper.dart';

extension DiversityScore on List<ObservedVideo> {
  // score between 0.0 and 1.0
  // unique channels to video count ratio
  double get diversityScore =>
      isNotEmpty ? map((item) => item.channelName).toSet().length / length : 0;
}
