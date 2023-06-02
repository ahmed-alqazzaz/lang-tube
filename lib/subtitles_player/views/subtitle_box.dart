import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/word_selectability_provider.dart';

typedef OnSubtitleTapped = void Function({
  required void Function() onReset,
  required String word,
});

class SubtitleBox extends ConsumerWidget {
  const SubtitleBox({
    super.key,
    required this.words,
    required this.backgroundColor,
    required this.defaultTextColor,
    this.onTap,
    required this.textFontSize,
    this.fontWeight = FontWeight.normal,
  });
  static const Color selectedTextColor = Colors.amber;
  static const int maxLines = 3;
  final Color backgroundColor;
  final Color defaultTextColor;
  final double textFontSize;
  final FontWeight fontWeight;

  final OnSubtitleTapped? onTap;
  final List<String> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        wordSelectabilityProvider
            .overrideWith((ref) => WordSelectabilityModel())
      ],
      child: Consumer(
        builder: (context, ref, _) {
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
                      ..onTap = () {
                        ref
                            .read(wordSelectabilityProvider)
                            .updateSelectedWordIndex(index);
                        onTap?.call(
                          onReset: () {
                            ref.read(wordSelectabilityProvider).reset();
                          },
                          word: words[index],
                        );
                      },
                    style: TextStyle(
                      color: selectedWordIndex == index
                          ? selectedTextColor
                          : defaultTextColor,
                      fontSize: textFontSize,
                      backgroundColor: backgroundColor,
                      fontWeight: fontWeight,
                    ),
                  )
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
