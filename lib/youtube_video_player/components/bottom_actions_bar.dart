import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/components/custom_loop_button.dart';
import '../actions/views/generic_actions.dart';
import 'package:curved_bottom_bar/curved_bottom_bar.dart';

class BottomActionsBar extends StatelessWidget {
  const BottomActionsBar({
    super.key,
    required YoutubePlayerGenericActions genericActions,
    required Widget subtitlesSettings,
  })  : _subtitlesSettings = subtitlesSettings,
        _genericActions = genericActions;

  final Widget _subtitlesSettings;
  final YoutubePlayerGenericActions _genericActions;
  Widget subtitlesSettingsButton() {
    return Consumer(
      builder: (context, ref, _) {
        return CircularInkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              constraints: const BoxConstraints(minHeight: 0, maxHeight: 270),
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return _subtitlesSettings;
                  },
                );
              },
            );
          },
          splashRadius: buttonsSplashRadius,
          child: const Icon(
            Icons.closed_caption_rounded,
            color: Colors.white,
          ),
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
