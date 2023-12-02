import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/youtube_player/loop.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/raw_loop_notifier.dart';

final customLoopProvider = StateNotifierProvider<CustomLoopNotifier, Loop?>(
  (ref) => CustomLoopNotifier(
    youtubePlayerController: ref.watch(youtubeControllerProvider)!,
  ),
);

// creating a a seperate instance of raw
// loop controller is neccessary to prevent
// conflict between custom and subtitles loops
final class CustomLoopNotifier extends StateNotifier<Loop?> {
  CustomLoopNotifier({
    required YoutubePlayerController youtubePlayerController,
  })  : _rawLoopController = RawLoopNotifier(
          youtubePlayerController: youtubePlayerController,
        ),
        super(null);
  final RawLoopNotifier _rawLoopController;

  void activateLoop({required Duration start, required Duration end}) {
    state = Loop(start: start, end: end);
    _rawLoopController.activateLoop(loop: state!, loopCount: (2 ^ 63) - 1);
  }

  void deactivateLoop() => _rawLoopController.deactivateLoop();

  void setState() {
    state = state;
  }

  @override
  void dispose() {
    _rawLoopController.dispose();
    super.dispose();
  }
}
