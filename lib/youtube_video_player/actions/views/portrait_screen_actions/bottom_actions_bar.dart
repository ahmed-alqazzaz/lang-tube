import 'dart:developer';
import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:clipped_icon/clipped_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/loop_providers/custom_loop_provider/setup_provider.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/youtube_playback_speed_provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
import '../generic_actions.dart';
import 'package:size_utils/size_utils.dart';

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
                  child: _genericActions.customLoopButton(
                    splashRadius: buttonsSplashRadius,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.13),
                  child: _genericActions.playbackSpeedButton(
                    splashRadius: buttonsSplashRadius,
                  ),
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

  static const double buttonsSplashRadius = 12;
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
