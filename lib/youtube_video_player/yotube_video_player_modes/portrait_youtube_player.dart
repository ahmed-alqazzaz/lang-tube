import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/views/main_subtitles_player.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/subtitles_player/utils/subtitle_player_model.dart';

class PortraitYoutubePlayer extends StatelessWidget {
  const PortraitYoutubePlayer({
    super.key,
    required this.controller,
    required this.subtitlesPlayerProvider,
  });
  final YoutubePlayerController controller;
  final FutureProvider<ChangeNotifierProvider<SubtitlePlayerModel>>
      subtitlesPlayerProvider;
  Widget subtitlePlayer() {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(subtitlesPlayerProvider).when(
          data: (data) {
            log('finished');
            return MainSubtitlesPlayer(
              subtitlePlayerProvider: data,
              onWordTapped: (x) {},
            );
          },
          error: (error, stackTrace) {
            log(error.toString());
            log(stackTrace.toString());
            return Container();
          },
          loading: () {
            log('loading');
            return Container();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              YoutubePlayer(
                controller: controller,
                bottomActions: const [],
                topActions: const [],
              ),
              Container(
                height: YoutubeVideoPlayerView.progressBarHandleRadius,
                color: Colors.transparent,
              ),
              // Positioned(
              //   bottom: 0.1 * height,
              //   left: 0.036 * width,
              //   child: positionIndicator(),
              // ),
              // Positioned(
              //   bottom: 0.1 * height,
              //   right: 0.036 * width,
              //   child: const Icon(Icons.fullscreen),
              // ),
              // Positioned(
              //   bottom: 0,
              //   left: -progressBarHandleRadius,
              //   right: -progressBarHandleRadius,
              //   child: progressBar(),
              // ),
            ],
          ),
          Expanded(child: subtitlePlayer()),
        ],
      ),
    );
  }
}
