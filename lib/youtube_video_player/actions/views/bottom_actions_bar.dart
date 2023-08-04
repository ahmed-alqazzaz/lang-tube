import 'dart:developer';
import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:clipped_icon/clipped_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/action_providers/loop_providers/custom_loop_provider/setup_provider.dart';
import 'package:lang_tube/youtube_video_player/action_providers/youtube_playback_speed_provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../action_providers/loop_providers/custom_loop_provider/loop_provider.dart';

class BottomActionsBar extends StatelessWidget {
  BottomActionsBar({
    super.key,
    required this.youtubePlayerController,
    required CustomLoopProvider customLoopProvider,
  })  : _youtubePlaybackSpeedProvider =
            youtubePlaybackSpeedProviderFamily(youtubePlayerController),
        _customLoopProvider = customLoopProvider;
  final splashRadius = 12.0;
  final YoutubePlayerController youtubePlayerController;

  final CustomLoopProvider _customLoopProvider;
  final YoutubePlaybackSpeedProvider _youtubePlaybackSpeedProvider;

  Widget subtitlesSettingsButton() {
    return Consumer(
      builder: (context, ref, _) {
        return CircularInkWell(
          onTap: () => throw UnimplementedError(),
          splashRadius: splashRadius,
          child: const Icon(
            Icons.closed_caption_rounded,
            color: Colors.white,
            size: 30,
          ),
        );
      },
    );
  }

  Widget customLoopButton() {
    Duration? loopStart;

    return Consumer(
      builder: (context, ref, _) {
        final loopNotifier = ref.read(_customLoopProvider.notifier);
        final loopSetupProvider = ref.read(customLoopSettingProvider.notifier);
        final loopState = ref.watch(customLoopSettingProvider);
        return CircularInkWell(
          onTap: () {
            switch (loopState) {
              case CustomLoopState.inactive:
                loopStart = youtubePlayerController.value.position;
                loopSetupProvider.state = CustomLoopState.activating;
                break;
              case CustomLoopState.activating:
                final loopEnd = youtubePlayerController.value.position;
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
                  height: 15,
                  icon: Icon(
                    Icons.repeat,
                    color: loopState == CustomLoopState.active
                        ? Colors.amber.shade600
                        : Colors.white,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClippedIcon(
                  clipDirection: ClipDirection.bottom,
                  height: 15,
                  icon: Icon(
                    Icons.repeat,
                    color: loopState == CustomLoopState.inactive
                        ? Colors.white
                        : Colors.amber.shade600,
                    size: 30,
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

  Widget playbackSpeedButton() {
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

  Widget settingsButton() {
    return Consumer(
      builder: (context, ref, _) {
        return CircularInkWell(
          onTap: () => throw UnimplementedError,
          splashRadius: splashRadius,
          child: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        log(constraints.toString());
        return Stack(
          children: [
            CustomPaint(
              size: Size(
                width,
                (width * 0.25).toDouble(),
              ),
              painter: RPSCustomPainter(
                backgroundColor: const Color.fromARGB(255, 15, 15, 15),
              ),
            ),
            Row(
              children: [
                SizedBox(width: constraints.maxWidth * 0.03),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.28),
                  child: subtitlesSettingsButton(),
                ),
                SizedBox(width: constraints.maxWidth * 0.055),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.13),
                  child: customLoopButton(),
                ),
                const Expanded(child: SizedBox()),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.13),
                  child: playbackSpeedButton(),
                ),
                SizedBox(width: constraints.maxWidth * 0.02),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.28),
                  child: settingsButton(),
                ),
                SizedBox(width: constraints.maxWidth * 0.05),
              ],
            )
          ],
        );
      },
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({required this.backgroundColor});
  final Color backgroundColor;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(0, size.height * 0.2520000);
    path0.quadraticBezierTo(size.width * 0.1261875, size.height * 0.0090000,
        size.width * 0.3152500, size.height * 0.0160000);
    path0.cubicTo(
        size.width * 0.4128125,
        size.height * 0.1520000,
        size.width * 0.3781875,
        size.height * 0.7562500,
        size.width * 0.4995000,
        size.height * 0.7560000);
    path0.cubicTo(
        size.width * 0.6245000,
        size.height * 0.7522500,
        size.width * 0.5854375,
        size.height * 0.2115000,
        size.width * 0.6887500,
        size.height * 0.0110000);
    path0.quadraticBezierTo(size.width * 0.8745625, size.height * 0.0045000,
        size.width, size.height * 0.2570000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);

    // Add shadow to the shape
    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
