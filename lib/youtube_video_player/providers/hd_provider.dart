import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'youtube_controller_provider.dart';

final youtubeHdProvider = StateNotifierProvider<YoutubeHdNotifier, bool>(
  (ref) => YoutubeHdNotifier(
    youtubePlayerController: ref.watch(youtubeControllerProvider),
  ),
);

class YoutubeHdNotifier extends StateNotifier<bool> {
  YoutubeHdNotifier({required YoutubePlayerController? youtubePlayerController})
      : _youtubePlayerController = youtubePlayerController,
        super(false);

  final YoutubePlayerController? _youtubePlayerController;
  void forceHd() {
    if (_youtubePlayerController == null) return;
    _youtubePlayerController!.setVideoQuality(VideoQuality.hd1080p);
    state = true;
  }

  void disableHd() {
    if (_youtubePlayerController == null) return;
    _youtubePlayerController!.setVideoQuality(VideoQuality.auto);
    state = false;
  }
}
