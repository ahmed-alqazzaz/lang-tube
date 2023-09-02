import 'package:flutter/material.dart';

extension RectMapper on Rect {
  static Rect fromMap(Map<String, dynamic> map) {
    return Rect.fromLTRB(
      map['left'] as double,
      map['top'] as double,
      map['right'] as double,
      map['bottom'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
      'width': width,
      'height': height,
    };
  }
}

extension ColorRgbaStringifier on Color {
  // Parse an RGBA string in the format 'rgba(255, 255, 255, 0.8)'
  static Color fromRgbaString(String rgbaString) {
    final regex = RegExp(r'rgba\((\d+), (\d+), (\d+), ([0-9.]+)\)');
    final match = regex.firstMatch(rgbaString);

    if (match != null && match.groupCount == 4) {
      final red = int.parse(match.group(1)!);
      final green = int.parse(match.group(2)!);
      final blue = int.parse(match.group(3)!);
      final alpha = double.parse(match.group(4)!);

      return Color.fromRGBO(red, green, blue, alpha);
    } else {
      throw ArgumentError('Invalid RGBA string format: $rgbaString');
    }
  }

  // Convert a Color object to an RGBA string
  String toRgbaString() =>
      'rgba(${red.toInt()}, ${green.toInt()}, ${blue.toInt()}, ${opacity.toStringAsFixed(1)})';
}
