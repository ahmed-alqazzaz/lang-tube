import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../youtube_scraper/youtube_player_scraper.dart';

final youtubeScraperProvider =
    Provider((ref) => YoutubePlayerScraper.sharedInstance());
