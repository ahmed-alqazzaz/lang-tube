import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
final class ParsedSubtitle {
  final Duration start;
  final Duration end;
  final String text;

  const ParsedSubtitle({
    required this.start,
    required this.end,
    required this.text,
  });

  ParsedSubtitle copyWith({
    Duration? start,
    Duration? end,
    String? text,
  }) {
    return ParsedSubtitle(
      start: start ?? this.start,
      end: end ?? this.end,
      text: text ?? this.text,
    );
  }

  @override
  String toString() => 'ParsedSubtitle(start: $start, end: $end, text: $text)';

  @override
  bool operator ==(covariant ParsedSubtitle other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end && other.text == text;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ text.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'end': end,
      'text': text,
    };
  }
}
