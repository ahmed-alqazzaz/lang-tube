import 'package:flutter/cupertino.dart';

import 'actions.dart';

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
          child: actions.toggleFullScreenButton(),
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
