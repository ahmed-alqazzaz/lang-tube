import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/helpers/loop_controller.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/helpers/subtitle_loop_controller.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../youtube_video_player.dart';
import 'helpers/seek_subtitles_controller.dart';

@immutable
class YoutubePlayerActionsController {
  YoutubePlayerActionsController({
    required this.youtubePlayerController,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required AutoDisposeChangeNotifierProviderRef ref,
    int subtitleLoopCount = 1,
    int customLoopCount = 5,
  })  : _seekSubtitleController = SeekSubtitleController(
          ref: ref,
          subtitlesPlayerProvider: subtitlesPlayerProvider,
          youtubePlayerController: youtubePlayerController,
        ),
        _loopController = YoutubePlayerLoopController(
          youtubePlayerController: youtubePlayerController,
          loopCount: customLoopCount,
        ),
        _subtitleLoopController = SubtitleLoopController(
          ref: ref,
          subtitlesPlayerProvider: subtitlesPlayerProvider,
          loopCount: subtitleLoopCount,
          youtubePlayerController: youtubePlayerController,
        ),
        _rxSharedPreferences = RxSharedPreferences.getInstance();
  final YoutubePlayerController youtubePlayerController;
  final SeekSubtitleController _seekSubtitleController;
  final YoutubePlayerLoopController _loopController;
  final SubtitleLoopController _subtitleLoopController;
  final RxSharedPreferences _rxSharedPreferences;

  Future<void> enableForceHd() async {
    await _rxSharedPreferences.setBool(
      YoutubeVideoPlayerView.sharedPreferencesForceHdKey,
      true,
    );
  }

  Future<void> disableForceHd() async {
    await _rxSharedPreferences.setBool(
      YoutubeVideoPlayerView.sharedPreferencesForceHdKey,
      true,
    );
  }

  void displayMainSettings() {
    throw UnimplementedError();
  }

  void displaySubtitlesSettings() {
    throw UnimplementedError();
  }

  void exit() {
    throw UnimplementedError();
  }

  void setPlayBackSpeed(double speed) =>
      youtubePlayerController.setPlaybackRate(speed);

  void disableSubtitleLoop() async {
    _subtitleLoopController.disable();
    //_subtitleLoopController.disable();
  }

  void enableSubtitleLoop() {
    _subtitleLoopController.enable();
  }

  void seekNextSubtitle() => _seekSubtitleController.seekNextSubtitle();
  void seekPreviousSubtitle() => _seekSubtitleController.seekPreviousSubtitle();

  void enableFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void exitFullScreen() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  void dispose() {
    _subtitleLoopController.dispose();
    _loopController.dispose();
  }
}
