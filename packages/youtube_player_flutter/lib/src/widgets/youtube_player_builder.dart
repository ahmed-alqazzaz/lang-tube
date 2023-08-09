import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A wrapper for [YoutubePlayer].
class YoutubePlayerBuilder extends StatefulWidget {
  /// The actual [YoutubePlayer].
  final YoutubePlayer player;

  /// Builds the widget below this [builder].
  final Widget Function(BuildContext, Widget) builder;

  /// Callback to notify that the player has entered fullscreen.
  final VoidCallback? onEnterFullScreen;

  /// Callback to notify that the player has exited fullscreen.
  final VoidCallback? onExitFullScreen;

  /// Builder for [YoutubePlayer] that supports switching between fullscreen and normal mode.
  const YoutubePlayerBuilder({
    Key? key,
    required this.player,
    required this.builder,
    this.onEnterFullScreen,
    this.onExitFullScreen,
  }) : super(key: key);

  @override
  State<YoutubePlayerBuilder> createState() => _YoutubePlayerBuilderState();
}

class _YoutubePlayerBuilderState extends State<YoutubePlayerBuilder>
    with WidgetsBindingObserver {
  final GlobalKey playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      widget.onEnterFullScreen?.call();
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      widget.onExitFullScreen?.call();
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final player = Container(
      key: playerKey,
      child: widget.player,
    );
    return widget.builder(context, player);
  }
}
