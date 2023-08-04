import 'package:flutter/material.dart';

import 'clip_direction.dart';
import 'clipper.dart';

class ClippedIcon extends StatelessWidget {
  final Icon icon;
  final double height;
  final ClipDirection clipDirection;

  const ClippedIcon({
    super.key,
    required this.icon,
    required this.clipDirection,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 2,
      child: ClipPath(
        clipper: CustomIconClipper(clipDirection: clipDirection),
        child: icon,
      ),
    );
  }
}
