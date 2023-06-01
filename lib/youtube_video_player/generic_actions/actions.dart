import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../custom/custom_current_position.dart';
import '../../custom/custom_progress_bar.dart';
import '../../custom/icons/custom_icons.dart';
import 'buttons/closed_caption_button.dart';
import 'buttons/full_screen_button.dart';

@immutable
class GenericActions {
  const GenericActions({required this.controller});

  final YoutubePlayerController controller;
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);

  static const double progressBarThickness = 2;

  Widget progressBar() {
    return CustomProgressBar(
      controller: controller,
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

  Widget genericButton(Widget child) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.2)),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
      ),
      child: child,
    );
  }

  Widget captionButton() => const ClosedCaptionsButton();

  Widget fullScreenButton() => genericButton(
        const FullScreenToggleButton(),
      );

  Widget positionIndicator() => CustomCurrentPosition(
        controller: controller,
      );

  Widget loopButton() {
    return genericButton(
      const Icon(
        Icons.repeat_one,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  Widget playBackSpeedButton() {
    return genericButton(
      const Text(
        '0.75x',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget saveClipButton() {
    return genericButton(
      const Icon(
        CustomIcons.selectMultiple,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  Widget settingsButton() {
    return genericButton(
      const Icon(
        Icons.settings_outlined,
        color: Colors.white,
        size: 25,
      ),
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
