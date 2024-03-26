import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/history_word_item.dart';
import 'notifier.dart';

final wordsHistoryProvider =
    StateNotifierProvider<WordsHistoryNotifier, List<HistoryWordItem>>(
  (ref) => WordsHistoryNotifier(),
);
