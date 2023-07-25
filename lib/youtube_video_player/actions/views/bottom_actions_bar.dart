import 'dart:developer';
import 'package:flutter/material.dart';

import '../actions_provider.dart';

class BottomActionsBar extends StatelessWidget {
  const BottomActionsBar({super.key, required this.retrieveActionsNotifier});
  final splashRadius = 8.0;
  final YoutubePlayerActionsModel Function() retrieveActionsNotifier;

  Widget subtitlesSettingsButton() {
    return CircularInkWell(
      onTap: () => retrieveActionsNotifier().displaySubtitlesSettings(),
      splashRadius: splashRadius,
      child: const Icon(
        Icons.closed_caption_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget rawLoopButton() {
    return CircularInkWell(
      onTap: () {},
      splashRadius: splashRadius,
      child: const Icon(
        Icons.loop_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget playbackSpeedButton() {
    return CircularInkWell(
      onTap: () {
        // _ref.read(actionsProvider).setPlaybackSpeed(0.75);
      },
      splashRadius: splashRadius,
      child: const Icon(
        Icons.speed,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget settingsButton() {
    return CircularInkWell(
      onTap: retrieveActionsNotifier().displayMainSettings,
      splashRadius: splashRadius,
      child: const Icon(
        Icons.settings_outlined,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
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
                offset: Offset(0, constraints.maxHeight * 0.35),
                child: subtitlesSettingsButton(),
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.2),
                child: rawLoopButton(),
              ),
              const Expanded(child: SizedBox()),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.2),
                child: playbackSpeedButton(),
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.35),
                child: settingsButton(),
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
            ],
          )
        ],
      );
    });
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
