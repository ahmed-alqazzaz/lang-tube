import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../youtube_player_provider.dart';

@immutable
class YoutubePlayerHdToggleManager {
  YoutubePlayerHdToggleManager({
    required YoutubePlayerController youtubePlayerController,
    required void Function(bool isEnabled) onToggle,
  }) : _forceHdObserver = RxSharedPreferences.getInstance()
            .observe<bool>(_sharedPreferencesForceHdKey, (_) {
          return null;
        }).listen(
          (bool? isHdEnabled) => _forceHdToggleListener(
            isHdEnabled: isHdEnabled,
            youtubePlayerController: youtubePlayerController,
            onToggle: onToggle,
          ),
        );

  static const _sharedPreferencesForceHdKey =
      YoutubePlayerModel.sharedPreferencesForceHdKey;

  final StreamSubscription<bool?> _forceHdObserver;

  void dispose() => _forceHdObserver.cancel();

  static void _forceHdToggleListener({
    required bool? isHdEnabled,
    required YoutubePlayerController youtubePlayerController,
    required void Function(bool isEnabled) onToggle,
  }) {
    isHdEnabled != null ? onToggle(isHdEnabled) : null;
  }
}
