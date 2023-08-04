import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/action_providers/actions_visibilty_provider/notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

KeepAliveLink? _link;
final actionsVisibilityProvider = StateNotifierProvider.family
    .autoDispose<ActionsVisibilityNotifier, bool, YoutubePlayerController>(
  (ref, controller) {
    _link?.close();
    _link = ref.keepAlive();
    return ActionsVisibilityNotifier(
      youtubePlayerController: controller,
    );
  },
);
