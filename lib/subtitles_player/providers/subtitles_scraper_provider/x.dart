import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/api_client.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_scraper_provider/provider.dart';
import 'package:languages/languages.dart';
import 'package:user_agent/user_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager().initilize();
  final scraper =
      await ProviderContainer().read(subtitlesScraperProvider.future);

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
  await scraper.fetchSubtitlesBundle(
    youtubeVideoId: '2QcZSVu3CCY',
    mainLanguage: Language.english,
    translatedLanguage: Language.arabic,
  );
  await Future.delayed(Duration(seconds: 1));
  scraper.close();
  log('finnished within ${timer.elapsedMilliseconds}');
}
