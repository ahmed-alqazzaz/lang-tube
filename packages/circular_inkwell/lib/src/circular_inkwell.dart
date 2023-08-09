import 'package:flutter/material.dart';

class CircularInkWell extends StatelessWidget {
  const CircularInkWell({
    super.key,
    required this.child,
    required this.onTap,
    this.splashRadius = defaultSplashRadius,
  });
  static const defaultSplashRadius = 8.0;
  final double splashRadius;
  final void Function()? onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        customBorder: const OvalBorder(),
        child: Padding(
          padding: EdgeInsets.all(splashRadius),
          child: child,
        ),
      ),
    );
  }
}
