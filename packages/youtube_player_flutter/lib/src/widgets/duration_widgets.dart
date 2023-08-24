// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../enums/position_indicator_value.dart';

/// A widget which displays the position of the video.
class PositionIndicator extends StatelessWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  final PositionIndicatorValue positionValue;

  /// Creates [PositionIndicator] widget.
  const PositionIndicator({
    super.key,
    this.controller,
    this.positionValue = PositionIndicatorValue.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return _ControllerListenableBuilder(
      key: key,
      controller: controller,
      mapper: (YoutubePlayerValue value) {
        final currentPosition = value.position.inMilliseconds;
        final videoDuration = value.metaData.duration.inMilliseconds;
        switch (positionValue) {
          case PositionIndicatorValue.currentPosition:
            return durationFormatter(currentPosition);
          case PositionIndicatorValue.videoDuration:
            return durationFormatter(videoDuration);
          case PositionIndicatorValue.remainingPosition:
            return durationFormatter(videoDuration - currentPosition);
        }
      },
      builder: (context, position) {
        return Text(
          position,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        );
      },
    );
  }
}

class _ControllerListenableBuilder extends StatefulWidget {
  const _ControllerListenableBuilder({
    super.key,
    required this.builder,
    required this.mapper,
    this.controller,
  });
  final YoutubePlayerController? controller;
  final Widget Function(BuildContext context, String value) builder;
  final String Function(YoutubePlayerValue value) mapper;
  @override
  State<_ControllerListenableBuilder> createState() =>
      _ControllerListenableBuilderState();
}

class _ControllerListenableBuilderState
    extends State<_ControllerListenableBuilder> {
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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _controller.syncMap(widget.mapper).unique,
      builder: (context, value, child) => widget.builder(context, value),
    );
  }
}
