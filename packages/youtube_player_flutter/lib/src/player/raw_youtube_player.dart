// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_flutter/src/enums/video_quality.dart';

import '../enums/player_state.dart';
import '../utils/youtube_meta_data.dart';
import '../utils/youtube_player_controller.dart';

/// A raw youtube player widget which interacts with the underlying webview inorder to play YouTube videos.
///
/// Use [YoutubePlayer] instead.
class RawYoutubePlayer extends StatefulWidget {
  /// Sets [Key] as an identification to underlying web view associated to the player.
  final Key? key;

  static const widthScalingFactor = 1.0;

  /// {@macro youtube_player_flutter.onEnded}
  final void Function(YoutubeMetaData metaData)? onEnded;

  /// Creates a [RawYoutubePlayer] widget.
  RawYoutubePlayer({
    this.key,
    this.onEnded,
  });

  @override
  _RawYoutubePlayerState createState() => _RawYoutubePlayerState();
}

class _RawYoutubePlayerState extends State<RawYoutubePlayer>
    with WidgetsBindingObserver {
  YoutubePlayerController? controller;
  PlayerState? _cachedPlayerState;
  bool _isPlayerReady = false;
  bool _onLoadStopCalled = false;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_cachedPlayerState != null &&
            _cachedPlayerState == PlayerState.playing) {
          controller?.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cachedPlayerState = controller!.value.playerState;
        controller?.pause();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = YoutubePlayerController.of(context);
    return InAppWebView(
      key: widget.key,
      initialData: initialData,
      initialOptions: initialOptions,
      onConsoleMessage: consoleMessageListener,
      onWebViewCreated: webviewCreationListener,
      onLoadStop: webviewLoadStopListener,
    );
  }

  void webviewLoadStopListener(_, __) {
    _onLoadStopCalled = true;
    if (_isPlayerReady) {
      controller!.updateValue(
        controller!.value.copyWith(isReady: true),
      );
    }
  }

  void webviewCreationListener(webController) async {
    await injectJavaScript(webController);
    controller!.updateValue(
      controller!.value.copyWith(webViewController: webController),
    );
    injectJavaScriptHandlers(webController);
  }

  void consoleMessageListener(webController, consoleMessage) async {
    log(consoleMessage.message);
    videoQualityErrorListener(consoleMessage.message);
  }

  InAppWebViewGroupOptions get initialOptions {
    return InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        userAgent: userAgent,
        mediaPlaybackRequiresUserGesture: false,
        transparentBackground: true,
        disableContextMenu: true,
        supportZoom: false,
        disableHorizontalScroll: false,
        disableVerticalScroll: false,
        useShouldOverrideUrlLoading: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        allowsAirPlayForMediaPlayback: true,
        allowsPictureInPictureMediaPlayback: true,
      ),
      android: AndroidInAppWebViewOptions(
        useWideViewPort: false,
        useHybridComposition: controller!.flags.useHybridComposition,
      ),
    );
  }

  InAppWebViewInitialData get initialData {
    return InAppWebViewInitialData(
      data: player,
      baseUrl: Uri.parse('https://www.youtube.com'),
      encoding: 'utf-8',
      mimeType: 'text/html',
    );
  }

  void videoQualityErrorListener(String message) {
    if (message.contains('Quality unavailable')) {
      throttler(Duration(milliseconds: 1700), () {
        final qualities = qualityToString.values.toList();
        final requestedQuality = message.split(' ').last;
        final requestedQualityIndex = qualities.indexOf(requestedQuality);
        final alternativeQuality = qualities[requestedQualityIndex - 1];
        log('Requested quality $requestedQuality is unavailable');
        log('Changing quality to $alternativeQuality');
        controller!.setVideoQuality(stringToQuality[alternativeQuality]!);
      });
    }
  }

  Future<void> injectJavaScript(InAppWebViewController webController) async {
    const jsAssetPath =
        'packages/youtube_player_flutter/web_assets/youtube_player.js';
    await webController.evaluateJavascript(
      source: await rootBundle.loadString(jsAssetPath).then(
            (jsString) => jsString
                .replaceAll('VIDEO_ID', controller!.initialVideoId)
                .replaceAll("'CC_LOAD_POLICY'",
                    boolean(value: controller!.flags.enableCaption))
                .replaceAll('CC_LANG_PREF', controller!.flags.captionLanguage)
                .replaceAll(
                    "'AUTOPLAY'", boolean(value: controller!.flags.autoPlay))
                .replaceAll("'START'", controller!.flags.startAt.toString())
                .replaceAll("'END'", controller!.flags.endAt.toString()),
          ),
    );
  }

  void injectJavaScriptHandlers(InAppWebViewController webController) {
    webController
      ..addJavaScriptHandler(
        handlerName: 'Ready',
        callback: (_) {
          _isPlayerReady = true;
          if (_onLoadStopCalled) {
            controller!.updateValue(
              controller!.value.copyWith(isReady: true),
            );
          }
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'StateChange',
        callback: (args) {
          switch (args.first as int) {
            case -1:
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.unStarted,
                  isLoaded: true,
                ),
              );
              break;
            case 0:
              widget.onEnded?.call(controller!.metadata);
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.ended,
                ),
              );
              break;
            case 1:
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.playing,
                  isPlaying: true,
                  hasPlayed: true,
                  errorCode: 0,
                ),
              );
              break;
            case 2:
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.paused,
                  isPlaying: false,
                ),
              );
              break;
            case 3:
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.buffering,
                ),
              );
              break;
            case 5:
              controller!.updateValue(
                controller!.value.copyWith(
                  playerState: PlayerState.cued,
                ),
              );
              break;
            default:
              throw Exception("Invalid player state obtained.");
          }
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'PlaybackQualityChange',
        callback: (args) {
          controller!.updateValue(
            controller!.value.copyWith(playbackQuality: args.first as String),
          );
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'PlaybackRateChange',
        callback: (args) {
          final num rate = args.first;
          controller!.updateValue(
            controller!.value.copyWith(playbackRate: rate.toDouble()),
          );
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'Errors',
        callback: (args) {
          controller!.updateValue(
            controller!.value.copyWith(errorCode: int.parse(args.first)),
          );
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'VideoData',
        callback: (args) {
          controller!.updateValue(
            controller!.value
                .copyWith(metaData: YoutubeMetaData.fromRawData(args.first)),
          );
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'VideoTime',
        callback: (args) {
          final position = args.first * 1000;
          final num buffered = args.last;
          controller!.updateValue(
            controller!.value.copyWith(
              position: Duration(milliseconds: position.floor()),
              buffered: buffered.toDouble(),
            ),
          );
        },
      );
  }

  String get player => '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
                pointer-events: auto;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
     <script></script>
    <body>
        <div id="player"></div>
        
    </body>
    </html>
  ''';

  String boolean({required bool value}) => value == true ? "1" : "0";

  String get userAgent => controller!.flags.forceHD
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : '';
}

Timer? _timer;
void throttler(Duration timeout, void Function() callback) {
  _timer?.cancel();
  _timer = Timer(timeout, callback);
}
