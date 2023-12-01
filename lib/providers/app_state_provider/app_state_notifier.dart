import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier._() : super(const DisplayingHomePage());
  static final _instance = AppStateNotifier._();
  static get instance => _instance;

  void displayVideoPlayer({required String videoId}) =>
      state = DisplayingVideoPlayer(videoId: videoId);
}
