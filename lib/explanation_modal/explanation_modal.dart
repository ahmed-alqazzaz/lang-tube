import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_modal_constraints_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExplanationModalSheet extends ConsumerWidget {
  ExplanationModalSheet({super.key, required String word})
      : _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
                'https://www.linguee.com/english-french/search?source=auto&query=+$word'),
          );
  final WebViewController _controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints:
          ref.watch(explanationModalConstraintsProvider).currentConstraints,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return WebViewWidget(
            controller: _controller,
            gestureRecognizers: {
              Factory(() => EagerGestureRecognizer()),
            },
          );
        },
      ),
    );
  }
}
