// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/data/constants.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/utils/int_to_bool.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

class CachedSourceCaptions extends SourceCaptions {
  const CachedSourceCaptions({
    required super.uri,
    required super.videoId,
    required super.isAutoGenerated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uri': uri.toString(),
      'videoId': videoId,
      'isAutoGenerated': isAutoGenerated,
    };
  }

  factory CachedSourceCaptions.fromMap(Map<String, dynamic> map) {
    return CachedSourceCaptions(
      uri: Uri.parse(map[subtitlesSourceColumn]),
      videoId: map[videoIdColumn] as String,
      isAutoGenerated: intToBool(
        map[isSubtitleAutoGeneratedColumn],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CachedSourceCaptions.fromJson(String source) =>
      CachedSourceCaptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
