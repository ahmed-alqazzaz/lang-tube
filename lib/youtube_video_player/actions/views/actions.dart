import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/action_providers/full_screen_provider/provider.dart';
import 'package:lang_tube/youtube_video_player/action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
import 'package:lang_tube/youtube_video_player/action_providers/loop_providers/subtitle_loop_provider.dart/notifier.dart';
import 'package:lang_tube/youtube_video_player/actions/views/actions_circular_menu.dart';
import 'package:lang_tube/youtube_video_player/actions/views/bottom_actions_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../custom/icons/custom_icons.dart';
import '../../action_providers/loop_providers/raw_loop_notifier/loop.dart';
import '../../action_providers/loop_providers/subtitle_loop_provider.dart/provider.dart';
import '../../action_providers/youtube_hd_provider/provider.dart';

@immutable
class YoutubePlayerActions {
  YoutubePlayerActions({
    required YoutubePlayerController youtubePlayerController,
    required CurrentSubtitleGetter currentSubtitleGetter,
  })  : _youtubePlayerController = youtubePlayerController,
        _customLoopProvider = customLoopProviderFamily(youtubePlayerController),
        _youtubeHdProvider = youtubeHdProviderFamily(youtubePlayerController),
        _subtitleLoopProvider = subtitleLoopProviderFamily((
          youtubePlayerController: youtubePlayerController,
          currentSubtitleGetter: currentSubtitleGetter,
          loopCount: 1
        ));
  static const double buttonsPadding = 15;
  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const Color progressBarSubtitleLoopColor = Colors.amber;
  static const Color progressBarCustomLoopColor = Colors.amber;
  static const double progressBarThickness = 2;

  static const circularMenuItemBackgroundColor =
      Color.fromARGB(255, 50, 50, 50);

  final circularMenuToggleButtonColor = Colors.amber[600];
  final YoutubePlayerController _youtubePlayerController;

  final CustomLoopProvider _customLoopProvider;
  final SubtitleLoopProvider _subtitleLoopProvider;
  final YoutubeHdProvider _youtubeHdProvider;

  BottomActionsBar bottomActionsBarBuilder() => BottomActionsBar(
        youtubePlayerController: _youtubePlayerController,
        customLoopProvider: _customLoopProvider,
      );

  ActionsCircularMenu actionsCircularMenuBuilder(
          {required void Function() onActionsMenuToggled}) =>
      ActionsCircularMenu(
        onActionsMenuToggled: onActionsMenuToggled,
        youtubePlayerController: _youtubePlayerController,
        subtitleLoopProvider: _subtitleLoopProvider,
        youtubeHdProvider: _youtubeHdProvider,
      );

  Widget progressBar() {
    CustomProgress? customProgressGenerator({
      required Loop loop,
      required Color color,
    }) =>
        CustomProgress(
          start: loop.start.inMilliseconds /
              _youtubePlayerController.value.metaData.duration.inMilliseconds,
          end: loop.end.inMilliseconds /
              _youtubePlayerController.value.metaData.duration.inMilliseconds,
          color: Colors.amber.shade600,
        );

    return Consumer(
      builder: (context, ref, _) {
        final subtitlesLoopStream =
            ref.read(_subtitleLoopProvider.notifier).stream.startWith(null);
        final customLoopStream =
            ref.read(_customLoopProvider.notifier).stream.startWith(null);
        return ProgressBar(
          controller: _youtubePlayerController,
          customProgress: Rx.combineLatestList([
            subtitlesLoopStream.asyncMap(
              (loop) => loop != null
                  ? customProgressGenerator(
                      loop: loop,
                      color: progressBarSubtitleLoopColor,
                    )
                  : null,
            ),
            customLoopStream.asyncMap(
              (loop) => loop != null
                  ? customProgressGenerator(
                      loop: loop,
                      color: progressBarCustomLoopColor,
                    )
                  : null,
            ),
          ]),
          colors: ProgressBarColors(
            handleColor: progressBarPlayedColor,
            playedColor: progressBarPlayedColor,
            bufferedColor: progressBarBufferColor.withOpacity(0.7),
            backgroundColor: progressBarBackgroungColor.withOpacity(0.5),
          ),
        );
      },
    );
  }

  Widget positionIndicator() => CurrentPosition(
        controller: _youtubePlayerController,
      );

  Widget loopButton() {
    return genericButton(
      childBuilder: (ref) => const Icon(
        Icons.repeat_one,
        color: Colors.white,
        size: 25,
      ),
      onPressed: (ref) {},
    );
  }

  Widget subtitlesSettingsButton() {
    return genericButton(
      childBuilder: (ref) => const Icon(
        Icons.closed_caption_rounded,
        color: Colors.white,
      ),
      onPressed: (ref) => throw UnimplementedError(),
    );
  }

  Widget playBackSpeedButton() {
    return genericButton(
      onPressed: (ref) {},
      childBuilder: (ref) => const Text(
        '0.75x',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget saveClipButton() {
    return genericButton(
      onPressed: (ref) {},
      childBuilder: (ref) => const Icon(
        CustomIcons.selectMultiple,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  Widget genericButton({
    required Widget Function(WidgetRef) childBuilder,
    required void Function(WidgetRef ref) onPressed,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        return RawMaterialButton(
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          onPressed: () => onPressed(ref),
          child: childBuilder(ref),
        );
      },
    );
  }

  Widget settingsButton() {
    return genericButton(
      childBuilder: (ref) => const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
      onPressed: (ref) => throw UnimplementedError(),
    );
  }

  Widget backButton() {
    return genericButton(
      childBuilder: (ref) => const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.white,
      ),
      onPressed: (ref) => throw UnimplementedError(),
    );
  }

  Widget toggleFullScreenButton() {
    return genericButton(
      childBuilder: (ref) {
        final isFullScreen = ref.read(youtubePlayerFullScreenProvider);
        return Icon(
          isFullScreen
              ? Icons.fullscreen_exit_outlined
              : Icons.fullscreen_sharp,
          color: Colors.white,
        );
      },
      onPressed: (ref) {
        final fullScreenNotifier =
            ref.read(youtubePlayerFullScreenProvider.notifier);
        final isFullScreen = ref.read(youtubePlayerFullScreenProvider);
        isFullScreen
            ? fullScreenNotifier.enableFullScreen()
            : fullScreenNotifier.exitFullScreen();
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
}
