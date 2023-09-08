import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/history_word_item.dart';

final List<HistoryWordItem> words = [
  HistoryWordItem(
    originVideoId: 'Itbsnna09MY',
    word: "Habe",
    translation: "have",
    media: Container(
      color: Colors.red,
      width: 90,
    ),
  ),
  HistoryWordItem(
    originVideoId: 'Itbsnna09MY',
    word: "Milch",
    translation: "Milk",
    media: Container(
      color: Colors.red,
      width: 90,
    ),
  ),
  HistoryWordItem(
    originVideoId: 'dzJvuswZ5ys',
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

  void search({required String text}) {
    log(text);
  }

  void sort() {
    // oldest, newest
  }
  void refresh() {}
}
