import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/views/subtitle_box.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utils/subtitle_player_model.dart';

class MainSubtitlesPlayer extends ConsumerStatefulWidget {
  const MainSubtitlesPlayer({
    super.key,
    required this.subtitlePlayerProvider,
    required this.onWordTapped,
  });
  static const double minWidth = 200;
  static const double textFontSize = 17;
  static final Color defaultTextColor = Colors.white.withOpacity(0.5);

  final ChangeNotifierProvider<SubtitlePlayerModel> subtitlePlayerProvider;
  final Function(String word) onWordTapped;
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
      final index = model.currentSubtitleIndex;

      if (index != null) {
        _scrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 330),
        );
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
        final words =
            ref.watch(widget.subtitlePlayerProvider).currentSubtitle?.words;
        return Container(
          color: Colors.black38,
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SubtitleBox(
                words: words ?? [],
                backgroundColor: Colors.transparent,
                textFontSize: 20,
                onWordTapped: (word) {},
                defaultTextColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitles = ref.watch(
        widget.subtitlePlayerProvider.select((model) => model.subtitles));

    return Container(
      color: Colors.grey.shade900,
      constraints: const BoxConstraints(
        minWidth: MainSubtitlesPlayer.minWidth,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _headerBuilder(),
          ),
          SliverFillRemaining(
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemCount: subtitles.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: SubtitleBox(
                    words: subtitles[index].words,
                    backgroundColor: Colors.transparent,
                    textFontSize: MainSubtitlesPlayer.textFontSize,
                    onWordTapped: (word) {},
                    defaultTextColor: MainSubtitlesPlayer.defaultTextColor,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
