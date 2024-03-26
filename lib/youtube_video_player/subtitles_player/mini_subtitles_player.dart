import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../explanation_modal/explanation_modal.dart';
import '../components/subtitle_box.dart';
import '../providers/subtitles_player_provider.dart';
import '../providers/youtube_controller_provider.dart';

class MiniSubtitlesPlayer extends ConsumerStatefulWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.maxLines,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;
  final int maxLines;
  @override
  ConsumerState<MiniSubtitlesPlayer> createState() =>
      _MiniSubtitlesPlayerState();
}

class _MiniSubtitlesPlayerState extends ConsumerState<MiniSubtitlesPlayer> {
  void _onTap({required String word, required VoidCallback reset}) {
    final controller = ref.read(youtubeControllerProvider);
    controller.pause();
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        barrierColor: Colors.black12,
        isScrollControlled: true,
        builder: (context) {
          return ExplanationModalSheet(
            word: word.replaceAll(RegExp(r'[^a-zA-Z]'), ''),
          );
        }).whenComplete(
      () {
        controller.play();
        reset();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitlesPlayerValue = ref.watch(subtitlesPlayerProvider);
    final isMultiLine =
        subtitlesPlayerValue.currentSubtitles.translatedSubtitle != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SubtitleBox(
          words:
              subtitlesPlayerValue.currentSubtitles.mainSubtitle?.words ?? [],
          onTapUp: _onTap,
          textFontSize: MiniSubtitlesPlayer.textFontSize,
          defaultTextColor: MiniSubtitlesPlayer.defaultTextColor,
          maxLines: widget.maxLines,
          margin: EdgeInsets.only(bottom: isMultiLine ? 8 : 0),
        ),
        if (isMultiLine)
          SubtitleBox(
            words:
                subtitlesPlayerValue.currentSubtitles.translatedSubtitle!.words,
            onTapUp: _onTap,
            textFontSize: MiniSubtitlesPlayer.textFontSize,
            defaultTextColor: Colors.amber.shade600,
            maxLines: widget.maxLines,
            margin: EdgeInsets.only(top: isMultiLine ? 2 : 0),
          ),
      ],
    );
  }
}
