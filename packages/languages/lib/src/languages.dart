import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:languages/src/language_flags.dart';

import 'language_codes.dart';
import 'language_patterns.dart';

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

  factory Language.english() => Language._(
        code: LanguageCodes.english,
        name: 'english',
        pattern: LanguagePatterns.english,
        flag: LangaugeFlags.english,
      );

  factory Language.german() => Language._(
        code: LanguageCodes.german,
        name: 'german',
        pattern: LanguagePatterns.german,
        flag: LangaugeFlags.german,
      );

  factory Language.french() => Language._(
        code: LanguageCodes.french,
        name: 'french',
        pattern: LanguagePatterns.french,
        flag: LangaugeFlags.french,
      );

  factory Language.arabic() => Language._(
        code: LanguageCodes.arabic,
        name: 'arabic',
        pattern: LanguagePatterns.arabic,
        flag: LangaugeFlags.arabic,
      );
}
