import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/views/subtitles_player_builders.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_player_model/youtube_player_provider.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/providers/player_pointer_absorbtion_provider.dart';
import '../../../subtitles_player/providers/subtitle_player_provider.dart';
import '../../actions/actions_provider.dart';
import '../../actions/views/actions.dart';

class PortraitYoutubePlayer extends ConsumerStatefulWidget {
  const PortraitYoutubePlayer({
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
  ConsumerState<PortraitYoutubePlayer> createState() =>
      _PortraitYoutubePlayerState();
}

class _PortraitYoutubePlayerState extends ConsumerState<PortraitYoutubePlayer>
    with SubtitlesPlayerBuilders {
  late final actions = YoutubePlayerActions(
    ref: ref,
    actionsProvider: widget.actionsProvider,
    youtubePlayerController: widget.youtubePlayerController,
  );
  late final BehaviorSubject<bool> _subtitlesPlayerPointersController;
  @override
  void initState() {
    _subtitlesPlayerPointersController = BehaviorSubject();
    super.initState();
  }

  @override
  void dispose() {
    _subtitlesPlayerPointersController.close();
    super.dispose();
  }

  Widget youtubePlayer() {
    return Stack(
      fit: StackFit.loose,
      children: [
        widget.player,
        Positioned.fill(
          child: PortraitPlayerActions(
            actions: actions,
          ),
        )
      ],
    );
  }

  Widget subtitlesPlayer(BuildContext context) {
    return mainSubtitlesPlayer(
      controller: widget.youtubePlayerController,
      subtitlesPlayerProvider: widget.subtitlesPlayerProvider,
      context: context,
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    final playerHeight = MediaQuery.of(context).size.width * 9 / 16;
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            youtubePlayer(),
            Expanded(
              child: subtitlesPlayer(context),
            ),
          ],
        ),
        Positioned(
          top: playerHeight - YoutubeVideoPlayerView.progressBarHandleRadius,
          left: 0,
          right: 0,
          child: actions.progressBar(),
        ),
      ],
    );
  }

  void _onActionMenuToggled() {
    final isAbsorbingPointers =
        ref.read(mainSubtitlesPlayerPointerAbsorbtionProvider);
    final notifier =
        ref.read(mainSubtitlesPlayerPointerAbsorbtionProvider.notifier);
    isAbsorbingPointers
        ? notifier.neverAbsorbPointers()
        : notifier.absorbPointers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _bodyBuilder(context),
          Positioned.fill(
            child: actions.actionsCircularMenu(
              onActionsMenuToggled: _onActionMenuToggled,
            ),
          ),
        ],
      ),
    );
  }
}
