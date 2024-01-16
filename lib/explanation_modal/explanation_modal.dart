import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

class ExplanationModalSheet extends StatelessWidget {
  ExplanationModalSheet({
    super.key,
    required String word,
    ValueListenable<Size?>? sizeListenable,
  })  : _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
                'https://www.linguee.com/english-german/search?source=auto&query=+$word'),
          ),
        _sizeListenable = sizeListenable
            ?.syncMap(
              (size) => size != null
                  ? Size(size.width, size.height - dragHandleBoxHeight)
                  : null,
            )
            .unique;
  static const dragHandleBoxHeight = kMinInteractiveDimension;
  final WebViewController _controller;
  final ValueListenable<Size?>? _sizeListenable;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Size?>(
      valueListenable: _sizeListenable ?? ValueNotifier(null),
      builder: (context, size, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size?.width,
          height: size?.height,
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
      },
    );
  }
}
