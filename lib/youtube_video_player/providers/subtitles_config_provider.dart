// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/subtitles/subtitles_player_config.dart';
import 'subtitles_provider.dart';

final subtitlesConfigProvider = StateProvider<SubtitlesPlayerConfig?>((ref) {
  final subtitles = ref.watch(subtitlesProvider);

  if (subtitles?.isNotEmpty == true) {
    return SubtitlesPlayerConfig(
      showTranslations: true,
      selectedBundle: subtitles!.first,
    );
  }
  return null;
});
