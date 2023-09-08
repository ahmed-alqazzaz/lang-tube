import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTerms = [
  'bananas',
  'stawberries',
  'apples',
  'oranges',
  'pineapples',
];

class BrowserSuggestionsListNotifier extends StateNotifier<List<String>> {
  BrowserSuggestionsListNotifier() : super([]);

  void updateQuery(String query) {
    state = (searchTerms.where(
      (term) => term.contains(query),
    )).toList();
  }
}
