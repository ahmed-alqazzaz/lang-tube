import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
import 'package:lang_tube/youtube_video_player/actions/action_providers/loop_providers/subtitle_loop_provider.dart/notifier.dart';
import 'package:lang_tube/youtube_video_player/components/actions_circular_menu.dart';
import 'package:lang_tube/youtube_video_player/actions/views/portrait_screen_actions/bottom_actions_bar.dart';
import 'package:lang_tube/youtube_video_player/actions/views/portrait_screen_actions/mini_player_actions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../action_providers/loop_providers/subtitle_loop_provider.dart/provider.dart';
import '../action_providers/youtube_hd_provider/provider.dart';
import 'full_screen_actions/full_screen_player_actions.dart';
import 'generic_actions.dart';

@immutable
class YoutubePlayerActions {
  YoutubePlayerActions({
    required YoutubePlayerController youtubePlayerController,
    required CurrentSubtitleGetter currentSubtitleGetter,
    required Widget subtitlesSettings,
  })  : _youtubePlayerController = youtubePlayerController,
        _customLoopProvider = customLoopProviderFamily(youtubePlayerController),
        _subtitleLoopProvider = subtitleLoopProviderFamily((
          youtubePlayerController: youtubePlayerController,
          currentSubtitleGetter: currentSubtitleGetter,
          loopCount: 1
        )),
        _subtitlesSettings = subtitlesSettings;

  FullScreenPlayerActions fullScreenActions() => FullScreenPlayerActions(
        genericActions: _genericActions,
        subtitleLoopProvider: _subtitleLoopProvider,
      );
  Widget miniPlayerActions() => MiniPlayerActions(actions: _genericActions);

  BottomActionsBar bottomActionsBarBuilder() => BottomActionsBar(
        subtitlesSettings: _subtitlesSettings,
        genericActions: _genericActions,
      );

  ActionsCircularMenu actionsCircularMenuBuilder(
          {required void Function() onActionsMenuToggled}) =>
      ActionsCircularMenu(
        onActionsMenuToggled: onActionsMenuToggled,
        youtubePlayerController: _youtubePlayerController,
        subtitleLoopProvider: _subtitleLoopProvider,
      );
  Widget progressBar() => _genericActions.progressBar();

  final YoutubePlayerController _youtubePlayerController;
  final CustomLoopProvider _customLoopProvider;
  final SubtitleLoopProvider _subtitleLoopProvider;
  final Widget _subtitlesSettings;

  late final YoutubePlayerGenericActions _genericActions =
      YoutubePlayerGenericActions(
    youtubePlayerController: _youtubePlayerController,
    customLoopProvider: _customLoopProvider,
    subtitleLoopProvider: _subtitleLoopProvider,
  );
}
