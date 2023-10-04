import 'package:bottom_tabbed_navigator/bottom_tabbed_navigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lang_tube/browser/webview.dart';
import 'package:lang_tube/video_recommendations.dart/video_recommendations_view.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';

import '../history/history_view.dart';
part 'routes.g.dart';

@TypedGoRoute<HomeScreenRoute>(path: '/', routes: [
  TypedGoRoute<YoutubePlayerRoute>(
    path: 'youtube_player/:id',
  )
])
@immutable
class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => TabbedNavigator(
        keepAlive: true,
        items: const [
          TabNavigationItem(
            page: VideoRecommendationsView(),
            bottomNavigationBarItem: BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
          ),
          TabNavigationItem(
            page: BrowserWebview(),
            bottomNavigationBarItem: BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chrome),
              label: "Browser",
            ),
          ),
          TabNavigationItem(
            page: HistoryView(),
            bottomNavigationBarItem: BottomNavigationBarItem(
              icon: Icon(Icons.video_library_rounded),
              label: "Library",
            ),
          ),
        ],
      );
}

@immutable
class YoutubePlayerRoute extends GoRouteData {
  const YoutubePlayerRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      YoutubeVideoPlayerView(videoId: id.toString());

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      child: YoutubeVideoPlayerView(videoId: id.toString()),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define a Tween that animates from bottom to top and vice versa
        final tween = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        // Use a SlideTransition widget to apply the Tween to the child
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
