// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

@immutable
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
