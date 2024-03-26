import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_item.dart';

class BrowserHistoryNotifier extends StateNotifier<List<BrowserHistoryItem>> {
  BrowserHistoryNotifier() : super([]) {}
}
