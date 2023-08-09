import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/word_selectability_provider.dart';

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
    required this.textFontSize,
    this.onTapUp,
    this.selectable = false,
    this.maxLines = 3,
    this.fontWeight = FontWeight.normal,
  });
  static const Color selectedTextColor = Colors.amber;
  final int maxLines;
  final Color backgroundColor;
  final Color defaultTextColor;
  final double textFontSize;
  final FontWeight fontWeight;

  final OnSubtitleTapped? onTapUp;
  final bool selectable;
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
          return Container(
            color: backgroundColor,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  for (int index = 0; index < words.length; index++) ...[
                    TextSpan(
                      text: '${words[index]} ',
                      recognizer: TapGestureRecognizer()
                        ..onTapUp = (details) {
                          if (selectable) {
                            ref
                                .read(wordSelectabilityProvider)
                                .updateSelectedWordIndex(index);
                          }

                          onTapUp?.call(
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
                        fontWeight: fontWeight,
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
