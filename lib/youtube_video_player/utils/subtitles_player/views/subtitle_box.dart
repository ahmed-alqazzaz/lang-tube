import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/word_selectability_provider.dart';

class SubtitleBox extends ConsumerWidget {
  const SubtitleBox({
    super.key,
    required this.words,
    required this.backgroundColor,
    required this.defaultTextColor,
    required this.onWordTapped,
    required this.textFontSize,
  });

  static const Color selectedTextColor = Colors.deepPurple;

  static const int maxLines = 3;

  final Color backgroundColor;
  final Color defaultTextColor;
  final double textFontSize;

  final void Function(String word) onWordTapped;
  final List<String> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWordIndex =
        ref.watch(wordSelectabilityProvider).selectedWordIndex;
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (int index = 0; index < words.length; index++) ...[
            TextSpan(
              text: '${words[index]} ',
              recognizer: TapGestureRecognizer()
                ..onTap = () => onWordTapped(words[index]),
              style: TextStyle(
                color: selectedWordIndex == index
                    ? selectedTextColor
                    : defaultTextColor,
                fontSize: textFontSize,
                backgroundColor: backgroundColor,
              ),
            )
          ]
        ],
      ),
    );
  }
}
