import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifier.dart';
import 'state.dart';

final languageConfigProvider =
    StateNotifierProvider<LanguageConfigNotifier, LanguageConfig>(
  (ref) => LanguageConfigNotifier.instance,
);
