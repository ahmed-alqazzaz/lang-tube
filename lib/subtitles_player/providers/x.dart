import 'dart:developer';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:languages/languages.dart';
import 'package:user_agent/user_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager().initilize();
  await SubtitlesScraper.ensureInitalized();

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
  final x = ['2QcZSVu3CCY', 'JOiGEI9pQBs', '9FppammO1zk'];

  try {
    final z = await SubtitlesScraper.instance.fetchSubtitlesBundle(
      youtubeVideoId: x[2],
      mainLanguage: Language.english,
      translatedLanguage: Language.arabic,
      onProgressUpdated: (p0) {
        printPurple(p0.toString());
      },
    );
    // await SubtitlesScraper.instance.fetchSubtitlesBundle(
    //   youtubeVideoId: x[2],
    //   mainLanguage: Language.english,
    //   translatedLanguage: Language.arabic,
    // );
    // await SubtitlesScraper.instance
    //     .scrapeSubtitles(youtubeVideoId: x[0], language: Language.english);
    // log(z.first.mainSubtitlesData.subtitles.toString());
  } finally {
    await Future.delayed(const Duration(seconds: 3));
    await SubtitlesScraper.instance.close();
    await Future.delayed(Duration(seconds: 3));
    log('finnished');
  }

  //await SubtitlesScraper.instance.close();
}
