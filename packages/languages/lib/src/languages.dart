import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
part 'languages/german.dart';
part 'languages/english.dart';
part 'languages/french.dart';
part 'languages/arabic.dart';

@immutable
abstract class Language {
  const Language({
    required this.code,
    required this.pattern,
    required this.name,
    required this.flagUrl,
  });

  final String code;
  final String pattern;
  final String name;
  final String flagUrl;

  Image get flag => Image.network(
        flagUrl,
        fit: BoxFit.cover,
      );

  static const English english = English();

  static const German german = German();

  static const French french = French();

  static const Arabic arabic = Arabic();

  static List<Language> get values => [
        Language.arabic,
        ...Language.arabic.variants,
        Language.french,
        ...Language.french.variants,
        Language.english,
        ...Language.english.variants,
        Language.german,
        ...Language.german.variants,
      ];

  @override
  String toString() {
    return 'Language(code: $code, pattern: $pattern, name: $name, flag: $flagUrl)';
  }

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;
    return other.code == code;
  }

  static Language? fromName(String? language) =>
      Language.values.firstWhereOrNull((element) => element.name == language);
  static Language? fromCode(String? code) =>
      Language.values.firstWhereOrNull((element) => element.code == code);

  @override
  int get hashCode {
    return code.hashCode ^ pattern.hashCode ^ name.hashCode ^ flagUrl.hashCode;
  }

  List<Language> get variants;
}
