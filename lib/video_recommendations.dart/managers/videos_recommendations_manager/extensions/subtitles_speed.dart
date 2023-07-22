import '../data/youtube_video.dart';

extension SubtitlesSpeedCalculator on YoutubeVideo {
  Future<double> get syllablesPerMillisecond async => await subtitles
      .mainSubtitles.subtitlesParser.avgerageSyllablesPerMillisecond;
}
