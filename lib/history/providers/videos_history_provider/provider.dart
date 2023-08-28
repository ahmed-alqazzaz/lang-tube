import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/providers/videos_history_provider/notifier.dart';

import '../../../video_widgets/display_video_item.dart';

final videosHistoryProvider =
    StateNotifierProvider<VideosHistoryNotifier, List<DisplayVideoItem>>(
  (ref) => VideosHistoryNotifier(),
);
