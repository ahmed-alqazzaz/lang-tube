import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/full_screen_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player_view.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'custom/custom_progress_bar.dart';
import 'custom/custom_current_position.dart' as custom_current_position;

void main() {
  runApp(const ProviderScope(child: WebViewer()));
}

class WebViewer extends StatefulWidget {
  const WebViewer({super.key});

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://pub.dev/packages/webview_flutter'),
      );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String videoId = 'x6a4hMyiwBo';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: YoutubeVideoPlayer(videoId: videoId),
      ),
    );
  }
}

class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({super.key, required this.videoId});

  final String videoId;
  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer>
    with WidgetsBindingObserver {
  static const double aspectRatio = 16 / 9;
  static const Color progressBarBufferColor = Color(0xFFCCCCCC);
  static const Color progressBarBackgroungColor = Color(0xFF575350);
  static const Color progressBarPlayedColor = Color(0xFFFF0000);
  static const double progressBarHandleRadius = 7;
  static const double progressBarThickness = 2;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(
          disableDragSeek: true,
          forceHD: true,
          useHybridComposition: false,
          enableCaption: false,
        ))
      ..addListener(() {});
    ReceiveSharingIntent.getTextStream().listen((event) {
      _controller.load(event.split('/').last);
    });
    ReceiveSharingIntent.getInitialText().then((value) {
      if (value != null) {
        _controller.load(value.split('/').last);
      }
    });
    YoutubeExplode()
        .videos
        .streamsClient
        .getManifest('')
        .then((value) => value.muxed.withHighestBitrate());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget player() => YoutubePlayer(
        controller: _controller,
        bottomActions: const [],
        controlsTimeOut: const Duration(days: 6),
      );

  Widget positionIndicator() => custom_current_position.CustomCurrentPosition(
        controller: _controller,
      );

  Widget progressBar() {
    return CustomProgressBar(
      controller: _controller,
      colors: ProgressBarColors(
        handleColor: progressBarPlayedColor,
        playedColor: progressBarPlayedColor,
        bufferedColor: progressBarBufferColor.withOpacity(0.7),
        backgroundColor: progressBarBackgroungColor.withOpacity(0.5),
      ),
      width: progressBarThickness,
      handleRadius: progressBarHandleRadius,
    );
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MediaQuery.of(context).orientation == Orientation.portrait
          ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
          : SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, orientation) {
        late final double width;
        late final double height;
        if (orientation == Orientation.portrait) {
          width = size.width;
          height = width / aspectRatio;
        } else {
          height = size.height - progressBarHandleRadius;
          width = height * aspectRatio;

          return YoutubeVideoPlayerView.fullScreen(
            controller: _controller,
          );
        }

        return Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: SizedBox(
            width: width,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height,
                      child: player(),
                    ),
                    Container(
                      height: progressBarHandleRadius,
                      color: Colors.transparent,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0.1 * height,
                  left: 0.036 * width,
                  child: positionIndicator(),
                ),
                Positioned(
                  bottom: 0.1 * height,
                  right: 0.036 * width,
                  child: const Icon(Icons.fullscreen),
                ),
                Positioned(
                  bottom: 0,
                  left: -progressBarHandleRadius,
                  right: -progressBarHandleRadius,
                  child: progressBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class H extends StatefulWidget {
  const H({super.key});

  @override
  State<H> createState() => _HState();
}

class _HState extends State<H> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class bottomShett extends StatelessWidget {
  const bottomShett({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Timer(const Duration(seconds: 3), () {
        // controller.initial().then((value) =>
        //     print(controller.durationSearch(Duration(seconds: 9))?.data));

        Scaffold.of(context).showBottomSheet(
          (context) {
            return SizedBox(
              width: 411,
              height: 600,
              child: WebViewWidget(
                controller: _controller,
                gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
              ),
            );
          },
        );
      });
      return Container();
    });
  }
}


// LayoutBuilder(
//               builder: (context, constraints) {
//                 return Transform(
//                   transform: Matrix4.identity()..scale(0.5),
//                   alignment: Alignment.centerLeft,
//                   child: Stack(
//                     children: [
//                       SizedBox(
//                         width: constraints.maxWidth,
//                         height: constraints.maxHeight,
//                       ),
//                       if (!controller.flags.hideThumbnail)
//                         AnimatedOpacity(
//                           opacity: controller.value.isPlaying ? 0 : 1,
//                           duration: const Duration(milliseconds: 300),
//                           child: widget.thumbnail ?? _thumbnail,
//                         ),
//                       if (!controller.value.isFullScreen &&
//                           !controller.flags.hideControls &&
//                           controller.value.position >
//                               const Duration(milliseconds: 100) &&
//                           !controller.value.isControlsVisible &&
//                           widget.showVideoProgressIndicator &&
//                           !controller.flags.isLive)
//                         Positioned(
//                           bottom: -7.0,
//                           left: -7.0,
//                           right: -7.0,
//                           child: IgnorePointer(
//                             ignoring: true,
//                             child: ProgressBar(
//                               colors: widget.progressColors.copyWith(
//                                 handleColor: Colors.transparent,
//                               ),
//                             ),
//                           ),
//                         ),
//                       if (!controller.flags.hideControls) ...[
//                         TouchShutter(
//                           disableDragSeek: controller.flags.disableDragSeek,
//                           timeOut: widget.controlsTimeOut,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           child: AnimatedOpacity(
//                             opacity: !controller.flags.hideControls &&
//                                     controller.value.isControlsVisible
//                                 ? 1
//                                 : 0,
//                             duration: const Duration(milliseconds: 300),
//                             child: controller.flags.isLive
//                                 ? LiveBottomBar(
//                                     liveUIColor: widget.liveUIColor,
//                                     showLiveFullscreenButton: widget.controller
//                                         .flags.showLiveFullscreenButton,
//                                   )
//                                 : Padding(
//                                     padding: widget.bottomActions == null
//                                         ? const EdgeInsets.all(0.0)
//                                         : widget.actionsPadding,
//                                     child: Row(
//                                       children: widget.bottomActions ??
//                                           [
//                                             const SizedBox(width: 14.0),
//                                             CurrentPosition(),
//                                             const SizedBox(width: 8.0),
//                                             ProgressBar(
//                                               isExpanded: true,
//                                               colors: widget.progressColors,
//                                             ),
//                                             RemainingDuration(),
//                                             const PlaybackSpeedButton(),
//                                             FullScreenButton(),
//                                           ],
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: AnimatedOpacity(
//                             opacity: !controller.flags.hideControls &&
//                                     controller.value.isControlsVisible
//                                 ? 1
//                                 : 0,
//                             duration: const Duration(milliseconds: 300),
//                             child: Padding(
//                               padding: widget.actionsPadding,
//                               child: Row(
//                                 children: widget.topActions ?? [Container()],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                       if (!controller.flags.hideControls)
//                         Center(
//                           child: PlayPauseButton(),
//                         ),
//                       if (controller.value.hasError) errorWidget,
//                     ],
//                   ),
//                 );
//               },
//             )