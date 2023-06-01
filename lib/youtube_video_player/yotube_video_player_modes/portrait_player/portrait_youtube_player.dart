import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/views/main_subtitles_player.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/actions.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_player_actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/utils/subtitle_player_model.dart';

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
            return ProviderScope(
              child: MainSubtitlesPlayer(
                subtitlePlayerProvider: data,
                onWordTapped: (x) {},
              ),
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
                child: subtitlePlayer(),
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
