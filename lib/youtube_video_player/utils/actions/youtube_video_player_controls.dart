import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lang_tube/custom/icons/custom_icons.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/buttons/closed_caption_button.dart';
import 'package:lang_tube/youtube_video_player/youtube_video_player_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'controls.dart';

class YoutubeVideoPlayerActions extends StatefulWidget {
  YoutubeVideoPlayerActions({
    super.key,
    required this.controller,
  }) : controls = Controls(controller: controller);

  final YoutubePlayerController controller;
  final Controls controls;
  @override
  State<YoutubeVideoPlayerActions> createState() =>
      _YoutubeVideoPlayerActionsState();
}

class _YoutubeVideoPlayerActionsState extends State<YoutubeVideoPlayerActions> {
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
              widget.controls.positionIndicator(),
              widget.controls.fullScreenButton(),
            ],
          ),
        ),
        widget.controls.progressBar(),
      ],
    );
  }

  Widget bottomActions() {
    return Row(
      children: [
        widget.controls.saveClipButton(),
        widget.controls.loopButton(),
        widget.controls.playBackSpeedButton(),
        Expanded(child: Container()),
        widget.controls.youtubeButton(),
      ],
    );
  }

  Widget topActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(value: true, onChanged: (h) {}),
        widget.controls.captionButton(),
        widget.controls.settingsButton(),
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
