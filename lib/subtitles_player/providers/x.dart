import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/cache_manager.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/cache_provider.dart';
import 'package:lang_tube/subtitles_scraper/api_client.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import 'package:languages/languages.dart';
import 'package:user_agent/user_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager().initilize();
  final scraper = ProviderContainer().read(subtitlesScraperProvider);

  print('started');
  // final apiClient = ScraperApiClient();
  // Future.wait([
  //   for (var i = 0; i < 5; i++)
  //     apiClient.fetchUrl(
  //       Uri.parse(
  //         'https://th.bing.com/th/id/R.a6d5f46dc02497871370c59ef49bf286?rik=qP6yIXH20TPhWA&riu=http%3a%2f%2fwww.pixelstalk.net%2fwp-content%2fuploads%2f2016%2f06%2fDownload-High-Res-Wallpaper-HD.jpg&ehk=6DgF%2blo28aThFhKMQdTT4Ly7DPUyUqIEXeW9dRcrWuY%3d&risl=&pid=ImgRaw&r=0',
  //       ),
  //     )
  // ]);
  final timer = Stopwatch()..start();
  final x = ['2QcZSVu3CCY', 'JOiGEI9pQBs', '9FppammO1zk'];
  await scraper.fetchSubtitlesBundle(
    youtubeVideoId: x[2],
    mainLanguage: Language.english,
    translatedLanguage: Language.arabic,
  );
  await scraper.scrapeSubtitles(
      youtubeVideoId: x[0], language: Language.english);
  log((await scraper.cacheManager.retrieveSources())?.toList().toString() ??
      'nothing');
  await Future.delayed(Duration(seconds: 5));
  await scraper.close();
  log("finnished");
}
