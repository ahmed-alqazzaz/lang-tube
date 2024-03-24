import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:languages/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/miscellaneous/lang_config.dart';

final languageConfigProvider =
    AsyncNotifierProvider<LanguageConfigNotifier, LanguageConfig>(
  () => LanguageConfigNotifier(),
);

class LanguageConfigNotifier extends AsyncNotifier<LanguageConfig> {
  @override
  Future<LanguageConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    ref.listenSelf((_, langConfig) {
      prefs.setString(
        _targetLanguageCodeKey,
        langConfig.value!.targetLanguage!.code,
      );
      prefs.setString(
        _translationLanguageCodeKey,
        langConfig.value!.translationLanguage!.code,
      );
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

  Future<void> setTargetLanguage(Language language) async =>
      state = AsyncValue.data(state.value!.copyWith(targetLanguage: language));

  Future<void> setTranslationLanguage(Language language) async => state =
      AsyncValue.data(state.value!.copyWith(translationLanguage: language));

  // Keys for SharedPreferences.
  static const String _targetLanguageCodeKey = 'targetLanguageCode';
  static const String _translationLanguageCodeKey = 'translationLanguageCode';
}
