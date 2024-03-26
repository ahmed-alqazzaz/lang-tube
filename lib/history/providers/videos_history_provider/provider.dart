import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../video_widgets/display_video_item.dart';
import 'notifier.dart';

final videosHistoryProvider =
    StateNotifierProvider<VideosHistoryNotifier, List<DisplayVideoItem>>(
  (ref) => VideosHistoryNotifier(),
);
