import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../actions_provider.dart';

class ActionsCircularMenu extends ConsumerWidget {
  ActionsCircularMenu({
    super.key,
    required this.onActionsMenuToggled,
    required this.retrieveActionsNotifier,
  }) : items = [
          _circularMenuHdButton,
          _circularMenuSubtitlesButton,
          _circulaMenuPlayBackSpeedButton,
        ];

  final YoutubePlayerActionsModel Function() retrieveActionsNotifier;
  final void Function() onActionsMenuToggled;
  final circularMenuToggleButtonColor = Colors.amber[600];
  static const circularMenuItemBackgroundColor =
      Color.fromARGB(255, 50, 50, 50);

  final List<CircularMenuItem Function(YoutubePlayerActionsModel)> items;
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
      items: items.map((item) => item(retrieveActionsNotifier())).toList(),
    );
  }

  static CircularMenuItem _genericCircularMenuItem({
    required IconData icon,
    Color iconColor = Colors.white,
    required void Function() onTap,
  }) {
    return CircularMenuItem(
      icon: icon,
      iconColor: iconColor,
      color: circularMenuItemBackgroundColor,
      onTap: onTap,
    );
  }

  static CircularMenuItem _circularMenuHdButton(
      YoutubePlayerActionsModel model) {
    return _genericCircularMenuItem(
      icon: Icons.hd_rounded,
      iconColor: model.isHd ? Colors.white : Colors.white30,
      onTap: () async => model.toggleHd(),
    );
  }

  static CircularMenuItem _circulaMenuPlayBackSpeedButton(
      YoutubePlayerActionsModel model) {
    return _genericCircularMenuItem(
      icon: Icons.repeat_one,
      iconColor: model.isSubtitleLoopActive ? Colors.white : Colors.white30,
      onTap: () => model.toggleSubtitleLoop(),
    );
  }

  static CircularMenuItem _circularMenuSubtitlesButton(
      YoutubePlayerActionsModel model) {
    return _genericCircularMenuItem(
      icon: Icons.closed_caption_rounded,
      onTap: () => model.displaySubtitlesSettings(),
    );
  }
}
