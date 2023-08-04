import 'package:flutter/rendering.dart';

import 'clip_direction.dart';

class CustomIconClipper extends CustomClipper<Path> {
  final ClipDirection clipDirection;

  CustomIconClipper({this.clipDirection = ClipDirection.top});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (clipDirection == ClipDirection.top) {
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height / 2);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
