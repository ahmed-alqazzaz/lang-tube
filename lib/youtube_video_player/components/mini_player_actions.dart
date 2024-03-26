import 'package:flutter/material.dart';

import 'custom_position_indicator.dart';
import 'orientation_toggler.dart';

class MiniPlayerActions extends StatelessWidget {
  const MiniPlayerActions({super.key});
  static const buttonsPadding = 15.0;

  Widget _bottomActions() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPositionIndicator(padding: buttonsPadding),
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: YoutubeOrientationToggler(),
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
          child: backButton(),
        ),
        Transform.translate(
          offset: const Offset(buttonsPadding, 0),
          child: backButton(),
        ),
      ],
    );
  }

  Widget backButton() {
    return RawMaterialButton(
      child: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //  _topActions(),
              _bottomActions(),
            ],
          ),
        );
      },
    );
  }
}
