import 'package:flutter/material.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

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
    this.selectable = false,
    this.maxLines = 3,
    this.fontWeight = FontWeight.normal,
  });

  final int maxLines;
  final Color backgroundColor;
  final Color defaultTextColor;
  final double textFontSize;
  final FontWeight fontWeight;

  final OnSubtitleTapped? onTapUp;
  final bool selectable;
  final List<String> words;

  @override
  State<SubtitleBox> createState() => _SubtitleBoxState();
}

class _SubtitleBoxState extends State<SubtitleBox> {
  late final ValueNotifier<int?> _selectedIndexNotifier;
  @override
  void initState() {
    _selectedIndexNotifier = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        textAlign: TextAlign.center,
        text: TextSpan(
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
      ),
    );
  }

  static const Color selectedTextColor = Colors.amber;
}
