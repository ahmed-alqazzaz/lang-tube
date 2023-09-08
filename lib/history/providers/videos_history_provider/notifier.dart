import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/history/enums/videos_sort_options.dart';

import '../../../video_widgets/display_video_item.dart';

final videos = [
  DisplayVideoItem(
    id: 'dzJvuswZ5ys',
    title: 'RIP google domains... and FIVE big tech stories this week',
    thumbnailUrl: 'https://i3.ytimg.com/vi/dzJvuswZ5ys/maxresdefault.jpg',
    lastWatched: DateTime(2020),
    duration: '12:35',
    badges: [],
    onActionsMenuPressed: () {},
    onPressed: () {},
  ),
  DisplayVideoItem(
    id: 'aXOChLn5ZdQ',
    title: 'Javascript for the Haters',
    thumbnailUrl: 'https://i3.ytimg.com/vi/aXOChLn5ZdQ/maxresdefault.jpg',
    lastWatched: DateTime(2017),
    duration: '11:35',
    badges: [],
    onActionsMenuPressed: () {},
    onPressed: () {},
  ),
  DisplayVideoItem(
    id: 'lXfEK8G8CUI',
    title: 'How The Immune System ACTUALLY Works- IMMUNE',
    thumbnailUrl: 'https://i3.ytimg.com/vi/lXfEK8G8CUI/maxresdefault.jpg',
    lastWatched: DateTime(2019),
    duration: '13:15',
    badges: [],
    onActionsMenuPressed: () {},
    onPressed: () {},
  ),
  DisplayVideoItem(
    id: 'sl0UUhmaiDU',
    title: 'Samsung Tab S9 Ultra: Is the IPAD KILLER Real?',
    thumbnailUrl: 'https://i3.ytimg.com/vi/sl0UUhmaiDU/maxresdefault.jpg',
    lastWatched: DateTime(2023),
    duration: '5:15',
    badges: [],
    onActionsMenuPressed: () {},
    onPressed: () {},
  ),
  DisplayVideoItem(
    id: 'Itbsnna09MY',
    title: 'Office PRANKS But They Get Progressively More Expensive',
    thumbnailUrl: 'https://i3.ytimg.com/vi/Itbsnna09MY/maxresdefault.jpg',
    lastWatched: DateTime(2003),
    duration: '9:15',
    badges: const [],
    onActionsMenuPressed: () {},
    onPressed: () {},
  ),
];

class VideosHistoryNotifier extends StateNotifier<List<DisplayVideoItem>> {
  VideosHistoryNotifier() : super(List.unmodifiable([])) {
    // TODO: request 10 items from server and add them
    for (var element in videos) {
      state = [...state, element];
    }
  }
  void addItem(DisplayVideoItem item) {}
  void removeItem(DisplayVideoItem item) {}
  void filter() {
    // last month, last day
  }
  void search({required String text}) {
    // TODO request from server
    state = videos
        .where(
          (video) => video.title.toLowerCase().contains(
                text.toLowerCase(),
              ),
        )
        .toList();
  }

  void sort(VideosSortOption option) {
    state = state.sorted((a, b) {
      switch (option) {
        case VideosSortOption.latest:
          return b.lastWatched.compareTo(a.lastWatched);
        case VideosSortOption.oldest:
          return a.lastWatched.compareTo(b.lastWatched);
        case VideosSortOption.longest:
          Duration durationParser(String duration) => Duration(
                minutes: int.parse(duration.split(':')[0]),
                seconds: int.parse(duration.split(':')[1]),
              );
          return durationParser(b.duration).compareTo(
            durationParser(a.duration),
          );
      }
    });
  }

  void refresh() {}
}
