import 'dart:async';

class Throttler {
  factory Throttler() => _sharedInstance;
  factory Throttler.privateInstance() => Throttler._internal();
  static final _sharedInstance = Throttler._internal();
  Throttler._internal();

  // when called multiple times before timeout,
  // only the last call executes
  Timer? _timer;
  void throttle(Duration timeout, void Function() callback) {
    _timer?.cancel();
    _timer = Timer(timeout, callback);
  }

  void cancel() => _timer?.cancel();
}
