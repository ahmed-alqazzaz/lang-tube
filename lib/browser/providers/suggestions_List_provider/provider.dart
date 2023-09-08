import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notfier.dart';

final browserSugesstionsListProvider =
    StateNotifierProvider<BrowserSuggestionsListNotifier, List<String>>(
  (ref) => BrowserSuggestionsListNotifier(),
);
