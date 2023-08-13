import 'package:flutter/cupertino.dart';

import '../../../youtube_scraper/data/youtube_video_item.dart';

// this is meant to manage the history of the videos clicked by the algorithm manipulator
// and is not different from the user videos history
@immutable
abstract class ManipulatorHistoryManager {
  Future<void> addToHistory();
  Future<List<YoutubeVideoItem>> getHistory();
}
