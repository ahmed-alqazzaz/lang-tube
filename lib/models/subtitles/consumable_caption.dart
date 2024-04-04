// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:subtitles_player/subtitles_player.dart';

@immutable
class ConsumableCaptions {
  final List<Subtitle> mainSubtitles;
  final List<Subtitle> translatedSubtitles;

  const ConsumableCaptions(
      {this.mainSubtitles = const [], this.translatedSubtitles = const []});

  @override
  String toString() =>
      'ConsumableCaptions(mainSubtitles: $mainSubtitles, translatedSubtitle: $translatedSubtitles)';

  @override
  bool operator ==(covariant ConsumableCaptions other) {
    if (identical(this, other)) return true;

    return listEquals(other.mainSubtitles, mainSubtitles) &&
        listEquals(other.translatedSubtitles, translatedSubtitles);
  }

  @override
  int get hashCode => mainSubtitles.hashCode ^ translatedSubtitles.hashCode;

  ConsumableCaptions copyWith({
    List<Subtitle>? mainSubtitles,
    List<Subtitle>? translatedSubtitle,
  }) {
    return ConsumableCaptions(
      mainSubtitles: mainSubtitles ?? this.mainSubtitles,
      translatedSubtitles: translatedSubtitle ?? this.translatedSubtitles,
    );
  }
}
