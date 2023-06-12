import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../custom/widgets/youtube_player_widgets/custom_current_position.dart';
import '../../../custom/widgets/youtube_player_widgets/custom_progress_bar.dart';
import '../../../custom/icons/custom_icons.dart';
import '../../youtube_player_model/youtube_player_provider.dart';
import '../actions_provider.dart';

@immutable
class YoutubePlayerActions {
  YoutubePlayerActions({
    required YoutubePlayerModel youtubePlayerModel,
    required WidgetRef ref,
  })  : _ref = ref,
        _youtubePlayerController = youtubePlayerModel.youtubePlayerController,
        actionsProvider = youtubePlayerModel.actionsProvider;
  static const double buttonsPadding = 15;

  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const double progressBarThickness = 2;

  static const circularMenuItemBackgroundColor =
      Color.fromARGB(255, 50, 50, 50);
  final circularMenuToggleButtonColor = Colors.amber[600];

  final YoutubePlayerActionsProvider actionsProvider;
  final WidgetRef _ref;
  final YoutubePlayerController _youtubePlayerController;

  Widget progressBar() {
    return CustomProgressBar(
      controller: _youtubePlayerController,
      colors: ProgressBarColors(
        handleColor: progressBarPlayedColor,
        playedColor: progressBarPlayedColor,
        bufferedColor: progressBarBufferColor.withOpacity(0.7),
        backgroundColor: progressBarBackgroungColor.withOpacity(0.5),
      ),
      width: progressBarThickness,
      handleRadius: YoutubeVideoPlayerView.progressBarHandleRadius,
    );
  }

  Widget positionIndicator() => CustomCurrentPosition(
        controller: _youtubePlayerController,
      );

  Widget loopButton() {
    return genericButton(
      child: const Icon(
        Icons.repeat_one,
        color: Colors.white,
        size: 25,
      ),
      onPressed: _ref.read(actionsProvider).toggleSubtitleLoop,
    );
  }

  Widget playBackSpeedButton() {
    return genericButton(
      onPressed: () => _ref.read(actionsProvider).setPlaybackSpeed(0.75),
      child: const Text(
        '0.75x',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget saveClipButton() {
    return genericButton(
      onPressed: () {},
      child: const Icon(
        CustomIcons.selectMultiple,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  RawMaterialButton genericButton({
    required Widget child,
    required void Function() onPressed,
  }) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(15.0),
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget settingsButton() {
    return genericButton(
      child: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: _ref.read(actionsProvider).displayMainSettings,
    );
  }

  Widget subtitlesButton() {
    return genericButton(
      child: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: _ref.read(actionsProvider).displaySubtitlesSettings,
    );
  }

  Widget backButton() {
    return genericButton(
      child: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.white,
      ),
      onPressed: _ref.read(actionsProvider).exit,
    );
  }

  Widget toggleFullScreenButton({required bool isFullScreen}) {
    return genericButton(
      child: Icon(
        isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_sharp,
        color: Colors.white,
      ),
      onPressed: () {
        isFullScreen
            ? _ref.read(actionsProvider).exitFullScreen()
            : _ref.read(actionsProvider).enableFullScreen();
      },
    );
  }

  Widget youtubeButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.2)),
          child: const SizedBox(
            width: 130,
            height: 35,
            child: Icon(
              CustomIcons.youtubeIcon,
              color: Colors.white,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget actionsCircularMenu({required void Function() onActionsMenuToggled}) {
    CircularMenuItem genericCircularMenuItem({
      required IconData icon,
      Color iconColor = Colors.white,
      required void Function() onTap,
    }) {
      return CircularMenuItem(
        icon: icon,
        iconColor: iconColor,
        color: circularMenuItemBackgroundColor,
        onTap: onTap,
      );
    }

    CircularMenuItem circularMenuLoopButton(YoutubePlayerActionsModel model) {
      return genericCircularMenuItem(
        icon: Icons.repeat_one,
        iconColor: model.isSubtitleLoopActive ? Colors.white : Colors.white30,
        onTap: () async {
          model.toggleSubtitleLoop();
        },
      );
    }

    CircularMenuItem circularMenuSubtitlesButton(
        YoutubePlayerActionsModel model) {
      return genericCircularMenuItem(
        icon: Icons.closed_caption_rounded,
        onTap: () => model.displaySubtitlesSettings(),
      );
    }

    CircularMenuItem circulaMenuPlayBackSpeedButton(
        YoutubePlayerActionsModel model) {
      return genericCircularMenuItem(
        icon: Icons.speed,
        onTap: () => model.setPlaybackSpeed(0.75),
      );
    }

    final items = <CircularMenuItem Function(YoutubePlayerActionsModel)>[
      circularMenuLoopButton,
      circularMenuSubtitlesButton,
      circulaMenuPlayBackSpeedButton,
    ];

    return Consumer(
      builder: (context, ref, _) {
        return CircularMenu(
          toggleButtonColor: circularMenuToggleButtonColor,
          alignment: const Alignment(1, 0.95),
          startingAngleInRadian: 2.8,
          endingAngleInRadian: 4.8,
          toggleButtonSize: 25,
          toggleButtonOnPressed: onActionsMenuToggled,
          toggleButtonBoxShadow: const [
            BoxShadow(color: Colors.white, blurRadius: 0.5)
          ],
          items: items.map((item) => item(ref.watch(actionsProvider))).toList(),
        );
      },
    );
  }
}
