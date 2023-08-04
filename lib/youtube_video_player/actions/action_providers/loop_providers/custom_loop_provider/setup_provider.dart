import 'package:flutter_riverpod/flutter_riverpod.dart';

KeepAliveLink? _link;
final customLoopSettingProvider = StateProvider.autoDispose((ref) {
  _link?.close();
  _link = ref.keepAlive();
  return CustomLoopState.inactive;
});

enum CustomLoopState {
  inactive,
  activating,
  active,
}
