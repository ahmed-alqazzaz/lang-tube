import 'package:flutter/rendering.dart';

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
