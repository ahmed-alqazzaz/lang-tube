import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';

import '../utils/subtitle_player_model.dart';

typedef SubtitlesBuilder = Widget Function(
  ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider,
  BuildContext context,
);
