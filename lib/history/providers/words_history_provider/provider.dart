import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/providers/words_history_provider/notifier.dart';
import 'package:lang_tube/history/words_list/history_word_item.dart';

final wordsHistoryProvider =
    StateNotifierProvider<WordsHistoryNotifier, List<HistoryWordItem>>(
  (ref) => WordsHistoryNotifier(),
);
