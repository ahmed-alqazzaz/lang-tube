import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/subtitles_parser/subtitles_parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SubtitlePlayerModel extends ChangeNotifier {
  SubtitlePlayerModel({
    required SubtitlesParser subtitlesParser,
    required YoutubePlayerController youtubePlayerController,
  })  : _subtitlesParser = subtitlesParser,
        _youtubePlayerController = youtubePlayerController {
    _youtubePlayerController.addListener(youtubePlayerListener);
  }

  final SubtitlesParser _subtitlesParser;
  final YoutubePlayerController _youtubePlayerController;

  List<String> currentVisibleWords = [];
  void youtubePlayerListener() {
    final playerCurrentPosition = _youtubePlayerController.value.position;
    final updatedVisibleWords = _subtitlesParser
        .searchDuration(
          playerCurrentPosition,
        )
        ?.words;

    if (updatedVisibleWords != null &&
        !listEquals(currentVisibleWords, updatedVisibleWords)) {
      if (!_youtubePlayerController.value.isDragging) {
        currentVisibleWords = updatedVisibleWords;
      } else {
        currentVisibleWords = [];
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
