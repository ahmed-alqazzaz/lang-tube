import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_modal.dart';

class ExplanationModalConstraintsNotifier extends ChangeNotifier {
  BoxConstraints? currentConstraints;
  void updateConstraints(BoxConstraints constraints) {
    currentConstraints = constraints.copyWith(
      maxHeight: constraints.maxHeight -
          ExplanationModalSheet.theme.dragHandleSize!.height,
      minHeight: constraints.minHeight -
          ExplanationModalSheet.theme.dragHandleSize!.height,
    );
    notifyListeners();
  }
}

final explanationModalConstraintsProvider =
    ChangeNotifierProvider((ref) => ExplanationModalConstraintsNotifier());
