import 'package:flutter/foundation.dart';

class InsertionController extends ValueNotifier<String> {
  InsertionController() : super("");

  void insert(String text) {
    value = value + text;
    notifyListeners();
  }
}
