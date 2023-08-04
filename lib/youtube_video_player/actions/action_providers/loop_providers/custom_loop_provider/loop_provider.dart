import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../raw_loop_notifier/loop.dart';
import 'notifier.dart';

typedef CustomLoopProvider
    = AutoDisposeStateNotifierProvider<CustomLoopNotifier, Loop?>;
KeepAliveLink? _link;

final customLoopProviderFamily = StateNotifierProvider.family
    .autoDispose<CustomLoopNotifier, Loop?, YoutubePlayerController>(
  (ref, youtubePlayerController) {
    _link?.close();
    _link = ref.keepAlive();
    return CustomLoopNotifier(
      youtubePlayerController: youtubePlayerController,
    );
  },
);
