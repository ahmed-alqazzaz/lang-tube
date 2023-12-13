// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:lang_tube/providers/app_state_provider/app_state_provider.dart';
import 'package:lang_tube/subtitles_scraper/scraper.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/lexicon.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/lexicon_entry.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/web_example.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/youtube_example.dart';
import 'package:lang_tube/explanation_modal/explanation_page/page.dart';
//import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:user_agent/user_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAgentManager().initilize();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  // await ReceiveSharingIntent.getInitialText();
  await SubtitlesScraper.ensureInitalized();
  ProviderContainer()
      .read(appStateProvider.notifier)
      .displayVideoPlayer(videoId: 'fuFlMtZmvY0');
  runApp(const LangTube());
}

class LangTube extends StatelessWidget {
  const LangTube({super.key});

  static const Color tmp = Color.fromARGB(255, 58, 18, 81);
  static const backgroundColor = Color.fromARGB(255, 242, 244, 249);
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        //routerConfig: GoRouter(routes: $appRoutes),
        home: const YoutubeVideoPlayerView(),
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
      ),
    );
  }
}

final explanationPage = ExplanationPage(
  word: 'Try',
  data: Lexicon(
    entries: [
      for (var i = 0; i < 5; i++)
        LexiconEntry(
          media: Image.asset(
            "assets/music.jpg",
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
              "https://www.nytimes.com/2023/08/22/climate/tropical-storm-california-maui-fire-extreme-august.html",
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
