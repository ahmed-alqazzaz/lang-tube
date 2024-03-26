import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/hd_provider.dart';
import '../providers/subtitle_loop_provider.dart';

class ActionsCircularMenu extends ConsumerWidget {
  ActionsCircularMenu({
    super.key,
    required this.onActionsMenuToggled,
  });
  final circularMenuToggleButtonColor = Colors.amber[600];
  static const circularMenuItemBackgroundColor =
      Color.fromARGB(255, 50, 50, 50);

  final void Function() onActionsMenuToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircularMenu(
      toggleButtonColor: circularMenuToggleButtonColor,
      alignment: const Alignment(0, 0.92),
      startingAngleInRadian: 3.8,
      endingAngleInRadian: 5.6,
      toggleButtonSize: 35,
      toggleButtonOnPressed: onActionsMenuToggled,
      toggleButtonBoxShadow: const [
        BoxShadow(color: Colors.white, blurRadius: 0.5)
      ],
      items: [
        _circularMenuHdButton(ref),
        _circularMenuSubtitlesButton(ref),
        circularMenuSubtitlesLoopButton(ref),
      ],
    );
  }

  CircularMenuItem _genericCircularMenuItem({
    required IconData icon,
    required void Function() onTap,
    Color iconColor = Colors.white,
  }) {
    return CircularMenuItem(
      icon: icon,
      iconColor: iconColor,
      color: circularMenuItemBackgroundColor,
      onTap: onTap,
    );
  }

  CircularMenuItem _circularMenuHdButton(WidgetRef ref) {
    final isHd = ref.watch(youtubeHdProvider);
    final youtubeHdNotifier = ref.read(youtubeHdProvider.notifier);
    return _genericCircularMenuItem(
      icon: Icons.hd_rounded,
      iconColor: isHd ? Colors.white : Colors.white30,
      onTap: () async =>
          isHd ? youtubeHdNotifier.disableHd() : youtubeHdNotifier.forceHd(),
    );
  }

  CircularMenuItem circularMenuSubtitlesLoopButton(WidgetRef ref) {
    final isLoopActive =
        ref.watch(subtitleLoopProvider.select((value) => value != null));
    final subtitleLoopNotifier = ref.read(subtitleLoopProvider.notifier);

    return _genericCircularMenuItem(
      icon: Icons.repeat_one,
      iconColor: isLoopActive ? Colors.white : Colors.white30,
      onTap: () => isLoopActive
          ? subtitleLoopNotifier.deactivateLoop()
          : subtitleLoopNotifier.activateLoop(),
    );
  }

  CircularMenuItem _circularMenuSubtitlesButton(WidgetRef ref) {
    return _genericCircularMenuItem(
      icon: Icons.closed_caption_rounded,
      onTap: () {},
    );
  }
}
