import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../subtitles_player/providers/multi_subtitles_player_provider/provider.dart';
import 'subtitles_player_builders.dart';
import '../actions/views/actions.dart';
import '../actions/views/full_screen_actions/full_screen_player_actions.dart';

class FullScreenYoutubeVideoPlayer extends ConsumerStatefulWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.player,
    required this.youtubePlayerController,
    required this.multiSubtitlesPlayerProvider,
  });
  final Widget player;
  final YoutubePlayerController youtubePlayerController;
  final MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider;

  @override
  ConsumerState<FullScreenYoutubeVideoPlayer> createState() =>
      _FullScreenYoutubeVideoPlayerState();
}

class _FullScreenYoutubeVideoPlayerState
    extends ConsumerState<FullScreenYoutubeVideoPlayer>
    with SubtitlesPlayerBuilders {
  late final actions = YoutubePlayerActions(
    subtitlesSettings: Container(),
    youtubePlayerController: widget.youtubePlayerController,
    currentSubtitleGetter: () =>
        ref.read(widget.multiSubtitlesPlayerProvider).mainSubtitle,
  );
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
                controller: widget.youtubePlayerController,
                multiSubtitlesPlayerProvider:
                    widget.multiSubtitlesPlayerProvider,
                context: context,
              ),
            ),
            Positioned(
              right: progressBarHandleRadius,
              left: progressBarHandleRadius,
              top: 0,
              bottom: 0,
              child: actions.fullScreenActions(),
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
            controller: widget.youtubePlayerController,
            multiSubtitlesPlayerProvider: widget.multiSubtitlesPlayerProvider,
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
