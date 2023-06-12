import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/custom/widgets/youtube_player_widgets/custom_progress_bar.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: MyWidget(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return YoutubeVideoPlayerView(videoId: controller.text);
                },
              ), (route) {
                return false;
              });
            },
            child: const Text('submit'),
          )
        ],
      ),
    );
  }
}
