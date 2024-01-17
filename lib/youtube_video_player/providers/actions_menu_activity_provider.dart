import 'package:flutter_riverpod/flutter_riverpod.dart';

final actionsMenuActivityProvider =
    StateNotifierProvider<_ActionsMenuActivityNotifier, bool>(
  (ref) => _ActionsMenuActivityNotifier.instance,
);

class _ActionsMenuActivityNotifier extends StateNotifier<bool> {
  static _ActionsMenuActivityNotifier get instance => _instance;
  static final _instance = _ActionsMenuActivityNotifier();
  _ActionsMenuActivityNotifier() : super(false);

  void activate() => state = true;
  void deactivate() => state = false;
  void toggle() => state = !state;
}
