import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/browser/providers/search_history_provider/history_item.dart';

class BrowserHistoryNotifier extends StateNotifier<List<BrowserHistoryItem>> {
  BrowserHistoryNotifier() : super([]) {}
}
