// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:colourful_print/colourful_print.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lang_tube/providers/captions_cache/user_captions_cache_provider.dart';
import 'package:lang_tube/providers/captions_scraper/captions_scraper_provider.dart';
import 'package:languages/languages.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:subtitles_parser/subtitles_parser.dart';
import 'explanation_modal/explanation_page/data/lexicon.dart';
import 'explanation_modal/explanation_page/data/lexicon_entry.dart';
import 'explanation_modal/explanation_page/data/web_example.dart';
import 'explanation_modal/explanation_page/data/youtube_example.dart';
import 'explanation_modal/explanation_page/page.dart';
import 'models/subtitles/cached_captions.dart';
import 'models/subtitles/cached_captions_info.dart';
import 'models/subtitles/captions_type.dart';
import 'providers/shared/app_state_provider.dart';
import 'providers/shared/language_config_provider.dart';
import 'youtube_video_player/youtube_video_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  final container = ProviderContainer();
  final languageConfigNotifier =
      container.read(languageConfigProvider.notifier);
  await languageConfigNotifier.build();
  await languageConfigNotifier.setTargetLanguage(Language.german);
  await languageConfigNotifier.setTranslationLanguage(Language.english);
  container.read(appStateProvider.notifier).displayVideoPlayer(
        videoId: 'hLoatpfE7VM',
      );
  runApp(const ProviderScope(child: LangTube()));
}

class VideoIdSelector extends ConsumerWidget {
  VideoIdSelector({super.key});
  late final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: _textEditingController),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              void x(_) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const YoutubeVideoPlayerView(),
                    ),
                  );
              // Y_8VbBOjJJw
              ref.read(appStateProvider.notifier).displayVideoPlayer(
                    videoId: _textEditingController.text,
                  );
              final languageConfigNotifier =
                  ref.read(languageConfigProvider.notifier);
              await languageConfigNotifier.build();
              await languageConfigNotifier.setTargetLanguage(Language.german);
              await languageConfigNotifier
                  .setTranslationLanguage(Language.english);
              await ref.watch(captionsScraperProvider.future);
              WidgetsBinding.instance.addPostFrameCallback(x);
            },
            child: const Text('proceed'),
          ),
          TextButton(
            onPressed: () async {
              final cookies = await CookieManager.instance().getCookies(
                url: Uri.parse(
                    'https://youtube.com/watch?v=8WQ3LUvVP6g&bpctr=9999999999&hl=en'),
              );
              printRed('cookies$cookies');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(
                              'https://youtube.com/watch?v=8WQ3LUvVP6g&bpctr=9999999999&hl=en')),
                    );
                  },
                ),
              );
            },
            child: const Text('display web'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const CustomSubsCache();
                  },
                ),
              );
            },
            child: const Text('cache subs'),
          ),
        ],
      ),
    );
  }
}

class CustomSubsCache extends StatefulWidget {
  const CustomSubsCache({super.key});

  @override
  State<CustomSubsCache> createState() => _CustomSubsCacheState();
}

class _CustomSubsCacheState extends State<CustomSubsCache> {
  String? file1Path;
  String? file2Path;
  String? videoId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return TextButton(
                onPressed: () {
                  FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['txt']).then((value) {
                    if (value != null) {
                      setState(() {
                        file1Path = value.files.single.path;
                      });
                    }
                  });
                },
                child: Text(file1Path ?? 'Pick file1'),
              );
            },
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return TextButton(
                onPressed: () {
                  FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['txt']).then((value) {
                    if (value != null) {
                      setState(() {
                        file2Path = value.files.single.path;
                      });
                    }
                  });
                },
                child: Text(file2Path ?? 'Pick file1'),
              );
            },
          ),
          TextField(
            onChanged: (value) {
              videoId = value;
            },
          ),
          const Gap(100),
          Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () async {
                  if (file1Path != null &&
                      file2Path != null &&
                      videoId != null) {
                    final parsedSubs1 =
                        await SubtitlesParser.parseYoutubeTimedText(
                            File(file1Path!).readAsStringSync());
                    final parsedSubs2 =
                        await SubtitlesParser.parseYoutubeTimedText(
                            File(file2Path!).readAsStringSync());
                    (await ref.read(
                            userUploadedCaptionsCacheManagerProvider.future))
                        .cacheCaptions(
                      CachedCaptions(
                        info: CachedCaptionsInfo(
                          videoId: videoId!,
                          language: Language.german,
                          type: CaptionsType.userUploaded,
                        ),
                        subtitles: parsedSubs1,
                      ),
                    );
                    (await ref.read(
                            userUploadedCaptionsCacheManagerProvider.future))
                        .cacheCaptions(
                      CachedCaptions(
                        info: CachedCaptionsInfo(
                          videoId: videoId!,
                          language: Language.english,
                          type: CaptionsType.userUploaded,
                        ),
                        subtitles: parsedSubs2,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('proceed'),
              );
            },
          )
        ],
      ),
    );
  }
}

class LangTube extends StatelessWidget {
  const LangTube({super.key});

  static const Color tmp = Color.fromARGB(255, 58, 18, 81);
  static const backgroundColor = Color.fromARGB(255, 242, 244, 249);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoIdSelector(),
      // routerConfig: GoRouter(routes: $appRoutes),
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: tmp,
        ),
        listTileTheme: const ListTileThemeData(iconColor: tmp),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: tmp,
          selectionColor: Colors.deepPurple.withOpacity(0.3),
          selectionHandleColor: tmp,
        ),
        splashColor: LangTube.tmp.withOpacity(0.1),
        highlightColor: LangTube.tmp.withOpacity(0.1),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: backgroundColor),
        checkboxTheme: CheckboxThemeData(
          side: BorderSide(color: tmp.withOpacity(0.2), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        scaffoldBackgroundColor: backgroundColor,
        splashFactory: InkRipple.splashFactory,
        iconTheme: const IconThemeData(
          color: tmp,
          size: 38,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: const Color.fromARGB(255, 27, 4, 40).withOpacity(0.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: tmp, width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 70,
          backgroundColor: backgroundColor,
          elevation: 0.0,
          centerTitle: true,
          actionsIconTheme: IconThemeData(
            color: tmp,
            size: 30,
          ),
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: tmp,
          ),
          iconTheme: IconThemeData(
            color: tmp,
            size: 30,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

final explanationPage = ExplanationPage(
  key: GlobalKey(),
  word: 'Try',
  data: Lexicon(
    entries: [
      for (var i = 0; i < 5; i++)
        LexiconEntry(
          media: Image.asset(
            'assets/music.jpg',
            fit: BoxFit.cover,
          ),
          cefr: 'C1',
          linguisticElement: 'verb',
          term: 'characterize',
          definition:
              'To describe distinctive features of something, or someone',
          examples: const [
            'the rolling hills that characterize this part of England',
            'The city is characterized by tall modern buildings in steel and glass.',
            'the rolling hills that characterize this part of England',
          ],
        )
    ],
    webExamples: [
      for (var i = 0; i < 5; i++)
        const WebExample(
          title:
              "you guessed it, a good night's sleep. Sleep is comprised of four stages",
          link:
              'https://www.nytimes.com/2023/08/22/climate/tropical-storm-california-maui-fire-extreme-august.html',
          content:
              """it, a good night's sleep. Sleep is comprised of four stages, the deepest of which is known as slow-wave sleep and rapid eye movement. EEG machines monitoring people during these stages have shown electrical impulses""",
        )
    ],
    youtubeExamples: [
      for (var i = 1; i < 3; i++)
        YoutubeExample(
          videoId: 'vC1uxXvPG0Q',
          start: Duration(seconds: i * 32),
          end: Duration(seconds: i * 36),
          mainSubtitle:
              'Eine der größten Illusionen im Leben ist Kontinuität. es ist so absurd',
          translatedSubtitle:
              'One the greatest illusions in life is continuity. it is so absurd',
        )
    ],
  ),
);
