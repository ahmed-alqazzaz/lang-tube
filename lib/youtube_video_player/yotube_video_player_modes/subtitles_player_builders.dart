import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../explanation_modal/explanation_modal.dart';
import '../../subtitles_player/providers/multi_subtitles_player_provider/provider.dart';
import '../../subtitles_player/views/main_subtitles_player.dart';
import '../../subtitles_player/views/mini_subtitles_player.dart';

mixin SubtitlesPlayerBuilders {
  MiniSubtitlesPlayer miniSubtitlesPlayer({
    required BuildContext context,
    required int maxLines,
    required YoutubePlayerController controller,
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
  }) {
    return MiniSubtitlesPlayer(
      maxLines: maxLines,
      multiSubtitlesPlayerProvider: multiSubtitlesPlayerProvider,
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
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
    required BuildContext context,
  }) {
    return MainSubtitlesPlayer(
      youtubePlayerController: controller,
      headerBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
      multiSubtitlesPlayerProvider: multiSubtitlesPlayerProvider,
      onTap: ({required Function() onReset, required String word}) {
        controller.pause();
        showModalBottomSheet(
            showDragHandle: true,
            context: context,
            barrierColor: Colors.black12,
            isScrollControlled: true,
            builder: (context) {
              return ExplanationModalSheet(
                word: word.replaceAll(RegExp(r'[^a-zA-Z]'), ''),
              );
            }).then(
          (_) {
            controller.play();
            onReset();
          },
        );
      },
    );
  }
}
