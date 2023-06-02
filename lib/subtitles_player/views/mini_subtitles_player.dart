import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/utils/subtitle_player_model.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';

class MiniSubtitlesPlayer extends ConsumerWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.subtitlePlayerProvider,
    required this.onTap,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;

  final ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider;
  final OnSubtitleTapped onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref
            .watch(subtitlePlayerProvider)
            .mainSubtitlesController
            .currentSubtitle
            ?.words ??
        [];
    return SubtitleBox(
      words: words,
      backgroundColor: backgroundColor,
      onTap: onTap,
      textFontSize: textFontSize,
      defaultTextColor: defaultTextColor,
    );
  }
}
