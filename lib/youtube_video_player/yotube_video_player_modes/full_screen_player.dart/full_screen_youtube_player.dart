import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../subtitles_player/providers/subtitle_player_provider.dart';
import '../../../subtitles_player/views/subtitles_player_builders.dart';
import '../../actions/actions_provider.dart';
import '../../actions/views/actions.dart';
import '../../youtube_player_model/youtube_player_provider.dart';
import 'full_screen_player_action.dart';

class FullScreenYoutubeVideoPlayer extends ConsumerStatefulWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.player,
    required this.youtubePlayerController,
    required this.actionsProvider,
    required this.subtitlesPlayerProvider,
  });
  final Widget player;
  final YoutubePlayerController youtubePlayerController;
  final YoutubePlayerActionsProvider actionsProvider;
  final SubtitlesPlayerProvider subtitlesPlayerProvider;

  @override
  ConsumerState<FullScreenYoutubeVideoPlayer> createState() =>
      _FullScreenYoutubeVideoPlayerState();
}

class _FullScreenYoutubeVideoPlayerState
    extends ConsumerState<FullScreenYoutubeVideoPlayer>
    with SubtitlesPlayerBuilders {
  late final actions = YoutubePlayerActions(
    ref: ref,
    actionsProvider: widget.actionsProvider,
    youtubePlayerController: widget.youtubePlayerController,
  );
  Widget _youtubePlayerBuilder() {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          widget.player,
          Positioned(
            bottom: 30,
            right: 150,
            left: 150,
            child: miniSubtitlesPlayer(
              controller: widget.youtubePlayerController,
              subtitlesPlayerProvider: widget.subtitlesPlayerProvider,
              context: context,
            ),
          ),
          Positioned(
            right: YoutubeVideoPlayerView.progressBarHandleRadius,
            left: YoutubeVideoPlayerView.progressBarHandleRadius,
            top: 0,
            bottom: 0,
            child: FullScreenYoutubePlayerActions(
              actions: actions,
            ),
          ),
        ],
      );
    });
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
            subtitlesPlayerProvider: widget.subtitlesPlayerProvider,
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
        drawerSubtitlesPlayer(context),
        Expanded(
          child: _youtubePlayerBuilder(),
        ),
      ],
    );
  }
}
