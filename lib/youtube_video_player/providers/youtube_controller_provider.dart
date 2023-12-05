import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/video_id_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final youtubeControllerProvider = Provider((ref) {
  final videoId = ref.watch(videoIdProvider);

  final controller = YoutubePlayerController(initialVideoId: videoId);
  ref.onDispose(() => controller.dispose());
  return controller;
});
