import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  late final _loopProvider = customLoopProviderFamily(_controller);
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
    final isLoopActive = ref.read(_loopProvider) != null;

    if (_controller.value.isPlaying && !isLoopActive) {
      ref.read(_loopProvider.notifier).activateLoop(
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
