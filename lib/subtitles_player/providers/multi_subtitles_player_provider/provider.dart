import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/multi_subtitles_player_provider/player.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;
import 'display_subtitles.dart';

KeepAliveLink? _keepAliveLink;

typedef MultiSubtitlesPlayerProvider
    = AutoDisposeStateNotifierProvider<MultiSubtitlesPlayer, DisplaySubtitles>;

final multiSubtitlesPlayerProvider = StateNotifierProvider.family.autoDispose<
    MultiSubtitlesPlayer,
    DisplaySubtitles,
    ({
      List<subtitles_player.Subtitle> mainSubtitles,
      List<subtitles_player.Subtitle> translatedSubtitles,
      ValueListenable<Duration> playbackPosition,
    })>(
  (ref, args) {
    _keepAliveLink?.close();
    _keepAliveLink = ref.keepAlive();
    return MultiSubtitlesPlayer(
      mainSubtitles: args.mainSubtitles,
      translatedSubtitles: args.translatedSubtitles,
      playbackPosition: args.playbackPosition,
    );
  },
);
