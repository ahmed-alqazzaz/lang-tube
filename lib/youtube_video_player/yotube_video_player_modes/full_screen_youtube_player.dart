import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/components/full_screen_player_actions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../subtitles_player/main_subtitles_player.dart';
import '../subtitles_player/mini_subtitles_player.dart';

class FullScreenYoutubePlayer extends StatelessWidget {
  const FullScreenYoutubePlayer({super.key, required this.player});
  final Widget player;

  Widget _youtubePlayerBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            player,
            const Positioned(
              bottom: 70,
              right: 50,
              left: 50,
              child: MiniSubtitlesPlayer(maxLines: 2),
            ),
            const Positioned(
              right: progressBarHandleRadius,
              left: progressBarHandleRadius,
              top: 0,
              bottom: 0,
              child: FullScreenPlayerActions(),
            ),
          ],
        );
      },
    );
  }

  Widget drawerSubtitlesPlayer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: constraints.maxHeight,
          width: true ? constraints.maxHeight : 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxHeight,
              child: const MainSubtitlesPlayer(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //drawerSubtitlesPlayer(context),
        Expanded(
          child: _youtubePlayerBuilder(),
        ),
      ],
    );
  }
}
