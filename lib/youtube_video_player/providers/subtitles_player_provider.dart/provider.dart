import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/subtitles/consumable_subtitles.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_config_provider.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

import 'player.dart';

final subtitlesPlayerProvider =
    StateNotifierProvider<MultiSubtitlesPlayer, SubtitlesPlayerValue>((ref) {
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
        youtubePlayerController?.where((event) => !event.isDragging).syncMap(
                  (value) => value.position,
                ) ??
            ValueNotifier(Duration.zero),
  );
});

extension on ParsedSubtitle {
  subtitles_player.Subtitle toSubtitle() =>
      subtitles_player.Subtitle(end: end, start: start, text: text);
}
