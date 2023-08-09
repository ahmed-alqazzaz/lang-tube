import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/views/generic_actions.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../custom/icons/custom_icons.dart';
import '../../action_providers/loop_providers/subtitle_loop_provider.dart/provider.dart';
import '../../action_providers/youtube_hd_provider/provider.dart';

class FullScreenPlayerActions extends ConsumerWidget {
  const FullScreenPlayerActions({
    super.key,
    required this.genericActions,
    required SubtitleLoopProvider subtitleLoopProvider,
    required YoutubeHdProvider youtubeHdProvider,
  })  : _youtubeHdProvider = youtubeHdProvider,
        _subtitleLoopProvider = subtitleLoopProvider;
  final YoutubePlayerGenericActions genericActions;
  final YoutubeHdProvider _youtubeHdProvider;
  final SubtitleLoopProvider _subtitleLoopProvider;

  Widget subtitlesSettingsButton() {
    return CircularInkWell(
      child: const Icon(
        Icons.closed_caption_rounded,
        color: Colors.white,
      ),
      onTap: () {},
    );
  }

  Widget settingsButton() {
    return CircularInkWell(
      child: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onTap: () {},
    );
  }

  Widget youtubeButton() {
    return RawMaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      highlightColor: Colors.white10,
      child: const SizedBox(
        width: 130,
        height: 35,
        child: Icon(
          CustomIcons.youtubeIcon,
          color: Colors.white,
          size: 24,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _hdButton({required double splashRadius}) {
    return Consumer(
      builder: (context, ref, _) {
        final iconSize = Theme.of(context).iconTheme.size!;
        final isHd = ref.watch(_youtubeHdProvider);
        final youtubeHdNotifier = ref.read(_youtubeHdProvider.notifier);
        return CircularInkWell(
          splashRadius: splashRadius,
          child: Icon(
            Icons.hd_rounded,
            size: iconSize - 3,
            color: isHd ? Colors.amber.shade600 : Colors.white,
          ),
          onTap: () => isHd
              ? youtubeHdNotifier.disableHd()
              : youtubeHdNotifier.forceHd(),
        );
      },
    );
  }

  Widget _subtitlesLoopButton({required double splashRadius}) {
    return Consumer(
      builder: (context, ref, _) {
        final isLoopActive =
            ref.watch(_subtitleLoopProvider.select((value) => value != null));
        final subtitleLoopNotifier = ref.read(_subtitleLoopProvider.notifier);
        return CircularInkWell(
          splashRadius: splashRadius,
          child: Icon(
            Icons.repeat_one_outlined,
            color: isLoopActive ? Colors.amber.shade600 : Colors.white,
          ),
          onTap: () => isLoopActive
              ? subtitleLoopNotifier.deactivateLoop()
              : subtitleLoopNotifier.activateLoop(),
        );
      },
    );
  }

  Widget midActions() {
    // LayoutBuilder(
    //   builder: (context, constraints) {
    //     bool showVideoDuration = true;
    //     return StatefulBuilder(builder: (context, setState) {
    //       return Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           SizedBox(width: constraints.maxWidth * 0.02),
    //           genericActions.currentDuration(),
    //           SizedBox(width: constraints.maxWidth * 0.01),
    //           Expanded(child: genericActions.progressBar()),
    //           SizedBox(width: constraints.maxWidth * 0.01),
    //           GestureDetector(
    //             child: showVideoDuration
    //                 ? genericActions.videoDuration()
    //                 : genericActions.remainingDuration(),
    //             onTap: () =>
    //                 setState(() => showVideoDuration = !showVideoDuration),
    //           ),
    //           SizedBox(width: constraints.maxWidth * 0.02),
    //         ],
    //       );
    //     });
    //   },
    // );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: progressBarHandleRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              genericActions.currentPositionIndicator(
                  padding: buttonsSplashRadius),
              genericActions.toggleFullScreenButton(),
            ],
          ),
        ),
        genericActions.progressBar(),
      ],
    );
  }

  Widget bottomActions() {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(width: constraints.maxWidth * 0.02),
          _subtitlesLoopButton(splashRadius: buttonsSplashRadius),
          SizedBox(width: constraints.maxWidth * 0.01),
          genericActions.customLoopButton(splashRadius: buttonsSplashRadius),
          SizedBox(width: constraints.maxWidth * 0.01),
          genericActions.playbackSpeedButton(splashRadius: buttonsSplashRadius),
          Expanded(child: Container()),
          youtubeButton(),
          SizedBox(width: constraints.maxWidth * 0.02),
        ],
      );
    });
  }

  Widget topActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(value: true, onChanged: (h) {}),
        _hdButton(splashRadius: 8),
        subtitlesSettingsButton(),
        settingsButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areActionsVisible = true;
    // ref.watch(
    //   actions._actionsProvider
    //       .select((actionsModel) => actionsModel.areFullScreenActionsVisible),
    // );
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
          bottomActions(),
          const SizedBox(height: 4)
        ],
      ),
    );
  }

  static const double buttonsSplashRadius = 8;
}
