import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/actions_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../subtitles_player/providers/multi_subtitles_player_provider/provider.dart';

KeepAliveLink? playerActionsProviderKeepAliveLink;

typedef YoutubePlayerActionsProvider
    = AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>;
final youtubePlayerActionsProvider = ChangeNotifierProvider.autoDispose.family<
    YoutubePlayerActionsModel,
    ({
      YoutubePlayerController youtubePlayerController,
      MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
    })>(
  (ref, args) {
    playerActionsProviderKeepAliveLink?.close();
    playerActionsProviderKeepAliveLink = ref.keepAlive();
    return YoutubePlayerActionsModel(
      youtubePlayerController: args.youtubePlayerController,
      multiSubtitlesPlayerProvider: args.multiSubtitlesPlayerProvider,
      ref: ref,
    );
  },
);

class YoutubePlayerActionsModel extends ChangeNotifier {
  YoutubePlayerActionsModel({
    required YoutubePlayerController youtubePlayerController,
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
    required AutoDisposeChangeNotifierProviderRef ref,
  }) : _actionsController = YoutubePlayerActionsController(
          youtubePlayerController: youtubePlayerController,
          multiSubtitlesPlayerProvider: multiSubtitlesPlayerProvider,
          ref: ref,
        ) {
    _actionsController.youtubePlayerController
        .addListener(_fullScreenActionsisibilityListener);
  }
  final YoutubePlayerActionsController _actionsController;
  double playbackSpeed = 0.75;
  bool isHd = false;
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
    assert(
        areFullScreenActionsVisible, 'Full screen actions are already hidden');
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

  void toggleHd() {
    try {
      isHd ? _actionsController.disableHd() : _actionsController.forceHd();
    } finally {
      isHd = !isHd;
    }
    notifyListeners();
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
