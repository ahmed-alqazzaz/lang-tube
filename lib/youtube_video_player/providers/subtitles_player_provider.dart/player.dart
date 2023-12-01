// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_player/subtitles_player.dart';

import '../../../models/subtitles/consumable_subtitles.dart';

@immutable
class SubtitlesPlayerValue {
  final ConsumableSubtitles currentSubtitles;
  final List<ConsumableSubtitles> subtitles;

  int? get index => subtitles.indexOf(currentSubtitles);

  const SubtitlesPlayerValue({
    required this.currentSubtitles,
    required this.subtitles,
  });

  SubtitlesPlayerValue copyWith({
    ConsumableSubtitles? currentSubtitles,
    List<ConsumableSubtitles>? subtitles,
  }) =>
      SubtitlesPlayerValue(
        currentSubtitles: currentSubtitles ?? this.currentSubtitles,
        subtitles: subtitles ?? this.subtitles,
      );
}

class MultiSubtitlesPlayer extends StateNotifier<SubtitlesPlayerValue> {
  MultiSubtitlesPlayer({
    required List<Subtitle> mainSubtitles,
    required List<Subtitle> translatedSubtitles,
    required ValueListenable<Duration> playbackPosition,
  })  : _mainSubtitlesPlayer = SubtitlesPlayer(
          playbackPosition: playbackPosition,
          subtitles: mainSubtitles,
        ),
        _translatedSubtitlesPlayer = SubtitlesPlayer(
          playbackPosition: playbackPosition,
          subtitles: translatedSubtitles,
        ),
        super(
          SubtitlesPlayerValue(
            subtitles: [
              for (var i in IterableZip([mainSubtitles, translatedSubtitles]))
                ConsumableSubtitles(
                  mainSubtitle: i.first,
                  translatedSubtitle: i.last,
                )
            ],
            currentSubtitles: const ConsumableSubtitles(),
          ),
        ) {
    _mainSubtitlesPlayer.addListener(
      (subtitle) => state = state.copyWith(
        currentSubtitles:
            state.currentSubtitles.copyWith(mainSubtitle: subtitle),
      ),
    );
    _translatedSubtitlesPlayer.addListener(
      (subtitle) => state = state.copyWith(
        currentSubtitles:
            state.currentSubtitles.copyWith(translatedSubtitle: subtitle),
      ),
    );
  }
  final SubtitlesPlayer _mainSubtitlesPlayer;
  final SubtitlesPlayer _translatedSubtitlesPlayer;
  @override
  void dispose() {
    _mainSubtitlesPlayer.dispose();
    _translatedSubtitlesPlayer.dispose();
    super.dispose();
  }
}
