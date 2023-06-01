import 'dart:async';
import 'dart:developer';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/utils/subtitle_player_model.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_parser/subtitles_parser.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/full_screen_player.dart/full_screen_youtube_player.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerView extends ConsumerStatefulWidget {
  const YoutubeVideoPlayerView({super.key, required this.videoId});

  final String videoId;
  static const double progressBarHandleRadius = 7;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YoutubeVideoPlayerViewwState();
}

class _YoutubeVideoPlayerViewwState
    extends ConsumerState<YoutubeVideoPlayerView> with WidgetsBindingObserver {
  late final YoutubePlayerController _controller;
  late final FutureProvider<ChangeNotifierProvider<SubtitlePlayerModel>>
      _subtitlesPlayerProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FkUserAgent.init();
    });

    WidgetsBinding.instance.addObserver(this);
    _controller = YoutubePlayerController(initialVideoId: widget.videoId);
    _subtitlesPlayerProvider = FutureProvider(
      (ref) async {
        final userAgent = await FkUserAgent.getPropertyAsync("userAgent");
        final subtitlesScraper = userAgent != null
            ? await SubtitlesScraper.withUserAgent(userAgent)
            : await SubtitlesScraper.withRandomUserAgent();
        return subtitlesScraper
            .getSubtitle(
              youtubeVideoId: widget.videoId,
              languages: (
                mainLanguage: 'german',
                translatedLanguage: 'English'
              ),
            )
            .first
            .then(
              (value) {
                return ChangeNotifierProvider(
                  (ref) => SubtitlePlayerModel(
                    youtubePlayerController: _controller,
                    mainSubtitlesController:
                        SubtitlesController.fromSubtitlesEntry(
                      value.mainLanguageSubtitles,
                    ),
                    translatedSubtitlesController:
                        SubtitlesController.fromSubtitlesEntry(
                      value.translatedSubtitles,
                    ),
                  ),
                );
              },
            );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    FkUserAgent.release();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.pause();
      Timer(const Duration(milliseconds: 1500), () {
        _controller.play();
      });
      MediaQuery.of(context).orientation == Orientation.portrait
          ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
          : SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return PortraitYoutubePlayer(
              controller: _controller,
              subtitlesPlayerProvider: _subtitlesPlayerProvider,
            );
          }
          return FullScreenYoutubeVideoPlayer(
            controller: _controller,
            subtitlesPlayerProvider: _subtitlesPlayerProvider,
          );
        },
      ),
    );
  }
}
