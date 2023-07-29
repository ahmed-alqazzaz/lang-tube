import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../explanation_modal/explanation_modal.dart';
import '../providers/multi_subtitles_player_provider/provider.dart';
import '../providers/subtitle_player_provider.dart';
import 'main_subtitles_player.dart';
import 'mini_subtitles_player.dart';

mixin SubtitlesPlayerBuilders {
  SubtitlesPlayerBuilder miniSubtitlesPlayer({
    required BuildContext context,
    required YoutubePlayerController controller,
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
  }) {
    return MiniSubtitlesPlayerBuilder(
      controller: controller,
      multiSubtitlesPlayerProvider: multiSubtitlesPlayerProvider,
    );
  }

  SubtitlesPlayerBuilder mainSubtitlesPlayer({
    required YoutubePlayerController controller,
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
    required BuildContext context,
  }) {
    return MainSubtitlesPlayerBuilder(
      headerBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
      controller: controller,
      multiSubtitlesPlayerProvider: multiSubtitlesPlayerProvider,
    );
  }
}

abstract class SubtitlesPlayerBuilder extends StatelessWidget {
  const SubtitlesPlayerBuilder({
    super.key,
    required this.controller,
    required this.multiSubtitlesPlayerProvider,
  });
  final YoutubePlayerController controller;
  final MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider;

  @override
  Widget build(BuildContext context);
}

class MiniSubtitlesPlayerBuilder extends SubtitlesPlayerBuilder {
  const MiniSubtitlesPlayerBuilder({
    super.key,
    required super.controller,
    required super.multiSubtitlesPlayerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MiniSubtitlesPlayer(
      multiSubtitlesPlayerProvider: super.multiSubtitlesPlayerProvider,
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
}

class MainSubtitlesPlayerBuilder extends SubtitlesPlayerBuilder {
  const MainSubtitlesPlayerBuilder({
    super.key,
    required super.controller,
    required super.multiSubtitlesPlayerProvider,
    required this.headerBackgroundColor,
  });
  final Color headerBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return MainSubtitlesPlayer(
      youtubePlayerController: controller,
      headerBackgroundColor: headerBackgroundColor,
      multiSubtitlesPlayerProvider: super.multiSubtitlesPlayerProvider,
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

final playerKey = GlobalKey();
