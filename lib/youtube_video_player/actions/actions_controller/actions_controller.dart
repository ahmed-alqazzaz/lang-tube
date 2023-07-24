import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/utils/loop_controllers/raw_loop_controller.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_controller/utils/loop_controllers/subtitle_loop_controller.dart';
import 'package:lang_tube/youtube_video_player/youtube_player_model/youtube_player_provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'utils/seek_subtitles_controller.dart';

@immutable
class YoutubePlayerActionsController {
  YoutubePlayerActionsController({
    required this.youtubePlayerController,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required AutoDisposeChangeNotifierProviderRef ref,
    int subtitleLoopCount = 1,
    int customLoopCount = 5,
  })  : _seekSubtitleController = SubtitlesSeekController(
          ref: ref,
          subtitlesPlayerProvider: subtitlesPlayerProvider,
          youtubePlayerController: youtubePlayerController,
        ),
        _loopController = RawLoopController(
          youtubePlayerController: youtubePlayerController,
          loopCount: customLoopCount,
        ),
        _subtitleLoopController = SubtitleLoopController(
          ref: ref,
          subtitlesPlayerProvider: subtitlesPlayerProvider,
          loopCount: subtitleLoopCount,
          youtubePlayerController: youtubePlayerController,
        );
  final YoutubePlayerController youtubePlayerController;
  final SubtitlesSeekController _seekSubtitleController;
  final RawLoopController _loopController;
  final SubtitleLoopController _subtitleLoopController;

  Future<void> enableForceHd() async {
    youtubePlayerController.setVideoQuality(VideoQuality.hd1080p);
    // await _rxSharedPreferences.setBool(
    //   YoutubePlayerModel.sharedPreferencesForceHdKey,
    //   true,
    // );
  }

  Future<void> disableForceHd() async {
    youtubePlayerController.setVideoQuality(VideoQuality.auto);
    // await _rxSharedPreferences.setBool(
    //   YoutubePlayerModel.sharedPreferencesForceHdKey,
    //   true,
    // );
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
