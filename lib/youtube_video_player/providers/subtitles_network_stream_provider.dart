// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/subtitles/subtitles_network_stream.dart';
import '../../providers/captions_scraper_provider.dart';
import 'video_id_provider.dart';

final subtitlesNetworkStreamProvider =
    StreamProvider<SubtitlesNetworkStream>((ref) async* {
  final scraper = await ref.watch(captionsScraperProvider.future);
  final videoId = ref.watch(videoIdProvider);
  final progressController = StreamController<double>();
  final subtitlesBundles = scraper
      .fetchSubtitlesBundle(
        youtubeVideoId: videoId,
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
