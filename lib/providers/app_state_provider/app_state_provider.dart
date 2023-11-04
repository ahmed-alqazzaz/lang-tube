import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/providers/app_state_provider/app_state_notifier.dart';
import 'package:lang_tube/providers/app_state_provider/states.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(
    const DisplayingHomePage(),
  ),
);
