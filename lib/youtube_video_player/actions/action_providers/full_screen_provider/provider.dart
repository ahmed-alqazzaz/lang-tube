import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/full_screen_provider/notifier.dart';

final youtubePlayerOrientationProvider = StateNotifierProvider<
    YoutubePlayerOrientationNotifier, List<DeviceOrientation>>(
  (ref) => YoutubePlayerOrientationNotifier(),
);

extension IsFullScreen on List<DeviceOrientation> {
  bool get isFullScreen => contains(DeviceOrientation.landscapeRight);
}
