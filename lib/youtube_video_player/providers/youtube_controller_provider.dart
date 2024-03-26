import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_id_provider.dart';

final youtubeControllerProvider = Provider((ref) {
  final videoId = ref.watch(videoIdProvider);

  final controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(enableCaption: false),
  );
  ref.onDispose(() => controller.dispose());
  return controller;
});
