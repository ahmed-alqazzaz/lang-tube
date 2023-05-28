import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/subtitle_player_model.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/word_selectability_provider.dart';

class SubtitlesPlayer extends ConsumerWidget {
  const SubtitlesPlayer({
    super.key,
    required this.subtitlePlayerProvider,
    required this.onWordTapped,
  });

  static const Color defaultTextColor = Colors.white;
  static const Color selectedTextColor = Colors.deepPurple;
  static const Color backgroungColor = Colors.black;

  final ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider;
  final Function(String word) onWordTapped;

  InlineSpan wordSpan({
    required String word,
    required Function() onTap,
    required Color textColor,
  }) {
    return TextSpan(
      text: '$word ',
      recognizer: TapGestureRecognizer()..onTap = onTap,
      style: TextStyle(
        color: textColor,
        fontSize: 22,
        backgroundColor: backgroungColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(subtitlePlayerProvider).currentVisibleWords;
    final selectedWordIndex =
        ref.watch(wordSelectabilityProvider).selectedWordIndex;
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (int index = 0; index < words.length; index++) ...[
            wordSpan(
              onTap: () => onWordTapped(words[index]),
              word: words[index],
              textColor: selectedWordIndex == index
                  ? selectedTextColor
                  : defaultTextColor,
            )
          ]
        ],
      ),
    );
  }
}
