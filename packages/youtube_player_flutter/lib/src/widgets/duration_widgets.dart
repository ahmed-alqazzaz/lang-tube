// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A widget which displays the current position of the video.
class CurrentPosition extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Creates [CurrentPosition] widget.
  const CurrentPosition({super.key, this.controller});

  @override
  State<CurrentPosition> createState() => _CurrentPositionState();
}

class _CurrentPositionState extends State<CurrentPosition> {
  late YoutubePlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
    _controller.removeListener(listener);
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentDuration = durationFormatter(
      _controller.value.position.inMilliseconds,
    );
    final videoDuration = durationFormatter(
      _controller.value.metaData.duration.inMilliseconds,
    );
    return Text(
      '$currentDuration / $videoDuration',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      ),
    );
  }
}

/// Formats duration in milliseconds to xx:xx:xx format.
String durationFormatter(int milliSeconds) {
  var seconds = milliSeconds ~/ 1000;
  final hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
  return formattedTime;
}
