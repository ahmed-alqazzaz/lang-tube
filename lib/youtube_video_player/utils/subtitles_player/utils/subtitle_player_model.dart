
import 'package:flutter/foundation.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/subtitles_parser/subtitles_parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SubtitlePlayerModel extends ChangeNotifier {
  SubtitlePlayerModel({
    required SubtitlesParser subtitlesParser,
    required YoutubePlayerController youtubePlayerController,
  })  : _subtitlesParser = subtitlesParser,
        _youtubePlayerController = youtubePlayerController,
        subtitles = subtitlesParser.subtitles {
    _youtubePlayerController.addListener(youtubePlayerListener);
  }

  final SubtitlesParser _subtitlesParser;
  final YoutubePlayerController _youtubePlayerController;

  final List<Subtitle> subtitles;
  int? currentSubtitleIndex;
  Subtitle? get currentSubtitle =>
      currentSubtitleIndex != null ? subtitles[currentSubtitleIndex!] : null;

  void youtubePlayerListener() {
    final updatedSubtitleIndex = _subtitlesParser.searchDuration(
      _youtubePlayerController.value.position,
    );
    if (updatedSubtitleIndex != currentSubtitleIndex) {
      if (!_youtubePlayerController.value.isDragging) {
        currentSubtitleIndex = updatedSubtitleIndex;
      } else {
        currentSubtitleIndex = null;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _youtubePlayerController.removeListener(youtubePlayerListener);
    super.dispose();
  }
}
