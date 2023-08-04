import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../raw_loop_notifier/loop.dart';
import '../raw_loop_notifier/raw_loop_state.dart';
import '../raw_loop_notifier/notifier.dart';

typedef CurrentSubtitleGetter = Subtitle? Function();

final class SubtitleLoopNotifier extends StateNotifier<Loop?> {
  SubtitleLoopNotifier({
    required CurrentSubtitleGetter currentSubtitleGetter,
    required YoutubePlayerController youtubePlayerController,
    required int loopCount,
  })  : _loopNotifier = RawLoopNotifier(
          youtubePlayerController: youtubePlayerController,
        ),
        _youtubePlayerController = youtubePlayerController,
        _getCurrentSubtitle = currentSubtitleGetter,
        _loopCount = loopCount,
        super(null);

  final RawLoopNotifier _loopNotifier;
  final YoutubePlayerController _youtubePlayerController;
  final int _loopCount;

  final Subtitle? Function() _getCurrentSubtitle;
  Subtitle? _previousSubtitle;

  void _subtitleLoopListener() {
    final currentSubtitle = _getCurrentSubtitle();
    if (currentSubtitle != null &&
        _previousSubtitle != currentSubtitle &&
        _loopNotifier.state != RawLoopState.active &&
        _loopNotifier.state != RawLoopState.paused) {
      final loop = Loop(start: currentSubtitle.start, end: currentSubtitle.end);
      final youtubePlayerPosition = _youtubePlayerController.value.position;

      if (state != loop) {
        state = loop;
      }
      if ((loop.end - youtubePlayerPosition).inMilliseconds < 100) {
        _previousSubtitle = currentSubtitle;
        _loopNotifier.activateLoop(
          loop: state!,
          loopCount: _loopCount,
        );
      }
    }
  }

  void activateLoop() {
    _youtubePlayerController.addListener(_subtitleLoopListener);
  }

  void deactivateLoop() {
    _loopNotifier.deactivateLoop();
    _youtubePlayerController.removeListener(_subtitleLoopListener);
    state = null;
  }

  @override
  void dispose() {
    _youtubePlayerController.removeListener(_subtitleLoopListener);
    _loopNotifier.dispose();
    super.dispose();
  }
}
