import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/subtitle_player_model.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/word_selectability_provider.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/views/subtitle_box.dart';

class MiniSubtitlesPlayer extends ConsumerWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.subtitlePlayerProvider,
    required this.onWordTapped,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;

  final ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider;
  final Function(String word) onWordTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words =
        ref.watch(subtitlePlayerProvider).currentSubtitle?.words ?? [];
    log('exe $words');
    return SubtitleBox(
      words: words,
      backgroundColor: backgroundColor,
      onWordTapped: onWordTapped,
      textFontSize: textFontSize,
      defaultTextColor: defaultTextColor,
    );
  }
}
