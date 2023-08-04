// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:subtitles_player/subtitles_player.dart' as subtitles_player;

@immutable
class DisplaySubtitles {
  const DisplaySubtitles({
    this.mainSubtitle,
    this.translatedSubtitle,
    this.index,
  });
  final subtitles_player.Subtitle? mainSubtitle;
  final subtitles_player.Subtitle? translatedSubtitle;
  final int? index;

  DisplaySubtitles copyWith({
    subtitles_player.Subtitle? mainSubtitle,
    subtitles_player.Subtitle? translatedSubtitle,
    int? index,
  }) {
    return DisplaySubtitles(
      mainSubtitle: mainSubtitle ?? this.mainSubtitle,
      translatedSubtitle: translatedSubtitle ?? this.translatedSubtitle,
      index: index ?? this.index,
    );
  }

  @override
  String toString() =>
      'DisplayedSubtitles(mainSubtitle: $mainSubtitle, translatedSubtitle: $translatedSubtitle, index: $index)';

  @override
  bool operator ==(covariant DisplaySubtitles other) {
    if (identical(this, other)) return true;

    return other.mainSubtitle == mainSubtitle &&
        other.translatedSubtitle == translatedSubtitle &&
        other.index == index;
  }

  @override
  int get hashCode =>
      mainSubtitle.hashCode ^ translatedSubtitle.hashCode ^ index.hashCode;
}
