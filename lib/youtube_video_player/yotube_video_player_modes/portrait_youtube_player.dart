import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/components/actions_circular_menu.dart';
import 'package:lang_tube/youtube_video_player/components/bottom_actions_bar.dart';
import 'package:lang_tube/youtube_video_player/components/custom_progress_bar.dart';
import 'package:lang_tube/youtube_video_player/components/mini_player_actions.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/subtitles_player_builders.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../subtitles_player/providers/player_pointer_absorbtion_provider.dart';
import '../providers/subtitles_player_provider.dart';
import '../providers/youtube_controller_provider.dart';

class PortraitYoutubePlayer extends ConsumerStatefulWidget {
  const PortraitYoutubePlayer({
    super.key,
    required this.player,
    required this.subtitlesSettings,
  });
  final Widget player;
  final Widget subtitlesSettings;

  @override
  ConsumerState<PortraitYoutubePlayer> createState() =>
      _PortraitYoutubePlayerState();
}

class _PortraitYoutubePlayerState extends ConsumerState<PortraitYoutubePlayer>
    with SubtitlesPlayerBuilders {
  @override
  void didUpdateWidget(covariant PortraitYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget youtubePlayer() {
    return Stack(
      fit: StackFit.loose,
      children: [
        widget.player,
        const Positioned.fill(
          child: MiniPlayerActions(),
        )
      ],
    );
  }

  Widget subtitlesPlayer(BuildContext context) {
    return mainSubtitlesPlayer(
      controller: ref.read(youtubeControllerProvider)!,
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
          child: const CustomProgressBar(),
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
              child: BottomActionsBar(),
            ),
            Positioned.fill(
              child: ActionsCircularMenu(
                onActionsMenuToggled: _onActionMenuToggled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
