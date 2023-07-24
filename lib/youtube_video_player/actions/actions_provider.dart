import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/actions_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../subtitles_player/providers/subtitle_player_provider.dart';

KeepAliveLink? playerActionsProviderKeepAliveLink;

typedef YoutubePlayerActionsProvider
    = AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>;
final youtubePlayerActionsProvider = ChangeNotifierProvider.autoDispose.family<
    YoutubePlayerActionsModel,
    ({
      YoutubePlayerController youtubePlayerController,
      SubtitlesPlayerProvider subtitlesPlayerProvider,
    })>(
  (ref, args) {
    playerActionsProviderKeepAliveLink?.close();
    playerActionsProviderKeepAliveLink = ref.keepAlive();
    return YoutubePlayerActionsModel(
      youtubePlayerController: args.youtubePlayerController,
      subtitlesPlayerProvider: args.subtitlesPlayerProvider,
      ref: ref,
    );
  },
);

class YoutubePlayerActionsModel extends ChangeNotifier {
  YoutubePlayerActionsModel({
    required YoutubePlayerController youtubePlayerController,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required AutoDisposeChangeNotifierProviderRef ref,
  }) : _actionsController = YoutubePlayerActionsController(
          youtubePlayerController: youtubePlayerController,
          subtitlesPlayerProvider: subtitlesPlayerProvider,
          ref: ref,
        ) {
    _actionsController.youtubePlayerController
        .addListener(_fullScreenActionsisibilityListener);
  }
  final YoutubePlayerActionsController _actionsController;
  double playbackSpeed = 0.75;
  bool shouldForceHd = false;
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
      toggleForceHd();
      // isSubtitleLoopActive
      //     ? _actionsController.disableSubtitleLoop()
      //     : _actionsController.enableSubtitleLoop();
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
