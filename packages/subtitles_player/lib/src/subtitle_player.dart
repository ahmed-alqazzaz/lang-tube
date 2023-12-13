import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:subtitles_player/src/models/subtitle.dart';
import 'package:subtitles_player/src/utils/duration_search.dart';

class SubtitlesPlayer extends StateNotifier<Subtitle?> {
  SubtitlesPlayer({
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
