import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class YoutubePlayerOrientationNotifier
    extends StateNotifier<List<DeviceOrientation>> {
  YoutubePlayerOrientationNotifier() : super([DeviceOrientation.portraitUp]) {
    addListener(orientationListener);
  }

  void enableFullScreen() => state = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
  void exitFullScreen() => state = [DeviceOrientation.portraitUp];
  void orientationListener(List<DeviceOrientation> orientation) =>
      SystemChrome.setPreferredOrientations(orientation);
}
