import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class CarouselVideoItem {
  final String title;
  final String thumbnailUrl;
  final List<String> badges;
  final void Function() onPressed;
  final void Function() onActionsMenuPressed;

  const CarouselVideoItem({
    required this.title,
    required this.thumbnailUrl,
    required this.badges,
    required this.onPressed,
    required this.onActionsMenuPressed,
  });

  CarouselVideoItem copyWith({
    String? title,
    String? thumbnailUrl,
    List<String>? badges,
    void Function()? onPressed,
    void Function()? onActionsMenuPressed,
  }) {
    return CarouselVideoItem(
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      badges: badges ?? this.badges,
      onPressed: onPressed ?? this.onPressed,
      onActionsMenuPressed: onActionsMenuPressed ?? this.onActionsMenuPressed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'badges': badges,
      'onPressed': onPressed,
      'onActionsMenuPressed': onActionsMenuPressed,
    };
  }

  @override
  String toString() {
    return 'CarouselVideoItem(title: $title, thumbnailUrl: $thumbnailUrl, badges: $badges, onPressed: $onPressed, onActionsMenuPressed: $onActionsMenuPressed)';
  }

  @override
  bool operator ==(covariant CarouselVideoItem other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.title == title &&
        other.thumbnailUrl == thumbnailUrl &&
        listEquals(other.badges, badges) &&
        other.onPressed == onPressed &&
        other.onActionsMenuPressed == onActionsMenuPressed;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        thumbnailUrl.hashCode ^
        badges.hashCode ^
        onPressed.hashCode ^
        onActionsMenuPressed.hashCode;
  }
}
