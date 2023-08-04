import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;
import 'package:subtitles_player/subtitles_player.dart';

import 'display_subtitles.dart';

class MultiSubtitlesPlayer extends StateNotifier<DisplaySubtitles> {
  MultiSubtitlesPlayer({
    required this.mainSubtitles,
    required this.translatedSubtitles,
    required ValueListenable<Duration> playbackPosition,
  })  : mainSubtitlesPlayer = SubtitlesPlayer(
          playbackPosition: playbackPosition,
          subtitles: mainSubtitles,
        ),
        translatedSubtitlesPlayer = SubtitlesPlayer(
          playbackPosition: playbackPosition,
          subtitles: translatedSubtitles,
        ),
        super(const DisplaySubtitles()) {
    mainSubtitlesPlayer.addListener(
      (subtitle) => state = state.copyWith(
        mainSubtitle: subtitle,
        index: subtitle != null ? mainSubtitles.indexOf(subtitle) : null,
      ),
    );
    translatedSubtitlesPlayer.addListener(
      (subtitle) => state = state.copyWith(
        translatedSubtitle: subtitle,
      ),
    );
  }
  final SubtitlesPlayer mainSubtitlesPlayer;
  final SubtitlesPlayer translatedSubtitlesPlayer;

  final List<subtitles_player.Subtitle> mainSubtitles;
  final List<subtitles_player.Subtitle> translatedSubtitles;

  subtitles_player.Subtitle? get previousMainSubtitle =>
      mainSubtitlesPlayer.previousSubtitle();
  subtitles_player.Subtitle? get nextMainSubtitle =>
      mainSubtitlesPlayer.nextSubtitle();

  subtitles_player.Subtitle? get previousTranslatedSubtitle =>
      translatedSubtitlesPlayer.previousSubtitle();
  subtitles_player.Subtitle? get nextTranslatedSubtitle =>
      translatedSubtitlesPlayer.nextSubtitle();

  @override
  void dispose() {
    mainSubtitlesPlayer.dispose();
    translatedSubtitlesPlayer.dispose();
    super.dispose();
  }
}
