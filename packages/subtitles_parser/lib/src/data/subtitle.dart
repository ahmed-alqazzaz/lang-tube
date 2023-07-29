// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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

  @override
  String toString() => 'Subtitle(start: $start, end: $end, text: $text)';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'end': end,
      'text': text,
    };
  }

  factory Subtitle.fromMap(Map<String, dynamic> map) {
    return Subtitle(
      start: map['start'] as Duration,
      end: map['end'] as Duration,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subtitle.fromJson(String source) =>
      Subtitle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Subtitle other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end && other.text == text;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ text.hashCode;
}
