import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PortraitYoutubePlayerActions extends StatelessWidget {
  PortraitYoutubePlayerActions({super.key, required this.controller})
      : actions = GenericActions(controller: controller);

  final YoutubePlayerController controller;
  final GenericActions actions;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        actions.progressBar(),
      ],
    );
  }
}
