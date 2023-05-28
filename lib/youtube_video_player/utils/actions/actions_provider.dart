import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionsModel extends ChangeNotifier {
  bool _isClosedCaptionEnabled = false;
  bool get isClosedCaptionEnabled => _isClosedCaptionEnabled;

  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;

  void toggleClosedCaptionsButton() {
    _isClosedCaptionEnabled = !_isClosedCaptionEnabled;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }
}

final actionsProvider = ChangeNotifierProvider((ref) => ActionsModel());
