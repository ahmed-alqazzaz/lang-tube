// this provider is necessary for obtaining latest emitted video id
// without returning null when the state changes anything other than  DisplayingVideoPlayer

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/providers/app_state_provider/app_state_provider.dart';
import 'package:lang_tube/providers/app_state_provider/states.dart';

// ref.watch is not used, because when app state changes,
// and navigation animation starts, the provider will return null for few milliseconds
// causing the view to break

// this provider is necessary for obtaining latest emitted video id,
// without returning null when the state changes anything
final videoIdProvider = Provider<String>(
  (ref) {
    ref.listen(
      appStateProvider,
      (_, state) {
        if (state is DisplayingVideoPlayer) {
          printBlue("invalidating video id provider");
          ref.invalidateSelf();
        }
      },
      fireImmediately: false,
    );
    return ref.read(
      appStateProvider.select((state) {
        assert(state is DisplayingVideoPlayer,
            'state must be DisplayingVideoPlayer when video id provider is used or refreshed');
        return (state as DisplayingVideoPlayer).videoId;
      }),
    );
  },
);
