import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/actions_controller.dart';

KeepAliveLink? playerActionsProviderKeepAliveLink;

typedef YoutubePlayerActionsProvider
    = AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>;
final youtubePlayerActionsProvider = ChangeNotifierProvider.autoDispose.family<
    YoutubePlayerActionsModel,
    ({
      YoutubePlayerActionsController controller,
      double playbackSpeed,
      bool shouldForceHd,
    })>(
  (ref, args) {
    playerActionsProviderKeepAliveLink = ref.keepAlive();
    return YoutubePlayerActionsModel(
      shouldForceHd: args.shouldForceHd,
      playbackSpeed: args.playbackSpeed,
      controller: args.controller,
    );
  },
);

class YoutubePlayerActionsModel extends ChangeNotifier {
  YoutubePlayerActionsModel({
    required this.shouldForceHd,
    required this.playbackSpeed,
    required YoutubePlayerActionsController controller,
  }) : _actionsController = controller {
    _actionsController.youtubePlayerController
        .addListener(_fullScreenActionsisibilityListener);
  }
  final YoutubePlayerActionsController _actionsController;
  double playbackSpeed;
  bool shouldForceHd;
  bool isCustomLoopActive = false;
  bool isSubtitleLoopActive = false;
  bool areFullScreenActionsVisible = false;

  void showFullScreenActions() {
    assert(!areFullScreenActionsVisible,
        'Full screen actions are already visible');
    areFullScreenActionsVisible = true;
    notifyListeners();
  }

  void hideFullScreenActions() {
    assert(!areFullScreenActionsVisible,
        'Full screen actions are already visible');
    areFullScreenActionsVisible = false;
    notifyListeners();
  }

  void toggleSubtitleLoop() {
    try {
      isSubtitleLoopActive
          ? _actionsController.disableSubtitleLoop()
          : _actionsController.enableSubtitleLoop();
    } finally {
      isSubtitleLoopActive = !isSubtitleLoopActive;
    }
    notifyListeners();
  }

  void toggleForceHd() {
    shouldForceHd = !shouldForceHd;
    shouldForceHd
        ? _actionsController.enableForceHd()
        : _actionsController.disableForceHd();
  }

  void setPlaybackSpeed(double speed) {
    assert(playbackSpeed != playbackSpeed, 'playback speed is already $speed');
    playbackSpeed = playbackSpeed;
    _actionsController.setPlayBackSpeed(speed);
    notifyListeners();
  }

  void enableFullScreen() => _actionsController.enableFullScreen();
  void exitFullScreen() => _actionsController.exitFullScreen();

  void seekNextSubtitle() => _actionsController.seekNextSubtitle();
  void seekPreviousSubtitle() => _actionsController.seekPreviousSubtitle();

  void displaySubtitlesSettings() =>
      _actionsController.displaySubtitlesSettings();
  void displayMainSettings() => _actionsController.displayMainSettings();

  void exit() => _actionsController.exit();

  void _fullScreenActionsisibilityListener() {
    final areActionsVisible =
        _actionsController.youtubePlayerController.value.isControlsVisible;
    if (areFullScreenActionsVisible != areActionsVisible) {
      areFullScreenActionsVisible = areActionsVisible;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _actionsController.youtubePlayerController
        .removeListener(_fullScreenActionsisibilityListener);
    _actionsController.dispose();

    super.dispose();
  }
}
