// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lang_tube/subtitles_player/providers/multi_subtitles_player_provider/player.dart';
// import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;
// import 'display_subtitles.dart';

// KeepAliveLink? _keepAliveLink;

// typedef MultiSubtitlesPlayerProvider = StateNotifierProvider<
//     MultiSubtitlesPlayer, ConsumableSubtitles>;

// // final multiSubtitlesPlayerProvider = StateNotifierProvider.family.autoDispose<
// //     MultiSubtitlesPlayer,
// //     ConsumableSubtitles,
// //     ({
// //       List<subtitles_player.Subtitle> mainSubtitles,
// //       List<subtitles_player.Subtitle> translatedSubtitles,
// //       ValueListenable<Duration> playbackPosition,
// //     })>(
// //   (ref, args) {
// //     // Timer(const Duration(seconds: 1), () => _keepAliveLink?.close());
// //     _keepAliveLink?.close();
// //     _keepAliveLink = ref.keepAlive();
// //     return MultiSubtitlesPlayer(
// //       mainSubtitles: args.mainSubtitles,
// //       translatedSubtitles: args.translatedSubtitles,
// //       playbackPosition: args.playbackPosition,
// //     );
// //   },
// // );
