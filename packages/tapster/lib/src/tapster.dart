import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:throttler/throttler.dart';
import 'tap_priority.dart';
part 'taps_resolver.dart';
part 'tap_type.dart';

class Tapster extends StatefulWidget {
  const Tapster({
    super.key,
    required this.child,
    this.tapPriority,
    this.onTapOutside,
    this.onTapInside,
  });
  final Widget child;
  final TapPriority? tapPriority;
  final VoidCallback? onTapOutside;
  final VoidCallback? onTapInside;

  @override
  State<Tapster> createState() => _TapsterState();
}

class _TapsterState extends State<Tapster> with TapsResolver {
  @override
  void initState() {
    if (widget.tapPriority != null)
      initialize(tapPriority: widget.tapPriority!);
    super.initState();
  }

  late final _throttler = Throttler.privateInstance();
  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (_) => log("1"),
      onTapOutside: (_) => log("2"),
      child: widget.child,
    );
  }

  @override
  void tapInside() => widget.onTapInside?.call();

  @override
  void tapOutside() => widget.onTapOutside?.call();
}
