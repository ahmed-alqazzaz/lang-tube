import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:clipped_icon/clipped_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../action_providers/full_screen_provider/provider.dart';
import '../action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
import '../action_providers/loop_providers/custom_loop_provider/setup_provider.dart';
import '../action_providers/loop_providers/raw_loop_notifier/loop.dart';
import '../action_providers/loop_providers/subtitle_loop_provider.dart/provider.dart';
import '../action_providers/youtube_playback_speed_provider/provider.dart';

class YoutubePlayerGenericActions {
  YoutubePlayerGenericActions({
    required YoutubePlayerController youtubePlayerController,
    required CustomLoopProvider customLoopProvider,
    required SubtitleLoopProvider subtitleLoopProvider,
  })  : _youtubePlayerController = youtubePlayerController,
        _youtubePlaybackSpeedProvider =
            youtubePlaybackSpeedProviderFamily(youtubePlayerController),
        _customLoopProvider = customLoopProvider,
        _subtitleLoopProvider = subtitleLoopProvider;

  final YoutubePlayerController _youtubePlayerController;
  final YoutubePlaybackSpeedProvider _youtubePlaybackSpeedProvider;
  final CustomLoopProvider _customLoopProvider;
  final SubtitleLoopProvider _subtitleLoopProvider;

  Widget backButton() {
    return RawMaterialButton(
      child: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }

  Widget toggleFullScreenButton({double? iconSize}) {
    return Consumer(
      builder: (context, ref, _) {
        final isFullScreen =
            ref.watch(youtubePlayerOrientationProvider).isFullScreen;
        log("is full screen $isFullScreen");
        return CircularInkWell(
          child: Icon(
            isFullScreen
                ? Icons.fullscreen_exit_outlined
                : Icons.fullscreen_sharp,
            color: Colors.white,
            size: iconSize,
          ),
          onTap: () {
            final fullScreenNotifier =
                ref.read(youtubePlayerOrientationProvider.notifier);
            ref.read(youtubePlayerOrientationProvider).isFullScreen
                ? fullScreenNotifier.exitFullScreen()
                : fullScreenNotifier.enableFullScreen();
          },
        );
      },
    );
  }

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

  Widget playbackSpeedButton({required double splashRadius}) {
    return Consumer(
      builder: (context, ref, _) {
        final playbackSpeedNotifier = ref.read(
          _youtubePlaybackSpeedProvider.notifier,
        );
        final speed = ref.watch(_youtubePlaybackSpeedProvider).toString();
        return Transform.translate(
          offset: Offset(speed.length == 4 ? 0 : -6, 0),
          child: CircularInkWell(
            onTap: () => playbackSpeedNotifier.seekNext(),
            splashRadius: splashRadius,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: speed,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const TextSpan(
                    text: 'x',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget customLoopButton({required double splashRadius}) {
    Duration? loopStart;
    return Consumer(
      builder: (context, ref, _) {
        final iconSize = Theme.of(context).iconTheme.size!;
        final loopNotifier = ref.read(_customLoopProvider.notifier);
        final loopSetupProvider = ref.read(customLoopSettingProvider.notifier);
        final loopState = ref.watch(customLoopSettingProvider);
        return CircularInkWell(
          onTap: () {
            switch (loopState) {
              case CustomLoopState.inactive:
                loopStart = _youtubePlayerController.value.position;
                loopSetupProvider.state = CustomLoopState.activating;
                break;
              case CustomLoopState.activating:
                final loopEnd = _youtubePlayerController.value.position;
                loopNotifier.activateLoop(start: loopStart!, end: loopEnd);
                loopSetupProvider.state = CustomLoopState.active;
                break;
              case CustomLoopState.active:
                loopStart = null;
                loopNotifier.deactivateLoop();
                loopSetupProvider.state = CustomLoopState.inactive;
                break;
            }
          },
          splashRadius: splashRadius,
          child: Stack(
            children: [
              const SizedBox(height: 30, width: 30),
              Positioned(
                top: 0,
                child: ClippedIcon(
                  clipDirection: ClipDirection.top,
                  height: iconSize / 2,
                  icon: Icon(
                    Icons.repeat,
                    color: loopState == CustomLoopState.active
                        ? Colors.amber.shade600
                        : Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClippedIcon(
                  clipDirection: ClipDirection.bottom,
                  height: iconSize / 2,
                  icon: Icon(
                    Icons.repeat,
                    color: loopState == CustomLoopState.inactive
                        ? Colors.white
                        : Colors.amber.shade600,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'A',
                          style: TextStyle(
                            color: loopState == CustomLoopState.inactive
                                ? Colors.white
                                : Colors.amber.shade600,
                            fontSize: 8,
                          ),
                        ),
                        TextSpan(
                          text: 'B',
                          style: TextStyle(
                            color: loopState == CustomLoopState.active
                                ? Colors.amber.shade600
                                : Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget currentPositionIndicator({required double padding}) {
    PositionIndicatorValue indicatorValue =
        PositionIndicatorValue.currentPosition;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () => setState(
            () => indicatorValue =
                indicatorValue == PositionIndicatorValue.currentPosition
                    ? PositionIndicatorValue.remainingPosition
                    : PositionIndicatorValue.currentPosition,
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: PositionIndicator(
                      controller: _youtubePlayerController,
                      positionValue: indicatorValue,
                    ),
                  ),
                  const TextSpan(text: ' / '),
                  WidgetSpan(
                    child: PositionIndicator(
                        controller: _youtubePlayerController,
                        positionValue: PositionIndicatorValue.videoDuration),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const Color progressBarSubtitleLoopColor = Colors.amber;
  static const Color progressBarCustomLoopColor = Colors.amber;
  static const double progressBarThickness = 2;
}
