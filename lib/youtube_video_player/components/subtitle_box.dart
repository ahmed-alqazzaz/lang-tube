import 'dart:developer';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:throttler/throttler.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

final _tapThrottler = Throttler.privateInstance();
const _tapThrottlerDuration = Duration(milliseconds: 100);

typedef OnSubtitleTapped = void Function({
  required void Function() onReset,
  required String word,
});

class SubtitleBox extends StatefulWidget {
  const SubtitleBox({
    super.key,
    required this.words,
    required this.backgroundColor,
    required this.defaultTextColor,
    required this.textFontSize,
    this.onTapUp,
    this.maxLines = 3,
    this.margin = EdgeInsets.zero,
    this.fontWeight = FontWeight.normal,
  });

  final int maxLines;
  final Color backgroundColor;
  final Color defaultTextColor;
  final double textFontSize;
  final FontWeight fontWeight;
  final EdgeInsets margin;
  final OnSubtitleTapped? onTapUp;
  final List<String> words;

  @override
  State<SubtitleBox> createState() => _SubtitleBoxState();
}

class _SubtitleBoxState extends State<SubtitleBox> {
  late final ValueNotifier<int?> _selectedIndexNotifier;
  late final FocusNode _selectionNode;
  @override
  void initState() {
    _selectedIndexNotifier = ValueNotifier(null);
    _selectionNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _selectedIndexNotifier.dispose();
    _selectionNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) => _tapThrottler.throttle(
        _tapThrottlerDuration,
        () => _selectionNode.requestFocus(),
      ),
      child: Container(
        color: widget.backgroundColor,
        padding: widget.margin,
        child: SelectionArea(
          focusNode: _selectionNode,
          child: RichText(
            text: TextSpan(
              style:
                  const TextStyle(overflow: TextOverflow.ellipsis, height: 0.3),
              children: [
                for (int index = 0; index < widget.words.length; index++) ...[
                  WidgetSpan(
                    child: ValueListenableBuilder(
                      valueListenable: _selectedIndexNotifier
                          .syncMap((selectedIndex) => selectedIndex == index)
                          .unique,
                      builder: (context, isSelected, _) {
                        return GestureDetector(
                          onTap: () => _selectedIndexNotifier.value = index,
                          onTapUp: (_) => widget.onTapUp?.call(
                            onReset: () => _selectedIndexNotifier.value = null,
                            word: widget.words[index],
                          ),
                          child: Text(
                            '${widget.words[index]} ',
                            style: TextStyle(
                              color: isSelected
                                  ? selectedTextColor
                                  : widget.defaultTextColor,
                              fontSize: widget.textFontSize,
                              fontWeight: widget.fontWeight,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]
              ],
            ),
            maxLines: widget.maxLines,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static const Color selectedTextColor = Colors.amber;
}
