// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class ObservedVideo {
  final String id;
  final String title;
  final String channelIconUrl;
  final String thumbnailUrl;
  final String sourceTab;

  final List<String> badges;
  final Future<void> Function() click;
  const ObservedVideo({
    required Future<void> Function() onClick,
    required this.id,
    required this.title,
    required this.channelIconUrl,
    required this.thumbnailUrl,
    required this.sourceTab,
    required this.badges,
  }) : click = onClick;

  String get channelName => badges.first;

  ObservedVideo copyWith({
    String? videoId,
    String? title,
    String? channelIconUrl,
    String? thumbnailUrl,
    String? sourceTab,
    List<String>? badges,
    Future<void> Function()? onClick,
  }) {
    return ObservedVideo(
      id: videoId ?? this.id,
      title: title ?? this.title,
      channelIconUrl: channelIconUrl ?? this.channelIconUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      sourceTab: sourceTab ?? this.sourceTab,
      badges: badges ?? this.badges,
      onClick: onClick ?? click,
    );
  }

  @override
  String toString() {
    return 'YoutubeVideoItem(videoId: $id, title: $title, channelIconUrl: $channelIconUrl, thumbnailUrl: $thumbnailUrl, sourceTab: $sourceTab, badges: $badges, click: $click)';
  }

  @override
  bool operator ==(covariant ObservedVideo other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.title == title &&
        other.channelIconUrl == channelIconUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.sourceTab == sourceTab &&
        listEquals(other.badges, badges) &&
        other.click == click;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        channelIconUrl.hashCode ^
        thumbnailUrl.hashCode ^
        sourceTab.hashCode ^
        badges.hashCode ^
        click.hashCode;
  }
}
