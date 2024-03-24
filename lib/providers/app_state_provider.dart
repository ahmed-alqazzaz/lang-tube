import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_states/app_state.dart';
import '../models/app_states/homepage_state.dart';
import '../models/app_states/video_player_state.dart';

final appStateProvider = AsyncNotifierProvider<AppStateNotifier, AppState>(
  () => AppStateNotifier(),
);

class AppStateNotifier extends AsyncNotifier<AppState> {
  @override
  FutureOr<AppState> build() {
    return const DisplayingHomePage();
  }

  void displayVideoPlayer({required String videoId}) =>
      state = AsyncValue.data(DisplayingVideoPlayer(videoId: videoId));
}
