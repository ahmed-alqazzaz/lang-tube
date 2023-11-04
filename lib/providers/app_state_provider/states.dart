// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
abstract class AppState {
  const AppState();
}

class DisplayingHomePage extends AppState {
  const DisplayingHomePage();
}

final class DisplayingVideoPlayer extends AppState {
  final String videoId;
  const DisplayingVideoPlayer({required this.videoId});

  @override
  bool operator ==(covariant DisplayingVideoPlayer other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId;
  }

  @override
  int get hashCode => videoId.hashCode;

  @override
  String toString() => 'DisplayingVideoPlayer(videoId: $videoId)';

  DisplayingVideoPlayer copyWith({
    String? videoId,
  }) {
    return DisplayingVideoPlayer(
      videoId: videoId ?? this.videoId,
    );
  }
}
