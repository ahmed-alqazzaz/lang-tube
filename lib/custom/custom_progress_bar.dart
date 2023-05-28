// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A widget to display video progress bar.
class CustomProgressBar extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines colors for the progress bar.
  final ProgressBarColors? colors;

  /// Set true to get expanded [ProgressBar].
  ///
  /// Default is false.
  final bool isExpanded;

  final double width;
  final double handleRadius;

  /// Creates [ProgressBar] widget.
  const CustomProgressBar({
    super.key,
    this.controller,
    this.colors,
    this.isExpanded = false,
    required this.width,
    required this.handleRadius,
  });

  @override
  State<CustomProgressBar> createState() {
    return CustomProgressBarState();
  }
}

class CustomProgressBarState extends State<CustomProgressBar> {
  late YoutubePlayerController _controller;
  final touchDownController = BehaviorSubject<bool>()..add(false);
  Offset _touchPoint = Offset.zero;

  double _playedValue = 0.0;
  double _bufferedValue = 0.0;

  late Duration _position;

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
    _controller.addListener(positionListener);
    positionListener();
  }

  @override
  void dispose() {
    _controller.removeListener(positionListener);
    super.dispose();
  }

  void positionListener() {
    // in case there is no touch down
    if (touchDownController.valueOrNull == false) {
      updatePosition(_controller.value.position);
    }
  }

  void updatePosition(Duration position) {
    var totalDuration = _controller.metadata.duration.inMilliseconds;
    if (!totalDuration.isNaN && totalDuration != 0) {
      setState(() {
        _playedValue = position.inMilliseconds / totalDuration;
        _bufferedValue = _controller.value.buffered;
      });
    }
  }

  void _setValue() {
    _playedValue = _touchPoint.dx / context.size!.width;
  }

  void _checkTouchPoint() {
    if (_touchPoint.dx <= 0) {
      _touchPoint = Offset(0, _touchPoint.dy);
    }
    if (_touchPoint.dx >= context.size!.width) {
      _touchPoint = Offset(context.size!.width, _touchPoint.dy);
    }
  }

  void _seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    _touchPoint = box.globalToLocal(globalPosition);
    _checkTouchPoint();

    final relative = _touchPoint.dx / box.size.width;
    _position = _controller.metadata.duration * relative;
    updatePosition(_position);

    _controller.seekTo(_position, allowSeekAhead: false);
  }

  void _dragEndActions() {
    _controller.updateValue(
      _controller.value.copyWith(isControlsVisible: false, isDragging: false),
    );
    _controller.seekTo(_position, allowSeekAhead: true);
    touchDownController.add(false);

    _controller.play();
  }

  Widget _buildBar() {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        _controller.updateValue(
          _controller.value.copyWith(isControlsVisible: true, isDragging: true),
        );
        _seekToRelativePosition(details.globalPosition);
        touchDownController.add(true);
      },
      onHorizontalDragUpdate: (details) {
        _seekToRelativePosition(details.globalPosition);
        setState(_setValue);
      },
      onHorizontalDragEnd: (details) {
        _dragEndActions();
      },
      onHorizontalDragCancel: _dragEndActions,
      child: Container(
        color: Colors.transparent,
        constraints: BoxConstraints.expand(height: widget.handleRadius * 2),
        child: StreamBuilder<bool>(
            stream: touchDownController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: _ProgressBarPainter(
                  progressWidth: widget.width,
                  handleRadius: widget.handleRadius,
                  playedValue: _playedValue,
                  bufferedValue: _bufferedValue,
                  colors: widget.colors,
                  touchDown: snapshot.data ?? false,
                  themeData: Theme.of(context),
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpanded ? Expanded(child: _buildBar()) : _buildBar();
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progressWidth;
  final double handleRadius;
  final double playedValue;
  final double bufferedValue;
  final ProgressBarColors? colors;
  final bool touchDown;
  final ThemeData themeData;

  _ProgressBarPainter({
    required this.progressWidth,
    required this.handleRadius,
    required this.playedValue,
    required this.bufferedValue,
    this.colors,
    required this.touchDown,
    required this.themeData,
  });

  @override
  bool shouldRepaint(_ProgressBarPainter old) {
    return playedValue != old.playedValue ||
        bufferedValue != old.bufferedValue ||
        touchDown != old.touchDown;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - handleRadius * 2.0;

    final startPoint = Offset(handleRadius, centerY);
    final endPoint = Offset(size.width - handleRadius, centerY);
    final progressPoint = Offset(
      barLength * playedValue + handleRadius,
      centerY,
    );
    final secondProgressPoint = Offset(
      barLength * bufferedValue + handleRadius,
      centerY,
    );

    final secondaryColor = themeData.colorScheme.secondary;

    paint.color = colors?.backgroundColor ?? secondaryColor.withOpacity(0.38);
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = colors?.bufferedColor ?? Colors.white70;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = colors?.playedColor ?? secondaryColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    final handlePaint = Paint()..isAntiAlias = true;

    handlePaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, handlePaint);

    final _handleColor = colors?.handleColor ?? secondaryColor;

    if (touchDown) {
      handlePaint.color = _handleColor.withOpacity(1);
      canvas.drawCircle(progressPoint, handleRadius * 1.5, handlePaint);
    }

    handlePaint.color = _handleColor;
    canvas.drawCircle(progressPoint, handleRadius, handlePaint);
  }
}
