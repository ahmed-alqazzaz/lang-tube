import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lang_tube/youtube_video_player/utils/subtitles_player/views/subtitles_player.dart';
import 'package:lang_tube/youtube_video_player/utils/controls/actions_provider.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player_view.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utils/subtitles_player/utils/word_selectability_provider.dart';
import '../utils/controls/youtube_video_player_controls.dart';

class FullScreenYoutubeVideoPlayer extends YoutubeVideoPlayerView {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required super.controller,
    required super.subtitlesPlayerProvider,
  });
  Widget subtitlePlayer() {
    return Consumer(
      builder: (context, ref, child) {
        final isEnabled = ref.watch(actionsProvider
            .select((notifier) => notifier.isClosedCaptionEnabled));
        if (isEnabled) {
          return ref.watch(subtitlesPlayerProvider).when(
            data: (data) {
              return SubtitlesPlayer(
                subtitlePlayerProvider: data,
                onWordTapped: (String word) {
                  controller.pause();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container();
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
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  final double tmp = 16 / 9;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.fromSize(
          size: MediaQuery.of(context).size,
        ),
        player(
          onReady: () {
            Timer(const Duration(milliseconds: 1500), () {
              controller.seekTo(controller.value.position);
            });
          },
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
          child: YoutubeVideoPlayerActions(
            controller: controller,
          ),
        ),
      ],
    );
  }
}
