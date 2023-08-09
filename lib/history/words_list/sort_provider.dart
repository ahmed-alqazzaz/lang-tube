import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/words_list/sort_settings.dart';

class _SettingsStateNotifier extends StateNotifier<WordsListSortSettings> {
  _SettingsStateNotifier() : super(WordsListSortSettings.recent);

  void updateSettings(WordsListSortSettings newSettings) => state = newSettings;
}

final wordsListSortProvider = StateNotifierProvider.autoDispose<
    _SettingsStateNotifier,
    WordsListSortSettings>((ref) => _SettingsStateNotifier());
