import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../custom/widgets/youtube_player_widgets/custom_current_position.dart';
import '../../custom/widgets/youtube_player_widgets/custom_progress_bar.dart';
import '../../custom/icons/custom_icons.dart';

@immutable
class YoutubePlayerActions {
  const YoutubePlayerActions({
    required this.youtubePlayerController,
    required SubtitlesPlayerModel subtitlesPlayerModel,
  });

  final YoutubePlayerController youtubePlayerController;

  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const double progressBarThickness = 2;
  static const double buttonsPadding = 15;

  Widget progressBar() {
    return CustomProgressBar(
      controller: youtubePlayerController,
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
        controller: youtubePlayerController,
      );

  Widget loopButton(void Function() onPressed) {
    return genericButton(
        child: const Icon(
          Icons.repeat_one,
          color: Colors.white,
          size: 25,
        ),
        onPressed: onPressed);
  }

  Widget playBackSpeedButton(void Function() onPressed) {
    return genericButton(
      onPressed: onPressed,
      child: const Text(
        '0.75x',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget saveClipButton(void Function() onPressed) {
    return genericButton(
      onPressed: onPressed,
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

  Widget settingsButton(void Function() onPressed) {
    return genericButton(
      child: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }

  Widget backButton() {
    return genericButton(
        child: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.white,
        ),
        onPressed: () {} // _actionsController.exit,
        );
  }

  Widget toggleFullScreenButton({
    required bool isFullScreen,
  }) {
    return genericButton(
        child: Icon(
          isFullScreen
              ? Icons.fullscreen_exit_outlined
              : Icons.fullscreen_sharp,
          color: Colors.white,
        ),
        onPressed: () {}
        // isFullScreen
        //     ? _actionsController.exitFullScreen
        //     : _actionsController.enableFullScreen,
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
}
