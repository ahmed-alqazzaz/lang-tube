import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/custom/custom_progress_bar.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'custom/custom_progress_bar2.dart' as custom;

void main() {
  runApp(
    const MaterialApp(
      home: YoutubePlayerWithStutteringProgressBarExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class YoutubePlayerWithStutteringProgressBarExample extends StatefulWidget {
  const YoutubePlayerWithStutteringProgressBarExample({super.key});

  @override
  State<YoutubePlayerWithStutteringProgressBarExample> createState() =>
      _YoutubePlayerWithStutteringProgressBarExampleState();
}

class _YoutubePlayerWithStutteringProgressBarExampleState
    extends State<YoutubePlayerWithStutteringProgressBarExample> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(initialVideoId: 'q1fsBWLpYW4')
      ..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressBar;
    return SafeArea(
      child: Scaffold(
        body: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: controller),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return YoutubeVideoPlayerView(videoId: controller.text);
                  },
                ));
              },
              child: const Text('submit'))
        ],
      ),
    );
  }
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
    ReceiveSharingIntent.getTextStream().listen((event) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          log('built');
          return Scaffold(
            body: YoutubeVideoPlayerView(videoId: videoId),
          );
        },
      ));
      // log(event.split('/').last);
      // setState(() {
      //   videoId = event.split('/').last;
      // });
    });
    ReceiveSharingIntent.getInitialText().then((value) {
      if (value != null) {
        log('built');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: YoutubeVideoPlayerView(videoId: videoId),
            );
          },
        ));
        // log(value.split('/').last);
        // setState(() {
        //   videoId = value.split('/').last;
        // });
      }
    });
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

  String videoId = 'wEWNY8G1n40';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubeVideoPlayerView(videoId: videoId),
    );
  }
}

class WordExplanationModal extends StatelessWidget {
  static const double _width = double.infinity;
  static const double _height = double.infinity;
  WordExplanationModal({super.key, required String word})
      : _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
                'https://www.linguee.de/deutsch-englisch/uebersetzung/$word.html'),
          );
  final WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return WebViewWidget(
            controller: _controller,
            gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
          );
        },
      ),
    );
  }
}
