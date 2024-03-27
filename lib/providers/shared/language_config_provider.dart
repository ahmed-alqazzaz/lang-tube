import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:languages/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/miscellaneous/lang_config.dart';

final languageConfigProvider =
    AsyncNotifierProvider<LanguageConfigNotifier, LanguageConfig>(
  () => LanguageConfigNotifier(),
);

class LanguageConfigNotifier extends AsyncNotifier<LanguageConfig> {
  @override
  Future<LanguageConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    ref.listenSelf((_, langConfig) async {
      final targetLangCode = langConfig.value?.targetLanguage?.code;
      final translationLangCode = langConfig.value?.translationLanguage?.code;
      if (targetLangCode != null) {
        await prefs.setString(
          _targetLanguageCodeKey,
          targetLangCode,
        );
      }
      if (translationLangCode != null) {
        await prefs.setString(
          _translationLanguageCodeKey,
          translationLangCode,
        );
      }
    });
    return LanguageConfig(
      // Load target language.
      targetLanguage: Language.values.firstWhereOrNull(
        (lang) => lang.code == prefs.getString(_targetLanguageCodeKey),
      ),
      // Load translation language.
      translationLanguage: Language.values.firstWhereOrNull(
        (lang) => lang.code == prefs.getString(_translationLanguageCodeKey),
      ),
    );
  }

  Future<void> setTargetLanguage(Language language) async {
    state.whenData(
      (value) =>
          state = AsyncValue.data(value.copyWith(targetLanguage: language)),
    );
  }

  Future<void> setTranslationLanguage(Language language) async =>
      state.whenData(
        (value) => state =
            AsyncValue.data(value.copyWith(translationLanguage: language)),
      );

  // Keys for SharedPreferences.
  static const String _targetLanguageCodeKey = 'targetLanguageCode';
  static const String _translationLanguageCodeKey = 'translationLanguageCode';
}
