import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../subtitles_player/providers/subtitle_player_provider.dart';
import '../../../../subtitles_player/utils/subtitles_parser/data/subtitle.dart';

@immutable
class SeekSubtitleController {
  const SeekSubtitleController({
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required YoutubePlayerController youtubePlayerController,
    required AutoDisposeChangeNotifierProviderRef ref,
  })  : _subtitlesPlayerProvider = subtitlesPlayerProvider,
        _youtubePlayerController = youtubePlayerController,
        _ref = ref;

  final SubtitlesPlayerProvider _subtitlesPlayerProvider;
  final YoutubePlayerController _youtubePlayerController;
  final AutoDisposeChangeNotifierProviderRef _ref;
  SubtitlesController get _subtitlesController =>
      _ref.read(_subtitlesPlayerProvider).mainSubtitlesController;

  void seekPreviousSubtitle() => _seekSubtitle(
        _subtitlesController.previousSubtitle,
      );

  void seekNextSubtitle() => _seekSubtitle(
        _subtitlesController.nextSubtitle,
      );

  void _seekSubtitle(Subtitle? subtitle) {
    if (subtitle != null) {
      _youtubePlayerController.seekTo(subtitle.start);
    }
    throw UnimplementedError();
  }
}

extension SubtitlesSequence on SubtitlesController {
  Subtitle? get previousSubtitle {
    final index = currentSubtitleIndex;
    if (index != null && index > 0) {
      subtitles[index - 1];
    }
    return null;
  }

  Subtitle? get nextSubtitle {
    final index = currentSubtitleIndex;
    if (index != null && index < subtitlesCount - 1) {
      subtitles[index + 1];
    }
    return null;
  }
}
