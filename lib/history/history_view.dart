import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:collection/collection.dart';
import 'package:colourful_print/colourful_print.dart';
import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/enums/videos_sort_options.dart';
import 'package:lang_tube/history/enums/words_sort_options.dart';
import 'package:lang_tube/history/providers/videos_history_provider/provider.dart';
import 'package:lang_tube/history/providers/words_history_provider/provider.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:size_utils/size_utils.dart';
import 'package:sized_button/sized_button.dart';

import '../main.dart';
import '../video_widgets/videos_list.dart';
import 'data/history_word_item.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  final _searchAppbarKey = GlobalKey<SearchAppbarState>();
  final _wordsHistoryKey = GlobalKey<State<StatefulBuilder>>();

  late final videosHistoryNotifier = ref.read(videosHistoryProvider.notifier);
  late final wordsHistoryNotifier = ref.read(wordsHistoryProvider.notifier);
  late final _videosSortOptions =
      VideosSortOption.values.map((e) => e.name.capitalize()).toList();
  late final _wordsSortOptions = WordsSortOption.values.map((e) {
    if (e == WordsSortOption.cefr) return 'B1';
    return e.name.capitalize();
  }).toList();

  String? _videoIdFilter;
  int _tabIndex = 0;

  // int get currentIndex => _controller.index;
  void _searchFieldListener(String value) => _tabIndex == 0
      ? videosHistoryNotifier.search(text: value)
      : wordsHistoryNotifier.search(text: value);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              iconTheme: IconThemeData(color: LangTube.tmp, size: 30),
              centerTitle: false,
            ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            SearchAppbar(
              toolbarHeight: 60,
              onChange: _searchFieldListener,
              key: _searchAppbarKey,
              title: 'History',
              searchFieldHint: _searchVideosHint,
              leading: const Icon(Icons.menu),
              actions: [
                CircularInkWell(
                  child: const Icon(
                    Icons.filter_list_sharp,
                  ),
                  onTap: () {},
                )
              ],
            ),
            Expanded(
              child: Listener(
                onPointerUp: (_) =>
                    _searchAppbarKey.currentState?.disableSearch(),
                child: NotificationListener(
                  onNotification: _tabBarNotificationListener,
                  child: ContainedTabBarView(
                    onChange: (index) {
                      _tabIndex = index;
                      _searchAppbarKey.currentState
                        ?..disableSearch()
                        ..searchFieldHint =
                            index == 0 ? _searchVideosHint : _searchWordsHint;
                    },
                    tabBarProperties: TabBarProperties(
                      indicatorColor: const Color.fromARGB(255, 190, 40, 216),
                      unselectedLabelColor: LangTube.tmp.withOpacity(0.6),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      labelColor: LangTube.tmp,
                      labelPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    tabs: const [Text(' VIDEOS'), Text('WORDS')],
                    views: [
                      _videosHistoryBuilder(),
                      _wordsHistoryBuilder(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _tabBarNotificationListener(Notification notification) {
    // if (notification is OverscrollNotification) {
    //   final bottomBarPageController =
    //       TabbedNavigatorPageController.of(context)!;
    //   bottomBarPageController.jumpTo(
    //       bottomBarPageController.position.pixels + notification.overscroll);
    // }
    return true;
  }

  Widget _videosHistoryBuilder() {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: height * 0.01),
        _sortButtonsBuilder(
          buttonsList: [_videosSortOptions],
          onTap: (selectedIndex) => videosHistoryNotifier.sort(
            VideosSortOption.values[selectedIndex],
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final videos = ref.watch(videosHistoryProvider);
              return VideosListView(
                videos: videos,
                onTap: (p0) {},
                itemHeight: getScreenSize().height * 0.11,
                verticalPadding: getScreenSize().height * 0.007,
                trailingBuilder: (_) => CircularInkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _wordsHistoryBuilder() {
    return StatefulBuilder(
        key: _wordsHistoryKey,
        builder: (context, setState) {
          final height = MediaQuery.of(context).size.height;
          final videoOriginTitle = ref
              .read(videosHistoryProvider)
              .where((video) => video.id == _videoIdFilter)
              .firstOrNull
              ?.title;
          final wordItems = (ref.watch(wordsHistoryProvider).where(
                (wordItem) => _videoIdFilter != null
                    ? wordItem.originVideoId == _videoIdFilter
                    : true,
              )).toList();
          return Column(
            children: [
              SizedBox(height: height * 0.01),
              _sortButtonsBuilder(
                buttonsList: [
                  if (videoOriginTitle != null)
                    [videoOriginTitle]
                  else ...[
                    _wordsSortOptions.sublist(0, 2),
                    _wordsSortOptions.sublist(2),
                  ]
                ],
                onTap: (selectedIndex) {
                  printGreen(selectedIndex.toString());
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: wordItems.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: _wordListTileBuilder(
                        item: wordItems[index],
                        onPressed: () {},
                        onActionsMenuTapped: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget _wordListTileBuilder({
    required HistoryWordItem item,
    required VoidCallback onPressed,
    required VoidCallback onActionsMenuTapped,
  }) {
    const border = BorderRadius.vertical(
      top: Radius.circular(10),
      bottom: Radius.circular(10),
    );
    const double horizaontalGap = 20;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
            shape: const RoundedRectangleBorder(
              borderRadius: border,
            ),
            color: Colors.white,
            elevation: 0,
            child: ClipRRect(
              borderRadius: border,
              child: RawMaterialButton(
                onPressed: onPressed,
                child: Row(
                  children: [
                    item.media,
                    const SizedBox(width: horizaontalGap),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.1),
                        // TITLE
                        Text(
                          item.word,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.1),
                        Text(
                          item.translation,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.color?.withOpacity(0.6),
                              ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.2),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    // ACTIONS MENU
                    IconButton(
                      onPressed: onActionsMenuTapped,
                      icon: const Icon(
                        Icons.more_vert_sharp,
                        size: 30,
                      ),
                      splashRadius: horizaontalGap,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _sortButtonsBuilder({
    required List<List<String>> buttonsList,
    required void Function(int selectedIndex) onTap,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final selectabilityProvider = StateProvider.autoDispose((ref) => 0);
        ref.listen(selectabilityProvider, (_, index) => onTap(index));
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
              child: Column(
                  children: buttonsList.mapIndexed((buttonsListIndex, buttons) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  children: buttons.mapIndexed((index, button) {
                    // adjust index to be the index of the super list
                    index = buttonsList.sublist(0, buttonsListIndex).fold(
                          index,
                          (previousValue, element) =>
                              previousValue + element.length,
                        );
                    return Consumer(
                      builder: (context, ref, _) {
                        final isSelected = ref.watch(
                          selectabilityProvider.select(
                              (selectedIndex) => selectedIndex == index),
                        );
                        final selectabilityNotifier =
                            ref.read(selectabilityProvider.notifier);
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.01,
                          ),
                          child: SizedButton.small(
                            color: isSelected ? LangTube.tmp : Colors.white,
                            textColor: isSelected ? Colors.white : LangTube.tmp,
                            onPressed: () {
                              selectabilityNotifier.state = index;
                            },
                            child: Text(button),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }).toList()),
            );
          },
        );
      },
    );
  }

  static const String _searchVideosHint = 'Search Videos';
  static const String _searchWordsHint = 'Search Words';
}
