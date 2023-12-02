import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/youtube_player/loop.dart';
import 'package:lang_tube/models/youtube_player/raw_loop_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RawLoopNotifier extends StateNotifier<RawLoopState> {
  RawLoopNotifier({required this.youtubePlayerController})
      : super(RawLoopState.unInitialized) {
    youtubePlayerController.addListener(_pauseListener);
  }
  final YoutubePlayerController youtubePlayerController;
  StreamSubscription? loopSubscription;

  void activateLoop({required Loop loop, required int loopCount}) {
    assert(state != RawLoopState.active, 'Loop is already active');
    assert(state != RawLoopState.paused,
        "Can't activate a loop when player is paused");
    youtubePlayerController.seekTo(loop.start);
    state = RawLoopState.active;
    loopSubscription =
        Stream.periodic(loop.duration).take(loopCount - 1).listen(
              (event) => youtubePlayerController.seekTo(loop.start),
              onDone: () => state = RawLoopState.finished,
            );
  }

  void deactivateLoop() {
    assert(state != RawLoopState.disabled, 'Loop is Already disabled');
    state = RawLoopState.disabled;

    loopSubscription?.cancel();
  }

  void resume() {
    assert(state == RawLoopState.paused, "can't resume an unapused loop");
    state = RawLoopState.active;
    loopSubscription?.resume();
  }

  void pause() {
    assert(state == RawLoopState.active, "can't pause an inactive loop");
    state = RawLoopState.paused;
    loopSubscription?.pause();
  }

  void _pauseListener() {
    if (state != RawLoopState.unInitialized) {
      final isPaused = !youtubePlayerController.value.isPlaying;
      if (isPaused && state == RawLoopState.active) {
        pause();
      } else if (!isPaused && state == RawLoopState.paused) {
        resume();
      }
    }
  }

  @override
  void dispose() {
    deactivateLoop();
    youtubePlayerController.removeListener(_pauseListener);
    super.dispose();
  }
}
