import 'dart:developer';

import 'package:subtitles_parser/duration_sanitizer.dart';

import 'rust_bridge/api.dart';
export 'rust_bridge/parsed_subtitle.dart';

Future<List<ParsedSubtitle>> parseSubtitles(String rawSubtitles) async =>
    rustApi
        .parseSubtitles(rawSubtitles: rawSubtitles)
        .then(
          (subtitles) => subtitles.santitizeDurations().toList(),
        )
        .onError((error, stackTrace) {
      log(error.toString());
      log(rawSubtitles);
      throw stackTrace;
    });
