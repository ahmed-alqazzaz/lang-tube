import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'suggestions_list.dart';

class BrowserSuggestionsOverlayNotifier extends StateNotifier<OverlayEntry?> {
  BrowserSuggestionsOverlayNotifier({
    required Stream<List<String>> suggestionsStream,
    required List<String> Function() initialSuggestionsCallback,
  })  : _suggestionsStream = suggestionsStream,
        _initialSuggestionsCallback = initialSuggestionsCallback,
        super(null);

  final Stream<List<String>> _suggestionsStream;
  final List<String> Function() _initialSuggestionsCallback;

  void show(BuildContext context) {
    state?.remove();
    state = _suggestionsListOverlay;
    Overlay.of(context).insert(state!);
  }

  void hide() {
    state?.remove();
    state = null;
  }

  OverlayEntry get _suggestionsListOverlay {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top +
              AppBar().preferredSize.height,
          bottom: 0,
          left: 0,
          right: 0,
          child: StreamBuilder<List<String>>(
            initialData: _initialSuggestionsCallback(),
            stream: _suggestionsStream,
            builder: (context, snapshot) {
              return BrowserSuggestionsList(
                onTap: (suggestion) {},
                suggestions: snapshot.data ?? [],
              );
            },
          ),
        );
      },
    );
  }
}
