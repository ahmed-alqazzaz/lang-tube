library sized_button;

import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {
  SizedButton.large({
    super.key,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.child,
    this.size,
    Color? onPressedTextColor,
  })  : border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(
            color: Color.fromRGBO(186, 186, 186, 100),
            width: 1,
          ),
        ),
        onPressedTextColor = onPressedTextColor ?? textColor,
        padding = const EdgeInsets.all(0);

  SizedButton.small({
    super.key,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.child,
    this.size,
    Color? onPressedTextColor,
  })  : border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressedTextColor = onPressedTextColor ?? textColor,
        padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 3);

  final Color color;
  final Color textColor;
  final Color onPressedTextColor;
  final EdgeInsets padding;
  final RoundedRectangleBorder border;
  final Size? size;
  final Widget child;
  final void Function() onPressed;

  static const maxHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize:
            const MaterialStatePropertyAll(Size(double.infinity, maxHeight)),
        fixedSize: MaterialStatePropertyAll(size),
        backgroundColor: MaterialStatePropertyAll(color),
        padding: MaterialStatePropertyAll(padding),
        shape: MaterialStatePropertyAll(border),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.pressed)
              ? onPressedTextColor
              : textColor,
        ),
        overlayColor: const MaterialStatePropertyAll(Colors.white24),
      ),
      child: child,
    );
  }
}
