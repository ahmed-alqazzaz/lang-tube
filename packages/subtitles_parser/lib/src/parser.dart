import 'dart:developer';

import 'package:subtitles_parser/src/duration_sanitizer.dart';
import 'package:subtitles_parser/src/rust_bridge/api.dart';
import 'package:subtitles_parser/src/rust_bridge/parsed_subtitle.dart';

final class SubtitlesParser {
  static Future<List<ParsedSubtitle>> parseSrv1(String rawSubtitles) async =>
      rustApi
          .parseSrv1StaticMethodSubtitlesParser(rawSubtitles: rawSubtitles)
          .sanitizeOutput();

  static Future<List<ParsedSubtitle>> parseYoutubeTimedText(
          String rawSubtitles) async =>
      rustApi
          .parseYoutubeTimedTextStaticMethodSubtitlesParser(
              rawSubtitles: rawSubtitles)
          .sanitizeOutput();
}

extension on Future<List<ParsedSubtitle>> {
  Future<List<ParsedSubtitle>> sanitizeOutput() =>
      then((subtitles) => subtitles.santitizeDurations().toList())
          .onError(_errorHandler);

  static Future<List<ParsedSubtitle>> _errorHandler(
      Object error, StackTrace stackTrace) {
    log(error.toString());
    throw stackTrace;
  }
}
