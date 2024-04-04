import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DynamicText extends StatefulWidget {
  const DynamicText({
    super.key,
    required this.listenableText,
    this.style,
    this.maxLines = 2,
  });

  final Stream<String> listenableText;
  final TextStyle? style;
  final int maxLines;
  @override
  State<DynamicText> createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText> {
  late final ScrollController _scrollController;
  late final StreamSubscription<String> _subscription;
  @override
  void initState() {
    _jumpToEnd();
    _scrollController = ScrollController();
    _subscription = widget.listenableText.listen((_) => _animateToEnd());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _animateToEnd() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  void _jumpToEnd() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      },
    );
  }

  DefaultTextStyle get _defualtStyle => DefaultTextStyle.of(context);
  double get _lineHeight => widget.style?.height ?? _defualtStyle.style.height!;
  double get _fontSize =>
      widget.style?.fontSize ?? _defualtStyle.style.fontSize!;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _lineHeight * _fontSize * widget.maxLines,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        child: StreamBuilder<String>(
          stream: widget.listenableText,
          builder: (context, snapshot) {
            widget.listenableText;
            return Text(
              snapshot.data ?? "",
              style: widget.style,
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
