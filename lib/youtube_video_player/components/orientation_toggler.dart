import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/device_orientation_provider.dart';

class YoutubeOrientationToggler extends ConsumerWidget {
  const YoutubeOrientationToggler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullScreen = ref.watch(deviceOrientationProvider
        .select((orientation) => orientation.isFullScreen));
    final orientationNotifier = ref.read(deviceOrientationProvider.notifier);
    return CircularInkWell(
      child: Icon(
        isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_sharp,
        color: Colors.white,
        size: 22,
      ),
      onTap: () => isFullScreen
          ? orientationNotifier.exitFullScreen()
          : orientationNotifier.enableFullScreen(),
    );
  }
}
