// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_provider.dart';

final subtitlesConfigProvider = StateProvider<SubtitlesPlayerConfig?>((ref) {
  final subtitles = ref.watch(subtitlesProvider).valueOrNull;
  if (subtitles?.isNotEmpty == true) {
    return SubtitlesPlayerConfig(
      showTranslations: true,
      selectedBundle: subtitles!.first,
    );
  }
  return null;
});

@immutable
final class SubtitlesPlayerConfig {
  final bool showTranslations;
  final SubtitlesBundle selectedBundle;
  const SubtitlesPlayerConfig({
    required this.showTranslations,
    required this.selectedBundle,
  });

  @override
  String toString() =>
      'SubtitlesPlayerConfig(showTranslationl: $showTranslations, selectedBundle: $selectedBundle)';

  @override
  bool operator ==(covariant SubtitlesPlayerConfig other) {
    if (identical(this, other)) return true;

    return other.showTranslations == showTranslations &&
        other.selectedBundle == selectedBundle;
  }

  @override
  int get hashCode => showTranslations.hashCode ^ selectedBundle.hashCode;

  SubtitlesPlayerConfig copyWith({
    bool? showTranslations,
    SubtitlesBundle? selectedBundle,
  }) {
    return SubtitlesPlayerConfig(
      showTranslations: showTranslations ?? this.showTranslations,
      selectedBundle: selectedBundle ?? this.selectedBundle,
    );
  }
}
