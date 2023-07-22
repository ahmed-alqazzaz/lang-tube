import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/full_screen_player.dart/full_screen_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/portrait_player/portrait_youtube_player.dart';
import 'package:lang_tube/youtube_video_player/youtube_player_model/youtube_player_provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../custom/widgets/youtube_player_widgets/custom_youtube_player_builder.dart';

class YoutubeVideoPlayerView extends ConsumerStatefulWidget {
  const YoutubeVideoPlayerView({
    super.key,
    required this.videoId,
  });
  final String videoId;

  static const double progressBarHandleRadius = 7;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YoutubeVideoPlayerViewState();
}

class _YoutubeVideoPlayerViewState
    extends ConsumerState<YoutubeVideoPlayerView> {
  late final rxSharedPreferences = RxSharedPreferences.getInstance();
  @override
  void initState() {
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FkUserAgent.release();

    super.dispose();
  }

  late final _controller =
      YoutubePlayerController(initialVideoId: widget.videoId);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: OrientationBuilder(
    //     builder: (context, orientation) {
    //       return CustomYoutubePlayerBuilder(
    //         player: YoutubePlayer(
    //           controller: _controller,
    //         ),
    //         builder: (context, child) {
    //           if (orientation == Orientation.portrait) {
    //             return Column(
    //               children: [
    //                 child,
    //               ],
    //             );
    //           }
    //           return child;
    //         },
    //       );
    //     },
    //   ),
    // );

    return FutureBuilder(
      future: RxSharedPreferences.getInstance()
          .getBool(YoutubePlayerModel.sharedPreferencesForceHdKey),
      builder: (context, snapshot) {
        final sharedPreferencesForceHd = snapshot.data ?? false;
        return Consumer(
          builder: (context, ref, _) => adaptiveYoutubePlayer(
            youtubePlayerModel: ref.watch(
              youtubePlayerProviderFamily(
                (
                  shouldForceHd: sharedPreferencesForceHd,
                  videoId: widget.videoId
                ),
              ),
            ),
            key: UniqueKey(),
          ),
        );
      },
    );
  }

  Widget adaptiveYoutubePlayer({
    required YoutubePlayerModel youtubePlayerModel,
    required Key key,
  }) {
    return Scaffold(
      key: key,
      body: CustomYoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: youtubePlayerModel.youtubePlayerController,
          bottomActions: const [],
          topActions: const [],
        ),
        builder: (context, player) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return PortraitYoutubePlayer(
                    youtubePlayerModel: youtubePlayerModel, player: player);
              }
              return FullScreenYoutubeVideoPlayer(
                  player: player, youtubePlayerModel: youtubePlayerModel);
            },
          );
        },
      ),
    );
  }
}

class Player2 extends StatefulWidget {
  const Player2({
    super.key,
    required YoutubePlayerController controller,
  }) : _controller = controller;

  final YoutubePlayerController _controller;

  @override
  State<Player2> createState() => _Player2State();
}

class _Player2State extends State<Player2> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return YoutubePlayer(controller: widget._controller, key: Key('1'));
  }

  @override
  bool get wantKeepAlive => true;
}

class Player1 extends StatefulWidget {
  const Player1({
    super.key,
    required YoutubePlayerController controller,
  }) : _controller = controller;

  final YoutubePlayerController _controller;

  @override
  State<Player1> createState() => _Player1State();
}

class _Player1State extends State<Player1> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        YoutubePlayer(
          controller: widget._controller,
          key: const Key('1'),
        ),
        const Text('hhh'),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
