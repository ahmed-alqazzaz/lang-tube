import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/explanation_modal/explanation_modal_constraints_provider.dart';
import 'package:lang_tube/main.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_parser/data/subtitle.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../explanation_modal/explanation_modal.dart';
import '../utils/subtitle_player_model.dart';

class MainSubtitlesPlayer extends ConsumerStatefulWidget {
  const MainSubtitlesPlayer({
    super.key,
    required this.subtitlePlayerProvider,
    required this.onTap,
  });
  static const double minWidth = 200;
  static const double textFontSize = 16;
  static const double headerTextFontSize = 18;
  static const double subtitleBoxVerticalPadding = 20;
  static const Color headerBackgroundColor = Colors.black26;
  static const double headerlinesDividerHeight = 5;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);

  final ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider;
  final OnSubtitleTapped onTap;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrawerSubtitlesPlayerState();
}

class _DrawerSubtitlesPlayerState extends ConsumerState<MainSubtitlesPlayer> {
  late final ItemScrollController _scrollController;
  late final ProviderSubscription<SubtitlePlayerModel>
      _subtitlePlayerSubscription;

  @override
  void initState() {
    _scrollController = ItemScrollController();
    _subtitlePlayerSubscription =
        ref.listenManual(widget.subtitlePlayerProvider, (_, model) {
      final index = model.mainSubtitlesController.currentSubtitleIndex;
      if (index != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _scrollController.scrollTo(
            index: model.mainSubtitlesController.subtitles.length - index,
            duration: const Duration(milliseconds: 330),
          );
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subtitlePlayerSubscription.close();

    super.dispose();
  }

  Widget _headerBuilder() {
    return Consumer(
      builder: (context, ref, _) {
        final (mainLine: mainLine, translatedLine: translatedLine) = ref.watch(
          widget.subtitlePlayerProvider.select((model) {
            SubtitleBox mainLine() {
              return SubtitleBox(
                words:
                    model.mainSubtitlesController.currentSubtitle?.words ?? [],
                backgroundColor: Colors.transparent,
                textFontSize: MainSubtitlesPlayer.headerTextFontSize,
                onTap: widget.onTap,
                defaultTextColor: Colors.white,
              );
            }

            SubtitleBox translatedLine() {
              return SubtitleBox(
                words: model
                        .translatedSubtitlesController.currentSubtitle?.words ??
                    [],
                backgroundColor: Colors.transparent,
                textFontSize: MainSubtitlesPlayer.headerTextFontSize,
                defaultTextColor: Colors.amber,
              );
            }

            return (
              mainLine: mainLine,
              translatedLine: translatedLine,
            );
          }),
        );
        return Container(
          color: MainSubtitlesPlayer.headerBackgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              mainLine(),
              const SizedBox(
                height: MainSubtitlesPlayer.headerlinesDividerHeight,
              ),
              translatedLine(),
            ],
          ),
        );
      },
    );
  }

  Widget _body(List<Subtitle> subtitles) {
    final explanationModalConstraintsNotifier =
        ref.read(explanationModalConstraintsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          explanationModalConstraintsNotifier.updateConstraints(constraints);
        });
        return ScrollablePositionedList.builder(
          padding: EdgeInsets.only(bottom: constraints.maxHeight),
          itemScrollController: _scrollController,
          itemCount: subtitles.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: MainSubtitlesPlayer.subtitleBoxVerticalPadding,
                horizontal: MediaQuery.of(context).size.width * 0.15,
              ),
              child: SubtitleBox(
                words: subtitles[subtitles.length - 1 - index].words,
                backgroundColor: Colors.transparent,
                textFontSize: MainSubtitlesPlayer.textFontSize,
                defaultTextColor: MainSubtitlesPlayer.defaultTextColor,
                fontWeight: FontWeight.w300,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitles = ref.read(widget.subtitlePlayerProvider
        .select((model) => model.mainSubtitlesController.subtitles));
    return Container(
      color: Colors.grey.shade900,
      constraints: const BoxConstraints(
        minWidth: MainSubtitlesPlayer.minWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _headerBuilder(),
          Expanded(child: _body(subtitles)),
        ],
      ),
    );
  }
}
