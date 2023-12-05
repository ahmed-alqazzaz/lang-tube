// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/subtitles/subtitles_network_stream.dart';
import 'package:languages/languages.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:lang_tube/youtube_video_player/providers/video_id_provider.dart';

final subtitlesNetworkStreamProvider =
    StreamProvider<SubtitlesNetworkStream>((ref) async* {
  final progressController = StreamController<double>();
  final videoId = ref.watch(videoIdProvider);

  printRed("network $videoId");
  await for (double progress in progressController.stream.distinctUnique()) {
    printRed("progress $progress");
    // yield SubtitlesNetworkStream(downloadProgress: progress);
  }

  yield SubtitlesNetworkStream(
    subtitlesBundles: await SubtitlesScraper.instance.fetchSubtitlesBundle(
      youtubeVideoId: videoId,
      mainLanguage: Language.english,
      translatedLanguage: Language.arabic,
      onProgressUpdated: (progress) => progressController.add(progress),
    ),
    downloadProgress: 1.0,
  );

  ref.onDispose(() => progressController.close());
  ref.listenSelf((_, next) {
    if (next.hasError) {
      printRed("network subs provider ${next.error}");
    }
  });
});
