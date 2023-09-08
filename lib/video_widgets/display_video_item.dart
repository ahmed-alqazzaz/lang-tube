// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class DisplayVideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final List<String> badges;
  final DateTime lastWatched;
  final String duration;
  final void Function() onPressed;
  final void Function() onActionsMenuPressed;
  const DisplayVideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.badges,
    required this.lastWatched,
    required this.duration,
    required this.onPressed,
    required this.onActionsMenuPressed,
  });

  DisplayVideoItem copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    List<String>? badges,
    DateTime? lastWatched,
    String? duration,
    void Function()? onPressed,
    void Function()? onActionsMenuPressed,
  }) {
    return DisplayVideoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      badges: badges ?? this.badges,
      lastWatched: lastWatched ?? this.lastWatched,
      duration: duration ?? this.duration,
      onPressed: onPressed ?? this.onPressed,
      onActionsMenuPressed: onActionsMenuPressed ?? this.onActionsMenuPressed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'badges': badges,
      'lastWatched': lastWatched.millisecondsSinceEpoch,
      'duration': duration,
    };
  }

  factory DisplayVideoItem.fromMap({
    required Map<String, dynamic> map,
    required VoidCallback onPressed,
    required VoidCallback onTrailingPressed,
  }) {
    return DisplayVideoItem(
      id: map['id'] as String,
      title: map['title'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      badges: List<String>.from((map['badges'] as List<String>)),
      lastWatched:
          DateTime.fromMillisecondsSinceEpoch(map['lastWatched'] as int),
      duration: map['duration'] as String,
      onPressed: onPressed,
      onActionsMenuPressed: onTrailingPressed,
    );
  }

  String toJson() => json.encode(toMap());

  factory DisplayVideoItem.fromJson({
    required String source,
    required VoidCallback onPressed,
    required VoidCallback onTrailingPressed,
  }) =>
      DisplayVideoItem.fromMap(
        map: json.decode(source) as Map<String, dynamic>,
        onPressed: onPressed,
        onTrailingPressed: onTrailingPressed,
      );

  @override
  String toString() {
    return 'DisplayVideoItem(id: $id, title: $title, thumbnailUrl: $thumbnailUrl, badges: $badges, lastWatched: $lastWatched, duration: $duration, onPressed: $onPressed, onActionsMenuPressed: $onActionsMenuPressed)';
  }

  @override
  bool operator ==(covariant DisplayVideoItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.thumbnailUrl == thumbnailUrl &&
        listEquals(other.badges, badges) &&
        other.lastWatched == lastWatched &&
        other.duration == duration &&
        other.onPressed == onPressed &&
        other.onActionsMenuPressed == onActionsMenuPressed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        thumbnailUrl.hashCode ^
        badges.hashCode ^
        lastWatched.hashCode ^
        duration.hashCode ^
        onPressed.hashCode ^
        onActionsMenuPressed.hashCode;
  }
}
