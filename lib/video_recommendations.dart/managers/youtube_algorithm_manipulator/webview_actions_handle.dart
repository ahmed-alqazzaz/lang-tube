import 'package:flutter/cupertino.dart';

@immutable
class WebviewActionsHandle {
  const WebviewActionsHandle({
    required this.scrollToBottom,
    required this.getCurrentUrl,
    required this.navigateHome,
    required this.getClickDepth,
  });

  final Future<void> Function() scrollToBottom;
  final Future<void> Function() getCurrentUrl;
  final Future<void> Function() navigateHome;
  final Future<int> Function() getClickDepth;
}
