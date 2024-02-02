// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:lang_tube/models/subtitles/subtitles_network_stream.dart';
import 'package:lang_tube/providers/language_config_provider/provider.dart';
import 'package:languages/languages.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:lang_tube/youtube_video_player/providers/video_id_provider.dart';

final subtitlesNetworkStreamProvider =
    StreamProvider<SubtitlesNetworkStream>((ref) async* {
  await SubtitlesScraper.ensureInitalized();
  final languageConfig = ref.watch(languageConfigProvider);
  assert(languageConfig.targetLanguage != null &&
      languageConfig.translationLanguage != null);
  final videoId = ref.watch(videoIdProvider);
  final scraper = SubtitlesScraper.instance;
  final progressController = StreamController<double>();
  final subtitlesBundles = scraper
      .fetchSubtitlesBundle(
        youtubeVideoId: videoId,
        mainLanguages: [
          languageConfig.targetLanguage!,
          ...languageConfig.targetLanguage!.variants,
        ],
        translatedLanguage: languageConfig.translationLanguage!,
        onProgressUpdated: (progress) => progressController.add(progress),
      )
      .whenComplete(() => progressController.add(1.0));

  await for (double progress in progressController.stream.distinctUnique()) {
    yield SubtitlesNetworkStream(
      subtitlesBundles: progress == 1.0 ? await subtitlesBundles : null,
      downloadProgress: progress,
    );
  }

  ref.onDispose(() => progressController.close());
  ref.listenSelf((_, next) {
    printRed('network subs provider ${next.error}');
  });
});
