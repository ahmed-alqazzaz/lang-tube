import 'package:curved_bottom_bar/src/painter.dart';
import 'package:flutter/widgets.dart';

class CurvedBottomBar extends StatelessWidget {
  CurvedBottomBar({super.key, required this.actions}) {
    assert(actions.length == 4, 'Curved bottom bar must have 4 actions');
  }

  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          CustomPaint(
            size: Size(
              constraints.maxWidth,
              (constraints.maxWidth * 0.25).toDouble(),
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
                child: actions[0],
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.2),
                child: actions[1],
              ),
              const Expanded(child: SizedBox()),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.2),
                child: actions[2],
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
              Transform.translate(
                offset: Offset(0, constraints.maxHeight * 0.35),
                child: actions[3],
              ),
              SizedBox(width: constraints.maxWidth * 0.075),
            ],
          )
        ],
      );
    });
  }
}
