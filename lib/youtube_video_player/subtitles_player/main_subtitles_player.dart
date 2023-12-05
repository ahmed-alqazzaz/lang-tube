import 'dart:async';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lang_tube/youtube_video_player/components/subtitle_box.dart';
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
  const MainSubtitlesPlayer({
    super.key,
    required this.headerBackgroundColor,
  });
  static const double textFontSize = 16;
  static const double headerTextFontSize = 18;
  static const double subtitleBoxVerticalPadding = 20;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);
  static const double headerlinesDividerHeight = 5;
  static const Duration bodyScrollDuration = Duration(milliseconds: 500);
  final Color headerBackgroundColor;

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
      (timeStamp) =>
          ref.read(actionsMenuActivityProvider.notifier).state = false,
    );

    super.dispose();
  }

  void _onTap({required String word, required VoidCallback onReset}) {
    final controller = ref.read(youtubeControllerProvider);
    controller.pause();
    showModalBottomSheet(
        showDragHandle: true,
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
    // final explanationModalConstraintsNotifier =
    //     ref.read(explanationModalConstraintsProvider);
    final subtitlesPlayerValue = ref.read(subtitlesPlayerProvider);
    final youtubePlayerController = ref.read(youtubeControllerProvider);
    final subtitles = subtitlesPlayerValue.subtitles;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (event) {
            ref.read(youtubeControllerProvider).pause();
          },
          child: SizeObserver(
            onChange: (size) => _bottomSheetHeightNotifier.value = size,
            child: ScrollablePositionedList.builder(
              padding: EdgeInsets.only(bottom: constraints.maxHeight),
              itemScrollController: _scrollController,
              initialScrollIndex:
                  subtitlesPlayerValue.index ?? subtitles.length,
              itemCount: subtitles.length,
              itemBuilder: (context, index) {
                if (index >= subtitles.length) return Container();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final shouldAbsorbPointers = ref.read(actionsMenuActivityProvider);

    ref.listen<SubtitlesPlayerValue>(
      subtitlesPlayerProvider,
      (_, value) {
        printRed("scrolling to ${value.subtitles.length} ${value.index}");
        _scrollController.scrollTo(
          index: value.subtitles.length - value.index,
          duration: MainSubtitlesPlayer.bodyScrollDuration,
        );
      },
    );
    // if (MediaQuery.of(context).orientation == Orientation.landscape) {
    //   assert(!shouldAbsorbPointers,
    //       'Main Subtitles player should not absorb pointers while in landscape');
    // }
    return Scaffold(
      body: AbsorbPointer(
        absorbing: shouldAbsorbPointers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final currentSubtitle =
                    ref.watch(subtitlesPlayerProvider).currentSubtitles;
                return headerBuilder(
                  backgroundColor: widget.headerBackgroundColor,
                  onTap: ({required onReset, required word}) =>
                      _onTap(word: word, onReset: onReset),
                  mainSubtitle: currentSubtitle.mainSubtitle,
                  translatedSubtitle: currentSubtitle.translatedSubtitle,
                );
              },
            ),
            Expanded(child: _body())
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget headerBuilder({
  Subtitle? mainSubtitle,
  Subtitle? translatedSubtitle,
  required OnSubtitleTapped onTap,
  required Color backgroundColor,
  Color mainLineColor = Colors.white,
  Color translatedLineColor = Colors.amber,
}) {
  SubtitleBox mainLine(Subtitle currentSubtitle) {
    return SubtitleBox(
      words: currentSubtitle.words,
      backgroundColor: Colors.transparent,
      textFontSize: MainSubtitlesPlayer.headerTextFontSize,
      onTapUp: onTap,
      defaultTextColor: mainLineColor,
    );
  }

  SubtitleBox translatedLine(Subtitle currentSubtitle) {
    return SubtitleBox(
      words: currentSubtitle.words,
      backgroundColor: Colors.transparent,
      textFontSize: MainSubtitlesPlayer.headerTextFontSize,
      defaultTextColor: translatedLineColor,
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
          horizontal: constraints.maxWidth * 0.05,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mainSubtitle != null) mainLine(mainSubtitle),
            const SizedBox(
                height: MainSubtitlesPlayer.headerlinesDividerHeight),
            if (translatedSubtitle != null) translatedLine(translatedSubtitle),
          ],
        ),
      );
    },
  );
}
