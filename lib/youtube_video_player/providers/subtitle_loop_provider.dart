import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/youtube_player/loop.dart';
import '../../models/youtube_player/raw_loop_state.dart';
import '../utils/raw_loop_notifier.dart';
import 'subtitles_player_provider.dart';
import 'youtube_controller_provider.dart';

typedef CurrentSubtitleGetter = List<Subtitle> Function();

final subtitleLoopProvider = StateNotifierProvider((ref) {
  return SubtitleLoopNotifier(
    currentSubtitleGetter: () =>
        ref.read(subtitlesPlayerProvider).currentSubtitles.mainSubtitles,
    youtubePlayerController: ref.read(youtubeControllerProvider)!,
    loopCount: 1,
  );
});

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

  final List<Subtitle> Function() _getCurrentSubtitle;
  List<Subtitle>? _previousSubtitle;

  void _subtitleLoopListener() {
    final currentSubtitle = _getCurrentSubtitle();
    if (currentSubtitle.isNotEmpty &&
        !listEquals(_previousSubtitle, currentSubtitle) &&
        _loopNotifier.state != RawLoopState.active &&
        _loopNotifier.state != RawLoopState.paused) {
      final loop = Loop(
          start: currentSubtitle.first.start, end: currentSubtitle.last.end);
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
