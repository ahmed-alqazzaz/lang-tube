import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/components/full_screen_player_actions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../subtitles_player/main_subtitles_player.dart';
import '../subtitles_player/mini_subtitles_player.dart';

class FullScreenYoutubeVideoPlayer extends ConsumerStatefulWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.player,
  });
  final Widget player;

  @override
  ConsumerState<FullScreenYoutubeVideoPlayer> createState() =>
      _FullScreenYoutubeVideoPlayerState();
}

class _FullScreenYoutubeVideoPlayerState
    extends ConsumerState<FullScreenYoutubeVideoPlayer> {
  Widget _youtubePlayerBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.player,
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

  Widget drawerSubtitlesPlayer(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: size.height,
      width: true ? size.height : 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: size.height,
          child: const MainSubtitlesPlayer(),
        ),
      ),
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
