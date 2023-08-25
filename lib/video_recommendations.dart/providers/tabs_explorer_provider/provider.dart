import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/providers/tabs_explorer_provider/explorer.dart';

import '../youtube_scraper_provider/provider.dart';

final tabsExplorerProvider =
    StateNotifierProvider<YoutubeTabsExplorer, List<String>>(
  (ref) => YoutubeTabsExplorer(
    interactionsController: ref.read(youtubeScraperProvider).interactions,
  ),
);
