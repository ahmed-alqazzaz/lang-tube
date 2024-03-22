import 'dart:convert';

import 'package:subtitles_parser/subtitles_parser.dart';

extension ParsedSubtitlesJsonifier on List<ParsedSubtitle> {
  // Convert a List<ParsedSubtitle> to a JSON string
  String toJson() => jsonEncode(map((item) => item.toMap()).toList());

  // Convert a JSON string to a List<ParsedSubtitle>
  static List<ParsedSubtitle> fromJson(String jsonString) {
    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    return list.map((item) => ParsedSubtitle.fromMap(item)).toList();
  }
}
