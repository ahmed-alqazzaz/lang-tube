import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/components/actions_circular_menu.dart';
import 'package:lang_tube/youtube_video_player/components/bottom_actions_bar.dart';
import 'package:lang_tube/youtube_video_player/components/custom_progress_bar.dart';
import 'package:lang_tube/youtube_video_player/components/mini_player_actions.dart';
import 'package:lang_tube/youtube_video_player/subtitles_player/main_subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/actions_menu_activity_provider.dart';

class PortraitYoutubePlayer extends StatelessWidget {
  const PortraitYoutubePlayer({super.key, required this.player});
  final Widget player;

  Widget youtubePlayer() {
    return Stack(
      fit: StackFit.loose,
      children: [
        player,
        const Positioned.fill(
          child: MiniPlayerActions(),
        )
      ],
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
            const Expanded(child: MainSubtitlesPlayer()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _bodyBuilder(context),
            const Positioned(
              height: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomActionsBar(),
            ),
            Positioned.fill(
              child: Consumer(
                builder: (context, ref, _) {
                  return ActionsCircularMenu(
                    onActionsMenuToggled:
                        ref.read(actionsMenuActivityProvider.notifier).toggle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
