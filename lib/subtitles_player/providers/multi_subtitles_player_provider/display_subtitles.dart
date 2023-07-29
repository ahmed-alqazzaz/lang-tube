// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;

@immutable
class DisplayedSubtitles {
  const DisplayedSubtitles({
    this.mainSubtitle,
    this.translatedSubtitle,
  });
  final subtitles_player.Subtitle? mainSubtitle;
  final subtitles_player.Subtitle? translatedSubtitle;

  DisplayedSubtitles copyWith({
    subtitles_player.Subtitle? mainSubtitle,
    subtitles_player.Subtitle? translatedSubtitle,
  }) {
    return DisplayedSubtitles(
      mainSubtitle: mainSubtitle ?? this.mainSubtitle,
      translatedSubtitle: translatedSubtitle ?? this.translatedSubtitle,
    );
  }

  @override
  bool operator ==(covariant DisplayedSubtitles other) {
    if (identical(this, other)) return true;

    return other.mainSubtitle == mainSubtitle &&
        other.translatedSubtitle == translatedSubtitle;
  }

  @override
  int get hashCode => mainSubtitle.hashCode ^ translatedSubtitle.hashCode;

  @override
  String toString() =>
      'DisplayedSubtitles(mainSubtitle: $mainSubtitle, translatedSubtitle: $translatedSubtitle)';
}
