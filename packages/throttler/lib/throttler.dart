library throttler;

import 'dart:async';

import 'package:flutter/foundation.dart';

/// A class that throttles the execution of a callback function.
///
/// This class takes in an optional [CallbackRateLimit] object and instantiates
/// a [_CallbackLimitManager] object if this argument is provided. The [throttle]
/// method uses the [shouldExecuteCallback] method of the [_CallbackLimitManager]
/// object to determine whether or not to execute the callback. If no rate limit
/// is provided, the [throttle] method will only execute the last call to the
/// callback before the specified timeout.
class Throttler {
  factory Throttler({CallbackRateLimit? rateLimit}) =>
      Throttler._internal(rateLimit: rateLimit);
  factory Throttler.privateInstance({CallbackRateLimit? rateLimit}) =>
      Throttler._internal(rateLimit: rateLimit);
  Throttler._internal({CallbackRateLimit? rateLimit})
      : _limitManager = rateLimit != null
            ? _CallbackLimitManager(rateLimit: rateLimit)
            : null;

  final _CallbackLimitManager? _limitManager;

  // when called multiple times before timeout,
  // only the last call executes
  Timer? _timer;
  void throttle(Duration timeout, void Function() callback) {
    _timer?.cancel();
    if (_limitManager?.shouldExecuteCallback() != false) {
      _timer = Timer(timeout, callback);
    }
  }

  void cancel() => _timer?.cancel();
}

/// A class that limits the rate at which a callback function is executed.
///
/// This class takes in a [CallbackRateLimit] object that specifies the maximum
/// number of times a callback can be executed within a certain duration. The
/// [shouldExecuteCallback] method returns a boolean indicating whether or not
/// a callback should be executed based on the specified rate limit.
class _CallbackLimitManager {
  final CallbackRateLimit rateLimit;
  int _count = 0;
  Timer? _timer;

  _CallbackLimitManager({required this.rateLimit});

  bool shouldExecuteCallback() {
    _count++;
    _timer ??= Timer(rateLimit.duration, () {
      _count = 0;
      _timer = null;
    });
    if (_count <= rateLimit.maxCount + 1) {
      return true;
    } else {
      _timer?.cancel();
      _timer = Timer(rateLimit.duration, () {
        _count = 0;
        _timer = null;
      });
      return false;
    }
  }
}

/// A data class that specifies the maximum number of times a callback can be
/// executed within a certain duration.
@immutable
class CallbackRateLimit {
  final int maxCount;
  final Duration duration;

  const CallbackRateLimit({required this.maxCount, required this.duration});
}
