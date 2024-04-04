import 'dart:math';
import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

import '../../models/subtitles/consumable_caption.dart';
import '../../../models/subtitles/subtitles_player_value.dart';
import 'subtitles_config_provider.dart';
import 'youtube_controller_provider.dart';

final subtitlesPlayerProvider =
    StateNotifierProvider<MultiSubtitlesPlayer, SubtitlesPlayerValue>(
  (ref) {
    final youtubePlayerController = ref.watch(youtubeControllerProvider);
    final subtitlesConfig = ref.watch(subtitlesConfigProvider);
    final selectedSubtitlesBundle = subtitlesConfig?.selectedBundle;
    final mainSubtitles = selectedSubtitlesBundle?.mainSubtitles.subtitles
        .map((e) => e.toSubtitle());
    final translatedSubtitles = selectedSubtitlesBundle
        ?.translatedSubtitles.subtitles
        .map((e) => e.toSubtitle());
    return MultiSubtitlesPlayer(
      mainSubtitles: mainSubtitles?.toList() ?? [],
      translatedSubtitles: (subtitlesConfig?.showTranslations == true
              ? translatedSubtitles?.toList()
              : null) ??
          [],
      playbackPosition:
          youtubePlayerController.where((event) => !event.isDragging).syncMap(
                (value) => value.position,
              ),
    );
  },
);

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
              for (int i = 0;
                  i < max(mainSubtitles.length, translatedSubtitles.length);
                  i++)
                ConsumableCaptions(
                  mainSubtitles: [mainSubtitles.elementAtOrNull(i)]
                      .whereNotNull()
                      .toList(),
                  translatedSubtitles: [translatedSubtitles.elementAtOrNull(i)]
                      .whereNotNull()
                      .toList(),
                )
            ],
            currentSubtitles: const ConsumableCaptions(),
            index:
                mainSubtitles.getClosestIndexByDuration(playbackPosition.value),
          ),
        ) {
    _mainSubtitlesPlayer.addListener(
      (subtitles) {
        state = state.copyWith(
          currentSubtitles:
              state.currentSubtitles.copyWith(mainSubtitles: subtitles),
          index: subtitles.isNotEmpty
              ? mainSubtitles.indexOf(subtitles.last)
              : null,
        );
      },
      fireImmediately: true,
    );
    _translatedSubtitlesPlayer.addListener(
      (subtitles) {
        state = state.copyWith(
          currentSubtitles:
              state.currentSubtitles.copyWith(translatedSubtitle: subtitles),
          index: subtitles.isNotEmpty
              ? translatedSubtitles.indexOf(subtitles.last)
              : null,
        );
      },
      fireImmediately: true,
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

extension on ParsedSubtitle {
  Subtitle toSubtitle() => Subtitle(end: end, start: start, text: text);
}
