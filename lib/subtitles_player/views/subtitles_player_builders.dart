import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../explanation_modal/explanation_modal.dart';
import '../providers/subtitle_player_provider.dart';
import 'main_subtitles_player.dart';
import 'mini_subtitles_player.dart';

mixin SubtitlesPlayerBuilders {
  SubtitlesPlayerBuilder miniSubtitlesPlayer({
    required BuildContext context,
    required YoutubePlayerController controller,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
  }) {
    return MiniSubtitlesPlayerBuilder(
      controller: controller,
      subtitlesPlayerProvider: subtitlesPlayerProvider,
    );
  }

  SubtitlesPlayerBuilder mainSubtitlesPlayer({
    required YoutubePlayerController controller,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required BuildContext context,
  }) {
    return MainSubtitlesPlayerBuilder(
      controller: controller,
      subtitlesPlayerProvider: subtitlesPlayerProvider,
    );
  }
}

abstract class SubtitlesPlayerBuilder extends StatelessWidget {
  const SubtitlesPlayerBuilder({
    super.key,
    required this.controller,
    required this.subtitlesPlayerProvider,
  });
  final YoutubePlayerController controller;
  final SubtitlesPlayerProvider subtitlesPlayerProvider;

  @override
  Widget build(BuildContext context);
}

class MiniSubtitlesPlayerBuilder extends SubtitlesPlayerBuilder {
  const MiniSubtitlesPlayerBuilder(
      {super.key,
      required super.controller,
      required super.subtitlesPlayerProvider});

  @override
  Widget build(BuildContext context) {
    return MiniSubtitlesPlayer(
      subtitlesPlayerProvider: subtitlesPlayerProvider,
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
  const MainSubtitlesPlayerBuilder(
      {super.key,
      required super.controller,
      required super.subtitlesPlayerProvider});

  @override
  Widget build(BuildContext context) {
    return MainSubtitlesPlayer(
      subtitlesPlayerProvider: subtitlesPlayerProvider,
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
