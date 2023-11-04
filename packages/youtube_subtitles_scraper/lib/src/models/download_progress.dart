import 'package:flutter/foundation.dart';

@immutable
class SubtitlesDownloadProgress {
  // progress unique id
  final String uuid;

  // download progress from 0.0 to 1.0
  final double value;

  const SubtitlesDownloadProgress({
    required this.uuid,
    required this.value,
  }) : assert(value >= 0.0 && value <= 1.0);

  SubtitlesDownloadProgress copyWith({double? value}) =>
      SubtitlesDownloadProgress(
        uuid: uuid,
        value: value ?? this.value,
      );

  bool get isActive => value < 1.0;

  @override
  String toString() => 'SubtitlesDownloadProgress(id: $uuid, value: $value)';

  @override
  bool operator ==(covariant SubtitlesDownloadProgress other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid && other.value == value;
  }

  @override
  int get hashCode => uuid.hashCode ^ value.hashCode;
}
