// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeHdNotifier extends StateNotifier<bool> {
//   YoutubeHdNotifier({required YoutubePlayerController youtubePlayerController})
//       : _youtubePlayerController = youtubePlayerController,
//         super(false);

//   final YoutubePlayerController _youtubePlayerController;
//   void forceHd() {
//     _youtubePlayerController.setVideoQuality(VideoQuality.hd1080p);
//     state = true;
//   }

//   void disableHd() {
//     _youtubePlayerController.setVideoQuality(VideoQuality.auto);
//     state = false;
//   }
// }
