import '../../../../video_recommendations.dart/managers/videos_recommendations_manager/rust_api/api.dart';

class Subtitle {
  const Subtitle({
    required this.start,
    required this.end,
    required this.text,
  });

  final Duration start;
  final Duration end;
  final String text;

  Duration get duration => end - start;
  List<String> get words => text.split(RegExp(r'[ \n]'));

  // syllables per millisecond
  Future<double> get syllablesPerMillisecond async {
    return (await rustApi.countSyllables(text: text)) / duration.inMilliseconds;
  }

  Subtitle copyWith({
    Duration? start,
    Duration? end,
    String? text,
  }) {
    return Subtitle(
      start: start ?? this.start,
      end: end ?? this.end,
      text: text ?? this.text,
    );
  }

  @override
  String toString() => 'Subtitle(start: $start, end: $end, text: $text)';

  @override
  bool operator ==(covariant Subtitle other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end && other.text == text;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ text.hashCode;
}
