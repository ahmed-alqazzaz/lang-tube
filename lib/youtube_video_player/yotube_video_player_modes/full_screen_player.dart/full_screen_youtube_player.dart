import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import '../../../subtitles_player/views/subtitles_player_builders.dart';
import '../../actions/views/actions.dart';
import '../../youtube_player_model/youtube_player_provider.dart';
import 'full_screen_player_action.dart';

class FullScreenYoutubeVideoPlayer extends ConsumerStatefulWidget {
  const FullScreenYoutubeVideoPlayer({
    super.key,
    required this.player,
    required this.youtubePlayerModel,
  });
  final Widget player;
  final YoutubePlayerModel youtubePlayerModel;

  @override
  ConsumerState<FullScreenYoutubeVideoPlayer> createState() =>
      _FullScreenYoutubeVideoPlayerState();
}

class _FullScreenYoutubeVideoPlayerState
    extends ConsumerState<FullScreenYoutubeVideoPlayer>
    with SubtitlesPlayerBuilders {
  late final youtubePlayerController =
      widget.youtubePlayerModel.youtubePlayerController;
  late final subtitlesPlayerProvider =
      widget.youtubePlayerModel.subtitlesPlayerProvider;
  late final actions = YoutubePlayerActions(
    youtubePlayerModel: widget.youtubePlayerModel,
    ref: ref,
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
              controller: youtubePlayerController,
              subtitlesPlayerProvider: subtitlesPlayerProvider,
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
            controller: youtubePlayerController,
            subtitlesPlayerProvider: subtitlesPlayerProvider,
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
