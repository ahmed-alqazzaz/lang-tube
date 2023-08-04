import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class YoutubePlayerFullscreenNotifier extends StateNotifier<bool> {
  YoutubePlayerFullscreenNotifier() : super(false);

  void enableFullScreen() => SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) => state = true);

  void exitFullScreen() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) => state = true);
}
