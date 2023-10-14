// import 'dart:async';

// import 'package:collection/collection.dart';
// import 'package:colourful_print/colourful_print.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_scraper/youtube_scraper.dart';

// class YoutubeTabsExplorer extends StateNotifier<List<String>> {
//   YoutubeTabsExplorer({
//     required YoutubeInteractionsController interactionsController,
//   })  : _interactionsController = interactionsController,
//         super([]) {
//     _interactionsController.selectedTab.then(
//       (tab) => state = [...state, tab],
//     );
//   }
//   final YoutubeInteractionsController _interactionsController;

//   Future<void> exploreInitialTabs({int tabsCount = 3}) async {
//     final tabs = await _interactionsController.tabs;
//     assert(tabsCount < tabs.length);
//     if (state.length < tabsCount) {
//       final unexploredTabs = tabs.whereNot((tab) => state.contains(tab));
//       await _interactionsController.clickTab(tabName: unexploredTabs.first);
//       state = state..add(unexploredTabs.first);
//       await Future.delayed(const Duration(seconds: 3));
//       await _interactionsController.scrollToBottom();
//       await Future.delayed(const Duration(seconds: 5));
//       await _interactionsController.scrollToBottom();
//       await Future.delayed(const Duration(seconds: 5));
//       return await exploreInitialTabs(tabsCount: tabsCount);
//     }
//   }
// }
