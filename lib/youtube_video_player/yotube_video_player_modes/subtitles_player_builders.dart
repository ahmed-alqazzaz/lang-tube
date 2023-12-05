import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../subtitles_player/main_subtitles_player.dart';
import '../subtitles_player/mini_subtitles_player.dart';

mixin SubtitlesPlayerBuilders {
  MiniSubtitlesPlayer miniSubtitlesPlayer({
    required BuildContext context,
    required int maxLines,
    required YoutubePlayerController controller,
  }) {
    return MiniSubtitlesPlayer(
      maxLines: maxLines,
      onTap: ({required Function() onReset, required String word}) {
        controller.pause();
        showModalBottomSheet(
          constraints: const BoxConstraints(
            minHeight: 300,
            maxHeight: 300,
            minWidth: 400,
            maxWidth: 400,
          ),
          context: context,
          builder: (context) {
            return Container();
          },
        ).then(
          (value) {
            controller.play();
            onReset();
          },
        );
      },
    );
  }

  MainSubtitlesPlayer mainSubtitlesPlayer({
    required YoutubePlayerController controller,
    required BuildContext context,
  }) {
    return const MainSubtitlesPlayer(
      headerBackgroundColor: Color.fromARGB(255, 20, 20, 20),
    );
  }
}
