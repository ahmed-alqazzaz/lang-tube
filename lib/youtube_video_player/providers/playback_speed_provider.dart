import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'youtube_controller_provider.dart';

final youtubePlaybackSpeedProvider = StateNotifierProvider(
  (ref) => YoutubePlaybackSpeedNotifier(
    youtubePlayerController: ref.watch(youtubeControllerProvider)!,
  ),
);

class YoutubePlaybackSpeedNotifier extends StateNotifier<double> {
  YoutubePlaybackSpeedNotifier({
    required YoutubePlayerController youtubePlayerController,
  })  : _youtubePlayerController = youtubePlayerController,
        super(defaultPlaybackSpeed);

  final YoutubePlayerController _youtubePlayerController;
  void seekNext() {
    final currentIndex = acceptedPlaybackSpeeds.indexOf(state);
    final nextIndex = (currentIndex + 1) % acceptedPlaybackSpeeds.length;
    state = acceptedPlaybackSpeeds[nextIndex];
    _youtubePlayerController.setPlaybackRate(state);
  }

  static const double defaultPlaybackSpeed = 0.75;
  static const acceptedPlaybackSpeeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0
  ];
}
