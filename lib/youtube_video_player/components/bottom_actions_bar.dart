import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_bottom_bar/curved_bottom_bar.dart';

import 'custom_loop_button.dart';
import 'playback_speed_button.dart';
import 'settings.dart';

class BottomActionsBar extends StatelessWidget {
  const BottomActionsBar({
    super.key,
  });

  Widget subtitlesSettingsButton() {
    return Consumer(
      builder: (context, ref, _) {
        return CircularInkWell(
          onTap: () => _displaySubtitlesSettings(context),
          splashRadius: buttonsSplashRadius,
          child: const Icon(
            Icons.closed_caption_rounded,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Future<dynamic> _displaySubtitlesSettings(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(minHeight: 0, maxHeight: 270),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => const SubtitlesConfig(),
        );
      },
    );
  }

  Widget settingsButton() {
    return Consumer(
      builder: (context, ref, _) {
        return CircularInkWell(
          onTap: () => throw UnimplementedError,
          splashRadius: buttonsSplashRadius,
          child: Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: Theme.of(context).iconTheme.size! - 3,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomBar(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      actions: [
        subtitlesSettingsButton(),
        const YoutubeCustomLoopButton(splashRadius: buttonsSplashRadius),
        const YoutubePlaybackSpeedButton(splashRadius: buttonsSplashRadius),
        settingsButton()
      ],
    );
  }

  static const double buttonsSplashRadius = 12;
}
