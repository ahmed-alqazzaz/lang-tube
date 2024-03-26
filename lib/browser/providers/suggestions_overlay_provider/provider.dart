import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../suggestions_List_provider/provider.dart';
import 'notifier.dart';

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
