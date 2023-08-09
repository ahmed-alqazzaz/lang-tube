// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/youtube_player_controller.dart';

const double progressBarHandleRadius = 7.0;

/// A widget to display video progress bar.
class ProgressBar extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines colors for the progress bar.
  final ProgressBarColors? colors;

  /// Set true to get expanded [ProgressBar].
  ///
  /// Default is false.
  final bool isExpanded;

  final Stream<List<CustomProgress?>>? customProgress;

  /// Creates [ProgressBar] widget.
  const ProgressBar({
    super.key,
    this.controller,
    this.colors,
    this.customProgress,
    this.isExpanded = false,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late YoutubePlayerController _controller;
  bool _touchDown = false;

  Offset _touchPoint = Offset.zero;

  double _playedValue = 0.0;
  double _bufferedValue = 0.0;

  late final StreamSubscription<List<CustomProgress?>>?
      _customProgressSubscription;
  List<CustomProgress?> _customProgress = [];

  late Duration _position;

  @override
  void dispose() {
    _controller.removeListener(positionListener);
    _customProgressSubscription?.cancel();
    super.dispose();
  }

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
    _customProgressSubscription = widget.customProgress?.listen(
      (customProgress) => setState(() => _customProgress = customProgress),
    );
    _controller.addListener(positionListener);
    positionListener();
  }

  void positionListener() {
    // in case there is no touch down
    if (_touchDown == false) {
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
    setState(() {
      _touchDown = false;
    });

    _controller.play();
  }

  Widget _buildBar() {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        _controller.updateValue(
          _controller.value.copyWith(isControlsVisible: true, isDragging: true),
        );
        _seekToRelativePosition(details.globalPosition);
        setState(() {
          _touchDown = true;
        });
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
          constraints:
              const BoxConstraints.expand(height: progressBarHandleRadius * 2),
          child: CustomPaint(
            painter: _ProgressBarPainter(
              progressWidth: 3.0,
              handleVisible: _controller.value.isControlsVisible,
              playedValue: _playedValue,
              bufferedValue: _bufferedValue,
              colors: widget.colors,
              touchDown: _touchDown,
              customProgress: _customProgress,
              themeData: Theme.of(context),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpanded ? Expanded(child: _buildBar()) : _buildBar();
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progressWidth;
  final double playedValue;
  final double bufferedValue;
  final List<CustomProgress?> customProgress;
  final ProgressBarColors? colors;
  final bool handleVisible;
  final bool touchDown;
  final ThemeData themeData;

  _ProgressBarPainter({
    required this.progressWidth,
    required this.playedValue,
    required this.bufferedValue,
    this.customProgress = const [],
    this.colors,
    required this.handleVisible,
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
    customProgress;
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - progressBarHandleRadius * 2.0;

    final startPoint = Offset(progressBarHandleRadius, centerY);
    final endPoint = Offset(size.width - progressBarHandleRadius, centerY);
    final progressPoint = Offset(
      barLength * playedValue + progressBarHandleRadius,
      centerY,
    );
    final secondProgressPoint = Offset(
      barLength * bufferedValue + progressBarHandleRadius,
      centerY,
    );

    final secondaryColor = themeData.colorScheme.secondary;

    paint.color = colors?.backgroundColor ?? secondaryColor.withOpacity(0.38);
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = colors?.bufferedColor ?? Colors.white70;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = colors?.playedColor ?? secondaryColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    for (var progress in customProgress) {
      if (progress != null) {
        final customProgressStartPoint = Offset(
            barLength * progress.start + progressBarHandleRadius, centerY);
        final customProgressEndPoint =
            Offset(barLength * progress.end + progressBarHandleRadius, centerY);
        paint.color = progress.color;
        canvas.drawLine(
            customProgressStartPoint, customProgressEndPoint, paint);
      }
    }
    if (handleVisible) {
      final handlePaint = Paint()..isAntiAlias = true;
      final handleColor = colors?.handleColor ?? secondaryColor;

      handlePaint.color = handleColor;
      canvas.drawCircle(progressPoint, progressBarHandleRadius, handlePaint);
    }
  }
}

/// Defines different colors for [ProgressBar].
class ProgressBarColors {
  /// Defines background color of the [ProgressBar].
  final Color? backgroundColor;

  /// Defines color for played portion of the [ProgressBar].
  final Color? playedColor;

  /// Defines color for buffered portion of the [ProgressBar].
  final Color? bufferedColor;

  /// Defines color for handle of the [ProgressBar].
  final Color? handleColor;

  /// Creates [ProgressBarColors].
  const ProgressBarColors({
    this.backgroundColor,
    this.playedColor,
    this.bufferedColor,
    this.handleColor,
  });

  ///
  ProgressBarColors copyWith({
    Color? backgroundColor,
    Color? playedColor,
    Color? bufferedColor,
    Color? handleColor,
  }) =>
      ProgressBarColors(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        handleColor: handleColor ?? this.handleColor,
        bufferedColor: bufferedColor ?? this.bufferedColor,
        playedColor: playedColor ?? this.playedColor,
      );
}

@immutable
class CustomProgress {
  const CustomProgress(
      {required this.start, required this.end, required this.color});
  final double start;
  final double end;
  final Color color;

  CustomProgress copyWith({
    double? start,
    double? end,
    Color? color,
  }) {
    return CustomProgress(
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'CustomProgress(start: $start, end: $end, color: $color)';

  @override
  bool operator ==(covariant CustomProgress other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end && other.color == color;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ color.hashCode;
}
