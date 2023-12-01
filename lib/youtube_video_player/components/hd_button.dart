import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/hd_provider.dart';

class YoutubeHdButton extends ConsumerWidget {
  const YoutubeHdButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = Theme.of(context).iconTheme.size!;
    final isHd = ref.watch(youtubeHdProvider);
    final youtubeHdNotifier = ref.read(youtubeHdProvider.notifier);
    return CircularInkWell(
      splashRadius: 8,
      child: Icon(
        Icons.hd_rounded,
        size: iconSize - 3,
        color: isHd ? Colors.amber.shade600 : Colors.white,
      ),
      onTap: () =>
          isHd ? youtubeHdNotifier.disableHd() : youtubeHdNotifier.forceHd(),
    );
  }
}
