import 'package:flutter/foundation.dart';
import 'package:languages/languages.dart';

@immutable
final class LanguageConfig {
  final Language? targetLanguage;
  final Language? translationLanguage;

  const LanguageConfig({
    this.targetLanguage,
    this.translationLanguage,
  });

  LanguageConfig copyWith({
    Language? targetLanguage,
    Language? translationLanguage,
  }) {
    return LanguageConfig(
      targetLanguage: targetLanguage ?? this.targetLanguage,
      translationLanguage: translationLanguage ?? this.translationLanguage,
    );
  }

  @override
  String toString() =>
      'LanguageConfig(targetLanguage: $targetLanguage, translationLanguage: $translationLanguage)';

  @override
  bool operator ==(covariant LanguageConfig other) {
    if (identical(this, other)) return true;

    return other.targetLanguage == targetLanguage &&
        other.translationLanguage == translationLanguage;
  }

  @override
  int get hashCode => targetLanguage.hashCode ^ translationLanguage.hashCode;
}
