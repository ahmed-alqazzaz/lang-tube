import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:lang_tube/providers/app_state_provider/app_state_provider.dart';
import 'package:lang_tube/providers/app_state_provider/states.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:languages/languages.dart';
import 'package:rxdart/rxdart.dart';

// ref.watch is not used, because when app state changes,
// and navigation animation starts, the provider will return null for few milliseconds
// causing the view to break
final subtitlesProvider =
    StreamProvider<Iterable<SubtitlesBundle>>((ref) async* {
  final videoIdController = StreamController<String>();

  ref.listen(
    appStateProvider,
    (_, state) => state is DisplayingVideoPlayer
        ? videoIdController.add(state.videoId)
        : null,
    fireImmediately: true,
  );
  await for (String videoId in videoIdController.stream.distinctUnique()) {
    yield await SubtitlesScraper.instance.fetchSubtitlesBundle(
      youtubeVideoId: videoId,
      mainLanguage: Language.english,
      translatedLanguage: Language.arabic,
    );
  }
});
