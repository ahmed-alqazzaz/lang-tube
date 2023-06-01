import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/generic_actions/buttons/closed_caption_button.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../generic_actions/actions.dart';

class FullScreenYoutubePlayerActions extends StatefulWidget {
  FullScreenYoutubePlayerActions({
    super.key,
    required this.controller,
  }) : actions = GenericActions(controller: controller);

  final YoutubePlayerController controller;
  final GenericActions actions;
  @override
  State<FullScreenYoutubePlayerActions> createState() =>
      _FullScreenYoutubePlayerActionsState();
}

class _FullScreenYoutubePlayerActionsState
    extends State<FullScreenYoutubePlayerActions> {
  @override
  void initState() {
    widget.controller.addListener(visibilityListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(visibilityListener);
    super.dispose();
  }

  void visibilityListener() {
    final areControlsVisible = widget.controller.value.isControlsVisible;
    if (_areControlsVisible != areControlsVisible) {
      setState(() {
        _areControlsVisible = areControlsVisible;
      });
    }
  }

  Widget topControls() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClosedCaptionsButton(),
      ],
    );
  }

  Widget midControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: YoutubeVideoPlayerView.progressBarHandleRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.actions.positionIndicator(),
              widget.actions.fullScreenButton(),
            ],
          ),
        ),
        widget.actions.progressBar(),
      ],
    );
  }

  Widget bottomActions() {
    return Row(
      children: [
        widget.actions.saveClipButton(),
        widget.actions.loopButton(),
        widget.actions.playBackSpeedButton(),
        Expanded(child: Container()),
        widget.actions.youtubeButton(),
      ],
    );
  }

  Widget topActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(value: true, onChanged: (h) {}),
        widget.actions.captionButton(),
        widget.actions.settingsButton(),
      ],
    );
  }

  bool _areControlsVisible = false;
  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.toString());
    return AnimatedOpacity(
      opacity: _areControlsVisible ? 1.0 : 0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          topActions(),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          midControls(),
          const SizedBox(height: 4),
          bottomActions(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
