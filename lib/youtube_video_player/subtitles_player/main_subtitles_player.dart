import 'dart:async';
import 'package:aligned_bottom_sheet/aligned_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_modal_constraints_provider.dart';

import 'package:lang_tube/youtube_video_player/components/subtitle_box.dart';
import 'package:lang_tube/youtube_video_player/providers/subtitles_download_progress_provider.dart';
import 'package:lang_tube/youtube_video_player/providers/youtube_controller_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:size_observer/size_observer.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../explanation_modal/explanation_modal.dart';
import '../../models/subtitles/subtitles_player_value.dart';
import '../providers/actions_menu_activity_provider.dart';
import '../providers/subtitles_player_provider.dart';

class MainSubtitlesPlayer extends ConsumerStatefulWidget {
  const MainSubtitlesPlayer({super.key});
  static const double textFontSize = 16;
  static const double headerTextFontSize = 18;
  static const double subtitleBoxVerticalPadding = 20;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);
  static const double headerlinesDividerHeight = 5;
  static const Duration bodyScrollDuration = Duration(milliseconds: 500);
  static const Color headerBackgroundColor = Color.fromARGB(255, 20, 20, 20);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainSubtitlesPlayerState();
}

class _MainSubtitlesPlayerState extends ConsumerState<MainSubtitlesPlayer>
    with AutomaticKeepAliveClientMixin {
  late final ItemScrollController _scrollController;
  late final ValueNotifier<Size?> _bottomSheetHeightNotifier;
  ProviderSubscription? _currentSubtitleSubscription;

  @override
  void initState() {
    _scrollController = ItemScrollController();
    _bottomSheetHeightNotifier = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    _currentSubtitleSubscription?.close();
    _bottomSheetHeightNotifier.dispose();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => ProviderContainer()
          .read(actionsMenuActivityProvider.notifier)
          .deactivate(),
    );

    super.dispose();
  }

  void _onTap({required String word, required VoidCallback onReset}) {
    final controller = ref.read(youtubeControllerProvider);
    controller.pause();

    showAlignedModalBottomSheet(
        useRootNavigator: true,
        showDragHandle: MediaQuery.of(context).size.height > 600,
        context: context,
        barrierColor: Colors.black12,
        isScrollControlled: true,
        builder: (context) {
          return ExplanationModalSheet(
            word: word.replaceAll(RegExp(r'[^a-zA-Z]'), ''),
            sizeListenable: _bottomSheetHeightNotifier,
          );
        }).whenComplete(
      () {
        controller.play();
        onReset();
      },
    );
  }

  Widget _body() {
    final subtitlesPlayerValue = ref.watch(subtitlesPlayerProvider);
    final youtubePlayerController = ref.read(youtubeControllerProvider);
    final subtitles = subtitlesPlayerValue.subtitles;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (event) => ref.read(youtubeControllerProvider).pause(),
          child: SizeObserver(
            onChange: (size) => _bottomSheetHeightNotifier.value = size,
            child: ScrollablePositionedList.builder(
              padding: EdgeInsets.only(bottom: constraints.maxHeight),
              itemScrollController: _scrollController,
              initialScrollIndex: subtitles.length - subtitlesPlayerValue.index,
              itemCount: subtitles.length,
              itemBuilder: (context, index) {
                if (index >= subtitles.length || index < 0) return Container();
                final subtitle =
                    subtitles.reversed.toList()[index].mainSubtitle!;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    youtubePlayerController.seekTo(subtitle.start);
                    youtubePlayerController.value.isPlaying == true
                        ? null
                        : youtubePlayerController.play();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.03),
                          child: Text(
                            durationFormatter(subtitle.start.inMilliseconds),
                            style: TextStyle(
                              color: MainSubtitlesPlayer.defaultTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SubtitleBox(
                            words: subtitle.words,
                            backgroundColor: Colors.transparent,
                            textFontSize: MainSubtitlesPlayer.textFontSize,
                            defaultTextColor:
                                MainSubtitlesPlayer.defaultTextColor,
                            fontWeight: FontWeight.w300,
                            selectable: false,
                            onTapUp: ({required onReset, required word}) {
                              Timer(MainSubtitlesPlayer.bodyScrollDuration, () {
                                _onTap(word: word, onReset: onReset);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          child: Text(
                            durationFormatter(subtitle.end.inMilliseconds),
                            style: TextStyle(
                              color: MainSubtitlesPlayer.defaultTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget headerBuilder() {
    return Container(
      color: MainSubtitlesPlayer.headerBackgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final mainSubtitle = ref.watch(
                  subtitlesPlayerProvider.select(
                    (value) => value.currentSubtitles.mainSubtitle,
                  ),
                );
                if (mainSubtitle != null) {
                  return SubtitleBox(
                    words: mainSubtitle.words,
                    backgroundColor: Colors.transparent,
                    textFontSize: MainSubtitlesPlayer.headerTextFontSize,
                    onTapUp: _onTap,
                    defaultTextColor: Colors.white,
                  );
                }
                return Container();
              },
            ),
            const SizedBox(
                height: MainSubtitlesPlayer.headerlinesDividerHeight),
            Consumer(
              builder: (context, ref, _) {
                final translatedSubtitle = ref.watch(
                  subtitlesPlayerProvider.select(
                    (value) => value.currentSubtitles.translatedSubtitle,
                  ),
                );
                if (translatedSubtitle != null) {
                  return SubtitleBox(
                    words: translatedSubtitle.words,
                    backgroundColor: Colors.transparent,
                    textFontSize: MainSubtitlesPlayer.headerTextFontSize,
                    defaultTextColor: Colors.amber.shade600,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressIndictorBuilder() {
    return Consumer(
      builder: (context, ref, _) {
        final downloadProgress = ref.watch(subtitlesDownloadProgressProvider);
        if (downloadProgress != null) {
          return LinearProgressIndicator(
            value: downloadProgress == 0.0 ? null : downloadProgress,
            minHeight: 2.3,
            backgroundColor: MainSubtitlesPlayer.defaultTextColor,
            color: Colors.deepPurple.shade800,
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final shouldAbsorbPointers = ref.watch(actionsMenuActivityProvider);
    ref.listen<SubtitlesPlayerValue>(
      subtitlesPlayerProvider,
      (_, value) {
        _scrollController.scrollTo(
          index: value.subtitles.length - value.index,
          duration: MainSubtitlesPlayer.bodyScrollDuration,
        );
      },
    );

    return Scaffold(
      body: AbsorbPointer(
        absorbing: shouldAbsorbPointers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            headerBuilder(),
            _progressIndictorBuilder(),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
