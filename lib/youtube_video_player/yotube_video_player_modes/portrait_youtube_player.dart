import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/subtitles_player_builders.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../subtitles_player/providers/multi_subtitles_player_provider/provider.dart';
import '../../subtitles_player/providers/player_pointer_absorbtion_provider.dart';
import '../actions/views/actions.dart';
import '../actions/views/portrait_screen_actions/mini_player_actions.dart';
import '../settings/subtitles_settings/settings.dart';

class PortraitYoutubePlayer extends ConsumerStatefulWidget {
  const PortraitYoutubePlayer({
    super.key,
    required this.player,
    required this.subtitlesSettings,
    required this.youtubePlayerController,
    required this.multiSubtitlesPlayerProvider,
  });
  final Widget player;
  final Widget subtitlesSettings;
  final YoutubePlayerController youtubePlayerController;
  final MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider;

  @override
  ConsumerState<PortraitYoutubePlayer> createState() =>
      _PortraitYoutubePlayerState();
}

class _PortraitYoutubePlayerState extends ConsumerState<PortraitYoutubePlayer>
    with SubtitlesPlayerBuilders {
  late YoutubePlayerActions actions = YoutubePlayerActions(
    subtitlesSettings: widget.subtitlesSettings,
    youtubePlayerController: widget.youtubePlayerController,
    currentSubtitleGetter: () =>
        ref.read(widget.multiSubtitlesPlayerProvider).mainSubtitle,
  );
  @override
  void didUpdateWidget(covariant PortraitYoutubePlayer oldWidget) {
    actions = YoutubePlayerActions(
      subtitlesSettings: widget.subtitlesSettings,
      youtubePlayerController: widget.youtubePlayerController,
      currentSubtitleGetter: () =>
          ref.read(widget.multiSubtitlesPlayerProvider).mainSubtitle,
    );
    super.didUpdateWidget(oldWidget);
  }

  Widget youtubePlayer() {
    return Stack(
      fit: StackFit.loose,
      children: [
        widget.player,
        Positioned.fill(
          child: actions.miniPlayerActions(),
        )
      ],
    );
  }

  Widget subtitlesPlayer(BuildContext context) {
    return mainSubtitlesPlayer(
      controller: widget.youtubePlayerController,
      multiSubtitlesPlayerProvider: widget.multiSubtitlesPlayerProvider,
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
          top: playerHeight - progressBarHandleRadius,
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _bodyBuilder(context),
            Positioned(
              height: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: actions.bottomActionsBarBuilder(),
            ),
            Positioned.fill(
              child: actions.actionsCircularMenuBuilder(
                onActionsMenuToggled: _onActionMenuToggled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
