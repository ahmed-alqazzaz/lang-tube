// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../languages.dart';

class X {
  final Language main;
  final List<Language> variants;
  X()
      : main = _builder(
          code: LanguageCodes.german,
          name: 'German',
        ),
        variants = [
          _builder(
            code: LanguageCodes.german,
            name: 'German',
          ),
          _builder(
            code: LanguageCodes.germanGermany,
            name: 'German (Germany)',
          ),
          _builder(
            code: LanguageCodes.germanAustria,
            name: 'German (Austria)',
          ),
          _builder(
            code: LanguageCodes.germanSwitzerland,
            name: 'German (Switzerland)',
          ),
          _builder(
            code: LanguageCodes.germanLiechtenstein,
            name: 'German (Liechtenstein)',
          ),
          German._(
            code: LanguageCodes.germanLuxembourg,
            name: 'German (Luxembourg)',
          ),
        ];

  static Language _builder({
    required String code,
    required String name,
  }) {
    return Language._(
      code: code,
      name: name,
      pattern: LanguagePatterns.german,
      flag: LangaugeFlags.german,
    );
  }
}

@immutable
final class German extends Language {
  German._({
    required String code,
    required String name,
  }) : super._(
          code: code,
          name: name,
          pattern: LanguagePatterns.german,
          flag: LangaugeFlags.german,
        );
  static Language get main => German._(
        code: LanguageCodes.german,
        name: 'German',
      );
  static List<Language> get variants => [
        German._(
          code: LanguageCodes.german,
          name: 'German',
        ),
        German._(
          code: LanguageCodes.germanGermany,
          name: 'German (Germany)',
        ),
        German._(
          code: LanguageCodes.germanAustria,
          name: 'German (Austria)',
        ),
        German._(
          code: LanguageCodes.germanSwitzerland,
          name: 'German (Switzerland)',
        ),
        German._(
          code: LanguageCodes.germanLiechtenstein,
          name: 'German (Liechtenstein)',
        ),
        German._(
          code: LanguageCodes.germanLuxembourg,
          name: 'German (Luxembourg)',
        ),
      ];
}
