import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/custom_loop_provider.dart';

class IframeYoutubePlayer extends ConsumerStatefulWidget {
  const IframeYoutubePlayer({
    super.key,
    required this.videoId,
    this.keepALive = true,
    required this.start,
    required this.end,
  });
  final String videoId;
  final bool keepALive;
  final Duration start;
  final Duration end;
  @override
  ConsumerState<IframeYoutubePlayer> createState() =>
      _IframeYoutubePlayerState();
}

class _IframeYoutubePlayerState extends ConsumerState<IframeYoutubePlayer>
    with AutomaticKeepAliveClientMixin {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        hideControls: true,
        hideNativeControls: false,
        hideNativeHeader: false,
        enableCaption: false,
        loop: true,
        autoPlay: false,
      ),
    )..addListener(_onPlay);
    super.initState();
  }

  void _onPlay() {
    final isLoopActive = ref.read(customLoopProvider) != null;

    if (_controller.value.isPlaying && !isLoopActive) {
      ref.read(customLoopProvider.notifier).activateLoop(
            start: widget.start,
            end: widget.end,
          );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlay);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return YoutubePlayerBuilder(
      key: widget.key,
      player: YoutubePlayer(
        useIframe: true,
        key: widget.key,
        controller: _controller,
        onReady: () {},
      ),
      builder: (context, player) => player,
    );
  }

  @override
  bool get wantKeepAlive => widget.keepALive;
}
