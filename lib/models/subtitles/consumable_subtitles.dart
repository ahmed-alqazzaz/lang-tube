import 'package:flutter/material.dart';
import 'package:subtitles_player/subtitles_player.dart';

@immutable
class ConsumableSubtitles {
  const ConsumableSubtitles({
    this.mainSubtitle,
    this.translatedSubtitle,
  });
  final Subtitle? mainSubtitle;
  final Subtitle? translatedSubtitle;

  ConsumableSubtitles copyWith({
    Subtitle? mainSubtitle,
    Subtitle? translatedSubtitle,
  }) {
    return ConsumableSubtitles(
      mainSubtitle: mainSubtitle ?? this.mainSubtitle,
      translatedSubtitle: translatedSubtitle ?? this.translatedSubtitle,
    );
  }

  @override
  String toString() =>
      'DisplayedSubtitles(mainSubtitle: $mainSubtitle, translatedSubtitle: $translatedSubtitle)';

  @override
  bool operator ==(covariant ConsumableSubtitles other) {
    if (identical(this, other)) return true;

    return other.mainSubtitle == mainSubtitle &&
        other.translatedSubtitle == translatedSubtitle;
  }

  @override
  int get hashCode => mainSubtitle.hashCode ^ translatedSubtitle.hashCode;
}
