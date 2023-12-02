import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/playback_speed_provider.dart';

class PlaybackSpeedButton extends ConsumerWidget {
  const PlaybackSpeedButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackSpeedNotifier =
        ref.read(youtubePlaybackSpeedProvider.notifier);
    final speed = ref.watch(youtubePlaybackSpeedProvider).toString();
    return Transform.translate(
      offset: Offset(speed.length == 4 ? 0 : -6, 0),
      child: CircularInkWell(
        onTap: () => playbackSpeedNotifier.seekNext(),
        splashRadius: splashRadius,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: speed,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              const TextSpan(
                text: 'x',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return const Placeholder();
  }
}
