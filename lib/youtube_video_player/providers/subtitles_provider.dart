import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/subtitles/subtitles_bundle.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_network_stream_provider.dart';

final subtitlesProvider = Provider<Iterable<SubtitlesBundle>?>(
  (ref) {
    return ref.watch(
      subtitlesNetworkStreamProvider.select(
        (asyncNetworkSubtitles) {
          if (asyncNetworkSubtitles.hasError) {
            throw asyncNetworkSubtitles.error!;
          }

          return asyncNetworkSubtitles.valueOrNull?.subtitlesBundles;
        },
      ),
    );
  },
);
