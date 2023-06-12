import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../subtitles_player/providers/subtitle_player_provider.dart';
import '../../../subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';
import '../../actions/actions_controller/actions_controller.dart';
import '../../actions/actions_provider.dart';

// when subtitles are being fetched, actions and
// subtitles providers are assigned to null
int _v = 0;

@immutable
class YoutubePlayerConfigurations {
  factory YoutubePlayerConfigurations({
    required String videoId,
    required bool shouldForceHd,
    required SubtitlesBundle subtitles,
    required AutoDisposeChangeNotifierProviderRef ref,
  }) {
    final youtubePlayerController = _buildYoutubePlayerController(
      shouldForceHd: shouldForceHd,
      videoId: videoId,
    );
    final subtitlesPlayerProvider = _buildSubtitlesProvider(
      subtitles: subtitles,
      youtubePlayerController: youtubePlayerController,
    );
    final actionsProvider = _buildActionsProvider(
      shouldForceHd: shouldForceHd,
      subtitlesPlayerProvider: subtitlesPlayerProvider,
      youtubePlayerController: youtubePlayerController,
      ref: ref,
    );
    return YoutubePlayerConfigurations._(
      youtubePlayerController: youtubePlayerController,
      subtitlesPlayerProvider: subtitlesPlayerProvider,
      actionsProvider: actionsProvider,
      videoId: videoId,
      shouldForceHd: shouldForceHd,
      subtitles: subtitles,
      ref: ref,
    );
  }

  const YoutubePlayerConfigurations._({
    required String videoId,
    required bool shouldForceHd,
    required this.youtubePlayerController,
    required this.ref,
    required this.subtitlesPlayerProvider,
    required this.actionsProvider,
    required SubtitlesBundle subtitles,
  })  : _subtitles = subtitles,
        _videoId = videoId,
        _shouldForceHd = shouldForceHd;
  final AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>
      actionsProvider;
  final SubtitlesPlayerProvider subtitlesPlayerProvider;
  final SubtitlesBundle _subtitles;

  final AutoDisposeChangeNotifierProviderRef ref;
  final YoutubePlayerController youtubePlayerController;
  final String _videoId;
  final bool _shouldForceHd;

  void dispose() {
    subtitlesPlayerProviderkeepAliveLink?.close();
    playerActionsProviderKeepAliveLink?.close();
    youtubePlayerController.dispose();
  }

  YoutubePlayerConfigurations copyWith({
    String? videoId,
    bool? shouldForceHd,
    SubtitlesBundle? subtitles,
  }) {
    dispose();
    return YoutubePlayerConfigurations(
      videoId: videoId ?? _videoId,
      shouldForceHd: shouldForceHd ?? _shouldForceHd,
      subtitles: subtitles ?? _subtitles,
      ref: ref,
    );
  }

  static YoutubePlayerController _buildYoutubePlayerController({
    required bool shouldForceHd,
    required String videoId,
  }) {
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        enableCaption: false,
        forceHD: shouldForceHd,
      ),
    );
  }

  static AutoDisposeChangeNotifierProvider<YoutubePlayerActionsModel>
      _buildActionsProvider({
    required bool shouldForceHd,
    required SubtitlesPlayerProvider subtitlesPlayerProvider,
    required YoutubePlayerController youtubePlayerController,
    required AutoDisposeChangeNotifierProviderRef ref,
  }) {
    return youtubePlayerActionsProvider((
      playbackSpeed: 0.75,
      shouldForceHd: shouldForceHd,
      controller: YoutubePlayerActionsController(
        youtubePlayerController: youtubePlayerController,
        subtitlesPlayerProvider: subtitlesPlayerProvider,
        ref: ref,
      ),
    ));
  }

  static SubtitlesPlayerProvider _buildSubtitlesProvider({
    required SubtitlesBundle subtitles,
    required YoutubePlayerController youtubePlayerController,
  }) {
    subtitlesPlayerProviderkeepAliveLink?.close();
    return subtitlesPlayerProviderBuilder(
      youtubePlayerController: youtubePlayerController,
      mainSubtitlesController: SubtitlesController.fromSubtitlesEntry(
        subtitles.mainSubtitles,
      ),
      translatedSubtitlesController: SubtitlesController.fromSubtitlesEntry(
        subtitles.translatedSubtitles,
      ),
    );
  }
}
