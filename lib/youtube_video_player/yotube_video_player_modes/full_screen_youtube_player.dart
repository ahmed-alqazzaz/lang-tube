import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/components/full_screen_player_actions.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/subtitles_player_provider.dart';
import 'subtitles_player_builders.dart';

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
    extends ConsumerState<FullScreenYoutubeVideoPlayer>
    with SubtitlesPlayerBuilders {
  Widget _youtubePlayerBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.player,
            Positioned(
              bottom: 70,
              right: 50,
              left: 50,
              child: miniSubtitlesPlayer(
                maxLines: 2,
                controller: ref.read(youtubeControllerProvider)!,
                context: context,
              ),
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
          child: mainSubtitlesPlayer(
            controller: ref.read(youtubeControllerProvider)!,
            context: context,
          ),
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
