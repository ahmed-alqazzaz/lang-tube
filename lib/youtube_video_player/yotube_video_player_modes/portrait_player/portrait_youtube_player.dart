import 'dart:developer';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/utils/word_selectability_provider.dart';
import 'package:lang_tube/subtitles_player/views/main_subtitles_player.dart';
import 'package:lang_tube/subtitles_player/views/subtitles_builder.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/actions.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_player_actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../explanation_modal/explanation_modal.dart';
import '../../../subtitles_player/utils/subtitle_player_model.dart';
import '../../../subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';

mixin SubtitlesPlayerBuilders {
  Widget mainSubtitlesPlayer({
    required YoutubePlayerController controller,
    required Widget Function({required SubtitlesBuilder builder})
        subtitlesPlayerBuilder,
  }) {
    return subtitlesPlayerBuilder(
      builder: (subtitlesPlayerProvider, context) {
        return ProviderScope(
          child: MainSubtitlesPlayer(
            subtitlePlayerProvider: subtitlesPlayerProvider,
            onTap: ({required Function() onReset, required String word}) {
              log('executed');
              controller.pause();
              showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  barrierColor: Colors.black12,
                  builder: (context) {
                    return ExplanationModal(
                      word: word.replaceAll(RegExp(r'[^a-zA-Z]'), ''),
                    );
                  }).then(
                (_) {
                  controller.play();
                  onReset();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class PortraitYoutubePlayer extends StatelessWidget
    with SubtitlesPlayerBuilders {
  const PortraitYoutubePlayer({
    super.key,
    required this.controller,
    required this.subtitlesPlayerBuilder,
  });
  final YoutubePlayerController controller;
  final Widget Function({required SubtitlesBuilder builder})
      subtitlesPlayerBuilder;

  @override
  Widget build(BuildContext context) {
    final playerHeight = MediaQuery.of(context).size.width * 9 / 16;
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              YoutubePlayer(
                controller: controller,
                bottomActions: const [],
                topActions: const [],
              ),
              Expanded(
                child: mainSubtitlesPlayer(
                  controller: controller,
                  subtitlesPlayerBuilder: subtitlesPlayerBuilder,
                ),
              ),
            ],
          ),
          SizedBox(
            height:
                playerHeight + YoutubeVideoPlayerView.progressBarHandleRadius,
            child: PortraitYoutubePlayerActions(controller: controller),
          ),
        ],
      ),
    );
  }
}
