import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/subtitles/subtitles_bundle.dart';
import 'subtitles_network_stream_provider.dart';

final subtitlesProvider = Provider<Iterable<CaptionsBundle>?>(
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
