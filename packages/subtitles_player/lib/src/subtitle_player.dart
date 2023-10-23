import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:subtitles_player/src/data/subtitle.dart';
import 'package:subtitles_player/src/utils/get_subtitle_by_duration.dart';

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

  int? get currentIndex => state != null ? subtitles.indexOf(state!) : null;

  Subtitle? previousSubtitle() {
    final currentIndex = state != null ? subtitles.indexOf(state!) : -1;
    return currentIndex > 0 ? subtitles[currentIndex - 1] : null;
  }

  Subtitle? nextSubtitle() {
    final currentIndex = state != null ? subtitles.indexOf(state!) : -1;
    return currentIndex > 0 ? subtitles[currentIndex + 1] : null;
  }

  @override
  void dispose() {
    playbackPosition.removeListener(_playbackPositionListener);
    super.dispose();
  }
}
