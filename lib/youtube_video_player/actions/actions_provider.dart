import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/actions_controller.dart';

typedef YoutubePlayerActionsProvider
    = AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>;
final youtubePlayerActionsProvider = ChangeNotifierProvider.autoDispose.family<
    YoutubePlayerActionsModel,
    ({
      YoutubePlayerActionsController controller,
      double playbackSpeed,
      bool shouldForceHd,
    })>(
  (ref, args) => YoutubePlayerActionsModel(
    shouldForceHd: args.shouldForceHd,
    playbackSpeed: args.playbackSpeed,
    controller: args.controller,
  ),
);

class YoutubePlayerActionsModel extends ChangeNotifier {
  YoutubePlayerActionsModel({
    required this.shouldForceHd,
    required this.playbackSpeed,
    required YoutubePlayerActionsController controller,
  }) : _controller = controller;
  final YoutubePlayerActionsController _controller;
  double playbackSpeed;
  bool shouldForceHd;
  bool isCustomLoopActive = false;
  bool isSubtitleLoopActive = false;

  void toggleSubtitleLoop() {
    try {
      isSubtitleLoopActive
          ? _controller.disableSubtitleLoop()
          : _controller.enableSubtitleLoop();
    } finally {
      isSubtitleLoopActive = !isSubtitleLoopActive;
    }
    notifyListeners();
  }

  void toggleForceHd() {
    shouldForceHd = !shouldForceHd;
    shouldForceHd ? _controller.enableForceHd() : _controller.disableForceHd();
  }

  void setPlaybackSpeed(double speed) {
    assert(playbackSpeed != playbackSpeed, 'playback speed is already $speed');
    playbackSpeed = playbackSpeed;
    _controller.setPlayBackSpeed(speed);
    notifyListeners();
  }

  void enableFullScreen() => _controller.enableFullScreen();
  void exitFullScreen() => _controller.exitFullScreen();

  void seekNextSubtitle() => _controller.seekNextSubtitle();
  void seekPreviousSubtitle() => _controller.seekPreviousSubtitle();

  void displaySubtitlesSettings() => _controller.displaySubtitlesSettings();
  void displayMainSettings() => _controller.displayMainSettings();

  void exit() => _controller.exit();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
