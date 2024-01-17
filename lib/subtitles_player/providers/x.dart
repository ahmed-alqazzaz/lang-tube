import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:languages/languages.dart';
import 'package:user_agent/user_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager.instance.initilize();
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
    // final z = await SubtitlesScraper.instance.fetchSubtitlesBundle(
    //   youtubeVideoId: x[2],
    //   mainLanguage: Language.english,
    //   translatedLanguage: Language.arabic,
    //   onProgressUpdated: (p0) {
    //     printPurple(p0.toString());
    //   },
    // );
    runApp(MaterialApp(
      home: ProgressIndicatorTest(),
    ));
  } finally {
    await Future.delayed(const Duration(seconds: 3));
    //await SubtitlesScraper.instance.close();
    await Future.delayed(Duration(seconds: 3));
    log('finnished');
  }

  //await SubtitlesScraper.instance.close();
}

class ProgressIndicatorTest extends StatefulWidget {
  const ProgressIndicatorTest({super.key});

  @override
  State<ProgressIndicatorTest> createState() => _ProgressIndicatorTestState();
}

class _ProgressIndicatorTestState extends State<ProgressIndicatorTest> {
  late final _notifer = ValueNotifier(0.0);
  @override
  void initState() {
    SubtitlesScraper.instance.fetchSubtitlesBundle(
      youtubeVideoId: '2QcZSVu3CCY',
      mainLanguages: Language.germanVariants,
      translatedLanguage: Language.arabic,
      onProgressUpdated: (p0) {
        _notifer.value = p0;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          ValueListenableBuilder(
            valueListenable: _notifer,
            builder: (context, value, _) {
              return LinearProgressIndicator(value: value != 0 ? value : null);
            },
          ),
        ],
      ),
    );
  }
}
