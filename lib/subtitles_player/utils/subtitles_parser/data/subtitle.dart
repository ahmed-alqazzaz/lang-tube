class Subtitle {
  Subtitle({
    required this.start,
    required this.duration,
    required this.text,
  })  : end = start + duration,
        words = text.split(' ');

  final Duration start;
  final Duration duration;
  final Duration end;
  final String text;
  final List<String> words;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subtitle &&
        other.start == start &&
        other.duration == duration &&
        other.text == text;
  }

  @override
  int get hashCode => start.hashCode ^ duration.hashCode ^ text.hashCode;

  @override
  String toString() =>
      'SubtitleLine(start: $start, duration: $duration, text: $text)';
}
