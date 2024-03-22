// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';
import 'package:youtube_subtitles_scraper/src/models/captions_info.dart';

@immutable
class SourceCaptions {
  final Uri uri;
  final CaptionsInfo info;

  const SourceCaptions({
    required this.uri,
    required this.info,
  });

  DateTime? get expirationDate {
    dynamic expirationInSeconds = uri.queryParameters['expire'];
    expirationInSeconds =
        expirationInSeconds != null ? int.tryParse(expirationInSeconds) : null;
    return expirationInSeconds is int
        ? DateTime.fromMillisecondsSinceEpoch(
            expirationInSeconds * 1000,
          )
        : null;
  }

  bool? get isExpired => expirationDate?.isBefore(DateTime.now());

  bool get isAutoTranslated => uri.queryParameters.containsKey('tlang');

  SourceCaptions autoTranslate(Language language) {
    Map<String, String> queryParameters = Map.from(uri.queryParameters);
    queryParameters['tlang'] = language.code;
    return copyWith(
      uri: uri.replace(
        queryParameters: queryParameters,
      ),
    );
  }

  SourceCaptions copyWith({
    Uri? uri,
    CaptionsInfo? info,
  }) {
    return SourceCaptions(
      uri: uri ?? this.uri,
      info: info ?? this.info,
    );
  }
}
