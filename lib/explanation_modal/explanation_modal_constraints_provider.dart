import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplanationModalConstraintsNotifier extends ChangeNotifier {
  BoxConstraints? currentConstraints;
  static const dragHandleBoxHeight = kMinInteractiveDimension;
  void updateConstraints(BoxConstraints constraints) {
    currentConstraints = constraints.copyWith(
      maxHeight: constraints.maxHeight - dragHandleBoxHeight,
      minHeight: constraints.minHeight - dragHandleBoxHeight,
    );
    notifyListeners();
  }
}

final explanationModalConstraintsProvider =
    ChangeNotifierProvider((ref) => ExplanationModalConstraintsNotifier());
