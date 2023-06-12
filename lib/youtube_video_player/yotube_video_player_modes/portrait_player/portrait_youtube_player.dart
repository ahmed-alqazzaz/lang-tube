import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/subtitles_player/views/main_subtitles_player.dart';
import 'package:lang_tube/subtitles_player/views/subtitles_player_builders.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_provider.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/actions.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_player_model/youtube_player_provider.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/providers/player_pointer_absorbtion_provider.dart';
import '../../actions/views/actions.dart';

class PortraitYoutubePlayer extends ConsumerStatefulWidget {
  const PortraitYoutubePlayer({
    super.key,
    required this.youtubePlayerModel,
    required this.player,
  });
  final Widget player;
  final YoutubePlayerModel youtubePlayerModel;

  @override
  ConsumerState<PortraitYoutubePlayer> createState() =>
      _PortraitYoutubePlayerState();
}

class _PortraitYoutubePlayerState extends ConsumerState<PortraitYoutubePlayer>
    with SubtitlesPlayerBuilders {
  late final youtubePlayerController =
      widget.youtubePlayerModel.youtubePlayerController;
  late final subtitlesPlayerProvider =
      widget.youtubePlayerModel.subtitlesPlayerProvider;
  late final actions = YoutubePlayerActions(
    youtubePlayerModel: widget.youtubePlayerModel,
    ref: ref,
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
      controller: youtubePlayerController,
      subtitlesPlayerProvider: subtitlesPlayerProvider,
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
