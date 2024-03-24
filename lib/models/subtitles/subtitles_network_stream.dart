import 'package:flutter/material.dart';

import 'subtitles_bundle.dart';

@immutable
final class SubtitlesNetworkStream {
  final Iterable<CaptionsBundle>? subtitlesBundles;
  final double downloadProgress;
  const SubtitlesNetworkStream({
    this.subtitlesBundles,
    required this.downloadProgress,
  }) : assert(subtitlesBundles != null
            ? downloadProgress == 1.0
            : downloadProgress < 1.0);

  SubtitlesNetworkStream copyWith({
    Iterable<CaptionsBundle>? subtitlesBundles,
    double? downloadProgress,
  }) {
    return SubtitlesNetworkStream(
      subtitlesBundles: subtitlesBundles ?? this.subtitlesBundles,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  @override
  String toString() =>
      'SubtitlesNetworkStream(subtitlesBundles: $subtitlesBundles, downloadProgress: $downloadProgress)';

  @override
  bool operator ==(covariant SubtitlesNetworkStream other) {
    if (identical(this, other)) return true;

    return other.subtitlesBundles == subtitlesBundles &&
        other.downloadProgress == downloadProgress;
  }

  @override
  int get hashCode => subtitlesBundles.hashCode ^ downloadProgress.hashCode;
}
