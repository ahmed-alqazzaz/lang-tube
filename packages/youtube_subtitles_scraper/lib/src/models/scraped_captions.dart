// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:subtitles_parser/subtitles_parser.dart';
import 'package:youtube_subtitles_scraper/src/models/captions_info.dart';

@immutable
class ScrapedCaptions {
  const ScrapedCaptions({
    required this.subtitles,
    required this.info,
  });

  final List<ParsedSubtitle> subtitles;
  final CaptionsInfo info;

  @override
  String toString() => 'ScrapedCaptions(subtitles: $subtitles, info: $info)';

  @override
  bool operator ==(covariant ScrapedCaptions other) {
    if (identical(this, other)) return true;

    return listEquals(other.subtitles, subtitles) && other.info == info;
  }

  @override
  int get hashCode => subtitles.hashCode ^ info.hashCode;
}
