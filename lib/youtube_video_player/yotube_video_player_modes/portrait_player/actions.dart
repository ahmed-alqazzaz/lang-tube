import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/youtube_video_player/actions/actions_provider.dart';

import '../../actions/views/actions.dart';

// class ActionsPieMenu extends ConsumerWidget {
//   ActionsPieMenu({
//     super.key,
//     required this.onActionMenuToggled,
//     required this.actions,
//   });
//   final YoutubePlayerActions actions;
//   final void Function() onActionMenuToggled;
//   final _toggleButtonColor = Colors.amber[600];

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(actionsProvider);
//     return CircularMenu(
//       toggleButtonColor: _toggleButtonColor,
//       alignment: const Alignment(1, 0.95),
//       startingAngleInRadian: 2.8,
//       endingAngleInRadian: 4.8,
//       toggleButtonSize: 25,
//       toggleButtonOnPressed: onActionMenuToggled,
//       toggleButtonBoxShadow: const [
//         BoxShadow(color: Colors.white, blurRadius: 0.5)
//       ],
//       items: items.map((item) => item(ref)).toList(),
//     );
//   }
// }

class PortraitPlayerActions extends StatelessWidget {
  const PortraitPlayerActions({super.key, required this.actions});
  final YoutubePlayerActions actions;
  static const buttonsPadding = YoutubePlayerActions.buttonsPadding;

  Widget _bottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(buttonsPadding, 0),
          child: actions.positionIndicator(),
        ),
        Transform.translate(
          offset: const Offset(buttonsPadding, 0),
          child: actions.toggleFullScreenButton(
            isFullScreen: false,
          ),
        ),
      ],
    );
  }

  Widget _topActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(-buttonsPadding, 0),
          child: actions.backButton(),
        ),
        Transform.translate(
          offset: const Offset(buttonsPadding, 0),
          child: actions.settingsButton(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topActions(),
              _bottomActions(),
            ],
          ),
        );
      },
    );
  }
}
