import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/views/main_subtitles_player.dart';

import 'package:lang_tube/subtitles_player/views/mini_subtitles_player.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/actions_provider.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/utils/subtitle_player_model.dart';
import '../../../subtitles_player/utils/word_selectability_provider.dart';
import 'full_screen_player_action.dart';

class FullScreenYoutubeVideoPlayer extends StatelessWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.controller,
    required this.subtitlesPlayerProvider,
  });
  final YoutubePlayerController controller;
  final FutureProvider<ChangeNotifierProvider<SubtitlePlayerModel>>
      subtitlesPlayerProvider;
  Widget subtitlePlayer() {
    return Consumer(
      builder: (context, ref, child) {
        final isEnabled = ref.watch(actionsProvider
            .select((notifier) => notifier.isClosedCaptionEnabled));
        if (isEnabled) {
          return ref.watch(subtitlesPlayerProvider).when(
            data: (data) {
              log('finished');
              return MiniSubtitlesPlayer(
                subtitlePlayerProvider: data,
                onWordTapped: (String word) {
                  controller.pause();
                  showModalBottomSheet(
                    constraints: BoxConstraints(
                      minHeight: 300,
                      maxHeight: 300,
                      minWidth: 400,
                      maxWidth: 400,
                    ),
                    context: context,
                    builder: (context) {
                      return MainSubtitlesPlayer(
                          subtitlePlayerProvider: data,
                          onWordTapped: (String v) {});
                    },
                  ).then(
                    (value) {
                      controller.play();
                      ref.read(wordSelectabilityProvider).reset();
                    },
                  );
                },
              );
            },
            error: (error, stackTrace) {
              log(error.toString());
              print(stackTrace);
              return Container();
            },
            loading: () {
              log('loading');
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.fromSize(
          size: MediaQuery.of(context).size,
        ),
        YoutubePlayer(
          controller: controller,
          bottomActions: const [],
          topActions: const [],
          controlsTimeOut: const Duration(days: 1),
        ),
        // 0.5 = 1
        // 16/19 = x

        Positioned(
          bottom: 30,
          right: 150,
          left: 150,
          child: subtitlePlayer(),
        ),
        Positioned(
          right: YoutubeVideoPlayerView.progressBarHandleRadius,
          left: YoutubeVideoPlayerView.progressBarHandleRadius,
          top: 0,
          bottom: 0,
          child: FullScreenYoutubePlayerActions(
            controller: controller,
          ),
        ),
      ],
    );
  }
}
