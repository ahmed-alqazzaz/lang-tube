// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_provider.dart';

import '../../models/subtitles/subtitles_player_config.dart';

final subtitlesConfigProvider = StateProvider<SubtitlesPlayerConfig?>((ref) {
  final subtitles = ref.watch(subtitlesProvider).valueOrNull;
  if (subtitles?.isNotEmpty == true) {
    return SubtitlesPlayerConfig(
      showTranslations: true,
      selectedBundle: subtitles!.first,
    );
  }
  return null;
});
