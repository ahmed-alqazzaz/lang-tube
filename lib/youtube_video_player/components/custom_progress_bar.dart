import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/youtube_player/loop.dart';
import 'package:lang_tube/youtube_video_player/providers/custom_loop_provider.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitle_loop_provider.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomProgressBar extends ConsumerStatefulWidget {
  const CustomProgressBar({super.key});

  @override
  ConsumerState<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends ConsumerState<CustomProgressBar> {
  CustomProgress? customProgressGenerator({
    required Loop loop,
    required Color color,
  }) {
    final controler = ref.watch(youtubeControllerProvider)!;
    return CustomProgress(
      start: loop.start.inMilliseconds /
          controler.value.metaData.duration.inMilliseconds,
      end: loop.end.inMilliseconds /
          controler.value.metaData.duration.inMilliseconds,
      color: Colors.amber.shade600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitlesLoopStream =
        ref.read(subtitleLoopProvider.notifier).stream.startWith(null);
    final customLoopStream =
        ref.read(customLoopProvider.notifier).stream.startWith(null);

    return ProgressBar(
      controller: ref.watch(youtubeControllerProvider),
      customProgress: Rx.combineLatestList([
        subtitlesLoopStream.asyncMap(
          (loop) => loop != null
              ? customProgressGenerator(
                  loop: loop,
                  color: progressBarSubtitleLoopColor,
                )
              : null,
        ),
        customLoopStream.asyncMap(
          (loop) => loop != null
              ? customProgressGenerator(
                  loop: loop,
                  color: progressBarCustomLoopColor,
                )
              : null,
        ),
      ]),
      colors: ProgressBarColors(
        handleColor: progressBarPlayedColor,
        playedColor: progressBarPlayedColor,
        bufferedColor: progressBarBufferColor.withOpacity(0.7),
        backgroundColor: progressBarBackgroungColor.withOpacity(0.5),
      ),
    );
  }

  static const Color progressBarBackgroungColor =
      Color.fromARGB(255, 156, 156, 156);
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const Color progressBarSubtitleLoopColor = Colors.amber;
  static const Color progressBarCustomLoopColor = Colors.amber;
  static const double progressBarThickness = 2;
}
