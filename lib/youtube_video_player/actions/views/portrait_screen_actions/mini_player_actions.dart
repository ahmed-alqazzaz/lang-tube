import 'package:flutter/cupertino.dart';
import 'package:lang_tube/youtube_video_player/components/orientation_toggler.dart';
import '../generic_actions.dart';

class MiniPlayerActions extends StatelessWidget {
  const MiniPlayerActions({super.key, required this.actions});
  final YoutubePlayerGenericActions actions;
  static const buttonsPadding = 15.0;

  Widget _bottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        actions.currentPositionIndicator(padding: buttonsPadding),
        const Padding(
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
          child: actions.backButton(),
        ),
        Transform.translate(
          offset: const Offset(buttonsPadding, 0),
          child: actions.backButton(),
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
