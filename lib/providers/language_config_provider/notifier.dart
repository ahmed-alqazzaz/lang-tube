import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/providers/language_config_provider/state.dart';
import 'package:languages/languages.dart';
import 'package:mutex/mutex.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages language configurations.
class LanguageConfigNotifier extends StateNotifier<LanguageConfig> {
  // Singleton instance.
  static LanguageConfigNotifier get instance => _instance;
  static final _instance = LanguageConfigNotifier._();
  static final _mutex = Mutex();

  // Constructor loads language configs from SharedPreferences.
  LanguageConfigNotifier._() : super(const LanguageConfig()) {
    _mutex.acquire();
    SharedPreferences.getInstance().then((prefs) {
      state = LanguageConfig(
        // Load target language.
        targetLanguage: Language.values.firstWhereOrNull(
          (lang) => lang.code == prefs.getString(_targetLanguageCodeKey),
        ),
        // Load translation language.
        translationLanguage: Language.values.firstWhereOrNull(
          (lang) => lang.code == prefs.getString(_translationLanguageCodeKey),
        ),
      );
    }).whenComplete(_mutex.release);
  }

  // Sets target language and saves it to SharedPreferences.
  FutureOr<void> setTargetLanguage(Language language) async {
    if (state.targetLanguage == language) return;
    try {
      await _mutex.acquire();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_targetLanguageCodeKey, language.code);
      state = state.copyWith(targetLanguage: language);
    } finally {
      _mutex.release();
    }
  }

  // Sets translation language and saves it to SharedPreferences.
  FutureOr<void> setTranslationLanguage(Language language) async {
    if (state.translationLanguage == language) return;
    try {
      await _mutex.acquire();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_translationLanguageCodeKey, language.code);
      state = state.copyWith(translationLanguage: language);
    } finally {
      _mutex.release();
    }
  }

  // Keys for SharedPreferences.
  static const String _targetLanguageCodeKey = 'targetLanguageCode';
  static const String _translationLanguageCodeKey = 'translationLanguageCode';
}
