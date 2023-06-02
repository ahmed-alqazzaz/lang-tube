import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplanationModalConstraintsNotifier extends ChangeNotifier {
  BoxConstraints? currentConstraints;
  void updateConstraints(BoxConstraints constraints) {
    currentConstraints = constraints;
    notifyListeners();
  }
}

final explanationModalConstraintsProvider =
    ChangeNotifierProvider((ref) => ExplanationModalConstraintsNotifier());
