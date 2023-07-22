import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/data/data_classes.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_provider.dart';

import 'package:lang_tube/youtube_video_player/youtube_player_model/helpers/hd_toggle_manager.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';
import 'helpers/player_setup_manager.dart';
import 'helpers/subtitles_fetch_manager.dart';

typedef YoutubePlayerProvider
    = AutoDisposeChangeNotifierProvider<YoutubePlayerModel>;
final youtubePlayerProviderFamily = ChangeNotifierProvider.family.autoDispose<
    YoutubePlayerModel,
    ({
      String videoId,
      bool shouldForceHd,
    })>(
  (ref, args) {
    return YoutubePlayerModel._(
      ref: ref,
      videoId: args.videoId,
      subtitles: SubtitlesBundle.empty(),
      shouldInitialllyForceHd: args.shouldForceHd,
    );
  },
);

class YoutubePlayerModel extends ChangeNotifier {
  YoutubePlayerModel._({
    required String videoId,
    required AutoDisposeChangeNotifierProviderRef ref,
    required SubtitlesBundle subtitles,
    required bool shouldInitialllyForceHd,
  }) {
    _configurations = YoutubePlayerConfigurations(
      videoId: videoId,
      subtitles: subtitles,
      shouldForceHd: shouldInitialllyForceHd,
      ref: ref,
    );
    _hdToggleManager = YoutubePlayerHdToggleManager(
      youtubePlayerController: _configurations.youtubePlayerController,
      onToggle: (isHdEnabled) {
        _configurations = _configurations.copyWith(shouldForceHd: isHdEnabled);
        notifyListeners();
      },
    );
    _subtitlesFetchManager = YoutubePlayerSubtitlesFetchManager(
      mainLanguage: 'english',
      translatedLanguage: 'arabic',
      videoId: videoId,
      ref: ref,
      onFetched: (subtitles) {
        _configurations = _configurations.copyWith(subtitles: subtitles);
        notifyListeners();
      },
    );
  }

  static const String sharedPreferencesForceHdKey = 'yt_player_force_hd';
  late final YoutubePlayerHdToggleManager _hdToggleManager;
  late final YoutubePlayerSubtitlesFetchManager _subtitlesFetchManager;
  late YoutubePlayerConfigurations _configurations;

  YoutubePlayerController get youtubePlayerController =>
      _configurations.youtubePlayerController;

  SubtitlesPlayerProvider get subtitlesPlayerProvider =>
      _configurations.subtitlesPlayerProvider;
  YoutubePlayerActionsProvider get actionsProvider =>
      _configurations.actionsProvider;

  @override
  void dispose() {
    _configurations.dispose();
    _hdToggleManager.dispose();
    _subtitlesFetchManager.dispose();
    super.dispose();
  }
}
