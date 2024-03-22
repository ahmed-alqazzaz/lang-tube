import 'package:collection/collection.dart';
import 'package:languages/languages.dart';

extension LanguageFactory on Language {
  static Language? fromName(String? language) =>
      Language.values.firstWhereOrNull((element) => element.name == language);

  static Language? fromCode(String? code) =>
      Language.values.firstWhereOrNull((element) => element.code == code);
}
