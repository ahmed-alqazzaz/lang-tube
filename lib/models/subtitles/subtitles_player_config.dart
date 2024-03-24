import 'package:flutter/material.dart';
import 'subtitles_bundle.dart';

@immutable
final class SubtitlesPlayerConfig {
  final bool showTranslations;
  final CaptionsBundle selectedBundle;
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
    CaptionsBundle? selectedBundle,
  }) {
    return SubtitlesPlayerConfig(
      showTranslations: showTranslations ?? this.showTranslations,
      selectedBundle: selectedBundle ?? this.selectedBundle,
    );
  }
}
