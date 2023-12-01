import 'package:flutter/services.dart';

extension IsFullScreen on List<DeviceOrientation> {
  bool get isFullScreen =>
      contains(DeviceOrientation.landscapeRight) ||
      contains(DeviceOrientation.landscapeLeft);
}
