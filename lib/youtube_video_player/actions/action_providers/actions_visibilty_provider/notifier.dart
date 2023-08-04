import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ActionsVisibilityNotifier extends StateNotifier<bool> {
  ActionsVisibilityNotifier({
    required YoutubePlayerController youtubePlayerController,
  })  : _youtubePlayerController = youtubePlayerController,
        super(false) {
    _youtubePlayerController.addListener(_actionsVisibilityListener);
  }
  final YoutubePlayerController _youtubePlayerController;

  void _actionsVisibilityListener() {
    final areControlsVisible = _youtubePlayerController.value.isControlsVisible;
    if (state != areControlsVisible) {
      state = areControlsVisible;
    }
  }

  @override
  void dispose() {
    _youtubePlayerController.removeListener(_actionsVisibilityListener);
    super.dispose();
  }
}
