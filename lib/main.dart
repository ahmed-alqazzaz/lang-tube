import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_scraper/webview/cookies_manager.dart';

import 'package:lang_tube/youtube_scraper/youtube_player_scraper.dart';

import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:user_agent/user_agent.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:stack_trace/stack_trace.dart' as stack_trace;

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
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const YoutubeVideoPlayerView(videoId: '9FppammO1zk'),
        theme: ThemeData(
          iconTheme: const IconThemeData(size: 30),
          scaffoldBackgroundColor: Colors.grey.shade900,
        ),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: controller),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    body: YoutubeVideoPlayerView(videoId: controller.text),
                  );
                },
              ), (route) {
                return false;
              });
            },
            child: const Text('submit'),
          )
        ],
      ),
    );
  }
}

class YoutubeScraper extends StatelessWidget {
  YoutubeScraper({super.key})
      : controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://www.youtube.com'));
  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}

class ToBeNamed extends StatefulWidget {
  const ToBeNamed({super.key});

  @override
  State<ToBeNamed> createState() => _ToBeNamedState();
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube'),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            userAgent:
                'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1',
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            supportZoom: false,
            disableHorizontalScroll: false,
            disableVerticalScroll: false,
            useShouldOverrideUrlLoading: true,
          ),
        ),
        initialUrlRequest: URLRequest(url: Uri.parse('https://m.youtube.com/')),
        onWebViewCreated: (controller) async {
          await controller.clearCache();
          CookieManager.instance().deleteAllCookies();
          final url = Uri.parse('https://m.youtube.com/');
          final cookieManager = YoutubeCookiesManager(
            uri: url,
            cookiesUpdateCallBack: () async {
              await Future.delayed(
                  cookieReloadDuration + const Duration(seconds: 3), () async {
                //  log('reloading');
                return await controller.reload();
              });
            },
          );
        },
        onConsoleMessage: (controller, consoleMessage) {
          //    log(consoleMessage.message);
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {},
      ),
    );
  }
}

class _ToBeNamedState extends State<ToBeNamed> {
  late final YoutubePlayerScraper _scraper;
  @override
  void initState() {
    // _scraper.run();
    super.initState();
  }

  @override
  void dispose() {
    // _scraper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   for (var element in _scraper.videoItems.reversed) {
    //     if (RegExp(r'^[a-zA-Z0-9\s!@#$%^&*(),.?":{}|<>`~_-]+$')
    //         .hasMatch(element.title)) {
    //       // final scraper = await SubtitlesScraper.withRandomUserAgent();
    //       // final z = YoutubeRecommendationsManager.instance()
    //       //   ..addVideo(
    //       //     await YoutubeVideo.init(
    //       //       item: element,
    //       //       subtitles: await scraper.getSubtitle(
    //       //         youtubeVideoId: element.videoId,
    //       //         languages: (
    //       //           mainLanguage: 'English',
    //       //           translatedLanguage: 'German'
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   );
    //       //await element.click();
    //       log('titles ${[for (final item in _scraper.videoItems) item.title]}');
    //       log('clicking ${element.title}');
    //       //log('${z.recommendations}');

    //       break;
    //     }
    //   }
    // });
    return _scraper.webview;
  }
}

    

// final cookieManager = CookieManager.instance();
//           final currentUri = Uri.parse('https://m.youtube.com/');
//           await cookieManager.deleteAllCookies();
//           YoutubeScraperCookiesManager(uri: currentUri, controller: controller);
//           await controller.clearCache();
//           for (final cookie in cookies) {
//             await cookieManager.setCookie(
//               url: currentUri,
//               name: cookie['name'] as String,
//               value: cookie['value'] as String,
//             );
//           }

//           controller.webStorage.sessionStorage
//               .setItem(key: 'hhhh', value: 'jjjj');
//           Timer(Duration(seconds: 5), () async {
//             controller.reload();
//             log((await cookieManager.getCookies(url: currentUri!)).toString());
//           });
// const cookies = [
//   {
//     'name': 'GPS',
//     'value': '1',
//     'expiresDate': null,
//     'isSessionOnly': null,
//     'domain': null,
//     'sameSite': null,
//     'isSecure': null,
//     'isHttpOnly': null,
//     'path': null
//   },
//   {
//     'name': 'YSC',
//     'value': '-OS-mP8c_6Q',
//     'expiresDate': null,
//     'isSessionOnly': null,
//     'domain': null,
//     'sameSite': null,
//     'isSecure': null,
//     'isHttpOnly': null,
//     'path': null
//   },
//   {
//     'name': 'VISITOR_INFO1_LIVE',
//     'value': '8n8pWuqMwhA',
//     'expiresDate': null,
//     'isSessionOnly': null,
//     'domain': null,
//     'sameSite': null,
//     'isSecure': null,
//     'isHttpOnly': null,
//     'path': null
//   },
//   {
//     'name': 'PREF',
//     'value': 'tz=Asia.Baghdad',
//     'expiresDate': null,
//     'isSessionOnly': null,
//     'domain': null,
//     'sameSite': null,
//     'isSecure': null,
//     'isHttpOnly': null,
//     'path': null
//   }
// ];
