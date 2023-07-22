import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';

import '../../actions/views/actions.dart';

class FullScreenYoutubePlayerActions extends ConsumerWidget {
  const FullScreenYoutubePlayerActions({
    super.key,
    required this.actions,
  });

  final YoutubePlayerActions actions;

  Widget midActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: YoutubeVideoPlayerView.progressBarHandleRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              actions.positionIndicator(),
              actions.toggleFullScreenButton(isFullScreen: true),
            ],
          ),
        ),
        actions.progressBar(),
      ],
    );
  }

  Widget bottomActions() {
    return Row(
      children: [
        actions.saveClipButton(),
        actions.loopButton(),
        actions.playBackSpeedButton(),
        Expanded(child: Container()),
        actions.youtubeButton(),
      ],
    );
  }

  Widget topActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(value: true, onChanged: (h) {}),
        actions.subtitlesButton(),
        actions.settingsButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areActionsVisible = ref.watch(
      actions.actionsProvider
          .select((actionsModel) => actionsModel.areFullScreenActionsVisible),
    );
    return AnimatedOpacity(
      opacity: areActionsVisible ? 1.0 : 0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          topActions(),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          midActions(),
          const SizedBox(height: 4),
          bottomActions(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
