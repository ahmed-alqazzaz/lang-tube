import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_modal_constraints_provider.dart';
import 'package:lang_tube/subtitles_player/providers/player_pointer_absorbtion_provider.dart';

import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:subtitles_player/subtitles_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/multi_subtitles_player_provider/provider.dart';

final mainSubtitlesPlayerKey = GlobalKey<_MainSubtitlesPlayerState>();

class MainSubtitlesPlayer extends ConsumerStatefulWidget {
  const MainSubtitlesPlayer({
    super.key,
    required this.multiSubtitlesPlayerProvider,
    required this.youtubePlayerController,
    required this.onTap,
    required this.headerBackgroundColor,
  });
  static const double textFontSize = 16;
  static const double headerTextFontSize = 18;
  static const double subtitleBoxVerticalPadding = 20;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);
  static const double headerlinesDividerHeight = 5;
  static const Duration bodyScrollDuration = Duration(milliseconds: 500);

  final MultiSubtitlesPlayerProvider multiSubtitlesPlayerProvider;
  final YoutubePlayerController youtubePlayerController;
  final Color headerBackgroundColor;

  final OnSubtitleTapped onTap;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainSubtitlesPlayerState();
}

class _MainSubtitlesPlayerState extends ConsumerState<MainSubtitlesPlayer>
    with AutomaticKeepAliveClientMixin {
  late final ItemScrollController _scrollController;
  late final ProviderSubscription _subtitlesPlayerProviderSubscription;
  late final MainSubtitlesPlayerPointerAbsorbtionNotifier _absorbtionNotifier;
  @override
  void initState() {
    _scrollController = ItemScrollController();
    _absorbtionNotifier =
        ref.read(mainSubtitlesPlayerPointerAbsorbtionProvider.notifier);

    final multiSubtitlesPlayer =
        ref.read(widget.multiSubtitlesPlayerProvider.notifier);
    final length = multiSubtitlesPlayer.mainSubtitles.length;
    final currentIndex = ref.read(widget.multiSubtitlesPlayerProvider).index;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => currentIndex != null
          ? _subtitlesPlayerListener(
              index: currentIndex,
              subtitlesCount: length,
            )
          : _scrollController.jumpTo(index: length),
    );

    ref.listenManual(
      widget.multiSubtitlesPlayerProvider,
      (_, subtitle) {
        _subtitlesPlayerListener(
          index: subtitle.index,
          subtitlesCount: length,
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _subtitlesPlayerProviderSubscription.close();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _absorbtionNotifier.neverAbsorbPointers(),
    );

    super.dispose();
  }

  void _subtitlesPlayerListener(
      {required int? index, required int subtitlesCount}) {
    if (index != null) {
      _scrollController.scrollTo(
        index: subtitlesCount - index,
        duration: MainSubtitlesPlayer.bodyScrollDuration,
      );
    }
  }

  Widget _headerBuilder() {
    SubtitleBox mainLine(Subtitle? currentSubtitle) {
      return SubtitleBox(
        words: currentSubtitle?.words ?? [],
        backgroundColor: Colors.transparent,
        textFontSize: MainSubtitlesPlayer.headerTextFontSize,
        onTapUp: widget.onTap,
        defaultTextColor: Colors.white,
      );
    }

    SubtitleBox translatedLine(Subtitle? currentSubtitle) {
      return SubtitleBox(
        words: currentSubtitle?.words ?? [],
        backgroundColor: Colors.transparent,
        textFontSize: MainSubtitlesPlayer.headerTextFontSize,
        defaultTextColor: Colors.amber,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: widget.headerBackgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
            horizontal: constraints.maxWidth * 0.05,
          ),
          child: Consumer(builder: (context, ref, _) {
            final currentSubtitle =
                ref.watch(widget.multiSubtitlesPlayerProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mainLine(currentSubtitle.mainSubtitle),
                const SizedBox(
                    height: MainSubtitlesPlayer.headerlinesDividerHeight),
                translatedLine(currentSubtitle.translatedSubtitle),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _body() {
    final explanationModalConstraintsNotifier =
        ref.read(explanationModalConstraintsProvider);
    final subtitles =
        ref.read(widget.multiSubtitlesPlayerProvider.notifier).mainSubtitles;
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          explanationModalConstraintsNotifier.updateConstraints(constraints);
        });
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (event) {
            widget.youtubePlayerController.pause();
          },
          child: ScrollablePositionedList.builder(
            padding: EdgeInsets.only(bottom: constraints.maxHeight),
            itemScrollController: _scrollController,
            itemCount: subtitles.length + 1,
            itemBuilder: (context, index) {
              if (index >= subtitles.length) return Container();
              final subtitle = subtitles.reversed.toList()[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final controller = widget.youtubePlayerController;
                  controller.seekTo(subtitle.start);
                  controller.value.isPlaying ? null : controller.play();
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
                              widget.onTap(onReset: onReset, word: word);
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final shouldAbsorbPointers =
        ref.watch(mainSubtitlesPlayerPointerAbsorbtionProvider);
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
            _headerBuilder(),
            Expanded(
              child: _body(),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
