import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordSelectabilityModel extends ChangeNotifier {
  WordSelectabilityModel();
  int? selectedWordIndex;

  void updateSelectedWordIndex(int index) {
    selectedWordIndex = index;
    notifyListeners();
  }

  void reset() {
    if (selectedWordIndex != null) {
      selectedWordIndex = null;
      notifyListeners();
    }
  }
}

final wordSelectabilityProvider =
    ChangeNotifierProvider((ref) => WordSelectabilityModel());
