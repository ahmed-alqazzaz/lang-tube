import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/youtube_controller_provider.dart';

class CustomPositionIndicator extends ConsumerStatefulWidget {
  const CustomPositionIndicator({super.key, required this.padding});

  final double padding;
  @override
  ConsumerState<CustomPositionIndicator> createState() =>
      _CustomPositionIndicatorState();
}

class _CustomPositionIndicatorState
    extends ConsumerState<CustomPositionIndicator> {
  PositionIndicatorValue indicatorValue =
      PositionIndicatorValue.currentPosition;
  @override
  Widget build(BuildContext context) {
    final youtubePlayerController = ref.watch(youtubeControllerProvider);
    return GestureDetector(
      onTap: () => setState(
        () => indicatorValue =
            indicatorValue == PositionIndicatorValue.currentPosition
                ? PositionIndicatorValue.remainingPosition
                : PositionIndicatorValue.currentPosition,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: PositionIndicator(
                  controller: youtubePlayerController,
                  positionValue: indicatorValue,
                ),
              ),
              const TextSpan(text: ' / '),
              WidgetSpan(
                child: PositionIndicator(
                  controller: youtubePlayerController,
                  positionValue: PositionIndicatorValue.videoDuration,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
