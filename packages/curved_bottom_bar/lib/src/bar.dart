import 'package:curved_bottom_bar/src/painter.dart';
import 'package:flutter/material.dart';

class CurvedBottomBar extends StatelessWidget {
  CurvedBottomBar({super.key, required this.actions, this.backgroundColor}) {
    assert(actions.length == 4, 'Curved bottom bar must have 4 actions');
  }

  final List<Widget> actions;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            CustomPaint(
              size: Size(
                constraints.maxWidth,
                (constraints.maxWidth * 0.25).toDouble(),
              ),
              painter: RPSCustomPainter(
                backgroundColor: backgroundColor ??
                    Theme.of(context).bottomAppBarTheme.color ??
                    Colors.white,
              ),
            ),
            Row(
              children: [
                SizedBox(width: constraints.maxWidth * 0.03),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.28),
                  child: actions[0],
                ),
                SizedBox(width: constraints.maxWidth * 0.055),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.13),
                  child: actions[1],
                ),
                const Expanded(child: SizedBox()),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.13),
                  child: actions[2],
                ),
                SizedBox(width: constraints.maxWidth * 0.02),
                Transform.translate(
                  offset: Offset(0, constraints.maxHeight * 0.28),
                  child: actions[3],
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
