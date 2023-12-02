import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:clipped_icon/clipped_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/custom_loop_provider.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';

class YoutubeCustomLoopButton extends ConsumerStatefulWidget {
  const YoutubeCustomLoopButton({super.key, this.splashRadius = 8});

  final double splashRadius;
  @override
  ConsumerState<YoutubeCustomLoopButton> createState() =>
      _YoutubeCustomLoopButtonState();
}

class _YoutubeCustomLoopButtonState
    extends ConsumerState<YoutubeCustomLoopButton> {
  Duration? _loopStart;
  CustomLoopState state = CustomLoopState.inactive;

  void _onTap() {
    final youtubePlayerController = ref.read(youtubeControllerProvider);
    final loopNotifier = ref.read(customLoopProvider.notifier);
    switch (state) {
      case CustomLoopState.inactive:
        _loopStart = youtubePlayerController!.value.position;
        setState(() => state = CustomLoopState.activating);
        break;
      case CustomLoopState.activating:
        final loopEnd = youtubePlayerController!.value.position;
        loopNotifier.activateLoop(start: _loopStart!, end: loopEnd);
        setState(() => state = CustomLoopState.active);
        break;
      case CustomLoopState.active:
        _loopStart = null;
        loopNotifier.deactivateLoop();
        setState(() => state = CustomLoopState.inactive);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = Theme.of(context).iconTheme.size!;
    return CircularInkWell(
      onTap: _onTap,
      splashRadius: widget.splashRadius,
      child: Stack(
        children: [
          const SizedBox(height: 30, width: 30),
          Positioned(
            top: 0,
            child: ClippedIcon(
              clipDirection: ClipDirection.top,
              height: iconSize / 2,
              icon: Icon(
                Icons.repeat,
                color: state == CustomLoopState.active
                    ? Colors.amber.shade600
                    : Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClippedIcon(
              clipDirection: ClipDirection.bottom,
              height: iconSize / 2,
              icon: Icon(
                Icons.repeat,
                color: state == CustomLoopState.inactive
                    ? Colors.white
                    : Colors.amber.shade600,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'A',
                      style: TextStyle(
                        color: state == CustomLoopState.inactive
                            ? Colors.white
                            : Colors.amber.shade600,
                        fontSize: 8,
                      ),
                    ),
                    TextSpan(
                      text: 'B',
                      style: TextStyle(
                        color: state == CustomLoopState.active
                            ? Colors.amber.shade600
                            : Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum CustomLoopState {
  inactive,
  activating,
  active,
}
