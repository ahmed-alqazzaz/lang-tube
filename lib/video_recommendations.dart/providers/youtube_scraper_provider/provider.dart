import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/video_recommendations.dart/providers/youtube_scraper_provider/cookies_stoarge_manager.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

final youtubeScraperProvider = Provider(
  (ref) => YoutubeScraper(
    cookieStorageManager: YoutubeScraperCookiesStorageManager(),
  ),
);
