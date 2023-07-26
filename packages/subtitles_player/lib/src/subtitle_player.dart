import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:subtitles_player/src/data/subtitle.dart';
import 'package:subtitles_player/src/urils/get_subtitle_by_duration.dart';

class SubtitlePlayer extends StateNotifier<Subtitle?> {
  SubtitlePlayer({
    required this.subtitles,
    required this.playbackPosition,
  }) : super(null) {
    playbackPosition.addListener(_playbackPositionListener);
  }
  final ValueListenable<Duration> playbackPosition;
  final List<Subtitle> subtitles;
  void _playbackPositionListener() =>
      state = subtitles.getSubtitleByDuration(playbackPosition.value);

  @override
  void dispose() {
    playbackPosition.removeListener(_playbackPositionListener);
    super.dispose();
  }
}
