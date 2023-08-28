import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../words_list/history_word_item.dart';

final List<HistoryWordItem> words = [
  HistoryWordItem(
    word: "Habe",
    translation: "have",
    media: Container(
      color: Colors.red,
      width: 90,
    ),
  ),
  HistoryWordItem(
    word: "Milch",
    translation: "Milk",
    media: Container(
      color: Colors.red,
      width: 90,
    ),
  ),
  HistoryWordItem(
    word: "will",
    translation: "want",
    media: Container(
      color: Colors.red,
      width: 90,
    ),
  )
];

class WordsHistoryNotifier extends StateNotifier<List<HistoryWordItem>> {
  WordsHistoryNotifier() : super([]) {
    for (var element in words) {
      state = [...state, element];
    }
  }
  void addItem(HistoryWordItem item) {}
  void removeItem(HistoryWordItem item) {}
  void filter() {
    // last month, last day
  }
  void search({required String text}) {
    log(text);
  }

  void sort() {
    // oldest, newest
  }
  void refresh() {}
}
