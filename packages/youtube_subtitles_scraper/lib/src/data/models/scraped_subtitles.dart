// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';

@immutable
class ScrapedSubtitles {
  const ScrapedSubtitles({
    required this.subtitles,
    required this.isAutoGenerated,
    required this.videoId,
    required String language,
  }) : _language = language;
  final String subtitles;
  final String videoId;
  final bool isAutoGenerated;
  final String _language;

  Language? get language {
    for (Language language in Language.values) {
      if (language.name == _language) return language;
    }
    return null;
  }

  @override
  String toString({bool includeSubtitles = false}) {
    return 'ScrapedSubtitles(${includeSubtitles ? 'subtitles: $subtitles' : ''}, videoId: $videoId, isAutoGenerated: $isAutoGenerated, _language: $_language)';
  }

  ScrapedSubtitles copyWith({
    String? subtitles,
    String? videoId,
    bool? isAutoGenerated,
    String? language,
  }) {
    return ScrapedSubtitles(
      subtitles: subtitles ?? this.subtitles,
      videoId: videoId ?? this.videoId,
      isAutoGenerated: isAutoGenerated ?? this.isAutoGenerated,
      language: language ?? _language,
    );
  }

  @override
  bool operator ==(covariant ScrapedSubtitles other) {
    if (identical(this, other)) return true;

    return other.subtitles == subtitles &&
        other.videoId == videoId &&
        other.isAutoGenerated == isAutoGenerated &&
        other._language == _language;
  }

  @override
  int get hashCode {
    return subtitles.hashCode ^
        videoId.hashCode ^
        isAutoGenerated.hashCode ^
        _language.hashCode;
  }
}
