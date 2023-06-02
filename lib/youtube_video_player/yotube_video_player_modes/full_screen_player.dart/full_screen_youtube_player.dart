import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/views/subtitles_player_builders.dart';
import 'full_screen_player_action.dart';

class FullScreenYoutubeVideoPlayer extends StatefulWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.controller,
    required this.subtitlesPlayerBuilder,
  });
  final YoutubePlayerController controller;
  final Widget Function({required SubtitlesBuilder builder})
      subtitlesPlayerBuilder;

  @override
  State<FullScreenYoutubeVideoPlayer> createState() =>
      _FullScreenYoutubeVideoPlayerState();
}

class _FullScreenYoutubeVideoPlayerState
    extends State<FullScreenYoutubeVideoPlayer> with SubtitlesPlayerBuilders {
  Widget _youtubePlayerBuilder() {
    return Stack(
      alignment: Alignment.center,
      children: [
        YoutubePlayer(
          controller: widget.controller,
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
          child: miniSubtitlesPlayer(
            controller: widget.controller,
            subtitlesPlayerBuilder: widget.subtitlesPlayerBuilder,
          ),
        ),
        Positioned(
          right: YoutubeVideoPlayerView.progressBarHandleRadius,
          left: YoutubeVideoPlayerView.progressBarHandleRadius,
          top: 0,
          bottom: 0,
          child: FullScreenYoutubePlayerActions(
            controller: widget.controller,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _youtubePlayerBuilder();
  }
}
