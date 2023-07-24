import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_fetch_provider.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/full_screen_player.dart/full_screen_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/youtube_player_model/youtube_player_provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../custom/widgets/youtube_player_widgets/custom_youtube_player_builder.dart';
import '../subtitles_player/providers/subtitle_player_provider.dart';
import '../subtitles_player/utils/subtitles_parser/subtitles_scraper/data/data_classes.dart';
import 'actions/actions_provider.dart';

class Tmp extends ConsumerWidget {
  const Tmp(this.videoId, {super.key});
  final String videoId;
  @override
  Widget build(BuildContext context, ref) {
    return FutureBuilder(
      future: ref.read(
        subtitlesFetchProviderFamily((
          videoId: videoId,
          mainLanguage: 'english',
          translatedLanguage: 'arabic',
        )).future,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return YoutubeVideoPlayerView(
            videoId: videoId,
            subtitles: snapshot.data!,
          );
        }
        return Container();
      },
    );
  }
}

class YoutubeVideoPlayerView extends ConsumerStatefulWidget {
  const YoutubeVideoPlayerView({
    super.key,
    required this.videoId,
    required this.subtitles,
  });
  final String videoId;
  final SubtitlesBundle subtitles;
  static const double progressBarHandleRadius = 7;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YoutubeVideoPlayerViewState();
}

class _YoutubeVideoPlayerViewState
    extends ConsumerState<YoutubeVideoPlayerView> {
  late final rxSharedPreferences = RxSharedPreferences.getInstance();
  late final YoutubePlayerController _youtubePlayerController;
  late final YoutubePlayerActionsProvider _actionsProvider;
  late final SubtitlesPlayerProvider _subtitlesPlayerProvider;
  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(enableCaption: false),
    );
    _subtitlesPlayerProvider = subtitlesPlayerProviderBuilder(
      youtubePlayerController: _youtubePlayerController,
      mainSubtitlesController: SubtitlesController.fromSubtitlesEntry(
        widget.subtitles.mainSubtitles,
      ),
      translatedSubtitlesController: SubtitlesController.fromSubtitlesEntry(
        widget.subtitles.translatedSubtitles,
      ),
    );
    _actionsProvider = youtubePlayerActionsProvider((
      youtubePlayerController: _youtubePlayerController,
      subtitlesPlayerProvider: _subtitlesPlayerProvider,
    ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FkUserAgent.init();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([]);
    Timer(const Duration(seconds: 2), () async {
      await Connectivity().checkConnectivity().then((value) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value.toString(),
            ),
          ),
        );
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FkUserAgent.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomYoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubePlayerController,
          bottomActions: const [],
          topActions: const [],
        ),
        builder: (context, player) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return PortraitYoutubePlayer(
                  player: player,
                  actionsProvider: _actionsProvider,
                  subtitlesPlayerProvider: _subtitlesPlayerProvider,
                  youtubePlayerController: _youtubePlayerController,
                );
              }
              return FullScreenYoutubeVideoPlayer(
                player: player,
                actionsProvider: _actionsProvider,
                subtitlesPlayerProvider: _subtitlesPlayerProvider,
                youtubePlayerController: _youtubePlayerController,
              );
            },
          );
        },
      ),
    );
  }
}
