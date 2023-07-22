import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/custom/widgets/youtube_player_widgets/custom_current_position.dart';
import 'package:lang_tube/explanation_modal/explanation_modal_constraints_provider.dart';
import 'package:lang_tube/subtitles_player/providers/player_pointer_absorbtion_provider.dart';

import 'package:lang_tube/subtitles_player/utils/subtitles_parser/data/subtitle.dart';

import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../providers/subtitle_player_provider.dart';

final mainSubtitlesPlayerKey = GlobalKey<_MainSubtitlesPlayerState>();

class MainSubtitlesPlayer extends ConsumerStatefulWidget {
  const MainSubtitlesPlayer({
    super.key,
    required this.subtitlesPlayerProvider,
    required this.onTap,
  });
  static const double textFontSize = 16;
  static const double headerTextFontSize = 18;
  static const double subtitleBoxVerticalPadding = 20;
  static const Color headerBackgroundColor = Colors.black26;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);
  static const double headerlinesDividerHeight = 5;
  static const Duration bodyScrollDuration = Duration(milliseconds: 500);
  final SubtitlesPlayerProvider subtitlesPlayerProvider;
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
    final subtitlesPlayerModel = ref.read(widget.subtitlesPlayerProvider);
    final currentIndex =
        subtitlesPlayerModel.mainSubtitlesController.currentSubtitleIndex;
    final subtitlesCount =
        subtitlesPlayerModel.mainSubtitlesController.subtitles.length;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentIndex != null
          ? _subtitlesPlayerListener(
              index: currentIndex,
              subtitlesCount: subtitlesCount,
            )
          : _scrollController.jumpTo(
              index: subtitlesCount,
            );
    });
    _subtitlesPlayerProviderSubscription =
        ref.listenManual<SubtitlesPlayerModel>(
      widget.subtitlesPlayerProvider,
      (_, model) {
        _subtitlesPlayerListener(
          subtitlesCount: subtitlesCount,
          index: model.mainSubtitlesController.currentSubtitleIndex,
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _subtitlesPlayerProviderSubscription.close();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _absorbtionNotifier.neverAbsorbPointers();
    });

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
          color: MainSubtitlesPlayer.headerBackgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
            horizontal: constraints.maxWidth * 0.05,
          ),
          child: Consumer(builder: (context, ref, _) {
            final subtitlesPlayerModel =
                ref.watch(widget.subtitlesPlayerProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mainLine(
                  subtitlesPlayerModel.mainSubtitlesController.currentSubtitle,
                ),
                const SizedBox(
                  height: MainSubtitlesPlayer.headerlinesDividerHeight,
                ),
                translatedLine(
                  subtitlesPlayerModel
                      .translatedSubtitlesController.currentSubtitle,
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _body({required List<Subtitle> subtitles}) {
    final explanationModalConstraintsNotifier =
        ref.read(explanationModalConstraintsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          explanationModalConstraintsNotifier.updateConstraints(constraints);
        });
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (event) {
            ref.read(widget.subtitlesPlayerProvider).pause();
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
                  ref.read(widget.subtitlesPlayerProvider).seekTo(
                        subtitle.start,
                      );
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
    return AbsorbPointer(
      absorbing: shouldAbsorbPointers,
      child: Container(
        color: Colors.grey.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _headerBuilder(),
            Expanded(
              child: _body(
                subtitles: ref
                    .read(widget.subtitlesPlayerProvider)
                    .mainSubtitlesController
                    .subtitles,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
