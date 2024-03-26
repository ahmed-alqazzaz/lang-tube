import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'providers/youtube_controller_provider.dart';
import 'yotube_video_player_modes/full_screen_youtube_player.dart';
import 'yotube_video_player_modes/portrait_youtube_player.dart';

class YoutubeVideoPlayerView extends ConsumerStatefulWidget {
  const YoutubeVideoPlayerView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YoutubeVideoPlayerViewState();
}

class _YoutubeVideoPlayerViewState
    extends ConsumerState<YoutubeVideoPlayerView> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // MultiSubtitlesPlayerProvider buildMultiSubtitlesPlayerProvider({
  //   required List<Subtitle>? mainSubtitles,
  //   required List<Subtitle>? translatedSubtitles,
  // }) {
  //   return multiSubtitlesPlayerProvider((
  //     mainSubtitles: mainSubtitles ?? [],
  //     translatedSubtitles: translatedSubtitles ?? [],
  //     playbackPosition:
  //         _youtubePlayerController.where((event) => !event.isDragging).syncMap(
  //               (value) => value.position,
  //             )
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
        iconTheme: theme.iconTheme.copyWith(size: 30),
      ),
      child: Scaffold(
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: ref.read(youtubeControllerProvider),
            bottomActions: const [],
            topActions: const [],
          ),
          builder: (context, player) {
            return OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? PortraitYoutubePlayer(player: player)
                    : FullScreenYoutubePlayer(player: player);
              },
            );
          },
        ),
      ),
    );
  }
}
