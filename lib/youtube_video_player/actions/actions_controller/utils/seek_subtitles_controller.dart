import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../subtitles_player/providers/multi_subtitles_player_provider/provider.dart';

@immutable
class SubtitlesSeekController {
  const SubtitlesSeekController({
    required MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider,
    required YoutubePlayerController youtubePlayerController,
    required AutoDisposeChangeNotifierProviderRef ref,
  })  : _multiSubtitlesPlayerProvider = multiSubtitlesPlayerProvider,
        _youtubePlayerController = youtubePlayerController,
        _ref = ref;

  final MultiSubtitlesPlayerProvider _multiSubtitlesPlayerProvider;
  final YoutubePlayerController _youtubePlayerController;
  final AutoDisposeChangeNotifierProviderRef _ref;

  void seekPreviousSubtitle() => _seekSubtitle(
        _ref.read(_multiSubtitlesPlayerProvider.notifier).previousMainSubtitle,
      );

  void seekNextSubtitle() => _seekSubtitle(
        _ref.read(_multiSubtitlesPlayerProvider.notifier).nextMainSubtitle,
      );

  void _seekSubtitle(Subtitle? subtitle) {
    subtitle != null
        ? _youtubePlayerController.seekTo(subtitle.start)
        : throw UnimplementedError();
  }
}
