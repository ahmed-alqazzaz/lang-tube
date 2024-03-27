import 'package:colourful_print/colourful_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/app_states/video_player_state.dart';
import '../../providers/shared/app_state_provider.dart';

// this provider is necessary for obtaining latest emitted video id,
// without returning null when the state changes anything

// ref.watch is not used, because when app state changes,
// and navigation animation starts, the provider will return null for few milliseconds
// causing the view to break
final videoIdProvider = Provider<String>(
  (ref) {
    ref.listen(
      appStateProvider.future,
      (_, state) async {
        if (await state is DisplayingVideoPlayer) {
          printBlue('invalidating video id provider');
          ref.invalidateSelf();
        }
      },
      fireImmediately: false,
    );
    return ref.read(
      appStateProvider.select((state) {
        assert(state.valueOrNull is DisplayingVideoPlayer,
            'state must be DisplayingVideoPlayer when video id provider is used or refreshed');
        return (state.valueOrNull as DisplayingVideoPlayer).videoId;
      }),
    );
  },
);
