import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/multi_subtitles_player_provider/provider.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/full_screen_player.dart/full_screen_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_youtube_player.dart';
import 'package:languages/language_utils.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../subtitles_player/providers/subtitles_scraper_provider/data/subtitles_bundle.dart';
import '../subtitles_player/providers/subtitles_scraper_provider/subtitles_scraper_provider.dart';
import 'actions/actions_provider.dart';

class Tmp extends ConsumerWidget {
  const Tmp(this.videoId, {super.key});
  final String videoId;

  @override
  Widget build(BuildContext context, ref) {
    return FutureBuilder(
      future: ref.read(subtitlesScraperProvider.future).then(
            (scraper) => scraper.fetchSubtitlesBundle(
              youtubeVideoId: videoId,
              mainLanguage: Language.english(),
              translatedLanguage: Language.arabic(),
            ),
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
  late final MultiSubtitlesPlayerProvider _multiSubtitlesPlayerProvider;
  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(enableCaption: false),
    );
    _multiSubtitlesPlayerProvider = multiSubtitlesPlayerProvider((
      mainSubtitles: widget.subtitles.mainSubtitles.first.subtitles.toList(),
      translatedSubtitles:
          widget.subtitles.translatedSubtitles.first.subtitles.toList(),
      playbackPosition:
          _youtubePlayerController.syncMap((value) => value.position)
    ));

    _actionsProvider = youtubePlayerActionsProvider((
      youtubePlayerController: _youtubePlayerController,
      multiSubtitlesPlayerProvider: _multiSubtitlesPlayerProvider,
    ));

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      child: Scaffold(
        body: YoutubePlayerBuilder(
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
                    multiSubtitlesPlayerProvider: _multiSubtitlesPlayerProvider,
                    youtubePlayerController: _youtubePlayerController,
                  );
                }
                return FullScreenYoutubeVideoPlayer(
                  player: player,
                  actionsProvider: _actionsProvider,
                  multiSubtitlesPlayerProvider: _multiSubtitlesPlayerProvider,
                  youtubePlayerController: _youtubePlayerController,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
