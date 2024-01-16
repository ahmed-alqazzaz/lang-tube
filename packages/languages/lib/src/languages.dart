import 'package:flutter/material.dart';
import 'package:languages/src/language_flags.dart';
import 'language_codes.dart';
import 'language_patterns.dart';
part 'languages/german.dart';

@immutable
class Language {
  const Language._({
    required this.code,
    required this.pattern,
    required this.name,
    required this.flag,
  });

  final String code;
  final String pattern;
  final String name;
  final Image flag;

  static Language get english => Language._(
        code: LanguageCodes.english,
        name: 'english',
        pattern: LanguagePatterns.english,
        flag: LangaugeFlags.english,
      );

  static List<Language> get germanVariants => German.variants;

  static Language get french => Language._(
        code: LanguageCodes.french,
        name: 'french',
        pattern: LanguagePatterns.french,
        flag: LangaugeFlags.french,
      );

  static Language get arabic => Language._(
        code: LanguageCodes.arabic,
        name: 'arabic',
        pattern: LanguagePatterns.arabic,
        flag: LangaugeFlags.arabic,
      );

  static List<Language> get values => [
        Language.arabic,
        Language.english,
        Language.french,
        ...Language.germanVariants,
      ];

  @override
  String toString() {
    return 'Language(code: $code, pattern: $pattern, name: $name, flag: $flag)';
  }

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.code == code;
  }

  @override
  int get hashCode {
    return code.hashCode ^ pattern.hashCode ^ name.hashCode ^ flag.hashCode;
  }

  Language copyWith({
    String? code,
    String? pattern,
    String? name,
    Image? flag,
  }) {
    return Language._(
      code: code ?? this.code,
      pattern: pattern ?? this.pattern,
      name: name ?? this.name,
      flag: flag ?? this.flag,
    );
  }
}
