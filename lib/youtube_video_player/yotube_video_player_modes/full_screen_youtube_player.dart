import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_player_provider.dart/provider.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'subtitles_player_builders.dart';
import '../actions/views/actions.dart';

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
  late final actions = YoutubePlayerActions(
    subtitlesSettings: Container(),
    youtubePlayerController: ref.read(youtubeControllerProvider)!,
    currentSubtitleGetter: () =>
        ref.read(subtitlesPlayerProvider).currentSubtitles.mainSubtitle,
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
                controller: ref.read(youtubeControllerProvider)!,
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
