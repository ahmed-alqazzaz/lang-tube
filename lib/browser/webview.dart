import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_agent/user_agent.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';
import 'package:word_listenable_webview/word_listenable_webview.dart';

import '../explanation_modal/explanation_modal.dart';
import 'package:string_validator/string_validator.dart';

import '../providers/user_agent_provider.dart';
import 'browser_appbar.dart';

class BrowserWebview extends ConsumerStatefulWidget {
  const BrowserWebview({super.key});

  @override
  ConsumerState<BrowserWebview> createState() => _BrowserWebviewState();
}

class _BrowserWebviewState extends ConsumerState<BrowserWebview> {
  late final WordListenableWebViewController _webViewController;
  late final ValueNotifier<String> _currentUrlNotifier;
  late final ValueNotifier<int> _loadingProgressNotifier;
  static const _homeUrl = 'https://www.google.com/';

  @override
  void initState() {
    _loadingProgressNotifier = ValueNotifier<int>(0);
    _currentUrlNotifier = ValueNotifier<String>(
      'https://www.scientificamerican.com/article/scientists-tried-to-re-create-an-entire-human-brain-in-a-computer-what-happened/',
    );
    super.initState();
  }

  @override
  void dispose() {
    _currentUrlNotifier.dispose();
    _loadingProgressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _currentUrlNotifier,
            builder: (context, url, _) {
              return BrowserAppbar(
                onSubmit: (query) {
                  _webViewController.loadUrl(
                    isURL(query)
                        ? Uri.parse(query)
                        : Uri.parse('https://www.google.com/search?q=$query'),
                  );
                },
                onHomeTabbed: () =>
                    _webViewController.loadUrl(Uri.parse(_homeUrl)),
                currentUrl: url,
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: _loadingProgressNotifier.syncMap<double>(
              (event) => event / 100,
            ),
            builder: (context, value, _) => value != 1.0
                ? LinearProgressIndicator(value: value)
                : const SizedBox(),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Consumer(
                builder: (context, ref, child) {
                  return WordListenableWebview(
                    onWordTapped: (clickedWord) async {
                      clickedWord.highlight(
                        backgroundColor: Colors.white,
                        textColor: Colors.amber.shade800,
                      );
                      final wordBottom = clickedWord.boundingRect.bottom;
                      final firstQuarter = constraints.maxHeight * 0.25;
                      final neededScroll = (wordBottom - firstQuarter).ceil();

                      if (neededScroll > 0) {
                        final availableHeight =
                            await _webViewController.scrollHeight -
                                await _webViewController.scrollOffset -
                                await _webViewController.windowHeight;
                        if (availableHeight < neededScroll) {
                          await _webViewController.injectSpaceAtBottom(
                            height: (neededScroll - availableHeight).ceil(),
                          );
                        }
                        await _webViewController.scroll(neededScroll);
                      }

                      final cleanedWord =
                          clickedWord.word.replaceAll(RegExp(r'[^a-zA-Z]'), '');

                      // ignore: use_build_context_synchronously
                      showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          barrierColor: Colors.black12,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight * 0.75,
                            maxHeight: constraints.maxHeight * 0.75,
                          ),
                          builder: (context) {
                            return ExplanationModalSheet(
                              word: cleanedWord,
                            );
                          }).then(
                        (_) async {
                          clickedWord.removeHighlight();
                          if (neededScroll > 0) {
                            _webViewController.scroll(-neededScroll);
                          }
                          _webViewController.removeInjectedSpace();
                        },
                      );
                    },
                    userAgent: ref.watch(userAgentProvider).valueOrNull?.device,
                    initialRequest: Uri.parse(
                      _currentUrlNotifier.value,
                    ),
                    onUrlUpdated: (url) => _currentUrlNotifier.value = url,
                    onWebViewCreated: (controller) =>
                        _webViewController = controller,
                    onProgressUpdated: (progress) =>
                        _loadingProgressNotifier.value = progress,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
