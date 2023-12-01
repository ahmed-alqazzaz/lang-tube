// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'notifier.dart';

// typedef YoutubeHdProvider
//     = AutoDisposeStateNotifierProvider<YoutubeHdNotifier, bool>;

// KeepAliveLink? _link;
// final youtubeHdProviderFamily = StateNotifierProvider.family
//     .autoDispose<YoutubeHdNotifier, bool, YoutubePlayerController>(
//   (ref, controller) {
//     _link?.close();
//     _link = ref.keepAlive();
//     return YoutubeHdNotifier(youtubePlayerController: controller);
//   },
// );
