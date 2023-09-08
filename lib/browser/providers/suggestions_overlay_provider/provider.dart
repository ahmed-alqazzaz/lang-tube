import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/browser/providers/suggestions_overlay_provider/notifier.dart';

import '../suggestions_List_provider/provider.dart';

final browserSuggestionsOverlayProvider =
    StateNotifierProvider<BrowserSuggestionsOverlayNotifier, OverlayEntry?>(
  (ref) {
    return BrowserSuggestionsOverlayNotifier(
      suggestionsStream:
          ref.read(browserSugesstionsListProvider.notifier).stream,
      initialSuggestionsCallback: () {
        return ref.read(browserSugesstionsListProvider);
      },
    );
  },
);
