import 'dart:async';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'loop_state.dart';

class YoutubePlayerLoopController {
  YoutubePlayerLoopController({
    required this.youtubePlayerController,
    required this.loopCount,
  }) {
    youtubePlayerController.addListener(_pauseListener);
  }
  final YoutubePlayerController youtubePlayerController;
  final int loopCount;

  bool _isDisposed = false;
  LoopState _loopState = LoopState.unInitialized;
  LoopState get loopState => _loopState;
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  StreamSubscription? loopSubscription;

  void activateLoop({required Duration start, required Duration end}) {
    assert(end > start, 'End duration must be greater than start duration.');
    assert(_loopState != LoopState.active, 'Loop is already active');
    assert(!_isPaused, "Can't activate a loop when player is paused");
    assert(
        !_isDisposed, "loop controller can't activate loop when it's disposed");
    youtubePlayerController.seekTo(start);
    _loopState = LoopState.active;
    loopSubscription = Stream.periodic(end - start).take(loopCount - 1).listen(
          (event) => youtubePlayerController.seekTo(start),
          onDone: () => _loopState = LoopState.finished,
        );
  }

  void disableLoop() {
    assert(_loopState != LoopState.disabled, 'Loop is Already disabled');
    assert(
        !_isDisposed, "loop controller can't disable looop when it's disposed");
    _loopState = LoopState.disabled;
    loopSubscription?.cancel();
  }

  void resume() {
    assert(!_isDisposed, "loop controller can't resume when it's disposed");
    _isPaused = false;
    loopSubscription?.resume();
  }

  void pause() {
    assert(!_isDisposed, "loop controller can't pause when it's disposed");
    _isPaused = true;
    loopSubscription?.pause();
  }

  void _pauseListener() {
    assert(!_isDisposed,
        "loop controller can't listen to pause when it's disposed");
    if (_loopState != LoopState.unInitialized) {
      final isPaused = !youtubePlayerController.value.isPlaying;
      if (isPaused && !_isPaused) {
        pause();
      } else if (!isPaused && _isPaused) {
        resume();
      }
    }
  }

  void dispose() {
    disableLoop();
    youtubePlayerController.removeListener(_pauseListener);
    _isDisposed = true;
  }
}
