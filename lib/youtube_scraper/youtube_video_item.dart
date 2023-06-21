import 'package:flutter/foundation.dart';

@immutable
class YoutubeVideoItem {
  final String videoId;
  final String title;
  final Uri channelIconUri;
  final Uri thumbnailUri;

  final List<String> badges;
  final Future<void> Function() click;
  const YoutubeVideoItem({
    required this.videoId,
    required this.title,
    required this.badges,
    required this.channelIconUri,
    required this.thumbnailUri,
    required Future<void> Function() onClick,
  }) : click = onClick;

  YoutubeVideoItem copyWith({
    String? videoId,
    Uri? channelIconUri,
    Uri? thumbnailUri,
    String? title,
    List<String>? badges,
    Future<void> Function()? onClick,
  }) {
    return YoutubeVideoItem(
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      badges: badges ?? this.badges,
      channelIconUri: channelIconUri ?? this.channelIconUri,
      thumbnailUri: thumbnailUri ?? this.thumbnailUri,
      onClick: onClick ?? click,
    );
  }

  @override
  String toString() {
    return 'YoutubeVideoItem(videoId: $videoId, title: $title, badges: $badges, channelIconUri: $channelIconUri, thumbnailUri: $thumbnailUri, click: $click)';
  }

  @override
  bool operator ==(covariant YoutubeVideoItem other) {
    if (identical(this, other)) return true;
    return other.videoId == videoId &&
        other.title == title &&
        listEquals(other.badges, badges) &&
        other.channelIconUri == channelIconUri &&
        other.thumbnailUri == thumbnailUri &&
        other.click == click;
  }

  @override
  int get hashCode {
    return videoId.hashCode ^
        title.hashCode ^
        badges.hashCode ^
        channelIconUri.hashCode ^
        thumbnailUri.hashCode ^
        click.hashCode;
  }
}
