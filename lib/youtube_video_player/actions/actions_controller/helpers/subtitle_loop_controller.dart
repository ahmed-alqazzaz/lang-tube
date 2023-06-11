import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/helpers/loop_controller.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/helpers/loop_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../subtitles_player/utils/subtitles_parser/data/subtitle.dart';

class SubtitleLoopController {
  SubtitleLoopController({
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required AutoDisposeChangeNotifierProviderRef ref,
    required YoutubePlayerController youtubePlayerController,
    required int loopCount,
  })  : _loopController = YoutubePlayerLoopController(
          loopCount: loopCount,
          youtubePlayerController: youtubePlayerController,
        ),
        _youtubePlayerController = youtubePlayerController {
    _subtitlesModelSubscription =
        ref.listen(subtitlesPlayerProvider, (_, model) {
      _currentSubtitle = model.mainSubtitlesController.currentSubtitle;
    });
  }
  late final ProviderSubscription<SubtitlesPlayerModel>
      _subtitlesModelSubscription;
  final YoutubePlayerLoopController _loopController;
  final YoutubePlayerController _youtubePlayerController;

  bool _isEnabled = false;
  bool _isDisposed = false;

  Subtitle? _currentSubtitle;
  Subtitle? _previousSubtitle;
  void _subtitleLoopListener() {
    final currentSubtitle = _currentSubtitle;
    if (currentSubtitle != null &&
        _loopController.loopState != LoopState.active &&
        _previousSubtitle != currentSubtitle &&
        !_loopController.isPaused) {
      final subtitleStartPosition = currentSubtitle.start;
      final subtitlesEndPosition = currentSubtitle.end;
      final youtubePlayerPosition = _youtubePlayerController.value.position;
      if ((subtitlesEndPosition - youtubePlayerPosition).inMilliseconds < 100) {
        _previousSubtitle = currentSubtitle;
        _loopController.activateLoop(
          start: subtitleStartPosition,
          end: subtitlesEndPosition,
        );
      }
    }
  }

  void enable() {
    assert(!_isEnabled, 'subtitle loop controller is already enabled');
    assert(!_isDisposed,
        "can't enable subtitle loop listener after being disposed");
    _youtubePlayerController.addListener(_subtitleLoopListener);
    _isEnabled = true;
  }

  void disable() {
    assert(_isEnabled, 'subtitle loop controller is already not enabled');
    assert(!_isDisposed,
        "can't disable subtitle loop listener after being disposed");
    _loopController.disableLoop();
    _youtubePlayerController.removeListener(_subtitleLoopListener);
    _isEnabled = false;
  }

  void dispose() {
    assert(!_isDisposed, "subtitle loop player is already disposed");

    _youtubePlayerController.removeListener(_subtitleLoopListener);
    _subtitlesModelSubscription.close();
    _isDisposed = true;
  }
}
