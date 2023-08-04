import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../raw_loop_notifier/loop.dart';
import 'notifier.dart';

typedef SubtitleLoopProvider
    = AutoDisposeStateNotifierProvider<SubtitleLoopNotifier, Loop?>;
KeepAliveLink? _link;
final subtitleLoopProviderFamily = StateNotifierProvider.family.autoDispose<
    SubtitleLoopNotifier,
    Loop?,
    ({
      CurrentSubtitleGetter currentSubtitleGetter,
      YoutubePlayerController youtubePlayerController,
      int loopCount
    })>(
  (ref, args) {
    _link?.close();
    _link = ref.keepAlive();
    return SubtitleLoopNotifier(
      youtubePlayerController: args.youtubePlayerController,
      currentSubtitleGetter: args.currentSubtitleGetter,
      loopCount: args.loopCount,
    );
  },
);
