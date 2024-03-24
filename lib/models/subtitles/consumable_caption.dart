import 'package:flutter/material.dart';
import 'package:subtitles_player/subtitles_player.dart';

@immutable
class ConsumableCaption {
  const ConsumableCaption({
    this.mainSubtitle,
    this.translatedSubtitle,
  });
  final Subtitle? mainSubtitle;
  final Subtitle? translatedSubtitle;

  ConsumableCaption copyWith({
    Subtitle? mainSubtitle,
    Subtitle? translatedSubtitle,
  }) {
    return ConsumableCaption(
      mainSubtitle: mainSubtitle ?? this.mainSubtitle,
      translatedSubtitle: translatedSubtitle ?? this.translatedSubtitle,
    );
  }

  @override
  String toString() =>
      'DisplayedSubtitles(mainSubtitle: $mainSubtitle, translatedSubtitle: $translatedSubtitle)';

  @override
  bool operator ==(covariant ConsumableCaption other) {
    if (identical(this, other)) return true;

    return other.mainSubtitle == mainSubtitle &&
        other.translatedSubtitle == translatedSubtitle;
  }

  @override
  int get hashCode => mainSubtitle.hashCode ^ translatedSubtitle.hashCode;
}
