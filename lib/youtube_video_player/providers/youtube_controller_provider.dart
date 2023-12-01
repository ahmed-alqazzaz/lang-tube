import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/providers/app_state_provider/app_state_provider.dart';
import 'package:lang_tube/providers/app_state_provider/states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final youtubeControllerProvider = Provider((ref) {
  final videoId = ref.watch(
    appStateProvider.select(
        (state) => state is DisplayingVideoPlayer ? state.videoId : null),
  );
  final controller =
      videoId != null ? YoutubePlayerController(initialVideoId: videoId) : null;
  ref.onDispose(() => controller?.dispose());
  return videoId != null ? controller : null;
});
