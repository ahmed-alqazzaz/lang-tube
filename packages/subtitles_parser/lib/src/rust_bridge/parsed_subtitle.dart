import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:subtitles_parser/src/rust_bridge/bridge.g.dart';
import 'package:subtitles_parser/src/rust_bridge/duration_converter.dart';

@immutable
class ParsedSubtitle {
  final Duration start;
  final Duration end;
  final String text;

  const ParsedSubtitle._({
    required this.start,
    required this.end,
    required this.text,
  });

  ParsedSubtitle({
    required RustDuration start,
    required RustDuration end,
    required this.text,
  })  : start = start.toDart(),
        end = end.toDart();

  ParsedSubtitle copyWith({
    Duration? start,
    Duration? end,
    String? text,
  }) {
    return ParsedSubtitle._(
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
      'start': start.toJson(),
      'end': end.toJson(),
      'text': text,
    };
  }

  factory ParsedSubtitle.fromMap(Map<String, dynamic> map) {
    return ParsedSubtitle._(
      start: DurationJsonifier.fromJson(map['start'] as String),
      end: DurationJsonifier.fromJson(map['end'] as String),
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParsedSubtitle.fromJson(String source) =>
      ParsedSubtitle.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension DurationJsonifier on Duration {
  String toJson() => jsonEncode(inMicroseconds);
  static Duration fromJson(String json) =>
      Duration(microseconds: jsonDecode(json));
}
