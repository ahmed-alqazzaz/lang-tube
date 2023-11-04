import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier(super.state);

  void displayVideoPlayer({required String videoId}) =>
      state = DisplayingVideoPlayer(videoId: videoId);
}
