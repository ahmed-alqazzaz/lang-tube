
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';

class MiniSubtitlesPlayer extends ConsumerStatefulWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.subtitlesPlayerProvider,
    required this.onTap,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;
  final SubtitlesPlayerProvider subtitlesPlayerProvider;
  final OnSubtitleTapped onTap;

  @override
  ConsumerState<MiniSubtitlesPlayer> createState() =>
      _MiniSubtitlesPlayerState();
}

class _MiniSubtitlesPlayerState extends ConsumerState<MiniSubtitlesPlayer> {
  @override
  Widget build(BuildContext context) {
    final currentMainSubtitle = ref.watch(widget.subtitlesPlayerProvider
        .select((model) => model.mainSubtitlesController.currentSubtitle));

    return SubtitleBox(
      words: currentMainSubtitle?.words ?? [],
      backgroundColor: MiniSubtitlesPlayer.backgroundColor,
      onTapUp: widget.onTap,
      textFontSize: MiniSubtitlesPlayer.textFontSize,
      defaultTextColor: MiniSubtitlesPlayer.defaultTextColor,
    );
  }
}
