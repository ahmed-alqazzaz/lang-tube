import 'package:flutter/foundation.dart';

@immutable
final class WebExample {
  final String link;
  final String title;
  final String content;
  const WebExample({
    required this.link,
    required this.title,
    required this.content,
  });

  @override
  String toString() =>
      'WebExample(link: $link, title: $title, content: $content)';

  @override
  bool operator ==(covariant WebExample other) {
    if (identical(this, other)) return true;

    return other.link == link &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode => link.hashCode ^ title.hashCode ^ content.hashCode;

  WebExample copyWith({
    String? link,
    String? title,
    String? content,
  }) {
    return WebExample(
      link: link ?? this.link,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
