import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceOrientationProvider =
    StateNotifierProvider<DeviceOrientationNotifier, List<DeviceOrientation>>(
  (ref) => DeviceOrientationNotifier(),
);

extension IsFullScreen on List<DeviceOrientation> {
  bool get isFullScreen => contains(DeviceOrientation.landscapeRight);
}

final class DeviceOrientationNotifier
    extends StateNotifier<List<DeviceOrientation>> {
  DeviceOrientationNotifier() : super([DeviceOrientation.portraitUp]) {
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
