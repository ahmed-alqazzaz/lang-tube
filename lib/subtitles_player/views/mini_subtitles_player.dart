import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_player_provider.dart/provider.dart';

import '../providers/multi_subtitles_player_provider/provider.dart';

class MiniSubtitlesPlayer extends ConsumerStatefulWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.onTap,
    required this.maxLines,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;
  final OnSubtitleTapped onTap;
  final int maxLines;
  @override
  ConsumerState<MiniSubtitlesPlayer> createState() =>
      _MiniSubtitlesPlayerState();
}

class _MiniSubtitlesPlayerState extends ConsumerState<MiniSubtitlesPlayer> {
  @override
  Widget build(BuildContext context) {
    final subtitlesPlayerValue = ref.watch(subtitlesPlayerProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SubtitleBox(
          words:
              subtitlesPlayerValue.currentSubtitles.mainSubtitle?.words ?? [],
          backgroundColor: MiniSubtitlesPlayer.backgroundColor,
          onTapUp: widget.onTap,
          textFontSize: MiniSubtitlesPlayer.textFontSize,
          defaultTextColor: MiniSubtitlesPlayer.defaultTextColor,
          maxLines: widget.maxLines,
        ),
        if (subtitlesPlayerValue.currentSubtitles.translatedSubtitle !=
            null) ...[
          const SizedBox(height: 5),
          SubtitleBox(
            words:
                subtitlesPlayerValue.currentSubtitles.translatedSubtitle!.words,
            backgroundColor: MiniSubtitlesPlayer.backgroundColor,
            onTapUp: widget.onTap,
            textFontSize: MiniSubtitlesPlayer.textFontSize,
            defaultTextColor: Colors.amber.shade600,
            maxLines: widget.maxLines,
          ),
        ]
      ],
    );
  }
}
