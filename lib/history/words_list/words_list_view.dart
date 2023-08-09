import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/words_list/sort_provider.dart';
import 'package:lang_tube/history/words_list/sort_settings.dart';
import 'package:lang_tube/main.dart';
import 'package:lang_tube/youtube_video_player/settings/subtitles_settings/settings.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:sized_button/sized_button.dart';

import 'word_list_tile.dart';

class WordListView extends StatelessWidget {
  WordListView({super.key});
  static const _sortButtons = WordsListSortSettings.values;
  static const _title = "Words List";
  static const _searchFieldHint = "search words";

  Widget _sortButtonsBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final button in _sortButtons)
              Consumer(
                builder: (context, ref, _) {
                  final isSelected = ref.watch(wordsListSortProvider
                      .select((selectedButton) => selectedButton == button));
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.01,
                    ),
                    child: SizedButton.small(
                      color: isSelected ? LangTube.tmp : Colors.white,
                      textColor: isSelected ? Colors.white : LangTube.tmp,
                      onPressed: () {
                        ref.read(wordsListSortProvider.notifier).updateSettings(
                              button,
                            );
                      },
                      child: Text(button.name.capitalize()),
                    ),
                  );
                },
              )
          ],
        );
      },
    );
  }

  Widget _filterButtonBuilder() {
    return CircularInkWell(
      child: const Icon(Icons.filter_list_sharp),
      onTap: () {},
    );
  }

  Widget _wordListTileBuilder() {
    return SizedBox(
      height: 80,
      child: WordListTile(
        title: "Habe",
        subtitle: "have",
        onPressed: () {
          if (_isSearching == false) {
            log("hhh");
          }
        },
        onActionsMenuTapped: () {},
        media: Container(
          color: Colors.red,
          width: 90,
        ),
      ),
    );
  }

  final _appBarKey = GlobalKey<SearchAppbarState>();
  void _disableAppBarSearch() => _appBarKey.currentState?.disableSearch();
  bool? get _isSearching => _appBarKey.currentState?.isSearching;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: SearchAppbar(
        key: _appBarKey,
        onQueryUpdated: (l) {},
        title: _title,
        searchFieldHint: _searchFieldHint,
        leading: const Icon(Icons.arrow_back_sharp),
      ),
      body: Listener(
        onPointerUp: (details) => _disableAppBarSearch(),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            _sortButtonsBuilder(),
            SizedBox(height: height * 0.01),
            _filterButtonBuilder(),
            SizedBox(height: height * 0.025),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => _wordListTileBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
