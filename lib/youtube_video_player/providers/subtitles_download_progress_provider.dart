import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_network_stream_provider.dart';

final subtitlesDownloadProgressProvider = Provider<double?>(
  (ref) => ref.watch(
    subtitlesNetworkStreamProvider.select(
      (networkSubtitles) {
        final progress = networkSubtitles.valueOrNull?.downloadProgress;
        return progress == 1.0 ? null : progress;
      },
    ),
  ),
);
