import 'package:flutter/material.dart';

import 'insertion_controller.dart';

class InsertableText extends StatefulWidget {
  const InsertableText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 2,
    this.insertionController,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final InsertionController? insertionController;
  @override
  State<InsertableText> createState() => _InsertableTextState();
}

class _InsertableTextState extends State<InsertableText> {
  late final ScrollController _scrollController = ScrollController();
  InsertionController? __insertionController;
  InsertionController get _insertionController =>
      widget.insertionController ??
      (__insertionController = InsertionController());

  @override
  void initState() {
    _jumpToEnd();
    _insertionController
      ..insert(widget.text)
      ..addListener(_animateToEnd);

    super.initState();
  }

  void _animateToEnd() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  void _jumpToEnd() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    __insertionController?.dispose();
    super.dispose();
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
        controller: _scrollController,
        child: ValueListenableBuilder<String>(
            valueListenable: _insertionController,
            builder: (context, text, _) {
              return Text(
                text,
                style: widget.style,
              );
            }),
      ),
    );
  }
}
