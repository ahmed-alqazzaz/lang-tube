import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/youtube_playback_speed_provider/notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

typedef YoutubePlaybackSpeedProvider
    = AutoDisposeStateNotifierProvider<YoutubePlaybackSpeedNotifier, double>;

KeepAliveLink? _link;
final youtubePlaybackSpeedProviderFamily = StateNotifierProvider.autoDispose
    .family<YoutubePlaybackSpeedNotifier, double, YoutubePlayerController>(
  (ref, controller) {
    _link?.close();
    _link = ref.keepAlive();
    return YoutubePlaybackSpeedNotifier(youtubePlayerController: controller);
  },
);
