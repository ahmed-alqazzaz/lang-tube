import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/action_providers/full_screen_provider/notifier.dart';

final youtubePlayerFullScreenProvider =
    StateNotifierProvider<YoutubePlayerFullscreenNotifier, bool>(
  (ref) => YoutubePlayerFullscreenNotifier(),
);
