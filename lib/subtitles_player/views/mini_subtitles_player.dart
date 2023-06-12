import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitle_player_provider.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniSubtitlesPlayer extends ConsumerStatefulWidget {
  const MiniSubtitlesPlayer({
    super.key,
    required this.subtitlesPlayerProvider,
    required this.onTap,
  });

  static const Color backgroundColor = Colors.black;
  static const Color defaultTextColor = Colors.white;
  static const double textFontSize = 22;
  final SubtitlesPlayerProvider subtitlesPlayerProvider;
  final OnSubtitleTapped onTap;

  @override
  ConsumerState<MiniSubtitlesPlayer> createState() =>
      _MiniSubtitlesPlayerState();
}

class _MiniSubtitlesPlayerState extends ConsumerState<MiniSubtitlesPlayer> {
  late final BehaviorSubject<int?> _currentSubtitleIndex;
  late final SubtitlesPlayerModel _subtitlesPlayerModel;
  @override
  void initState() {
    _currentSubtitleIndex = BehaviorSubject();
    _subtitlesPlayerModel = ref.read(widget.subtitlesPlayerProvider)
      ..addListener(_subtitlesPlayerListener);
    super.initState();
  }

  void _subtitlesPlayerListener() {
    YoutubePlayerController;
    final subtitlesModel = ref.read(widget.subtitlesPlayerProvider);
    log(subtitlesModel.mainSubtitlesController.currentSubtitle.toString());
    final index = subtitlesModel.mainSubtitlesController.currentSubtitleIndex;
    if (_currentSubtitleIndex.valueOrNull != index) {
      _currentSubtitleIndex.add(index);
    }
  }

  @override
  void dispose() {
    _currentSubtitleIndex.close();
    _subtitlesPlayerModel.removeListener(_subtitlesPlayerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainSubtitles =
        _subtitlesPlayerModel.mainSubtitlesController.subtitles;
    final translatedSubtitles =
        _subtitlesPlayerModel.translatedSubtitlesController.subtitles;
    return StreamBuilder(
      stream: _currentSubtitleIndex.stream,
      builder: (context, snapshot) {
        final index = snapshot.data;
        return SubtitleBox(
          words: index != null ? mainSubtitles[index].words : [],
          backgroundColor: MiniSubtitlesPlayer.backgroundColor,
          onTapUp: widget.onTap,
          textFontSize: MiniSubtitlesPlayer.textFontSize,
          defaultTextColor: MiniSubtitlesPlayer.defaultTextColor,
        );
      },
    );
  }
}
